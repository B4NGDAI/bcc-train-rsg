local Core = exports['rsg-core']:GetCoreObject()

lib.callback.register('bcc-trains:server:HasJob', function(source)
  local src = source
  local Player = Core.Functions.GetPlayer(src)
  local HasJob = false

  if not Player then
    return HasJob
  end

  for _, station in pairs(Config.Stations) do
    -- Check if job is enabled for the current station
    if not station.jobEnabled then
      HasJob = true
    else
      local ped = GetPlayerPed(src)
      local coords = GetEntityCoords(ped)
      local dist = #(coords - vector3(station.coords.x, station.coords.y, station.coords.z))

      if dist < station.radius then
        for _, jobName in pairs(station.job) do
          if Player.PlayerData.job.name == jobName and Player.PlayerData.job.grade.level == station.grade then
            HasJob = true
            break
          end
        end
      end
    end
  end

  return HasJob
end)


TrainSpawned, TrainEntity = false, nil

lib.callback.register('bcc-train:AllowTrainSpawn', function(source)
  return not TrainSpawned
end)

RegisterServerEvent('bcc-train:UpdateTrainSpawnVar', function(updateBool, createdTrain)
  if updateBool then
    TrainSpawned = true
    TrainEntity = createdTrain
    TriggerEvent("rsg-log:server:CreateLog", "Train-Job", "Train Spawn", "green", _U("trainSpawnedwebMain"))
  else
    TrainSpawned = false
    TrainEntity = nil
    TriggerEvent("rsg-log:server:CreateLog", "Train-Job", "Train Delete", "green", _U("trainNotSpawnedWeb"))
  end
end)

lib.callback.register('bcc-train:GetOwnedTrains', function(source)
  local Player = Core.Functions.GetPlayer(source)
  local trains = {}
  local Result = MySQL.query.await('SELECT * FROM train WHERE charidentifier=@charidentifier', {['@charidentifier'] = Player.PlayerData.citizenid})
  for i = 1, #Result do
      trains[#trains+1] = Result[i]
  end
  return trains
end)

RegisterServerEvent('bcc-train:BoughtTrainHandler', function(trainTable)
  local src = source
  local Character = Core.Functions.GetPlayer(src)

  if not Character then
      print("Error: Character is nil")
      return
  end

  local cash = Character.PlayerData.money["cash"]

  if cash >= trainTable.cost then
      local insertParams = {
          ['charidentifier'] = Character.PlayerData.citizenid,
          ['trainModel'] = trainTable.model,
          ['fuel'] = trainTable.maxFuel,
          ['trainCondition'] = trainTable.maxCondition  -- Change the key to avoid the reserved keyword
      }

      MySQL.query.await("INSERT INTO train (charidentifier, trainModel, fuel, `condition`) VALUES (@charidentifier, @trainModel, @fuel, @trainCondition)", insertParams)

      Character.Functions.RemoveMoney('cash', trainTable.cost)
      TriggerClientEvent('ox_lib:notify', src, {title = _U("trainBought"), type = 'inform', duration = 5000 })
      TriggerEvent("rsg-log:server:CreateLog", "Train-Job", "Train Delete", "green", _U("charIdWeb") .. Character.PlayerData.citizenid, _U("boughtTrainWeb") .. trainTable.model)
  else
      TriggerClientEvent('ox_lib:notify', src, {title = _U("notEnoughMoney"), type = 'inform', duration = 5000 })
  end
end)

RegisterServerEvent('bcc-train:DecTrainFuel', function(trainid, trainFuel)
  local _source = source
  local param = { ['trainId'] = trainid, ['fuel'] = trainFuel - Config.FuelSettings.FuelDecreaseAmount }
  MySQL.query.await('UPDATE train SET fuel=@fuel WHERE trainid=@trainId', param)
  local result = MySQL.query.await("SELECT * FROM train WHERE trainid=@trainId", param)
  if #result > 0 then
    TriggerClientEvent('bcc-train:CleintFuelUpdate', _source, result[1].fuel)
  end
end)

RegisterServerEvent('bcc-train:DecTrainCond', function(trainid, trainCondition)
  local _source = source
  local param = { ['trainId'] = trainid, ['cond'] = trainCondition - Config.ConditionSettings.CondDecreaseAmount }
  MySQL.query.await('UPDATE train SET `condition`=@cond WHERE trainid=@trainId', param)
  local result = MySQL.query.await("SELECT * FROM train WHERE trainid=@trainId", param)
  if #result > 0 then
    TriggerClientEvent('bcc-train:CleintCondUpdate', _source, result[1].condition)
  end
end)

RegisterServerEvent('bcc-train:FuelTrain', function(trainId, configTable)
  local src = source
  local Player = Core.Functions.GetPlayer(src)
  local itemCount = Player.Functions.GetItemByName(Config.FuelSettings.TrainFuelItem)
  if itemCount >= Config.FuelSettings.TrainFuelItemAmount then
    Player.Functions.RemoveItem(Config.FuelSettings.TrainFuelItem, Config.FuelSettings.FuelDecreaseAmount)
    local param = { ['trainId'] = trainId, ['fuel'] = configTable.maxFuel }
    MySQL.query.await("UPDATE train SET `fuel`=@fuel WHERE trainid=@trainId", param)
    TriggerClientEvent('bcc-train:CleintFuelUpdate', src, configTable.maxFuel)
    TriggerClientEvent('ox_lib:notify', src, {title = _U("fuelAdded"), type = 'inform', duration = 5000 })
  else
    TriggerClientEvent('ox_lib:notify', src, {title = _U("noItem"), type = 'inform', duration = 5000 })
  end
end)

RegisterServerEvent('bcc-train:RepairTrain', function(trainId, configTable)
  local src = source
  local Player = Core.Functions.GetPlayer(src)
  local itemCount = Player.Functions.GetItemByName(Config.ConditionSettings.TrainCondItem)
  if itemCount >= Config.ConditionSettings.TrainCondItemAmount then
    Player.Functions.RemoveItem(Config.ConditionSettings.TrainCondItem, Config.ConditionSettings.TrainCondItemAmount)
    local param = { ['trainId'] = trainId, ['cond'] = configTable.maxCondition }
    MySQL.query.await("UPDATE train SET `condition`=@cond WHERE trainid=@trainId", param)
    TriggerClientEvent('bcc-train:CleintCondUpdate', src, configTable.maxCondition)
    TriggerClientEvent('ox_lib:notify', src, {title = _U("trainRepaired"), type = 'inform', duration = 5000 })
  else
    TriggerClientEvent('ox_lib:notify', src, {title = _U("noItem"), type = 'inform', duration = 5000 })
  end
end)

------ Baccus bridge fall area ---------
BridgeDestroyed = false
RegisterServerEvent('bcc-train:ServerBridgeFallHandler', function(freshJoin)
  local src = source
  local Player = Core.Functions.GetPlayer(src)
  if not freshJoin then
    local itemCount = Player.Functions.GetItemByName(Config.BacchusBridgeDestroying.dynamiteItem)
    if itemCount >= Config.BacchusBridgeDestroying.dynamiteItemAmount then
      if not BridgeDestroyed then
        Player.Functions.RemoveItem(Config.BacchusBridgeDestroying.dynamiteItem, Config.BacchusBridgeDestroying.dynamiteItemAmount)
        BridgeDestroyed = true
        TriggerClientEvent('ox_lib:notify', src, {title = _U("runFromExplosion"), type = 'inform', duration = 5000 })
        Wait(Config.BacchusBridgeDestroying.explosionTimer)
        TriggerEvent("rsg-log:server:CreateLog", "Train-Job", "BridgeDestroyed", "green", _U("bacchusDestroyedWebhook"))
        TriggerClientEvent('bcc-train:BridgeFall', -1) --triggers for all cleints
      end
    else
      TriggerClientEvent('ox_lib:notify', src, {title = _U("noItem"), type = 'inform', duration = 5000 })
    end
  else
    if BridgeDestroyed then
      TriggerClientEvent('bcc-train:BridgeFall', src) --triggers for loaded in client
    end
  end
end)

RegisterServerEvent('bcc-train:DeliveryPay', function(pay)
  local src = source
  local Character = Core.Functions.GetPlayer(src)
  if not Character then return end
  Character.Functions.AddMoney('cash', pay)
end)
