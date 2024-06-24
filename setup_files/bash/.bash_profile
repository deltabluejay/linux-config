#!/bin/bash
# .bash_profile - runs once upon login

# PATH
#if [[ "$(hostname)" == "framework" ]]; then
export PATH="\
$PATH:\
$HOME/.local/bin/:\
$HOME/Applications/:\
$HOME/.local/share/gem/ruby/3.2.0/bin:\
$HOME/.rbenv/versions/3.1.4/bin:\
$HOME/.local/share/gem/ruby/3.1.0/bin:\
$HOME/.cargo/bin:\
$HOME/Applications/IntelliJ/bin:\
$HOME/.pyenv/bin:\
$HOME/.pwndbg/bin"
#fi
export LC_CTYPE=C.UTF-8

# Default Editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"

# Ruby env (rbenv)
if [[ "$(hostname)" == "framework" ]]; then
    eval "$(rbenv init - bash)"
fi

# Pywal
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors-tty.sh

# Kitty
export KITTY_CONFIG_DIRECTORY="$HOME/Linux-Config/dots/kitty"
#export TERM=xterm-kitty

# Ruby gem
#export PATH="$PATH:$HOME/.rbenv/versions/3.1.4/bin"
#export PATH="$PATH:$HOME/.local/share/gem/ruby/3.1.0/bin"

# Cargo
. "$HOME/.cargo/env"

# IntelliJ
#export PATH="$PATH:$HOME/Applications/IntelliJ/bin"
