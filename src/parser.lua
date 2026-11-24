local parser = { }

function parser.parse(input)
    local parts = {}

    for word in input:gmatch("%S+") do
        table.insert(parts, word)
    end

    return parts

end

return parser