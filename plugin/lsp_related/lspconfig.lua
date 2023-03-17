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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Default config for all language servers
local default_config = {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- Configuration for omnisharp
-- Why not csharp-ls? I faced tons of issues working with that ls on Ubuntu
-- and omnisharp seems (at least currently) to have a much better support.
servers['omnisharp'] = {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    cmd = { "omnisharp", '--languageserver' , '--hostPID', tostring(vim.fn.getpid()) },
    -- rest of your settings
}

servers['lua_ls'] = {
    on_attach = on_attach,
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

