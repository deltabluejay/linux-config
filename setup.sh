#!/bin/bash

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

# Get the user argument
DISTRO="$1"

# Check if the argument is in the list of DISTROS
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

###################
#  SUSE
###################

### CONSTANTS ###
FIREFOX_EXTENSIONS=(
    "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/simplelogin/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/darkreader/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
    "https://addons.mozilla.org/en-US/firefox/addon/xbs/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search" \
)

PACKAGES_REPO=(
  "flatpak" \
  "kitty" \
  "wireshark" \
  "virt-manager" \
  "openvpn" \
  "curl" \
  "java-21-openjdk" \
  "discord" \
  "gimp" \
  "gdb" \
  "docker" \
  "docker-compose" \
  "yast2-docker" \
  "steam" \
  "ungoogled-chromium" \
  "python311-pywal" \
)
# Trying yast2-docker for Docker GUI
# If that's not very good follow this: https://docs.docker.com/desktop/install/fedora/

PACKAGES_URL=(
  "https://dl.google.com/dl/linux/direct/google-earth-pro-stable-7.3.6.x86_64.rpm" \
  "https://repo.protonvpn.com/fedora-39-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm" \
  "https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-4.35.131-0.1.el8.x86_64.rpm" \
)

FLATPAKS=(
  "com.spotify.Client" \
  "org.signal.Signal" \
  "com.getpostman.Postman" \
)


### SETUP FILE STRUCTURE ###
echo "Setting up file structure..."
mkdir ./downloads
mkdir $HOME/Applications
git clone <INSERT GITHUB URL HERE> # TODO: get link

# .bash_profile and .bashrc
cat ./files/.bash_profile_additions >> $HOME/.bash_profile
cat ./files/.bashrc_additions >> $HOME/.bashrc


### INSTALL APPLICATIONS ###
# Install packages from repository
ZYPPER_COMMAND="sudo zypper in -y"
echo "Installing packages..."
for package in "${PACKAGES_REPO[@]}"; do
    ZYPPER_COMMAND+=" $package"
    echo "  - $package"
done
eval "$ZYPPER_COMMAND"

# Install packages from URLs
ZYPPER_COMMAND="sudo zypper in -y"
echo "Installing packages..."
for package in "${PACKAGES_URL[@]}"; do
    ZYPPER_COMMAND+=" $package"
    echo "  - $package"
done
eval "$ZYPPER_COMMAND"

# Flathub
echo "Adding Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
FLATPAK_COMMAND="flatpak install -y flathub"
echo "Installing flatpaks..."
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
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo zypper in -y brave-browser

# Github CLI (gh)
echo "Installing Github CLI..."
sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
sudo zypper ref
sudo zypper in -y gh
# TODO: login with Github (`gh auth login`)

# Pyenv
echo "Installing Pyenv..."
curl https://pyenv.run | bash
# TODO: install Python version (may have to install dev packages)

# Pywal
echo "Configuring Pywal..."
wal --theme ./dots/pywal/themes/hackthebox.theme
# TODO: add `@reboot wal -R` via `crontab -e`

# Obsidian
echo "Installing Obsidian..."
wget -O ./downloads/Obsidian.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/Obsidian-1.4.16.AppImage
# TODO: AppImage installing tool

# Ghidra
wget -O ./downloads/ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip
unzip ./downloads/ghidra.zip
chmod +x ./downloads/ghidra/ghidraRun
mv ./downloads/ghidra $HOME/Applications/Ghidra
mkdir $HOME/.local/share/applications
cp ./files/Ghidra.desktop $HOME/.local/share/applications
./$HOME/Applications/Ghidra/ghidraRun # probably not right

# GEF
echo "Installing GEF for GDB..."
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Burp Suite
wget -O ./downloads/burpsuite_install.sh https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.11.1.3&type=Linux
./downloads/burpsuite_install.sh # probably not right

# TODO: Other VPNs
# TODO: install media codecs?
# TODO: configure power saving?

# Install Firefox extensions (open links automatically)
firefox --new-tab https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search
for url in "${EXTENSIONS[@]}"; do
  firefox --new-tab "$url"
done
# TODO: Firefox theme
# TODO: configure Ublock Origin lists


echo "TODO:"
echo "    -[ ] KDE customization"
echo "    -[ ] Login to applications (1Password, gh, Obsidian, Discord, Slack, XBrowserSync, SimpleLogin)"
echo "    -[ ] Install Firefox extensions and theme"
echo "    -[ ] Configure Firefox preferences"
echo "    -[ ] Configure Ublock Origin filter lists"
echo "    -[ ] Fully set up Ghidra"
echo "    -[ ] Ricing"
echo "        -[ ] VSCodium theme"
echo "        -[ ] KDE theme"
echo "        -[ ] Obsidian theme"
echo "        -[ ] Wallpaper"
echo "        -[ ] "
echo "    -[ ] "