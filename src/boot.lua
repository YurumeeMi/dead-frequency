local boot = {}

local function delay(seconds)
    local start = os.clock()

    while os.clock() -  start < seconds do
    end
end

function boot.start()
    print("NORTH/OS BIOS v2.09")
    print("NORTH-17 COMMUNICATIONS SYSTEM")
    print("-------------------------------")
    delay(0.5)

   print("Initializing hardware........ OK")
   delay(0.5)

   print("Checking memory......... OK")
   delay(0.5)

   print("Loading storage.......... OK")
   delay(0.5)

   print("Mounting archive.......... OK")
   delay(0.5)

   print("Initializing radio interface.. WARNING")
   delay(1)

   print("-------------------------------")
   delay(0.5)

   print("Loading NORTH/OS kernel .......... OK")
   delay(0.5)

   print("Starting communications core.. OK")
   delay(0.5)

   print("-------------------------------")
   print("SYSTEM READY")
   print("NORTH-17 ARCHIVE TERMINAL")
   print("-------------------------------")

end


return boot