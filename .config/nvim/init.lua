-- =========================================
-- Basic configurations
-- =========================================
vim.opt.number = true

-- Set tab size to 4 spaces by default
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Use 2 spaces as tab for javascript / Typescript / Terraform / JSON files
vim.cmd('autocmd BufEnter *.js,*ts,*.tsx,*tf,*.tfvars,*.json,*.lua :setlocal tabstop=2 shiftwidth=2 expandtab')

-- Incremental search
vim.opt.incsearch = true

-- Show current file in the title bar
vim.opt.title = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
  space = '·'
}

-- Remap leader to space
vim.g.mapleader = " "

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Plugins
vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/duane9/nvim-rg' }, -- ripgrep support for Neovim
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' }, -- depends on plenary.nvim
  { src = 'https://github.com/catppuccin/nvim' }, -- catppuccin color scheme
  { src = 'https://github.com/nvim-lualine/lualine.nvim' }, -- show a nice status line
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter.git', build = ':TSUpdate' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = "https://github.com/hrsh7th/nvim-cmp.git" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp.git" },
  { src = "https://github.com/hrsh7th/cmp-buffer.git" },
  { src = "https://github.com/mfussenegger/nvim-jdtls.git" },
})

-- =========================================
-- Global keymaps
-- =========================================
vim.keymap.set('n', '<leader>t', function()
vim.cmd('belowright split | lcd ' .. vim.fn.expand('%:p:h') .. ' | terminal')
end, { desc = 'Open terminal in current file directory' })

-- Nvim Tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })

-- Telescope keymaps
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- =========================================
-- NVim Tree setup
-- =========================================
require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
  view = {
    adaptive_size = true,
  },
  on_attach = function(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 1. Load all default keymaps automatically
  api.config.mappings.default_on_attach(bufnr)

  -- 2. Add custom or overridden mappings
  -- vim.keymap.set('n', 'l', api.node.open.edit,         opts('Open File/Folder'))
  -- vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Folder'))

  -- 3. Delete/Unmap a default binding if desired
  -- vim.keymap.del('n', '<C-e>', { buffer = bufnr })
end,
})

require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  integration_default = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope = true,
    },
  },
})

-- Setup must be called before loading the colorscheme
vim.cmd.colorscheme("catppuccin")

-- =========================================
-- LSP configuration
-- =========================================
local lsp = vim.lsp
-- No Mason installed, hence this assumes all language server binaries are already in the path
local servers = { 'pyright', 'tsserver', 'jdtls', 'terraformls' }

for _, server in ipairs(servers) do
  lsp.config(server, {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {},
  })
  lsp.enable(server)
end

-- =========================================
-- CMP (Completion Engine)
-- =========================================
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
  experimental = { ghost_text = true },
})

-- =========================================
-- Treesitter (Syntax Highlighting)
-- =========================================
require("nvim-treesitter").setup({
  ensure_installed = { "python", "html", "javascript", "json", "terraform", "hcl" },
  highlight = { enable = true },
})

-- =========================================
-- lualine (Status Line)
-- =========================================
require("lualine").setup()
