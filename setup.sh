#!/bin/bash

#### Usage ####
DISTROS=("suse" "arch")

# Check if the script is provided with an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 [DISTRO]"
    echo "Options:"
    for distro in "${DISTROS[@]}"; do
        echo "  - $distro"
    done
    exit 1
fi

DISTRO="$1"

# Check if argument is in the list of DISTROS
if [[ " ${DISTROS[@]} " =~ " ${DISTRO} " ]]; then
    echo "Installing for $DISTRO... (3 seconds to abort)"
    sleep 3
else
    echo "Invalid option."
    echo "Usage: $0 [DISTRO]"
    echo "Options:"
    for distro in "${DISTROS[@]}"; do
        echo "  - $distro"
    done
    exit 1
fi

#### CONSTANTS ####
# Firefox Extensions
FIREFOX_EXTENSIONS=(
    "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin" \
    "https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager" \
    "https://addons.mozilla.org/en-US/firefox/addon/simplelogin" \
    "https://addons.mozilla.org/en-US/firefox/addon/darkreader" \
    "https://addons.mozilla.org/en-US/firefox/addon/xbs" \
    "https://addons.mozilla.org/en-US/firefox/addon/firefox-color" \
    "https://addons.mozilla.org/en-US/firefox/addon/plasma-integration" \
    "https://addons.mozilla.org/en-US/firefox/addon/simple-tab-groups"
)

# Flatpaks
FLATPAKS=(
  "com.spotify.Client" \
  "org.signal.Signal" \
  "com.getpostman.Postman" \
  "org.keepassxc.KeePassXC" \
  "io.podman_desktop.PodmanDesktop" \
  "com.github.joseexposito.touche" \
  "org.gtk.Gtk3theme.Breeze" \
  "org.raspberrypi.rpi-imager" \
  "org.audacityteam.Audacity" \
  "org.videolan.VLC" \
  "org.gimp.GIMP"
)

# Distrobox
# MySQL client
# Parsec
# DB Browser

#### SETUP FILE STRUCTURE ####
echo "##############################################"
echo "            SETTING UP FILESYSTEM             "
echo "##############################################"
mkdir ./downloads
mkdir $HOME/Applications

# .bash_profile and .bashrc
cat ./setup_files/bash/.bash_profile_additions >> $HOME/.bash_profile
cat ./setup_files/bash/.bashrc_additions >> $HOME/.bashrc

source $HOME/.bash_profile
source $HOME/.bashrc


#### INSTALL APPLICATIONS ####
echo "##############################################"
echo "           INSTALLING APPLICATIONS            "
echo "##############################################"

# Install distro-specific packages
bash "${DISTRO}.sh"

# Flathub
echo "Adding Flathub..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
echo "Installing flatpaks..."
FLATPAK_COMMAND="flatpak install --user -y flathub"
for flatpak in "${FLATPAKS[@]}"; do
    FLATPAK_COMMAND+=" $flatpak"
    echo "  - $flatpak"
done
eval "$FLATPAK_COMMAND"

# Pyenv
echo "Installing Pyenv..."
curl https://pyenv.run | bash

# Install Python (make sure build dependencies are installed)
echo "Installing Python 3.12.1 with Pyenv..."
pyenv install 3.12.1
pyenv global 3.12.1

# pwntools
# echo "Installing pwntools (globally for 3.12.1)..."
# pip install setuptools
# pip install pwntools

# pwninit
echo "Installing pwninit..."
wget -O ./downloads/pwninit https://github.com/io12/pwninit/releases/download/3.3.0/pwninit
mv ./downloads/pwninit $HOME/.local/bin/pwninit

# one_gadget
echo "Installing one_gadget..."
sudo gem install one_gadget

# Pywal
echo "Configuring Pywal..."
wal --theme ./dots/pywal/themes/hackthebox.theme

# Obsidian
echo "Installing Obsidian..."
#wget -O ./downloads/Obsidian.AppImage "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian-1.4.16.AppImage"
flatpak install --user flathub md.obsidian.Obsidian
# Should install to ~/Applications by default
ail-cli integrate ./downloads/Obsidian.AppImage

# Ghidra
echo "Installing Ghidra..."
wget -O ./downloads/Ghidra.zip "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip"
unzip -q ./downloads/Ghidra.zip -d $HOME/Applications
mv $HOME/Applications/ghidra_* $HOME/Applications/Ghidra
chmod +x $HOME/Applications/Ghidra/ghidraRun
mkdir $HOME/.local/share/applications
sed -i "s/{HOME}/$(echo $HOME | sed 's/\//\\\//g')/g" ./setup_files/ghidra/Ghidra.desktop
cp ./setup_files/ghidra/Ghidra.desktop $HOME/.local/share/applications
cp ./setup_files/ghidra/ghidra_icon_white.png $HOME/Applications/Ghidra

# GEF
echo "Installing GEF for GDB..."
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Download Burp Suite
echo "Downloading Burp Suite..."
wget -O ./downloads/burpsuite_install.sh "https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.11.1.3&type=Linux"
chmod +x ./downloads/burpsuite_install.sh

# Add current user to needed groups for docker and virt-manager to work
sudo usermod -aG docker,libvirt,kvm $USER

# Create kali distrobox
distrobox create --image docker.io/kalilinux/kali-rolling:latest --name kali --yes
distrobox enter kali -e sudo apt update
distrobox enter kali -e export TERM=xterm; sudo apt upgrade -y
distrobox enter kali -e export TERM=xterm; sudo apt install -y kali-linux-default
distrobox enter kali -e export TERM=xterm; sudo apt install -y gdb gdb-multiarch

# https://github.com/pwndbg/pwndbg/releases/download/2024.02.14/pwndbg_2024.02.14_amd64.deb
wget https://github.com/pwndbg/pwndbg/releases/download/2024.02.14/pwndbg_2024.02.14_amd64.deb
distrobox enter kali -e sudo apt install -y ./pwndbg*.deb

# Log into Github
echo "Log into Github..."
gh auth login

# Install Burp Suite
echo "Install Burp Suite..."
./downloads/burpsuite_install.sh

# Set up Ghidra
echo "Setup Ghidra..."
bash $HOME/Applications/Ghidra/ghidraRun

# Install Firefox extensions (open links automatically)
echo "Install Firefox extensions..."
FIREFOX_COMMAND="firefox -new-window -url"
for url in "${FIREFOX_EXTENSIONS[@]}"; do
    FIREFOX_COMMAND+=" \"$url\""
done
FIREFOX_COMMAND+=" 2>/dev/null"
eval "$FIREFOX_COMMAND"


echo "##############################################"
echo "                     TODO                     "
echo "##############################################"
echo " - [ ] Add \`@reboot wal -R\` via \`crontab -e\`"
echo " - [ ] Rice/Configure Desktop"
echo "   - [ ] Dock"
echo "   - [ ] Workspaces and keybindings"
echo "   - [ ] Display scaling? (if Wayland)"
echo "   - [ ] Theming (GTK and Qt)"
echo "   - [ ] Dark mode"
echo " - [ ] Login to applications"
echo "   - [ ] 1Password (desktop and browser)"
echo "   - [ ] Obsidian"
echo "   - [ ] Discord"
echo "   - [ ] Slack"
echo "   - [ ] XBrowserSync"
echo "   - [ ] SimpleLogin"
echo "   - [ ] Signal"
echo " - [ ] Setup VPNs (CS, THM, BYU, CCDC, Proton)"
echo " - [ ] Install Firefox theme"
echo " - [ ] Configure Firefox preferences"
echo "   - [ ] Compact mode"
echo "   - [ ] Security/privacy settings"
echo " - [ ] Configure Ublock Origin filter lists"
echo " - [ ] Fully set up Ghidra"
echo " - [ ] Ricing"
echo "   - [ ] VSCodium theme"
echo "   - [ ] KDE theme"
echo "   - [ ] Obsidian theme"
echo "   - [ ] Wallpaper"
echo "   - [ ] Ghidra theme"
echo " - [ ] Configure Touche (if X11)"
echo " - [ ] Install Steam games"
echo " - [ ] Configure power saving"
echo " - [ ] Setup VMs"
