{ config, pkgs, ... }:

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
        rev = "0f14e030b3a9391e761c03ce3c260730a78a4db6";
      }
    }/user.js";

  # Fetch WhiteSur theme using builtins.fetchGit
  whitesurThemeSrc = builtins.fetchGit {
    url = "https://github.com/vinceliuice/WhiteSur-firefox-theme";
    rev = "848f9bf8f91dae355eece14fca75929f86d33421";
  };
  themeName = "WhiteSur";
  userChromeName = "${themeName}";
  userContentName = themeName;

  # Create a new directory with renamed files from WhiteSur theme's src folder
  whitesurTheme =
    # https://github.com/vinceliuice/WhiteSur-firefox-theme/blob/main/install.sh
    pkgs.runCommand "whitesur-theme" { inherit customChrome customContent; } ''
      mkdir -p $out
      mkdir -p $out/.hide
      mkdir -p $out/${themeName}/icons
      mkdir -p $out/${themeName}/titlebuttons
      mkdir -p $out/${themeName}/pages
      mkdir -p $out/${themeName}/parts

      # Copy all files except customChrome.css
      cp -r ${whitesurThemeSrc}/src/* $out/
      mv $out/customChrome.css $out/.hide/customChrome.css

      # Copy common assets
      cp -rf $out/common/icons $out/${themeName}
      cp -rf $out/common/titlebuttons $out/${themeName}
      cp -rf $out/common/pages $out/${themeName}
      cp -rf $out/common/*.css $out/${themeName}
      cp -rf $out/common/parts/*.css $out/${themeName}/parts

      # Rename userChrome
      mv $out/userChrome-${userChromeName}.css $out/userChrome.css

      # Generate userContent.css by reading original and appending import
      cat $out/userContent-${userContentName}.css > $out/userContent.css
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
      DontCheckDefaultBrowser = true;
      DisableFeedbackCommands = true;
      DisableFirefoxScreenshots = true;
      ExtensionUpdate = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      FirefoxHome = {
        Search = true;
        Pocket = false;
        Snippets = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        SponsoredPocket = false;
      };
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      ExtensionSettings = {
        # Disable built-in search engines
        "amazondotcom@search.mozilla.org" = { installation_mode = "blocked"; };
        "bing@search.mozilla.org" = { installation_mode = "blocked"; };
        "ebay@search.mozilla.org" = { installation_mode = "blocked"; };
        "google@search.mozilla.org" = { installation_mode = "blocked"; };
        "duckduckgo@search.mozilla.org" = { installation_mode = "blocked"; };
      };
    };
    # Wait for https://github.com/NixOS/nixpkgs/pull/462094 to update
    package = (config.lib.nixGL.wrap pkgs.firefox-bin);
  };

  home.file = {
    "${profilePath}/user.js".text = combinedUserJs;
    "${profilePath}/chrome".source = whitesurTheme;
  };
}
