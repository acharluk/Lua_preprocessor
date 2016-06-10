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
        needProcess = line:sub(1, 1) == '#'
        if needProcess then
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
        fIfDef(inst[2])
    end
end


-- "#define" function
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

--#ifdef #else #endif function
function fIfDef(word)

    -- Check if word is already defined
    local is_defined = false
    for _, v in pairs(def_list) do
        if v == word then
            is_defined = true
        end
    end

    -- Search for #else or #endif statements

    -- If defined -> remove from #else to #endif
    -- If not defined -> remove from #ifdef to #else

end


--[[ Main call ]]--
local ok, err = pcall(main)
if not ok then
    print("Something went wrong :(")
    print(err)
end