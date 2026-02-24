local RecipesManager = {}
RecipesManager.__index = RecipesManager
local inventorysistem = require("../inventory/inventoryList")

function RecipesManager:new()
  local obj = {
    recipe = {
      name = nil,
      quantity = nil
    },
    ingredientsFinal = {}
  }

  setmetatable(obj, RecipesManager)
  return obj
end

function RecipesManager:getRecipesUI()
  local recipesListUI = {}

  local file = fs.open("recipes.db", "r")
  if not file then return recipesListUI end

  local content = file.readAll()

  local recipes = textutils.unserialise(content)
  if not recipes then return recipesListUI end

  for _, recipe in ipairs(recipes) do
    table.insert(recipesListUI, recipe)
  end
  file.close()

  return recipesListUI
end

function RecipesManager:getRecipesManager()
  local recipesList = {}

  local file = fs.open("recipes.db", "r")
  if not file then return recipesList end

  local content = file.readAll()

  local recipes = textutils.unserialise(content)
  if not recipes then return recipesList end

  for _, recipe in ipairs(recipes) do
    recipesList[recipe.name] = recipe
  end
  file.close()

  return recipesList
end

function RecipesManager:buildRecipe(recipeSelected)
  local virtualStock = inventorysistem.getItemListRecipe()
  local recipes = self:getRecipesManager()

  local nameRecipe = recipeSelected.name
  local quantityRecipe = recipeSelected.quantity

  local middleIngredients = {}

  self:hasItemInventory(virtualStock, nameRecipe, quantityRecipe, recipes, middleIngredients)
  
  local index = 1
  repeat
    if next(middleIngredients) ~= nil and recipes[middleIngredients[index].name] and middleIngredients[index].stock <= 0 then
      
      local name = middleIngredients[index].name
      local requested = middleIngredients[index].requested
      middleIngredients[index].toCraft = true
      
      self:hasItemInventory(virtualStock, name, requested, recipes, middleIngredients)
    end
    
    index = index + 1
  until middleIngredients[index] == nil
  
  return middleIngredients
end

function RecipesManager:hasItemInventory(virtualStock, name, quantity, recipes, middleIngredients)
  local currentIngredients = {}
  local recipe = recipes[name]

  local quantityCraft = math.ceil(quantity / recipe.quantity)

  if recipe then
    for _, ingredient in ipairs(recipe.grid) do
      if ingredient then
        local dataStock = virtualStock[ingredient]
        local dataIngredients = currentIngredients[ingredient]

        if not dataIngredients then
          dataIngredients = {
            requested = 0,
            stock = 0,
            toCraft = false
          }
          currentIngredients[ingredient] = dataIngredients
        end

        if dataStock then
          dataIngredients.stock = dataStock.count
          dataStock.count = math.max(0, dataStock.count - quantityCraft)
        end

        dataIngredients.requested = dataIngredients.requested + quantityCraft
      end
    end
  end

  assert(next(currentIngredients) ~= nil, "nao existe ingredients na recipe")
  for itemName, data in pairs(currentIngredients) do
    table.insert(middleIngredients, { name = itemName, requested = data.requested, stock = data.stock })
  end
end

return RecipesManager
