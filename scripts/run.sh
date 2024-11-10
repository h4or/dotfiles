#!/bin/sh

xrdb merge ~/.Xresources
feh --bg-fill ~/.config/h4orwm/pictures/forestbg.jpg &
xset r rate 200 50 &
picom &
dunst &
slstatus &

while type dwm >/dev/null; do dwm && continue || break; done
