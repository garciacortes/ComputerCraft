local vault = require("../inventory/inventoryList")
local recipesManager = require("../recipes/recipesManager")

local craftingUI = {}
craftingUI.__index = craftingUI

local widthTerm, heightTerm = term.getSize()

function craftingUI:new(tab)
    local obj = {
        tab = tab,
        slots = {}
    }
    setmetatable(obj, craftingUI)
    return obj
end

function craftingUI:createUI()
    local tab = self.tab

    local nameInput = tab:addInput()
        :setPosition(3, 2)
        :setSize(21, 1)
        :setPlaceholder("Nome da Recipe")

    local qtdInput = tab:addInput()
        :setPosition(8, 4)
        :setSize(10, 1)
        :setPlaceholder("Qtd Saida")
        :setPattern("%d+")

    local craftingGrid = tab:addFrame()
        :setSize(19, 13)
        :setPosition(4, 5)
        :setBackground(colors.black)
        :applyLayout("layouts/grid", {
            columns = 3,
            rows = 3,
            spacing = 1,
            padding = 1
        })

    local craftingArea = {}
    for i = 1, 9 do
        local btnIndex = i
        craftingGrid:addButton()
            :setText("[ ]")
            :setBackground(colors.lightGray)
            :onClick(function(btn)
                self:listItemsUI(btn, btnIndex, craftingArea)
            end)
    end

    tab:addButton()
        :setPosition(23, 14)
        :setSize(4, 3)
        :setText("Save")
        :setBackground(colors.gray)
        :onClick(function()
            self:saveRecipe(nameInput, craftingGrid, craftingArea, qtdInput)
        end)
end

function craftingUI:listItemsUI(activeButton, btnIndex, craftingArea)
    local itemsList = vault.getItemListUI()

    local combo = self.tab:addComboBox()
        :setPosition(23, 4)
        :setSize(23, 1)
        :setItems(itemsList)
        :setSelectedText("selecione o Item")
        :setAutoComplete(true)

    combo:onSelect(function(self)
        local value = self:getText()
        if value == "" then return end
        craftingArea[btnIndex] = value

        if value == "vazio" then
            activeButton:setText("[ X ]")
        else
            activeButton:setText("[ O ]")
        end
    end)
end

function craftingUI:clearRecipe(nameInput, grid, qtdInput)
    for _, button in ipairs(grid.get("children")) do
        button:setText("[ ]")
    end
    nameInput:setText("")
    qtdInput:setText("")
end

function craftingUI:saveRecipe(nameInput, grid, craftingArea, qtdInput)
    nameRecipe = nameInput:getText()
    qtdRecipe = qtdInput:getText()

    local recipe = {
        name = nameRecipe,
        quantity = qtdRecipe,
        grid = {},
    }

    for i = 1, 9 do
        recipe.grid[i] = craftingArea[i] or false
    end

    local recipes = recipesManager:getRecipesUI()
    table.insert(recipes, recipe)

    local file = fs.open("recipes.db", "w")

    file.write(textutils.serialise(recipes))
    file.close()
    self:clearRecipe(nameInput, grid, qtdInput)
end

return craftingUI
