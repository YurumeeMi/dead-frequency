local save = {}

local SAVE_PATH = "saves/north17.dat"
local function shell_quote(value) 
        return "'" .. value:gsub("'", "'\\''") .. "'"
    end
    

function save.write(data)
    local serialized = ""

    for key, value in pairs(data) do
        serialized = serialized .. key .. "=" .. tostring(value) .. "\n"
    end

    local temp_path = SAVE_PATH .. ".tmp"

    local command = "python3 " .. shell_quote("src/crypto.py")
       .. " encrypt > " .. shell_quote(temp_path)
       .. " && mv " .. shell_quote(temp_path)
       .. " " .. shell_quote(SAVE_PATH)

    local pipe = io.popen(command, "w")

    if not pipe then 
        return false
    end

    pipe:write(serialized)
    local success = pipe:close()

    if success ~= true then
        os.remove(temp_path)
        return false
    end

    return true
end

function save.read()
    local check = io.open(SAVE_PATH, "rb")

    if not check then 
        return {}
    end

    check:close()

    local command = "python3 " .. shell_quote("src/crypto.py")
    .. " decrypt < " .. shell_quote(SAVE_PATH)

    local pipe = io.popen(command, "r")

    if not pipe then 
        return nil, "Could not start decryption"
    end

    local serialized = pipe:read("*a")
    local success = pipe:close()

    if not success then 
        return nil, "Save decryption failed"
    end
    
    local data = {}

    for line in serialized:gmatch("[^\r\n]+") do 
       local key, value = line:match("^([^=]+)=(.*)$")

        if key then 
            if value == "true" then 
                value = true
            elseif value == "false" then
                value = false
            elseif tonumber(value) then 
                value = tonumber(value)
            end
            data[key] = value
        end
    end

    return data
end

return save