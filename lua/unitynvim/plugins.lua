local ensure_packer = function()
  local fn = vim.fn
  local install_path =
     fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
      print('Installing packer.nvim plugin...')
    fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    print('Plugin not loaded (CRUCIAL): ', 'packer')
    print('Automatic installation failed.', 'Follow installation instructions\
    in packer.nvim repo.')
    return
end
packer.startup(function(use)
  ---------------------------------- PACKER -----------------------------------
  use 'wbthomason/packer.nvim'              -- Packer can manage itself
  -----------------------------------------------------------------------------
  ---------------------------- TELESCOPE RELATED ------------------------------
  use {
	  'nvim-telescope/telescope.nvim',      -- fuzzy finder
      tag = '0.1.1',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  -----------------------------------------------------------------------------
  -------------------------------- TREESITTER ---------------------------------
  use {
	  'nvim-treesitter/nvim-treesitter',    -- syntax highlighting and more
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({
              with_sync = true
          })
		  ts_update()
	  end,
  }
  -----------------------------------------------------------------------------
  ---------------------------- COMPLETION RELATED -----------------------------
  use "hrsh7th/nvim-cmp"                    -- completion plugin
  use "hrsh7th/cmp-buffer"                  -- buffer completions
  use "hrsh7th/cmp-path"                    -- path completions
  use "hrsh7th/cmp-cmdline"                 -- cmdline completions
  use "saadparwaiz1/cmp_luasnip"            -- snippet completions
  use "hrsh7th/cmp-nvim-lua"                -- lua vim completions
  use "hrsh7th/cmp-nvim-lsp"                -- LSP completions
  use "hrsh7th/cmp-nvim-lsp-signature-help" -- function parameters completions
  -----------------------------------------------------------------------------
  ----------------------------- SNIPPETS RELATED ------------------------------
  use "L3MON4D3/LuaSnip"                    -- snippet engine
  use "rafamadriz/friendly-snippets"        -- a bunch of ready-to-use snippets
  -----------------------------------------------------------------------------
  -------------------------------- LSP RELATED --------------------------------
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "jose-elias-alvarez/null-ls.nvim"     -- for linting purposes
  use "Hoffs/omnisharp-extended-lsp.nvim"   -- for proper go-to-definition
                                            -- support for omnisharp
  -----------------------------------------------------------------------------
  -------------------------------- UI RELATED ---------------------------------
  use 'nvim-tree/nvim-tree.lua'             -- fancy file explorer
  use 'nvim-lualine/lualine.nvim'           -- fancy status bar
  use 'nvim-tree/nvim-web-devicons'         -- beautiful nvim-tree icons
  use {
      "catppuccin/nvim",                    -- color themes
      as = "catppuccin"
  }
  use {
      'akinsho/bufferline.nvim',            -- tabline plugin
      tag = "v3.*",
      requires = 'nvim-tree/nvim-web-devicons'
  }
  use 'lukas-reineke/indent-blankline.nvim' -- showing indentation (especially
                                            -- usefull for Python)
  use 'famiu/bufdelete.nvim'                -- required to fix closing window
                                            -- issues with bufferline plugin
  -----------------------------------------------------------------------------
  ------------------------------------ MISC -----------------------------------
  use ('mbbill/undotree')                   -- undotree visualization
  use {
      "akinsho/toggleterm.nvim",            -- terminal integration within nvim
      tag = '*',
      config = function() require("toggleterm").setup() end
  }
  use { "danymat/neogen", tag = "*" }       -- annotation support (docstrings
                                            -- for python & xmldoc for csharp)
  use({
      "iamcco/markdown-preview.nvim",       -- markdown preview
      run = function() vim.fn["mkdp#util#install"]() end,
  })
  -----------------------------------------------------------------------------
  -------------------------------- GIT RELATED --------------------------------
  use 'lewis6991/gitsigns.nvim'             -- Fancy git decorations
  -----------------------------------------------------------------------------
  ----------------------------- DEBUGGING RELATED -----------------------------
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  -----------------------------------------------------------------------------
  if packer_bootstrap then
      require('packer').sync()
  end
end)
