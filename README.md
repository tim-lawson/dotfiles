# dotfiles

macOS: zsh, Ghostty, yabai/skhd, Homebrew packages, beets.

```sh
git clone git@github.com:<you>/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Re-runnable. Installs Homebrew and uv if missing, applies the Brewfile, symlinks
configs, installs beets. Prints the remaining manual steps when it finishes.

## Notes

Shell config is split by when zsh reads it: `zshenv` is environment only,
`zprofile` sets Homebrew's PATH at login, `zshrc` is interactive-only.

The yabai sudoers rule pins the binary's SHA, so it needs redoing after every
yabai upgrade. Same for Accessibility — macOS keys it to the binary.

`brew bundle` upgrades outdated packages, so re-running `install.sh` isn't purely
additive.

## beets

One uv tool env: beets plus the plugins in `beets/plugins.txt`, pinned in
`beets/constraints.txt`. Re-pin after upgrading:

```sh
uv pip freeze --python ~/.local/share/uv/tools/beets/bin/python \
  | sort > beets/constraints.txt
```

The CFLAGS in `install.sh`: `aubio` is sdist-only and predates NumPy 2, so it
compiles locally and clang 16+ rejects its old ufunc signature. The mismatch is
ABI-safe. Pinning NumPy down instead doesn't work — beets needs `numpy>=2.0.2`.

`ffmpeg` is in the Brewfile for `beets-bpmanalyser`, which decodes via pydub.

Volta, rustup and bun aren't installed here — the shell config just guards
against their absence.
