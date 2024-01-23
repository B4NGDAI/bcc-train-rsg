
MenuData = {}

TriggerEvent("rsg-menubase:getData", function(call)
  MenuData = call
end)

function loadModel(model) --function to load a model
  RequestModel(model)
  while not HasModelLoaded(model) do
    Wait(100)
  end
end

AddEventHandler('bcc-train:TrainTargetted', function()
  local player = PlayerPedId()
  local id = PlayerId()
  local returnDist = 5.5
  while DoesEntityExist(CreatedTrain) do
    local sleep = 1000
    local dist = #(GetEntityCoords(player) - GetEntityCoords(CreatedTrain))
    if dist <= returnDist then
      Citizen.InvokeNative(0x05254BA0B44ADC16, CreatedTrain, true) -- SetVehicleCanBeTargetted
      if Citizen.InvokeNative(0x6F972C1AB75A1ED0, player) then -- IsPedOnAnyTrain
        local _, targetEntity = GetPlayerTargetEntity(id)
        if Citizen.InvokeNative(0x27F89FDC16688A7A, id, CreatedTrain, 0) then -- IsPlayerTargettingEntity
          sleep = 0
          local trainGroup = Citizen.InvokeNative(0xB796970BD125FCE8, targetEntity) -- PromptGetGroupIdForTargetEntity
          TriggerEvent('bcc-train:TargetPrompts', trainGroup)
          if Citizen.InvokeNative(0x580417101DDB492F, 2, 0x5415BE48) then -- IsControlJustPressed
            TriggerServerEvent('bcc-train:FuelTrain', TrainId, TrainConfigtable)
          elseif Citizen.InvokeNative(0x580417101DDB492F, 2, 0x73A8FD83) then
            TriggerServerEvent('bcc-train:RepairTrain', TrainId, TrainConfigtable)
          end
        end
      else
        Citizen.InvokeNative(0x05254BA0B44ADC16, CreatedTrain, false) -- SetVehicleCanBeTargetted
      end
    else
      Citizen.InvokeNative(0x05254BA0B44ADC16, CreatedTrain, false) -- SetVehicleCanBeTargetted
    end
      Wait(sleep)
  end
end)

AddEventHandler('bcc-train:TargetPrompts', function(trainGroup)
  local str = CreateVarString(10, 'LITERAL_STRING', _U("addFuel"))
  local fuelTarget = PromptRegisterBegin()
  PromptSetControlAction(fuelTarget, 0x5415BE48)
  PromptSetText(fuelTarget, str)
  PromptSetEnabled(fuelTarget, 1)
  PromptSetVisible(fuelTarget, 1)
  PromptSetHoldMode(fuelTarget, 1)
  PromptSetGroup(fuelTarget, trainGroup)
  PromptRegisterEnd(fuelTarget)

  local str2 = CreateVarString(10, 'LITERAL_STRING', _U("repairdTrain"))
  local repairTarget = PromptRegisterBegin()
  PromptSetControlAction(repairTarget, 0x73A8FD83)
  PromptSetText(repairTarget, str2)
  PromptSetEnabled(repairTarget, 1)
  PromptSetVisible(repairTarget, 1)
  PromptSetHoldMode(repairTarget, 1)
  PromptSetGroup(repairTarget, trainGroup)
  PromptRegisterEnd(repairTarget)
end)

function loadTrainCars(trainHash)
  local trainWagons = Citizen.InvokeNative(0x635423d55ca84fc8, trainHash)
  for wagonIndex = 0, trainWagons - 1 do
    local trainWagonModel = Citizen.InvokeNative(0x8df5f6a19f99f0d5, trainHash, wagonIndex)
    while not HasModelLoaded(trainWagonModel) do
      Citizen.InvokeNative(0xFA28FE3A6246FC30, trainWagonModel, 1)
      Wait(100)
    end
  end
end

function trackSwitch(toggle)
  local trackModels = {
    { model = 'FREIGHT_GROUP' },
    { model = 'TRAINS3' },
    { model = 'BRAITHWAITES2_TRACK_CONFIG' },
    { model = 'TRAINS_OLD_WEST01' },
    { model = 'TRAINS_OLD_WEST03' },
    { model = 'TRAINS_NB1' },
    { model = 'TRAINS_INTERSECTION1_ANN' },
  }
  local counter = 0
  repeat
    for k, v in pairs(trackModels) do
      local trackHash = joaat(v.model)
      Citizen.InvokeNative(0xE6C5E2125EB210C1, trackHash, counter, toggle)
    end
    counter = counter + 1
  until counter >= 25
end

-- function InitPrompts(trainConfigTable)
--   if Config.CruiseControl then
--     CreatePromptButton('train_prompt', _U("forward"), 'INPUT_MOVE_UP_ONLY', false)
--     CreatePromptButton('train_prompt', _U("backward"), 'INPUT_FRONTEND_NAV_DOWN', false)
--   end
--   if trainConfigTable.allowInventory then
--     CreatePromptButton('train_prompt', _U("openInv"), 'INPUT_OPEN_JOURNAL', false)
--   end
--   CreatePromptButton('train_prompt', _U("startEnging"), 'INPUT_INTERACT_LOCKON_ANIMAL', false)
--   CreatePromptButton('train_prompt', _U("switchTrack"), 'INPUT_GAME_MENU_RIGHT', false)
--   CreatePromptButton('train_prompt', _U("deleteTrain"), 'INPUT_CREATOR_DELETE', false)
-- end

-- prompts = {}
-- promptGroups = {}
-- promptName = ''
-- timerkey = {}

-- function ClearPromptGroup(group)
--   for _,prompt in pairs (promptGroups[group].prompts) do
--     PromptDelete(prompt)
--   end
--   promptGroups[group] = nil
-- end

-- function GetPromptPage(group)
--   return PromptGetGroupActivePage(promptGroups[group].group)
-- end

-- function DisplayPrompt(group,str)
--   local promptName  = CreateVarString(10, 'LITERAL_STRING', str)
--   PromptSetActiveGroupThisFrame(promptGroups[group].group, promptName,promptGroups[group].tabAmount,0)
-- end

-- function EditPromptText(group,key,str)
--   str = CreateVarString(10, 'LITERAL_STRING', str)
--   PromptSetText(promptGroups[group].prompts[key], str)
-- end

-- function IsPromptCompleted(group,key)
--   if UiPromptHasHoldMode(promptGroups[group].prompts[key]) then
--     if PromptHasHoldModeCompleted(promptGroups[group].prompts[key]) then
--       return true
--     end
--   else
--     if IsControlJustPressed(0,GetHashKey(key)) then
--       return true
--     end
--   end
--   return false
-- end

-- function UiPromptHasHoldMode(...)
--   return Citizen.InvokeNative(0xB60C9F9ED47ABB76, ...)
-- end

-- function CreatePromptButton(group, str, key, holdTime, tabIndex)
--   --Check if group exist
-- 	if not tabIndex then tabIndex = 0 end
-- 	if not holdTime then holdTime = false end
--   if (promptGroups[group] == nil) then
--     if type(group) == "string" then
--       promptGroups[group] = {
--         group = GetRandomIntInRange(0, 0xffffff),
--         prompts = {},
--         tabAmount = 1
--       }
--     else
--        promptGroups[group] = {
--         group = group,
--         prompts = {},
--         tabAmount = 1
--       }
--     end
--   end
--   if type(key) == "table" then
--     local keys = key
--     key = keys[1]
--     promptGroups[group].prompts[key] = PromptRegisterBegin()
--     for _,k in pairs (keys) do
--       promptGroups[group].prompts[k] = promptGroups[group].prompts[key]
--       PromptSetControlAction(promptGroups[group].prompts[key], joaat(k))
--     end
--   else
--     promptGroups[group].prompts[key] = PromptRegisterBegin()
--     PromptSetControlAction(promptGroups[group].prompts[key], joaat(key))
--   end
--   str = CreateVarString(10, 'LITERAL_STRING', str)
--   PromptSetText(promptGroups[group].prompts[key], str)
--   PromptSetPriority(promptGroups[group].prompts[key], 2)
--   PromptSetEnabled(promptGroups[group].prompts[key], true)
--   PromptSetVisible(promptGroups[group].prompts[key], true)
--   if holdTime then
--     PromptSetHoldMode(promptGroups[group].prompts[key], holdTime)
--   end
-- 	if group ~= "interaction" then
--   	PromptSetGroup(promptGroups[group].prompts[key], promptGroups[group].group,tabIndex)
--     if promptGroups[group].tabAmount < tabIndex + 1 then
--       promptGroups[group].tabAmount = tabIndex + 1
--     end
-- 	end
--   PromptRegisterEnd(promptGroups[group].prompts[key])
-- end

-- function __(name)
--   return Config[name] or ("#"..name)
-- end