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
local servers = {}

-- Default config for all language servers
local default_config = {
    capabilities = capabilities,
}

servers['omnisharp'] = {
    capabilities = capabilities,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    cmd = { "omnisharp", '--languageserver' , '--hostPID', tostring(vim.fn.getpid()) },
    -- rest of your settings
}

servers['lua_ls'] = {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
}

-- Add your language server(s) here
-- You cant replace default_config by your server's configurations
servers['pyright'] = default_config
servers['marksman'] = default_config
servers['jsonls'] = default_config
servers['html'] = default_config
servers['clangd'] = default_config
servers['bashls'] = default_config
servers['yamlls'] = default_config
servers['lemminx'] = default_config

-- Setup mason-lspconfig
mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = false,
}

-- Setup LSP servers
for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(config)
end

