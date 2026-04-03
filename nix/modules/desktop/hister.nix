{ inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports = [ inputs.hister.homeModules.hister ];

    services.hister = {
      enable = true;
      config = {
        app = {
          search_url = "https://duckduckgo.com/?q={query}";
          log_level = "info";
          open_results_on_new_tab = true;
        };
        server = {
          address = "127.0.0.1:4433";
          database = "db.sqlite3";
        };
        indexer = {
          detect_languages = true;
          directories = {
            path = "~/Documents/notes";
            filetypes = [ "md" ];
            excludes = [ "*secret*" ];
          };
        };
        hotkeys.web = {
          "/" = "focus_search_input";
          "enter" = "open_result";
          "ctrl+1" = "select_next_result";
          "ctrl+2" = "open_query_in_search_engine";
          "ctrl+3" = "select_previous_result";
          "tab" = "autocomplete";
          "?" = "show_hotkeys";
        };
        sensitive_content_patterns = {
          aws_access_key = "AKIA[0-9A-Z]{16}";
          github_token = "(ghp|gho|ghu|ghs|ghr)_[a-zA-Z0-9]{36}";
        };
      };
    };

    programs.firefox.policies = {
      # Install hister firefox extension
      ExtensionSettings = {
        "{f0bda7ce-0cda-42dc-9ea8-126b20fed280}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{f0bda7ce-0cda-42dc-9ea8-126b20fed280}/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
      Add = [
        {
          Name = "hister";
          URLTemplate = "http://127.0.0.1:4433/?q={searchTerms}";
          IconURL = "http://127.0.0.1:4433/static/logo.png";
          Alias = "hister";
        }
      ];
    };
  };
}
