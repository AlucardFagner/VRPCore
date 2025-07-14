local Config = {
	RequireDiscord = false,
	RequireSteam = false,
	Language = {
		joining = 'Entrando...',
		connecting = 'Conectando...',
		err = 'Não foi possível identificar sua Steam ou Social Club.',
		_err = 'Você foi desconectado por demorar demais na fila.',
		pos = 'Você é o %d/%d da fila, aguarde sua conexão',
		connectingerr = 'Não foi possível adicioná-lo na fila.',
		steam = 'Você precisa estar com a Steam aberta para conectar.',
		discord = 'Você precisa estar com o Discord aberto e conectado ao FiveM'
	}
}

local Queue = {
	QueueList = {},
	PlayerList = {},
	PlayerCount = 0,
	Priority = {},
	Connecting = {},
	ThreadCount = 0,
	MaxPlayers = 10,
	PriorityUsers = {}
}

-- UTILITÁRIOS
function Queue:GetIds(src)
	local ids = GetPlayerIdentifiers(src)
	local ip = GetPlayerEndpoint(src)
	ids = (ids and ids[1]) and ids or (ip and {'ip:' .. ip} or false)
	if ids and #ids > 1 then
		for k, v in ipairs(ids) do
			if string.sub(v, 1, 3) == 'ip:' then table.remove(ids, k) end
		end
	end
	return ids
end

function Queue:IsSteamRunning(src)
	for _, id in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(id, 1, 5) == 'steam' then return true end
	end
	return false
end

function Queue:IsDiscordRunning(src)
	for _, id in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(id, 1, 7) == 'discord' then return true end
	end
	return false
end

-- PRIORIDADE
function Queue:LoadPriority()
	Queue.PriorityUsers = {}
	local pList = vRP.query('vRP/get_priority')
	for _, user in ipairs(pList) do
		Queue.PriorityUsers[user.steam] = user.priority
	end
	print('Priority Users Loaded:', #pList)
end

function Queue:IsPriority(ids)
	Queue:LoadPriority()
	for _, id in ipairs(ids) do
		id = string.lower(id)
		if string.sub(id, 1, 5) == 'steam' and not Queue.PriorityUsers[id] then
			local sid = Queue:HexIdToSteamId(id)
			if Queue.PriorityUsers[sid] then return Queue.PriorityUsers[sid] end
		end
		if Queue.PriorityUsers[id] then return Queue.PriorityUsers[id] end
	end
	return false
end

function Queue:HexIdToSteamId(hexId)
	local cid = parseInt(string.sub(hexId, 7), 16)
	local steam64 = parseInt(string.sub(cid, 2))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	return ('steam_0:%d:%d'):format(a, a == 1 and b - 1 or b)
end

-- FUNÇÕES DE FILA
function Queue:IsInQueue(ids)
	for i, player in ipairs(Queue.QueueList) do
		for _, pid in ipairs(player.ids) do
			for _, id in ipairs(ids) do
				if pid == id then return true, i, player end
			end
		end
	end
	return false
end

function Queue:AddToQueue(ids, name, src, deferrals)
	if Queue:IsInQueue(ids) then return end
	local priority = Queue:IsPriority(ids) or 0
	table.insert(Queue.QueueList, {
		source = src, ids = ids, name = name,
		priority = priority, deferrals = deferrals,
		timeout = 0, firstconnect = os.time()
	})
end

function Queue:RemoveFromQueue(src)
	for i, player in ipairs(Queue.QueueList) do
		if player.source == src then table.remove(Queue.QueueList, i) break end
	end
end

function Queue:AddToConnecting(ids, playerData)
	if #Queue.Connecting >= 10 then return false end
	table.insert(Queue.Connecting, playerData)
	Queue:RemoveFromQueue(playerData.source)
	return true
end

function Queue:RemoveFromConnecting(src)
	for i, conn in ipairs(Queue.Connecting) do
		if conn.source == src then table.remove(Queue.Connecting, i) break end
	end
end

-- CONEXÃO DE PLAYER
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	local src = source
	local ids = Queue:GetIds(src)
	if not ids then deferrals.done(Config.Language.err) CancelEvent() return end

	deferrals.defer()
	deferrals.update(Config.Language.connecting)
	Citizen.Wait(1000)

	if Config.RequireSteam and not Queue:IsSteamRunning(src) then
		deferrals.done(Config.Language.steam)
		CancelEvent()
		return
	end

	if Config.RequireDiscord and not Queue:IsDiscordRunning(src) then
		deferrals.done(Config.Language.discord)
		CancelEvent()
		return
	end

	Queue:AddToQueue(ids, name, src, deferrals)
	local _, pos, data = Queue:IsInQueue(ids)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			pos = select(2, Queue:IsInQueue(ids))
			if pos == 1 and (#Queue.Connecting < 10) then
				if Queue:AddToConnecting(ids, data) then
					deferrals.update('Carregando...')
					Citizen.Wait(1000)
					deferrals.done()
					TriggerEvent('queue:playerConnecting', src, ids, name, setKickReason, deferrals)
					return
				else
					deferrals.done(Config.Language.connectingerr)
					return
				end
			else
				deferrals.update(string.format(Config.Language.pos, pos or 0, #Queue.QueueList))
			end
		end
	end)
end)

-- ATIVAÇÃO / DESCONEXÃO
AddEventHandler('Queue:playerActivated', function()
	local src = source
	if not Queue.PlayerList[src] then
		Queue.PlayerCount = Queue.PlayerCount + 1
		Queue.PlayerList[src] = true
		Queue:RemoveFromConnecting(src)
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
	if Queue.PlayerList[src] then
		Queue.PlayerCount = Queue.PlayerCount - 1
		Queue.PlayerList[src] = nil
		Queue:RemoveFromQueue(src)
		Queue:RemoveFromConnecting(src)
	end
end)

return Queue
