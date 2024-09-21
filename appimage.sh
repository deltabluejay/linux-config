#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <appimage_path> <app_icon> <app_name>"
    exit 1
fi

appimage="$1"
app_icon="$2"
app_name="$3"

saved_appimage="$HOME/Applications/$app_name/$(basename $appimage)"
saved_app_icon="$HOME/Applications/$app_name/$(basename $app_icon)"
desktop_file="$HOME/.local/share/applications/${app_name}.desktop"

mkdir "$HOME/Applications/$app_name/"
cp "$appimage" "$saved_appimage"
cp "$app_icon" "$saved_app_icon"

echo "[Desktop Entry]" > "$desktop_file"
echo "Version=1.0" >> "$desktop_file"
echo "Type=Application" >> "$desktop_file"
echo "Terminal=false" >> "$desktop_file"
echo "Name=$app_name" >> "$desktop_file"
echo "Icon=$saved_app_icon" >> "$desktop_file"
echo "Exec=\"$saved_appimage\"" >> "$desktop_file"
echo "Categories=Utility" >> "$desktop_file"

chmod 644 "$desktop_file"
echo "Desktop file created at: $desktop_file"

