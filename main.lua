local terminal = require("src.terminal")
local parser = require("src.parser")
local commands = require("src.commands")
local boot = require("src.boot")



boot.start()


while true do
    local input = terminal.prompt()

    if input == nil then 
        print("\n Connection interrupted")
        break
    end

    local parts = parser.parse(input)
    local command = parts [1]


     
    if command == nil then 
   
    elseif command == "exit" then
        print("Disconnecting...")
        break
    else
    commands.execute(parts)

    ::continue::
    end

end