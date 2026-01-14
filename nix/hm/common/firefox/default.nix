{ ... }:

let
  profileName = "default"; # Replace with your actual profile name

  # Prepare user.js
  arkenfoxUserJs = "${
    fetchGit {
      url = "https://github.com/arkenfox/user.js/";
      rev = "0f14e030b3a9391e761c03ce3c260730a78a4db6";
    }
  }/user.js";
  userOverrides = builtins.readFile ./user-override.js;

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
      userChrome = builtins.readFile ./customChrome.css;
      userContent = builtins.readFile ./customContent.css;
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
  stylix.targets.firefox.colorTheme.enable = true;
}
