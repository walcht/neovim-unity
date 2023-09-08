local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
    print('Plugin not loaded: ', 'null-ls')
    return
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- before adding any new linters/formatters, make sure that you add them to Mason's list of
-- linters_and_formatters. That way they are ensured to be installed and managed through Mason!
null_ls.setup({
    sources = {
        --------------------------------------------- FORMATTERS --------------------------------------------
        formatting.black.with({
            extra_args = { "--line-length=88" }
        }),
        formatting.markdownlint,
        formatting.csharpier,
        -----------------------------------------------------------------------------------------------------
        --------------------------------------------- DIAGNOSTICS -------------------------------------------
        diagnostics.ruff,
        diagnostics.markdownlint,
        diagnostics.jsonlint,
        -----------------------------------------------------------------------------------------------------
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end
    end,
})
