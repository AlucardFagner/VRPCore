local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

server = {}
Tunnel.bindInterface('zGarbargeman',server)

function server.payment()
    local source = source
    local user_id = vRP.getUserId(source)
    local pagamento = math.random(config.payment[1],config.payment[2])

    if user_id then
        vRP.tryGiveInventoryItem(user_id, 'dinheiro', pagamento)
        TriggerClientEvent('Notify',source,'sucesso','<b>Lixo coletado!</b> | Ganhos: <b>$'..pagamento..' dólares</b>.',9000)
    end
end

function server.checkPlate(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	local veh,vhash,vplaca,vname = vRPclient.vehListHash(source,4)
	if veh and vhash == modelo then
		local placa_user_id = vRP.getUserByRegistration(vplaca)
		if user_id == placa_user_id then
			return true
		end
	end
end

function server.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.checkCrimeRecord(user_id) > 0 then
			TriggerClientEvent('Notify',source,'negado','Não contratamos pessoas com <b>Ficha Criminal</b>.',10000)
			return false
		else
			return true
		end
	end
end
