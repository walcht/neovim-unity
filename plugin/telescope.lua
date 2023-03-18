local status_ok, telescope_builtin = pcall(require, 'telescope.builtin')
if not status_ok then
    print('CRUCIAL plugin not loaded: ', 'telescope.builtin')
    return
end

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})

vim.keymap.set('n', '<leader>fg', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', function()
    telescope_builtin.grep_string({ serach = vim.fn.input("Grep > ")})
end)

