-- This file contains neovim startup configuration. This file may be plugin specific
-- to some degree. Since after all, we want to start some plugins at the start of 
-- neovim

local function open_nvim_tree()

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
