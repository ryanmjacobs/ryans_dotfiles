ryans_dotfiles
==============

A repository of Ryan's dotfiles.

Basic Install
-------------
```
git clone --recursive --depth=1 https://github.com/ryanmjacobs/ryans_dotfiles
cd ryans_dotfiles
./setup.sh
```

setup.sh options
----------------
```
Usage: ./setup.sh [options]
Installs ryans_dotfiles into your $HOME.

  --help     Display this help message.
  --basic    Install only the basics.
  --full     Install everything!
  --copy     Copy files instead of symlinking.
  --symlink  Symlink files instead of copying.
  --force    Overwrite existing files.

Default run: ./setup.sh --basic --copy

Report bugs to <ryan.mjacobs@gmail.com>.
```
