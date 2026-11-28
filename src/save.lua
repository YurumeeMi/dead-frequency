local save = {}

local LEGACY_SAVE_PATH = "saves/north17.dat"
local DATA_DIR = os.getenv("DEAD_FREQUENCY_DATA_DIR")

local SAVE_PATH = LEGACY_SAVE_PATH

if DATA_DIR and DATA_DIR ~= "" then
    SAVE_PATH = DATA_DIR .. "/saves/north17.dat"
end

local function shell_quote(value) 
        return "'" .. value:gsub("'", "'\\''") .. "'"
    end
    
local function migrate_legacy_save()
    if SAVE_PATH == LEGACY_SAVE_PATH then 
        return true
    end

    local existing = io.open(SAVE_PATH, "rb")
    if existing then 
        existing:close()
        return true
    end

    local legacy = io.open(LEGACY_SAVE_PATH, "rb")
    if not legacy then 
        return true
    end

    if not contents then 
        return false, "Could not read old save"
    end

    local temp = SAVE_PATH .. ".migrate.tmp"
    local file = io.open(temp, "wb")
    
    if not file then 
        return false, "Could not create migrated save"
    end

    local written, write_err = file:write(contents)
    local closed, close_err = file:close()

    if not written or not closed then
        os.remove(temp)
        return false, write_err or close_err
    end

    local renamed, rename_err = os.rename(temp, SAVE_PATH)

    if not renamed then
        os.remove(temp)
        return false, rename_err
    end

    return true
end

function save.write(data)

    local migrated, err = migrate_legacy_save()

    if not migrated then 
        return false, err
    end

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

    local migrated, err =  migrate_legacy_save

    if not migrated then 
        return nil, err
    end
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