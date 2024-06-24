#!/bin/bash

####################
#       ARCH       #
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
    "opi" \
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

echo "Installing packages with pacman..."

# Install packages from repo
PACMAN_COMMAND="sudo pacman "
for package in "${PACKAGES_REPO[@]}"; do
    PACMAN_COMMAND+=" $package"
    echo "  - $package"
done
eval "$PACMAN_COMMAND"

echo "Installing packages with pacman (from URLs)..."

# Install packages from URLs
PACMAN_COMMAND="sudo pacman "
for package in "${PACKAGES_URL[@]}"; do
    PACMAN_COMMAND+=" $package"
    echo "  - $package"
done
eval "$PACMAN_COMMAND"