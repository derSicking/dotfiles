# AGENTS.md — `.dotfiles`

## Setup

Clone to `$HOME/.dotfiles/`, then run `./install` from the repo root.

## How `install` works

Finds and executes **all** scripts named either `dotfile_setup` or `dotfile_link` (in that order) in any subdirectory:

- **`dotfile_setup`** — one-time setup (e.g. cloning nvm, tpm). Runs first.
- **`dotfile_link`** — creates symlinks from the repo subtree to the corresponding `$HOME` location. The script removes itself from the target after linking.

Symlink targets by directory:

| Repo dir | Links to |
|---|---|
| `home/` | `$HOME/` (all files, including dotfiles) |
| `config/` | `$HOME/.config/` (each subdirectory, e.g. nvim, i3) |
| `local-bin/` | `$HOME/.local/bin/` |
| `desktopfiles/` | `$HOME/.local/share/applications/desktopfiles` |

## Prerequisites

Packages listed in `stuff-to-install.md` must be installed **before** running `install`. This includes shell, display server, audio, network, tools (tmux, neovim, fzf, docker, etc.), and AUR packages.

## Ignores (`.gitignore`)

- `config/nvim/plugin` — managed by Neovim plugin manager
- `config/tmux/plugins` — managed by TPM

## Config linking quirks

- `config/dotfile_link` skips subdirectories already present in `~/.config/` (so apps that manage their own runtime data, like opencode, are never overwritten).
- `config/opencode/dotfile_setup` symlinks individual files (not the whole subdirectory) because OpenCode manages its own plugins/agents/themes there.

## Special files at repo root

- `caps2esc.yaml` — `interception-tools` config; linked to `/etc/interception/udevmon.d/` (needs root).
- `usde` — custom XKB symbols file (US layout + German umlauts); linked to `/usr/share/X11/xkb/symbols/` (needs root).

## Commit style

`type: short description` (e.g. `fix:`, `add:`, `chore:`).

## Notes

- `oh-my-zsh/` has a `dotfile_setup` (manages its own install), not a `dotfile_link`.
- `home/.zshrc` uses `powerlevel10k` theme and a custom oh-my-zsh plugin `frederik`.
- No build, test, lint, or typecheck tooling in this repo.
