local M = {}

-- Load the formatter function
local formatequal_lines = require"formatequal.format".formatequal_lines
local any_contains_sign = require"formatequal.utils".any_contains_sign
local ignore_functions  = require"formatequal.ignore"

-- Value that sets that a filetype should be ignored
M.IGNORE = 0

--Format a selection of lines hierarchically, according to settings.signs
function M.format_hierarchically()
    local filetype = vim.bo.filetype:gsub('^%l', string.upper)
    local settings = M.settings.filetype[filetype]

    -- Ignore this call if necessary
    if (settings == false) then
        vim.notify(string.format('formatequal is ignored in %s files', filetype), vim.log.levels.WARN)
        return
    end

    local ordered_signs, ignore_filter = {"="}, nil
    if settings then
        ordered_signs = settings.signs or ordered_signs
        ignore_filter = settings.ignore_function or nil
    end

    local slnr, elnr   = vim.fn.line("'<"), vim.fn.line("'>")
    local bufnr, lines = vim.api.nvim_get_current_buf(), vim.fn.getline(slnr, elnr)

    for _, sign in pairs(ordered_signs) do
         if any_contains_sign(lines, sign, ignore_filter) then
             lines = formatequal_lines(lines, sign, ignore_filter)
             break
         end
    end
    vim.api.nvim_buf_set_lines(bufnr, slnr - 1, elnr, true, lines)
end

---Setup function used to set some hierarchical special characters
---@param settings table #Settings table to update the plugin
function M.setup(settings)
    -- Default settings of the module
    M.settings = {
        keybinding = {
            lhs = '<leader>=',
            set = true,
        },
        filetype = {
            Python   = {signs={'=', ':'}, ignore_function=ignore_functions.python},
            Lua      = {signs={'='}, ignore_function=ignore_functions.lua},
            Tex      = false,
            Markdown = false,
        },
    }
    M.settings = (settings) and vim.tbl_deep_extend('force', M.settings, settings) or M.settings
    local keybinding = M.settings.keybinding
    if keybinding.set then
        vim.keymap.set('v', keybinding.lhs, ':lua require"formatequal".format_hierarchically()<Cr>', {silent=true})
    end
end

return M