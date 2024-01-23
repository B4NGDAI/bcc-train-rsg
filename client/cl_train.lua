CreatedTrain, TrainFuel, TrainId, TrainConfigtable, TrainCondition, TrainBlip = nil, nil, nil, nil, nil, nil
local currentStation = nil --used to store config table to detect where to spawn the train
local StationPrompt = GetRandomIntInRange(0, 0xffffff)
local DestroyPrompt = GetRandomIntInRange(0, 0xffffff)
DrivingMenuOpened = false
Blipdelivery = nil

function OpenStationPrompt()
    local str = _U("openStationMenu")
    PromptStation = PromptRegisterBegin()
    PromptSetControlAction(PromptStation, 0x760A9C6F)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptStation, str)
    PromptSetEnabled(PromptStation, true)
    PromptSetVisible(PromptStation, true)
    PromptSetHoldMode(PromptStation, true)
    PromptSetGroup(PromptStation, StationPrompt)
    PromptRegisterEnd(PromptStation)
end

function BacchusStPrompt()
    local str = _U("blowUpBridge")
    BacchusPrompt = PromptRegisterBegin()
    PromptSetControlAction(BacchusPrompt, 0x760A9C6F)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(BacchusPrompt, str)
    PromptSetEnabled(BacchusPrompt, true)
    PromptSetVisible(BacchusPrompt, true)
    PromptSetHoldMode(BacchusPrompt, true)
    PromptSetGroup(BacchusPrompt, DestroyPrompt)
    PromptRegisterEnd(BacchusPrompt)
end

CreateThread(function()
    SetRandomTrains(false)
    OpenStationPrompt()
    TriggerServerEvent('bcc-train:ServerBridgeFallHandler', true)
    while true do
        Wait(5)
        local sleep = true
        local pcoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Stations) do
            local dist = #(pcoords - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist < v.radius then
                sleep = false
                local PromptGroup = CreateVarString(10, 'LITERAL_STRING', _U("trainStation"))
                PromptSetActiveGroupThisFrame(StationPrompt, PromptGroup)
                if PromptHasHoldModeCompleted(PromptStation) then
                    currentStation = v
                    local hasJob = lib.callback.await('bcc-trains:server:HasJob', false)
                    if hasJob then
                        OpenMenuStation()
                    else
                        print('You are not authorized')
                    end
                end
            end
        end
        if sleep then
            Wait(1500)
        end
    end
end)

function spawnTrain(trainTable, dbTable, dirChange) --credit to rsg_trains for some of the logic here
    local trainHash = joaat(trainTable.model)
    TrainFuel = dbTable.fuel
    TrainId = dbTable.trainid
    TrainCondition = dbTable.condition
    TrainConfigtable = trainTable

    loadTrainCars(trainHash)
    CreatedTrain = Citizen.InvokeNative(0xC239DBD9A57D2A71, trainHash, currentStation.trainSpawnCoords.x, currentStation.trainSpawnCoords.y, currentStation.trainSpawnCoords.z, dirChange, false, true, false)
    SetTrainSpeed(CreatedTrain, 0.0)
    SetTrainCruiseSpeed(CreatedTrain, 0.0) --these 2 natives freeze train on spawn

    local bliphash = -399496385
    TrainBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, bliphash, CreatedTrain) -- blip for train
    SetBlipScale(TrainBlip, 1.5)
    TriggerEvent('bcc-train:FuelDecreaseHandler')
    TriggerEvent('bcc-train:CondDecreaseHandler')
    TriggerEvent('bcc-train:TrainTargetted') --Triggers the targetting to fuel and repair etc (DAM CONFOOOSIN THIS SHIT IS)

    while DoesEntityExist(CreatedTrain) do --done to check if it has been deleted via the command
        Wait(5)
        local pcoord = GetEntityCoords(PlayerPedId())
        local traincoords = GetEntityCoords(CreatedTrain)
        local sleep = true
        local dist = #(pcoord - traincoords)
        if dist > 50 then
            sleep = false
            if dist > Config.TrainDespawnDist then
                lib.notify({ title = 'Train Job', description = _U("tooFarFromTrain"), type = 'inform', duration = 5000 })
                TriggerServerEvent('bcc-train:UpdateTrainSpawnVar', false, CreatedTrain)
                RemoveBlip(TrainBlip)
                DeleteEntity(CreatedTrain)
                break
            end
        elseif dist < 10 then
            sleep = false
            if not IsVehicleSeatFree(CreatedTrain, -1) then
                if GetPedInVehicleSeat(CreatedTrain, -1) == PlayerPedId() then
                    if not DrivingMenuOpened then
                        DrivingMenuOpened = true
                        ShowTextui()
                        drivingTrainMenu(trainTable, dbTable)
                    end
                else
                    DrivingMenuOpened = false
                    MenuData.CloseAll()
                    lib.hideTextUI()
                end
            else
                if DrivingMenuOpened then
                    DrivingMenuOpened = false
                    MenuData.CloseAll()
                    lib.hideTextUI()
                end
            end
        end
        if sleep then
            Wait(1500)
        end
    end
end

function ShowTextui()
    CreateThread(function ()
        while DrivingMenuOpened do
            Wait(10)
            lib.showTextUI('Health : ' .. TrainCondition ..'%  \n' .. 'Fuel : ' .. TrainFuel .. '%'  , {
                position = "right-center",
                style = {
                    borderRadius = 0,
                    backgroundColor = '#420b03',
                    color = 'white'
                }
            })
        end
    end)
end

AddEventHandler('bcc-train:FuelDecreaseHandler', function()
    while DoesEntityExist(CreatedTrain) do
        Wait(5)
        if EngineStarted then
            if TrainFuel > 0 then
                Wait(Config.FuelSettings.FuelDecreaseTime)
                TriggerServerEvent('bcc-train:DecTrainFuel', TrainId, TrainFuel)
                Wait(1000)
            else
                Citizen.InvokeNative(0x9F29999DFDF2AEB8, CreatedTrain, 0.0)
            end
        else
            Citizen.InvokeNative(0x9F29999DFDF2AEB8, CreatedTrain, 0.0)
        end
    end
end)

AddEventHandler('bcc-train:CondDecreaseHandler', function()
    while DoesEntityExist(CreatedTrain) do
        Wait(5)
        if EngineStarted then
            if TrainCondition > 0 then
                Wait(Config.ConditionSettings.CondDecreaseTime)
                TriggerServerEvent('bcc-train:DecTrainCond', TrainId, TrainCondition)
                Wait(1000)
            else
                Citizen.InvokeNative(0x9F29999DFDF2AEB8, CreatedTrain, 0.0)
            end
        end
    end
end)

RegisterNetEvent('bcc-train:CleintFuelUpdate', function(fuel)
    TrainFuel = fuel
end)

RegisterNetEvent('bcc-train:CleintCondUpdate', function(cond)
    TrainCondition = cond
end)

--------- Bacchus bridge collapse handling --------
RegisterNetEvent("bcc-train:BridgeFall", function()
    local ran = 0
    repeat
        local object = GetRayfireMapObject(GetEntityCoords(PlayerPedId()), 10000.0, 'des_trn3_bridge')
        SetStateOfRayfireMapObject(object, 4)
        Wait(100)
        AddExplosion(521.13, 1754.46, 187.65, 28, 1.0, true, false, true)
        AddExplosion(507.28, 1762.3, 187.77, 28, 1.0, true, false, true)
        AddExplosion(527.21, 1748.86, 187.8, 28, 1.0, true, false, true)
        Wait(100)
        SetStateOfRayfireMapObject(object, 6)
        ran = ran + 1
    until ran == 2 --has to run twice no idea why

    --Spawning ghost train model as the game engine wont allow trains to hit each other this will slow the trains down automatically if near the exploded part of the bridge
    Wait(1000)
    local trainHash = joaat('engine_config')
    loadTrainCars(trainHash)
    local ghostTrain = Citizen.InvokeNative(0xc239dbd9a57d2a71, trainHash, 499.69, 1768.78, 188.77, false, false, true, false)

    SetTrainSpeed(ghostTrain, 0.0)
    SetTrainCruiseSpeed(ghostTrain, 0.0) --these 2 natives freeze train on spawn
    SetEntityVisible(ghostTrain, false)
    SetEntityCollision(ghostTrain, false, false)
end)

CreateThread(function()
    if Config.BacchusBridgeDestroying.enabled then
        BacchusStPrompt()
        while true do
            local sleep = true
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - vector3(Config.BacchusBridgeDestroying.coords.x, Config.BacchusBridgeDestroying.coords.y, Config.BacchusBridgeDestroying.coords.z))
            if dist < 2 then
                sleep = false
                local PropmtGroup = CreateVarString(10, 'LITERAL_STRING', "Destroy Bridge")
                PromptSetActiveGroupThisFrame(DestroyPrompt, PropmtGroup)
                if PromptHasHoldModeCompleted(BacchusPrompt) then
                    TriggerServerEvent('bcc-train:ServerBridgeFallHandler', false)
                end
            end

            if sleep then
                Wait(1500)
            end
            Wait(5)
        end
    end
end)

function deliveryMission()
    local dCoords, storedCoords = nil, {}
    for k, v in pairs(Config.SupplyDeliveryLocations) do
        if v.outWest == currentStation.outWest then
            table.insert(storedCoords, v)
        end
    end
    dCoords = storedCoords[math.random(1, #storedCoords)]
    Blipdelivery = Citizen.InvokeNative(0x45F13B7E0A15C880, -1282792512, dCoords.coords.x, dCoords.coords.y, dCoords.coords.z, 10.0)
    Citizen.InvokeNative(0x9CB1A1623062F402, Blipdelivery, _U("deliverySpot"))

    lib.notify({ title = 'Train Job', description = _U("goToDeliverSpot"), type = 'inform', duration = 5000 })
    local beenIn = false
    while true do
        Wait(5)
        if IsEntityDead(PlayerPedId()) or not DoesEntityExist(CreatedTrain) then break end
        local sleep = true
        local tcoords = GetEntityCoords(CreatedTrain)
        local dist = #(vector3(dCoords.coords.x, dCoords.coords.y, dCoords.coords.z) - tcoords)
        if dist < dCoords.radius + 300 then
            sleep = false
            if dist < dCoords.radius then
                beenIn = true
                lib.notify({ title = 'Train Job', description = _U("goDeliver"), type = 'inform', duration = 5000 })
                local pcoords = GetEntityCoords(PlayerPedId())
                if #(pcoords - vector3(dCoords.coords.x, dCoords.coords.y, dCoords.coords.z)) < 2 then
                    InMission = false
                    if Blipdelivery ~= nil then
                        RemoveBlip(Blipdelivery)
                    end
                    lib.notify({ title = 'Train Job', description = _U("deliveryDone"), type = 'inform', duration = 5000 })
                    TriggerServerEvent('bcc-train:DeliveryPay', dCoords.pay)
                    break
                end
            end
            if beenIn and dist > dCoords.radius then
                beenIn = false
                lib.notify({ title = 'Train Job', description = _U("trainToFar"), type = 'inform', duration = 5000 })
            end
        end

        if sleep then
            Wait(1500)
        end
    end
    if CreatedTrain ~= nil then
        if IsEntityDead(PlayerPedId()) or not DoesEntityExist(CreatedTrain) then
            DeleteEntity(CreatedTrain)
            InMission = false
            lib.notify({ title = 'Train Job', description = _U("missionFailed"), type = 'inform', duration = 5000 })
        end
    end
end

local blips = {}
CreateThread(function()
    for k, v in pairs(Config.Stations) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords.x, v.coords.y, v.coords.z) -- This create a blip with a defualt blip hash we given
        SetBlipSprite(blip, Config.StationBlipHash, 1) -- This sets the blip hash to the given in config.
        SetBlipScale(blip, 0.8)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.StationBlipColor))
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.stationName) -- Sets the blip Name
        table.insert(blips, blip)
    end
end)

------- Cleanup -----
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        MenuData.CloseAll()
        InMission = false
        if DoesEntityExist(CreatedTrain) then
            DeleteEntity(CreatedTrain)
        end
        if #blips > 0 then
            for key, value in pairs(blips) do
                RemoveBlip(value)
            end
        end
    end
end)

AddEventHandler("playerDropped", function ()
    if DoesEntityExist(CreatedTrain) then
        DeleteEntity(CreatedTrain)
        TriggerServerEvent('bcc-train:UpdateTrainSpawnVar', false)
    end
end)

--[[
    Sacred Comment Penis
    8========================D
    Do not touch
]]