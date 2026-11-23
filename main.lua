local terminal = require("src.terminal")

print("NORTH/OS")
print("Communications Research Terminal")
print("--------------------------------")

while true do
    local input = terminal.prompt()

    if input == nil then 
        print("\n Connection interrupted")
        break
    end

    if input == "exit" then
        print("Disconnecting...")
        break
    end

    print("Unknown command: " .. input)

end