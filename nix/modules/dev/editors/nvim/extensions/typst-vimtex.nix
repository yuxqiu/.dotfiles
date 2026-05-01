{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = typst-vim;
          optional = true;
        }

        {
          plugin = vimtex;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local function lazy_load(pack_name, before_fn, after_fn)
          if vim.fn.exists("g:loaded_" .. pack_name) == 0 then
            if before_fn then before_fn() end
            vim.cmd("packadd " .. pack_name)
            vim.g["loaded_" .. pack_name] = 1
            if after_fn then after_fn() end
          end
        end

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "typst",
          callback = function()
            lazy_load("typst.vim", function()
              vim.g.typst_auto_compile = 0
              vim.g.typst_pdf_viewer = "sioyek"
            end, nil)
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "tex", "latex", "bib" },
          callback = function()
            lazy_load("vimtex", function()
              vim.g.vimtex_view_method = "sioyek"
              vim.g.vimtex_compiler_method = "tectonic"
              vim.g.vimtex_compiler_tectonic = {
                options = { "--synctex", "--keep-logs", "--keep-intermediates" },
              }
              vim.g.tex_flavor = "latex"
              vim.g.vimtex_quickfix_mode = 2
            end, nil)
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typst", "tex", "latex" },
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end,
        })
      '';
    };
}
