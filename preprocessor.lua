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

    -- Open input file
    inFile = io.open(inFile_name, 'r')

    -- Read all data from input file and close it
    local data = {}
    local inLines = 0

    for line in io.lines(inFile_name) do
        inLines = inLines + 1
        data[inLines] = line
    end

    inFile:close()

    local currLine = 1

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
function processLine(line, data)
    local inst = acl.str_split(line)
    local func = inst[1]:sub(2)

    if func == "define" then
        fDefine(data, inst[2], inst[3])
    end
end

function fDefine(data, word, definition)

end


--[[ Main call ]]--
local ok, err = pcall(main)
if not ok then
    print("Something went wrong :(")
    print(err)
end