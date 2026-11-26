local event = {}

local triggered = {}

function event.trigger(name)
    if triggered[name] then
        return false
    end

    triggered[name] = true
    return true
end

function event.on_trigger(name, action)
    if event.trigger(name) then 
        action()
        end
    end

return event
