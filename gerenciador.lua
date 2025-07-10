local monitor = nil
for _, name in ipairs(peripheral.getNames()) do
    if peripheral.getType(name) == "monitor" then
        monitor = peripheral.wrap(name)
        break
    end
end

for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "modem" then
        rednet.open(side)
        break
    end
end

while true do
    local id, msg = rednet.receive()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Primeiro: "..msg)
end
