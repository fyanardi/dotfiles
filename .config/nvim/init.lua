-- Basic configurations
vim.g.mapleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.list = true
vim.o.clipboard = "unnamed"
vim.o.number = true
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2

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

-- LSP
-- Nvim 0.10
require('lspconfig').pyright.setup{}
-- Nvim 0.11+
-- vim.lsp.enable('pyright')
