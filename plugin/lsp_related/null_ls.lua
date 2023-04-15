local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
    print('Plugin not loaded: ', 'null-ls')
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

null_ls.setup({
    sources = {
        -- Python
        formatting.autopep8,
        diagnostics.flake8,

        -- C#
        formatting.csharpier,

        -- Lua
        formatting.stylua,

        -- Markdown
        diagnostics.markdownlint,

        -- JSON
        diagnostics.jsonlint,

        -- Misc
        diagnostics.cspell,
        completion.spell,
    },
})
