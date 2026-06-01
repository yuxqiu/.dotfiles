{
  config,
  ...
}:

{
  configurations.nixos = {
    "yuxqiu-cedrus" = {
      system = "x86_64-linux";
      username = "yuxqiu";
      homeStateVersion = "26.11";
      nixosStateVersion = "26.11";
      modules = [
        config.flake.modules.generic.base
        config.flake.modules.generic.yuxqiu-cedrus

        # base
        config.flake.modules.nixos.base

        # hardware
        config.flake.modules.nixos.i2c
        config.flake.modules.nixos.powertop
        config.flake.modules.nixos.graphics
        config.flake.modules.nixos.tuned
        config.flake.modules.nixos.bluetooth

        # networking
        config.flake.modules.nixos.dns
        config.flake.modules.nixos.networking
        config.flake.modules.nixos.NetworkManager
        config.flake.modules.nixos.opensnitch
        config.flake.modules.nixos.tailscale
        config.flake.modules.nixos.vpn

        # security
        config.flake.modules.nixos.polkit
        config.flake.modules.nixos.sysctl

        # services
        config.flake.modules.nixos.earlyoom
        config.flake.modules.nixos.journald
        config.flake.modules.nixos.accountservice
        config.flake.modules.nixos.udisk2
        config.flake.modules.nixos.upower
        config.flake.modules.nixos.usbmuxd
        config.flake.modules.nixos.libinput
        config.flake.modules.nixos.fprintd

        # virtualization
        config.flake.modules.nixos.docker

        # desktop
        config.flake.modules.nixos.display-manager
        config.flake.modules.nixos.dms
        config.flake.modules.nixos.hister
        config.flake.modules.nixos.niri
        config.flake.modules.nixos.xdg
        config.flake.modules.nixos.xremap

        # dev
        config.flake.modules.nixos.geminicli

        # user
        config.flake.modules.nixos.yuxqiu
        config.flake.modules.nixos.yuxqiu-cedrus

        # sops
        config.flake.modules.nixos.backup
        config.flake.modules.nixos.backup-home

        # hostname
        { networking.hostName = "pc"; }

        # hardware config
        (
          { modulesPath, ... }:
          {
            imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

            boot.initrd.availableKernelModules = [
              "xhci_pci"
              "thunderbolt"
              "nvme"
              "usb_storage"
              "sd_mod"
              "rtsx_pci_sdmmc"
            ];
            boot.initrd.kernelModules = [ ];
            boot.kernelModules = [ "kvm-intel" ];
            boot.extraModulePackages = [ ];

            fileSystems."/" = {
              device = "/dev/disk/by-uuid/142862d6-6393-4cf8-92e1-1e61a9cea266";
              fsType = "ext4";
            };

            fileSystems."/boot" = {
              device = "/dev/disk/by-uuid/EC63-2A5C";
              fsType = "vfat";
              options = [
                "fmask=0077"
                "dmask=0077"
              ];
            };

            swapDevices = [ ];

            hardware.cpu.intel.npu.enable = true;
            hardware.cpu.intel.updateMicrocode = true;

            boot.loader = {
              efi.canTouchEfiVariables = true;
              grub = {
                efiSupport = true;
                device = "nodev";
                useOSProber = true;
              };
            };

            environment.etc."libinput/local-overrides.quirks".text = ''
              [Lenovo ThinkBook 16 G8+ IPH touchpad]
              MatchName=*GXTP5100*
              MatchDMIModalias=dmi:*svnLENOVO:*pvrThinkBook16G8+IPH*:*
              MatchUdevType=touchpad
              AttrInputProp=+INPUT_PROP_PRESSUREPAD
            '';
          }
        )
      ];
      homeManagerModules = [
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
        config.flake.modules.homeManager.wayscriber
        config.flake.modules.homeManager.wlr-which-key
        config.flake.modules.homeManager.xdg
        config.flake.modules.homeManager.xremap
        config.flake.modules.homeManager.yuxqiu-cedrus-xremap

        # dev
        config.flake.modules.homeManager.ai
        config.flake.modules.homeManager.editorconfig
        config.flake.modules.homeManager.lsp
        config.flake.modules.homeManager.nvim
        config.flake.modules.homeManager.zed
        config.flake.modules.homeManager.python
        config.flake.modules.homeManager.rust

        # hardware (home-manager)
        config.flake.modules.homeManager.vpn

        # networking (home-manager)
        config.flake.modules.homeManager.opensnitch

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

  flake.modules.generic.yuxqiu-cedrus = {
    my.sops.enable = true;
    my = {
      username = "yuxqiu";
      networking = {
        bindAddress = "100.108.78.86";
        publicHost = "pc.taile30f2a.ts.net";
      };
    };
  };

  flake.modules.homeManager.yuxqiu-cedrus-xremap = {
    services.xremap.config.modmap = [
      {
        name = "internal-keyboard-remaps";
        device.only = [ "AT Translated Set 2 keyboard" ];
        remap = {
          "KEY_LEFTMETA" = "KEY_LEFTALT";
          "KEY_LEFTALT" = "KEY_LEFTCTRL";
          "KEY_CAPSLOCK" = "KEY_ESC";
          "KEY_ESC" = "KEY_CAPSLOCK";
        };
      }
    ];
  };

  flake.modules.nixos.yuxqiu-cedrus =
    { config, lib, ... }:
    {
      sops = lib.mkIf config.my.sops.enable {
        defaultSopsFile = ../secrets/yuxqiu.yaml;
        age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
        age.generateKey = true;
      };

      services.tailscale.enable = true;

      # dms-greeter uses its theme from a user's dir
      programs.dank-material-shell.greeter.configHome = config.users.users.yuxqiu.home;
    };
}
