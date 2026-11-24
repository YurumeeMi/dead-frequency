local filesystem = {}

local current_directory = "/"

local files = {
    ["/"] = {
        "documents",
        "transmissions",
        "recordings"
    },

    ["/documents"] = {
        "incident_report.txt",
        "project_echo.txt",
    },

    ["/transmissions"] = {
        "frequency_87.3.txt"
    },

    ["/recordings"] = {
        "operator_02.txt"
    }
}

local file_contents = {
    ["/documents/incident_report.txt"] = "Incident Report - NoRTH-12\nStatus: Classified",
    ["/documents/project_echo.txt"] = "PROJECT ECHO\nStatus: Unknown",
    ["/transmissions/frequency_87.3.txt"] = "Signal detected at 87.300 Mhz.",
    ["/recordings/operator_02.txt"] = "OPERATOR_02: Is anyone receving this?",
}

local function resolve_path(path)

    if path == nil or path == "" then
        return current_directory
    end

    if path == ".." then
        if current_directory == "/" then
            return "/"
        end
    local parent = current_directory:match("^(.*)/[^/]+$")
    
    if parent == "" then 
        return "/"
    end

    return parent
end
    if path:sub(1, 1) == "/" then 
        return path
    end

    if current_directory == "/" then
        return "/" .. path
    end

    return current_directory .. "/" .. path
end

function filesystem.list(path)
   local target = resolve_path(path)
   local directory = files[target]


    if directory == nil then
        print("Directory not found.")
        return
    end

    for _, item in ipairs(directory) do
        print(item)
    end
end

function filesystem.read(path)
    local target = resolve_path(path)
    local content = file_contents[target]

    if content == nill then
        print("File not found.")
        return
    end

    print(content)
end

function filesystem.change_directory(path)
    local target = resolve_path(path)

    if files[target] == nil then
        print("Directory not found.")
        return
    end

    current_directory = target
end


function filesystem.get_current_directory()
    return current_directory
end

return filesystem