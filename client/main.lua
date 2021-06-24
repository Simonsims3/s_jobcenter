-- Original Author: SimoN#6253 (Discord) | S_imoN (Forum CFX) --
-- Please Respect My Work --
-- Do Not Touch Here If You Don't Know What You Are Doing --

local config = json.decode(LoadResourceFile(GetCurrentResourceName(), "config.json"))
local configLang = json.decode(LoadResourceFile(GetCurrentResourceName(), "html/lang/"..config.lang..".json"))

local pedConfig = config.pedInfo

local jobCenterCoords = vector3(pedConfig.PedCoords.x, pedConfig.PedCoords.y, pedConfig.PedCoords.z)
local jobCenterHeading = pedConfig.PedHeading
local jobCenterPedHash = GetHashKey(pedConfig.PedName)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

Citizen.CreateThread(function()
    RequestModel(jobCenterPedHash)
    while not HasModelLoaded(jobCenterPedHash) do Citizen.Wait(1) end
    jobPed = CreatePed(4, jobCenterPedHash, jobCenterCoords, jobCenterHeading, true, true)
    
    AddTextEntry('CallText', configLang.PedInfoBox)

    SetEntityAsMissionEntity(jobPed)
    SetPedDiesWhenInjured(jobPed, false)
    SetEntityInvincible(jobPed, true)
    SetPedFleeAttributes(jobPed, 0, 0)
    SetBlockingOfNonTemporaryEvents(jobPed, true)
    FreezeEntityPosition(jobPed, true)

    while true do
        Citizen.Wait(60)
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        if Vdist2(pedCoords, jobCenterCoords) < 5 then
            BeginTextCommandDisplayHelp('CallText')
            EndTextCommandDisplayHelp(0, false, false, -1)
            if IsControlPressed(0, 51) then
                SendNUIMessage({
                    type = 'openMenu'
                })
                SetNuiFocus(true, true)
                TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
            end
        end
    end
end)



RegisterNUICallback("closemenu", function()
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    ClearAreaOfObjects(GetEntityCoords(GetPlayerPed(-1)), 1.0, 0)
end)


RegisterNUICallback("button", function(data)
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    ClearAreaOfObjects(GetEntityCoords(GetPlayerPed(-1)), 1.0, 0)
    TriggerServerEvent('s_jobcenter:setJob', data.jobName)

    if data.jobName == "unemployed" then
        ESX.ShowAdvancedNotification(config.jobCenter, configLang.notifSubtitle, configLang.notificationDescUnemployed, "CHAR_SOCIAL_CLUB", 8, false, false, 140)
    else
        ESX.ShowAdvancedNotification(config.jobCenter, configLang.notifSubtitle, configLang.notificationDesc ..data.jobLabel, "CHAR_SOCIAL_CLUB", 8, false, false, 140)
    end
end)


Citizen.CreateThread(function()
    local info_blip = AddBlipForCoord(-269.13, -955.8, 30.22)
    SetBlipSprite(info_blip, 351)
    SetBlipDisplay(info_blip, 4)
    SetBlipScale(info_blip, 1.0)
    SetBlipColour(info_blip, 0)
    SetBlipAsShortRange(info_blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(config.jobCenter)
    EndTextCommandSetBlipName(info_blip)
end)