local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

zSERVER = Tunnel.getInterface('zLogin')

local cam = nil
local new = false
local weight = 270.0

RegisterNUICallback('requestLocalizations', function(data, cb)
	local loc = zSERVER.localizations()
	local imgLastLocation = config.imageLastLocation
	if loc then
		cb({ loc = loc, imgLastLocation = imgLastLocation })
	end
end)

RegisterNUICallback('spawn', function(data, cb)
	local ped = PlayerPedId()
	if data.choice == 'spawn' then
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ action = 'closeInterface' })
		
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)

		SetEntityVisible(ped, true, false)
		FreezeEntityPosition(ped, false)
		SetEntityInvincible(ped, false)

		RenderScriptCams(false, false, 0, true, true)
		SetCamActive(cam, false)
		DestroyCam(cam, true)
		cam = nil

		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
		TriggerEvent('zHud:changeHudOnOff', true)
		TriggerEvent('vRP:playerReady', true)
	elseif data.choice == 'return' then
		SendNUIMessage({ action = 'buttomsMenuOff' })
		DoScreenFadeOut(500)
		Citizen.Wait(500)
		local x, y, z = table.unpack(GetEntityCoords(ped))

		SetCamCoord(cam, x, y, z + 200)

		Citizen.Wait(500)
		DoScreenFadeIn(500)
		SendNUIMessage({ action = 'selectionMenuOn' })
	else
		SendNUIMessage({ action = 'selectionMenuOff' })
		new = false
		local speed = 0.7
		TransitionFromBlurred(1000)
		DoScreenFadeOut(500)
		Citizen.Wait(500)

		SetCamRot(cam, 270.0)
		SetCamActive(cam, true)
		new = true
		weight = 270.0

		DoScreenFadeIn(500)

		for a, b in pairs(config.localizations) do
			if a == data.choice then
				SetEntityCoords(ped, b.x, b.y, b.z + 0.5)
			end
		end

		local x, y, z = table.unpack(GetEntityCoords(ped))

		SetCamCoord(cam, x, y, z+200.0)
		local i = z + 200.0

		while i > config.localizations[data.choice].z + 1.5 do
			Citizen.Wait(5)
			i = i - speed
			SetCamCoord(cam, x, y, i)

			if i <= config.localizations[data.choice].z + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(cam, weight)
			end

			if not new then
				break
			end
		end

		SendNUIMessage({ action = 'buttomsMenuOn' })
	end
	cb('ok')
end)

RegisterNetEvent('zLogin:Hide')
AddEventHandler('zLogin:Hide', function(status, cutscene)
	SendNUIMessage({ action = 'closeInterface' })
end)

RegisterNetEvent('zLogin:Spawn')
AddEventHandler('zLogin:Spawn', function(status, cutscene)
	local ped = PlayerPedId()
	if status then
		SetEntityVisible(ped, true, false)
		FreezeEntityPosition(ped, false)
		SetEntityInvincible(ped, false)
		
		RenderScriptCams(false, false, 0, true, true)
		SetCamActive(cam, false)
		DestroyCam(cam, true)
		cam = nil
		if not cutscene then
			TriggerEvent('zHud:changeHudOnOff', true)
		end
	else
		local x, y, z = table.unpack(GetEntityCoords(ped))

		cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', x, y, z+200.0, 270.00, 0.0, 0.0, 80.0, 0, 0)
		SetCamActive(cam, true)

		RenderScriptCams(true, false, 1, true, true)

		SetNuiFocus(true, true)
		TransitionToBlurred(1000)
		SendNUIMessage({ action = 'selectionMenuLoading' })
		SendNUIMessage({ action = 'selectionMenuOn' })
		TriggerEvent('zHud:changeHudOnOff', false)
	end

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end)
