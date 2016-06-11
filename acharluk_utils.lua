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

function acl.file_to_table(file_name)
    local f_data = {}
    local count = 0
    for line in io.lines(file_name) do
        count = count + 1
        f_data[count] = line
    end

    return f_data
end

function acl.insert_table_at(main_table, index, secondary_table)
    for i = 1, #secondary_table do
        table.insert(main_table, i + index, secondary_table[i])
    end
    return main_table, #main_table
end