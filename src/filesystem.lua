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

local function resolve_path(path)

    if path == nil or path == "" then
        return current_directory
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

function filesystem.change_directory(path)
    local target = resolve_path(path)

    if files[target] == nil then
        print("Directory not found.")
        return
    end

    current_directory = target
end


return filesystem