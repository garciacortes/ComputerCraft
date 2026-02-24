local basalt = require("..basalt/init")
local craftingUI = require("UI/craftingSave")
local requesterUI = require("UI/craftingRequest")

local widthTerm, heightTerm = term.getSize()
local main = basalt.getMainFrame():setBackground(colors.lightGray)
main:openConsole()

local tabControl = main:addTabControl()
    :setSize(widthTerm, 15)
    :setPosition(1, 1)

local CraftingSaveTab = tabControl:newTab("Crafting")
local CraftingRequestTab = tabControl:newTab("Request")

CraftingSaveTab:setSize(widthTerm, heightTerm)
CraftingRequestTab:setSize(widthTerm, heightTerm)

local craftingUI = craftingUI:new(CraftingSaveTab)
local requesterUI = requesterUI:new(CraftingRequestTab)

craftingUI:createUI()
requesterUI:createUI()

tabControl:onChange("activeTab", function(oldTabId, newTabId)
    if newTabId == 2 then
        requesterUI:updateList()
    end
end)

basalt.LOGGER.setEnabled(true)
basalt.LOGGER.setLogToFile(true)
basalt.run()
