local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

z = {}
Tunnel.bindInterface('zADMIN', z)
zSERVER = Tunnel.getInterface('zADMIN')

local vehEletric = {
	['teslaprior'] = true,
	['voltic'] = true,
	['raiden'] = true,
	['neon'] = true,
	['tezeract'] = true,
	['cyclone'] = true,
	['surge'] = true,
	['dilettante'] = true,
	['dilettante2'] = true,
	['bmx'] = true,
	['cruiser'] = true,
	['fixter'] = true,
	['scorcher'] = true,
	['tribike'] = true,
	['tribike2'] = true,
	['tribike3'] = true
}

local dickheaddebug = false

local Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [', '] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
	['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

local inFreeze = false

RegisterCommand(config.commands['noclip'].cmd, function(source, args, rawCommand)
	zSERVER.enablaNoclip()
end)

RegisterKeyMapping(config.commands['noclip'].cmd, 'Admin: Noclip', 'keyboard', 'o')

function z.vehicleHash(vehicle)
	
end

function z.teleportWay()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
    end
	local waypointBlip = GetFirstBlipInfoId(8)
	local x, y, z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))
	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0, 1050.0, 1100.0 }
	for i, height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped, x, y, height, 0, 0, 1)
		RequestCollisionAtCoord(x, y, z)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(10)
		end
		Citizen.Wait(20)
		ground, z = GetGroundZFor_3dCoord(x, y, height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end
	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(ped, 0xFBAB5776, 1, 0)
	end
	RequestCollisionAtCoord(x, y, z)
	while not HasCollisionLoadedAroundEntity(ped) do
		Citizen.Wait(10)
	end
	SetEntityCoordsNoOffset(ped, x, y, z, 0, 0, 1)
end

function z.teleportLimbo()
	local ped = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(ped))
	local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(5, 10), 0, 0, 0)
	local x2, y2, z2 = table.unpack(vector)
	SetEntityCoordsNoOffset(ped, x2, y2, z2+5, 0, 0, 1)
end

function z.deleteNpcs()
	local handle, ped = FindFirstPed()
	local finished = false
	repeat
		local coords = GetEntityCoords(ped)
		local coordsPed = GetEntityCoords(PlayerPedId())
		local distance = #(coords - coordsPed)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			TriggerServerEvent('tryDeleteEntity', PedToNet(ped))
			finished = true
		end
		finished, ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end

function GetVehicle()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos['x'], pos['y'], pos['z']+1, 'Veh: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. ' IN CONTACT' )
	    	else
	    		DrawText3Ds(pos['x'], pos['y'], pos['z']+1, 'Veh: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. '' )
	    	end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos['x'], pos['y'], pos['z']+1, 'Obj: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. ' IN CONTACT' )
	    	else
	    		DrawText3Ds(pos['x'], pos['y'], pos['z']+1, 'Obj: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. '' )
	    	end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
	    		DrawText3Ds(pos['x'], pos['y'], pos['z'], 'Ped: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. ' Relationship HASH: ' .. GetPedRelationshipGroupHash(ped) .. ' IN CONTACT' )
	    	else
	    		DrawText3Ds(pos['x'], pos['y'], pos['z'], 'Ped: ' .. ped .. ' Model: ' .. GetEntityModel(ped) .. ' Relationship HASH: ' .. GetPedRelationshipGroupHash(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function debugon()
    Citizen.CreateThread( function()
        while true do
            Citizen.Wait(1)
            if dickheaddebug then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
                local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
                local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
                local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 
                local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
                local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
                local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
                local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
                currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
                drawTxtS(0.8, 0.50, 0.4, 0.4, 0.30, 'Heading: ' .. GetEntityHeading(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.52, 0.4, 0.4, 0.30, 'Coords: ' .. pos, 55, 155, 55, 255)
                drawTxtS(0.8, 0.54, 0.4, 0.4, 0.30, 'Attached Ent: ' .. GetEntityAttachedTo(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.56, 0.4, 0.4, 0.30, 'Health: ' .. GetEntityHealth(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.58, 0.4, 0.4, 0.30, 'H a G: ' .. GetEntityHeightAboveGround(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.60, 0.4, 0.4, 0.30, 'Model: ' .. GetEntityModel(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.62, 0.4, 0.4, 0.30, 'Speed: ' .. GetEntitySpeed(GetPlayerPed(-1)), 55, 155, 55, 255)
                drawTxtS(0.8, 0.64, 0.4, 0.4, 0.30, 'Frame Time: ' .. GetFrameTime(), 55, 155, 55, 255)
                drawTxtS(0.8, 0.66, 0.4, 0.4, 0.30, 'Street: ' .. currentStreetName, 55, 155, 55, 255)
                DrawLine(pos, forPos, 255, 0, 0, 115)
                DrawLine(pos, backPos, 255, 0, 0, 115)
                DrawLine(pos, LPos, 255, 255, 0, 115)
                DrawLine(pos, RPos, 255, 255, 0, 115)
                DrawLine(forPos, forPos2, 255, 0, 255, 115)
                DrawLine(backPos, backPos2, 255, 0, 255, 115)
                DrawLine(LPos, LPos2, 255, 255, 255, 115)
                DrawLine(RPos, RPos2, 255, 255, 255, 115)
                local nearped = getNPC()
                local veh = GetVehicle()
                local nearobj = GetObject()
                if IsControlJustReleased(0, 38) then
                    if inFreeze then
                        inFreeze = false
                        TriggerEvent('Notify', 'aviso', 'Freeze ON.', 5000)
                    else
                        inFreeze = true
                        TriggerEvent('Notify', 'aviso', 'Freeze OFF.', 5000)
                    end
                end
            else
                Citizen.Wait(5000)
            end
        end
    end)
end

function drawTxtS(x, y , width, height, scale, text, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y=World3dToScreen2d(x, y, z)
    local px, py, pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('skinmenu')
AddEventHandler('skinmenu', function(mhash)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(10)
    end
    if HasModelLoaded(mhash) then
        SetPlayerModel(PlayerId(), mhash)
        SetModelAsNoLongerNeeded(mhash)
    end
end)

RegisterNetEvent('adminVehicle')
AddEventHandler('adminVehicle', function(name, plate)
	local mHash = GetHashKey(name)
	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end
	if HasModelLoaded(mHash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mHash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
		SetVehicleDirtLevel(nveh, 0.0)
		SetVehRadioStation(nveh, 'OFF')
		SetVehicleNumberPlateText(nveh, plate)
		SetEntityAsMissionEntity(nveh, true, true)
		SetPedIntoVehicle(ped, nveh, -1)
		if vehEletric[vehname] then
			SetVehicleFuelLevel(nveh, 0.0)
		else
			SetVehicleFuelLevel(nveh, 100.0)
		end
		SetModelAsNoLongerNeeded(mHash)
	end
end)

RegisterNetEvent('zADMIN:vehicleTuning')
AddEventHandler('zADMIN:vehicleTuning', function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11)-1, false)
		SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12)-1, false)
		SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13)-1, false)
		SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15)-1, false)
		ToggleVehicleMod(vehicle, 18, true)
	end
end)

RegisterNetEvent('ToggleDebug')
AddEventHandler('ToggleDebug', function()
	dickheaddebug = not dickheaddebug
    if dickheaddebug then
        TriggerEvent('chatMessage', 'DEBUG', {255, 70, 50}, 'ON')
        debugon()
    else
        TriggerEvent('chatMessage', 'DEBUG', {255, 70, 50}, 'OFF')
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000)
        SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
    end
end)

-- Comando para desbugar screen
RegisterCommand('desbugar',function(source)
	TriggerEvent('zLogin:Hide')
	SetNuiFocus(false)
	TransitionFromBlurred(1000)
	DoScreenFadeIn(500)
	FreezeEntityPosition(PlayerPedId(),false)
end)

function DrawTxt(text, x, y)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.35, 0.35)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

RegisterNetEvent('zADMIN:spawnarveiculo')
AddEventHandler('zADMIN:spawnarveiculo',function(name, plate)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mhash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)
		SetVehicleNumberPlateText(nveh,plate) 
		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetVehicleIsStolen(nveh,false)
		SetPedIntoVehicle(ped,nveh,-1)
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetEntityInvincible(nveh,false)
		
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehRadioStation(nveh,"OFF")
	end
end)