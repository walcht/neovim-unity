-- This file contains global remappings that are NOT specific to any particular plugin
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap.set           -- Shorten function name
keymap("", "<Space>", "<Nop>", opts)    -- Leader key remapping to <Space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
----------------------------------------------- NORMAL MODE -------------------------------------------------
keymap("n", "<C-h>", "<C-w>h", opts)    -- Window navigation
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-Up>", ":resize +2<CR>", opts)           -- Window resizing using arrow keys
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)                -- Navigate to left buffer
keymap("n", "<S-h>", ":bprevious<CR>", opts)            -- Navigate to right buffer
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)       -- Move text vertically
keymap("n", "<A-k>", "<Esc>:m .-3<CR>==gi", opts)
keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "Q", "<nop>")               -- Disable Q key
keymap("n", "\"", "<nop>")
keymap("n", "<leader>y", "\"+y")        -- Copy to system clipboard
keymap("n", "<leader>Y", "\"+Y")
keymap("n", "<leader>d", "\"_d")        -- Delete to void register
keymap("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])   -- Replace word 
keymap("n", "<leader>fo", ":Format<cr>", opts)                          -- Formatting keybinding
keymap("n", "<leader>trn", ":set invrelativenumber<CR>", term_opts)     -- Toggle relative line numbers
keymap("n", "<leader>cs", ":set spell!<CR>", opts)   -- Toggle spell
-------------------------------------------------------------------------------------------------------------
----------------------------------------------- VISUAL MODE -------------------------------------------------
keymap("v", "<", "<gv", opts)           -- Stay in indent mode
keymap("v", ">", ">gv", opts)
keymap("v", "J", ":m '>+1<CR>gv=gv")    -- Move text up and down and adjust indents accordingly
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("v", "<leader>y", "\"+y")        -- Copy to system clipboard
keymap("v", "<leader>d", "\"_d")        -- Deleting to void register
keymap("v", "<leader>trn", ":set invrelativenumber<CR>", term_opts)     -- Toggle relative line numbers
-------------------------------------------------------------------------------------------------------------
-------------------------------------------- VISUAL BLOCK MODE ----------------------------------------------
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)       -- Move text up and down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<leader>p", "\"_dP")                   -- Disabling bad vim paste behaviour
keymap("x", "<leader>trn", ":set invrelativenumber<CR>", term_opts)     -- Toggle relative line numbers
-------------------------------------------------------------------------------------------------------------
---------------------------------------------- TERMINAL MODE ------------------------------------------------
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-------------------------------------------------------------------------------------------------------------
