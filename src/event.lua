local event = {}
local save = require("src.save")
local triggered = {}

function event.trigger(name, state)
    local key = "event_ " .. name

    if state[key] then
        return false
    end

    state[key] = true
    return true
end

function event.on_trigger(name, state, action)
    if event.trigger(name, state) then 
        action()
        save.write(state)
        return true
        end

        return false
    end

return event
