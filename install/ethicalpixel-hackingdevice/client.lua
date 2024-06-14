local open = false

RegisterNUICallback('hackingdevice-callback', function(data, cb)
	SetNuiFocus(false, false)
    Callbackk(data.success)
    open = false
    cb('ok')
end)

local function hackingdevice(callback, type, time, mirrored)
    if type == nil then type = "alphabet" end
    if time == nil then time = 10 end
    if mirrored == nil then mirrored = 0 end

    if not open then
        Callbackk = callback
        open = true
        SendNUIMessage({
            action = "hackingdevice-start",
            type = type,
            time = time,
            mirrored = mirrored,

        })
        SetNuiFocus(true, true)
    end
end

local hacking = {
    "numeric",
    "alphabet",
    "alphanumeric",
    "greek",
    "braille",
    "runes"
}

RegisterCommand('ethicalhacktest', function()
    hackingdevice(function(success)
        if success then
            print("success")
        else
            print("fail")
        end
    end, hacking[math.random(1, #hacking)], 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
end)

exports("hackingdevice", hackingdevice)
