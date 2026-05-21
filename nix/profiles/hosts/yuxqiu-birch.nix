{
  config,
  ...
}:

{
  configurations.homeManager = {
    "yuxqiu-birch" = {
      system = "aarch64-linux";
      username = "yuxqiu";
      homeDirectory = "/home/yuxqiu";
      stateVersion = "26.05";
      modules = [
        config.flake.modules.generic.base
        config.flake.modules.generic.yuxqiu-birch

        # base
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.base-linux
        config.flake.modules.homeManager.base-linux-desktop

        # cli
        config.flake.modules.homeManager.fzf
        config.flake.modules.homeManager.session
        config.flake.modules.homeManager.bash
        config.flake.modules.homeManager.zsh
        config.flake.modules.homeManager.ssh
        config.flake.modules.homeManager.ssh-copy-id
        config.flake.modules.homeManager.ssh-agent
        config.flake.modules.homeManager.git
        config.flake.modules.homeManager.gh
        config.flake.modules.homeManager.jj
        config.flake.modules.homeManager.proton-pass-cli

        # desktop
        config.flake.modules.homeManager.firefox
        config.flake.modules.homeManager.captive-browser
        config.flake.modules.homeManager.ghostty
        config.flake.modules.homeManager.dms
        config.flake.modules.homeManager.dolphin
        config.flake.modules.homeManager.fcitx5
        config.flake.modules.homeManager.flatpak
        config.flake.modules.homeManager.handy
        config.flake.modules.homeManager.hister
        config.flake.modules.homeManager.idescriptor
        config.flake.modules.homeManager.kanshi
        config.flake.modules.homeManager.llama
        config.flake.modules.homeManager.localsend
        config.flake.modules.homeManager.loupe
        config.flake.modules.homeManager.mime-apps
        config.flake.modules.homeManager.niri
        config.flake.modules.homeManager.obs
        config.flake.modules.homeManager.pointer
        config.flake.modules.homeManager.quicksnip
        config.flake.modules.homeManager.sioyek
        config.flake.modules.homeManager.stylix
        config.flake.modules.homeManager.gtk
        config.flake.modules.homeManager.qt
        config.flake.modules.homeManager.tolaria
        config.flake.modules.homeManager.wayscriber
        config.flake.modules.homeManager.wlr-which-key
        config.flake.modules.homeManager.xdg
        config.flake.modules.homeManager.xremap

        # dev
        config.flake.modules.homeManager.ai
        config.flake.modules.homeManager.editorconfig
        config.flake.modules.homeManager.lsp
        config.flake.modules.homeManager.nvim
        config.flake.modules.homeManager.vscode
        config.flake.modules.homeManager.zed
        config.flake.modules.homeManager.python
        config.flake.modules.homeManager.rust

        # hardware (home-manager)
        config.flake.modules.homeManager.earlyoom
        config.flake.modules.homeManager.systemd
        config.flake.modules.homeManager.vpn

        # networking (home-manager)
        config.flake.modules.homeManager.opensnitch
        config.flake.modules.homeManager.tailscale

        # nix
        config.flake.modules.homeManager.nix
        config.flake.modules.homeManager.nix-index
        config.flake.modules.homeManager.nix-update
        config.flake.modules.homeManager.hydra-check
        config.flake.modules.homeManager.nixpkgs-track

        # services (home-manager)
        config.flake.modules.homeManager.activitywatch

        # sound
        config.flake.modules.homeManager.lowfi

        # virtualization (home-manager)
        config.flake.modules.homeManager.docker
        config.flake.modules.homeManager.distrobox

        # fonts
        config.flake.modules.homeManager.fonts

        # user
        config.flake.modules.homeManager.yuxqiu
      ];
    };
  };

  configurations.systemManager = {
    "yuxqiu-birch" = {
      system = "aarch64-linux";
      modules = [
        config.flake.modules.generic.base
        config.flake.modules.generic.yuxqiu-birch

        # base
        config.flake.modules.systemManager.base

        # hardware
        config.flake.modules.systemManager.i2c
        config.flake.modules.systemManager.powertop
        config.flake.modules.systemManager.udev
        config.flake.modules.systemManager.graphics
        config.flake.modules.systemManager.tuned

        # networking
        config.flake.modules.systemManager.dns
        config.flake.modules.systemManager.networking
        config.flake.modules.systemManager.NetworkManager
        config.flake.modules.systemManager.opensnitch
        config.flake.modules.systemManager.tailscale
        config.flake.modules.systemManager.vpn

        # security
        config.flake.modules.systemManager.polkit
        config.flake.modules.systemManager.pam
        config.flake.modules.systemManager.sysctl

        # services
        config.flake.modules.systemManager.abort
        config.flake.modules.systemManager.dbus
        config.flake.modules.systemManager.earlyoom
        config.flake.modules.systemManager.journald
        config.flake.modules.systemManager.accountservice
        config.flake.modules.systemManager.backup
        config.flake.modules.systemManager.backup-home
        config.flake.modules.systemManager.backup-ios
        config.flake.modules.systemManager.udisk2
        config.flake.modules.systemManager.upower
        config.flake.modules.systemManager.usbmuxd

        # virtualization
        config.flake.modules.systemManager.docker

        # desktop
        config.flake.modules.systemManager.display-manager
        config.flake.modules.systemManager.dms
        config.flake.modules.systemManager.hister
        config.flake.modules.systemManager.niri
        config.flake.modules.systemManager.xdg
        config.flake.modules.systemManager.xremap

        # dev
        config.flake.modules.systemManager.paseo
        config.flake.modules.systemManager.geminicli

        # user
        config.flake.modules.systemManager.yuxqiu
        config.flake.modules.systemManager.yuxqiu-birch
      ];
    };
  };

  flake.modules.generic.yuxqiu-birch = {
    my.sops.enable = true;
    my = {
      system.isSystemManager = true;
      networking = {
        bindAddress = "100.108.78.86";
        publicHost = "pc.taile30f2a.ts.net";
      };
      kanshi.externalMonitorName = "Dell Inc. DELL S2725QS 95HL364";
      xremap.internalKeyboardName = "Apple SPI Keyboard";
    };
  };

  flake.modules.systemManager.yuxqiu-birch =
    { config, lib, ... }:
    {
      sops = lib.mkIf config.my.sops.enable {
        defaultSopsFile = ../secrets/yuxqiu.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        age.generateKey = true;
      };

      # dms-greeter uses its theme from a user's dir so we need
      # to specify that user.
      programs.dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = config.users.users.yuxqiu.home;
      };

      services.tailscale.enable = true;
    };
}
