#!/bin/bash
###################### GLOBALS ######################
DISTROS=( "fedora" "aurora" "suse" "ubuntu" "debian" "arch" )
distro=""

BREW_PACKAGES=(
    "bat" \
    "btop" \
    "eza" \
    "gh" \
    "go" \
    "moar" \
    "neovim" \
    "nmap" \
    "openjdk" \
    "patchelf" \
    "pyenv-virtualenv" \
    "ranger" \
    "rbenv" \
    "ruby" \
    "stow" \
    "zoxide" \
    "fish" \
    "starship" \
    "distrobox" \
    "rust" \
    "glow" \
    "7zip" \
    "exiftool" \
    "fastfetch" \
    "zip" \
    "gzip" \
    "tmux" \
)

SYSTEM_PACKAGES=(
    "firefox" \
    "podman" \
    "docker-compose" \
    "flatpak" \
    "virt-manager" \
    "virt-viewer" \
    "qemu" \
    "code" \
    "gdb" \
    "gdb-gdbserver" \
    "gcc" \
    "make" \
    "kitty" \
    "wireshark" \
    "strongswan" \
    "NetworkManager-openvpn" \
    "NetworkManager-l2tp" \
    "openvpn" \
    "hashcat" \
    "xfreerdp" # ?
)

FLATPAKS=(
    # Disclaimer: some of these are unverified or not official
    # "com.spotify.Client" \
    # "com.getpostman.Postman" \
    # "com.github.joseexposito.touche" \
    "com.slack.Slack" \
    "org.signal.Signal" \
    "org.keepassxc.KeePassXC" \
    "io.podman_desktop.PodmanDesktop" \
    "org.gtk.Gtk3theme.Breeze" \
    "org.raspberrypi.rpi-imager" \
    "org.audacityteam.Audacity" \
    "org.videolan.VLC" \
    "org.gimp.GIMP" \
    "com.brave.Browser" \
    "com.discordapp.Discord" \
    "com.parsecgaming.parsec" \
    "com.slack.Slack" \
    "md.obsidian.Obsidian" \
    "nl.hjdskes.gcolor3" \
    "com.usebottles.bottles" \
    "org.onlyoffice.desktopeditors" \
    # "org.wireshark.Wireshark" \
    "org.ghidra_sre.Ghidra" \
    "us.zoom.Zoom" \
    "io.github.dvlv.boxbuddyrs" \
    "com.google.EarthPro" \
)

FIREFOX_EXTENSIONS=(
    "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin" \
    "https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager" \
    "https://addons.mozilla.org/en-US/firefox/addon/simplelogin" \
    "https://addons.mozilla.org/en-US/firefox/addon/darkreader" \
    "https://addons.mozilla.org/en-US/firefox/addon/firefox-color" \
    "https://addons.mozilla.org/en-US/firefox/addon/plasma-integration" \
    "https://addons.mozilla.org/en-US/firefox/addon/simple-tab-groups"
)
#####################################################

##################### FUNCTIONS #####################
function get_input_string {
    read -r -p "$1" input
    echo "$input"
}

function error {
    echo -e "\033[0;31mERROR: $1\033[0m"
}

function get_distro {
    echo "What distro is this?"
    echo "Options: "
    for i in "${!DISTROS[@]}"; do
        echo "$((i + 1)). ${DISTROS[$i]}"
    done
    choice=$(get_input_string "Pick a number: " | tr -d ' ')
    if [[ $choice -ge 1 && $choice -le ${#items[@]} ]]; then
        distro=${items[$((choice - 1))]}
    else
        error "Invalid choice"
        exit 1
    fi
}

function install_with_brew {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Installing Homebrew packages..."
    brew install -y "${BREW_PACKAGES[@]}"
}

function install_flatpaks {
    echo "Adding Flathub..."
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Installing flatpaks..."
    eval "flatpak install --user -y flathub ${FLATPAKS[*]}"
}

function setup_pyenv {
    echo "Installing Pyenv..."
    curl https://pyenv.run | bash

    echo "Installing Python dependencies..."
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    case "$distro" in
        "fedora")
            sudo dnf install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite \
            sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2
            ;;
        "aurora")
            # This definitely needs to be tested- not entirely sure how it's supposed to work
            toolbox enter
            sudo dnf update vte-profile  # https://github.com/containers/toolbox/issues/390
            sudo dnf install "@Development Tools" zlib-devel bzip2 bzip2-devel readline-devel sqlite \
            sqlite-devel openssl-devel xz xz-devel libffi-devel findutils tk-devel
            exit
            ;;
        "suse")
            sudo zypper install gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
            readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel gdbm-devel make findutils patch
            ;;
        "ubuntu" | "debian")
            sudo apt update; sudo apt install make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev curl git \
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
            ;;
        "arch")
            sudo pacman -S --needed base-devel openssl zlib xz tk
            ;;
        *)
            error "Unknown distro: $distro"
            exit 1
            ;;
    esac

    echo "Installing Python 3.11.12 via Pyenv..."
    pyenv install 3.11.12
    pyenv global 3.11.12

    echo "Setting up Pyenv virtual environments..."
    pyenv virtualenv ctf
    pyenv virtualenv ccdc
}

function setup_pwn {
    pyenv activate ctf
    pip install pwntools
    pyenv deactivate

    cargo install pwninit
    gem install one_gadget

    git clone https://github.com/pwndbg/pwndbg.git ~/Applications/pwndbg/
    cd ~/Applications/pwndbg
    ./setup.sh
    cd -

    # bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
}

function setup_pywal {
    pip install --user pywal

    echo "Configuring Pywal..."
    wal --theme ~/.config/wal/templates/hackthebox.theme

    # Make sure `wal -R` is set to run on startup or login (e.g. ~/.config/autostart/)
}

function setup_distrobox {
    distrobox create --image ghcr.io/ublue-os/fedora-toolbox --name fedora --yes
    distrobox create --image ghcr.io/ublue-os/ubuntu-toolbox --name ubuntu --yes
    distrobox create --image docker.io/kalilinux/kali-rolling:latest --name kali --yes
    # TODO: fix networking / systemd
    # TODO: background kali installation

    distrobox enter kali -e sudo apt update
    distrobox enter kali -e export TERM=xterm; sudo apt upgrade -y
    distrobox enter kali -e export TERM=xterm; sudo apt install -y kali-linux-default
}

function install_burpsuite {
    echo "To download Burp Suite, please visit https://portswigger.net/burp/releases/community/latest"
    echo "Download the installer and run it to install Burp Suite"
    echo "Press ENTER when you have finished: "
    get_input_string ""
}

function install_binja {
    # TODO
}

function install_1password {
    echo "Installing 1Password..."
    # https://support.1password.com/install-linux/
    case "$distro" in
        "fedora")
            sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
            sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
            sudo dnf install 1password
            ;;
        "aurora")
            # https://leopoldluley.de/posts/install-1password-with-rpm-ostree/
            echo '[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc' | sudo tee -a /etc/yum.repos.d/1password.repo
            rpm-ostree install 1password 1password-cli
            ;;
        "suse")
            sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
            sudo zypper addrepo https://downloads.1password.com/linux/rpm/stable/x86_64 1password
            sudo zypper install 1password
            ;;
        "ubuntu" | "debian")
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
            sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
            curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
            sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
            sudo apt update && sudo apt install 1password
            ;;
        "arch")
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
            git clone https://aur.archlinux.org/1password.git
            cd 1password
            makepkg -si

            cd ..
            rm -rf 1password/
            ;;
        *)
            error "Unknown distro: $distro"
            exit 1
            ;;
    esac
}

function setup_github {
    # Login to Github
    echo "Logging into Github..."
    gh auth login
    git config --global user.name "deltabluejay"
    git config --global user.email "github-deltabluejay.iqoyw@slmail.me"
}

function setup_kde {
    # Load KDE preferences
    echo "Loading KDE preferences..."
    # TODO
}

# Unused- now covered by Firefox sync
function open_firefox_extensions {
    echo "Opening Firefox extensions..."
    FIREFOX_COMMAND="firefox -new-window -url"
    for url in "${FIREFOX_EXTENSIONS[@]}"; do
        FIREFOX_COMMAND+=" \"$url\""
    done
    FIREFOX_COMMAND+=" 2>/dev/null"
    eval "$FIREFOX_COMMAND"
}
#####################################################

######################## MAIN #######################
# Add current user to needed groups for docker and virt-manager to work
sudo usermod -aG docker,libvirt,kvm $USER
sudo virsh net-autostart default # ?

# Make applications folder
mkdir $HOME/Applications
# Symlink dotfiles
bash "./stow.sh"

# Distro-specific setup
get_distro
if [ -f "./scripts/$distro.sh" ]; then
    bash "./scripts/$distro.sh"
fi

# Packages
install_with_brew
install_flatpaks

# Applications
install_burpsuite
install_binja
install_1password

# Application configuration
setup_pyenv # TODO may need to reload shell first
#setup_rbenv #TODO
setup_pwn
setup_pywal
setup_distrobox
setup_github
setup_kde

# Change firefox settings
# VSCode extensions
# Obsidian vault/extensions
# System fonts? Nerd fonts?