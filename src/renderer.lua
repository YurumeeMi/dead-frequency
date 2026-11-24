local renderer = {}

local colors = {
    reset = "\27[0m",
    green = "\27[32m",
    amber = "\27[33m",
    red = "\27[31m",
    grey = "\27[90m",
    bold = "\27[1m",
    dim = "\27[2m",
}

function renderer.print(text, color)
    local selected = colors[color] or colors.green

    print(selected .. text .. colors.reset)
end

function renderer.title(text)
    print(colors.bold .. colors.green .. text .. colors.reset)
end

function renderer.error(text)
    print(colors.red .. text .. colors.reset)
end


function renderer.metadata(text) 
    print(colors.grey .. text .. colors.reset)
end

function renderer.document(doc)
    renderer.title("NORTH-17 ARCHIVE SYSTEM")
    print("------------------------------")
    renderer.print(doc.title, "amber")
    print("------------------------------")
    renderer.metadata("FILE ID: " .. doc.id)
    renderer.metadata("DATE: " .. doc.date)
    renderer.print("CLASSIFICATION: " .. doc.classification, "red")
    print("------------------------------")
    print()
    print(doc.content)
    print()
    renderer.metadata("[ END OF DOCUMENT ]")
end

return renderer
