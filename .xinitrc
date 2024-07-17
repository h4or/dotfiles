#exec startplasma-x11
#xrandr --output HDMI-1 --mode 1920x1080 --rate 75 --output DVI-D-1 --mode 1920x1080 --rate 60 --right-of HDMI-1 &
echo "1" > ~/.local/scripts/display_switch_config.txt &
~/.local/scripts/display-switch &
dunst &
clipmenud &
picom &
slstatus &
~/.fehbg &
exec dwm
