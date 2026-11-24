local terminal = require("src.terminal")
local parser= require("src.parser")

print("NORTH/OS")
print("Communications Research Terminal")
print("--------------------------------")

while true do
    local input = terminal.prompt()

    if input == nil then 
        print("\n Connection interrupted")
        break
    end

    local parts = parser.parse(input)
    local command = parts [1]

    if command == "exit" then
        print("Disconnecting...")
        break
    end

   

    print("Received command: " ..  tostring(command))

end