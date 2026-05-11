# Wal
#wal -R
#cat $HOME/.cache/wal/sequences
source ~/.cache/wal/colors.fish

# Init pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin

# Aliases
abbr --add db distrobox
abbr --add venv pyenv activate
abbr --add dc docker compose
abbr --add dcrdp xfreerdp /u:BYUCCDC\\\\deltabluejay /v:192.168.4.60 /dynamic-resolution /scale-desktop:172 /scale-device:100
alias pwninit="pwninit --template-path ~/.config/solve.py"

# Variables
set -x TERM xterm-256color # for kitty terminal
set -x BN_USER_DIRECTORY "~/.config/binaryninja/"
set -x POWERSHELL_TELEMETRY_OPTOUT 1

# Add paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications/
fish_add_path $HOME/.gem/bin/
fish_add_path $HOME/Applications/codeql/

# Pyenv
if type -q pyenv
    pyenv init - fish | source
end

# Rbenv
if type -q rbenv
    set -x GEM_HOME $HOME/.gem
    status --is-interactive; and rbenv init - --no-rehash fish | source
end