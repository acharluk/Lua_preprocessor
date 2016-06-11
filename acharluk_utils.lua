acl = acl or {}

function acl.str_split(str, reg)
    reg = reg or "%S+"
    local spl = {}
    local count = 1

    for i in string.gmatch(str, reg) do
        spl[count] = i
        count = count + 1
    end

    return spl
end

function acl.search_tab(tab, word)
    for _, v in pairs(tab) do
       if v == word then
           return true
       end
    end
    return false
end