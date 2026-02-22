{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      profileName = "default";

      # Prepare user.js
      arkenfoxUserJs = "${
        pkgs.fetchFromGitHub {
          owner = "arkenfox";
          repo = "user.js";
          rev = "0f14e030b3a9391e761c03ce3c260730a78a4db6";
          hash = "sha256-LPDiiEPOZu5Ah5vCLyCMT3w1uoBhUjyqoPWCOiLVLnw=";
        }
      }/user.js";
      userOverrides = builtins.readFile ./user-override.js;

      firefox-mod-blur = pkgs.fetchFromGitHub {
        owner = "datguypiko";
        repo = "Firefox-Mod-Blur";
        rev = "25425c6db933da9dcc37c36991fb3942874da6b7";
        hash = "sha256-O0gVK6xwvHseuX5B+lp5oEhg/81O4p+tR32Pc9bszDw=";
      };

      # Prepare userChrome.css
      userChrome = builtins.concatStringsSep "\n" [
        (builtins.readFile ./css/chrome/blur.css)
        (builtins.readFile ./css/chrome/container.css)
        (builtins.readFile ./css/chrome/menupopup.css)
        (builtins.readFile "${firefox-mod-blur}/EXTRA MODS/Privacy mods/Blur Username in main menu/privacy_blur_email_in_main_menu.css")
        (builtins.readFile "${firefox-mod-blur}/EXTRA MODS/Compact extensions menu/Style 1/With no settings wheel icon/cleaner_extensions_menu.css")
        (builtins.readFile "${firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/uBlock icon change/ublock-icon-change.css")
      ];

      # Prepare userContent.css
      userContent = builtins.concatStringsSep "\n" [
        (builtins.readFile ./css/content/home.css)
        (builtins.readFile "${firefox-mod-blur}/EXTRA MODS/Homepage mods/Remove text from homepage shortcuts/remove_homepage_shortcut_title_text.css")
      ];

    in
    {
      # Enable Firefox and define profiles
      programs.firefox = {
        enable = true;
        profiles.${profileName} = {
          isDefault = true;

          # stylix: prevent auto disabling extensions installed inside firefox
          # https://github.com/nix-community/home-manager/issues/6398#issuecomment-2958982664
          settings = {
            extensions.autoDisableScopes = 0;
            extensions.update.autoUpdateDefault = false;
            extensions.update.enabled = false;
          };
          extensions = {
            force = true;
          };

          # user.js
          preConfig = arkenfoxUserJs;
          extraConfig = userOverrides;

          # userChrome and userContent
          userChrome = userChrome;
          userContent = userContent;
        };
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
            "amazondotcom@search.mozilla.org" = {
              installation_mode = "blocked";
            };
            "bing@search.mozilla.org" = {
              installation_mode = "blocked";
            };
            "ebay@search.mozilla.org" = {
              installation_mode = "blocked";
            };
            "google@search.mozilla.org" = {
              installation_mode = "blocked";
            };
            "duckduckgo@search.mozilla.org" = {
              installation_mode = "blocked";
            };
          };
        };
      };

      # stylix
      stylix.targets.firefox.profileNames = [ profileName ];
    };
}
