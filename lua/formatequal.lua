local M = {}

-- Load the formatter function
local formatequal_lines = require"formatequal.format".formatequal_lines
local any_contains_sign = require"formatequal.utils".any_contains_sign

-- Value that sets that a filetype should be ignored
M.IGNORE = 0

-- Main function of the module, used to format the data
function M.format_hierarchically()
    local filetype = vim.bo.filetype:gsub('^%l', string.upper)
    local settings = M.settings[filetype]

    -- Ignore this call if necessary
    if settings == M.IGNORE then
        vim.notify(string.format('formatequal is ignored in %s files', filetype), vim.log.levels.WARN)
        return
    end

    local hierarchy = {'='}
    if settings then
        hierarchy = settings.signs
    end

    local slnr, elnr   = vim.fn.line("'<"), vim.fn.line("'>")
    local bufnr, lines = vim.api.nvim_get_current_buf(), vim.fn.getline(slnr, elnr)
    for _, sign in pairs(hierarchy) do
        if any_contains_sign(lines, sign, settings.ignore_function) then
            lines = formatequal_lines(lines, sign, settings.ignore_function)
            break
        end
    end
    vim.api.nvim_buf_set_lines(bufnr, slnr - 1, elnr, true, lines)
end

-- Default options used in the system
function M.set_defaults()
    M.settings = {
        Python   = {signs={'=', ':'}, ignore_function=nil},
        Tex      = M.IGNORE,
        Markdown = M.IGNORE,
    }
end

---Setup function used to set some hierarchical special characters
---@param settings table #Settings table to update the plugin
function M.setup(settings)
    M.set_defaults()
    if not settings then return end
    M.settings = vim.tbl_deep_extend('force', M.settings, settings)
end

-- Load the defaults before loading the plugin
M.set_defaults()

return M
