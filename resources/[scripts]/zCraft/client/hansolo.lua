local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

z = {}
Tunnel.bindInterface('zCraft', z)
zSERVER = Tunnel.getInterface('zCraft')

local factory = nil
local imageService = config.imageService


RegisterCommand('craft', function(source, args)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 101 then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        for a, b in pairs(config.craft) do
			local distance = #(coords - vector3(b['coords'].x, b['coords'].y, b['coords'].z))
            if distance <= 5.0 and zSERVER.checkPermission(b['permission']) then
				SetNuiFocus(true, true)
				TransitionToBlurred(1000)
				SendNUIMessage({ action = 'showCraft', type = a })
				factory = a
			end
        end
	end
end)

RegisterNUICallback('requestCrafts',function(data, cb)
	local craft = zSERVER.craft(factory)	
	if craft then
		cb({ craft = craft, imageService = imageService})
	end
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = 'hideMenu' })
end)

RegisterNUICallback('craftar', function(data, cb)
	zSERVER.crafting(data.item)
end)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('zCraft:closeNui')
AddEventHandler('zCraft:closeNui', function()
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = 'hideMenu' })
end)


Citizen.CreateThread(function()
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
end)