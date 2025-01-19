local QBCore = exports['qb-core']:GetCoreObject()
local isMenuOpen = false


local function drawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


local function openMenu()

    local menu = {
        { header = "🍽️ Yemek Seçimi", isMenuHeader = true } 
    }
    for _, item in ipairs(Config.MenuItems) do
        table.insert(menu, {
            header = item.header,
            txt = item.txt,
            params = { event = item.event, args = item.args }
        })
    end
    table.insert(menu, {
        header = "❌ Kapat",
        txt = "Menüyü kapat",
        params = { event = "qb-menu:closeMenu" }
    })
    exports['qb-menu']:openMenu(menu)
    QBCore.Functions.Notify("Menü açıldı, bir yemek seçebilirsiniz!", "success")
end
RegisterNetEvent("qb-menu:closeMenu", function()
    isMenuOpen = false
    QBCore.Functions.Notify("Menü kapatıldı.", "error")
end)
RegisterNetEvent("menu:selectFood", function(food)
    isMenuOpen = false
    TriggerServerEvent("menu:addFoodToInventory", food)
end)



CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, location in ipairs(Config.Locations) do
            local dist = #(pos - location)
            if dist < 2.0 then
                local playerJob = QBCore.Functions.GetPlayerData().job

                local function isAllowedJob(job)
                    for _, allowedJob in ipairs(Config.Jobs) do
                        if job == allowedJob then
                            return true
                        end
                    end
                    return false
                end
                if playerJob and isAllowedJob(playerJob.name) then
                    drawText3D(location.x, location.y, location.z + 1.0, "[E] Menüyü Aç")
                    if IsControlJustPressed(0, 38) then
                        openMenu()
                    end
                else
                    drawText3D(location.x, location.y, location.z + 1.0, "Bu alan yalnızca Mekan Sahipleri içindir.")
                end
            end
        end

        Wait(0)
    end
end)
