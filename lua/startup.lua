-- This file contains neovim startup configuration. This file may be plugin specific
-- to some degree. Since after all, we want to start some plugins at the start of 
-- neovim

local status_ok, nvim_tree = pcall(require, 'nvim-tree.api')
if not status_ok then
    print('Plugin not loaded: ', 'nvim_tree')
    return
end
-- Open nvim-tree on directory or no-name buffer
local function open_nvim_tree(data)

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    if directory then
        -- change to the directory
        vim.cmd.cd(data.file)
        nvim_tree.tree.open()
        return
    end

    if no_name then
        nvim_tree.tree.toggle({ focus = false, find_file = true, })
    end

end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
