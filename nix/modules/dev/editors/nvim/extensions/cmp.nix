{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            snippet.expand = ''
              function(args)
                require("luasnip").lsp_expand(args.body)
              end
            '';
            mapping.__raw = ''
              cmp.mapping.preset.insert({
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
                  if require("luasnip").locally_jumpable(1) then
                    require("luasnip").jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping({
                  i = function(fallback)
                    if require("luasnip").locally_jumpable(-1) then
                      require("luasnip").jump(-1)
                    else
                      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-D>", true, true, true), "n", true)
                    end
                  end,
                  s = function(fallback)
                    if require("luasnip").locally_jumpable(-1) then
                      require("luasnip").jump(-1)
                    else
                      fallback()
                    end
                  end,
                }),
              })
            '';
            sources = [
              {
                name = "nvim_lsp";
                group_index = 1;
              }
              {
                name = "luasnip";
                group_index = 1;
              }
              {
                name = "buffer";
                group_index = 2;
              }
              {
                name = "path";
                group_index = 2;
              }
            ];
          };
          cmdline = {
            ":" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [
                {
                  name = "path";
                  group_index = 1;
                }
                {
                  name = "cmdline";
                  group_index = 2;
                }
              ];
            };
          };
        };

        plugins.luasnip = {
          enable = true;
          settings = {
            region_check_events = [
              "CursorHold"
              "InsertLeave"
              "CursorMovedI"
            ];
            delete_check_events = [
              "TextChanged"
              "InsertEnter"
            ];
          };
        };

        plugins.friendly-snippets.enable = true;

        extraConfigLua = ''
          local ls = require("luasnip")
          local s = ls.snippet
          local t = ls.text_node
          local i = ls.insert_node

          ls.add_snippets("tex", {
            s("im", { t("\\("), i(1), t("\\)"), i(0) }),
            s("dm", { t("\\["), t({ "", "\t" }), i(1), t({ "", "\\]" }), i(0) }),
          })

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
      };
    };
}
