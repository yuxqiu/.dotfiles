{
  flake.modules.homeManager.nvim =
    { pkgs, config, ... }:
    {
      programs.neovim = {
        extraPackages = config.my.dev.lsp;
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

          # texlab: https://github.com/latex-lsp/texlab/issues/1551
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

              vim.lsp.config("basedpyright", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("clangd", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("gopls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("markdown_oxide", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("nixd", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("ruff", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("tinymist", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  exportPdf = "onSave",
                  formatterMode = "typstyle",
                },
              })
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
              vim.lsp.config("jsonls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("typos_lsp", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("bashls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("taplo", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("yamlls", { capabilities = capabilities, on_attach = on_attach })

              vim.lsp.enable({
                "basedpyright",
                "bashls",
                "clangd",
                "cssls",
                "gopls",
                "jsonls",
                "lua_ls",
                "markdown_oxide",
                "nixd",
                "ruff",
                "rust_analyzer",
                "taplo",
                "tinymist",
                "texlab",
                "typos_lsp",
                "yamlls",
              })

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
    };
}
