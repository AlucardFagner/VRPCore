local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

zSERVER = {}
Tunnel.bindInterface("zPostman",zSERVER)

local ammount = {}

function zSERVER.checkWeight()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.computeInvWeight(user_id)+vRP.itemWeightList("encomenda")*3 <= vRP.getBackpackWeight(user_id) and vRP.tryGetInventoryItem(user_id,config.boxpostman,config.ammountpostman) and TriggerClientEvent("itensNotify",source,"usar","Usou","caixa-vazia") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia ou <b>itens insuficientes</b> para o trabalho.",10000)
			return false
		end
	end
end

function zSERVER.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
			return true
	end
end

function zSERVER.giveOrders()
	local source = source
	local user_id = vRP.getUserId(source)

	vRP.tryGiveInventoryItem(user_id,config.orderpostman,config.ammoutorder)
	TriggerClientEvent("Notify",source,"sucesso","Suas caixas foram empacotadas.")
end

function zSERVER.startPayments()
	local source = source
	local user_id = vRP.getUserId(source)
	if ammount[source] == nil then
		ammount[source] = parseInt(math.random(config.postmandelivery[1],config.postmandelivery[2]))
	end
	if user_id then
		if vRP.tryGetInventoryItem(user_id,config.postmanitem,ammount[source]) then
			local price = parseInt(math.random(config.postmanpayment[1],config.postmanpayment[2]))
			vRP.tryGiveInventoryItem(user_id,'dinheiro',parseInt(price+ammount[source]))
			vRP.upgradeStress(user_id,1)
			TriggerClientEvent("zSounds:source",source,"coin",0.5)
			TriggerClientEvent("Notify",source,"sucesso","Você entregou <b>x"..ammount[source].." encomendas</b>, recebendo <b>$"..vRP.format(parseInt(price+ammount[source])).." dólares</b>.",8000)
			ammount[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..ammount[source].."x Encomendas</b>.",8000)
		end
	end
end

function zSERVER.checkPlate(modelo)
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

function zSERVER.setWork()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id, "postman") then
			vRP.insertPermission(user_id, "postman")
			return
		else
			vRP.removePermission(user_id, "postman")
			return
		end
	end
	return false
end