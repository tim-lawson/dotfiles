# dotfiles

macOS: zsh, Ghostty, yabai/skhd, Homebrew packages, beets.

```sh
git clone git@github.com:<you>/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Re-runnable, though `brew bundle` upgrades outdated packages so it isn't purely
additive. Prints the remaining manual steps at the end.

## Notes

`zshenv` is environment only, `zprofile` sets Homebrew's PATH at login, `zshrc`
is interactive-only. Volta, rustup and bun aren't installed — the shell config
just guards against their absence.

The yabai sudoers rule pins the binary's SHA, so redo it after every upgrade.
Same for Accessibility. The scripting addition also needs
`sudo nvram boot-args=-arm64e_preview_abi` and a reboot on Apple Silicon — not
set here.

## beets

One uv tool env: beets plus `beets/plugins.txt`, pinned in
`beets/constraints.txt`. Re-pin after upgrading:

```sh
uv pip freeze --python ~/.local/share/uv/tools/beets/bin/python \
  | sort > beets/constraints.txt
```

Discogs token: `~/.config/beets/secrets.yaml`, untracked, pulled in by
`config.yaml`'s `include`, seeded by `install.sh`. Keep the placeholder
non-empty or the plugin falls into OAuth and prompts on every command.

`ffmpeg` and `sox` are for `convert` (the `aiff` format uses sox) and the
`replaygain` ffmpeg backend.
