{
  flake.modules.homeManager.nvim =
    { ... }:
    {
      programs.nixvim.opts = {
        encoding = "utf-8";
        hidden = true;
        number = true;
        relativenumber = true;
        showmatch = true;
        shiftwidth = 4;
        tabstop = 4;
        expandtab = true;
        smarttab = true;
        formatoptions = "croqln";
        backup = false;
        writebackup = false;
        wrap = false;
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        mouse = "a";
        wildmode = [ "longest" "list" ];
        wildmenu = true;
        foldmethod = "expr";
        foldexpr = "v:lua.vim.treesitter.foldexpr()";
        foldcolumn = "1";
        foldnestmax = 10;
        foldenable = false;
        foldlevel = 99;
        autoindent = true;
        cursorline = true;
        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
        updatetime = 250;
        timeoutlen = 300;
        scrolloff = 8;
        sidescrolloff = 8;
        termguicolors = true;
        clipboard = "unnamedplus";
        showtabline = 2;
        laststatus = 3;
        pumheight = 10;
        inccommand = "split";
      };

      programs.nixvim.extraConfigLua = ''
        vim.opt.diffopt:append("algorithm:histogram")
        vim.opt.whichwrap:append("<,>,h,l,[,]")

        local function change_font_size(delta)
          local guifont = vim.o.guifont
          if guifont == "" then return end
          local size = tonumber(guifont:match(":h(%d+)$")) or 12
          local new_size = math.max(6, size + delta)
          local base = guifont:gsub(":h%d+$", "")
          vim.o.guifont = base .. ":h" .. new_size
        end

        vim.api.nvim_create_autocmd("CursorHold", {
          callback = function()
            collectgarbage("step", 256)
          end,
        })
      '';
    };
}
