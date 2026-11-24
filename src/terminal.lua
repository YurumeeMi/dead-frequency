local terminal = {}
local filesystem = require("src.filesystem")

function terminal.print(text)
    print(text)
end

function terminal.prompt()
    io.write("\n NORTH-17:" .. filesystem.get_current_directory() .. "> ")
    return io.read("*l")
end

function terminal.clear()
    os.execute("clear")
end


return terminal