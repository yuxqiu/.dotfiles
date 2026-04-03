{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        localsend
      ];
    };

  flake.modules.homeManager.linux-desktop =
    { pkgs, lib, ... }:
    {
      home.file.".local/share/kio/servicemenus/localsend.desktop" = {
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
