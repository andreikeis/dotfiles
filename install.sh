#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# -n: if the destination is already a symlink (e.g. to a directory, like
# ~/.vim), replace it in place rather than following it and creating a
# broken/self-referential link inside the target directory. BSD ln (macOS)
# also accepts -h for this, but GNU ln (Linux) only accepts -n/--no-dereference.
for f in $(ls $DIR/dotfiles); do
  if [ $f == "." ]; then continue; fi
  if [ $f == ".." ]; then continue; fi
  if [ $f == "config" ]; then continue; fi
  if [ $f == "claude" ]; then continue; fi

  ln -s -f -n $DIR/dotfiles/$f ~/.$f
done

# XDG config files -> ~/.config/<name>
if [ -d "$DIR/dotfiles/config" ]; then
  mkdir -p ~/.config
  for f in $(ls $DIR/dotfiles/config); do
    ln -s -f -n $DIR/dotfiles/config/$f ~/.config/$f
  done
fi

# Claude Code files -> ~/.claude/<name> (settings.json stays per-host: the
# theme differs between home and remote on purpose)
if [ -d "$DIR/dotfiles/claude" ]; then
  mkdir -p ~/.claude
  for f in $(ls $DIR/dotfiles/claude); do
    ln -s -f -n $DIR/dotfiles/claude/$f ~/.claude/$f
  done
fi
