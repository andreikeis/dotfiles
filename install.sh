#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# -h: if the destination is already a symlink (e.g. to a directory, like
# ~/.vim), replace it in place rather than following it and creating a
# broken/self-referential link inside the target directory.
for f in $(ls $DIR/dotfiles); do
  if [ $f == "." ]; then continue; fi
  if [ $f == ".." ]; then continue; fi
  if [ $f == "config" ]; then continue; fi

  ln -s -f -h $DIR/dotfiles/$f ~/.$f
done

# XDG config files -> ~/.config/<name>
if [ -d "$DIR/dotfiles/config" ]; then
  mkdir -p ~/.config
  for f in $(ls $DIR/dotfiles/config); do
    ln -s -f -h $DIR/dotfiles/config/$f ~/.config/$f
  done
fi
