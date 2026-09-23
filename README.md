# dotfiles (private) - Ubuntu -> Omarchy

Stow-based backup. Restores shell, editor, tmux, git, and tool settings on a fresh Omarchy install.

## Layout (each dir is a stow package, mirrors `$HOME`)

* `zsh/` -> `~/.zshrc`, `~/.p10k.zsh`, `~/.zshenv`, `~/.profile`
* `bash/` -> `~/.bashrc`
* `git/` -> `~/.gitconfig`
* `tmux/` -> `~/.tmux.conf` (plugins NOT versioned, reinstall via TPM)
* `nvim/` -> `~/.config/nvim/` (LazyVim, `lazy-lock.json` pins exact commits)
* `config/` -> `~/.config/lazygit/`, `~/.config/opencode/`, `~/.config/uv/`
* `packages/` -> apt/cargo/npm/uv lists + tmux SHAs (meta, not stowed)
* `omarchy/` -> placeholder for future `~/.config/hypr`, `omarchy`, `waybar`, `foot`

## Fresh Omarchy restore

```bash
sudo pacman -Syu git stow
git clone <this-private-repo> ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
chsh -s $(which zsh)
```

What bootstrap does: pacman installs, `stow -R -t ~`, clones oh-my-zsh + powerlevel10k + zsh-autosuggestions if missing, `tpm/bin/install_plugins`, `nvim --headless Lazy sync`.

## Notes

* Secrets excluded via `.gitignore`: `.git-credentials`, history, cache, `node_modules`, `.tmux/plugins`, zoxide db. Never `git add -f` those.
* Ubuntu -> Arch renames: `batcat->bat`, `fdfind->fd` (symlinks in `~/.local/bin` intentionally NOT backed up).
* Exercism + Obsidian CLI intentionally excluded from this backup.
* `nvim` is exact: `lazy-lock.json` restores same plugin commits; Mason LSPs/treesitters re-download on first open.
* Omarchy owns `/usr/share/omarchy`; your overrides live in `~/.config` (hypr, omarchy/shell.json, foot). Add them here later with `stow`.
