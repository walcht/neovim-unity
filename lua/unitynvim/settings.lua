-- This file contains global (non pluging-specific) settings.

-- Line and relative line numbering
vim.opt.nu = true
vim.opt.relativenumber = true

-- Configuring tab to 4 space indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Line wrapping disabled
vim.opt.wrap = false

-- Disable backup (extremely bothering)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

-- Search options
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Use terminal colors
vim.opt.termguicolors = true

-- Scrolling\Vertical navigation options
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Fast update time
vim.opt.updatetime = 50

-- Set max-line-length column
vim.opt.colorcolumn = "110"

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
