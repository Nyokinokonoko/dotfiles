# 2022/11/12: Updated for macOS Ventura (13)

# Content collected across the internet.
# Script contains basic settings for macOS and installation of CommandLineTools
# This will also install Git and Homebrew

# Close opened System Preferences panels (if any)
osascript -e 'tell application "System Preferences" to quit'

# Init. sudo session (ask for admin password)
sudo -v

# Always expand save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Always expand print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Enable tap to click on trackpad (for current user and in login screen)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Require password right after sleep / sacreensaver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Resize Launhpad icon size
defaults write com.apple.dock springboard-rows -int 7
defaults write com.apple.dock springboard-columns -int 6

# Show hidden files by default in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions by default in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar by default in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar by default in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Use the system-native print preview dialog (In Chrome)
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default (In Chrome)
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

# Kill all apps with settings changed
for app in "Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome"; do
	killall "${app}" &> /dev/null
done
echo "Settings updated. Moving on to tool installations."

# Install CommandLineTools (Install XCode on AppStore FIRST)
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Git
brew install git

# brew install node (and npm)
brew install node

# Fix npm (global node_modules) permission issue (if any)
sudo chown -R $USER /usr/local/lib/node_modules
