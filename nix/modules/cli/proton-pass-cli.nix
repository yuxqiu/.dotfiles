{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ proton-pass-cli ];

      programs.zsh.siteFunctions.pass-ssh = ''
        if ! pass-cli test &>/dev/null; then
          pass-cli login || return 1
        fi

        pass-cli ssh-agent load
        pass-cli logout
      '';
    };
}
