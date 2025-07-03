return {
  -- show search results using folds
  {
    "vim-scripts/searchfold.vim",
  },

  -- nvim-rg allows you to run ripgrep from Neovim or Vim and shows the results
  -- in a quickfix window. It was developed for use on macOS with Neovim. On
  -- Neovim, it runs asynchronously.
  {
    "duane9/nvim-rg",
  },

  -- A File Explorer For Neovim Written In Lua
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        sync_root_with_cwd = false,
        respect_buf_cwd = false,
        disable_netrw = false,
        hijack_netrw = false,
        view = {
          adaptive_size = true,
        },
        update_focused_file = {
          enable = true,
        },
        git = {
          enable = false,
        },
      }
    end,
  },

  -- telescope.nvim is a highly extendable fuzzy finder over lists
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          "^node_modules/",
          "^.git/",
        },
        -- disable treesitter in preview
        preview = {
        },
      }
    end,
  },

  -- The goal of nvim-treesitter is both to provide a simple and easy way to
  -- use the interface for tree-sitter in Neovim and to provide some basic
  -- functionality such as highlighting based on it
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "yaml",
          "lua",
        },
        ignore_install = { },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP
  -- client configurations for various LSP servers.
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local nvim_lsp = require('lspconfig')
      local servers = { 'pyright', 'ts_ls', 'jdtls' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          capabilities = capabilities,
          -- on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end
    end,
  },

  -- A completion engine plugin for neovim written in Lua
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },

  -- project.nvim is an all in one neovim plugin written in lua that provides
  -- superior project management.
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        patterns = { ".git" },
      }
    end,
  },

  -- onedark.vim: A dark Vim/Neovim color scheme for the GUI and
  -- 16/256/true-color terminals, based on FlatColor, with colors inspired by
  -- the excellent One Dark syntax theme for the Atom text editor.
  {
    "joshdick/onedark.vim",
  },

  {
    'williamboman/mason.nvim',
  },

  -- install Eclipse JDT LS with ":MasonInstall jdtls"
  {
    'mfussenegger/nvim-jdtls',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
  },

  {
    'nvim-neotest/neotest',
     dependencies = {
       'nvim-neotest/nvim-nio',
       'nvim-lua/plenary.nvim',
       'nvim-treesitter/nvim-treesitter',
       'antoinemadec/FixCursorHold.nvim',
       'rcasia/neotest-java',
    },
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
  },
}
