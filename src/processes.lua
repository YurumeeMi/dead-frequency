local processes = {}

local registry = {}
local next_pid = 1

function processes.register(name, user, status, protected, callbacks)
    protected = protected or false
    callbacks = callbacks or {}
    local process = {
        pid = next_pid,
        name = name,
        user = user or "system",
        status = status or "running",
        protected = protected,
        on_start =  callbacks.on_start,
        on_stop =  callbacks.on_stop
    }

    next_pid = next_pid + 1
    table.insert(registry, process)

    return process.pid
end

function processes.list()
    return registry
end

local function find_by_pid(pid)

    pid = tonumber(pid)

    for _, process in ipairs(registry) do 
        if process.pid == pid then
            return process
        end 
    end 
    return nil
end

function processes.set_status(pid, status)
    local process = find_by_pid(pid)

    if not process then 
        return false, "PID not found"
    end

    local valid = {
        running = true,
        sleeping = true,
        stopped = true
    }

    if not valid[status] then 
        return false, "Invalid process status"
    end

    process.status = status
    return true
end

function processes.start(name)
    for _, process in ipairs(registry) do
        if process.name == name then
            if process.status == "running" then
                return false, "Process already running"
            end
            
            if process.on_start then
                local ok, result, err = pcall(process.on_start, process)

                if not ok then 
                    return false, "Start failed: " .. tostring(result)
                end

                if result == false then
                    return false, err or  "Process refused to start"
                end
            end

            return processes.set_status(process.pid, "running")
        end
    end

    return false, "Process not found"
end

function processes.stop(pid)
    local process = find_by_pid(pid)

    if not process then 
        return false, "PID not found"
    end

    if process.protected then 
        return false, "Cannot terminate protected process"
    end

    if process.status ~= "running" then
        return false, "Process is not running"
    end
    
    if process.on_stop then
        local ok, result, err = pcall(process.on_stop, process)

    if not ok then
        return false, "Stop failed: " .. tostring(result)
    end

    if result == false then
        return false, err or "Process refused to stop"
    end
end

    return processes.set_status(pid, "stopped")
end

function processes.unregister(pid)
    for index, process in ipairs(registry) do 
        if process.pid == tonumber(pid) then
            if process.protected then 
                return false, "Cannot unregister protected process"
            end

            table.remove(registry, index)
            return true
        end
    end
    
    return false, "PID not found"
end


        
return processes