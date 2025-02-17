#!/bin/sh
. /lib/functions.sh
config_load misc

restore6855Esw()
{
	echo "restore GSW to dump switch mode"
	#port matrix mode
	switch reg w 2004 ff0000 #port0
	switch reg w 2104 ff0000 #port1
	switch reg w 2204 ff0000 #port2
	switch reg w 2304 ff0000 #port3
	switch reg w 2404 ff0000 #port4
	switch reg w 2504 ff0000 #port5
	switch reg w 2604 ff0000 #port6
	switch reg w 2704 ff0000 #port7

	#LAN/WAN ports as transparent mode
	switch reg w 2010 810000c0 #port0
	switch reg w 2110 810000c0 #port1
	switch reg w 2210 810000c0 #port2
	switch reg w 2310 810000c0 #port3
	switch reg w 2410 810000c0 #port4
	switch reg w 2510 810000c0 #port5
	switch reg w 2610 810000c0 #port6
	switch reg w 2710 810000c0 #port7

	#clear mac table if vlan configuration changed
	switch clear
}

config6855Esw()
{
	#LAN/WAN ports as security mode
	switch reg w 2004 ff0003 #port0
	switch reg w 2104 ff0003 #port1
	switch reg w 2204 ff0003 #port2
	switch reg w 2304 ff0003 #port3
	switch reg w 2404 ff0003 #port4
	switch reg w 2504 ff0003 #port5
	#LAN/WAN ports as transparent port
	switch reg w 2010 810000c0 #port0
	switch reg w 2110 810000c0 #port1
	switch reg w 2210 810000c0 #port2
	switch reg w 2310 810000c0 #port3
	switch reg w 2410 810000c0 #port4
	switch reg w 2510 810000c0 #port5
	#set CPU/P7 port as user port
	switch reg w 2610 81000000 #port6
	switch reg w 2710 81000000 #port7

    hwnat_on=`lsmod |grep hw_nat 2>/dev/null`
    if [ -z "$hwnat_on" ];
    then
	    switch reg w 2604 20ff0003 #port6, Egress VLAN Tag Attribution=tagged
	    switch reg w 2704 20ff0003 #port7, Egress VLAN Tag Attribution=tagged
    else
        #enable hwnat packet forward
	    switch reg w 2604 20c00001
	    switch reg w 2704 20c00001
    fi

	if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
	    echo "Special Tag Enabled"
		switch reg w 2610 81000020 #port6

	else
	    echo "Special Tag Disabled"
		switch reg w 2610 81000000 #port6
	fi

	if [ "$1" = "LLLLW" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
		#set PVID
		switch reg w 2014 10007 #port0
		switch reg w 2114 10007 #port1
		switch reg w 2214 10007 #port2
		switch reg w 2314 10007 #port3
		switch reg w 2414 10008 #port4
		switch reg w 2514 10007 #port5
		#VLAN member port
		switch vlan set 0 1 10000011
		switch vlan set 1 2 01000011
		switch vlan set 2 3 00100011
		switch vlan set 3 4 00010011
		switch vlan set 4 5 00001011
		switch vlan set 5 6 00000111
		switch vlan set 6 7 11110111
		switch vlan set 7 8 00001011
		else
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10002 #port4
		switch reg w 2514 10001 #port5
		#VLAN member port
		switch vlan set 0 1 11110111
		switch vlan set 1 2 00001011
		fi
	elif [ "$1" = "WLLLL" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
		#set PVID
		switch reg w 2014 10008 #port0
		switch reg w 2114 10007 #port1
		switch reg w 2214 10007 #port2
		switch reg w 2314 10007 #port3
		switch reg w 2414 10007 #port4
		switch reg w 2514 10007 #port5
		#VLAN member port
		switch vlan set 4 5 10000011
		switch vlan set 0 1 01000011
		switch vlan set 1 2 00100011
		switch vlan set 2 3 00010011
		switch vlan set 3 4 00001011
		switch vlan set 5 6 00000111
		switch vlan set 6 7 01111111
		switch vlan set 7 8 10000011
		else
		#set PVID
		switch reg w 2014 10002 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10001 #port5
		#VLAN member port
		switch vlan set 0 1 01111111
		switch vlan set 1 2 10000011
		fi
	elif [ "$1" = "W1234" ]; then
		echo "W1234"
		#set PVID
		switch reg w 2014 10005 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10002 #port2
		switch reg w 2314 10003 #port3
		switch reg w 2414 10004 #port4
		switch reg w 2514 10006 #port5
		#VLAN member port
		switch vlan set 4 5 10000011
		switch vlan set 0 1 01000011
		switch vlan set 1 2 00100011
		switch vlan set 2 3 00010011
		switch vlan set 3 4 00001011
		switch vlan set 5 6 00000111
	elif [ "$1" = "12345" ]; then
		echo "12345"
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10002 #port1
		switch reg w 2214 10003 #port2
		switch reg w 2314 10004 #port3
		switch reg w 2414 10005 #port4
		switch reg w 2514 10006 #port5
		#VLAN member port
		switch vlan set 0 1 10000011
		switch vlan set 1 2 01000011
		switch vlan set 2 3 00100011
		switch vlan set 3 4 00010011
		switch vlan set 4 5 00001011
		switch vlan set 5 6 00000111
	elif [ "$1" = "GW" ]; then
		echo "GW"
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10002 #port5
		#VLAN member port
		switch vlan set 0 1 11111011
		switch vlan set 1 2 00000111
	elif [ "$1" = "IPTV" ]; then
		echo "switch setup for IPTV"
                #iptv_pvid="$(uci get network.iptv.vlan_pvid 2>/dev/null)"
                #wan_pvid="$(uci get network.wan.vlan_pvid 2>/dev/null)"
                logger -t "switch" "iptv pvid: $iptv_pvid"
                logger -t "switch" "wan pvid: $wan_pvid"

		# change from mode LLLLW
		#set PVID
		#switch reg w <port-reg> <PVID, 10003 for pvid 3>
		switch reg w 2014 10001 #port0,
		switch reg w 2114 10003 #port1 iptv port, vlan 5, port near usb port
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10002 #port4, wan port, port near DC
		switch reg w 2514 10001 #port5, cpu port

		#VLAN member port
		#11111111 =>
		#port near usb => port near DC
		switch vlan set 0 1 10110111 #lan port, vlan 1
		switch vlan set 1 2 00001011 #wan port, vlan 2, port near DC
		switch vlan set 2 3 01000011 #iptv port, vlan 3, second port near usb port
		#switch vlan dump
	fi

	#clear mac table if vlan configuration changed
	switch clear
}

# work for 7620a and 7621
setup_switch()
{
	mode=`nvram get mode`
	echo "setup switch for mode $mode"
        iptv_interface="$(uci get network.iptv.ifname 2>/dev/null)"

	if [ "$mode" = "AP" ]; then
		restore6855Esw
	elif [ "$iptv_interface" = 'eth0.3' ]; then
		#DLLLW
		config6855Esw IPTV
	else
		# 4 lan port + 1 wan port
		model=`nvram get model`
		model=${model:-`cat /proc/xiaoqiang/model`}
        config_get wan_port sw_reg sw_wan_port
        config_get lan_ports sw_reg sw_lan_ports
        echo "WAN port $wan_port"
        echo "LAN port $lan_ports"
        if [ "$wan_port" = "4" ]; then
            echo "Set to LLLLW"
            config6855Esw LLLLW
        elif [ "$wan_port" = "0" ]; then
            echo "Set to WLLLL"
            config6855Esw WLLLL
        else
            echo "Please set sw_wan_port in misc file."
            echo "Default to LLLLW"
            config6855Esw LLLLW
        fi

		case $model in
			"R3" )
			# switch patch from MTK
			killall smart_speed &> /dev/null
			smart_speed eth0&
				;;
			* )
			echo "We can add additional switch port configuration here."
				;;
		esac
	fi
}
