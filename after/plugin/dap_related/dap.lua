local dap_status_ok, dap = pcall(require, 'dap')
if not dap_status_ok then
    print('Plugin not loaded: ', 'nvim-dap')
    return
end
local dap_ui_status_ok, dapui = pcall(require, 'dapui')
local dap_virtual_status_ok, dap_virtual_text = pcall(require, 'nvim-dap-virtual-text')
------------------------------------- ADD YOUR DEBUGGERS HERE -----------------------------------------------
local dap_python_status_ok, dap_python = pcall(require, 'dap-python')
-------------------------------------------------------------------------------------------------------------
-------------------------------------------- KEYMAPS --------------------------------------------------------
vim.keymap.set('n', '<leader>dc', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<leader>do', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<leader>di', ":lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<leader>dO', ":lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<leader>db', ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<leader>dB', ":lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: '))<CR>")
-------------------------------------------------------------------------------------------------------------
if not dap_virtual_status_ok then
    print('Plugin not loaded: ', 'nvim-dap-virtual-text')
else
    dap_virtual_text.setup()
end
if not dap_ui_status_ok then
    print('Plugin not loaded: ', 'nvim-dap-ui')
    return
end
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
if not dap_python_status_ok then
    print('Plugin not loaded: ', 'nvim-dap-python')
else
    ---------------------------------------------- KEYMAPS --------------------------------------------------
    vim.keymap.set('n', '<leader>dn', ':lua require("dap-python").test_method()<CR>')
    vim.keymap.set('n', '<leader>df', ':lua require("dap-python").test_class()<CR>')
    vim.keymap.set('v', '<leader>ds', '<ESC>:lua require("dap-python").debug_selection()<CR>')
    vim.keymap.set({ 'n', 'v' }, '<leader>dr', ':lua require("dapui").eval()<CR>')
    ---------------------------------------------------------------------------------------------------------
    -- uses global instance of python3
    -- (better use virtualenv's python executable!)
    dap_python.setup('python3')
end
