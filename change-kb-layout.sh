#!/bin/bash

get_kb_layout() {
    setxkbmap -query | awk '/layout/ {print $2}'
}

set_kb_layout() {
	setxkbmap $1
}

if [ $(get_kb_layout) == "us" ]
then
	set_kb_layout es
else
	set_kb_layout us
fi
