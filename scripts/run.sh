#!/bin/sh

xrdb merge ~/.Xresources &
feh --bg-fill ~/.config/h4orwm/pictures/night-road.jpg &
xset r rate 155 70 &
xrandr --output HDMI-1 --mode 1920x1080 --rate 74.97 &
xrandr --output DVI-D-1 --mode 1920x1080 --rate 67 &
xinput set-prop "Logitech G502 HERO Gaming Mouse" "libinput Accel Speed" 0.5 &
xinput set-prop "Logitech G502 HERO Gaming Mouse" "libinput Accel Profile Enabled" 0, 1, 0 &
xset dpms 600 900 1200 &
picom &
dunst &
slstatus &

while type dwm >/dev/null; do dwm && continue || break; done
