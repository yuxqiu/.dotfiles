{
  flake.modules.systemManager.base = {
    environment.etc = {
      "sysctl.d/99-my-hardening.conf" = {
        text = ''
          kernel.kptr_restrict = 2
          net.core.bpf_jit_harden = 2
          dev.tty.ldisc_autoload = 0

          # File protections in shared dirs
          fs.protected_fifos = 2
          fs.protected_regular = 2
          fs.suid_dumpable = 0

          # Disable SysRq key (magic system request)
          kernel.sysrq = 0
        '';
        mode = "0644";
      };
    };
  };
}
