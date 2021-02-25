#!/bin/bash

function stop_quit {
	local screen_id=$1
	local name=$2
	if [[ -z $2 ]]; then
		local name=$screen_id
	fi
	
	echo 'Stopping ${name}'
	screen -S $screen_id -p 0 -X stuff "^c
"
	sleep 2
	screen -S $screen_id -p 0 -X quit
	echo 'Stopped ${name}'
}

stop_quit dcrs 

stop_quit sdcrs

stop_quit zk Zookeeper

stop_quit broker-0

stop_quit broker-1

stop_quit broker-2