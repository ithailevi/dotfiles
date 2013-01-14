export http_proxy=
# git clone https://github.com/L3V3L9/dotfiles.git
# core
sudo http_proxy= pacman -S tmux xorg-server xorg-xinit xorg-server-utils dwm xterm zsh rxvt-unicode dmenu 
# apps
sudo http_proxy= pacman -S chromium mutt ranger openssh cmus cifs-utils alsa-utils unzip mplayer axel htop youtube-viewer cmatrix newsbeuter ntfs-3g wget
# dev
sudo http_proxy= pacman -S git gcc make patch gvim valgrind gdb nodejs 
#
#pacman -S xf86-video-ati
#pacman -S xf86-video-vesa
cd ~
ln -s ./dotfiles/.dircolors .dircolors
ln -s ./dotfiles/.fonts .fonts
ln -s ./dotfiles/.gitconfig .gitconfig
ln -s ./dotfiles/.githelpers .githelpers
ln -s ./dotfiles/.muttrc.colors .muttrc.colors 
ln -s ./dotfiles/.muttrc.core .muttrc.core 
ln -s ./dotfiles/.muttrc.gmail .muttrc.gmail 
ln -s ./dotfiles/.tmux.conf .tmux.conf 
ln -s ./dotfiles/.xinitrc .xinitrc 
ln -s ./dotfiles/.xmodmap .xmodmap 
ln -s ./dotfiles/.Xresources .Xresources 
ln -s ./dotfiles/.Xresources.colors .Xresources.colors 
ln -s ./dotfiles/.vim .vim
ln -s ./dotfiles/.vimrc .vimrc
#
mkdir dwm
cd dwm 
wget http://dl.suckless.org/dwm/dwm-6.0.tar.gz
tar xvf dwm-6.0.tar.gz
cd dwm-6.0
git clone https://github.com/L3V3L9/dwm6-patchwork.git
patch config.mk dwm6-patchwork/00-dwm-6.0-buildflags.diff 
patch dwm.c dwm6-patchwork/01-dwm-6.0-xft.diff
patch dwm.c dwm6-patchwork/02-dwm-6.0-pertag2.diff
patch dwm.c dwm6-patchwork/03-dwm-6.0-uselessgaps.diff
patch dwm.c dwm6-patchwork/04-dwm-6.0-systray.diff
patch dwm.c dwm6-patchwork/05-dwm-6.0-statuscolors.diff
patch dwm.c dwm6-patchwork/06-dwm-6.0-occupiedcol.diff
patch dwm.c dwm6-patchwork/07-dwm-6.0-monocle_fixes.diff
patch dwm.c dwm6-patchwork/08-dwm-6.0-statusallmons.diff
patch dwm.c dwm6-patchwork/09-dwm-6.0-attachaside.diff
patch dwm.c dwm6-patchwork/10-dwm-6.0-no_title.diff
patch dwm.c dwm6-patchwork/11-dwm-6.0-remove_unfunc.diff
patch dwm.c dwm6-patchwork/12-dwm-6.0-XKeycodeToKeysym_fix.diff
cp dwm6-patchwork/config.h .
make
sudo make install
#
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fc-cache -f
sudo locale-gen
