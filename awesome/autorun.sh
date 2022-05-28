#!/usr/bin/env bash

xrandr --output HDMI-1-0 --auto --output eDP1 --left-of HDMI-1-0
setxkbmap gb
setxkbmap -option caps:escape
picom
nitrogen --restore
