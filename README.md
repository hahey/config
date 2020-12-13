# An automatic environment setting script with dotfiles

The goal of this scripts is to setup my personal setting for a new laptop or a desktop as automatically as possible after install debian after formatting. The current version is more optimized for debian-bullseye - for example you need to twick `/etc/apt/source.list` for the packages like `polybar`.

### Customization

- `apt.list` contains the list of package names that you prefer and want to install.
The files that ends with `*.deb` will be downloaded while running the script.
- `ml_requirements.list` contains the list of python3 packages that will be installed when you run the `mkplay` command in `zsh`. The `mkplay` command is for creating one time use virtual environment for testing Jupyter notebook or some data science prototype. Similarly for `dl_requirements.list` as well. The command `ml_venv3` and `dl_venv3` will generate python3 virtual environments with packages listed in `ml_requirements.list` and both `ml_requirements.list` and `dl_requirements.list` respectively.
- This repository also contains my customized dotfiles for vim (neovim), conky, zsh, konsole (yakuake), i3 window manager, polybar, and autokey. You can switch those files with yours.

### Running the script

```

at your home directory:

$ git clone https://github.com/hahey/config.git

$ cd config
$ ./setup-config.sh
```

### Post Configuration

This is a self-reminder note: I usually do the following configuration afterwards manually.

* Korean, German setting
   - `ibus-setup`
       - `Input Method` -> add `Korean - Hangul`
       - `Keyboard Shortcuts` -> `Next input method`
   - `Keyboard settings`
       - `Layout` -> `Change layout option`, add `Keyboard layout`
* browser cookie exception, cookie auto clean
   - airtable, pocket, boostnote, dropbox login
* startup applications
   - conky, yakuake, autokey
