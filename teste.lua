local monitor = nil
for _, name in ipairs(peripheral.getNames()) do
    if peripheral.getType(name) == "monitor" then
         monitor = peripheral.wrap(name)
         break
    end
end

if monitor then
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("ola, mundo")
else
    print("nenhum monitor")
end
     
