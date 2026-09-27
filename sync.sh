#!/bin/bash
# Bring this machine in line with the repo: pull, re-link dotfiles, and update
# the nix profile from flake.nix when the package set changed since last sync.
#
#   sync.sh          full sync (pull + link + nix if changed)
#   sync.sh --quick  same, but a failed/slow pull is just a warning - used on
#                    connect to a dev box, where it must never block the login
#
# Never exits non-zero in --quick mode.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
QUICK=0; [ "${1:-}" = "--quick" ] && QUICK=1
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
STAMP="$STATE/flake.stamp"
ENTRY=dotfiles   # nix profile entry name (from the repo dir name)

warn() { printf '\033[33mdotsync:\033[0m %s\n' "$*" >&2; }
fail() { warn "$*"; [ $QUICK = 1 ] && exit 0; exit 1; }

# --- 1. pull (bounded: a hung network must not hold up a login) ---
if [ -z "$(git -C "$DIR" status --porcelain --untracked-files=no)" ]; then
  if command -v timeout >/dev/null; then t="timeout 10"; else t=""; fi
  $t git -C "$DIR" pull --ff-only -q 2>/dev/null || warn "git pull failed/timed out - using local copy"
else
  warn "local changes in $DIR - skipping pull"
fi

# --- 2. symlinks ---
"$DIR/install.sh" || fail "install.sh failed"

# --- 3. nix profile, only if the package set changed ---
command -v nix >/dev/null || fail "nix not on PATH - skipping packages"
want=$(cat "$DIR/flake.nix" "$DIR/flake.lock" | cksum)
[ "$want" = "$(cat "$STAMP" 2>/dev/null)" ] && exit 0

echo "dotsync: package set changed - updating nix profile..."
if nix profile list --json 2>/dev/null | grep -q "\"$ENTRY\":"; then
  nix profile upgrade "$ENTRY" || fail "nix profile upgrade failed"
else
  # Priority 4 (default is 5) makes this set win over any package also
  # installed ad hoc, instead of failing on the file conflict.
  nix profile install --priority 4 "$DIR" || fail "nix profile install failed"
fi
mkdir -p "$STATE" && echo "$want" > "$STAMP"
# Re-run so copied .app bundles (macOS) pick up the upgraded packages.
"$DIR/install.sh" || warn "install.sh failed after profile update"
echo "dotsync: done"
