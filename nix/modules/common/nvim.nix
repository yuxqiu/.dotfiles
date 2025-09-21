{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Install required plugins and dependencies
    plugins = with pkgs.vimPlugins; [ vim-plug leap-nvim ];

    extraConfig = ''
      set encoding=utf-8
      set hidden
      set number
      set relativenumber
      set showmatch
      set smarttab
      set shiftwidth=4
      set tabstop=4
      set expandtab
      set nobackup
      set nowritebackup
      set nowrap
      set incsearch
      set ignorecase
      set smartcase
      set hlsearch
      set mouse=a
      set wildmode=longest,list
      set wildmenu
      set foldmethod=indent
      set foldnestmax=10
      set nofoldenable
      set foldlevel=2
      set autoindent

      filetype plugin indent on
      syntax enable

      " Set map leader
      let mapleader = ","

      " Initialize vim-plug
      call plug#begin()
      Plug 'ggandor/leap.nvim'
      call plug#end()
    '';

    extraLuaConfig = ''
      -- Key mappings
      vim.keymap.set('n', '<space>', ':', { noremap = true })
      vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
      vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
      vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
      vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
      vim.keymap.set('n', 'H', '^', { noremap = true })
      vim.keymap.set('n', 'L', '$', { noremap = true })
      vim.keymap.set('n', 'Y', '"+y', { noremap = true })
      vim.keymap.set('v', 'Y', '"+y', { noremap = true })
      vim.keymap.set('n', 'yY', '^"+y$', { noremap = true })

      -- leap.nvim setup
      require('leap').create_default_mappings()

      -- VSCode-specific mappings
      if vim.g.vscode then
        vim.keymap.set('x', 'gc', '<Plug>VSCodeCommentary', {})
        vim.keymap.set('n', 'gc', '<Plug>VSCodeCommentary', {})
        vim.keymap.set('o', 'gc', '<Plug>VSCodeCommentary', {})
        vim.keymap.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})
        vim.keymap.set('n', 'zc', '<Cmd>call VSCodeNotify("editor.fold")<CR>', { noremap = true })
        vim.keymap.set('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', { noremap = true })
        vim.keymap.set('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfold")<CR>', { noremap = true })
        vim.keymap.set('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', { noremap = true })
      end

      -- Conditional function for plugin compatibility
      _G.Cond = function(cond, opts)
        opts = opts or {}
        if cond then
          return opts
        else
          return vim.tbl_extend("force", opts, { on = {}, ["for"] = {} })
        end
      end
    '';
  };

  # Configure EDITOR using full path to ensure sudoedit can pick up nvim
  home.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";
}
