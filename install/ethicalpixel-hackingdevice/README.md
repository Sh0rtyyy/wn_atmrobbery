# [Standalone] Ethical Pixel Hackinh Device
A simple standalone fivem hacking resource

# Useage 

```

local hacking = {
    "numeric",
    "alphabet",
    "alphanumeric",
    "greek",
    "braille",
    "runes"
}

exports["ethicalpixel-hackingdevice"]:hackingdevice(function(success)
    if success then
       print("success")
    else
        print("failed")
    end
end, hacking[math.random(1, #hacking)], 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
```

__**Permanent Discord Invite**__
https://discord.gg/W5MtEHy5ga

```<EthicelPixel>```
