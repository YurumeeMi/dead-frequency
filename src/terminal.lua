local terminal = {}
local filesystem = require("src.filesystem")
local readline = require("readline")

function terminal.print(text)
    print(text)
end

function terminal.prompt()
    local prompt = "\27[32mNORTH-17:" .. filesystem.get_current_directory() .. "> \27[0m"
    local success, input =  pcall(readline.readline, prompt)

    if not success or input == nil then
        return nil
    end
    
    if input ~= "" then 
        readline.add_history(input)
    end

    return input
end

function terminal.clear()
    os.execute("clear")
end


return terminal