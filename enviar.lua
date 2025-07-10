for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "modem" then
        rednet.open(side)
        break
    end
end

write("Nome: ")
local nome = io.read()

while true do
    term.clear()
    term.setCursorPos(1, 1)
    write("Aperte Enter para funcionar")
    local event, key = os.pullEvent("key")
    if key == keys.enter then
        print("teste")
        rednet.broadcast(nome)
    end
end   
