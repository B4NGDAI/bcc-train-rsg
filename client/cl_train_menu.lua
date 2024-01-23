----- Close Menu When Backspaced Out -----
InMission = false
EngineStarted = false

-- AddEventHandler('bcc-train:MenuClose', function()
--     while inMenu do
--         Wait(5)
--         if IsControlJustReleased(0, 0x156F7119) then
--             inMenu = false
--             MenuData.CloseAll()
--             break
--         end
--     end
-- end)

function OpenMenuStation()
    TriggerEvent('bcc-train:MenuClose')
    MenuData.CloseAll()

    local elements = {
        { label = _U("ownedTrains"),     value = 'ownedtrains',     desc = _U("ownedTrains_desc") },
        { label = _U("buyTrains"),       value = 'buytrains',       desc = _U("buyTrains_desc") }
    }

    if CreatedTrain ~= nil then
        table.insert(elements, { label = _U("deliveryMission"), value = 'deliveryMission', desc = _U("deliveryMission_desc") })
        table.insert(elements, { label = _U("deleteTrain"), value = 'deleteTrain', desc = _U("deleteTrain_desc") })
    end

    MenuData.Open('default', GetCurrentResourceName(), 'ip-menubase',
        {
            title =_U("trainStation"),
            align = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
            local selectedOption = {
                ['ownedtrains'] = function()
                    menu.close()
                    ViewOwnedTrains()
                end,
                ['buytrains'] = function()
                    menu.close()
                    BuyTrains()
                end,
                ['deliveryMission'] = function()
                    if CreatedTrain ~= nil then
                        if not InMission then
                            InMission = true
                            deliveryMission()
                        else
                            lib.notify({ title = 'Train Job', description = _U("inMission"), type = 'inform', duration = 5000 })
                        end
                    else
                        lib.notify({ title = 'Train Job', description = _U("noTrain"), type = 'inform', duration = 5000 })
                    end
                end,
                ['deleteTrain'] = function()
                    TriggerServerEvent('bcc-train:UpdateTrainSpawnVar', false, CreatedTrain)
                    if TrainBlip ~= nil then
                        RemoveBlip(TrainBlip)
                        TrainBlip = nil
                    end
                    MenuData.CloseAll()
                    if CreatedTrain ~= nil then
                        DeleteEntity(CreatedTrain)
                        CreatedTrain = nil
                    end
                    lib.hideTextUI()
                    DrivingMenuOpened = false
                end
            }

            if selectedOption[data.current.value] then
                selectedOption[data.current.value]()
            end
        end, function(data, menu)
            menu.close()
        end)
end

function BuyTrains()
    MenuData.CloseAll()
    local elements = {}
    local ownedTrains = lib.callback.await('bcc-train:GetOwnedTrains', false)
    if #ownedTrains <= 0 then
        for k, v in pairs(Config.Trains) do
            elements[#elements + 1] = {
                label = _U("trainModel") .. ' ' .. v.label .. ' ' .. _U("price") .. v.cost,
                value = "train" .. k,
                desc = "",
                info = v
            }
        end
    else
        for key, value in pairs(Config.Trains) do
            local insert = true
            for k, v in pairs(ownedTrains) do
                if value.model == v.trainModel then
                    insert = false
                end
            end
            if insert then
                elements[#elements + 1] = {
                    label = _U("trainModel") .. ' ' .. value.label .. ' ' .. _U("price") .. value.cost,
                    value = "train" .. key,
                    desc = "",
                    info = value
                }
            end
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'buy-trains',
        {
            title      =_U("trainMenu"),
            subtext    = _U("trainMenu_desc"),
            align      = 'top-left',
            elements   = elements,
        },
        function(data)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
            if data.current.value then
                MenuData.CloseAll()
                TriggerServerEvent('bcc-train:BoughtTrainHandler', data.current.info)
            end
        end, function(data, menu)
            OpenMenuStation()
        end)
end

function ViewOwnedTrains()
    MenuData.CloseAll()
    local OwnedElement = {}
    local ownedTrains = lib.callback.await('bcc-train:GetOwnedTrains', false)
    if #ownedTrains <= 0 then
        MenuData.CloseAll()
        lib.notify({ title = 'Train Job', description = _U("noOwnedTrains"), type = 'inform', duration = 5000 })
    else
        for key, value in pairs(ownedTrains) do
            OwnedElement[#OwnedElement + 1] = {
                label = _U("trainModel") .. ' ' .. value.trainModel,
                value = "train" .. key,
                desc = "",
                info = value
            }
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'ownedmenu',
        {
            title      =_U("trainMenu"),
            subtext    = _U("trainMenu_desc"),
            align      = 'top-left',
            elements   = OwnedElement,
        },
        function(data)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
            if data.current.value then
                local result = lib.callback.await("bcc-train:AllowTrainSpawn", false)
                if result then
                    TriggerServerEvent('bcc-train:UpdateTrainSpawnVar', true)
                    MenuData.CloseAll() --have to be called above funct
                    local configTable = nil
                    for k, v in pairs(Config.Trains) do
                        if data.current.info.trainModel == v.model then
                            configTable = v
                            break
                        end
                    end
                    switchDirectionMenu(configTable, data.current.info)
                else
                    lib.notify({ title = 'Train Job', description = _U("trainSpawnedAlrady"), type = 'inform', duration = 5000 })
                end
            end
        end, function(data, menu)
            menu.close()
            OpenMenuStation()
        end)
end

function switchDirectionMenu(configTable, menuTable)
    MenuData.CloseAll()

    local elements = {
        { label = _U("changeSpawnDir"),   value = 'changeSpawnDir',   desc = _U("changeSpawnDir_desc") },
        { label = _U("noChangeSpawnDir"), value = 'noChangeSpawnDir', desc = _U("noChangeSpawnDir_desc") }
    }

    MenuData.Open('default', GetCurrentResourceName(), 'swith-menu',
        {
            title      =_U("trainMenu"),
            subtext    = _U("trainMenu_desc"),
            align      = 'top-left',
            elements   = elements,
        },
        function(data)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
            if data.current.value == 'changeSpawnDir' then
                MenuData.CloseAll()
                lib.notify({ title = 'Train Job', description = _U("trainSpawned"), type = 'inform', duration = 5000 })
                spawnTrain(configTable, menuTable, true)
            else
                MenuData.CloseAll()
                lib.notify({ title = 'Train Job', description = _U("trainSpawned"), type = 'inform', duration = 5000 })
                spawnTrain(configTable, menuTable, false)
            end
        end, function(data, menu)
            OpenMenuStation()
        end)
end

local on, speed = false, 0 --used for track switching
function drivingTrainMenu(trainConfigTable, trainDbTable)
    MenuData.CloseAll()

    local elements = {
        {
            label = _U("speed"),
            value = speed,
            desc = _U("speed_desc"),
            type = 'slider',
            min = 0,
            max =
                trainConfigTable.maxSpeed,
            hop = 1.0
        },
        { label = _U("switchTrack"),  value = 'switchtrack', desc = _U("switchTrack_desc") },
    }
    if Config.CruiseControl then
        table.insert(elements, { label = _U("forward"), value = 'forward', desc = _U("forward_desc") })
        table.insert(elements, { label = _U("backward"), value = 'backward', desc = _U("backward_desc") })
    end
    if EngineStarted then
        table.insert(elements, { label = _U("stopEngine"),   value = 'stopEngine',  desc = _U("stopEngine_desc") })
    else
        table.insert(elements, { label = _U("startEnging"),  value = 'startEngine', desc = _U("startEnging_desc") })
    end

    table.insert(elements, { label = _U("deleteTrain"), value = 'deleteTrain', desc = _U("deleteTrain_desc") }) --done here to ensure this is at the bottom of menu

    local forwardActive, backwardActive = false, false
    MenuData.Open('default', GetCurrentResourceName(), 'driving-menu',
        {
            title =_U("drivingMenu"),
            align = 'top-left',
            elements = elements,
            lastmenu = '',
        },
        function(data, menu)
            if data.current == 'backup' then
                return _G[data.trigger]()
            end
            local selectedOption = {
                ['forward'] = function()
                    if EngineStarted then
                        if not backwardActive then
                            if not forwardActive then
                                if TrainFuel ~= 0 then
                                    forwardActive = true
                                    lib.notify({ title = 'Train Job', description = _U("forwardEnabled"), type = 'inform', duration = 5000 })
                                    while forwardActive do
                                        Wait(100)
                                        local tcoords = GetEntityCoords(CreatedTrain)
                                        if #(vector3(517.56, 1757.27, 188.34) - tcoords) < 1000 then
                                            lib.notify({ title = 'Train Job', description = _U("cruiseDisabledInRegion"), type = 'inform', duration = 5000 })
                                            forwardActive = false break
                                        end
                                        if speed ~= 0 and speed ~= nil then --stops error
                                            SetTrainSpeed(CreatedTrain, speed + .1)
                                        end
                                    end
                                else
                                    lib.notify({ title = 'Train Job', description = _U("noCruiseNoFuel"), type = 'inform', duration = 5000 })
                                end
                            else
                                lib.notify({ title = 'Train Job', description = _U("forwardDisbaled"), type = 'inform', duration = 5000 })
                                forwardActive = false
                            end
                        else
                            lib.notify({ title = 'Train Job', description = _U("backwardsIsOn"), type = 'inform', duration = 5000 })
                        end
                    end
                end,
                ['backward'] = function()
                    if EngineStarted then
                        if not forwardActive then
                            if not backwardActive then
                                if TrainFuel ~= 0 then
                                    backwardActive = true
                                    lib.notify({ title = 'Train Job', description = _U("backwardEnabled"), type = 'inform', duration = 5000 })
                                    while backwardActive do
                                        Wait(100)
                                        local tcoords = GetEntityCoords(CreatedTrain)
                                        if #(vector3(517.56, 1757.27, 188.34) - tcoords) < 1000 then
                                            lib.notify({ title = 'Train Job', description = _U("cruiseDisabledInRegion"), type = 'inform', duration = 5000 })
                                            backwardActive = false break
                                        end
                                        if speed ~= 0 and speed ~= nil then --stops error
                                            SetTrainSpeed(CreatedTrain, speed + .1 - speed * 2)
                                        end
                                    end
                                else
                                    lib.notify({ title = 'Train Job', description = _U("noCruiseNoFuel"), type = 'inform', duration = 5000 })
                                end
                            else
                                lib.notify({ title = 'Train Job', description = _U("backwardDisabled"), type = 'inform', duration = 5000 })
                                backwardActive = false
                            end
                        else
                            lib.notify({ title = 'Train Job', description = _U("forwardsIsOn"), type = 'inform', duration = 5000 })
                        end
                    end
                end,
                ['switchtrack'] = function()
                    if not on then
                        trackSwitch(true)
                        on = true
                        lib.notify({ title = 'Train Job', description = _U("switchingOn"), type = 'inform', duration = 5000 })
                    else
                        trackSwitch(false)
                        on = false
                        lib.notify({ title = 'Train Job', description = _U("switchingOn"), type = 'inform', duration = 5000 })
                    end
                end,
                ['stopEngine'] = function()
                    lib.notify({ title = 'Train Job', description = _U("engineStopped"), type = 'inform', duration = 5000 })
                    EngineStarted = false
                    MenuData.CloseAll()
                    drivingTrainMenu(trainConfigTable, trainDbTable)
                    Citizen.InvokeNative(0x9F29999DFDF2AEB8, CreatedTrain, 0.0)
                end,
                ['startEngine'] = function()
                    lib.notify({ title = 'Train Job', description = _U("engineStarted"), type = 'inform', duration = 5000 })
                    EngineStarted = true
                    MenuData.CloseAll()
                    drivingTrainMenu(trainConfigTable, trainDbTable)
                    maxSpeedCalc(speed)
                end,
                ['deleteTrain'] = function()
                    TriggerServerEvent('bcc-train:UpdateTrainSpawnVar', false, CreatedTrain)
                    if TrainBlip ~= nil then
                        RemoveBlip(TrainBlip)
                    end
                    MenuData.CloseAll()
                    if CreatedTrain ~= nil then
                        DeleteEntity(CreatedTrain)
                        CreatedTrain = nil
                    end
                    lib.hideTextUI()
                    DrivingMenuOpened = false
                end
            }

            if selectedOption[data.current.value] then
                selectedOption[data.current.value]()
            else --has to be done this way to get a vector menu option
                speed = data.current.value
                maxSpeedCalc(speed)
            end
        end)
end


function maxSpeedCalc(speed)
    local setMaxSpeed = speed + .1
    if setMaxSpeed > 30.0 then
        setMaxSpeed = 29.9
    end
    Citizen.InvokeNative(0x9F29999DFDF2AEB8, CreatedTrain, setMaxSpeed)
end