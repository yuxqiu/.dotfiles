{
  flake.modules.nixos.sysctl = {
    boot.kernel.sysctl = {
      "kernel.kptr_restrict" = 2;
      "net.core.bpf_jit_harden" = 2;
      "dev.tty.ldisc_autoload" = 0;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.suid_dumpable" = 0;
      "kernel.sysrq" = 0;
    };
  };
}
