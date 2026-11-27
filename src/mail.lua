local mail = {}
local processes = require("src.processes")
local mail_pid = processes.register("mail-service", "system")
local messages = {
    {
    id = 1,
    sender = "ADMINISTRATION",
    subject = "Welcome to NORTH-17",
    date = "2009-08-17",
    body = "Your shift begins at 00:00",
    read =  false
    }
}

function mail.list()
    for _, message in ipairs(messages) do 
        local status = message.read and "[READ]" or "[UNREAD]"
        print(message.id .. ". " .. message.subject .. " " .. status)
    end
end

function mail.read(id)
    for _, message in ipairs(messages) do
        if message.id == id then
            print("FROM: " .. message.sender)
            print("SUBJECT: " .. message.subject)
            print("DATE: " ..  message.date)
            print()
            print(message.body)

            message.read = true
            return
        end
    end
    print("Message not found.")
end

function mail.receive(sender, subject, date, body)
    local id = #messages + 1

    local new_messages = {
        id = id,
        sender = sender,
        subject =  subject,
        date =  date,
        body = body,
        read = false
    }
    
    table.insert(messages, new_messages)

end

function mail.exists(subject)
    for _, message in ipairs(messages) do
        if message.subject == subject then
            return true
        end
    end
    return false
end

return mail
