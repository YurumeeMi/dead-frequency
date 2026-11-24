local filesystem = {}
local renderer = require("src.renderer")

local function load_document(path)
    local file = io.open(path, "r")

    if file == nil then 
        return nil
    end

    local content = file:read("*a")
    file:close()

    return content
end
local function parse_document(raw)
    local metadata, body = raw:match("^(.-)\n\n(.*)$")

    if not metadata then
        return nil
    end
    
    local document = {}

    for line in metadata:gmatch("[^\r\n]+") do
        local key, value = line:match("^([%w_]+):%s*(.*)$")

        if key then
            document[key:lower()] = value
        end
    end
    document.content = body
    
    return document
end

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


local file_contents = {}
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
   
    
    if target:match("^/documents/") 
       or target:match("^/transmissions/") 
       or target:match("^/recordings/")then
       
        local external_content = load_document("content" .. target)

        if external_content then
            local document = parse_document(external_content)

            if document then
                renderer.document(document)
            else
                print(external_content)
            end

            return
        end
    end
    local content = file_contents[target]

    if content ==  nil then
        print("File Not Found.")
        return
    end

    if type(content) == "string" then 
        print(content)
        return
    end

    
   renderer.document(content)
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