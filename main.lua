local terminal = require("src.terminal")
local parser = require("src.parser")
local commands = require("src.commands")
local boot = require("src.boot")
local event = require("src.event")
local save = require("src.save")

boot.start()

local state, load_error = save.read()

if not state then
    print("SAVE ERROR: " .. tostring(load_error))
    os.exit(1)
end

state.station = state.station or "NORTH-17"
state.compromised = state.compromised or false
state.day = state.day or 17

local function shutdown()
    if save.write(state) then
        print("STATE SAVED.")
    else
        print("SAVE ERROR: Could not save station state")
    end
end


while true do
    local input = terminal.prompt()

    if input == nil then 
        shutdown()
        print("\n SHUTTING DOWN NORTH/OS")
        break
    end

    local parts = parser.parse(input)
    local command = parts [1]


     
    if command == nil then 
   
    elseif command == "exit" then
        print("Disconnecting...")
        shutdown()
        break
    else
    commands.execute(parts, state)

    ::continue::
    end

end