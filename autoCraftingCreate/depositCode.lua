--[[local slotFinal = nil

for slot, item in pairs(chest_b.list()) do
    if "minecraft:stick" == item.name then
        slotFinal = slot
        break
    end
end

chest_a.pullItems(peripheral.getName(chest_b), slotFinal, 1, 5)
sleep(0.5)
redstone.setOutput("left", true)
sleep(0.5)
redstone.setOutput("left", false)
]]--