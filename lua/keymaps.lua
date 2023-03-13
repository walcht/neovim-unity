-- This file contains global remappings that are NOT specific to any
-- particular plugin

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Leader key remapping
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal Mode --
-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Wondow resizing using arrow keys
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text vertically in noraml mode
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Disable Q key
keymap("n", "Q", "<nop>")
keymap("n", "L", "<nop>")
keymap("n", "\"", "<nop>")

-- Copy to system clipboard
keymap("n", "<leader>y", "\"+y")
keymap("n", "<leader>Y", "\"+Y")

-- Deleting to void register
-- Normally, deleting a sequence results in that sequence overriding whatever
-- is previously yanked. This behaviour is really confusing thus by using the
-- below keymap, this behaviour is disabled.
keymap("n", "<leader>d", "\"_d")

-- Replace the current word pointed by cursor
keymap("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Visual Mode --
-- Stauy in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down and adjust indents accordingly
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Copy to system clipboard
keymap("v", "<leader>y", "\"+y")

-- Deleting to void register
keymap("v", "<leader>d", "\"_d")

-- Visual block --
-- Move text up and down --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Disabling bad vim paste behaviour
keymap("x", "<leader>p", "\"_dP")

-- Terminal --
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
