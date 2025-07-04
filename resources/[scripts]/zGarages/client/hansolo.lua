local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zCLIENT = {}
Tunnel.bindInterface('zGarages', zCLIENT)
zSERVER = Tunnel.getInterface('zGarages')

local pointspawn = 1

local vehicleanchor = false
local boatanchor = false
local cooldown = 0
local vehicle = {}
local vehblips = {}
local gps = {}

RegisterNUICallback('myVehicles', function(data, cb)
	local vehicles = zSERVER.myVehicles(data.garage, data.key)
	local imageService = config.imageService
	if vehicles then
		cb({ vehicles = vehicles, imageService = imageService })
	end
end)

RegisterNUICallback('ButtonClick', function(data, cb)
	if data == 'exit' then
		SetNuiFocus(false, false)
		SendNUIMessage({ action = 'hideMenu' })
		StopScreenEffect('MenuMGSelectionIn')
	end
end)

RegisterNUICallback('spawnVehicles', function(data)
    if cooldown < 1 then
        cooldown = 3
		zSERVER.spawnVehicles(data.name, data.plate, parseInt(pointspawn))
		SetNuiFocus(false, false)
		SendNUIMessage({ action = 'hideMenu' })
		StopScreenEffect('MenuMGSelectionIn')
	end
end)

RegisterNUICallback('deleteVehicles', function(data)
    if cooldown < 1 then
        cooldown = 3
		zSERVER.deleteVehicles()
		SetNuiFocus(false, false)
		SendNUIMessage({ action = 'hideMenu' })
		StopScreenEffect('MenuMGSelectionIn')
    end
end)


RegisterNetEvent('zGarages:open')
AddEventHandler('zGarages:open', function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		for k, v in pairs(config.garages) do
			local coords = GetEntityCoords(PlayerPedId())
			local distance = #(coords - vector3(v.x, v.y, v.z))
			if distance < 5.4 then
				zSERVER.checkGarage(v.name, k)
			end
		end
	end
end)

function zCLIENT.openGarage(garage, key)
	pointspawn = parseInt(key)
	StartScreenEffect('MenuMGSelectionIn', 0, true)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'showMenu', garage = garage, key = parseInt(key) })
end

RegisterCommand('setlivery', function(source, args, custom)
	local ped = PlayerPedId()
	local vehicle = vRP.getNearVehicle(5)
	SetVehicleLivery(vehicle, parseInt(args[1]))
end)

RegisterKeyMapping('zGarages:LockCar', 'Lock Car', 'keyboard', 'L')
RegisterCommand('zGarages:LockCar', function()
	if cooldown < 1 then
		cooldown = 3
		zSERVER.vehicleLock()
	end
end)

function zCLIENT.vehicleMods(veh, custom)
	if custom and veh then
		SetVehicleModKit(veh, 0)
		if custom.color then
			SetVehicleColours(veh, tonumber(custom.color[1]), tonumber(custom.color[2]))
			SetVehicleExtraColours(veh, tonumber(custom.extracolor[1]), tonumber(custom.extracolor[2]))
		end

		if custom.smokecolor then
			SetVehicleTyreSmokeColor(veh, tonumber(custom.smokecolor[1]), tonumber(custom.smokecolor[2]), tonumber(custom.smokecolor[3]))
		end

		if custom.neon then
			SetVehicleNeonLightEnabled(veh, 0, 1)
			SetVehicleNeonLightEnabled(veh, 1, 1)
			SetVehicleNeonLightEnabled(veh, 2, 1)
			SetVehicleNeonLightEnabled(veh, 3, 1)
			SetVehicleNeonLightsColour(veh, tonumber(custom.neoncolor[1]), tonumber(custom.neoncolor[2]), tonumber(custom.neoncolor[3]))
		else
			SetVehicleNeonLightEnabled(veh, 0, 0)
			SetVehicleNeonLightEnabled(veh, 1, 0)
			SetVehicleNeonLightEnabled(veh, 2, 0)
			SetVehicleNeonLightEnabled(veh, 3, 0)
		end

		if custom.plateindex then
			SetVehicleNumberPlateTextIndex(veh, tonumber(custom.plateindex))
		end

		if custom.windowtint then
			SetVehicleWindowTint(veh, tonumber(custom.windowtint))
		end

		if custom.bulletProofTyres then
			SetVehicleTyresCanBurst(veh, custom.bulletProofTyres)
		end

		if custom.wheeltype then
			SetVehicleWheelType(veh, tonumber(custom.wheeltype))
		end

		if custom.spoiler then
			SetVehicleMod(veh, 0, tonumber(custom.spoiler))
			SetVehicleMod(veh, 1, tonumber(custom.fbumper))
			SetVehicleMod(veh, 2, tonumber(custom.rbumper))
			SetVehicleMod(veh, 3, tonumber(custom.skirts))
			SetVehicleMod(veh, 4, tonumber(custom.exhaust))
			SetVehicleMod(veh, 5, tonumber(custom.rollcage))
			SetVehicleMod(veh, 6, tonumber(custom.grille))
			SetVehicleMod(veh, 7, tonumber(custom.hood))
			SetVehicleMod(veh, 8, tonumber(custom.fenders))
			SetVehicleMod(veh, 10, tonumber(custom.roof))
			SetVehicleMod(veh, 11, tonumber(custom.engine))
			SetVehicleMod(veh, 12, tonumber(custom.brakes))
			SetVehicleMod(veh, 13, tonumber(custom.transmission))
			SetVehicleMod(veh, 14, tonumber(custom.horn))
			SetVehicleMod(veh, 15, tonumber(custom.suspension))
			SetVehicleMod(veh, 16, tonumber(custom.armor))
			SetVehicleMod(veh, 23, tonumber(custom.tires), custom.tiresvariation)
		
			if IsThisModelABike(GetEntityModel(veh)) then
				SetVehicleMod(veh, 24, tonumber(custom.btires), custom.btiresvariation)
			end
		
			SetVehicleMod(veh, 25, tonumber(custom.plateholder))
			SetVehicleMod(veh, 26, tonumber(custom.vanityplates))
			SetVehicleMod(veh, 27, tonumber(custom.trimdesign)) 
			SetVehicleMod(veh, 28, tonumber(custom.ornaments))
			SetVehicleMod(veh, 29, tonumber(custom.dashboard))
			SetVehicleMod(veh, 30, tonumber(custom.dialdesign))
			SetVehicleMod(veh, 31, tonumber(custom.doors))
			SetVehicleMod(veh, 32, tonumber(custom.seats))
			SetVehicleMod(veh, 33, tonumber(custom.steeringwheels))
			SetVehicleMod(veh, 34, tonumber(custom.shiftleavers))
			SetVehicleMod(veh, 35, tonumber(custom.plaques))
			SetVehicleMod(veh, 36, tonumber(custom.speakers))
			SetVehicleMod(veh, 37, tonumber(custom.trunk)) 
			SetVehicleMod(veh, 38, tonumber(custom.hydraulics))
			SetVehicleMod(veh, 39, tonumber(custom.engineblock))
			SetVehicleMod(veh, 40, tonumber(custom.camcover))
			SetVehicleMod(veh, 41, tonumber(custom.strutbrace))
			SetVehicleMod(veh, 42, tonumber(custom.archcover))
			SetVehicleMod(veh, 43, tonumber(custom.aerials))
			SetVehicleMod(veh, 44, tonumber(custom.roofscoops))
			SetVehicleMod(veh, 45, tonumber(custom.tank))
			SetVehicleMod(veh, 46, tonumber(custom.doors))
			SetVehicleMod(veh, 48, tonumber(custom.liveries))
			SetVehicleLivery(veh, tonumber(custom.liveries))

			ToggleVehicleMod(veh, 20, tonumber(custom.tyresmoke))
			ToggleVehicleMod(veh, 22, tonumber(custom.headlights))
			ToggleVehicleMod(veh, 18, tonumber(custom.turbo))
		end
	end
end

function zCLIENT.spawnVehicle(vehname, vehplate, vehengine, vehbody, vehfuel, custom, plate)
	if vehicle[vehplate] == nil then
		local checkslot = 1
		local mhash = GetHashKey(vehname)
		while not HasModelLoaded(mhash) do
			RequestModel(mhash)
			Citizen.Wait(1)
		end
		if HasModelLoaded(mhash) then
			while true do
				local checkPos = GetClosestVehicle(config.garages[pointspawn].parkings[checkslot].x, config.garages[pointspawn].parkings[checkslot].y, config.garages[pointspawn].parkings[checkslot].z, 3.001, 0, 71)
				if DoesEntityExist(checkPos) and checkPos ~= nil then
					checkslot = checkslot + 1
					if checkslot > #config.garages[pointspawn].parkings then
						checkslot = -1
						TriggerEvent('Notify', 'importante', 'Todas as vagas estão ocupadas no momento.', 10000)
						break
					end
				else
					break
				end
				Citizen.Wait(10)
			end
			if checkslot ~= -1 then
				local nveh = CreateVehicle(mhash, config.garages[pointspawn].parkings[checkslot].x, config.garages[pointspawn].parkings[checkslot].y, config.garages[pointspawn].parkings[checkslot].z+0.5, config.garages[pointspawn].parkings[checkslot].h, true, false)
				SetVehicleIsStolen(nveh, false)
				SetVehicleNeedsToBeHotwired(nveh, false)
				SetVehicleOnGroundProperly(nveh)
				SetVehicleNumberPlateText(nveh, vehplate)
				SetEntityAsMissionEntity(nveh, true, true)
				SetVehRadioStation(nveh, 'OFF')
				SetVehicleEngineHealth(nveh, vehengine+0.0)
				SetVehicleBodyHealth(nveh, vehbody+0.0)
				SetVehicleFuelLevel(nveh, vehfuel+0.0)
				zCLIENT.vehicleMods(nveh, custom)
				zCLIENT.syncBlips(nveh, vehname)
				vehicle[vehplate] = true
				gps[vehplate] = true
				SetModelAsNoLongerNeeded(mhash)
				local v = VehToNet(nveh)
				SetVehicleDoorsLocked(nveh, true)
				SetVehicleDoorsLockedForAllPlayers(nveh, true)
				return true, VehToNet(nveh)
			end
		end
	end
	return false
end

function zCLIENT.syncBlips(nveh, vehname)
	Citizen.CreateThread(function()
		while true do
			if GetBlipFromEntity(nveh) == 0 and gps[vehname] ~= nil then
				vehblips[vehname] = AddBlipForEntity(nveh)
				SetBlipSprite(vehblips[vehname], 1)
				SetBlipAsShortRange(vehblips[vehname], false)
				SetBlipColour(vehblips[vehname], 80)
				SetBlipScale(vehblips[vehname], 0.4)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString('~b~Rastreador: ~g~'..GetDisplayNameFromVehicleModel(GetEntityModel(nveh)))
				EndTextCommandSetBlipName(vehblips[vehname])
			end
			Citizen.Wait(100)
		end
	end)
end

function zCLIENT.deleteVehicle(vehicle)
	if IsEntityAVehicle(vehicle) then
		zSERVER.tryDelete(VehToNet(vehicle), GetVehicleNumberPlateText(vehicle), GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle), GetVehicleFuelLevel(vehicle))
	end
end

function zCLIENT.removeGpsVehicle(plate)
	if vehicle[plate] then
		RemoveBlip(vehblips[plate])
		vehblips[plate] = nil
		gps[plate] = nil
	end
end

function zCLIENT.freezeVehicleNotebook(vehicle)
	while not HasAnimDictLoaded(animDict) do
		RequestAnimDict(animDict)
		Citizen.Wait(1)
	end

	if IsEntityAVehicle(vehicle) then
		FreezeEntityPosition(vehicle, true)
		TaskPlayAnim(PlayerPedId(), animDict, anim, 3.0, 3.0, -1, 49, 5.0, 0, 0, 0)
		SetTimeout(60000, function()
			FreezeEntityPosition(vehicle, false)
			StopAnimTask(PlayerPedId(), animDict, anim, 1.0)
		end)
	end
end

function zCLIENT.syncVehicle(vehicle)
	if NetworkDoesNetworkIdExist(vehicle) then
		local v = NetToVeh(vehicle)
		if DoesEntityExist(v) and IsEntityAVehicle(v) then
			Citizen.InvokeNative(0xAD738C3085FE7E11, v, true, true)
			SetEntityAsMissionEntity(v, true, true)
			SetVehicleHasBeenOwnedByPlayer(v, true)
			NetworkRequestControlOfEntity(v)
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
			DeleteEntity(v)
			DeleteVehicle(v)
			SetEntityAsNoLongerNeeded(v)
		end
	end
end

function zCLIENT.syncNameDelete(plate)
	if vehicle[plate] then
		vehicle[plate] = nil
		if DoesBlipExist(vehblips[plate]) then
			RemoveBlip(vehblips[plate])
			vehblips[plate] = nil
		end
	end
end

function zCLIENT.returnVehicle(plate)
	return vehicle[plate]
end

function zCLIENT.vehicleAnchor(vehicle)
	local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 393.26, -1618.58, 29.3, true)
	if IsEntityAVehicle(vehicle) then
		if distance <= 20 then
			if vehicleanchor then
				TriggerEvent('Notify', 'importante', 'Veículo destravado.', 8000)
				FreezeEntityPosition(vehicle, false)
				vehicleanchor = false
			else
				TriggerEvent('Notify', 'importante', 'Veículo travado.', 8000)
				FreezeEntityPosition(vehicle, true)
				vehicleanchor = true
			end
		end
	end
end

function zCLIENT.boatAnchor(vehicle)
	if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) == 14 then
		if boatanchor then
			TriggerEvent('Notify', 'importante', 'Barco desancorado.', 8000)
			FreezeEntityPosition(vehicle, false)
			boatanchor = false
		else
			TriggerEvent('Notify', 'importante', 'Barco ancorado.', 8000)
			FreezeEntityPosition(vehicle, true)
			boatanchor = true
		end
	end
end

function zCLIENT.returnlivery(vehicle, livery)
	local ped = PlayerPedId()
	local vehicle = vRP.getNearVehicle(5)
	local livery = GetVehicleLivery(vehicle)
	return livery
end

function zCLIENT.getHash(vehiclehash)
    local vehicle = vRP.getNearVehicle(7)
    local vehiclehash = GetEntityModel(vehicle)
    return vehiclehash
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y=World3dToScreen2d(x, y, z)
    local px, py, pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function zCLIENT.vehicleClientLock(index, lock)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v, true, true)
			if lock == 1 then
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
end

function zCLIENT.vehicleClientTrunk(vehid, trunk)
	if NetworkDoesNetworkIdExist(vehid) then
		local v = NetToVeh(vehid)
		if DoesEntityExist(v) and IsEntityAVehicle(v) then
			if trunk then
				SetVehicleDoorShut(v, 5, 0)
			else
				SetVehicleDoorOpen(v, 5, 0, 0)
			end
		end
	end
end

function zCLIENT.syncVehiclesEveryone(veh, status)
	SetVehicleDoorsLocked(veh, status)
end

RegisterNetEvent('limpar')
AddEventHandler('limpar', function()
	local vehicle = vRP.getNearVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent('trylimpar', VehToNet(vehicle))
	end
end)

RegisterNetEvent('synclimpar')
AddEventHandler('synclimpar', function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDirtLevel(v, 0.0)
				Citizen.InvokeNative(0xAD738C3085FE7E11, v, true, true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v, fuel)
			end
		end
	end
end)

RegisterNetEvent('reparar')
AddEventHandler('reparar', function()
	local vehicle = vRP.getNearVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent('tryreparar', VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar', function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				--SetVehicleDirtLevel(v, 0.0)
				SetVehicleUndriveable(v, false)
				Citizen.InvokeNative(0xAD738C3085FE7E11, v, true, true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v, fuel)
			end
		end
	end
end)

RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor', function()
	local vehicle = vRP.getNearVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent('trymotor', VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncmotor')
AddEventHandler('syncmotor', function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v, 1000.0)
			end
		end
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