---Insert a string inside another substring at a given position, performs bound checking
---@param str1 string #Base string
---@param str2 string #Substring to be inserted into str1
---@param pos number #Position where str2 is inserted
local function insert_string(str1, str2, pos)
    assert(0 <= pos and pos <= #str1)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end

return {
    insert_string = insert_string,
}
