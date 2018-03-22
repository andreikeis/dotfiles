#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for f in $(ls $DIR/dotfiles); do
  if [ $f == "." ]; then continue; fi
  if [ $f == ".." ]; then continue; fi

  ln -s -f $DIR/dotfiles/$f ~/.$f
done
