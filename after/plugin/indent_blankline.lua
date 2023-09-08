local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
    print('Plugin not loaded: ', 'indent_blankline')
    return
end
indent_blankline.setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = false,
    show_current_context_start = true,
}
