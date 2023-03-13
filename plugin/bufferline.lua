require('bufferline').setup {
        options = {
            mode = "buffers", -- set to "tabs" to only show tabpages instead
            numbers = "none",
            close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
            right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
            indicator = {
                icon = '▎', -- this should be omitted if indicator style is not 'icon'
                style = 'icon',
            },
            buffer_close_icon = '',
            modified_icon = '*',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            truncate_names = true, -- whether or not tab names should be truncated
            tab_size = 18,
            diagnostics = "coc",
            diagnostics_update_in_insert = false,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = false
                }
            },
            color_icons = true, -- whether or not to add the filetype icon highlights
            show_buffer_icons = true, -- disable filetype icons for buffers
            show_buffer_close_icons = true,
            show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
            show_close_icon = true,
            show_tab_indicators = true,
            show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
            persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { '|', '|' }
            separator_style = "thin",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            hover = {
                enabled = false,
                delay = 200,
                reveal = {'close'}
            },
            sort_by = "extension",
        }
    }
