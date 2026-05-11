{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        friendly-snippets

        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            luasnip.setup({
              region_check_events = { "CursorHold", "InsertLeave", "CursorMovedI" },
              delete_check_events = { "TextChanged", "InsertEnter" },
            })

            cmp.setup({
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-j>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<C-k>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping({
                  i = function(fallback)
                    if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-D>", true, true, true), "n", true)
                    end
                  end,
                  s = function(fallback)
                    if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end,
                }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
              }, {
                { name = "buffer" },
                { name = "path" },
              }),
            })

            cmp.setup.cmdline(":", {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = "path" },
              }, {
                { name = "cmdline" },
              }),
            })
          '';
        }

        {
          plugin = luasnip;
          type = "lua";
          config = ''
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            ls.add_snippets("latex", {
              s("im", { t("\\("), i(1), t("\\)"), i(0) }),
              s("dm", { t("\\["), t({ "", "\t" }), i(1), t({ "", "\\]" }), i(0) }),
            })

            ls.add_snippets("markdown", {
              s("im", { t("$"), i(1), t("$"), i(0) }),
              s("dm", { t({ "$$", "" }), i(1), t({ "", "$$" }), i(0) }),
            })

            ls.add_snippets("typst", {
              s("im", { t("$"), i(1), t("$"), i(0) }),
              s("dm", { t({ "$$", "" }), i(1), t({ "", "$$" }), i(0) }),
            })
          '';
        }
      ];
    };
}
