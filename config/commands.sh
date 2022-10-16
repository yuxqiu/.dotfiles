# create empty space in Dock
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock

# enable developer mode
sudo spctl developer-mode enable-terminal

