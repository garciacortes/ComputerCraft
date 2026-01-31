local pixelui = require("pixelui")

math.randomseed(os.epoch("utc"))

local app = pixelui.create()
local root = app:getRoot()

local spacing = 3
local baseX = 11
local list = {}
local temp = {1.5, 2, 2.5, 2.75}
local numPerTemp = 20

for i = numPerTemp * #temp, 1, -1 do
    targetX = baseX + (i * spacing)

    local label = app:createLabel({ 
        y = 10,
        width = 2, height = 4,
        text = math.random(1, 20),
    })
    table.insert(list, {
        lbl = label,
        target = targetX
    })
end

function roll(index, indexTemp)
    local resumed = false
    app:animate({
        duration = temp[indexTemp],
        easing = "linear",
        update = function(progress)
            list[index].lbl.x = math.floor((list[index].target) * progress)
            if not resumed and progress >= 0.1 and index < numPerTemp * indexTemp then
                resumed = true
                roll(index + 1, indexTemp)
            elseif not resumed and index == numPerTemp * indexTemp and indexTemp < #temp then
                resumed = true
                roll(index, indexTemp + 1)
            end
        end,
        onComplete = function()
            if index < #list then
                root:removeChild(list[index].lbl)
            end
        end
    })
    root:addChild(list[index].lbl)
end

roll(1, 1)
app:run()
