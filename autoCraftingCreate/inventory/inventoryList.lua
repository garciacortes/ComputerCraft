local inv = {}

local vault = peripheral.wrap("create:item_vault_0")

function inv.getItemListUI()
    local items = {}

    table.insert(items, { text = "vazio" })

    for slot, item in pairs(vault.list()) do
        table.insert(items, { text = item.name })
    end
    return items
end

function inv.getItemListRecipe()
    local items = {}

    for slot, item in pairs(vault.list()) do
        items[item.name] = {slot = slot, count = item.count}
    end
    return items
end

return inv
