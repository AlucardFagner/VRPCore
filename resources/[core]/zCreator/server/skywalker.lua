local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRPclient = Tunnel.getInterface('vRP')
vRP = Proxy.getInterface('vRP')

local userlogin = {}

function processSpawnController(source, statusSent, user_id)
	if statusSent == 2 then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			doSpawnPlayer(source, user_id, false, false)
		else
			doSpawnPlayer(source, user_id, true, false)
		end
	elseif statusSent == 1 or statusSent == 0 then
		userlogin[user_id] = true
		local data = vRP.getUserDataTable(user_id)
		if data then
			TriggerClientEvent('zCreator:characterCreate', source)
		end
	end
end

function registerChar(source, user_id, name, firstname)
	vRP.execute('vRP/rename_user', {user_id = parseInt(user_id), name = name, firstname = firstname})
end

function doSpawnPlayer(source, user_id, firstspawn, cutscene)
	TriggerClientEvent('zCreator:normalSpawn', source, firstspawn, cutscene)
	TriggerEvent('zBarberShops:init', user_id)
	TriggerEvent('zBank:init', user_id)
end



RegisterServerEvent('zCreator:Spawn')
AddEventHandler('zCreator:Spawn', function(source, user_id) 
	local data = vRP.getUData(user_id, 'spawnController')
	local sdata = json.decode(data) or 0
	if sdata then
		Citizen.Wait(1000)
		processSpawnController(source, sdata, user_id)
	end
end)

RegisterServerEvent('zCreator:finishedCharacter')
AddEventHandler('zCreator:finishedCharacter', function(characterName, characterFirstname, currentCharacterMode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		registerChar(source, user_id, characterName, characterFirstname)
		TriggerClientEvent('convertClothes', source, vRPclient.getCustomization(source))
		vRP.setUData(user_id, 'currentCharacterMode', json.encode(currentCharacterMode))
		vRP.setUData(user_id, 'spawnController', json.encode(2))
		doSpawnPlayer(source, user_id, true, true)
	end
end)