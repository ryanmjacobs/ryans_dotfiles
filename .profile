################################################################################
# .profile
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
# May 18, 2014 -> File creation.
################################################################################

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set $PATH
bin_path="$HOME/.bin:$HOME/.bin/rbin:$HOME/.local/bin"
builds_path="$HOME/builds/usr/bin"
npm_path="$(npm config get prefix 2>/dev/null)/bin"
ruby_path="$(ruby -r rubygems -e "puts Gem.user_dir" 2>/dev/null)/bin"
cabal_path="$HOME/.cabal/bin"
vivado_path="/opt/Xilinx/Vivado/2018.3/bin"
export GOPATH="$HOME/go"
go_path="$GOPATH/bin"
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

PATH="$bin_path:$builds_path:$PATH:$npm_path:$ruby_path:$cabal_path:$go_path:$vivado_path"
LD_LIBRARY_PATH="$HOME/builds/usr/lib:$LD_LIBRARY_PATH:$vivado_path/../lib/lnx64.o"

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PATH="$HOME/.cargo/bin:$PATH"
