local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("menu:addFoodToInventory", function(food)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not QBCore.Shared.Items[food] then
        print("^1[HATA]: Geçersiz yemek seçimi! Seçilen:", food)
        return
    end
    if Player.Functions.AddItem(food, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[food], "add", 1)
        TriggerClientEvent('QBCore:Notify', src, food .. " envanterine eklendi!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Envanterde yer yok!", "error")
    end
end)
