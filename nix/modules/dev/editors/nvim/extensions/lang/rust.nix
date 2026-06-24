{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.extraConfigLua = ''
        local ra_run_in_split = function(command)
          local r = command.arguments[1]
          local cmd = { "cargo", unpack(r.args.cargoArgs) }
          if r.args.executableArgs and #r.args.executableArgs > 0 then
            vim.list_extend(cmd, { "--", unpack(r.args.executableArgs) })
          end
          vim.system(cmd, { cwd = r.args.cwd, env = r.args.environment, text = true }, function(result)
            vim.schedule(function()
              local lines
              local title
              if result.code == 0 then
                lines = vim.split(result.stdout or "", "\n")
                title = "Run Test"
              else
                lines = vim.split(result.stderr or result.stdout or "Command failed", "\n")
                title = "Run Test Error"
              end
              _G.open_result_split(title, lines)
            end)
          end)
        end

        local ra_debug_in_split = function(command)
          local r = command.arguments[1]
          local cmd = { "cargo", unpack(r.args.cargoArgs) }
          if r.args.executableArgs and #r.args.executableArgs > 0 then
            vim.list_extend(cmd, { "--", unpack(r.args.executableArgs) })
          end
          vim.system(cmd, { cwd = r.args.cwd, env = r.args.environment, text = true }, function(result)
            vim.schedule(function()
              local lines
              local title
              if result.code == 0 then
                lines = vim.split(result.stdout or "", "\n")
                title = "Debug Test"
              else
                lines = vim.split(result.stderr or result.stdout or "Command failed", "\n")
                title = "Debug Test Error"
              end
              _G.open_result_split(title, lines)
            end)
          end)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "rust_analyzer" then
              vim.lsp.commands["rust-analyzer.runSingle"] = ra_run_in_split
              vim.lsp.commands["rust-analyzer.debugSingle"] = ra_debug_in_split
            end
          end,
        })
      '';

      programs.nixvim.plugins.lsp.servers.rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
      programs.nixvim.plugins.lint.lintersByFt.rust = [ "clippy" ];
      programs.nixvim.plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        rust
      ];
    };
}
