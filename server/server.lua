main = {}

lib.callback.register('wn_atmrobbery:getCops', function()
    local src = source
    local cops = 0

    cops = GetCops()
    return cops
end)

lib.callback.register('wn_atmrobbery:getCooldons', function(source, objctId)
    local src = source
    local objectId = objctId
    if main[objectId] == nil then
        main[objectId] = { taken = false }
    end

    return main[objectId].taken
end)

lib.callback.register('wn_atmrobbery:getItem', function(source)
    local src = source
    local carRob = false
    local hasItem = GetItem(Config.HackingDevice, 1, src)
    if hasItem then
        RemoveItem(Config.HackingDevice, 1, src)
        carRob = true
    else
        carRob = false
    end
    return carRob
end)

RegisterNetEvent("wn_atmrobbery:syncPlant")
AddEventHandler("wn_atmrobbery:syncPlant", function(objectId)
    local src = source
    if CheckDistance(source, objectId) then
        if main[objectId] and main[objectId].taken then
            TriggerClientEvent('wn_houserobbery:notifysv', src, "error", "ATM", "This ATM is allready robbed", "fa-solid fa-user-shield", 5000)
        else
            TriggerEvent('wn_atmrobbery:takeCash', objectId, src)
        end
    else
        KickCheater(src, "Trying to rob with a big distance")
    end
end)

RegisterNetEvent("wn_atmrobbery:takeCash")
AddEventHandler("wn_atmrobbery:takeCash", function(objectId, source)
    local src = source
    if main[objectId] == nil then
        main[objectId] = { taken = false }
    end

    if main[objectId].taken then
        TriggerClientEvent('wn_houserobbery:notifysv', src, "error", "ATM", "This ATM is allready robbed", "fa-solid fa-user-shield", 5000)
    else
        local money = math.floor(Config.Reward)
        DiscordLog("ATM ROBBERY", GetPlayerName(src) .. " have robbed the ATM at " .. objectId .. " and get " .. money)
        main[objectId].taken = true
        AddMoney("money", money, src)

        CreateThread(function()
            Wait(tonumber(Config.Cooldown*60000))
            main[objectId].taken = false
        end)
    end
end)
