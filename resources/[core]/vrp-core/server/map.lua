local wanted = {}
local repose = {}

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(wanted) do
			if wanted[k] > 0 then
				wanted[k] = v - 1
				if wanted[k] <= 0 then
					wanted[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(repose) do
			if repose[k] > 0 then
				repose[k] = v - 1
				if repose[k] <= 0 then
					repose[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)

function vRP.getInformation(user_id)
	return vRP.query('vRP/get_user', { user_id = parseInt(user_id) })
end

function vRP.wantedReturn(user_id)
	if wanted[user_id] ~= nil then
		TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'azul', 'Aguarde '..vRP.getTimers(wanted[user_id])..'.', 5000)
		return true
	else
		return false
	end
end

function vRP.reposeReturn(user_id)
	if repose[user_id] ~= nil then
		TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'azul', 'Aguarde '..vRP.getTimers(repose[user_id])..'.', 5000)
		return true
	else
		return false
	end
end

function vRP.wantedTimer(user_id, timer)
	if wanted[user_id] ~= nil then
		wanted[user_id] = wanted[user_id] + timer
	else
		wanted[user_id] = timer
	end
end

function vRP.reposeTimer(user_id, timer)
	if repose[user_id] ~= nil then
		repose[user_id] = repose[user_id] + timer * 60
	else
		repose[user_id] = timer * 60
	end
end

RegisterCommand('procurado', function(source, args, rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if wanted[user_id] ~= nil then
			TriggerClientEvent('Notify', source, 'azul', 'Aguarde '..vRP.getTimers(wanted[user_id])..'.', 5000)
		end
	end
end)

RegisterCommand('repouso', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if repose[user_id] ~= nil then
			TriggerClientEvent('Notify', source, 'azul', 'Aguarde '..vRP.getTimers(repose[user_id])..'.', 5000)
		end
	end
end)

function vRP.getUser(user_id)
	return vRP.query('vRP/get_user', { user_id = parseInt(user_id) })
end

function vRP.getPlayer(steam)
	return vRP.query('vRP/get_player', { steam = steam })
end

function vRP.getTimers(seconds)
	local days = math.floor(seconds/86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds/3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format('<b>%d Dias</b>, <b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>', days, hours, minutes, seconds)
	elseif hours > 0 then
		return string.format('<b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>', hours, minutes, seconds)
	elseif minutes > 0 then
		return string.format('<b>%d Minutos</b> e <b>%d Segundos</b>', minutes, seconds)
	elseif seconds > 0 then
		return string.format('<b>%d Segundos</b>', seconds)
	end
end

function vRP.getTimersMinimal(seconds)
	local days = math.floor(seconds/86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds/3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format('<b>%d D</b>, <b>%d H</b>, <b>%d M</b>', days, hours, minutes)
	elseif hours > 0 then
		return string.format('<b>%d H</b>, <b>%d M</b>', hours, minutes)
	elseif minutes > 0 then
		return string.format('<b>%d Minutos</b>', minutes)
	elseif seconds > 0 then
		return string.format('<b>%d Segundos</b>', seconds)
	end
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	if not first_spawn then
		for k, v in pairs(blips.list) do
			vRPclient.addBlips(source, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
		end
	end
end)