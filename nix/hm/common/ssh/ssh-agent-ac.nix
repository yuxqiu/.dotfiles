{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh-agent-ac;
  sshAgentAc = cfg.package;
  realSshAgent = "${pkgs.openssh}/bin/ssh-agent";

  # Determine the path to the ssh-askpass program
  askpassPath =
    if cfg.sshAskpass == null then
      null
    else if lib.isDerivation cfg.sshAskpass then
      "${cfg.sshAskpass}/bin/ssh-askpass"
    else
      cfg.sshAskpass; # absolute path

  askpassEnv = lib.optionalAttrs (askpassPath != null) {
    SSH_ASKPASS = askpassPath;
  };
in
{
  options.services.ssh-agent-ac = {
    enable = lib.mkEnableOption "ssh-agent with per-use confirmation via ssh-agent-ac";

    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The ssh-agent-ac package from your flake (provides bin/ssh-agent-ac).
      '';
      example = "self.packages.\${pkgs.system}.ssh-agent-ac";
    };

    socket = lib.mkOption {
      type = lib.types.str;
      default = "ssh-agent";
      example = "ssh-agent/socket";
      description = ''
        The agent's socket suffix (appended to $XDG_RUNTIME_DIR on Linux or DARWIN_USER_TEMP_DIR on macOS).
      '';
    };

    defaultMaximumIdentityLifetime = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      example = 3600;
      description = "Default maximum lifetime for identities (-t).";
    };

    sshAskpass = lib.mkOption {
      type = lib.types.either lib.types.package lib.types.path;
      description = ''
        The ssh-askpass program to use for passphrase prompts.
        Must be either a package (derivation) containing the askpass binary
        or an absolute path to the program.

        This option is required when services.ssh-agent-ac.enable = true.
      '';
      example = "pkgs.x11_ssh_askpass";
    };

    enableBashIntegration = lib.mkEnableOption "bash integration" // {
      default = true;
    };
    enableZshIntegration = lib.mkEnableOption "zsh integration" // {
      default = true;
    };
    enableFishIntegration = lib.mkEnableOption "fish integration" // {
      default = true;
    };
    enableNushellIntegration = lib.mkEnableOption "nushell integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package != null;
        message = "services.ssh-agent-ac.package must be set to your ssh-agent-ac package.";
      }
      {
        assertion = cfg.sshAskpass != null;
        message = "services.ssh-agent-ac.sshAskpass is required when the service is enabled. Set it to a package (e.g. pkgs.x11_ssh_askpass) or an absolute path to an ssh-askpass program.";
      }
    ];

    programs =
      let
        socketPath =
          if pkgs.stdenv.isDarwin then
            "$(${lib.getExe pkgs.getconf} DARWIN_USER_TEMP_DIR)/${cfg.socket}"
          else
            "$XDG_RUNTIME_DIR/${cfg.socket}";

        bashIntegration = ''
          if [ -z "$SSH_AUTH_SOCK" ]; then
            export SSH_AUTH_SOCK=${socketPath}
          fi
        '';

        fishIntegration = ''
          if test -z "$SSH_AUTH_SOCK"
            set -x SSH_AUTH_SOCK ${socketPath}
          end
        '';

        nushellIntegration =
          if pkgs.stdenv.isDarwin then
            ''
              if "SSH_AUTH_SOCK" not-in $env {
                $env.SSH_AUTH_SOCK = $"(${lib.getExe pkgs.getconf} DARWIN_USER_TEMP_DIR)/${cfg.socket}"
              }
            ''
          else
            ''
              if "SSH_AUTH_SOCK" not-in $env {
                $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/${cfg.socket}"
              }
            '';
      in
      {
        bash.profileExtra = lib.mkIf cfg.enableBashIntegration (lib.mkOrder 900 bashIntegration);
        zsh.envExtra = lib.mkIf cfg.enableZshIntegration (lib.mkOrder 900 bashIntegration);
        fish.shellInit = lib.mkIf cfg.enableFishIntegration (lib.mkOrder 900 fishIntegration);
        nushell.extraEnv = lib.mkIf cfg.enableNushellIntegration (lib.mkOrder 900 nushellIntegration);
      };

    systemd.user.services.ssh-agent-ac = lib.mkIf pkgs.stdenv.isLinux {
      Install.WantedBy = [ "graphical-session.target" ]; # Changed from default.target

      Unit = {
        Description = "SSH authentication agent with confirmation";
        Documentation = "man:ssh-agent(1)";
        # Ensure it starts after the graphical session is up
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service =
        let
          lifetimeArg = lib.optionalString (
            cfg.defaultMaximumIdentityLifetime != null
          ) "-t ${toString cfg.defaultMaximumIdentityLifetime}";
        in
        {
          Environment = lib.mapAttrsToList (n: v: "${n}=${v}") askpassEnv;
          ExecStart = "${sshAgentAc}/bin/ssh-agent-ac -s %t/${cfg.socket} -a ${realSshAgent} -- ${lifetimeArg}";
        };
    };

    launchd.agents.ssh-agent-ac = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments =
          let
            socketPathCmd = "$(${lib.getExe pkgs.getconf} DARWIN_USER_TEMP_DIR)/${cfg.socket}";
            lifetimeArg = lib.optionalString (
              cfg.defaultMaximumIdentityLifetime != null
            ) "-t ${toString cfg.defaultMaximumIdentityLifetime}";

            envExports = lib.concatStringsSep " " (lib.mapAttrsToList (n: v: "${n}=${v}") askpassEnv);

            cmdPrefix = if envExports == "" then "" else "${envExports} ";
          in
          [
            (lib.getExe pkgs.bash)
            "-c"
            ''${cmdPrefix}${sshAgentAc}/bin/ssh-agent-ac -s ${socketPathCmd} -a ${realSshAgent} -- ${lifetimeArg}''
          ];

        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
        RunAtLoad = true;
      };
    };
  };
}
