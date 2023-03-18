local status_ok, neogen = pcall(require, 'neogen')
if not status_ok then
    print('Plugin not loaded: ', 'neogen')
    return
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)

neogen.setup {
    snippet_engine = "luasnip",
    enabled = true,
    languages = {
        cs = {
            template = {
                annotation_convention = "xmldoc"
            }
        },
        python = {
            template = {
                annotation_convention = "google_docstrings"
            }
        }
    }
}
