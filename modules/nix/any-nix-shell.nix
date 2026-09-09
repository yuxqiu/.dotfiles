{
  flake.modules.homeManager.any-nix-shell = { pkgs, ... }: {
    programs.zsh.initContent = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
