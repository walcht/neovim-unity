local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
    print('Plugin not loaded: ', 'null-ls')
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion
local code_actions = null_ls.builtins.code_actions

-- before adding any new linters/formatters, make sure that you add them
-- to Mason's list of linters_and_formatters. That way they are ensured to
-- be installed and managed through Mason!
null_ls.setup({
    sources = {
        -- Python
        formatting.black.with({
            extra_args = {"--line-length=110"}
        }),
        diagnostics.flake8,

        -- C#
        formatting.csharpier,

        -- Markdown
        formatting.markdownlint,
        diagnostics.markdownlint,

        -- JSON
        diagnostics.jsonlint,

        -- Misc
        -- add csharp, python etc... for spelling support
        diagnostics.cspell.with({
            filetypes = {"markdown"}
        }),
        code_actions.cspell,
    },
})
