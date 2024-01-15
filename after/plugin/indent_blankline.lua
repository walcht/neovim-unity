local status_ok, indent_blankline = pcall(require, 'ibl')
if not status_ok then
    print('Plugin not loaded: ', 'indent_blankline')
    return
end
indent_blankline.setup {}
