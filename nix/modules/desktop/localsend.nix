{
  flake.modules.homeManager.localsend =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        localsend
      ];

      home.file.".local/share/kio/servicemenus/localsend.desktop" = lib.mkIf pkgs.stdenv.isLinux {
        text = ''
          [Desktop Entry]
          Type=Service
          MimeType=application/octet-stream;inode/directory;
          Actions=shareWithLocalSend

          [Desktop Action shareWithLocalSend]
          Name=Share with LocalSend
          Icon=localsend
          Exec=${lib.getExe pkgs.localsend} %U
        '';
        executable = true;
      };
    };
}
