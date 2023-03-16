-- Requiring mason
local status_mason_ok, mason = pcall(require, "mason")
if not status_mason_ok then
  return
end

-- Requiring mason_lspconfig
local status_mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig_ok then
    return
end

-- Requiring lspconfig
local lspconfig = require("lspconfig")

-- Requiring cmp_nvim_lsp
local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_nvim_lsp then
  return
end

-- For advertising cmp_nvim_lsp completion cepabilities for LSP servers
local capabilities = cmp_nvim_lsp.default_capabilities()

-- The following setup order should be respected!
-- 1. mason.setup{}
-- 2. mason_lspconfig.setup{}
-- 3. lspconfig.<lsp_name>.setup{}
mason.setup {
    ui = {
        check_outdated_packages_on_open = true,
        border = "none",

        width = 0.8,
        height = 0.9,

        icons = {
            package_installed = "◍",
            package_pending = "◍",
            package_uninstalled = "◍",
        },

        keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            update_package = "u",
            check_package_version = "c",
            update_all_packages = "U",
            check_outdated_packages = "C",
            uninstall_package = "X",
            cancel_installation = "<C-c>",
            apply_language_filter = "<C-f>",
        },
    },
}

-- Add your language server(s) here
local servers = {
    'pyright',
    'marksman',
    'lua_ls',
    'jsonls',
    'html',
    'clangd',
    'bashls',
    'lemminx',
    'yamlls'
}

-- Setup mason-lspconfig
mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = false,
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- Omnisharp setup
local pid = vim.fn.getpid()
local omnisharp_bin = "omnisharp"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"

local config = {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) },
  -- rest of your settings
}

lspconfig['omnisharp'].setup(config)
