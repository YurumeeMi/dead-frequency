local terminal = {}
local filesystem = require("src.filesystem")

function terminal.print(text)
    print(text)
end

function terminal.prompt()
    io.write("\27[32mNORTH-17:" .. filesystem.get_current_directory() .. "> \27[0m")
    local success, input =  pcall(io.read, "*l")

    if not success then
        return nil
    end
    
    io.write("\27[32m")
    return input
end

function terminal.clear()
    os.execute("clear")
end


return terminal