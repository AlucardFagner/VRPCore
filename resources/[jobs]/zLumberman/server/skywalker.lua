local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
server = {}
Tunnel.bindInterface("zLumberman",server)
client = Tunnel.getInterface("zLumberman")

config.Collect = {}
local amount = {}

function server.amountCollect()
	local source = source
	if config.Collect[source] == nil then
		config.Collect[source] = math.random(config.CollectMin,config.CollectMax)
	end
end

function server.amountService()
	local source = source
	if amount[source] == nil then
		amount[source] = math.random(config.ConsumeMin,config.ConsumeMax)
	end
end

function server.collectMethod()
	server.amountCollect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGiveInventoryItem(user_id, config.ConsumeItem, math.random(config.CollectMin, config.CollectMax)) then
			vRPclient.stopActived(source)
			TriggerClientEvent("Progress",source,5000,"Coletando...")
			TriggerClientEvent("cancelando",source,true)
			vRP.playAnim(source,false,{"melee@hatchet@streamed_core","plyr_front_takedown_b"},true)
			config.Collect[source] = nil
			return true
		end
		return false
	end
end

function server.paymentMethod()
	server.amountService()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,tostring(config.ConsumeItem),parseInt(amount[source])) then
			vRP.upgradeStress(user_id,1)
			local value = math.random(config.PaymentMin,config.PaymentMax) * amount[source]
			vRP.tryGiveInventoryItem(user_id,config.PaymentItem,parseInt(value),true)
			TriggerClientEvent("zSounds:source",source,"coin",0.5)
			TriggerClientEvent("Notify",source,"sucesso","Você entregou as <b>toras</b>, continue entregando",18000)
			amount[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..vRP.format(parseInt(amount[source])).."x "..vRP.itemNameList(config.ConsumeItem).."</b>.",5000)
		end
		return false
	end
end