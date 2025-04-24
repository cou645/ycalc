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
case "$1" in
	bs) sed -E -i -e 's/[0-9+-=\bs* %#expsqrtcoanilg]{2}$//g' /tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		sum=$(cat /tmp/test)
		printf "%s\n" "$sum = $string" >/tmp/calc-"$var"
		exit;;
	sqrt|c|s|a|l) num=$(cat /tmp/test | sed 's| ||g' | cut -f1 -d' ')
		string=$(echo "scale=7;$1($num)" | bc -l)
		string=$(echo "$string" | sed -E -e '/^[.]/s/^/0/g' -e 's/^[-]{1}./\-0\./g')
		echo -e '\f' >/tmp/calc-"$var"
		printf "%s\n" "$1($num) = $string" | tee -a /root/.ycalc.history >/tmp/calc-"$var"
		rm -f /tmp/test;;
	=)	sum=$(cat /tmp/test | sed -E -e 's| ||g')
		if [[ ! -z $(echo $sum | grep -e '%') ]]; then
		string=$(($sum))
		else
		string=$(echo "scale=7;$sum" | bc -l)
		fi
		string=$(echo "$string" | sed -E -e '/^[.]/s/^/0/g' -e 's/^[-]{1}./\-0\./g')
		echo -e '\f' >/tmp/calc-"$var"
		printf "%s\n" "$sum = $string" | tee -a /root/.ycalc.history >/tmp/calc-"$var"
		rm -f /tmp/test;;
	*)
		echo -ne "$1 " | tr '#' '%' >>/tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		string=$(cat /tmp/test)
		printf "%s\n" "$string =" >/tmp/calc-"$var"
		exit;;
esac
};export -f calfn

yad --plug=$$ --tabnum=1 --text-info --fontname="sans bold 24" --fore=lightblue --back=darkgreen --listen --wrap <&3  &
yad --plug=$$ --tabnum=2 --form --columns=5 --fontname="sans bold 24" \
--field='1':fbtn "bash -c 'calfn 1'" --field='4':fbtn "bash -c 'calfn 4'" --field='7':fbtn "bash -c 'calfn 7'" --field='00':fbtn "bash -c 'calfn 00'" --field='cos':fbtn "bash -c 'calfn c'" \
--field='2':fbtn "bash -c 'calfn 2'" --field='5':fbtn "bash -c 'calfn 5'" --field='8':fbtn "bash -c 'calfn 8'" --field='0':fbtn "bash -c 'calfn 0'" --field='sin':fbtn "bash -c 'calfn s'" \
--field='3':fbtn "bash -c 'calfn 3'" --field='6':fbtn "bash -c 'calfn 6'" --field='9':fbtn "bash -c 'calfn 9'" --field='+':fbtn "bash -c 'calfn \+'" --field='atan':fbtn "bash -c 'calfn a'" \
--field='/':fbtn "bash -c 'calfn \/'" --field='*':fbtn "bash -c 'calfn \*'" --field='%':fbtn "bash -c 'calfn \#'"  --field='-':fbtn "bash -c 'calfn -'" --field='log':fbtn "bash -c 'calfn l'" \
--field='Del':fbtn "bash -c 'calfn bs'" --field="^":fbtn "bash -c 'calfn ^'" --field='sqrt':fbtn "bash -c 'calfn sqrt'" --field='=':fbtn "bash -c 'calfn ='" --field='.':fbtn "bash -c 'calfn \.'" \
--no-buttons &
yad --title="SSC" --paned --key=$$ --tab=sum --tab=pad --splitter=-10 --orient=vert --no-buttons --geometry=338x272-93-87 &
ret=$?
wait $!

case "$ret" in
*) rm -f /tmp/calc-"$var" /tmp/test;;
esac
