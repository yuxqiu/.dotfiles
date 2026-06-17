{
  flake.modules.nixos.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-system-composer";
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = false;
    };
  };
}
