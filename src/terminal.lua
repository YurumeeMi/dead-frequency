local terminal = {}

function terminal.print(text)
    print(text)
end

function terminal.prompt()
    io.write("\n NORTH-17>")
    return io.read("*l")
end

function terminal.clear()
    os.execute("clear")
end


return terminal