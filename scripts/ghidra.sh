#!/bin/bash
echo "Make sure you've installed the java openjdk development package"
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
