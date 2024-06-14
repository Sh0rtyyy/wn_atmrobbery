local webhook = "https://discord.com/api/webhooks/1250184705182007419/aoG7RN98Z52JYIVZ5jI2DyQO_2Upv1GqisucTEC2v52A-1Gp-8zlWzUJiXqRuXTag1T7"
local instances = {}
local instanceIndex = 0

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
    RegisterUsable = ESX.RegisterUsableItem
elseif Config.Framework == "qbcore" then
    QBCore = nil
    QBCore = exports['qb-core']:GetCoreObject()
    RegisterUsable = QBCore.Functions.CreateUseableItem
end

function CheckJob(source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src) 
        if xPlayer.job.name == Config.JobName then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayerData()
        if xPlayer.job.name == Config.JobName then 
            return true
        else
            return false
        end
    end
end

function GetCops()
    local cops = 0

    if Config.Framework == "ESX" then
        for _, src in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(src)
            for _, job in pairs(Config.PoliceJobs) do
                if xPlayer and xPlayer.getJob() and xPlayer.getJob().name == job then
                    cops = cops + 1
                end
            end
        end
        return cops
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayers()
        for i = 1, #Player do
            local Player = QBCore.Functions.GetPlayer(Player[i])
            for _, job in pairs(Config.PoliceJobs) do
                if Player.PlayerData.job.name == job then
                    cops = cops + 1
                end
            end
        end
        return cops
    end
end

function CheckDistance(source, TargetCoords)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src) 
	    local coords = xPlayer.getCoords(true)
        local distance = #(coords - TargetCoords)
        if distance < 10 then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local coords = GetEntityCoords(GetPlayerPed(src))
        local distance = #(coords - TargetCoords)
        if distance < 10 then
            return true
        else
            return false
        end
    end
end

function GetItem(name, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(name).count >= count then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer.Functions.GetItemByName(name) ~= nil then
            if xPlayer.Functions.GetItemByName(name).amount >= count then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end

function AddItem(name, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(name, count)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddItem(name, count, nil, nil)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[name], "add", count)
    end
end

function RemoveItem(name, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(name, count)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.RemoveItem(name, count, nil, nil)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[name], "remove", count)
    end
end

function AddMoney(type, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addAccountMoney(type, count)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddMoney("cash", count)
    end
end

function GetMoney(type, count, source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if type == "money" then
            if xPlayer.getMoney() >= count then
                return true
            else
                return false
            end
        elseif type == "bank" then
            if xPlayer.getAccount('bank').money >= count then
                return true
            else
                return false
            end
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if type == "money" then
            local type = "cash"
        end
        local playermoney = xPlayer.Functions.GetMoney(type)
        if playermoney >= count then
            return true
        else
            return false
        end
    end
end

function KickCheater(src, message)
	print("Cheater ".. src .. " " .. message)
    DropPlayer(src, message)
end

function DiscordLog(name,message,color)
    local embeds = {
        {
            ["title"] = name,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = 56108,
            ["footer"] = {
                ["text"] = "wn_atmrobbery " .. os.date('%H:%M - %d. %m. %Y', os.time()),
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end
