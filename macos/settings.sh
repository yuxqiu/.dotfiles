#!/usr/bin/env bash

set -e

# This file is taken from
# https://github.com/sobolevn/dotfiles/blob/master/macos/settings.sh

echo 'Configuring your mac. Hang tight.'
osascript -e 'tell application "System Preferences" to quit'


# === General ===
# Disable startup noise:
sudo nvram SystemAudioVolume=%01

# Mojave renders fonts that are too thin for me, use regular pre-mojave style:
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

# Scrollbars visible when scrolling:
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Always use expanded save dialog:
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# === Dock ===

# Strip the dock to just what's running 
defaults write com.apple.dock static-only -bool true

# === Finder ===

# Keep folders on top when sorting by name:
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show Finder path bar:
defaults write com.apple.finder ShowPathbar -bool true

# Do not show status bar in Finder:
defaults write com.apple.finder ShowStatusBar -bool false

# Show hidden files in Finder:
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions in Finder:
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show Library folder
chflags nohidden ~/Library


# === Safari ===

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true


# === Text editing ===
# Disable smart quotes:
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable autocorrect:
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization:
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes:
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution:
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable press and hold:
defaults write -g ApplePressAndHoldEnabled -bool false


# === Time Machine ===
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


# === Activity monitor ===
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0


# Restarting apps:
echo 'Restarting apps...'
killall Finder
killall Dock

echo 'Done!'
