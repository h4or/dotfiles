#!/bin/sh

xrdb merge ~/.Xresources &
feh --bg-fill ~/.config/h4orwm/pictures/night-road.jpg &
xset r rate 200 50 &
xset m 4 1 &
xset dpms 600 900 1200 &
picom &
dunst &
slstatus &

while type dwm >/dev/null; do dwm && continue || break; done
