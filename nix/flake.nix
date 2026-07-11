{
  description = "yuxqiu's dotfiles";

  inputs = {
    # Common
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/triplet";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      # stylix uses nix-systems/default which includes x86_64-darwin.
      # Its modules use self' which forces perSystem evaluation for all
      # systems, failing on nixpkgs 26.11+ (dropped x86_64-darwin).
      inputs.systems.url = "github:nix-systems/triplet";
    };
    ssh-agent-ac = {
      url = "github:yuxqiu/ssh-agent-ac?ref=v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tun2proxy = {
      url = "github:yuxqiu/tun2proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-update-git = {
      url = "github:yuxqiu/nix-update-git?ref=v0.6.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      url = "github:modem-dev/hunk?ref=v0.17.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.bun2nix.inputs.systems.url = "github:nix-systems/triplet";
    };
    omp = {
      url = "github:yuxqiu/omp-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=v0.7.0";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    handy = {
      url = "github:cjpais/Handy?ref=v0.9.1";
      inputs.nixpkgs.follows = "nixpkgs";
      # bun2nix (transitive dep) uses nix-systems/default which includes
      # x86_64-darwin. Its build-package.nix forces flake-parts perSystem
      # evaluation for all systems, which fails on nixpkgs 26.11+ (dropped
      # x86_64-darwin). Restrict to the same triplet we support.
      inputs.bun2nix.inputs.systems.url = "github:nix-systems/triplet";
    };
    fingerprint-lid-guard = {
      url = "github:TimP4w/nix-fingerprint-lid-guard";
    };
    quicksnip = {
      url = "github:yuxqiu/quicksnip-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hister = {
      url = "github:asciimoo/hister?ref=v0.16.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    paseo = {
      url = "github:getpaseo/paseo?ref=v0.2.0-rc.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./modules
        ./profiles
      ]
    );
}
