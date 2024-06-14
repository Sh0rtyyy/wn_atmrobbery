Config = {}
Config.Locale = 'en'

Config.Framework = "ESX" -- ESX or qbcore

Config.EnableDebug = false -- Enable/Disable prints and showing box of ox_target

Config.PoliceJobs =  {"police", "sheriff"} -- Name of the job for script
Config.Target = "ox_target" -- ox_target, qb-target
Config.Notify = "ox_lib" -- ox_lib, qbcore or ESX
Config.Dispatch = "cd_dispatch" -- cd_dispatch, linden_outlawalert, ps-disptach, core-dispatch, qs-dispatch
Config.SearchDuration = 6000 -- How long will the player search the pleace IN MS
Config.HackingDevice = "hacking_device" -- Name for your hacking item
Config.HackingMinigames = { -- Types of hacking games in the hacking menu
    "numeric",
    "alphabet",
    "alphanumeric",
    "greek",
    "braille",
    "runes"
}

Config.Props = { 'prop_atm_01', 'prop_atm_02', 'prop_fleeca_atm', 'prop_atm_03' } -- Prop names for ATMs !
Config.Reward = math.random(100, 500) -- Cash Reward per bill.
Config.Cooldown = 10 -- Cooldwon in minutes.
Config.CopsNeeded = 1 -- Cops needed to start the robbery.