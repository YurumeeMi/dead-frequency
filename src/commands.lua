local commands = {}
local renderer = require("src.renderer")
local filesystem = require("src.filesystem")
local mail =  require("src.mail")
local terminal = require("src.terminal")
local processes = require("src.processes")
local boot_time = os.time()

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
    renderer.print("whoami - prints the name of the user", "green")
    renderer.print("hostname - prints the host machine name", "green")
    renderer.print("date - prints date & time", "green")
    renderer.print("history - show command history", "green")
    renderer.print("uname - display system information", "green")
    renderer.print("uptime -  show system uptime", "green")
    renderer.print("ps - display registered processes", "green")
    renderer.print("ver - display NORTH/OS version", "green")
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

    elseif command == "whoami" then
        terminal.print("operator")

    elseif command == "hostname" then
        terminal.print("NORTH-17")

    elseif command == "date" then
        local current = os.date("*t")
        current.year = 2009

        local game_time = os.time(current)
        terminal.print(os.date("%a %b %H:%M:%S %Z %Y", game_time))

    elseif command == "pwd" then
        renderer.print(filesystem.get_current_directory(), "green")
    elseif command == "history" then
         terminal.show_history()
   elseif command == "clear" then
        terminal.clear()
   elseif command == "echo" then
        terminal.print(table.concat(parts, " ", 2))
   elseif command == "uname" then 
    if parts[2] == "-a" then
        terminal.print("NORTH/OS NORTH-17 2.09 x86_64")
    else
        terminal.print("NORTH/OS")
    end
    
   elseif command == "uptime" then
    local elapsed = os.difftime(os.time(), boot_time)

    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor(elapsed % 3600 / 60)
    local seconds = math.floor(elapsed % 60)
    
    terminal.print(string.format(
        "System uptime: %02d:%02d:%02d",
        hours, minutes, seconds
    ))

   elseif command == "ver" then
    terminal.print("NORTH/OS VERSION 2.09")

   elseif command == "ps" then
    terminal.print("PID  USER      STATUS   COMMAND")
    terminal.print("-------------------------------------")

    for _, process in ipairs(processes.list()) do
        terminal.print(string.format(
            "%-5d %-10s %-11s %s",
            process.pid,
            process.user,
            process.status,
            process.name
        ))
    end

   else
       renderer.error("Unknown command: " .. tostring(command))
       renderer.metadata("Type 'help' to see available commands.")

   end

  
end

return commands