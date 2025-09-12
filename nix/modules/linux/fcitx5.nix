{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        # For Chinese input (includes libpinyin, cloudpinyin, etc.)
        fcitx5-chinese-addons

        # For Japanese input (Mozc is recommended for accuracy)
        fcitx5-mozc

        # Optional: GTK support for better integration in GTK apps
        fcitx5-gtk

        fcitx5-configtool
      ];

      # Optional: If you're on Wayland, enable this to use the Wayland frontend
      waylandFrontend = true;

      # Optional: Declarative settings (example for basic input group setup)
      settings = {
        globalOptions = {
          Hotkey = {
            # Set trigger key to toggle input methods (e.g., Ctrl+Space)
            TriggerKeys = "Shift_L";
          };
          Appearance = {
            Theme = "material-ocean";
            # Alternatives: "material-dark", "material-deep-ocean", or "nord-dark" (if using fcitx5-nord)
          };
        };
        inputMethod = {
          GroupOrder = { "0" = "Default"; };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" =
              "us"; # US keyboard layout; change to "jp" if needed
            DefaultIM = "keyboard-us"; # Default to English
          };
          # Add English, Chinese (Pinyin), and Japanese (Mozc) to the group
          "Groups/0/Items/0" = { Name = "keyboard-us"; };
          "Groups/0/Items/1" = {
            Name = "pinyin";
          }; # From fcitx5-chinese-addons
          "Groups/0/Items/2" = { Name = "mozc"; }; # From fcitx5-mozc
        };
      };
    };
  };
}
