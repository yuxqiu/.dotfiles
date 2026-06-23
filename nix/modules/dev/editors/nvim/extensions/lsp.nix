{
  flake.modules.homeManager.nvim =
    { pkgs, config, lib, ... }:
    let
      allServers = lib.flatten (lib.mapAttrsToList (_: lang:
        map (s: s.server) lang.lsp
      ) config.my.dev.languages);

      trivialConfigCalls = lib.concatMapStringsSep "\n  " (server:
        ''vim.lsp.config("${server}", { capabilities = capabilities, on_attach = on_attach })''
      ) allServers;

      enableList = lib.concatMapStringsSep ", " (s: ''"${s}"'') allServers;
    in
    {
      programs.neovim = {
        plugins = with pkgs.vimPlugins; [
          {
            plugin = fastaction-nvim;
            type = "lua";
            config = ''
              require("fastaction").setup({
                popup = {
                  border = "rounded",
                },
              })

              vim.keymap.set("n", "<C-.>", require("fastaction").code_action, { desc = "Code Action" })
              vim.keymap.set("n", "gla", require("fastaction").code_action, { desc = "Code Action" })
            '';
          }

          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = ''
              local capabilities = require("cmp_nvim_lsp").default_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true
              capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

              local inlay_hint_exclude = {}

              local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                  require("nvim-navic").attach(client, bufnr)
                end
                local ft = vim.bo[bufnr].filetype
                if not inlay_hint_exclude[ft] then
                  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
                if client.server_capabilities.foldingRangeProvider then
                  local win = vim.api.nvim_get_current_win()
                  vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end
                if client.server_capabilities.codeLensProvider then
                  vim.lsp.codelens.enable(true, { bufnr = bufnr })
                end
              end

              ${trivialConfigCalls}

              ${lib.optionalString (config.my.dev.languages ? typst) ''
                vim.lsp.config("tinymist", {
                  capabilities = capabilities,
                  on_attach = on_attach,
                  settings = {
                    exportPdf = "onSave",
                    formatterMode = "typstyle",
                  },
                })
              ''}

              ${lib.optionalString (config.my.dev.languages ? latex) ''
                vim.lsp.config("texlab", {
                  capabilities = capabilities,
                  on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                  end,
                  settings = {
                    texlab = {
                      build = {
                        onSave = false,
                        forwardSearchAfter = false,
                        executable = "tectonic",
                        args = {
                          "-X", "compile", "%f",
                          "--untrusted", "--synctex",
                          "--keep-logs", "--keep-intermediates",
                        },
                      },
                      diagnostics = {
                        ignoredPatterns = { "Unused" },
                        delay = 0.4,
                      },
                    },
                  },
                })
              ''}

              vim.lsp.enable({ ${enableList} })

               vim.diagnostic.config({
                 virtual_text = true,
                 severity_sort = true,
                 underline = true,
                 signs = true,
                 float = {
                   border = "rounded",
                   source = "always",
                 },
               })

               vim.keymap.set("n", "<2-LeftMouse>", function()
                 local lenses = vim.lsp.codelens.get({ bufnr = 0 })
                 if #lenses > 0 then
                   vim.lsp.codelens.run()
                 else
                   vim.fn.execute("normal! \\<2-LeftMouse>")
                 end
                end, { desc = "Click code lens or default double-click" })
                vim.keymap.set("n", "gld", vim.lsp.buf.definition, { desc = "Definition" })
                vim.keymap.set("n", "glr", require("telescope.builtin").lsp_references, { desc = "References" })
                vim.keymap.set("n", "gli", vim.lsp.buf.implementation, { desc = "Implementation" })
                vim.keymap.set("n", "gly", vim.lsp.buf.type_definition, { desc = "Type Definition" })
                vim.keymap.set("n", "glD", vim.lsp.buf.declaration, { desc = "Declaration" })
                vim.keymap.set("n", "glh", vim.lsp.buf.hover, { desc = "Hover" })
                vim.keymap.set("n", "gls", vim.lsp.buf.signature_help, { desc = "Signature Help" })
                vim.keymap.set("n", "glR", vim.lsp.buf.rename, { desc = "Rename" })
                vim.keymap.set("n", "glx", vim.lsp.codelens.run, { desc = "Run Codelens" })
                vim.keymap.set("n", "glX", vim.lsp.codelens.refresh, { desc = "Refresh Codelens" })
                vim.keymap.set("n", "<C-j>", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
                vim.keymap.set("n", "<C-k>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })
            '';
          }
        ];
      };

      programs.neovim.initLua = ''
        vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
          if err then
            local lines = vim.split(err.message or tostring(err), "\n")
            _G.open_result_split("Code Lens Error", lines)
            return
          end
          if not result or vim.tbl_isempty(result) then
            return
          end
          local lines = vim.split(vim.inspect(result), "\n")
          _G.open_result_split(nil, lines)
        end
      '';
    };
}
