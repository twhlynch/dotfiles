#!/usr/bin/env bash

if pidof hypridle; then
	killall hypridle
else
	hypridle &
	disown
fi
