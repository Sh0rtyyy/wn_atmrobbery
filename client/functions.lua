local PlayerData = {}
local PlayerJob
local CurrentShopBlips = {}
lib.locale()

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent('wn_atmrobbery:int')
    end
end)

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        PlayerJob = PlayerData.job
        Wait(2000)
        TriggerEvent('wn_atmrobbery:int')
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
        PlayerJob = job
        Wait(500)
    end)

elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()

    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
        TriggerEvent('wn_atmrobbery:int')
    end)
    
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerData.job = JobInfo
    end)
    
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        PlayerData = {}
    end)
    
end

function Notify(type, title, text, icon, time)
    if Config.Notify == "ESX" then
        ESX.ShowNotification(text)
    elseif Config.Notify == "ox_lib" then
        if type == "success" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "success"
            })
        elseif type == "inform" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "inform"
            })
        elseif type == "error" then
            lib.notify({
                title = title,
                duration = time,
                description = text,
                type = "error"
            })
        end
    elseif Config.Notify == "qbcore" then
        if type == "success" then
            QBCore.Functions.Notify(text, "success")
        elseif type == "info" then
            QBCore.Functions.Notify(text, "primary")
        elseif type == "error" then
            QBCore.Functions.Notify(text, "error")
        end
    end
end

function GetJob()
    if Config.Framework == "ESX" then
        if ESX.GetPlayerData().job then
            return ESX.GetPlayerData().job.name
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        if QBCore.Functions.GetPlayerData().job then
            return QBCore.Functions.GetPlayerData().job.name
        else
            return false
        end
    end
end

function Dispatch(coords)
    if Config.Dispatch == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.PoliceJobs,
            coords = coords,
            title = "10-90 - ATM Robbery",
            message = "Somebody here is hacking an ATM !",
            flash = 0,
            unique_id = tostring(math.random(0000000, 9999999)),
            blip = {
                sprite = 40,
                scale = 1.2,
                colour = 1,
                flashes = false,
                text = text,
                time = (5 * 60 * 1000),
                sound = 1,
            }
        })
    elseif Config.Dispatch == "linden_outlawalert" then
        local data = { displayCode = "10-90", description = "House Robbery", isImportant = 1, recipientList = Config.PoliceJobs, length = '10000', infoM = 'fa-info-circle', info = "Alarm has turned on at the residence" }
        local dispatchData = { dispatchData = data, caller = 'alarm', coords = coords }
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    elseif Config.Dispatch == "ps-disptach" then
        exports["ps-dispatch"]:CustomAlert({
            coords = coords,
            message = "House Robbery",
            dispatchCode = "10-90",
            description = "Alarm has turned on at the residence",
            radius = 0,
            sprite = 40,
            color = 1,
            scale = 1.2,
            length = 3,
        })
    elseif Config.Dispatch == "core-dispatch" then
        for k, v in pairs(Config.PoliceJobs) do
            exports['core_dispatch']:addCall("10-90", "Alarm has turned on at the residence", {
                }, {coords.xyz}, v, 10000, 11, 5 
            )
        end
    elseif Config.Dispatch == "qs-dispatch" then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.PoliceJobs,
            callLocation = coords,
            callCode = { code = '<CALL CODE>', snippet = '<CALL SNIPPED: 10-90>' },
            message = "10-90 - House Robbery",
            flashes = false, -- you can set to true if you need call flashing sirens...
            image = "URL", -- Url for image to attach to the call
            --you can use the getSSURL export to get this url
            blip = {
                sprite = 40,
                scale = 1.2,
                colour = 1,
                flashes = false, -- blip flashes
                text = '10-90 - House Robbery', -- blip text
                time = (1 * 60000), --blip fadeout time (1 * 60000) = 1 minute
            },
            otherData = {
               {
                   text = 'Alarm has turned on at the residence', -- text of the other data item (can add more than one)
                   icon = 'fas fa-user-secret', -- icon font awesome https://fontawesome.com/icons/
               }
             }
        })
    end
end