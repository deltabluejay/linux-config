#!/bin/bash
# .bashrc - runs in every interactive non-login shell

# Pyenv
# My attempt to fix Python in distrobox, only kinda works
if [[ "$(hostname)" == "framework" ]]; then
    eval "$(pyenv init -)"
fi

# Default Editor
#export TERM=xterm-kitty
force_color_prompt=yes

# Stop GDB debug crap
unset DEBUGINFOD_URLS

# Custom prompt
PS1='╭(\[\e[94m\]\u\[\e[0m\]@\[\e[91m\]\h\[\e[0m\])-(\[\e[92m\]\w\[\e[0m\])\n╰─> '

# Aliases
alias dockerstart="sudo systemctl start docker"
#alias gdb="gdb --args env LC_CTYPE=C.UTF-8"
#if [[ "$(hostname)" == "framework" ]]; then
    #alias ssh="kitten ssh"
    #alias nssh="ssh"
#fi
alias db="distrobox"
alias ctf="pyenv activate ctf"
alias ice="pyenv activate ice"
alias medic="pyenv activate medic"

# Justin's CTF docker container
# mostly made obsolete by distrobox now
# usage: dockershell <image>[:tag]
# examples: 
#   dockershell ubuntu:22.04
#   dockershell python:3.8
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"
function dockershellhere() {
    dirname=${PWD##_/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##_/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}