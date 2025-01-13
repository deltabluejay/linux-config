#!/bin/bash
sudo usermod -aG docker ava
#sudo systemctl enable docker
#sudo systemctl start docker
sudo zypper in podman python311-podman-compose
sudo zypper in docker docker-compose
sudo zypper in stow fish starship zoxide eza
sudo zypper in make pyenv rbenv neovim
sudo zypper in NetworkManager-l2tp
sudo zypper in wireshark
sudo zypper in gparted
sudo zypper in cron
sudo zypper in google-noto-fonts fetchmsttfonts
sudo zypper in libvirt freerdp
sudo zypper in rclone
sudo zypper in gcc gcc-32bit glibc-devel-static

# Lazyvim
sudo zypper in fzf ripgrep fd

# Markdown preview
sudo zypper in glow


# VMs
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
sudo virsh net-autostart default
# Check that network started
#sudo virsh net-list --all

flatpak install --user flathub io.podman_desktop.PodmanDesktop
flatpak install --user flathub com.parsecgaming.parsec
flatpak install --user flathub com.slack.Slack
flatpak install --user flathub com.discordapp.Discord

./stow.sh
mkdir ~/Applications
wal --theme .config/wal/templates/hackthebox.theme

sudo zypper in java-17-openjdk-devel
# Ghidra High DPI fix https://gist.github.com/nstarke/baa031e0cab64a608c9bd77d73c50fc6
# Has to be either 1x or 2x, no 1.5x
# Also add -Dsun.java2d.uiScale=2 to ~/Applications/BurpSuiteCommunity/BurpSuiteCommunity.vmoptions
# then change font sizes manually inside Burp settings
# (that assumes the built-in scaling option isn't working)
# https://forum.portswigger.net/thread/burp-2020-5-1-looks-blurry-1b9337c4c
#

# fprintd
# https://wiki.archlinux.org/title/Fprint#Login_configuration
# This will make it work after pressing ENTER for both login screen and GUI prompts like 1password
# This may need to be redone from time to time
# Replace symlink with copy of file (instructions from file comments)
sudo rm -f /etc/pam.d/common-auth; sudo sed '/^#.*/d' /etc/pam.d/common-auth-pc | sudo tee /etc/pam.d/common-auth
# Add fprint lines
(echo '# Prompt for password
auth    sufficient      pam_unix.so     try_first_pass likeauth nullok
# If that fails, ask for fingerprint
auth    sufficient      pam_fprintd.so
# Defaults'; cat /etc/pam.d/common-auth) | sudo tee /etc/pam.d/common-auth
#

# Setup pyenv
pyenv install 3.11.9
pyenv global 3.11.9
git clone https://github.com/pyenv/pyenv-virtualenv.git (pyenv root)/plugins/pyenv-virtualenv

# VPNs
sudo zypper in NetworkManager-openvpn

# VMs
sudo zypper in virt-manager virt-viewer qemu

# Codecs
# See https://en.opensuse.org/SDB:Installing_codecs_from_Packman_repositories
