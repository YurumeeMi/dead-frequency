local save = require("src.save")

save.write({
    station = "NORTH-17",
    day = 17,
    compromised =  false
})

local data =  save.read()

for key, value in pairs(data) do
    print(key, value)
end
