Proxy = module('vrp', 'lib/Proxy')
Tunnel = module('vrp', 'lib/Tunnel')
vRP = Proxy.getInterface('vRP')

zCLIENT = {}
Tunnel.bindInterface('zInventory', zCLIENT)
zSERVER = Tunnel.getInterface('zInventory')
-----------------------------------------------------------------------------------------------------------------------------------
--[ INVENTORY ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

local ondrop = false
local takingWeapon = false
local droplist = {}
local cooldown = 0
local plateX = -1133.31
local plateY = 2694.2
local plateZ = 18.81
local skate = {}
local attached = false
local adrenalineCds = {	{ 1978.76, 5171.11, 47.64 }, { 707.86, 4183.95, 40.71 }, { 436.64, 6462.23, 28.75 }, { -2173.5, 4291.73, 49.04 }}
local firecracker = nil
local blockButtons = false
local registerCoords = {}
local imageService = config.imageService

RegisterNUICallback('invClose', function(data, cb)
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = 'hideMenu' })
	ondrop = false
end)

RegisterNUICallback('trunkClose', function(data, cb)
	zSERVER.trunkchestClose()
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = 'hideMenu' })
	ondrop = false
end)

RegisterNUICallback('unEquipeBackpack', function(data, cb)
	TriggerServerEvent('zInventory:unEquipeBackpack')
end)

RegisterNUICallback('dropOpen', function(data, cb)
	SendNUIMessage({ action = 'showDropsHideInventory' })
end)

RegisterNUICallback('dropItem', function(data)
	local ped = GetPlayerPed(-1)
	local hash = GetHashKey(data.item)
	if IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4) then
		local weapon, ammo = zSERVER.getWeaponConf(data.item)
		local ammoAmount = GetAmmoInPedWeapon(ped, hash)
		if weapon ~= 0 and ammo ~= 0 then
			if hash == GetHashKey(weapon) then
				TriggerServerEvent('zInventory:dropItem', data.item, data.amount, true, ammo, ammoAmount)
			end
		end
	else
		TriggerServerEvent('zInventory:dropItem', data.item, data.amount, true)
	end
end)

RegisterNUICallback('pickupItem', function(data)
	TriggerServerEvent('itemdrop:Pickup', data.id, data.target, data.amount)
end)

RegisterNetEvent('zInventory:useItemHot')
AddEventHandler('zInventory:useItemHot', function(slot, amount)
	if cooldown <= 0 then
		local ped = GetPlayerPed(-1)
		local item = zSERVER.getItemSlot(slot)
		local currentHash = GetHashKey(item)
		for k, v in pairs(zSERVER.getItemList()) do
			if v.type == 'equip' then
				local hash = GetHashKey(k)
				if HasPedGotWeapon(ped, hash) then
					if hash ~= currentHash then
						local ammoAmount = GetAmmoInPedWeapon(ped, hash)
						RemoveWeaponFromPed(ped, hash)
						SetPedAmmo(ped, hash, 0)
						TriggerServerEvent('zInventory:unEquipAmmo', v.ammo, ammoAmount)
					end
				end
			end
		end
		TriggerServerEvent('zInventory:useItem', slot, amount)
		cooldown = 3
	end
end)

RegisterNUICallback('useItem', function(data)
	if cooldown <= 0 then
		local ped = GetPlayerPed(-1)
		local currentHash = GetHashKey(data.item)
		if IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4) then
			for k, v in pairs(zSERVER.getItemList()) do
				if v.type == 'equip' then
					local hash = GetHashKey(k)
					if HasPedGotWeapon(ped, hash) then
						if hash ~= currentHash then	
							local ammoAmount = GetAmmoInPedWeapon(ped, hash)
							RemoveWeaponFromPed(ped, hash)
							SetPedAmmo(ped, hash, 0)
							TriggerServerEvent('zInventory:unEquipAmmo', v.ammo, ammoAmount)
						end
					end
				end
			end
		end
		TriggerServerEvent('zInventory:useItem', data.slot, data.amount)
		cooldown = 3
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)


RegisterNetEvent('zInventory:unEquipWeapon')
AddEventHandler('zInventory:unEquipWeapon', function(weapon)
	local ped = PlayerPedId()
	local hash = GetHashKey(weapon)
	RemoveWeaponFromPed(ped, hash)
	SetPedAmmo(ped, hash, 0)
end)

RegisterNUICallback('sendItem', function(data)
	local ped = GetPlayerPed(-1)
	local hash = GetHashKey(data.item)
	if IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4) then
		local weapon, ammo = zSERVER.getWeaponConf(data.item)
		local ammoAmount = GetAmmoInPedWeapon(ped, hash)
		if weapon ~= 0 and ammo ~= 0 then
			if hash == GetHashKey(weapon) then
				TriggerServerEvent('zInventory:sendItem', data.item, data.amount, ammo, ammoAmount)
			end
		end
	else
		TriggerServerEvent('zInventory:sendItem', data.item, data.amount)
	end
end)

RegisterNUICallback('updateSlot', function(data, cb)
	local ped = GetPlayerPed(-1)
	local hash = GetHashKey(data.item)
	if IsPedArmed(ped) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4) then
		local weapon, ammo = zSERVER.getWeaponConf(data.item)
		local ammoAmount = GetAmmoInPedWeapon(ped, hash)
		RemoveWeaponFromPed(ped, hash)
		if weapon ~= 0 and ammo ~= 0 then
			if hash == GetHashKey(weapon) then
				TriggerServerEvent('zInventory:updateSlot', data.item, data.slot, data.target, data.amount, ammo, ammoAmount)
				SetPedAmmo(ped, hash, 0)
			end
		end
	else
		TriggerServerEvent('zInventory:updateSlot', data.item, data.slot, data.target, data.amount)
	end
end)

RegisterNUICallback('requestHotBar', function(data, cb)
	local inventory, weight, maxweight, slots, maxslots = zSERVER.hotbar()
	if inventory then
		cb({inventory = inventory, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, imageService = imageService})
	end
end)

RegisterNUICallback('requestBackpack', function(data, cb)
	local inventory, weight, maxweight, slots, maxslots = zSERVER.backpack()
	if inventory then
		cb({inventory = inventory, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, imageService = imageService})
	end
end)

RegisterNUICallback('requestDrops', function(data, cb)
	local ped = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(ped))
	local dropItems = {}
	for k, v in pairs(droplist) do
		local bowz, cdz = GetGroundZFor_3dCoord(v.x, v.y, v.z)
		if GetDistanceBetweenCoords(v.x, v.y, cdz, x, y, z, true) <= 1.5 then
			table.insert(dropItems, { name = v.name, key = v.name, amount = v.count, index = v.index, weight = v.peso, desc = v.desc, id = k })
		end
	end
	local inventory, weight, maxweight, slots, maxslots = zSERVER.backpack()
	if inventory then
		cb({inventory = inventory, drop = dropItems, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, imageService = imageService})
	end
end)

RegisterKeyMapping('zInventory:backpack', 'Abrir invenrtário', 'keyboard', 'oem_3')

RegisterCommand('zInventory:backpack', function(source, args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 101 then
		local ped = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(ped))
		for k, v in pairs(droplist) do
			local bowz, cdz = GetGroundZFor_3dCoord(v.x, v.y, v.z)
			if GetDistanceBetweenCoords(v.x, v.y, cdz, x, y, z, true) <= 1.5 then
				ondrop = true
			end
		end

		if ondrop then
			SetNuiFocus(true, true)
			TransitionToBlurred(1000)
			SendNUIMessage({ action = 'showDrops' })
		else
			SetNuiFocus(true, true)
			TransitionToBlurred(1000)
			SendNUIMessage({ action = 'showInventory' })
		end
	end
end)

RegisterCommand('attachs', function(source, args)
	local ped = PlayerPedId()
	for k, v in pairs(config.wComponents) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2, v2 in pairs(v) do
				GiveWeaponComponentToPed(ped, GetHashKey(k), GetHashKey(v2))
			end
		end
	end
end)

function zCLIENT.closeInventory()
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SetCursorLocation(0.5, 0.5)
	SendNUIMessage({ action = 'hideMenu' })
end

function zCLIENT.dropItem(item, amount)
	TriggerServerEvent('zInventory:dropItem', item, amount, false)
end

function zCLIENT.plateDistance()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(plateX, plateY, plateZ))
			if distance <= 3.0 then
				FreezeEntityPosition(vehicle, true)
				return true
			end
		end
	end
	return false
end

function zCLIENT.plateApply(plate)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleNumberPlateText(vehicle, plate)
		FreezeEntityPosition(vehicle, false)
	end
end

function zCLIENT.blockButtons(status)
	blockButtons = status
end

function zCLIENT.parachuteColors()
	GiveWeaponToPed(PlayerPedId(), 'GADGET_PARACHUTE', 1, false, true)
	SetPedParachuteTintIndex(PlayerPedId(), math.random(7))
end

function zCLIENT.checkFountain()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	if DoesObjectOfTypeExistAtCoords(coords, 0.7, GetHashKey('prop_watercooler'), true) or DoesObjectOfTypeExistAtCoords(coords, 0.7, GetHashKey('prop_watercooler_dark'), true) then
		return true, 'fountain'
	end
	if IsEntityInWater(ped) then
		return true, 'floor'
	end
	return false
end

function zCLIENT.cashRegister()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for k, v in pairs(registerCoords) do
		local distance = #(coords - vector3(v[1], v[2], v[3]))
		if distance <= 1 then
			return false, v[1], v[2], v[3]
		end
	end
	local object = GetClosestObjectOfType(coords, 0.4, GetHashKey('prop_till_01'), 0, 0, 0)
	if DoesEntityExist(object) then
		SetEntityHeading(ped, GetEntityHeading(object)-360.0)
		local coords = GetEntityCoords(object)
		return true, coords.x, coords.y, coords.z
	end
	return false
end

function zCLIENT.fishingStatus()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(-1202.71, 2714.76, 4.11))
	if distance <= 40 then
		return true
	end
	return false
end

function zCLIENT.fishingAnim()
	local ped = PlayerPedId()
	if IsEntityPlayingAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 3) then
		return true
	end
	return false
end

function zCLIENT.putWeaponHands(weapon)
	local hash = GetHashKey(weapon)
	GiveWeaponToPed(PlayerPedId(), hash, 0, false, true)
end

function zCLIENT.rechargeWeapon(weapon, ammoAmount)
	local ped = PlayerPedId()
	if HasPedGotWeapon(ped, weapon) then
		AddAmmoToPed(ped, weapon, parseInt(ammoAmount))
	end
end

function zCLIENT.adrenalineDistance()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for k, v in pairs(adrenalineCds) do
		local distance = #(coords - vector3(v[1], v[2], v[3]))
		if distance <= 5 then
			return true
		end
	end
	return false
end

function zCLIENT.techDistance()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(1174.66, 2640.45, 37.82))
	if distance <= 10 then
		return true
	end
	return false
end

function zCLIENT.skateStart()
	local player = GetPlayerPed(-1)
	if DoesEntityExist(skate.Entity) then return end
	skateSpawn()
	while DoesEntityExist(skate.Entity) and DoesEntityExist(skate.Driver) do
		Citizen.Wait(5)
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(skate.Entity), true)
		if distanceCheck <= 100.0 then
			if not NetworkHasControlOfEntity(skate.Driver) then
				NetworkRequestControlOfEntity(skate.Driver)
			elseif not NetworkHasControlOfEntity(skate.Entity) then
				NetworkRequestControlOfEntity(skate.Entity)
			end
		else
			TaskVehicleTempAction(skate.Driver, skate.Entity, 6, 2500)
		end
	end
end

function skateMustRagdoll()
	local player = GetPlayerPed(-1)
	local x = GetEntityRotation(skate.Entity).x
	local y = GetEntityRotation(skate.Entity).y
	if ((-60.0 < x and x > 60.0)) and IsEntityInAir(skate.Entity) and skate.Speed < 5.0 then
		return true
	end	
	if (HasEntityCollidedWithAnything(GetPlayerPed(-1)) and skate.Speed > 5.0) then return true end
	if IsPedDeadOrDying(player, false) then return true end
	return false
end

function skateSpawn()
	local player = GetPlayerPed(-1)
	skateLoadModels({ GetHashKey('bmx'), 68070371, GetHashKey('p_defilied_ragdoll_01_s'), 'pickup_object', 'move_strafe@stealth', 'move_crouch_proto'})
	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())
	skate.Entity = CreateVehicle(GetHashKey('bmx'), spawnCoords, spawnHeading, true)
	skate.Skate = CreateObject(GetHashKey('p_defilied_ragdoll_01_s'), 0.0, 0.0, 0.0, true, true, true)
	while not DoesEntityExist(skate.Entity) do
		Citizen.Wait(5)
	end
	while not DoesEntityExist(skate.Skate) do
		Citizen.Wait(5)
	end
	SetEntityNoCollisionEntity(skate.Entity, player, false) -- disable collision between the player and the rc
	SetEntityCollision(skate.Entity, false, true)
	SetEntityVisible(skate.Entity, false)
	AttachEntityToEntity(skate.Skate, skate.Entity, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, -0.40, 0.0, 0.0, 90.0, false, true, true, true, 1, true)
	skate.Driver = CreatePed(12	, 68070371, spawnCoords, spawnHeading, true, true)
	SetEnableHandcuffs(skate.Driver, true)
	SetEntityInvincible(skate.Driver, true)
	SetEntityVisible(skate.Driver, false)
	FreezeEntityPosition(skate.Driver, true)
	TaskWarpPedIntoVehicle(skate.Driver, skate.Entity, -1)
	while not IsPedInVehicle(skate.Driver, skate.Entity) do
		Citizen.Wait(0)
	end
	zCLIENT.skateAttach('place')
end

function zCLIENT.skateAttach(param)
	local player = GetPlayerPed(-1)
	if not DoesEntityExist(skate.Entity) then
		return
	end
	if param == 'place' then
		AttachEntityToEntity(skate.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
		TaskPlayAnim(PlayerPedId(), 'pickup_object', 'pickup_low', 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(800)
		DetachEntity(skate.Entity, false, true)
		PlaceObjectOnGroundProperly(skate.Entity)
	elseif param == 'pick' then
		Citizen.Wait(100)
		TaskPlayAnim(PlayerPedId(), 'pickup_object', 'pickup_low', 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(600)
		AttachEntityToEntity(skate.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
		Citizen.Wait(900)
		skateClear()
	end
end

function skateClear(models)
	local player = GetPlayerPed(-1)
	DetachEntity(skate.Entity)
	DeleteEntity(skate.Skate)
	DeleteVehicle(skate.Entity)
	DeleteEntity(skate.Driver)
	skateUnloadModels()
	Attach = false
	attached  = false
	SetPedRagdollOnCollision(player, false)
end

function skateLoadModels(models)
	local player = GetPlayerPed(-1)
	for modelIndex = 1, #models do
		local model = models[modelIndex]
		if not skate.CachedModels then
			skate.CachedModels = {}
		end
		table.insert(skate.CachedModels, model)
		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Citizen.Wait(10)
			end    
		end
	end
end

function skateUnloadModels()
	local player = GetPlayerPed(-1)
	for modelIndex = 1, #skate.CachedModels do
		local model = skate.CachedModels[modelIndex]
		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end

function skateAttachPlayer(toggle)
	local player = GetPlayerPed(-1)
	if toggle then
		TaskPlayAnim(player, 'move_strafe@stealth', 'idle', 8.0, 8.0, -1, 1, 1.0, false, false, false)
		AttachEntityToEntity(player, skate.Entity, 20, 0.0, 0, 0.7, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		SetEntityCollision(player, true, true)
		SetPedRagdollOnCollision(player, true)
		TriggerServerEvent('shareImOnSkate')
	elseif not toggle then
		DetachEntity(player, false, false)
		SetPedRagdollOnCollision(player, false)
		StopAnimTask(player, 'move_strafe@stealth', 'idle', 1.0)
		StopAnimTask(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 1.0)
		TaskVehicleTempAction(skate.Driver, skate.Entity, 3, 1)	
	end	
	attached = toggle
end

RegisterNetEvent('zInventory:SetSchoolbag')
AddEventHandler('zInventory:SetSchoolbag',function(id, color)
	local ped = PlayerPedId()
	if id ~= nil and color ~= nil then
		SetPedComponentVariation(ped, 5, id, color, 3)
	end
end)

RegisterNetEvent('itemdrop:Remove')
AddEventHandler('itemdrop:Remove', function(id)
	if droplist[id] ~= nil then
		droplist[id] = nil
	end
end)

RegisterNetEvent('itemdrop:Players')
AddEventHandler('itemdrop:Players', function(id, marker)
	droplist[id] = marker
end)

RegisterNetEvent('itemdrop:Update')
AddEventHandler('itemdrop:Update', function(status)
	droplist = status
end)

RegisterNetEvent('zInventory:Update')
AddEventHandler('zInventory:Update', function(action)
	SendNUIMessage({ action = action })
end)

RegisterNetEvent('zInventory:repairVehicle')
AddEventHandler('zInventory:repairVehicle', function(index, status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			local fuel = GetVehicleFuelLevel(v)
			if status then
				SetVehicleFixed(v)
				SetVehicleDeformationFixed(v)
			end
			SetVehicleBodyHealth(v, 1000.0)
			SetVehicleEngineHealth(v, 1000.0)
			SetVehiclePetrolTankHealth(v, 1000.0)
			SetVehicleFuelLevel(v, fuel)
		end
	end
end)

RegisterNetEvent('zInventory:repairTires')
AddEventHandler('zInventory:repairTires', function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			for i = 0, 8 do
				SetVehicleTyreFixed(v, i)
			end
		end
	end
end)

RegisterNetEvent('zInventory:lockpickVehicle')
AddEventHandler('zInventory:lockpickVehicle', function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v, true, true)
			if GetVehicleDoorsLockedForPlayer(v, PlayerId()) == 1 then
				SetVehicleDoorsLocked(v, false)
				SetVehicleDoorsLockedForAllPlayers(v, false)
			else
				SetVehicleDoorsLocked(v, true)
				SetVehicleDoorsLockedForAllPlayers(v, true)
			end
			SetVehicleLights(v, 2)
			Wait(200)
			SetVehicleLights(v, 0)
			Wait(200)
			SetVehicleLights(v, 2)
			Wait(200)
			SetVehicleLights(v, 0)
		end
	end
end)

RegisterNetEvent('zInventory:updateRegister')
AddEventHandler('zInventory:updateRegister', function(status)
	registerCoords = status
end)

RegisterNetEvent('zInventory:Firecracker')
AddEventHandler('zInventory:Firecracker', function()
	if not HasNamedPtfxAssetLoaded('scr_indep_fireworks') then
		RequestNamedPtfxAsset('scr_indep_fireworks')
		while not HasNamedPtfxAssetLoaded('scr_indep_fireworks') do
			RequestNamedPtfxAsset('scr_indep_fireworks')
			Citizen.Wait(10)
		end
	end
	local mHash = GetHashKey('ind_prop_firework_03')
	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end
	local explosives = 25
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.6, 0.0)
	firecracker = CreateObjectNoOffset(mHash, coords.x, coords.y, coords.z, true, false, false)
	PlaceObjectOnGroundProperly(firecracker)
	FreezeEntityPosition(firecracker, true)
	SetModelAsNoLongerNeeded(mHash)
	Citizen.Wait(10000)
	repeat
		UseParticleFxAssetNextCall('scr_indep_fireworks')
		local explode = StartNetworkedParticleFxNonLoopedAtCoord('scr_indep_firework_trailburst', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
		explosives = explosives - 1

		Citizen.Wait(2000)
	until explosives == 0
	TriggerServerEvent('tryDeleteEntity', ObjToNet(firecracker))
end)

RegisterNetEvent('zInventory:backpackOnBody')
AddEventHandler('zInventory:backpackOnBody', function()
    SetPedComponentVariation(PlayerPedId(), 5, 52, 4, 2)
end)

RegisterNetEvent('zInventory:backpackOffBody')
AddEventHandler('zInventory:backpackOffBody', function()
    SetPedComponentVariation(PlayerPedId(), 5, -1, 0, 2)
end)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k, v in pairs(droplist) do
			local bowz, cdz = GetGroundZFor_3dCoord(v.x, v.y, v.z)
            local distance = #(coords - vector3(v.x, v.y, cdz))
            if distance <= 15 then
               timeDistance = 4
               DrawMarker(20, v.x, v.y, cdz+0.30, 0, 0, 0, 0, 0.0, 130.0, 0.6, 0.8, 0.50, 0, 129, 254, 100, 0, 0, 0, 1)
			end
        end
        Citizen.Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(plateX, plateY, plateZ))
			if distance <= 50.0 then
				timeDistance = 4
				DrawMarker(23, plateX, plateY, plateZ - 0.98, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 50, 0, 0, 0, 0)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if blockButtons then
			timeDistance = 4
			DisableControlAction(1, 73, true)
			DisableControlAction(1, 75, true)
			DisableControlAction(1, 29, true)
			DisableControlAction(1, 47, true)
			DisableControlAction(1, 105, true)
			DisableControlAction(1, 187, true)
			DisableControlAction(1, 189, true)
			DisableControlAction(1, 190, true)
			DisableControlAction(1, 188, true)
			DisableControlAction(1, 311, true)
			DisableControlAction(1, 245, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 288, true)
			DisablePlayerFiring(PlayerPedId(), true)
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 500
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(skate.Entity), true)
		local player = GetPlayerPed(-1)
		if distanceCheck <= 1.5 then
			idle = 5
			if IsControlJustPressed(0, 38) then
				TriggerServerEvent('takeSkate')
			end
			if IsControlJustReleased(0, 113) then
				if attached then
					skateAttachPlayer(false)
				elseif not IsPedRagdoll(player) then
					Citizen.Wait(200)
					skateAttachPlayer(true)
				end
			end
		end
		if distanceCheck < 100.0 then
			idle = 5
			local overSpeed = (GetEntitySpeed(skate.Entity)*3.6) > 35
			TaskVehicleTempAction(skate.Driver, skate.Entity, 1, 1)
			ForceVehicleEngineAudio(skate.Entity, 0)
			SetEntityInvincible(skate.Entity, true)
			StopCurrentPlayingAmbientSpeech(skate.Driver)	
			if attached then
				skate.Speed = GetEntitySpeed(skate.Entity) * 3.6
				if skateMustRagdoll() then
					skateAttachPlayer(false)
					SetPedToRagdoll(player, 5000, 4000, 0, true, true, false)
					attached = false
				end
			end
			if IsControlPressed(0, 32) and not IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 9, 1)
			end
			if IsControlPressed(0, 22) and attached then
				if not IsEntityInAir(skate.Entity) then	
					local vel = GetEntityVelocity(skate.Entity)
					TaskPlayAnim(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 5.0, 8.0, -1, 0, 0, false, false, false)
					local duration = 0
					local boost = 0
					while IsControlPressed(0, 22) do
						Citizen.Wait(10)
						duration = duration + 10.0
					end
					boost = 5 * duration / 250.0
					if boost > 5 then boost = 5 end
					StopAnimTask(PlayerPedId(), 'move_crouch_proto', 'idle_intro', 1.0)
					if(attached) then
						SetEntityVelocity(skate.Entity, vel.x, vel.y, vel.z + boost)
						TaskPlayAnim(player, 'move_strafe@stealth', 'idle', 8.0, 2.0, -1, 1, 1.0, false, false, false)
					end
				end
			end
			if IsControlJustReleased(0, 32) or IsControlJustReleased(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 6, 2500)
			end
			if IsControlPressed(0, 31) and not IsControlPressed(0, 32) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 22, 1)
			end
			if IsControlPressed(0, 34) and IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 13, 1)
			end
			if IsControlPressed(0, 35) and IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 14, 1)
			end
			if IsControlPressed(0, 32) and IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 30, 100)
			end
			if IsControlPressed(0, 34) and IsControlPressed(0, 32) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 7, 1)
			end
			if IsControlPressed(0, 35) and IsControlPressed(0, 32) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 8, 1)
			end
			if IsControlPressed(0, 34) and not IsControlPressed(0, 32) and not IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 4, 1)
			end
			if IsControlPressed(0, 35) and not IsControlPressed(0, 32) and not IsControlPressed(0, 31) and not overSpeed then
				TaskVehicleTempAction(skate.Driver, skate.Entity, 5, 1)
			end
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ CHEST ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local chestCoords = {}

RegisterNUICallback('chestClose', function(data)
	zSERVER.chestClose()
	TransitionFromBlurred(1000)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'hideMenu' })
end)

RegisterNUICallback('chestTakeItem', function(data)
	zSERVER.takeItem(data.item, data.slot, data.amount)
end)

RegisterNUICallback('chestStoreItem', function(data)
	zSERVER.storeItem(data.item, data.slot, data.amount)
end)

RegisterNUICallback('chestPopulateSlot', function(data, cb)
	TriggerServerEvent('chest:populateSlot', data.item, data.slot, data.target, data.amount)
end)

RegisterNUICallback('chestUpdateSlot', function(data, cb)
	TriggerServerEvent('chest:updateSlot', data.item, data.slot, data.target, data.amount)
end)

RegisterNUICallback('chestSumSlot', function(data, cb)
	TriggerServerEvent('chest:sumSlot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('requestChest', function(data, cb)
	local inventory, chest, weight, maxweight, slots, maxslots, chestweight, maxchestweight, chestslots, maxchestslots = zSERVER.openChest()
	if inventory then
		cb({ inventory = inventory, chest = chest, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, chestweight = chestweight, maxchestweight = maxchestweight, chestslots = chestslots, maxchestslots = maxchestslots, imageService = imageService })
	end
end)

function zCLIENT.insertTable(chestname, coords)
	local x, y, z = table.unpack(coords)
	table.insert(chestCoords, { chestname = chestname, x = x, y = y, z = z })
end

function gridChunk(x)
	return math.floor((x + 8192) / 128)
end

function toChannel(v)
	return (v.x << 8) | v.y
end

function DrawText3Ds(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	SetTextFont(4)
	SetTextScale(0.35, 0.35)
	SetTextColour(176, 180, 193, 150)
	SetTextEntry('STRING')
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text))/350
	DrawRect(_x, _y+0.0125, 0.01+factor, 0.03, 50, 55, 67, 200)
end

RegisterNetEvent('chest:Update')
AddEventHandler('chest:Update', function(action)
	SendNUIMessage({ action = action })
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local x, y, z = table.unpack(GetEntityCoords(ped))
			for k, v in pairs(chestCoords) do
				local distance = #(coords - vector3(parseInt(v.x), parseInt(v.y), parseInt(v.z)))
				if distance <= 2 then
					timeDistance = 4
					DrawText3Ds(v.x, v.y, v.z, '~g~E~w~  BAÚ')
					if IsControlJustPressed(1, 38) and zSERVER.checkIntPermissions(v.chestname) and distance <= 2 then
						SetNuiFocus(true, true)
						SendNUIMessage({ action = 'showChest' })
						TransitionToBlurred(1000)
						TriggerEvent('zSounds:source', 'zipper', 0.5)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ INSPECT ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false

RegisterNUICallback('inspectClose', function(data)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'hideMenu' })
	zSERVER.resetInspect()
end)

RegisterNUICallback('inspectTakeItem', function(data)
	zSERVER.takeItemInspect(data.item, data.slot, data.amount)
end)

RegisterNUICallback('inspectStoreItem', function(data)
	zSERVER.storeItemInspect(data.item, data.slot, data.amount)
end)

RegisterNUICallback('inspectPopulateSlot', function(data, cb)
	TriggerServerEvent('inspect:populateSlot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('inspectUpdateSlot', function(data, cb)
	TriggerServerEvent('inspect:updateSlot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('inspectSumSlot', function(data, cb)
	TriggerServerEvent('inspect:sumSlot', data.item, data.slotdata.amount)
end)

RegisterNUICallback('inspectSum2Slot', function(data, cb)
	TriggerServerEvent('inspect:sum2Slot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('requestInspect', function(data, cb)
	local inventory, weight, maxweight, slots, maxslots, inventorytwo, weighttwo, maxweighttwo, slotstwo, maxslotstwo = zSERVER.openInspectServ()
	if inventory and inventorytwo then
		cb({
			inventory = inventory, 
			weight = weight, 
			maxweight = maxweight, 
			slots = slots, 
			maxslots = maxslots,
			inventorytwo = inventorytwo, 
			weighttwo = weighttwo, 
			maxweighttwo = maxweighttwo, 
			slotstwo = slotstwo, 
			maxslotstwo = maxslotstwo,
			imageService = imageService
		})
	end
end)

function zCLIENT.toggleCarryInspect(source)
	uCarry = source
	iCarry = not iCarry
	local ped = PlayerPedId()
	if iCarry and uCarry then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF, PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(uCarry)), 4103, 11816, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped, false, false)
			sCarry = false
		end
	end	
end

RegisterNetEvent('inspect:OpenNui')
AddEventHandler('inspect:OpenNui', function(source)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'showInspect' })
end)

RegisterNetEvent('inspect:Update')
AddEventHandler('inspect:Update', function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ TRUNKCHEST ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('requestTrunkchest', function(data, cb) 
	local myinventory, myvehicle, weight, maxweight, slots, maxslots, weightcar, maxweightcar, slotscar, maxslotscar = zSERVER.trunkchestOpencar()
	if myinventory and myvehicle then
		cb({myinventory = myinventory, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, myvehicle = myvehicle, weightcar = weightcar, maxweightcar = maxweightcar, slotscar = slotscar, maxslotscar = maxslotscar, imageService = imageService})
	end
end)

RegisterNUICallback('trunkchestStoreItem', function(data)
	zSERVER.storeTrunkchestItem(data.item, data.slot, data.amount)
end)

RegisterNUICallback('trunkchestTakeItem', function(data)
	zSERVER.takeTrunkchestItem(data.item, data.slot, data.amount)
end)

RegisterNUICallback('trunkchestPopulateSlot', function(data, cb)
	TriggerServerEvent('trunkchest:populateSlot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('trunkchestUpdateSlot', function(data, cb)
	TriggerServerEvent('trunkchest:updateSlot', data.item, data.slot, data.amount)
end)

RegisterNUICallback('trunkchestSumSlot', function(data, cb)
	TriggerServerEvent('trunkchest:sumSlot', data.item, data.slotdata.amount)
end)

RegisterNUICallback('trunkchestSum2Slot', function(data, cb)
	TriggerServerEvent('trunkchest:sum2Slot', data.item, data.slot, data.amount)
end)

function zCLIENT.trunkOpen()
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'showTrunkchest', trunkchest = true })
end

function zCLIENT.trunkClose()
	SetNuiFocus(false)
	SendNUIMessage({ action = 'hideMenu'})
end

RegisterNetEvent('trunkchest:Update')
AddEventHandler('trunkchest:Update', function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ CHESTHOMES ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local houseName = {}

RegisterNUICallback('chesthomeTakeItem', function(data)
	zSERVER.chesthomeTakeItem(tostring(houseName), data.item, data.slot, data.amount)
end)

RegisterNUICallback('chesthomeStoreItem', function(data)
	zSERVER.chesthomeStoreItem(tostring(houseName), data.item, data.amount)
end)

RegisterNUICallback('requestChesthome', function(data, cb)
	local myinventory, mychesthome, weigth, maxweight, slots, maxslots, weighthome, maxweighthome, slotshome, maxslotshome, mychestname = zSERVER.requestChesthome(tostring(houseName))
	if myinventory and mychesthome then
		cb({ inventory = myinventory, chesthome = mychesthome, weigth = weigth, maxweight = maxweight, slots = slots, maxslots = maxslots, weighthome = weighthome, maxweighthome = maxweighthome, slotshome = slotshome, maxslotshome = maxslotshome, chesthomename = mychestname, imageService = imageService })
	end
end)

RegisterCommand(config.CommandChestHouse,function(source)
	if houseName ~= nil then
		if zSERVER.checkPermissionHome(houseName) then
			SetNuiFocus(true, true)
			SendNUIMessage({ action = 'showChesthome' })
		end
	end
end)

RegisterNetEvent('zInventory:houseOpen')
AddEventHandler('zInventory:houseOpen',function(houseOpen)
	houseName = houseOpen
end)

RegisterNetEvent('zInventory:updateChesthome')
AddEventHandler('zInventory:updateChesthome',function(action)
	SendNUIMessage({ action = action })
end)

RegisterNetEvent('zInventory:openTrunkchest')
AddEventHandler('zInventory:openTrunkchest', function()
	zSERVER.openTrunkchest()
end)

Citizen.CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		local player = GetPlayerPed(-1)
		if IsPedArmed(ped, 1) or IsPedArmed(ped, 2) or IsPedArmed(ped, 4) then
			idle = 1
			if IsPedShooting(player) then
				for k, v in pairs(zSERVER.getItemList()) do
					if v.type == 'equip' then
						local hash = GetHashKey(k)
						if HasPedGotWeapon(ped, hash) then
							zSERVER.registerWeapons(k, v.ammo, GetAmmoInPedWeapon(ped, hash))
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)