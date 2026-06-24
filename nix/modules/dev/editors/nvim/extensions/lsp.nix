{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [ fastaction-nvim ];

        extraConfigLua = ''
          require("fastaction").setup({
            popup = {
              border = "rounded",
            },
          })

          vim.keymap.set("n", "<C-.>", require("fastaction").code_action, { desc = "Code Action" })
          vim.keymap.set("n", "gla", require("fastaction").code_action, { desc = "Code Action" })

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

        plugins.lsp = {
          enable = true;
          inlayHints = true;

          capabilities = ''
            local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
            for k, v in pairs(cmp_caps) do capabilities[k] = v end
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
          '';

          onAttach = ''
            if client.server_capabilities.documentSymbolProvider then
              require("nvim-navic").attach(client, bufnr)
            end
            if client.name ~= "texlab" then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
            if client.server_capabilities.foldingRangeProvider then
              local win = vim.api.nvim_get_current_win()
              vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
            end
            if client.server_capabilities.codeLensProvider then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end
          '';

          keymaps = {
            silent = true;
            lspBuf = {
              gld = "definition";
              gli = "implementation";
              gly = "type_definition";
              glD = "declaration";
              glh = "hover";
              gls = "signature_help";
              glR = "rename";
            };
            diagnostic = {
              "<C-j>" = "goto_next";
              "<C-k>" = "goto_prev";
            };
            extra = [
              {
                key = "glr";
                action.__raw = "require('telescope.builtin').lsp_references";
                options.desc = "References";
              }
              {
                key = "glx";
                action = "<cmd>lua vim.lsp.codelens.run()<CR>";
                options.desc = "Run Codelens";
              }
              {
                key = "glX";
                action = "<cmd>lua vim.lsp.codelens.refresh()<CR>";
                options.desc = "Refresh Codelens";
              }
              {
                key = "<2-LeftMouse>";
                action.__raw = ''
                  function()
                    local lenses = vim.lsp.codelens.get({ bufnr = 0 })
                    if #lenses > 0 then
                      vim.lsp.codelens.run()
                    else
                      vim.fn.execute("normal! \\<2-LeftMouse>")
                    end
                  end
                '';
                options.desc = "Click code lens or default double-click";
              }
            ];
          };
        };

        diagnostic.settings = {
          virtual_text = true;
          severity_sort = true;
          underline = true;
          signs = true;
          float = {
            border = "rounded";
            source = "always";
          };
        };
      };
    };
}
