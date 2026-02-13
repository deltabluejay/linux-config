import requests
import subprocess
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup

url = "https://api.github.com/repos/nextcloud-releases/desktop/releases/latest"
filename = "Nextcloud.AppImage"
destination = "/home/ava/Applications/nextcloud/Nextcloud.AppImage"

# Get latest github releases
r = requests.get(url)
r.raise_for_status()

release_data = r.json()
appimage = [download for download in release_data['assets'] if download['name'].endswith('.AppImage')][0]['browser_download_url']

# Download AppImage
print(f"Downloading {appimage}...")
with requests.get(appimage, stream=True) as r:
    r.raise_for_status()
    with open(filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=8192):
            if chunk:
                f.write(chunk)

# Install the AppImage
print(f"Installing new AppImage to {destination}...")
result = subprocess.run(["mv", filename, destination], capture_output=True, text=True)
print(result.stdout) if result.stdout else ''
print(result.stderr) if result.stderr else ''

result = subprocess.run(["chmod", "+x", destination], capture_output=True, text=True)
print(result.stdout) if result.stdout else ''
print(result.stderr) if result.stderr else ''
