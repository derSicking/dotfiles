# AGENTS.md — `.dotfiles`

Clone to `$HOME/.dotfiles/`, then run `./install` from the repo root.

## How `install` works

`install` `cd`s to the repo root, then finds and runs every script named
`dotfile_setup` (all of them first), then every script named `dotfile_link`,
anywhere in the tree:

- **`dotfile_setup`** — one-time installs (nvm, tpm, oh-my-zsh, opencode file links).
- **`dotfile_link`** — symlinks a repo subtree to its `$HOME` location, then removes the linked copy of itself.

Scripts resolve their own directory via `BASH_SOURCE`, but always invoke them
via `./install` — running one in isolation skips the setup-before-link ordering.

Symlink targets by directory:

| Repo dir | Links to |
|---|---|
| `home/` | `$HOME/` (all files, including dotfiles) |
| `config/` | `$HOME/.config/` (each subdirectory) |
| `local-bin/` | `$HOME/.local/bin/` |
| `desktopfiles/` | `$HOME/.local/share/applications/desktopfiles` |
| `darkman/` | `$HOME/.local/share/darkman` (whole dir, replaces existing) |
| `oh-my-zsh/plugins/` | `$HOME/.oh-my-zsh/custom/plugins/` |

## Prerequisites

Packages listed in `stuff-to-install.md` must be installed **before** `install`.

## Theming gotcha

`config/waybar/theme.css`, `config/sway/theme.conf`, `config/rofi/theme.rasi`
are gitignored and regenerated at runtime by darkman hooks
(`darkman/45-waybar`, `darkman/50-sway-theme`, `darkman/35-rofi`) from the
committed `theme-{light,dark}.*` variants. Edit the variants, never the
generated files. Per-window sway rules are auto-generated in
`config/sway/config.d/` by `local-bin/scripts/sway-window-rule`.

## Config linking quirks

- `config/dotfile_link` skips subdirectories already present in `~/.config/`
  (apps that manage their own runtime data, like opencode, are never overwritten).
- `config/opencode/dotfile_setup` symlinks individual files (not the whole
  subdirectory) into `~/.config/opencode/`, which opencode itself also manages.

## Special files at repo root

- `caps2esc.yaml` — `interception-tools` config; manually linked to `/etc/interception/udevmon.d/` (root).
- `usde` — custom XKB symbols file (US layout + German umlauts); manually linked to `/usr/share/X11/xkb/symbols/` (root).
- Neither has a `dotfile_link` script; linking them is a manual step.

## References & conventions

- Read `config/nvim/AGENTS.md` before touching the Neovim config (vim.pack, blink.cmp, LSP quirks).
- Snippets live in `config/nvim-snippets/` (linked via `config/`).
- Commit style: `type: short description` (`add:`, `fix:`, `update:`, `chore:`).
- No build, test, lint, or typecheck tooling in this repo.
