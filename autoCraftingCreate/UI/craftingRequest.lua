local RequesterUI = {}
RequesterUI.__index = RequesterUI
local recipesManager = require("../recipes/recipesManager")
local basalt = require("..basalt/init")

local recipesManager = recipesManager:new()

function RequesterUI:new(tab)
  local obj = {
    tab = tab,
    list = nil,
    recipeSelected = {
      name = nil,
      quantity = nil
    }
  }
  setmetatable(obj, RequesterUI)
  return obj
end

function RequesterUI:updateList()
  local recipes = recipesManager:getRecipesManager()
  if self.list then
    self.list:clear()

    for recipeName, recipe in pairs(recipes) do
      self.list:addItem(recipeName)
    end
  end
end

function RequesterUI:createUI()
  tab = self.tab

  self.list = tab:addList()
      :setPosition(1, 1)
      :setSize(52, 18)
      :setBackground(colors.black)
      :setForeground(colors.white)
      :setEmptyText("no Recipes")
      :setSelectedBackground(colors.blue)
      :setSelectedForeground(colors.black)

  self.list:onSelect(function(_, _)
    local item = self.list:getSelectedItem()
    self.recipeSelected.name = item.text
    self:selectQuantityUI()
  end)

  self:updateList()
end

function RequesterUI:selectQuantityUI()
  local btnAdd = { 1, 10, 100 }
  local btnSub = { 1, 10, 100 }
  local qtdInput = nil
  local valueInput = 0

  local dialogQuantity = self.tab:addDialog()
      :setModal(true)
      :setPosition(15, 6)
      :setSize(22, 9)
      :setBackground(colors.gray)
      :removeBorder()

  dialogQuantity:applyLayout("layouts/flow", {
    direction = "vertical",
    spacing = 0,
    padding = 0,
  })

  local frameCloseDialog = dialogQuantity:addFrame()
      :setSize(22, 2)
      :setBackground(colors.gray)

  frameCloseDialog:applyLayout("layouts/flow", {
    direction = "horizontal",
    spacing = 0,
    padding = 1,
    align = "end"
  })

  local btnClose = frameCloseDialog:addButton()
      :setText("Close")
      :setBackground(colors.lightGray)
      :setForeground(colors.white)
      :setSize(6, 1)
      :setForegroundState("clicked", colors.black)
      :setBackgroundState("clicked", colors.lightBlue)
      :onClick(function()
        dialogQuantity:destroy()
        self.list:clearItemSelection()
      end)


  local frameQuantity = dialogQuantity:addFrame()
      :setSize(22, 7)
      :setBackground(colors.gray)

  frameQuantity:applyLayout("layouts/spanGrid", {
    columns = 3,
    rows = 3,
    spacing = 1,
    padding = 1,
    spans = {
      [2] = { 1, 2 },
    }
  })


  for _, v in ipairs(btnAdd) do
    local qtd = v
    frameQuantity:addButton()
        :setText("+" .. v)
        :setBackground(colors.lightGray)
        :setForeground(colors.white)
        :onClick(function()
          qtdAtual = tonumber(qtdInput:getText())
          qtdInput:setText(tostring(qtdAtual + qtd))
        end)
  end

  qtdInput = frameQuantity:addInput()
      :setText(tostring(valueInput))
      :setBackground(colors.lightGray)
      :setForeground(colors.white)
      :setPattern("%d")

  frameQuantity:addButton()
      :setText("next")
      :setBackground(colors.lightGray)
      :setForeground(colors.white)
      :onClick(function()
        self.recipeSelected.quantity = tonumber(qtdInput:getText())
        local ingredients = recipesManager:buildRecipe(self.recipeSelected)
        if ingredients then
          dialogQuantity:destroy()
          self:viewItensRecipesUI(ingredients)
        end
      end)

  for _, v in ipairs(btnSub) do
    local qtd = v
    frameQuantity:addButton()
        :setText("-" .. v)
        :setBackground(colors.lightGray)
        :setForeground(colors.white)
        :onClick(function()
          qtdAtual = tonumber(qtdInput:getText())
          if qtdAtual >= qtd then
            qtdInput:setText(tostring(qtdAtual - qtd))
          else
            qtdInput:setText(tostring(0))
          end
        end)
  end
end

function RequesterUI:viewItensRecipesUI(ingredients)
  if not ingredients then return end

  self.list:setVisible(false)

  local dialogViewItens = self.tab:addDialog()
      :setModal(true)
      :setPosition(11, 2)
      :setSize(27, 17)
      :setBackground(colors.gray)
      :removeBorder()

  local frameCloseDialog = dialogViewItens:addFrame()
      :setSize(27, 2)
      :setBackground(colors.gray)
      :setPosition(1, 15)

  frameCloseDialog:applyLayout("layouts/flow", {
    direction = "horizontal",
    spacing = 1,
    padding = 1,
    align = "end"
  })

  frameCloseDialog:addButton()
      :setText("Close")
      :setBackground(colors.lightGray)
      :setForeground(colors.white)
      :setSize(6, 1)
      :setForegroundState("clicked", colors.black)
      :setBackgroundState("clicked", colors.lightBlue)
      :onClick(function()
        dialogViewItens:destroy()
        self.list:clearItemSelection()
        self.list:setVisible(true)
      end)

  frameCloseDialog:addButton()
      :setText("craft")
      :setBackground(colors.lightGray)
      :setForeground(colors.white)
      :setSize(6, 1)
      :setForegroundState("clicked", colors.black)
      :setBackgroundState("clicked", colors.lightBlue)


  local listViewItens = dialogViewItens:addScrollFrame()
      :setSize(27, 15)
      :setBackground(colors.gray)

  listViewItens:applyLayout("layouts/flow", {
    direction = "vertical",
  })

  for _, data in ipairs(ingredients) do
    local textBox = listViewItens:addTextBox()
        :setSize(27, 2)

    if data.stock > 0 then
      textBox:setText(" " .. data.name .. "\n" .. " Availabe: " .. data.stock)
          :setBackground(colors.lightGray)
    elseif data.stock == 0 and not data.toCraft then
      textBox:setText(" " .. data.name .. "\n" .. " Missing: " .. data.requested)
          :setBackground(colors.red)
    else
      textBox:setText(" " .. data.name .. "\n" .. " To Craft: " .. data.requested)
          :setBackground(colors.yellow)
    end
  end
end

function RequesterUI:getSelectedRecipe()
  return self.selectedRecipe.quantity
end

return RequesterUI
