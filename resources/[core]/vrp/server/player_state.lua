local customize = {}

for i = 0, 19 do
	customize[i] = { 1, 0 }
end

AddEventHandler('vRP:playerSpawn', function(user_id, source)
	local data = vRP.getUserDataTable(user_id)
	if data then
		if data.customization then
			data.customization = nil
		end

		if data.position then
			if data.position.x == nil or data.position.y == nil or data.position.z == nil then
				data.position = { x = -26.9, y = -145.5, z = 56.98 }
			end 
		else
			data.position = { x = -26.9, y = -145.5, z = 56.98 }
		end
		vRPclient.teleport(source, data.position.x, data.position.y, data.position.z+0.5)

		if data.skin then
			vRPclient.applySkin(source, data.skin)
		end

		if data.armour then
			vRPclient.setArmour(source, data.armour)
		end

		if data.health then
			vRPclient.setHealth(source, data.health)
			TriggerClientEvent('statusHunger', source, data.hunger)
			TriggerClientEvent('statusThirst', source, data.thirst)
			TriggerClientEvent('statusStress', source, data.stress)
		end

		if data.inventory == nil then
			data.inventory = {}
		end

		if data.weaps then
			vRPclient.giveWeapons(source, data.weaps, true)
		end

		vRPclient.playerReady(source)
	end
end)

function tvRP.updatePositions(x, y, z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.position = { x = tvRP.mathLegth(x), y = tvRP.mathLegth(y), z = tvRP.mathLegth(z) }
		end
	end
end

function tvRP.mathLegth(n)
	return math.ceil(n*100)/100
end

RegisterServerEvent('tryDeleteEntity')
AddEventHandler('tryDeleteEntity', function(index)
	TriggerClientEvent('syncDeleteEntity', -1, index)
end)

RegisterServerEvent('tryCleanEntity')
AddEventHandler('tryCleanEntity', function(index)
	TriggerClientEvent('syncCleanEntity', -1, index)
end)

function gridChunk(x)
	return math.floor((x + 8192) / 128)
end

function toChannel(v)
	return (v.x << 8) | v.y
end

function vRP.getGridzone(x, y)
	local gridChunk = vector2(gridChunk(x), gridChunk(y))
	return toChannel(gridChunk)
end