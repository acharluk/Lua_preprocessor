--
-- Author: ACharLuk
--

require('acharluk_utils')

-- Program arguments
local tArgs = { ... }

-- File names
local inFile_name, outFile_name = tArgs[1], tArgs[2]

local inFile, outFile

function main()

    n_defs = 0
    def_list = {}

    -- Open input file
    inFile = io.open(inFile_name, 'r')

    -- Read all data from input file and close it
    data = {}
    inLines = 0

    for line in io.lines(inFile_name) do
        inLines = inLines + 1
        data[inLines] = line
    end

    inFile:close()

    currLine = 1

    -- Main processing loop
    while currLine < inLines do
        local line = data[currLine]

        -- Check if there is a # at start of the line
        if line:sub(1, 1) == '#' then
            processLine(line, data)
        end

        currLine = currLine + 1
    end

    -- Open output file
    outFile = io.open(outFile_name, 'w')

    -- Write processed data to output file
    for _, v in pairs(data) do
        outFile:write(v .. '\n')
    end

    -- Close output file
    outFile:close()

end


--[[ Functions ]]--
-- Main processing function
function processLine(line)
    -- Separate words into a table
    local inst = acl.str_split(line)
    local func = inst[1]:sub(2)

    -- All preprocessor function calls go here
    if func == "define" then
        fDefine(inst[2], inst[3])
    elseif func == "ifdef" then
        fIfDef(inst[2], false)
    elseif func == "ifndef" then
        fIfDef(inst[2], true)
    elseif func == "include" then
        fInclude(inst[2])
    end
end


-- #define function
function fDefine(word, definition)
    if definition ~= nil then
        -- Search and replace all words with the definition
        for j = 1, inLines do
            data[j] = string.gsub(data[j], word, definition)
        end
    end

    -- Remove the preprocessor line from the data
    table.remove(data, currLine)

    -- Decrement the number of lines and current line
    inLines = inLines - 1
    currLine = currLine - 1

    -- Add define to the list
    n_defs = n_defs + 1
    def_list[n_defs] = word
end

-- #ifdef #else #endif function
function fIfDef(word, inverted)

    -- Check if word is already defined
    local is_defined = acl.search_tab(def_list, word)
    if inverted then
       is_defined = not is_defined
    end

    -- Data between #ifdef and #else or #endif
    local if_data = {}

    -- Data between #else and #endif (may be nil)
    local else_data = {}

    -- Lines where #ifdef, #else and #endif
    -- are in data table
    local ifLine, elseLine, endifLine

    -- Set start point on the current line
    ifLine = currLine

    -- Search for #else or #endif statements
    local exists_else = false

    for l = currLine + 1, inLines do
        if data[l] == "#else" then
            elseLine = l
            exists_else = true
            break
        elseif data[l] == "#endif" then
            endifLine = l
            break
        end
        if_data[l] = data[l]
    end

    if exists_else then
        for l = ifLine + 1, inLines do
            if data[l] == "#endif" then
                endifLine = l
                break
            end
            else_data[l] = data[l]
        end
    end

    -- If defined -> remove from #else to #endif
    -- If not defined -> remove from #ifdef to #else
    if is_defined then
        for l = endifLine, elseLine, -1 do
            table.remove(data, l)
            inLines = inLines - 1
        end
        table.remove(data, ifLine)
        inLines = inLines - 1
    else
        table.remove(data, endifLine)
        inLines = inLines - 1
        for l = elseLine or endifLine, ifLine, -1 do
            table.remove(data, l)
            inLines = inLines - 1
        end
    end

end

-- #include function
function fInclude(file_name)
    -- Add all include file data in the data table
    data, nl = acl.insert_table_at(data, currLine, acl.file_to_table(file_name))

    -- Remove the #include line
    table.remove(data, currLine)
    inLines = nl - 1
end


--[[ Main call ]]--
local ok, err = pcall(main)
if not ok then
    print("Something went wrong :(")
    print(err)
end