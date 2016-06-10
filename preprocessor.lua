--
-- Author: ACharLuk
--

--Program arguments
local tArgs = { ... }

--File names
local inFile_name, outFile_name = tArgs[1], tArgs[2]

function main()

end

local ok, err = pcall(main)
if not ok then
    print("Something went wrong :(")
    print(err)
end

