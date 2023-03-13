-- This file can be loaded by calling `lua require('plugins')` from your init.lua

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope: 
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Catppuccin: color themes
  use { "catppuccin/nvim", as = "catppuccin" }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
  }

  use {'neoclide/coc.nvim', branch = 'release'}

  -- Undotree: undotree visualization
  use ('mbbill/undotree')

  use 'nvim-tree/nvim-web-devicons'     -- Nvim-web-devicons: beautiful nvim-tree icons
  use 'nvim-tree/nvim-tree.lua'         -- Nvim-tree: fancy file explorer
  use 'nvim-lualine/lualine.nvim'       -- Lualine: fancy status bar

  use 'lewis6991/gitsigns.nvim'         -- Gitsigns: fancy git decorations

  -- Toggleterm: terminal integration within neovim
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}

  -- Showing indentation (especially usefull for Python)
  use 'lukas-reineke/indent-blankline.nvim'

  -- Tabline plugin
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  -- Required to fix closing window issues with bufferline plugin
  use 'famiu/bufdelete.nvim'

  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", 
  setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- Snippets for tons of programming languages
  use 'honza/vim-snippets'

end)
