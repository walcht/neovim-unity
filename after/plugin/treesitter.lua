local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    print('CRUCIAL plugin not loaded: ', 'nvim-treesitter.configs')
    return
end
treesitter_configs.setup {
    -- list of parser names that SHOULD be installed
    ensure_installed = {
        "c", "lua", "vim", "c_sharp", "cpp", "python", "json", "json5",
        "bibtex", "query" },
    -- install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- automatically install missing parsers when entering buffer
    -- set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the
        -- same time. Set this to `true` if you depend on 'syntax' being
        -- enabled (like for indentation). Using this option may slow down
        -- your editor, and you may see some duplicate highlights. Instead of
        -- true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
