local status_mason_ok, mason = pcall(require, "mason")
if not status_mason_ok then
    return
end
local status_mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not status_mason_registry_ok then
    print("Plugin not installed (CRUCIAL): mason-registry")
    return
end
local status_mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig_ok then
    return
end
local lspconfig = require("lspconfig")
local status_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_nvim_lsp then
    return
end
-- For advertising cmp_nvim_lsp completion capabilities for LSP servers
local capabilities = cmp_nvim_lsp.default_capabilities()
-- WARNING: THE FOLLOWING SETUP ORDER SHOULD BE RESPECTED!
-- 1. mason.setup{}
-- 2. mason_lspconfig.setup{}
-- 3. lspconfig.<lsp_name>.setup{}
mason.setup {
    ui = {
        check_outdated_packages_on_open = true,
        border = "single",
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
------------------------------------- ADD LINTERS AND FORMATTERS HERE ---------------------------------------
local linters_and_formatters = {
    'black',
    'ruff',
    'csharpier',
    'jsonlint',
    'markdownlint',
}
-------------------------------------------------------------------------------------------------------------
----------------------------------------- ADD YOUR DEBUGGER(S) HERE -----------------------------------------
local debuggers = {
    'debugpy',
}
-------------------------------------------------------------------------------------------------------------
local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    ---------------------------------------------------------------------------------------------------------
    --------------------------------------------- KEYMAPS ---------------------------------------------------
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
    vim.keymap.set(
        'n',
        '<space>f',
        function() vim.lsp.buf.format { async = true } end,
        bufopts
    )
    ---------------------------------------------------------------------------------------------------------
end
local default_config = { -- Default config for all language servers
    on_attach = on_attach,
    capabilities = capabilities,
}
------------------------------------- ADD YOUR LANGUAGE SERVER(S) HERE --------------------------------------
-- Replace with your own path to Omnisharp executable
-- Install .NET CORE SDK for this omnisharp to work
-- Read README at official omnisharp repo: https://github.com/OmniSharp/omnisharp-roslyn
-- TODO:    OmniSharp startup is consuming a lot of memory! This is potentially related to some log buffering
--          that is done by lspconfig. This is a crucial issue and has to be fixed ASAP!
local omnisharp_executable = "omnisharp";
servers['omnisharp'] = { -- Configuration for omnisharp
    on_attach = on_attach,
    capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    }),
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    cmd = { omnisharp_executable, '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
    -- enable_editorconfig_support = true, -- setting from .editorconfig
    -- enable_ms_build_load_projects_on_demand = true,
    -- enable_roslyn_analyzers = true,
    -- analyze_open_documents_only = true,
    -- organize_imports_on_format = true,
    -- may result in slow completion responsiveness
    -- enable_import_completion = true,
    -- sdk_include_prereleases = true,
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
servers['pyright'] = default_config -- You can replace default_config by your server's configurations
servers['marksman'] = default_config
servers['jsonls'] = default_config
servers['html'] = default_config
servers['clangd'] = default_config
servers['bashls'] = default_config
servers['yamlls'] = default_config
servers['lemminx'] = default_config
servers['tsserver'] = default_config
-------------------------------------------------------------------------------------------------------------
-- Ensure installed servers
local ensure_installed = {}
for lsp, _ in pairs(servers) do
    table.insert(ensure_installed, lsp)
end
for _, linter_or_formatter in pairs(linters_and_formatters) do -- Ensure linters and formatters are installed
    if not mason_registry.is_installed(linter_or_formatter) then
        print(string.format("Linter or formatter not installed: %s",
            linter_or_formatter))
        vim.cmd(string.format(
            "MasonInstall %s", linter_or_formatter
        ))
    end
end
for _, debugger in pairs(debuggers) do -- Ensure debuggers are installed
    if not mason_registry.is_installed(debugger) then
        print(string.format("Debuggers is not installed: %s", debugger))
        vim.cmd(string.format("MasonInstall %s", debugger))
    end
end
mason_lspconfig.setup { -- Setup mason-lspconfig
    ensure_installed = ensure_installed,
    automatic_installation = false,
}
for lsp, config in pairs(servers) do -- Setup LSP servers
    lspconfig[lsp].setup(config)
end
---------------------------------------------- KEYMAPS ------------------------------------------------------
vim.keymap.set({ "n", "v" }, "<leader>rl", ":LspRestart<CR>", { silent = false })
-------------------------------------------------------------------------------------------------------------
