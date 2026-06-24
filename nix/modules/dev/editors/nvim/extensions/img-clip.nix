{
  flake.modules.homeManager.nvim =
    { ... }:
    {
      programs.nixvim.plugins.img-clip = {
        enable = true;
        settings = {
          default = {
            dir_path.__raw = ''
              function()
                return "attachments/" .. vim.fn.expand("%:t:r")
              end
            '';
            file_name = "%Y-%m-%d-%H-%M-%S";
            use_absolute_path = false;
            relative_to_current_file = true;
            prompt_for_file_name = false;
            template = "![$CURSOR]($FILE_PATH)";
            insert_mode_after_paste = true;
            drag_and_drop = {
              enabled = false;
            };
            process_cmd = "convert - -resize 800x -";
          };
          filetypes = {
            markdown = {
              url_encode_path = true;
              download_images = true;
            };
            tex = {
              relative_template_path = false;
              template.__raw = ''
                [[
                \begin{figure}[h]
                  \centering
                  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
                  \caption{$CURSOR}
                  \label{fig:$LABEL}
                \end{figure}
                ]]'';
            };
            typst = {
              template.__raw = ''
                [[
                #figure(
                  image("$FILE_PATH", width: 80%),
                  caption: [$CURSOR],
                ) <fig-$LABEL>
                ]]'';
            };
          };
        };
      };

      programs.nixvim.extraConfigLua = ''
        vim.keymap.set("n", "<leader>pi", function() require("img-clip").paste_image() end, { desc = "Paste image" })
      '';
    };
}
