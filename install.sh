#!/bin/sh



if [ -d ~/.config/rofi ]; then
  mv -v ~/.config/rofi ~/.config/rofi-old
fi

if [ -d ~/.config/xmonad ]; then
  mv -v ~/.config/xmonad ~/.config/xmonad-old
fi

if [ -d ~/.config/dunst ]; then
  mv -v ~/.config/dunst ~/.config/dunst-old
fi

if [ -f ~/.Xresources ]; then
  mv -v ~/.Xresources ~/.Xresources.old
fi

if [ -f ~/.xmobarrc ]; then
  mv -v ~/.xmobarrc ~/.xmobarrc.old
fi

cp -rv ./config/* ~/.config
cp -v .Xresources ~/
cp -v .xmobarrc ~/
