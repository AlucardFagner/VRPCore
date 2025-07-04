local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

zSERVER = {}
Tunnel.bindInterface("zMilkman",zSERVER)

local quantidade = {}
local amount = {}

function zSERVER.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.computeInvWeight(user_id)+vRP.itemWeightList("garrafa-leite")*3 <= vRP.getBackpackWeight(user_id) then
			if vRP.tryGetInventoryItem(user_id,config.milk,config.milk1) then
				vRP.giveInventoryItem(user_id,config.milk2,config.milk3)
				return true
			end
		end
	end
end

function zSERVER.setWork()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id, "milkman") then
			vRP.insertPermission(user_id, "milkman")
			return
		else
			vRP.removePermission(user_id, "milkman")
			return
		end
	end
	return false
end

function zSERVER.startPayments()
	local source = source

	if amount[source] == nil then
		amount[source] = parseInt(math.random(config.deliveryss[1],config.deliveryss[2]))
	end

	local user_id = vRP.getUserId(source)
	if user_id then

		if vRP.tryGetInventoryItem(user_id,config.milkman1,amount[source]) then
			local pagamento = parseInt(math.random(config.milkman2[1],config.milkman2[2]))
			vRP.tryGiveInventoryItem(user_id,"dinheiro",parseInt(pagamento+amount[source]))
			TriggerClientEvent("zSounds:source",source,'coin',0.2)
			TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(pagamento+amount[source])).." dólares</b>.",8000)

			amount[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount[source].."x Garrafas de Leite</b>.",8000)
		end
	end
	return false
end

function zSERVER.checkPlate(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	local veh,vhash,vplaca,vname = vRPclient.vehListHash(source,4)
	if veh and vhash == modelo then
		local placa_user_id = GetHashKey("youga2")
		if user_id == placa_user_id then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você <b>precisa usar o carro</b> de serviço.",10000)
			return false
		end
	end
end