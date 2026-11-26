local commands = {}
local renderer = require("src.renderer")
local filesystem = require("src.filesystem")
local mail =  require("src.mail")
local terminal = require("src.terminal")



function commands.execute(parts, state)
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
    renderer.print("pwd - prints current directory", "green")
    renderer.print("mail - read internal mails",  "green")
    renderer.print("echo - prints what you say on the term", "green")
    print("-----------------------------")

   elseif command == "status" then
    renderer.title("Station Status:")
    renderer.print("Station: " .. tostring(state.station), "green")
    renderer.print("System: Operational", "green")
    renderer.metadata("Archive: Incomplete")
    renderer.metadata("Day: " .. tostring(state.day))
    renderer.metadata("Compromised: " .. tostring(state.compromised and "YES" and "NO"))
   elseif command == "ls" then
         filesystem.list(parts[2])

   elseif command == "cd" then 
       if parts[2] == nil then
        renderer.error("ERROR: Missing directory.")
        renderer.metadata("Usage: cd <directory>")
       else 
        filesystem.change_directory(parts[2])
    end

   elseif command == "cat" then 
       if parts[2] ==  nil  then
        renderer.error("ERROR: Missing filename.")
        renderer.metadata("Usage: cat <filename>")
       else
        filesystem.read(parts[2])
    end

    elseif command == "mail" then
      if parts[2] == "read" and parts[3] ~= nil then
        mail.read(tonumber(parts[3]))

   
    else
        renderer.title("NORTH-17 INTERNAL MAIL")
        mail.list()
      
      end



    elseif command == "pwd" then
        renderer.print(filesystem.get_current_directory(), "green")

   elseif command == "clear" then
        terminal.clear()
   elseif command == "echo" then
        terminal.print(table.concat(parts, " ", 2))
    else
       renderer.error("Unknown command: " .. tostring(command))
       renderer.metadata("Type 'help' to see available commands.")

   end

  
end

return commands