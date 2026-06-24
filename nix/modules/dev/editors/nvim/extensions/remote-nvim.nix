{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    let
      remote-nvim-nvim-patched = pkgs.vimPlugins.remote-nvim-nvim.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          cd $out/scripts
          awk '
          /actual_checksum=.*expected_checksum-actual.*This ensures/ { line1 = $0; next }
          /expected_checksum=\$\(get_sha256/ { print; print line1; line1 = ""; next }
          { if (line1 != "") print line1; print }
          ' neovim_download.sh > neovim_download.sh.tmp && mv neovim_download.sh.tmp neovim_download.sh
          chmod +x neovim_download.sh
        '';
        postFixup = (old.postFixup or "") + ''
          sed -i 's/return ("nvim-%s-linux-%s.appimage"):format(version, arch)/return ("nvim-linux-" .. arch .. ".appimage")/' \
            $out/lua/remote-nvim/providers/utils.lua
          sed -i 's/return ("nvim-%s-linux.appimage"):format(version)/return ("nvim-linux.appimage")/' \
            $out/lua/remote-nvim/providers/utils.lua
          sed -i 's/return ("nvim-%s-macos-%s.tar.gz"):format(version, arch)/return ("nvim-macos-" .. arch .. ".tar.gz")/' \
            $out/lua/remote-nvim/providers/utils.lua
          sed -i 's/return ("nvim-%s-macos.tar.gz"):format(version)/return ("nvim-macos.tar.gz")/' \
            $out/lua/remote-nvim/providers/utils.lua
        '';
        nvimSkipModules = [
          "lazy"
          "repro"
        ];
      });
    in
    {
      programs.nixvim = {
        extraPackages = with pkgs; [ rsync ];

        plugins.remote-nvim = {
          enable = true;
          package = remote-nvim-nvim-patched;
          lazyLoad.settings.keys = [
            {
              __unkeyed-1 = "<leader>Rs";
              __unkeyed-2 = "<cmd>RemoteStart<CR>";
              desc = "Remote start";
            }
            {
              __unkeyed-1 = "<leader>Ri";
              __unkeyed-2 = "<cmd>RemoteInfo<CR>";
              desc = "Remote info";
            }
            {
              __unkeyed-1 = "<leader>Rc";
              __unkeyed-2 = "<cmd>RemoteCleanup<CR>";
              desc = "Remote cleanup";
            }
            {
              __unkeyed-1 = "<leader>Rd";
              __unkeyed-2 = "<cmd>RemoteConfigDel<CR>";
              desc = "Remote config delete";
            }
          ];
          settings = {
            offline_mode = {
              enabled = true;
              no_github = false;
            };
            remote = {
              app_name = "nvim";
              copy_dirs = {
                config = {
                  base.__raw = ''vim.fn.stdpath("config")'';
                  dirs = "*";
                  compression = {
                    enabled = true;
                    additional_opts = [ "--dereference" ];
                  };
                };
                data = {
                  base.__raw = ''vim.fn.stdpath("data")'';
                  dirs = [ "site" ];
                  compression = {
                    enabled = true;
                    additional_opts = [ "--dereference" ];
                  };
                };
              };
            };
            ssh_config.scp_binary = "rsync";
            client_callback.__raw = ''
              function(port, _)
                if vim.fn.has("mac") == 1 then
                  os.execute(("open -a Terminal nvim --server localhost:%s --remote-ui &"):format(port))
                else
                  os.execute(("xdg-terminal-exec nvim --server localhost:%s --remote-ui &"):format(port))
                end
              end
            '';
          };
        };
      };
    };
}
