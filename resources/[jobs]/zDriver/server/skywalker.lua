local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
server = {}
Tunnel.bindInterface("zDriver",server)
client = Tunnel.getInterface("zDriver")

function server.paymentMethod(status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = math.random(config.PaymentMin,config.PaymentMax)
		if not status then
			vRP.tryGiveInventoryItem(user_id,config.PaymentItem,parseInt(value),true)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..value.. " pelo trajeto",18000)
			TriggerClientEvent("zSounds:source",source,"coin",0.5)
		else
			vRP.tryGiveInventoryItem(user_id,config.PaymentItem,parseInt(value),true)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..value.. " pelo trajeto",18000)
			TriggerClientEvent("zSounds:source",source,"coin",0.5)
		end
	end
end