#! /bin/bash
# Syntax: ./install-chrome.sh

apt update
apt-get install -y wget
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
apt install -y --fix-broken

# sourced from:
# https://bytexd.com/install-chrome-remote-desktop-headless/#:~:text=%20Install%20Chrome%20Remote%20Desktop%20on%20a%20Headless,able%20to%20connect%20to%20the%20remote...%20More%20
