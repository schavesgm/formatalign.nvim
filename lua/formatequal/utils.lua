---Insert a string inside another substring at a given position, performs bound checking
---@param str1 string #Base string
---@param str2 string #Substring to be inserted into str1
---@param pos number #Position where str2 is inserted
local function insert_string(str1, str2, pos)
    assert(0 <= pos and pos <= #str1)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end

---Check if a line should be ignored according to a filter
---@param line string #String to be parsed
---@param filter function #Function to check the condition
local function ignore_this_line(line, filter)
    if (filter == nil) then return false end
    return filter(line)
end

---Check if any line contains the character, ignore filtered lines
local function any_contains_sign(lines, sign, filter)
    for _, line in ipairs(lines) do
        if ignore_this_line(line, filter) then goto continue end
        if (string.find(line, sign) ~= nil) then return true end
        ::continue::
    end
    return false
end


return {
    insert_string = insert_string,
    ignore_this_line = ignore_this_line,
    any_contains_sign = any_contains_sign,
}
