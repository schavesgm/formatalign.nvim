---Insert a substring into a given string at a particular position
---@param str1 string #Base string
---@param str2 string #Substring to be inserted into str1
---@param pos number #Location where str2 should be inserted
local function insert_string(str1, str2, pos)
    return str1:sub(1,pos) .. str2 .. str1:sub(pos+1)
end

return {
    insert_string = insert_string,
}
