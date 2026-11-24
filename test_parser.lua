local parser = require("src.parser")

local result = parser.parse("signal tune 87.300")

for index, word in ipairs(result) do
    print(index, word)
end