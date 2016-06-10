--
-- Author: ACharLuk
--

--Program arguments
local tArgs = { ... }

--File names
local inFile_name, outFile_name = tArgs[1], tArgs[2]

local inFile, outFile

function main()

    --Open out files
    inFile = io.open(inFile_name, 'r')
    outFile = io.open(outFile_name, 'w')

    --Read all data from input file and close it
    local data = {}
    local inLines = 0

    for line in io.lines(inFile_name) do
        inLines = inLines + 1
        data[inLines] = line
    end

    inFile:close()



    --Close output file
    outFile:close()

end

local ok, err = pcall(main)
if not ok then
    print("Something went wrong :(")
    print(err)
end

