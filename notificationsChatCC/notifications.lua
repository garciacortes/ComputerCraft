local chatBox = peripheral.find("chat_box") or peripheral.find("chatBox")
local args = { ... }
local chat = args[1]

parallel.waitForAny(
    function()
        while true do
            local _, message, _ = rednet.receive()

            if message.sType == "text" then
                local playerName = string.match(message.sText, "@([^%s]+)")
                local playerSend = string.match(message.sText, "<(.-)>")

                if playerName and playerSend then
                    chatBox.sendToastToPlayer("Message by " .. playerSend, "Notification Nonozap", playerName)
                end
            end
        end
    end,

    function()
        shell.run("chat join " .. chat .. " notifications_Nofaxu")
    end
)
