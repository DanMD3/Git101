#!/bin/bash
# Git101 workshop setup — run: bash setup.sh
# Installs: Homebrew (if missing), git, Node LTS, VS Code. Sets git identity.
set -uo pipefail
ok(){ echo "  ✔ $1"; }
warn(){ echo "  ⚠ $1"; }
die(){ echo "  ✘ $1"; exit 1; }
[ "$(uname)" = "Darwin" ] || die "This script targets MacBooks. Windows? use setup.ps1 instead (link in the workshop email)."

# --- Homebrew (the installer needs your password, type it when asked) ---
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew already installed"
else
  echo "→ Installing Homebrew (you may be asked for your Mac password)…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || die "Homebrew install failed — ask IT"
  # make brew available in this script (Apple Silicon + Intel paths)
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
  done
  command -v brew >/dev/null 2>&1 || die "brew not found after install — reopen Terminal and run setup.sh again"
  ok "Homebrew installed"
fi

# --- git, node, VS Code ---
for pkg in git node@22 visual-studio-code; do
  if brew list --formula "$pkg" >/dev/null 2>&1 || brew list --cask "$pkg" >/dev/null 2>&1; then
    ok "$pkg already installed"
  else
    echo "→ Installing $pkg…"
    brew install "$pkg" || die "$pkg failed to install — ask IT"
    ok "$pkg installed"
  fi
done
# node@22 is keg-only: symlink so plain `node` works without touching their shell profile
brew link node@22 --force >/dev/null 2>&1 || true
# VS Code's 'code' command lives inside the app; link it like the in-app command would
if ! command -v code >/dev/null 2>&1; then
  CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  BIN_DIR="$(dirname "$(command -v brew)")"   # always writable + on PATH
  [ -x "$CODE_BIN" ] && ln -sf "$CODE_BIN" "$BIN_DIR/code" 2>/dev/null || true
fi
command -v code >/dev/null 2>&1 || warn "'code' not on PATH — open VS Code once, then Cmd+Shift+P → 'Shell Command: Install code command'"

# --- git identity (commitlint/semantic-release attribute commits to this) ---
echo
NAME="$(git config --global user.name 2>/dev/null || true)"
MAIL="$(git config --global user.email 2>/dev/null || true)"
if [ -n "$NAME" ] && [ -n "$MAIL" ]; then
  ok "git identity already set: $NAME <$MAIL>"
else
  echo "→ Setting your git identity (shown on every commit you make in the workshop)"
  read -r -p "  Full name: " NAME; [ -n "$NAME" ] || die "name required"
  read -r -p "  Email (use the one your GitHub account uses): " MAIL
  case "$MAIL" in *@*) ;; *) die "that doesn't look like an email" ;; esac
  git config --global user.name "$NAME"
  git config --global user.email "$MAIL"
  ok "git identity set: $NAME <$MAIL>"
fi

# --- final check: versions ---
echo
echo "── Versions ──────────────────────────"
git --version    | sed 's/^/  git /'    || die "git broken"
node --version   | sed 's/^/  node /'   || die "node broken — reopen Terminal and run again"
npm --version    | sed 's/^/  npm v/'   || die "npm broken"
command -v code >/dev/null && ok "code command works" || true
echo
echo "✔ Done. Still on you (browser, can't be scripted):"
echo "   1. GitHub account  →  https://github.com/join"
echo "   2. Fork the repo   →  https://github.com/iman-izzat/Git101 → Fork → Create fork"
echo "   3. On YOUR fork: Settings → Actions → General →"
echo "        • Allow all actions  •  Workflow permissions: Read and write"
echo "   4. Clone once so the repo is ready (Terminal):"
echo "        git clone https://github.com/YOUR-USERNAME/Git101.git"
echo "        cd Git101 && npm ci"
echo "   5. In-house AI tool → ask IT for the installer"
