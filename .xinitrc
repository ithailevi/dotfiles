[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xmodmap ~/.xmodmap
exec dwm
