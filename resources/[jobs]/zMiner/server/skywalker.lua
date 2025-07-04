local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zMiner',zSERVER)

local ammount = {}
local percentage = 0
local itemName = ''

function zSERVER.ammount()
	local source = source
	if ammount[source] == nil then
		ammount[source] = parseInt(math.random(config.miner[1],config.miner[2]))
	end
end

function zSERVER.checkWeight()
	zSERVER.ammount()

	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		percentage = math.random(100)
		if percentage <= 58 then
			itemName = config.ferro
		elseif percentage >= 59 and percentage <= 79 then
			itemName = config.prata
		elseif percentage >= 80 and percentage <= 90 then
			itemName = config.ouro
		elseif percentage >= 91 then
			itemName = config.diamante
		end
		return vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * parseInt(ammount[source]) <= vRP.getBackpackWeight(user_id) and vRP.tryGetInventoryItem(user_id,config.stone,config.ammountstone)
	end
end

function zSERVER.collectOres()
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		vRP.tryGiveInventoryItem(user_id, itemName, ammount[source])
		ammount[source] = nil
	end
end

--[[function zSERVER.checkPlate(modelo)
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

function zSERVER.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(vRP.checkCrimeRecord(user_id)) > 0 then
			TriggerClientEvent('Notify',source,'negado','Não contratamos pessoas com <b>Ficha Criminal</b>.',10000)
			return false
		else
			return true
		end
	end
end]]