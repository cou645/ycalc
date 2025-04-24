#!/bin/sh
# Super Simple Calculator by stemsee
# Copyright (C) 2025 stemsee
#
if [[ $(id -u) -ne 0 ]]; then
	[[ "$DISPLAY" ]] && exec gtksu "hashtext" "$0" "$@" || exec su -c "$0 $*"
fi
[ -f /tmp/test ] && rm -f /tmp/test
export var="$$"
[ ! -p /tmp/calc-"$var" ] && mkfifo /tmp/calc-"$var"
exec 3<>/tmp/calc-"$var"

function calfn {

	if [[ "$1" == 'bs' ]]; then
		sed -E -i -e 's/[0-9+-=\bs* %#expsqrt]{2}$//g' /tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		sum=$(cat /tmp/test)
		printf "%s\n" "$sum = $string" >/tmp/calc-"$var"
		exit
	elif [[ "$1" == 'sqrt' ]]; then
		num=$(cat /tmp/test | sed 's| ||g' | cut -f1 -d's')
		string=$(echo "scale=7;sqrt($num)" | bc)
		echo -e '\f' >/tmp/calc-"$var"
		printf "%s\n" "sqrt($num)= $string" | tee -a /root/.ycalc.history >/tmp/calc-"$var"
		rm -f /tmp/test
	elif [[ "$1" == '=' ]]; then
		sum=$(cat /tmp/test | sed -E -e 's| ||g')
		if [[ ! -z $( echo "$sum" | grep -e '%') ]]; then
		string=$(($sum))
		elif [[ ! -z $( echo "$sum" | grep -e '.' -e 'sqrt' -e 'exp' -e '^') ]]; then
		string=$(echo "scale=7;$sum" | bc)
		string=$(echo "$string" | sed -E -e '/^[.]/s/^/0/g')
		fi
		echo -e '\f' >/tmp/calc-"$var"
		printf "%s\n" "$sum = $string" | tee -a /root/.ycalc.history >/tmp/calc-"$var"
		rm -f /tmp/test
	else
		echo -ne "$1 " | tr '#' '%' >>/tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		string=$(cat /tmp/test)
		printf "%s\n" "$string =" >/tmp/calc-"$var"
		exit
    fi
};export -f calfn

yad --plug=$$ --tabnum=1 --text-info --fontname="sans bold 24" --fore=lightblue --back=darkgreen --listen --wrap <&3  &
yad --plug=$$ --tabnum=2 --form --columns=5 --fontname="sans bold 24" \
--field='1':fbtn "bash -c 'calfn 1'" --field='4':fbtn "bash -c 'calfn 4'" --field='7':fbtn "bash -c 'calfn 7'" --field='.':fbtn "bash -c 'calfn \.'" \
--field='2':fbtn "bash -c 'calfn 2'" --field='5':fbtn "bash -c 'calfn 5'" --field='8':fbtn "bash -c 'calfn 8'" --field='0':fbtn "bash -c 'calfn 0'" \
--field='3':fbtn "bash -c 'calfn 3'" --field='6':fbtn "bash -c 'calfn 6'" --field='9':fbtn "bash -c 'calfn 9'" --field='+':fbtn "bash -c 'calfn \+'" \
--field='/':fbtn "bash -c 'calfn \/'" --field='*':fbtn "bash -c 'calfn \*'" --field='%':fbtn "bash -c 'calfn \#'"  --field='-':fbtn "bash -c 'calfn -'" \
--field='Del':fbtn "bash -c 'calfn bs'" --field="^":fbtn "bash -c 'calfn ^'" --field='sqrt':fbtn "bash -c 'calfn sqrt'" --field='=':fbtn "bash -c 'calfn ='" \
--no-buttons &
yad --title="SSC" --paned --key=$$ --tab=sum --tab=pad --splitter=-10 --orient=vert --no-buttons --geometry=338x272-93-87 &
ret=$?
wait $!

case "$ret" in
*) rm -f /tmp/calc-"$var" /tmp/test;;
esac

