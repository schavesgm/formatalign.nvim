local M = {}

local regex_emptyline = vim.regex("\\(^$\\)\\|\\(^\\s\\+$\\)")

---Function to ignore some python lines
M.python = function(line)
    local is_empty   = (regex_emptyline:match_str(line) ~= nil)
    local is_comment = (vim.regex('^\\s\\+#.*'):match_str(line) ~= nil)
    return is_empty or is_comment
end

---Function to ignore some lua lines
M.lua = function(line)
    local is_empty   = (regex_emptyline:match_str(line) ~= nil)
    local is_comment = (vim.regex('^\\s\\+--.*'):match_str(line) ~= nil)
    return is_empty or is_comment
end

return M
