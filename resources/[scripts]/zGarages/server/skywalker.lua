local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zGarages', zSERVER)
zCLIENT = Tunnel.getInterface('zGarages')

local idgens = Tools.newIDGenerator()

local police = {}
local vehlist = {}
local trydoors = {}

trydoors['CLONADOS'] = true
trydoors['CREATIVE'] = true

RegisterCommand('dv', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if vRP.hasPermission(user_id, 'gerente') or vRP.hasPermission(user_id, 'manager') or vRP.hasPermission(user_id, 'administrador') or vRP.hasPermission(user_id, 'moderador') then
		local vehicle = vRPclient.getNearVehicle(source, 7)
		if vehicle then
			zCLIENT.deleteVehicle(source, vehicle)
		end
	end
end)

RegisterCommand('veh', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] and args[2] and parseInt(args[3]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[3]))
			local myvehicles = vRP.query('vRP/get_vehicles', { plate = tostring(args[2]), vehicle = tostring(args[1]) })
			if myvehicles[1] then
				if vRP.vehicleType(tostring(args[1])) == 'import' or vRP.vehicleType(tostring(args[1])) == 'rental' and not vRP.hasPermission(user_id, 'gerente') then
					TriggerClientEvent('Notify', source, 'negado', '<b>'..vRP.vehicleName(tostring(args[1]))..'</b> não pode ser transferido por ser um veículo <b>Exclusivo ou Alugado</b>.', 10000)
				else
					local identity = vRP.getUserIdentity(parseInt(args[3]))
					local identity2 = vRP.getUserIdentity(user_id)
					local price = tonumber(sanitizeString(vRP.prompt(source, 'Valor:', ''), '\'[]{}+=?!_()#@%/\\|, .', false))
					if vRP.request(source, 'Deseja vender um <b>'..vRP.vehicleName(tostring(args[1]))..'</b> para <b>'..identity.name..' '..identity.firstname..'</b> por <b>$'..vRP.format(parseInt(price))..'</b> dólares ?', 30) then
						if vRP.request(nplayer, 'Aceita comprar um <b>'..vRP.vehicleName(tostring(args[1]))..'</b> de <b>'..identity2.name..' '..identity2.firstname..'</b> por <b>$'..vRP.format(parseInt(price))..'</b> dólares ?', 30) then
							if parseInt(price) > 0 then
								if vRP.tryPayment(parseInt(args[3]), parseInt(price)) then
									vRP.execute('vRP/move_vehicle', { user_id = parseInt(user_id), nuser_id = parseInt(args[3]), vehicle = tostring(args[1]) })

									local custom = vRP.getSData('custom:u'..parseInt(user_id)..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate)
									local custom2 = json.decode(custom)
									if custom2 then
										vRP.setSData('custom:u'..parseInt(args[3])..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate, json.encode(custom2))
										vRP.execute('vRP/rem_server_data', { dkey = 'custom:u'..parseInt(user_id)..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate })
									end

									local chest = vRP.getSData('chest:u'..parseInt(user_id)..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate)
									local chest2 = json.decode(chest)
									if chest2 then
										vRP.setSData('chest:u'..parseInt(args[3])..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate, json.encode(chest2))
										vRP.execute('vRP/rem_server_data', { dkey = 'chest:u'..parseInt(user_id)..'veh_'..tostring(args[1])..'_'..myvehicles[1].plate })
									end

									TriggerClientEvent('Notify', source, 'sucesso', 'Você Vendeu <b>'..vRP.vehicleName(tostring(args[1]))..'</b> e Recebeu <b>$'..vRP.format(parseInt(price))..'</b> dólares.', 20000)
									TriggerClientEvent('Notify', nplayer, 'importante', 'Você recebeu as chaves do veículo <b>'..vRP.vehicleName(tostring(args[1]))..'</b> de <b>'..identity2.name..' '..identity2.firstname..'</b> e pagou <b>$'..vRP.format(parseInt(price))..'</b> dólares.', 40000)
									vRPclient.playSound(source, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS')
									vRPclient.playSound(nplayer, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS')
									vRP.addBank(user_id, parseInt(price))
								else
									TriggerClientEvent('Notify', nplayer, 'negado', 'Dinheiro insuficiente.', 8000)
									TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 8000)
								end	
							end
						end
					end
				end
			else
				TriggerClientEvent('Notify', source, 'importante', 'Dados invalidos ou veículo inexistente!', 20000)
			end
		end
	end
end)

function zSERVER.getGaragesList()
	return config.garages
end

function zSERVER.checkGarage(name, garage)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local address = vRP.query('vRP/get_home_by_id', { user_id = parseInt(user_id) })
		if #address > 0 then
			for k, v in pairs(address) do
				if v.home == config.garages[garage].name then
					if parseInt(v.garage) == 1 then
						local resultOwner = vRP.query('vRP/get_home_owner_by_id', { home = tostring(name) })
						if resultOwner[1] then
							if parseInt(os.time()) >= parseInt(resultOwner[1].tax + 24 * 15 * 60 * 60) then
								TriggerClientEvent('Notify', source, 'aviso', 'A <b>Property Tax</b> da residência está atrasada.', 10000)
								return false
							else
								zCLIENT.openGarage(source, name, garage)
							end
						end
					end
				end
			end
		end
		if config.garages[garage].public then
			return zCLIENT.openGarage(source, name, garage)
		else
			if vRP.hasPermission(user_id, config.garages[garage].permission) then
				return zCLIENT.openGarage(source, name, garage)
			end
		end
		return false
	end
end

function zSERVER.myVehicles(garage, id)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local myvehicles = {}
	local tax = ''
	local status = ''
	if user_id then
		if config.garages[id].work then
			for k, v in pairs(config.garages[id].vehicles) do
				status = '<span class=\'green\'>'..k..'</span>'
				tax = '<span class=\'green\'>Paga</span>'
				table.insert(myvehicles, { index = v, name = vRP.vehicleName(v), plate = identity.registration, engine = 100, body = 100, fuel = 100, status = status, tax = tax })
			end
			return myvehicles
		else
			local vehicle = vRP.query('vRP/get_vehicle', { user_id = parseInt(user_id) })
			local address = vRP.query('vRP/get_home_by_id', { user_id = parseInt(user_id) })
			if #address > 0 then
				for a, b in pairs(address) do
					if b.home == garage then
						for c, d in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[c].arrested_time + 24 * 60 * 60) then
								status = '<span class=\'red\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[c].vehicle) * 0.5))..'</span>'
							elseif vehicle[c].arrested == 1 then
								status = '<span class=\'orange\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[c].vehicle) * 0.1))..'</span>'
							else
								status = '<span class=\'green\'>Gratuita</span>'
							end

							if parseInt(os.time()) >= parseInt(vehicle[c].tax + 24 * 15  * 60 * 60) then
								tax = '<span class=\'atrasado\'> Atrasada</span>'
							else
								tax = '<span class=\'emdia\'> Paga</span>'
							end
							table.insert(myvehicles, { index = vehicle[c].vehicle, name = vRP.vehicleName(vehicle[c].vehicle), plate = vehicle[c].plate, engine = parseInt(vehicle[c].engine*0.1), body = parseInt(vehicle[c].body*0.1), fuel = parseInt(vehicle[c].fuel), status = status, tax = tax })
						end
						return myvehicles
					else
						for c, d in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[c].arrested_time + 24 * 60 * 60) then
								status = '<span class=\'red\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[c].vehicle)*0.5))..'</span>'
							elseif vehicle[c].arrested == 1 then
								status = '<span class=\'orange\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[c].vehicle)*0.1))..'</span>'
							else
								status = '<span class=\'green\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[c].vehicle)*0.10))..'</span>'
							end

							if parseInt(os.time()) >= parseInt(vehicle[c].tax+24*15*60*60) then
								tax = '<span class=\'atrasado\'> Atrasada</span>'
							else
								tax = '<span class=\'emdia\'> Paga</span>'
							end
							table.insert(myvehicles, { index = vehicle[c].vehicle, name = vRP.vehicleName(vehicle[c].vehicle), plate = vehicle[c].plate, engine = parseInt(vehicle[c].engine*0.1), body = parseInt(vehicle[c].body*0.1), fuel = parseInt(vehicle[c].fuel), status = status, tax = tax })
						end
						return myvehicles
					end
				end
			else
				for k, v in pairs(vehicle) do
					if parseInt(os.time()) <= parseInt(vehicle[k].arrested_time + 24 * 60 * 60) then
						status = '<span class=\'red\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.5))..'</span>'
					elseif vehicle[k].arrested == 1 then
						status = '<span class=\'orange\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.1))..'</span>'
					else
						status = '<span class=\'green\'>$'..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.10))..'</span>'
					end

					if parseInt(os.time()) >= parseInt(vehicle[k].tax + 24 * 15 * 60 * 60) then
						tax = '<span class=\'atrasado\'> Atrasada</span>'
					else
						tax = '<span class=\'emdia\'> Paga</span>'
					end
					table.insert(myvehicles, { index = vehicle[k].vehicle, name = vRP.vehicleName(vehicle[k].vehicle), plate = vehicle[k].plate, engine = parseInt(vehicle[k].engine*0.1), body = parseInt(vehicle[k].body*0.1), fuel = parseInt(vehicle[k].fuel), status = status, tax = tax })
				end
				return myvehicles
			end
		end
	end
end

function zSERVER.spawnVehicles(name, plate, use)
	if name then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			local identity = vRP.getUserIdentity(user_id)
			local value = vRP.getUData(parseInt(user_id), 'vRP:multas')
			local multas = json.decode(value) or 0
			
			if multas >= 10000 then
				TriggerClientEvent('Notify', source, 'negado', 'Você tem multas pendentes.', 10000)
				return true
			end

			if not zCLIENT.returnVehicle(source, plate) then
				local vehicle = vRP.query('vRP/get_vehicles', { plate = plate, vehicle = name })
				local tuning = vRP.getSData('custom:u'..user_id..'veh_'..name.."_placa_"..plate) or {}
				local custom = json.decode(tuning) or {}
				if vehicle[1] ~= nil then
					if parseInt(os.time()) <= parseInt(vehicle[1].arrested_time+24*60*60) then
						local ok = vRP.request(source, 'Veículo na retenção, deseja acionar o seguro pagando <b>$'..vRP.format(parseInt(vRP.vehiclePrice(name)*0.5))..'</b> dólares ?', 60)
						if ok then
							if vRP.tryPayment(user_id, parseInt(vRP.vehiclePrice(name)*0.5)) then
								vRP.execute('vRP/set_detido', { plate = plate, vehicle = name, arrested = 0, arrested_time = 0 })
								TriggerClientEvent('Notify', source, 'sucesso', 'Veículo liberado.', 10000)
							else
								TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 10000)
							end
						end
					elseif parseInt(vehicle[1].arrested) >= 1 then
						local ok = vRP.request(source, 'Veículo na detenção, deseja acionar o seguro pagando <b>$'..vRP.format(parseInt(vRP.vehiclePrice(name)*0.1))..'</b> dólares ?', 60)
						if ok then
							if vRP.tryPayment(user_id, parseInt(vRP.vehiclePrice(name)*0.1)) then
								vRP.execute('vRP/set_detido', { plate = plate, vehicle = name, arrested = 0, arrested_time = 0 })
								TriggerClientEvent('Notify', source, 'sucesso', 'Veículo liberado.', 10000)
							else
								TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 10000)
							end
						end
					else
						if parseInt(os.time()) <= parseInt(vehicle[1].tax + 24 * 15 * 60 * 60) then
							if config.garages[use].tax then
								if vRP.tryPayment(user_id, parseInt(vRP.vehiclePrice(name)*0.005)) then										
									local spawnveh, vehid = zCLIENT.spawnVehicle(source, name, vehicle[1].plate, vehicle[1].engine, vehicle[1].body, vehicle[1].fuel, custom, parseInt(vehicle[1].colorR), parseInt(vehicle[1].colorG), parseInt(vehicle[1].colorB), parseInt(vehicle[1].color2R), parseInt(vehicle[1].color2G), parseInt(vehicle[1].color2B), false)
									if spawnveh then
										vehlist[vehid] = { parseInt(user_id), name }
										TriggerEvent('setPlateEveryone', vehicle[1].plate)
									end
								else
									TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 10000)
								end
							else
								local spawnveh, vehid = zCLIENT.spawnVehicle(source, name, vehicle[1].plate, vehicle[1].engine, vehicle[1].body, vehicle[1].fuel, custom, parseInt(vehicle[1].colorR), parseInt(vehicle[1].colorG), parseInt(vehicle[1].colorB), parseInt(vehicle[1].color2R), parseInt(vehicle[1].color2G), parseInt(vehicle[1].color2B), false)
								if spawnveh then
									vehlist[vehid] = { user_id, name }
									TriggerEvent('setPlateEveryone', vehicle[1].plate)
								end
							end
						else
							local price_tax = parseInt(vRP.vehiclePrice(name)*0.10)
							if price_tax > 100000 then
								price_tax = 100000
							end
							local ok = vRP.request(source, 'Deseja pagar o <b>Vehicle Tax</b> do veículo <b>'..vRP.vehicleName(name)..'</b> por <b>$'..vRP.format(price_tax)..'</b> dólares?', 60)
							if ok then
								if vRP.tryPayment(user_id, price_tax) then
									vRP.execute('vRP/set_tax', { plate = plate, vehicle = name, tax = parseInt(os.time()) })
									TriggerClientEvent('Notify', source, 'sucesso', 'Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.', 10000)
								else
									TriggerClientEvent('Notify', source, 'negado', 'Dinheiro insuficiente.', 10000)
								end
							end
						end
					end
				else
					local spawnveh, vehid = zCLIENT.spawnVehicle(source, name, identity.registration, 1000, 1000, 100, custom, 0, 0, 0, 0, 0, 0, true)
					if spawnveh then
						vehlist[vehid] = { user_id, name }
						TriggerEvent('setPlateEveryone', identity.registration)
					end
				end
			else
				TriggerClientEvent('Notify', source, 'aviso', 'Já possui um veículo deste modelo fora da garagem.', 10000)
			end
		end
	end
end

function zSERVER.returnVehicleEveryone(placa)
	return trydoors[placa]
end

function zSERVER.deleteVehicles()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRPclient.getNearVehicle(source, 30)
		if vehicle then
			zCLIENT.deleteVehicle(source, vehicle)
		end
	end
end

function zSERVER.plateUser(vehicle)
	local user_id = vRP.getUserId(source)
	local plateCar = vRP.query('vRP/get_plateUser', {user_id = user_id, vehicle = vehicle})
	for k, v in pairs(plateCar) do 
		return v.plate
	end
end

function zSERVER.plateCheck(vehicle, plate)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local vehicle = vRP.query('vRP/get_vehicles_by_id', { user_id = user_id, vehicle = vehicle })
	if vehicle[1] ~= nil then
		for k, v in pairs(vehicle) do
			if v.plate == plate then
				return true
			end
		end
		return false
	else
		if identity.registration == plate then
			return true
		end
		return false
	end
	return false
end

function zSERVER.vehicleLock()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle, vehNet, vehPlate, vehName, vehLock = vRPclient.vehList(source, 11)
		if vehicle and vehPlate then
			vehPlate = string.gsub(vehPlate, " ", "")
			local plateOk = zSERVER.plateCheck(vehName, vehPlate)
			if plateOk then
				zCLIENT.vehicleClientLock(-1, vehNet, vehLock)
				TriggerClientEvent('zSounds:source', source, 'lock', 0.5)
				vRPclient.playAnim(source, true, {'anim@mp_player_intmenu@key_fob@', 'fob_click'}, false)
				if vehLock == 1 then
					TriggerClientEvent('Notify', source, 'importante', 'Veículo <b>destrancado</b> com sucesso.', 8000)
				else
					TriggerClientEvent('Notify', source, 'importante', 'Veículo <b>trancado</b> com sucesso.', 8000)
				end
			end
		end
	end
end

function zSERVER.tryDelete(vehid, vehplate, vehengine, vehbody, vehfuel)
	if vehlist[vehid] and vehid ~= 0 then
		local user_id = vehlist[vehid][1]
		local vehname = vehlist[vehid][2]
		local player = vRP.getUserSource(user_id)
		vehplate = string.gsub(vehplate, " ", "")
		if player then
			zCLIENT.syncNameDelete(player, vehplate)
		end

		if vehengine <= 100 then
			vehengine = 100
		end

		if vehbody <= 100 then
			vehbody = 100
		end

		if vehfuel >= 100 then
			vehfuel = 100
		end

		local vehicle = vRP.query('vRP/get_vehicles', { plate = vehplate, vehicle = vehname })
		if vehicle[1] ~= nil then
			vRP.execute('vRP/set_update_vehicles', { plate = vehplate, vehicle = vehname, engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel) })
		end
	end
	zCLIENT.syncVehicle(-1, vehid)
end

function zSERVER.policeAlert()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
		if vehicle then
			if math.random(100) >= 50 then
				local policia = vRP.getUsersByPermission('policia.permissao')
				local x, y, z = vRPclient.getPosition(source)
				for k, v in pairs(policia) do
					local player = vRP.getUserSource(parseInt(v))
					if player then
						async(function()
							local id = idgens:gen()
							TriggerClientEvent('chatMessage', player, '911', {64, 64, 255}, 'Roubo na ^1'..street..'^0 do veículo ^1'..model..'^0 de placa ^1'..placa..'^0 verifique o ocorrido.')
							police[id] = vRPclient.addBlip(player, x, y, z, 304, 3, 'Ocorrência', 0.6, false)
							SetTimeout(60000, function() vRPclient.removeBlip(player, police[id]) idgens:free(id) end)
						end)
					end
				end
			end
		end
	end
end

function zSERVER.CheckLiveryPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id, 'gerente') 
end

RegisterServerEvent('setPlateEveryone')
AddEventHandler('setPlateEveryone', function(placa)
	trydoors[placa] = true
end)

RegisterServerEvent('desmancheVehicles62')
AddEventHandler('desmancheVehicles62', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				vRP.execute('vRP/set_detido', { user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })
				vRP.giveInventoryItem(user_id, 'dinheirosujo', parseInt(vRP.vehiclePrice(vname)*0.1))
				zCLIENT.deleteVehicle(source, vehicle)
				local identity = vRP.getUserIdentity(user_id)
			end
		end
	end
end)

RegisterServerEvent('trydeleteveh')
AddEventHandler('trydeleteveh', function(vehid)
	zCLIENT.syncVehicle(-1, vehid)
end)

RegisterServerEvent('trylimpar')
AddEventHandler('trylimpar', function(nveh)
	TriggerClientEvent('synclimpar', -1, nveh)
end)

RegisterServerEvent('tryreparar')
AddEventHandler('tryreparar', function(nveh)
	TriggerClientEvent('syncreparar', -1, nveh)
end)

RegisterServerEvent('trymotor')
AddEventHandler('trymotor', function(nveh)
	TriggerClientEvent('syncmotor', -1, nveh)
end)