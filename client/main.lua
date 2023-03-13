local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local spawnedWeed = 0
local weedPlants = {}

local isPickingUp = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoords()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.Zones.Farm.coords, true) < 1000 then
		SpawnWeedPlants()
	end
end)

function CheckCoords()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.Zones.Farm.coords, true) < 1000 then
				SpawnWeedPlants()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)

CreateThread(function()
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID


		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then


			if IsControlJustReleased(0, 38) and not isPickingUp then
				local test = 'mush_1'
				local level =  exports["mz-skills"]:GetCurrentSkill('???')
				local currentlevel = level.Current
				print(currentlevel)
				
				isPickingUp = true
				if currentlevel < 1600 then
					test = Config.Items.Level_1_Item
				elseif currentlevel >= 1600 and currentlevel < 11999 then
					test = Config.Items.Level_2_Item
				elseif  currentlevel >= 12000 then
					test = Config.Items.Level_3_Item
				end
				QBCore.Functions.Progressbar("mushroom_picking", "Mantar Topluyorsun.", 3000, false, true, {
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false),
					ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 0.1, 0),
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObjectF(nearbyObject)
                    ClearPedTasksImmediately(PlayerPedId())

					table.remove(weedPlants, nearbyID)
					spawnedWeed = spawnedWeed - 1
					exports["mz-skills"]:UpdateSkill('???', 10)
				     TriggerServerEvent('src-mushroom:serveritem', test)
				end, function()
                    ClearPedTasksImmediately(PlayerPedId())
					ClearPedTasks(PlayerPedId())
				end, test)

				isPickingUp = false
			end
		else
			Wait(500)
		end
	end
end)

RegisterCommand('commandName', function (source, args)
	exports["mz-skills"]:UpdateSkill('???', args[1])
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			DeleteObjectF(nearbyObject)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeed < 20 do
		Wait(1)
		local weedCoords = GenerateWeedCoords()

	    SpawnLocalObject('prop_stoneshroom1', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)


			table.insert(weedPlants, obj)
			spawnedWeed = spawnedWeed + 1
		end)
	end
	Wait(45 * 60000)
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeed > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.Zones.Farm.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Wait(1000)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		weedCoordX = Config.Zones.Farm.coords.x + modX
		weedCoordY = Config.Zones.Farm.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end





SpawnLocalObject = function(model, coords, cb)
  local model = (type(model) == 'number' and model or GetHashKey(model))

  Citizen.CreateThread(function()
      RequestModel(model)
      local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
      SetModelAsNoLongerNeeded(model)

      if cb then
          cb(obj)
      end
  end)
end

DeleteObjectF = function(object)
  SetEntityAsMissionEntity(object, false, true)
  DeleteObject(object)
end

Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("VendaPedras", vector3(1963.82, 3751.17, 32.25), 1, 1, {
        name = "VendaPedras",
        heading = 0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "src-mushroom:client:openmenu",
                icon = "fas fa-question",
                label = "Alıcıyla Konuş",
            },
        },
        distance = 2.5
    })
end)

  Citizen.CreateThread(function()
	  for _,v in pairs(Config.Peds) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  pedstable =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(pedstable, v[5])
		  FreezeEntityPosition(pedstable, true)
		  SetEntityInvincible(pedstable, true)
		  SetBlockingOfNonTemporaryEvents(pedstable, true)
		  TaskStartScenarioInPlace(pedstable, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	  end
  end)

RegisterNetEvent('src-mushroom:client:openmenu')
AddEventHandler('src-mushroom:client:openmenu', function()

    exports['qb-menu']:openMenu({
		{
            header = "??? Menu",
            isMenuHeader = true
        },
        {
            header = "Şurup Yap",
            txt = "",
            params = {
				isServer = false,
                event = "src-mushroom:client:openmenu:syrup",
            }
        },	
		{
            header = "??? Sat",
            txt = "",
            params = {
				isServer = false,
                event = "src-mushroom:client:openmenu:sell",
            }
        },		
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('src-mushroom:client:openmenu:syrup')
AddEventHandler('src-mushroom:client:openmenu:syrup', function()
    exports['qb-menu']:openMenu({
		{
            header = "Şurup Menu",
            isMenuHeader = true
        },
        {
            header = "Stamina Şurubu Yap",
            txt = "25x 1 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 1,
				}
            }
        },
		{
            header = "Can Şurubu Yap",
            txt = "25x 2 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 2,
				}
            }
        },	
		{
            header = "Stamina Şurubu Yap",
            txt = "25x 2 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 6,
				}
            }
        },	
		{
            header = "Armor Şurubu Yap",
            txt = "25x 3 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 3,
				}
            }
        },	
		{
            header = "Can Şurubu Yap",
            txt = "25x 3 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 4,
				}
            }
        },	
		{
            header = "Stamina Şurubu Yap",
            txt = "25x 3 LEVEL Sihirli ??? ",
            params = {
				isServer = true,
                event = "src-mushroom:syrup",
				args = {
					level = 5,
				}
            }
        },	
				
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('src-mushroom:client:openmenu:sell')
AddEventHandler('src-mushroom:client:openmenu:sell', function()

    exports['qb-menu']:openMenu({
		{
            header = "??? Satış Menu",
            isMenuHeader = true
        },
        	
		{
            header = "1. LEVEL ??? Sat",
            txt = "",
            params = {
				isServer = true,
                event = "src-mushroom:sell",
				args = {
					level = 1,
				}
            }
        },	
		{
            header = "2. LEVEL ??? Sat",
            txt = "",
            params = {
				isServer = true,
                event = "src-mushroom:sell",
				args = {
					level = 2,
				}
            }
        },	
		{
            header = "3. LEVEL ??? Sat",
            txt = "",
            params = {
				isServer = true,
                event = "src-mushroom:sell",
				args = {
					level = 3,
				}
            }
        },		
		
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })

end)

RegisterNetEvent('stamina-src', function()
	exports['ps-buffs']:StaminaBuffEffect(15000, 1.4)
end)

RegisterNetEvent('heal-src', function()
	exports['ps-buffs']:AddHealthBuff(20000, 10)
end)
RegisterNetEvent('arm-src', function()
	exports['ps-buffs']:AddArmorBuff(30000, 10)
end)

RegisterNetEvent('acid-src', function()
	-- exports["qb-smallresources"]:DoAcid(240000)
end)
