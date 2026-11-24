local commands = {}
local renderer = require("src.renderer")
local filesystem = require("src.filesystem")
local terminal = require("src.terminal")



function commands.execute(parts)
    local command =  parts[1]
   
   if command == "help" then
    renderer.title("NORTH/OS COMMANDS")
    print("-----------------------------")
    renderer.print("help - prints all the available commands", "green")
    renderer.print("status - shows station status", "green")
    renderer.print("ls - List directory contents", "green")
    renderer.print("cd - Change directory", "green")
    renderer.print("cat - Read an archive file", "green")
    renderer.print("exit - disconnect", "green")
    renderer.print("clear - clear terminal", "green")

    print("-----------------------------")

   elseif command == "status" then
    renderer.title("Station Status:")
    renderer.print("Station: North-17", "green")
    renderer.print("System: Operational", "green")
    renderer.metadata("Archive: Incomplete")
   elseif command == "ls" then
         filesystem.list(parts[2])
   elseif command == "cd" then 
       filesystem.change_directory(parts[2])
   elseif command == "cat" then 
       filesystem.read(parts[2])

   elseif command == "clear" then
        terminal.clear()
    else
       print("Unknown command: " .. tostring(command))
   end
end

return commands