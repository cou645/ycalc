#!/bin/sh
# Super Simple Calculator by stemsee
# Copyright (C) 2025 stemsee
#
if [[ $(id -u) -ne 0 ]]; then
	[[ "$DISPLAY" ]] && exec gtksu "xsr.sh" "$0" "$@" || exec su -c "$0 $*"
fi

[ -f /tmp/test ] && rm -f /tmp/test
export var="$$"
[[ ! -p /tmp/calc-"$var" ]] && mkfifo /tmp/calc-"$var"
exec 3<>/tmp/calc-"$var"

function calfn {
case "$1" in
	MM) IFS=' ' read -r MIIII MIII MII MI<<<"$(tail -n 4 /root/.ycalc.history | cut -f2 -d'=' | tr '\n' ' ')"
		echo "$MI" > /tmp/MI;echo "$MII" > /tmp/MII;echo "$MIII" > /tmp/MIII;echo "$MIIII" > /tmp/MIIII;;
   MI*) calfn "$(cat /tmp/$1)";;
   clr) rm -f /tmp/test
   		echo -e '\f' >/tmp/calc-"$var"
		exit;;
	bs) sed -E -i -e 's/[0-9+-=/b* %#expsqrtcoanilg^.)(]{1,2}$//g' /tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		sum=$(cat /tmp/test)
		printf "%s\n" "$sum = $string" >/tmp/calc-"$var"
		exit;;
	=)	sum=$(cat /tmp/test | sed -E -e 's| ||g' -e 's|(sqrt){1}([0-9.]+)|\1(\2)|g' -e 's|([csal]){1}([0-9.]+)|\1(\2)|g')
		if [[ ! -z $(echo $sum | grep -e '%') ]]; then
			if [[ ! -z $(echo $sum | grep -E -e "[sqrtcsal\(\)]") ]]; then
				echo -e "Calculate Modulo in isolation first then use 'M+'.\nbc calculates modulo with zero decimal places.\nsine cos atan log will be inaccurate." | yad --text-info --no-buttons --timeout=4 --center --width=610 --height=120 --fontname="sans 18" --fore=red --back=yellow
			fi
		string=$(echo "scale=0;$sum" | bc -l)
		else
		string=$(echo "scale=11;$sum" | bc -l)
		fi
		export string=$(echo "$string" | sed -E -e '/^[.]{1}/s|^|0|g' -e '/^[-]{1}[!.]/s|-|-0|g' -e '/^[-]{1}[.]{1}/s/^[-]{1}[.]{1}/\-0\./g')
		echo -e '\f' >/tmp/calc-"$var"
		printf "%s\n" "$sum = $string" | tee -a /root/.ycalc.history >/tmp/calc-"$var"
		;;
	*)
		echo -ne "$1 " | tr '#' '%' >>/tmp/test
		echo -e '\f' >/tmp/calc-"$var"
		string=$(cat /tmp/test)
		printf "%s\n" "$string =" >/tmp/calc-"$var"
		exit;;
esac
};export -f calfn
calfn MM

yad --plug=$$ --tabnum=1 --text-info --fontname="sans bold 24" --fore=lightblue --back=darkgreen --listen --wrap <&3  &
case "$1" in
simp) yad --plug=$$ --tabnum=2 --form --columns=5 --fontname="sans bold 24" \
--field='1':fbtn "bash -c 'calfn 1'" --field='4':fbtn "bash -c 'calfn 4'" --field='7':fbtn "bash -c 'calfn 7'" --field='.':fbtn "bash -c 'calfn \.'" \
--field='2':fbtn "bash -c 'calfn 2'" --field='5':fbtn "bash -c 'calfn 5'" --field='8':fbtn "bash -c 'calfn 8'" --field='0':fbtn "bash -c 'calfn 0'" \
--field='3':fbtn "bash -c 'calfn 3'" --field='6':fbtn "bash -c 'calfn 6'" --field='9':fbtn "bash -c 'calfn 9'" --field='+':fbtn "bash -c 'calfn \+'" \
--field='/':fbtn "bash -c 'calfn \/'" --field='*':fbtn "bash -c 'calfn \*'" --field='%':fbtn "bash -c 'calfn \#'" --field='-':fbtn "bash -c 'calfn -'" \
--field='Clr':fbtn "bash -c 'calfn clr'" --field='Del':fbtn "bash -c 'calfn bs'" --field="^":fbtn "bash -c 'calfn ^'" --field='=':fbtn "bash -c 'calfn ='" \
--no-buttons &;;
vance) yad --plug=$$ --tabnum=2 --form --columns=5 --fontname="sans bold 24" \
--field='1':fbtn "bash -c 'calfn 1'" --field='4':fbtn "bash -c 'calfn 4'" --field='7':fbtn "bash -c 'calfn 7'" --field='.':fbtn "bash -c 'calfn \.'" --field='cos':fbtn "bash -c 'calfn c'" --field='M1':fbtn "bash -c \"calfn MI \"" \
--field='2':fbtn "bash -c 'calfn 2'" --field='5':fbtn "bash -c 'calfn 5'" --field='8':fbtn "bash -c 'calfn 8'" --field='0':fbtn "bash -c 'calfn 0'" --field='sin':fbtn "bash -c 'calfn s'" --field='M2':fbtn "bash -c \"calfn MII \"" \
--field='3':fbtn "bash -c 'calfn 3'" --field='6':fbtn "bash -c 'calfn 6'" --field='9':fbtn "bash -c 'calfn 9'" --field='+':fbtn "bash -c 'calfn \+'" --field='atan':fbtn "bash -c 'calfn a'" --field='M3':fbtn "bash -c \"calfn MIII \"" \
--field='/':fbtn "bash -c 'calfn \/'" --field='*':fbtn "bash -c 'calfn \*'" --field='%':fbtn "bash -c 'calfn \#'" --field='-':fbtn "bash -c 'calfn -'" --field='nlog':fbtn "bash -c 'calfn l'" --field='M4':fbtn "bash -c \"calfn MIIII \"" \
--field='Clr':fbtn "bash -c 'calfn clr'" --field='Del':fbtn "bash -c 'calfn bs'" --field="^":fbtn "bash -c 'calfn ^'" --field='=':fbtn "bash -c 'calfn ='" --field='sqrt':fbtn "bash -c 'calfn sqrt'" --field='M+':fbtn "bash -c 'calfn MM'" \
--no-buttons &;;
esac
yad --title="SSC" --paned --key=$$ --tab=sum --fontname="sans bold 24" --tab=pad --splitter=-10 --orient=vert --no-buttons --geometry="338x272-93-87" &
ret=$?
wait $!

case "$ret" in
*) rm -f /tmp/calc-"$var" /tmp/test;;
esac

