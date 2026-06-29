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
        config.flake.modules.nixos.console

        # hardware
        config.flake.modules.nixos.i2c

        config.flake.modules.nixos.graphics
        config.flake.modules.nixos.tuned
        config.flake.modules.nixos.bluetooth
        config.flake.modules.nixos.fstrim
        config.flake.modules.nixos.sensor
        config.flake.modules.nixos.bolt
        config.flake.modules.nixos.thermald

        # networking
        config.flake.modules.nixos.dns
        config.flake.modules.nixos.networking
        config.flake.modules.nixos.NetworkManager
        config.flake.modules.nixos.firewall
        config.flake.modules.nixos.opensnitch
        config.flake.modules.nixos.tailscale
        config.flake.modules.nixos.vpn

        # security
        config.flake.modules.nixos.polkit
        config.flake.modules.nixos.sysctl
        config.flake.modules.nixos.coredump
        config.flake.modules.nixos.geoclue
        config.flake.modules.nixos.usbguard

        # services
        config.flake.modules.nixos.time
        config.flake.modules.nixos.earlyoom
        config.flake.modules.nixos.journald
        config.flake.modules.nixos.logind
        config.flake.modules.nixos.accountservice
        config.flake.modules.nixos.udisk2
        config.flake.modules.nixos.upower
        config.flake.modules.nixos.ios
        config.flake.modules.nixos.libinput
        config.flake.modules.nixos.fprintd
        config.flake.modules.nixos.udev

        # gaming
        config.flake.modules.nixos.steam

        # virtualization
        config.flake.modules.nixos.docker

        # desktop
        config.flake.modules.nixos.display-manager
        config.flake.modules.nixos.pipewire
        config.flake.modules.nixos.dms
        config.flake.modules.nixos.hister
        config.flake.modules.nixos.niri
        config.flake.modules.nixos.xdg
        config.flake.modules.nixos.xremap
        config.flake.modules.nixos.localsend
        config.flake.modules.nixos.gpu-screen-recorder

        # dev
        config.flake.modules.nixos.geminicommit
        config.flake.modules.nixos.nix-ld
        config.flake.modules.nixos.man

        # user
        config.flake.modules.nixos.yuxqiu
        config.flake.modules.nixos.yuxqiu-cedrus

        # backup
        config.flake.modules.nixos.restic

        # hostname
        { networking.hostName = "pc"; }
      ];
      homeManagerModules = [
        config.flake.modules.generic.base
        config.flake.modules.generic.yuxqiu-cedrus

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
        config.flake.modules.homeManager.loupe
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
        config.flake.modules.homeManager.jan
        config.flake.modules.homeManager.yuxqiu-cedrus-xremap

        # dev (ai)
        config.flake.modules.homeManager.agent-lsp
        config.flake.modules.homeManager.browser
        config.flake.modules.homeManager.harness
        config.flake.modules.homeManager.hunk
        config.flake.modules.homeManager.mcp
        config.flake.modules.homeManager.scripts
        config.flake.modules.homeManager.skills
        config.flake.modules.homeManager.agents-md
        config.flake.modules.homeManager.antigravity
        # config.flake.modules.homeManager.codex
        config.flake.modules.homeManager.devin
        config.flake.modules.homeManager.opencode
        config.flake.modules.homeManager.omp

        # dev
        config.flake.modules.homeManager.editorconfig
        config.flake.modules.homeManager.languages
        config.flake.modules.homeManager.nvim
        config.flake.modules.homeManager.zed
        config.flake.modules.homeManager.python
        config.flake.modules.homeManager.rust
        config.flake.modules.homeManager.go
        config.flake.modules.homeManager.c
        config.flake.modules.homeManager.sage
        config.flake.modules.homeManager.bash-lang
        config.flake.modules.homeManager.latex
        config.flake.modules.homeManager.lua
        config.flake.modules.homeManager.markdown
        config.flake.modules.homeManager.nix-lang
        config.flake.modules.homeManager.toml
        config.flake.modules.homeManager.typst
        config.flake.modules.homeManager.typos
        config.flake.modules.homeManager.yaml
        config.flake.modules.homeManager.typescript
        config.flake.modules.homeManager.json
        config.flake.modules.homeManager.css
        config.flake.modules.homeManager.entire
        config.flake.modules.homeManager.fence

        # networking (home-manager)
        config.flake.modules.homeManager.opensnitch
        config.flake.modules.homeManager.vpn
        config.flake.modules.homeManager.usbguard

        # nix
        config.flake.modules.homeManager.nix
        config.flake.modules.homeManager.nix-index
        config.flake.modules.homeManager.nix-update
        config.flake.modules.homeManager.hydra-check
        config.flake.modules.homeManager.nh
        config.flake.modules.homeManager.direnv
        config.flake.modules.homeManager.any-nix-shell

        # sound
        config.flake.modules.homeManager.lowfi
        config.flake.modules.homeManager.easyeffects

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
    my = {
      networking = {
        bindAddress = "100.99.246.87";
        publicHost = "cedrus.taile30f2a.ts.net";
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
    {
      config,
      pkgs,
      modulesPath,
      ...
    }:
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
      boot.kernelModules = [ "kvm-intel" ];

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

      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          configurationLimit = 5;
        };
      };

      hardware.cpu.intel.npu.enable = true;
      hardware.cpu.intel.updateMicrocode = true;

      # enable hardware decoding
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];

      # touchpad quirks, without overrides can only click but cannot move
      environment.etc."libinput/local-overrides.quirks".text = ''
        [Lenovo ThinkBook 16 G8+ IPH touchpad]
        MatchName=*GXTP5100*
        MatchDMIModalias=dmi:*svnLENOVO:*pvrThinkBook16G8+IPH*:*
        MatchUdevType=touchpad
        AttrInputProp=+INPUT_PROP_PRESSUREPAD
      '';

      sops = {
        defaultSopsFile = ../secrets/yuxqiu.yaml;
        age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
        age.generateKey = true;
      };

      # Host-specific USB device whitelist
      # Blocks all USB devices by default; only listed devices are allowed.
      # Run `lsusb` to find device IDs, then add them here.
      users.users.yuxqiu.extraGroups = [ "usbguard" ];
      services.usbguard = {
        enable = true;
        rules = ''
          allow with-interface equals { 09:00:00 }
          allow id 27c6:659a    # Goodix fingerprint sensor
          allow id 04f2:b875    # Chicony integrated camera
        '';
      };

      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale_key_cedrus".path;
      };
      sops.secrets."tailscale_key_cedrus" = {
        mode = "0400";
        owner = config.users.users.root.name;
        restartUnits = [ "tailscaled.service" ];
      };

      programs.dank-material-shell.greeter.configHome = config.users.users.yuxqiu.home;

      services.fprintd.lid-guard = {
        enable = true;
        lidPath = "LID0";
      };
    };
}
