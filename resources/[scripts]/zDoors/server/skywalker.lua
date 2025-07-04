local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

src = {}
Tunnel.bindInterface('zDoors', src)

function src.doorsStatistics(doorNumber, doorStatus)
	local source = source

	config.doorsList[parseInt(doorNumber)].lock = doorStatus

	if config.doorsList[parseInt(doorNumber)].other ~= nil then
		local doorSecond = config.doorsList[parseInt(doorNumber)].other
		config.doorsList[doorSecond].lock = doorStatus
	end

	TriggerClientEvent('zDoors:doorsUpdate', -1, config.doorsList)

	if config.doorsList[parseInt(doorNumber)].sound then
		TriggerClientEvent('zSound:source', source, 'doorlock', 0.1)
	end
end

RegisterNetEvent('zDoors:doorsStatistics')
AddEventHandler('zDoors:doorsStatistics', function(doorNumber, doorStatus)
	config.doorsList[parseInt(doorNumber)].lock = doorStatus

	if config.doorsList[parseInt(doorNumber)].other ~= nil then
		local doorSecond = config.doorsList[parseInt(doorNumber)].other
		config.doorsList[doorSecond].lock = doorStatus
	end

	TriggerClientEvent('zDoors:doorsUpdate', -1, config.doorsList)
end)

function src.doorsPermission(doorNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if config.doorsList[parseInt(doorNumber)].perm ~= nil then
			if vRP.hasPermission(user_id, config.doorsList[parseInt(doorNumber)].perm) then
				return true
			end
		end
		return true
	end
	return false
end