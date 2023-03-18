local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
      print('Installing packer.nvim plugin...')
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    print('Crucial plugin not loaded: ', 'packer')
    print('Automatic installation failed.', 'Follow installation instructions\
    in packer.nvim repo.')
    return
end

return require('packer').startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope (fuzzy finder)
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Catppuccin: color themes
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Syntax highlighting and much more!
  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
  }

  -- Completion plugins (for LSP, buffer, path, cmd line, snippets, etc...)
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lua" -- lua vim completions
  use "hrsh7th/cmp-nvim-lsp" -- LSP completions

  -- Snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP related plugins
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  -- for proper go-to-definition support for omnisharp
  use "Hoffs/omnisharp-extended-lsp.nvim"

  -- Undotree: undotree visualization
  use ('mbbill/undotree')

  use 'nvim-tree/nvim-web-devicons'     -- Nvim-web-devicons: beautiful nvim-tree icons
  use 'nvim-tree/nvim-tree.lua'         -- Nvim-tree: fancy file explorer
  use 'nvim-lualine/lualine.nvim'       -- Lualine: fancy status bar

  -- Fancy git decorations
  use 'lewis6991/gitsigns.nvim'

  -- Toggleterm: terminal integration within neovim
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}

  -- Showing indentation (especially usefull for Python)
  use 'lukas-reineke/indent-blankline.nvim'

  -- Tabline plugin (those beautiful tabs you see above)
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  -- Required to fix closing window issues with bufferline plugin
  use 'famiu/bufdelete.nvim'

  -- Preview markdown (very, very useful when writing markdown files)
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
  setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- Annotation support (docstrings for python in one click)
  -- Also supports xmldoc for csharp!
  use { "danymat/neogen", tag = "*" }

  if packer_bootstrap then
      require('packer').sync()
  end

end)
