# Local dotfiles.

Vim:

- https://github.com/tpope/vim-pathogen
- https://github.com/tpope/vim-sensible
- https://github.com/jlanzarotta/bufexplorer

git submodule update --init --recursive && ./install.sh

Packages (Mac and Linux dev boxes): `flake.nix` defines one nix profile entry, `dotfiles`, with the full
tool set (common + per-OS lists); `flake.lock` pins nixpkgs so both machines get the same versions.

    ./sync.sh              # pull, re-link, update the nix profile if flake.nix/flake.lock changed
    nix flake update       # bump package versions (commit the new flake.lock)

On dev boxes `sync.sh --quick` runs automatically on connect (see zshrc), before attaching to tmux.
