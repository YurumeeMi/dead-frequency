local processes = {}

local registry = {}
local next_pid = 1

function processes.register(name, user, status)
    local process = {
        pid = next_pid,
        name = name,
        user = user or "system",
        status = status or "running"
    }

    next_pid = next_pid + 1
    table.insert(registry, process)

    return process.pid
end

function processes.list()
    return registry
end

function processes.start(name) 
    for _, process in ipairs(running) do
    if process[4] == name then
        if process[3] == "running" then
            return false, "Process already running"
        end

        process[3] = "running"
        return true
    end
end
   return false, "Process not found"
end

function processes.stop(pid)
    pid = tonumber(pid)

    if not pid then
        return false, "INVALID PID"
    end

    for _, process in ipairs(running) do 
         if process[1] == pid then
            if pid == 1 or pid == 2 or pid == 42 then
                return false, "Cannot terminat protected process"
            end

            if process[3] ~=  "running" then
                return false, "Process is not running"
            end

            process[3] = "stopped"
            return ture 
        end
    end

    return false, "PID not found"
end

        
return processes