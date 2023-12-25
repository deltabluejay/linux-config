#!/bin/bash

#### Usage ####
DISTROS=("SUSE" "FEDORA")

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
# TODO: implement different commands depending on distro

####################
#       SUSE       #
####################

#### CONSTANTS ####
FIREFOX_EXTENSIONS=(
    "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/simplelogin/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/darkreader/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/xbs/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
)

PACKAGES_REPO=(
  "qtile" \
  "flatpak" \
  "kitty" \
  "wireshark" \
  "virt-manager" \
  "openvpn" \
  "curl" \
  "java-21-openjdk-devel" \
  "discord" \
  "gimp" \
  "binutils" \
  "gdb" \
  "docker" \
  "docker-compose" \
  "yast2-docker" \
  "steam" \
  "ungoogled-chromium" \
  "python311-pywal" \
  "distrobox" \
  "gcc" \
  "opi" \
  "patchelf" \
  "ruby" \
)
# Trying yast2-docker for Docker GUI
# If that's not very good follow this: https://docs.docker.com/desktop/install/fedora/

PACKAGES_URL=(
  "https://dl.google.com/dl/linux/direct/google-earth-pro-stable-7.3.6.x86_64.rpm" \
  "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm" \
  "https://repo.protonvpn.com/fedora-39-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm" \
)

FLATPAKS=(
  "com.spotify.Client" \
  "org.signal.Signal" \
  "com.getpostman.Postman" \
)


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
# Install packages from repository
echo "##############################################"
echo "           INSTALLING APPLICATIONS            "
echo "##############################################"

echo "Installing packages with zypper..."

# Install packages from repo
ZYPPER_COMMAND="sudo zypper in -y --allow-unsigned-rpm"
for package in "${PACKAGES_REPO[@]}"; do
    ZYPPER_COMMAND+=" $package"
    echo "  - $package"
done
eval "$ZYPPER_COMMAND"

echo "Installing packages with zypper (from URLs)..."

# Install packages from URLs
ZYPPER_COMMAND="sudo zypper in -y --allow-unsigned-rpm"
for package in "${PACKAGES_URL[@]}"; do
    ZYPPER_COMMAND+=" $package"
    echo "  - $package"
done
eval "$ZYPPER_COMMAND"

# Flathub
echo "Adding Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
echo "Installing flatpaks..."
FLATPAK_COMMAND="sudo flatpak install -y flathub"
for flatpak in "${FLATPAKS[@]}"; do
    FLATPAK_COMMAND+=" $flatpak"
    echo "  - $flatpak"
done
eval "$FLATPAK_COMMAND"

# 1Password
echo "Installing 1Password..."
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo zypper addrepo https://downloads.1password.com/linux/rpm/stable/x86_64 1password
sudo zypper in -y 1password

# VSCodium
echo "Installing VSCodium..."
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/zypp/repos.d/vscodium.repo
sudo zypper in -y codium

# Brave
echo "Installing Brave..."
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo zypper in -y brave-browser

# Pyenv
echo "Installing Pyenv..."
curl https://pyenv.run | bash

# Install Python build dependencies and install a new version
echo "Installing Python 3.12.1 with Pyenv..."
sudo zypper in -y gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel gdbm-devel make findutils patch
pyenv install 3.12.1
pyenv global 3.12.1

# pwntools
echo "Installing pwntools (globally for 3.12.1)..."
pip install pwntools

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

# Install multimedia codecs
echo "Installing multimedia codecs..."
opi -n codecs

# Obsidian
echo "Installing Obsidian..."
wget -O ./downloads/Obsidian.AppImage "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian-1.4.16.AppImage"
# Should install to ~/Applications by default
ail-cli integrate ./downloads/Obsidian.AppImage

# Ghidra
echo "Installing Ghidra..."
wget -O ./downloads/Ghidra.zip "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip"
unzip -q ./downloads/Ghidra.zip -d $HOME/Applications
mv $HOME/Applications/ghidra_* $HOME/Applications/Ghidra
chmod +x $HOME/Applications/Ghidra/ghidraRun
mkdir $HOME/.local/share/applications
cp ./setup_files/ghidra/Ghidra.desktop $HOME/.local/share/applications
cp ./setup_files/ghidra/ghidra_icon_white.png $HOME/Applications/Ghidra

# GEF
echo "Installing GEF for GDB..."
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Download Burp Suite
echo "Downloading Burp Suite..."
wget -O ./downloads/burpsuite_install.sh "https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.11.1.3&type=Linux"
chmod +x ./downloads/burpsuite_install.sh


#### USER SETUP ####
echo "##############################################"
echo "       PARTS REQUIRING USER INTERACTION       "
echo "##############################################"

# Slack
echo "Install Slack..."
sudo zypper in "https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-4.35.131-0.1.el8.x86_64.rpm"

# Github CLI (gh)
echo "Install Github CLI..."
sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
sudo zypper ref
sudo zypper in -y gh

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
echo "   - [ ] Display scaling?"
echo "   - [ ] Theming (GTK and Qt)"
echo "   - [ ] Dark mode"
echo " - [ ] Login to applications"
echo "   - [ ] 1Password (desktop and browser)"
echo "   - [ ] Obsidian"
echo "   - [ ] Discord"
echo "   - [ ] Slack"
echo "   - [ ] XBrowserSync"
echo "   - [ ] SimpleLogin"
echo "   - [ ] ProtonVPN"
echo " - [ ] Setup VPNs (CS, THM, BYU)"
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
echo " - [ ] Install Steam games"
echo " - [ ] Configure power saving and GPU drivers"
echo " - [ ] Setup distrobox (Kali, Ubuntu, Arch)"
echo " - [ ] Setup VMs"