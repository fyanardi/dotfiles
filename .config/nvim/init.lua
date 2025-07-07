-- Basic configurations
vim.g.mapleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.list = true
vim.o.clipboard = "unnamed"
-- show line numbers
vim.o.number = true
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
-- show title
vim.o.title = true
-- different tabstop for python and js/ts
vim.cmd('autocmd BufEnter *.py :setlocal tabstop=4 shiftwidth=4 expandtab')
vim.cmd('autocmd BufEnter *.js,*.ts,*.tsx :setlocal tabstop=2 shiftwidth=2 expandtab')

-- Nerd font
-- 1. download from https://www.nerdfonts.com/
-- 2. extract to `~/.fonts`
-- 3. run `fc-cache -fv` to rebuild the font cache
if vim.g.fvim_loaded then
  vim.cmd("set guifont=FiraCode\\ NF:h14")
end

require("config.lazy")

-- onedark colorschema (installed via lazy.vim)
vim.cmd(":colorscheme onedark")

-- Different tabstop for python and ts/tsx
vim.cmd("autocmd BufEnter *.py :setlocal tabstop=4 shiftwidth=4 expandtab")
vim.cmd("autocmd BufEnter *.js,*.ts,*.tsx :setlocal tabstop=2 shiftwidth=2 expandtab")

-- ignore node_modules from grep search
vim.cmd(":set wildignore=*/node_modules/*")

-- NerdTree
vim.cmd("nnoremap <C-n> :NvimTreeToggle<CR>")

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- LSPs
-- Pyright - Nvim 0.10
require('lspconfig').pyright.setup{}
-- Pyright - Nvim 0.11+
-- vim.lsp.enable('pyright')

require('jdtls').start_or_attach({
  cmd = {
    vim.fn.expand'$HOME/.local/share/nvim/mason/bin/jdtls',
      ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand'$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar'),
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  bundles = vim.split(vim.fn.glob('$HOME/.local/share/nvim/mason/packages/java-*/extension/server/*.jar', 1), '\n'),
})

require('mason').setup()

require('cmp').setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-c>'] = require'cmp'.mapping.abort(),
    ['<CR>'] = require'cmp'.mapping.confirm(),
    ['<C-n>'] = require'cmp'.mapping.select_next_item(),
    ['<C-p>'] = require'cmp'.mapping.select_prev_item(),
  },
  sources = {
    {
      name = 'nvim_lsp',
    },
  },
})

require('neotest').setup({
  adapters = {
    require'neotest-java',
  },
})
