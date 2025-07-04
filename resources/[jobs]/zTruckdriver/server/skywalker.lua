local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface("zTruckdriver",zSERVER)

function zSERVER.checkPaymentGas()
	local source = source
	local user_id = vRP.getUserId(source)
	local pay = math.random(config.PayMinGas, config.PayMaxGas)
	if user_id then
		vRP.giveInventoryItem(user_id, 'dinheiro', pay)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("zSounds:source",source,'coin',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(pay).." dólares</b>.",8000)
		return true
	end
	return false
end

function zSERVER.checkPaymentWood()
	local source = source
	local user_id = vRP.getUserId(source)
	local pay = math.random(config.PayMinWood, config.PayMaxWood)
	if user_id then
		vRP.giveDinheirama(user_id,pay)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("zSounds:source",source,'coin',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(pay).." dólares</b>.",8000)
		return true
	end
	return false
end

function zSERVER.setWork()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id, "truckdriver") then
			vRP.insertPermission(user_id, "truckdriver")
			return
		else
			vRP.removePermission(user_id, "truckdriver")
			return
		end
	end
	return false
end