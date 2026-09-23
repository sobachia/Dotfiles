#!/usr/bin/env bash
# bootstrap.sh - restore dotfiles on fresh Omarchy (Arch) install
# usage: ./bootstrap.sh [--no-packages]
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

PM="pacman"
if ! command -v pacman &>/dev/null; then
  echo "NOTE: pacman not found (you are on Ubuntu?). Only stow dry-run will work."
  echo "On Omarchy run this again - it will install packages via pacman."
  PM="apt"
fi

if [[ "${1:-}" != "--no-packages" && "$PM" == "pacman" ]]; then
  echo "=== Installing packages ==="
  sudo pacman -Syu --needed \
    stow git zsh neovim tmux fzf fd bat eza zoxide ripgrep \
    github-cli lazygit wl-clipboard python python-pip nodejs npm \
    base-devel g++ gdb python-virtualenv unzip curl wget tree-sitter-cli
  # AUR (Omarchy has yay/paru): fonts + tpm deps
  if command -v yay &>/dev/null; then
    yay -S --needed ttf-jetbrains-mono-nerd tpm 2>/dev/null || true
  fi
  # cargo tool from packages/cargo.txt
  if ! command -v tldr &>/dev/null; then cargo install tlrc 2>/dev/null || true; fi
fi

echo "=== Stowing dotfiles -> \$HOME ==="
command -v stow >/dev/null || { echo "install stow first"; exit 1; }
stow -v -R -t "$HOME" zsh bash git tmux nvim config

echo "=== oh-my-zsh + theme/plugins (if missing) ==="
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

echo "=== tmux plugins via TPM ==="
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
# pin to known-good commits from packages/tmux-plugins.txt if present
# (uncomment to enforce exact versions)
# while read -r name sha _; do git -C "$HOME/.tmux/plugins/$name" checkout "$sha" 2>/dev/null || true; done < "$DOTFILES/packages/tmux-plugins.txt"

echo "=== neovim lazy restore ==="
nvim --headless "+Lazy! sync" +qa || true

echo "=== done ==="
echo "Next: chsh -s \$(which zsh), restart shell, run 'p10k configure' if prompt looks off."
echo "Omarchy: Setup > Defaults > Editor = nvim. Theme via Super+Space > Theme."
