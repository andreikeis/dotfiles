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

# macOS: expose nix-installed .app bundles (e.g. Alacritty) in ~/Applications
# so Spotlight/Dock see a real app. These must be real copies, not symlinks:
# the Dock resolves a symlink when pinning and stores the /nix/store path,
# which breaks after the next profile upgrade + gc. The copy is refreshed
# whenever the profile's store path for the app changes (tracked in $APPSTATE).
# A same-named app in ~/Applications that we didn't create is left alone.
if [ "$(uname)" == "Darwin" ] && [ -d ~/.nix-profile/Applications ]; then
  APPSTATE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/apps"
  mkdir -p ~/Applications "$APPSTATE"
  for app in ~/.nix-profile/Applications/*.app; do
    name="$(basename "$app")"
    dst=~/Applications/"$name"
    stamp="$APPSTATE/$name"
    src="$(readlink -f "$app")"

    if [ -e "$dst" ] && [ ! -L "$dst" ] && [ ! -f "$stamp" ]; then
      echo "install.sh: $dst exists and isn't managed here - skipping" >&2
      continue
    fi
    if [ -d "$dst" ] && [ ! -L "$dst" ] && [ "$src" == "$(cat "$stamp" 2>/dev/null)" ]; then
      continue
    fi

    # Store files are read-only; make the old copy writable before removing.
    [ -L "$dst" ] || { [ -e "$dst" ] && chmod -R u+w "$dst"; }
    rm -rf "$dst"
    # -L: dereference symlinks inside the bundle so the copy has no
    # /nix/store references of its own.
    cp -R -L "$app" "$dst" && chmod -R u+w "$dst" && echo "$src" > "$stamp"
  done
fi
