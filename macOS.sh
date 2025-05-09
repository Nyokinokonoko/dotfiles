#!/bin/bash

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is only for macOS"
    exit 1
fi

# Print macOS version
echo "Current macOS version: $(sw_vers -productVersion)"

# Function to ask for user confirmation
ask_user() {
    read -p "$1 (y/n): " choice
    case "$choice" in 
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo "Invalid input. Please enter y or n."; ask_user "$1";;
    esac
}

# Close System Preferences if open
read -p "Press Enter to close System Preferences if it's open..."
osascript -e 'tell application "System Preferences" to quit'

# Init sudo session
sudo -v

# Save panel settings
if ask_user "Do you want to always expand save panel?"; then
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
fi

# Print panel settings
if ask_user "Do you want to always expand print panel?"; then
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
fi

# Trackpad settings
if ask_user "Do you want to enable tap to click on trackpad?"; then
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
fi

# Screensaver password settings
if ask_user "Do you want to require password immediately after sleep/screensaver begins?"; then
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
fi

# Launchpad icon size
if ask_user "Do you want to resize Launchpad icons (7x6 grid)?"; then
    defaults write com.apple.dock springboard-rows -int 7
    defaults write com.apple.dock springboard-columns -int 6
fi

# Finder hidden files
if ask_user "Do you want to show hidden files by default in Finder?"; then
    defaults write com.apple.finder AppleShowAllFiles -bool true
fi

# Filename extensions
if ask_user "Do you want to show all filename extensions by default?"; then
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
fi

# Finder status bar
if ask_user "Do you want to show status bar in Finder?"; then
    defaults write com.apple.finder ShowStatusBar -bool true
fi

# Finder path bar
if ask_user "Do you want to show path bar in Finder?"; then
    defaults write com.apple.finder ShowPathbar -bool true
fi

# .DS_Store files
if ask_user "Do you want to prevent .DS_Store file creation on network/USB volumes?"; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
fi

# Auto-open Finder for new volumes
if ask_user "Do you want Finder to automatically open when a volume is mounted?"; then
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
fi

# Grid arrangement
if ask_user "Do you want to enable snap-to-grid for desktop icons?"; then
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
fi

# Show Library folder
if ask_user "Do you want to show the ~/Library folder?"; then
    chflags nohidden ~/Library
fi

# Show Volumes folder
if ask_user "Do you want to show the /Volumes folder?"; then
    sudo chflags nohidden /Volumes
fi

# Time Machine settings
if ask_user "Do you want to prevent Time Machine from prompting to use new hard drives?"; then
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
fi

# Chrome print dialog settings
if ask_user "Do you want to configure Chrome's print dialog settings?"; then
    defaults write com.google.Chrome DisablePrintPreview -bool true
    defaults write com.google.Chrome.canary DisablePrintPreview -bool true
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
fi

# Restart affected applications
read -p "Press Enter to restart affected applications and apply changes..."
for app in "Dock" "Finder" "Google Chrome Canary" "Google Chrome"; do
    killall "${app}" &> /dev/null
done
echo "Settings updated. Moving on to tool installations."

# Tool installations
if ask_user "Do you want to install Command Line Tools?"; then
    xcode-select --install
fi

if ask_user "Do you want to install Homebrew?"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if ask_user "Do you want to install Git?"; then
    brew install git
fi

if ask_user "Do you want to install Node.js and npm?"; then
    brew install node
fi

if ask_user "Do you want to fix npm permissions?"; then
    sudo chown -R $USER /usr/local/lib/node_modules
fi