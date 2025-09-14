{ pkgs, ... }:

let
  # Define variables
  profileBase = if pkgs.stdenv.isLinux then
    ".mozilla/firefox"
  else if pkgs.stdenv.isDarwin then
    "Library/Application Support/Firefox/Profiles"
  else
    throw "Unsupported platform";

  profileName = "default"; # Replace with your actual profile name
  profilePath = "${profileBase}/${profileName}";
  customChrome = ./customChrome.css;
  customContent = ./customContent.css;

  # Fetch Arkenfox user.js
  arkenfoxUserJs = "${
      builtins.fetchGit {
        url = "https://github.com/arkenfox/user.js/";
        rev = "9103afafff2b5287b495c1a1268968fdb447d66f";
      }
    }/user.js";

  # Fetch WhiteSur theme using builtins.fetchGit
  whitesurThemeSrc = builtins.fetchGit {
    url = "https://github.com/vinceliuice/WhiteSur-firefox-theme";
    rev = "5bca0ba79af0e3707d080355f18a9c31086f7202";
  };

  # Create a new directory with renamed files from WhiteSur theme's src folder
  whitesurTheme = pkgs.runCommand "whitesur-theme" {
    inherit customChrome customContent;
   } ''
    mkdir -p $out
    mkdir -p $out/.hide

    # Copy all files except customChrome.css
    cp -r ${whitesurThemeSrc}/src/* $out/
    mv $out/customChrome.css $out/.hide/customChrome.css

    # Rename userChrome
    mv $out/userChrome-Monterey-alt.css $out/userChrome.css || true

    # Generate userContent.css by reading original and appending import
    cat $out/userContent-Monterey.css > $out/userContent.css
    echo '@import "customContent.css";' >> $out/userContent.css

    cp ${customChrome} $out/customChrome.css
    cp ${customContent} $out/customContent.css
  '';

  # Create combined user.js by concatenating arkenfox user.js and user-override.js
  combinedUserJs = builtins.readFile arkenfoxUserJs
    + builtins.readFile ./user-override.js;

in {
  # Enable Firefox and define profiles
  programs.firefox = {
    enable = true;
    profiles.${profileName} = { isDefault = true; };
    policies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      FirefoxHome = {
        Search = true;
        Pocket = false;
        Snippets = false;
        TopSites = false;
        Highlights = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
  };

  home.file = {
    "${profilePath}/user.js".text = combinedUserJs;
    "${profilePath}/chrome".source = whitesurTheme;
  };
}
