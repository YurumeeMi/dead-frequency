local boot = {}
local renderer = require("src.renderer")

local function delay(seconds)
    local start = os.clock()

    while os.clock() -  start < seconds do
    end
end

function boot.start()
    renderer.print("NORTH/OS BIOS v2.09", "white")
    renderer.print("NORTH-17 COMMUNICATIONS SYSTEM", "white")
    renderer.print("-------------------------------", "white")
    delay(0.5)

   renderer.print("Initializing hardware........ OK", "white")
   delay(0.5)

   renderer.print("Checking memory......... OK", "white")
   delay(0.5)

   renderer.print("Loading storage.......... OK", "white")
   delay(0.5)

   renderer.print("Mounting archive.......... OK", "white")
   delay(0.5)

   renderer.print("Initializing radio interface.. WARNING", "white")
   delay(1)

   renderer.print("-------------------------------", "white")
   delay(0.5)

   renderer.print("Loading NORTH/OS kernel .......... OK", "white")
   delay(0.5)

   renderer.print("Starting communications core.. OK", "white")
   delay(0.5)

   renderer.print("-------------------------------", "white")
   renderer.print("SYSTEM READY", "white")
   renderer.print("NORTH-17 ARCHIVE TERMINAL",  "white")
   renderer.print("-------------------------------", "white")

end


return boot