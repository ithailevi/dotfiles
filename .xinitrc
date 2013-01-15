[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:scroll us,il
xmodmap ~/.xmodmap
bash ~/bin/status2.sh &
exec dwm
