local Proxy = module('lib/Proxy')
local Tunnel = module('lib/Tunnel')

vRP = {}
vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_sources = {}
Proxy.addInterface('vRP', vRP)

tvRP = {}
Tunnel.bindInterface('vRP', tvRP)
vRPclient = Tunnel.getInterface('vRP')

local db_driver
local showIds = {}
local addPlayer = {}
local db_drivers = {}
local cached_queries = {}
local cached_prepares = {}
local db_initialized = false
local requireDiscord = true

function vRP.registerDBDriver(name, on_init, on_prepare, on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init, on_prepare, on_query }
		db_driver = db_drivers[name]
		db_initialized = true

		for _, prepare in pairs(cached_prepares) do
			on_prepare(table.unpack(prepare, 1, table.maxn(prepare)))
		end

		for _, query in pairs(cached_queries) do
			query[2](on_query(table.unpack(query[1], 1, table.maxn(query[1]))))
		end

		cached_prepares = nil
		cached_queries = nil
	end
end

function vRP.format(n)
	local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)', '%1.'):reverse())..right
end

function vRP.updateTxt(archive, text)
	archive = io.open('resources/logsystem/'..archive, 'a')
	if archive then
		archive:write(text..'\n')
	end
	archive:close()
end

function vRP.prepare(name, query)
	if db_initialized then
		db_driver[2](name, query)
	else
		table.insert(cached_prepares, { name, query })
	end
end

function vRP.query(name, params, mode)
	if not mode then mode = 'query' end

	if db_initialized then
		return db_driver[3](name, params or {}, mode)
	else
		local r = async()
		table.insert(cached_queries, {{ name, params or {}, mode }, r })
		return r:wait()
	end
end

function vRP.execute(name, params)
	return vRP.query(name, params, 'execute')
end

function vRP.isBanned(steam)
	local rows = vRP.getPlayer(steam)
	if rows[1] then
		return rows[1].banned
	end
end

function vRP.isWhitelisted(steam)
	local rows = vRP.getPlayer(steam)
	if rows[1] then
		return rows[1].whitelist
	end
end

function vRP.setUData(user_id, key, value)
	vRP.execute('vRP/set_user_data', { user_id = parseInt(user_id), key = key, value = value })
end

function vRP.getUData(user_id, key)
	local rows = vRP.query('vRP/get_user_data', { user_id = parseInt(user_id), key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ''
	end
end

function vRP.setSData(key, value)
	vRP.execute('vRP/set_server_data', { key = key, value = value })
end

function vRP.getSData(key)
	local rows = vRP.query('vRP/get_server_data', { key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ''
	end
end

function vRP.getUserDataTable(user_id)
	return vRP.user_tables[user_id]
end

function vRP.getInventory(user_id)
    local data = vRP.user_tables[user_id]
    if data then
        for k, v in pairs(data.inventory) do
            if v.item and v.timestamp then
                if v.timestamp <= os.time() then
                    v.item = vRP.itemTransformList(v.item) or v.item
					data.inventory[k] = {item = v.item, amount = v.amount}
                end
            end
        end
        return data.inventory
    end
    return false
end

function vRP.getWeapons(user_id)
    local data = vRP.user_tables[user_id]
    if data then
        for k, v in pairs(data.weapons) do
			data.inventory[k] = {ammo = v.ammo, ammoAmount = v.ammoAmount}
        end
        return data.weapons
    end
    return false
end

function vRP.tryGetAmmo(user_id)
	local data = vRP.user_tables[user_id]
	if data then
		if data.weapons and json.encode(data.weapons) ~= '{}' then
			for k, v in pairs(data.weapons) do
				vRP.tryGiveInventoryItem(user_id, v.ammo, v.ammoAmount)
				k = nil
			end
			return true
		end
		return false
	end
	return false
end

function vRP.updateSelectSkin(user_id, hash)
	local data = vRP.user_tables[user_id]
	if data then
		data.skin = hash
	end
end

function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end

function vRP.getUsers()
	local users = {}
	for k, v in pairs(vRP.user_sources) do
		users[k] = v
	end
	return users
end

function vRP.getUserSource(user_id)
	return vRP.user_sources[user_id]
end

AddEventHandler('playerDropped', function()
	vRP.rejoinServer(source)
	if addPlayer[source] then
		addPlayer[source] = nil
	end
	TriggerClientEvent('vRP:updateList', -1, addPlayer)
end)

function vRP.kick(user_id, reason)
	if vRP.user_sources[user_id] then
		local source = vRP.user_sources[user_id]
		vRP.rejoinServer(source)
		DropPlayer(source, reason)
	end
end

function vRP.rejoinServer(source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerEvent('vRP:playerLeave', user_id, source)
			vRP.setUData(user_id, 'Datatable', json.encode(vRP.user_tables[user_id]))
			vRP.users[identity.steam] = nil
			vRP.user_sources[user_id] = nil
			vRP.user_tables[user_id] = nil
			vRP.rusers[user_id] = nil
			showIds[source] = nil
			TriggerClientEvent('vRP:showIds', -1, showIds)
		end
	end
end

function vRP.clearInventory(user_id)
	vRP.user_tables[user_id].inventory = {}
	vRP.upgradeThirst(user_id, 100)
	vRP.upgradeHunger(user_id, 100)
	return true
end

function vRP.getSteam(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k, v in ipairs(identifiers) do
		if string.sub(v, 1, 5) == 'steam' then
			return v
		end
	end
end

function vRP.getDiscord(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v, 1, 7) == 'discord' then
			return v
		end
	end
end

AddEventHandler('queue:playerConnecting', function(source, ids, name, setKickReason, deferrals)
	deferrals.defer()
	local source = source
	local steam = vRP.getSteam(source)
	local discord = vRP.getDiscord(source)
	if steam then
		if requireDiscord then
			if discord then
				if not vRP.isBanned(steam) then
					if vRP.isWhitelisted(steam) then
						deferrals.done()
					else
						local newUser = vRP.getPlayer(steam)
						if newUser[1] == nil then
							vRP.execute('vRP/create_player', { steam = steam, discord = discord })
						end

						deferrals.done('Envie na sala liberação: '..steam)
						TriggerEvent('queue:playerConnectingRemoveQueues', ids)
					end
				else
					deferrals.done('Você foi banido da cidade.')
					TriggerEvent('queue:playerConnectingRemoveQueues', ids)
				end
			end
		else
			if not vRP.isBanned(steam) then
				if vRP.isWhitelisted(steam) then
					deferrals.done()
				else
					local newUser = vRP.getPlayer(steam)
					if newUser[1] == nil then
						vRP.execute('vRP/create_player_whitout_discord', { steam = steam })
					end

					deferrals.done('Envie na sala liberação: '..steam)
					TriggerEvent('queue:playerConnectingRemoveQueues', ids)
				end
			else
				deferrals.done('Você foi banido da cidade.')
				TriggerEvent('queue:playerConnectingRemoveQueues', ids)
			end
		end
	end
end)

RegisterServerEvent('vRP:playerSpawned')
AddEventHandler('vRP:playerSpawned', function()
	local source = source
	TriggerEvent('zMultiChar:setup', source)
	addPlayer[source] = true
	TriggerClientEvent('vRP:updateList', -1, addPlayer)
end)

RegisterServerEvent('baseModule:idLoaded')
AddEventHandler('baseModule:idLoaded', function(source, user_id, model)
	local source = source
	if vRP.rusers[user_id] == nil then
		local playerData = vRP.getUData(parseInt(user_id), 'Datatable')
		local resultData = json.decode(playerData) or {}

		vRP.user_tables[user_id] = resultData
		vRP.user_sources[user_id] = source

		if model ~= nil then
			vRP.user_tables[user_id].weapons = {}
			vRP.user_tables[user_id].inventory = {}
			vRP.user_tables[user_id].skin = GetHashKey(model)
			vRP.user_tables[user_id].inventory['1'] = { item = 'celular', amount = 1 }
			vRP.user_tables[user_id].inventory['2'] = { item = 'identidade', amount = 1 }
			vRP.user_tables[user_id].inventory['3'] = { item = 'agua', amount = 2 }
			vRP.user_tables[user_id].inventory['4'] = { item = 'sanduiche', amount = 2 }
			vRP.user_tables[user_id].inventory['5'] = { item = 'dinheiro', amount = 2000 }
			vRP.user_tables[user_id].health = 400
		end

		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.users[identity.steam] = user_id
			vRP.rusers[user_id] = identity.steam
		end

		showIds[source] = user_id
		TriggerClientEvent('vRP:showIds', -1, showIds)

		local registration = vRP.getUserRegistration(user_id)
		if registration == nil then
			vRP.execute('vRP/update_user', {user_id = parseInt(user_id), registration = vRP.generateRegistrationNumber(), phone = vRP.generatePhoneNumber()})
		end
		
		TriggerEvent('vRP:playerSpawn', user_id, source)
	end
end)

AddEventHandler('vRP:playerSpawn', function(user_id, source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.setUData(user_id, 'Datatable', json.encode(vRP.user_tables[user_id]))
			TriggerClientEvent('vRP:showIds', -1, showIds)
		end
	end
end)