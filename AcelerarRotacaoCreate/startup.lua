local t = peripheral.wrap("right")
t.setTargetSpeed(1)


while true do
    t.setTargetSpeed(1)

    os.pullEvent("redstone")

    if redstone.getInput("left") then
        parallel.waitForAny(
            function()
                for i = 1, 256 do
                    if not redstone.getInput("left") then
                        return
                    end
                    t.setTargetSpeed(i)
                    sleep(0.5)
                end
            end,

            function()
                while redstone.getInput("left") do
                    os.pullEvent("redstone")
                end
            end
        )
    end
end
