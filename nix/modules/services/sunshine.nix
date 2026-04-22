# disabled at the moment till the release of version with bind_address support
{
}
# {
#   flake.modules.homeManager.linux-desktop =
#     {
#       config,
#       lib,
#       pkgs,
#       ...
#     }:
#     let
#       sunshineSettings = {
#         controller = "disabled";
#         origin_web_ui_allowed = "pc";
#         bind_address = "127.0.0.1";
#       };
#       settingsFormat = pkgs.formats.keyValue { };
#       configFile = settingsFormat.generate "sunshine.conf" sunshineSettings;
#     in
#     {
#       # Modified from nixos/modules/services/networking/sunshine.nix
#       # Needed because system-manager does not support systemd.user yet
#       systemd.user.services.sunshine = lib.mkIf config.my.system.isSystemManager {
#         Unit = {
#           Description = "Self-hosted game stream host for Moonlight";
#           PartOf = [ "graphical-session.target" ];
#           Wants = [ "graphical-session.target" ];
#           After = [ "graphical-session.target" ];
#           StartLimitIntervalSec = 500;
#           StartLimitBurst = 5;
#         };

#         Install = {
#           WantedBy = [ "graphical-session.target" ];
#         };

#         Service = {
#           ExecStart = "/run/wrappers/bin/sunshine ${configFile}";
#           Restart = "on-failure";
#           RestartSec = "5s";
#         };
#       };
#     };

#   flake.modules.systemManager.desktop =
#     {
#       nixosModulesPath,
#       lib,
#       pkgs,
#       ...
#     }:
#     let
#       # the upstream does not provide bind_address support
#       # so have to override it here.
#       sunshineLatest = pkgs.sunshine.overrideAttrs (old: {
#         src = pkgs.fetchFromGitHub {
#           owner = "LizardByte";
#           repo = "Sunshine";
#           rev = "ba4db46ac0bfbe478ad017f0b388bfcb346ad8ce";
#           hash = "sha256-Zey35IaVeW3Jo2bzRf3j0ne4FdHySCpnLz6depLM/Rk=";
#           fetchSubmodules = true;
#         };
#       });
#     in
#     {
#       options = {
#         services.avahi = lib.mkOption {
#           type = lib.types.raw;
#         };
#         systemd.user.services.sunshine = lib.mkOption {
#           type = lib.types.raw;
#         };
#       };

#       imports = [ (nixosModulesPath + "/services/networking/sunshine.nix") ];

#       config = {
#         services.sunshine = {
#           enable = true;
#           openFirewall = false;
#           capSysAdmin = true;
#           package = sunshineLatest;
#         };

#         services.tailscale.serveHttpsTargets = {
#           "47990" = "tcp://127.0.0.1:47990";
#         };
#       };
#     };
# }
