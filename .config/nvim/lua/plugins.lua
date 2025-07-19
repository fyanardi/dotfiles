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
        update_focused_file = {
          enable = true,
        },
        view = {
          adaptive_size = true,
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
          "c",
          "cpp",
          "yaml",
          "lua",
          "python",
          "tsx",
          "bash",
          "markdown",
          "html",
          "css",
          "clojure",
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
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- Mappings.
        local opts = { noremap=true, silent=true }
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local nvim_lsp = require('lspconfig')
      local servers = { 'pyright', 'ts_ls', 'jdtls' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          capabilities = capabilities,
          on_attach = on_attach,
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

  {
    "Olical/conjure",
    ft = { "clojure" },
    lazy = false,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },
  },

  {
    "PaterJason/cmp-conjure",
    lazy = false,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },

}
