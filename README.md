# An automatic environment setting script with dotfiles

### Customization

- `apt.list` contains the list of package names that you prefer and want to install.
The files that ends with `*.deb` will be downloaded while running the script.
- `ml_requirements.list` contains the list of python3 packages that will be
  installed when you run the `mkplay` command in `zsh`. The `mkplay` command is
  for creating one time use virtual environment for testing Jupyter notebook or
  some data science prototype.
- This repository also contains my customized dotfiles for vim (neovim), conky, zsh,
  konsole (yakuake). You can switch those files with yours.

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
   - yakuake, autokey
