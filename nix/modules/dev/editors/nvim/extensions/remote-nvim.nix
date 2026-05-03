{
  flake.modules.homeManager.base =
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

      programs.neovim = {
        extraPackages = with pkgs; [ rsync ];
        plugins = [
          {
            plugin = remote-nvim-nvim-patched;
            optional = true;
          }
        ];
        initLua = ''
          local function load_remote_nvim()
            lazy_load("remote-nvim.nvim", nil, function()
              require("remote-nvim").setup({
                offline_mode = { enabled = true, no_github = false },
                remote = {
                  app_name = "nvim",
                  copy_dirs = {
                    config = {
                      base = vim.fn.stdpath("config"),
                      dirs = "*",
                      compression = { enabled = true, additional_opts = { "--dereference" } },
                    },
                    data = {
                      base = vim.fn.stdpath("data"),
                      dirs = { "site" },
                      compression = { enabled = true, additional_opts = { "--dereference" } },
                    },
                  },
                },
                ssh_config = { scp_binary = "rsync" },
                client_callback = function(port, _)
                  if vim.fn.has("mac") == 1 then
                    os.execute(("open -a Terminal nvim --server localhost:%s --remote-ui &"):format(port))
                  else
                    os.execute(("xdg-terminal-exec nvim --server localhost:%s --remote-ui &"):format(port))
                  end
                end,
              })
            end)
          end

          vim.keymap.set("n", "<leader>Rs", function() load_remote_nvim(); vim.cmd("RemoteStart") end, { desc = "Remote start" })
          vim.keymap.set("n", "<leader>Ri", function() load_remote_nvim(); vim.cmd("RemoteInfo") end, { desc = "Remote info" })
          vim.keymap.set("n", "<leader>Rc", function() load_remote_nvim(); vim.cmd("RemoteCleanup") end, { desc = "Remote cleanup" })
          vim.keymap.set("n", "<leader>Rd", function() load_remote_nvim(); vim.cmd("RemoteConfigDel") end, { desc = "Remote config delete" })
        '';
      };

    };
}