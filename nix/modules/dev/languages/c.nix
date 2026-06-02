{
  flake.modules.homeManager.c =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        clang
        cmake
      ];
    };
}
