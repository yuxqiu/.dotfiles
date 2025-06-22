## Firefox

1. `user-override.js` should be used in conjunction with `user.js`. I recommend using [arkenfox/user.js](https://github.com/arkenfox/user.js).
   - After putting `user.js` into the profile directory, the only thing you need to do is to paste the contents of `user-override.js` into `user.js`.
2. Install this theme [theme](https://github.com/vinceliuice/WhiteSur-firefox-theme).
   - Symlink `customChrome.css` and `customContent.css` to `~/.mozilla/firefox/firefox-themes/`
   - Modify `userContent.css` to import `customContent.css`