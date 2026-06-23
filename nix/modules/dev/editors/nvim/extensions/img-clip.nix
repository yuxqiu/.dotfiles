{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = img-clip-nvim;
          type = "lua";
          config = ''
                  require("img-clip").setup({
                    default = {
                      dir_path = function()
                        return "attachments/" .. vim.fn.expand("%:t:r")
                      end,
                      file_name = "%Y-%m-%d-%H-%M-%S",
                      use_absolute_path = false,
                      relative_to_current_file = true,
                      prompt_for_file_name = false,
                      template = "![$CURSOR]($FILE_PATH)",
                      insert_mode_after_paste = true,
                      drag_and_drop = {
                        enabled = false,
                      },
                      process_cmd = "convert - -resize 800x -",
                    },
                    filetypes = {
                      markdown = {
                        url_encode_path = true,
                        download_images = true,
                      },
                      tex = {
                        relative_template_path = false,
                        template = [[
            \begin{figure}[h]
              \centering
              \includegraphics[width=0.8\textwidth]{$FILE_PATH}
              \caption{$CURSOR}
              \label{fig:$LABEL}
            \end{figure}
                        ]],
                      },
                      typst = {
                        template = [[
            #figure(
              image("$FILE_PATH", width: 80%),
              caption: [$CURSOR],
            ) <fig-$LABEL>
                        ]],
                      },
                    },
                  })

                  vim.keymap.set("n", "<leader>pi", function() require("img-clip").paste_image() end, { desc = "Paste image" })
          '';
        }
      ];
    };
}
