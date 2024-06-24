#!/bin/bash

####################
#       SUSE       #
####################

PACKAGES_REPO=(
    "7zip" \
    "binutils" \
    "binwalk" \
    "btop" \
    "cargo" \
    "chromium" \
    "cmake" \
    "curl" \
    "discord" \
    "distrobox" \
    "docker" \
    "docker-compose" \
    "exiftool" \
    "fastfetch" \
    "flatpak" \
    "gcc" \
    "gdb" \
    "gdbserver" \
    "gimp" \
    "go" \
    "gparted" \
    "gzip" \
    "hack-fonts" \
    "hashcat" \
    "java-21-openjdk-devel" \
    "kitty" \
    "libvirt" \
    "libvirt-daemon-driver-qemu" \
    "nmap" \
    "openvpn" \
    # "opi" \
    "patchelf" \
    "php" \
    "plocate" \
    "podman" \
    "python311-pywal" \
    "qemu" \
    "qemu-extra" \
    "qemu-kvm" \
    "ruby" \
    "steam" \
    "strongswan-ipsec" \
    "tmux" \
    "touchegg" \
    "vim" \
    "virt-manager" \
    "virt-manager" \
    "wget"
    "wireshark" \
)

PACKAGES_URL=(
  "https://dl.google.com/dl/linux/direct/google-earth-pro-stable-7.3.6.x86_64.rpm" \
  "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm" \
#   "https://repo.protonvpn.com/fedora-39-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm"
)

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

# Install multimedia codecs
# echo "Installing multimedia codecs..."
# opi -n codecs

# Install Python build dependencies (for pyenv)
sudo zypper in -y gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel gdbm-devel make findutils patch

# Fix plocate
sudo updatedb

# Slack
echo "Install Slack..."
sudo zypper in "https://downloads.slack-edge.com/releases/linux/4.35.131/prod/x64/slack-4.35.131-0.1.el8.x86_64.rpm"

# Github CLI (gh)
echo "Install Github CLI..."
sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
sudo zypper ref
sudo zypper in -y gh