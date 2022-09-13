local utils = require"formatequal.utils"

---Get all spaces between position in string and first non-space word
---Example:
---get_spaces_before_position("  hola    = 1", 11) = 4
---@param line string #Line to be used as reference
---@param position number #Number to start looking for spaces, starts one before this number
local function get_spaces_before_position(line, position)
    if (position == -1) then return 0 end
    local spaces = 0
    for c in line:sub(1, position - 1):reverse():gmatch(".") do
        if (c == " ") then
            spaces = spaces + 1
        else
            return spaces
        end
    end
end

---Format a given line, trimming all spaces before sign and actual text
---Example: 
---format_line_to_sign("    hola: int      = 2", "=") = "    hola: int = 2"
---@param line string #Line to be formatted
---@param sign string #Character used as special sign
local function format_line_to_sign(line, sign)
    local position = string.find(line, sign)
    if (position == nil) then return line end
    local spaces = get_spaces_before_position(line, position)
    local str_replace = string.sub(line, position - spaces + 1, position)
    return line:gsub(str_replace, sign)
end

---Format all lines according to format_line_to_sign
---@param lines table #Table containing all lines to be formatted
---@param sign string #Character used as special sign
---@param ignore_line_filter function #Callback funtion that sets if a line should be ignored
local function format_lines(lines, sign, ignore_line_filter)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local new_line = utils.ignore_this_line(line, ignore_line_filter) and line or format_line_to_sign(line, sign)
        table.insert(new_lines, new_line)
    end
    return new_lines
end

return {
    format_line_to_sign = format_line_to_sign,
    get_spaces_before_position = get_spaces_before_position,
    format_lines = format_lines,
}
