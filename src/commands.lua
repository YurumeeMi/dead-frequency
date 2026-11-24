local commands = {}
local filesystem = require("src.filesystem")



function commands.execute(parts)
    local command =  parts[1]
   
   if command == "help" then
    print("Available Commands:")
    print("help - prints all the available commands")
    print("status - shows station status")
    print("exit - disconnect")
   elseif command == "status" then
    print("Station: North-17")
    print("System: Operational")
    print("Archive: Incomplete")
   elseif command == "ls" then
         filesystem.list(parts[2])
   elseif command == "cd" then 
       filesystem.change_directory(parts[2])
       
    else
       print("Unknown command: " .. tostring(command))
   end
end

return commands