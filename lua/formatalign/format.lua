local ignore_this_line = require"formatalign.utils".ignore_this_line
local insert_string    = require"formatalign.utils".insert_string

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

    if (spaces == 0) then
        return line:gsub(sign, " " .. sign, 1)
    else
        return line:gsub(line:sub(position - spaces + 1, position), sign)
    end
end

---Format all lines according to format_line_to_sign
---@param lines table #Table containing all lines to be formatted
---@param sign string #Character used as special sign
---@param ignore_line_filter function #Callback funtion that checks if a line should be ignored
local function format_lines(lines, sign, ignore_line_filter)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local new_line = ignore_this_line(line, ignore_line_filter) and line or format_line_to_sign(line, sign)
        table.insert(new_lines, new_line)
    end
    return new_lines
end

---Get the longest column at which sign is located in a collection of lines
---The lines should be previously formatted according to format_lines
---@param lines table #Table containing all lines to be parsed
---@param sign string #Character used as special sign
---@param ignore_line_filter function #Callback funtion that checks if a line should be ignored
local function get_longest_sign_column(lines, sign, ignore_line_filter)
    local longest_column = -1
    for _, line in ipairs(lines) do
        if ignore_this_line(line, ignore_line_filter) then
            goto continue
        end
        longest_column = math.max(longest_column, string.find(line, sign) or -1)
        ::continue::
    end
    return longest_column
end

---Format all files to a particular position; the lines should be previously formatted
---according to format_lines
---@param lines table #Table containing all lines to be parsed
---@param sign string #Character used as special sign
---@param longest_col number #Maximum length where the sign should be present
---@param ignore_line_filter function #Callback funtion that checks if a line should be ignored
local function format_to_longest_col(lines, sign, longest_col, ignore_line_filter)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local current_sign = string.find(line, sign)
        if ignore_this_line(line, ignore_line_filter) or (current_sign == nil) then
            table.insert(new_lines, line)
        else
            local new_line = insert_string(line, string.rep(" ", longest_col - current_sign), current_sign - 1)
            table.insert(new_lines, new_line)
        end
    end
    return new_lines
end


---Format a given selection of lines
local function formatequal_lines(lines, sign, ignore_line_filter)
    lines = format_lines(lines, sign, ignore_line_filter)
    local longest_col = get_longest_sign_column(lines, sign, ignore_line_filter)
    return format_to_longest_col(lines, sign, longest_col, ignore_line_filter)
end

return {
    format_line_to_sign = format_line_to_sign,
    get_spaces_before_position = get_spaces_before_position,
    format_lines = format_lines,
    get_longest_sign_column = get_longest_sign_column,
    format_to_longest_col = format_to_longest_col,
    formatequal_lines = formatequal_lines,
}
