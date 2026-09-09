{
  flake.modules.homeManager.nvim = {
    programs.nixvim.keymaps = [
      # Font size
      {
        mode = "n";
        key = "<C-=>";
        action.__raw = "function() change_font_size(1) end";
        options.desc = "Increase font size";
      }
      {
        mode = "n";
        key = "<C-+>";
        action.__raw = "function() change_font_size(1) end";
        options.desc = "Increase font size";
      }
      {
        mode = "n";
        key = "<C-->";
        action.__raw = "function() change_font_size(-1) end";
        options.desc = "Decrease font size";
      }

      # New file
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>enew<CR>";
        options.desc = "New file";
      }

      # Terminal mode: <Esc> to enter normal mode
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }

      # Insert/normal/visual: save file (VSCode-style)
      {
        mode = "i";
        key = "<C-s>";
        action = "<Esc>:w<CR>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        mode = "v";
        key = "<C-s>";
        action = "<Esc>:w<CR>";
        options.desc = "Save file";
      }

      # Disable default q (macro recording) to prevent accidental hijack of leader key
      {
        mode = "n";
        key = "q";
        action = "<Nop>";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<leader>Qr";
        action = "q";
        options.desc = "Record macro";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<leader>Qp";
        action = "@";
        options.desc = "Play macro";
        options.noremap = true;
      }
      {
        mode = "n";
        key = "<leader>Ql";
        action = "@@";
        options.desc = "Play last macro";
        options.noremap = true;
      }

      # Quick move to line start/end
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "H";
        action = "^";
        options.noremap = true;
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "L";
        action = "$";
        options.noremap = true;
      }

      # Movement: hjkl + arrows move by display line (wrap-aware)
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "j";
        action = "gj";
        options.desc = "Down (wrap-aware)";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "k";
        action = "gk";
        options.desc = "Up (wrap-aware)";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "<Down>";
        action = "gj";
        options.desc = "Down (wrap-aware)";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "<Up>";
        action = "gk";
        options.desc = "Up (wrap-aware)";
      }
      {
        mode = "i";
        key = "<Down>";
        action = "<C-o>gj";
        options.desc = "Down (wrap-aware)";
      }
      {
        mode = "i";
        key = "<Up>";
        action = "<C-o>gk";
        options.desc = "Up (wrap-aware)";
      }

      # Clipboard
      {
        mode = "n";
        key = "Y";
        action = ''"+y'';
        options.noremap = true;
      }
      {
        mode = "v";
        key = "Y";
        action = ''"+y'';
        options.noremap = true;
      }

      # Jump list navigation (back/forward like Zed)
      {
        mode = "n";
        key = "<leader>jb";
        action = "<C-O>";
        options.desc = "Jump back";
      }
      {
        mode = "n";
        key = "<leader>jf";
        action = "<C-I>";
        options.desc = "Jump forward";
      }

      # Toggle relative line numbers (from Zed vim config)
      {
        mode = "n";
        key = "<leader>lr";
        action = "<cmd>set relativenumber!<CR>";
        options.desc = "Toggle relative line numbers";
      }
    ];
  };
}
