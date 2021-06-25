#!/bin/bash
l_volume=`amixer get Master | awk '/Limits/{ print $NF }'`
c_volume=`amixer get Master | awk -F'[ []' 'END { print $5 }'`
echo $c_volume	

rate=10 #音量变化的百分比

function ajvolume(){
	echo $c_volume
	if [ $c_volume -lt 0 ]; then
		let c_volume=0
	elif [ $c_volume -gt $l_volume ];then
		let c_volume=$l_volume
	fi
	amixer sset Master $c_volume
	xsetroot -name "IP:$(ip addr show $IPADDR| awk '/inet\s/ {print $2}')|Volume:$(amixer get Master | awk -F'[][]' 'END { print $2 }')|$(LC_ALL='C' date +'%F[%b %a] %R')"
}
if [ $1 = "+" ];then
	if [ $c_volume != $l_volume ]; then
		let c_volume+=$[l_volume*$rate/100]
		ajvolume
	fi
elif [ $1 = "-" ];then
	if [ $c_volume != 0 ]; then
		let c_volume-=$[l_volume*$rate/100]
		ajvolume
	fi
else
	echo 参数错误
fi

