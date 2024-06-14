RegisterNetEvent('wn_atmrobbery:int',function()
    for k, model in pairs(Config.Props) do
        if Config.Target == "ox_target" then
            exports.ox_target:addModel(model, {
                {
                    event = 'wn_atmrobbery:rob',
                    name = 'rob_atm',
                    icon = "fas fa-money-bill",
                    label = 'Rob ATM',
                    onSelect = function()
                        TriggerEvent('wn_atmrobbery:rob')
                    end,
                    distance = 2.5
                }
            })
        elseif Config.Target == "qb-target" then
            exports['qb-target']:AddTargetModel(model, {
                options = {
                    {
                        event = 'wn_atmrobbery:rob',
                        type = 'client',
                        icon = "fa-solid fa-money-bill",
                        label = 'Rob',
                    },
                },
                distance = 2.5
            })
        end
    end
end)

RegisterNetEvent('wn_atmrobbery:rob',function()
    local objectId
    local ped = cache.ped
    local pedCoords = GetEntityCoords(ped)
    local cops = lib.callback('wn_atmrobbery:getCops')

    if cops >= Config.CopsNeeded then
        for k,v in pairs(Config.Props) do
            objectId = GetClosestObjectOfType(pedCoords, 2.0, joaat(Config.Props[k]), false)
            if DoesEntityExist(objectId) then
                NetworkRegisterEntityAsNetworked(objectId)
                local entpos = GetEntityCoords(objectId)
                local result = lib.callback.await('wn_atmrobbery:getCooldons', false, entpos)
                local hasItem = lib.callback('wn_atmrobbery:getItem')
                if not hasItem then
                    Notify("error", "ATM", "You dont have a hackingdevice", "fa-solid fa-user-shield", 5000)
                    return
                end
                    if result then
                    Notify("error", "ATM", "This ATM is allready robbed", "fa-solid fa-user-shield", 5000)
                    return
                else
                    Dispatch(entpos)
                    dict = 'anim@gangops@facility@servers@'
                    clip = 'hotwire'
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    exports["ethicalpixel-hackingdevice"]:hackingdevice(function(success)
                        if success then
                            if lib.progressCircle({
                                duration = Config.SearchDuration,
                                label = "Planting the Explosive",
                                position = 'bottom',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    comat = true,
                                    mouse = false
                                },
                                anim = {
                                    dict = 'anim@scripted@heist@ig1_table_grab@gold@male@',
                                    clip = 'grab'
                                },
                            })
                            then
                                TriggerServerEvent("wn_atmrobbery:syncPlant", entpos)
                            else
                                StopAnimTask(ped, "anim@scripted@heist@ig1_table_grab@gold@male@", "grab", 1.0)
                            end
                        else
                            StopAnimTask(cache.ped, "anim@gangops@facility@servers@", "hotwire", 1.0)
                            Notify("error", "ATM", "You failed the hack", "fa-solid fa-user-shield", 5000)
                        end
                    end, Config.HackingMinigames[math.random(1, #Config.HackingMinigames)], 30, 0)
                end
            end
            if objectId ~= 0 or objctId ~= nil then
                break
            end
        end
    else
        Notify("error", "ATM", "Not enought cops", "fa-solid fa-user-shield", 5000)
    end
end)