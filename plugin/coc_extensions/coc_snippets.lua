local keyset = vim.keymap.set

-- Use <C-l> for trigger snippet expand.
keyset("i", "<C-l>", "<Plug>(coc-snippets-expand)", { silent = true })

-- Use <C-j> for select text for visual placeholder of snippet.
keyset("v", "<C-j>", "<Plug>(coc-snippets-select)", { silent = true })

-- Use <C-j> for jump to next placeholder, it's default of coc.nvim
vim.cmd([[let g:coc_snippet_next = '<c-j>']])

-- Use <C-k> for jump to previous placeholder, it's default of coc.nvim
vim.cmd([[let g:coc_snippet_prev = '<c-k>']])

-- Use <C-j> for both expand and jump (make expand higher priority.)
keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", { silent = true })

-- Use <leader>x for convert visual selected code to snippet
keyset("x", "<leader>x", "<Plug>(coc-convert-snippet)", { silent = true })
