local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
server = {}
Tunnel.bindInterface("zHarvest",server)
client = Tunnel.getInterface("zHarvest")

local collectMin = 1
local collectMax = 2
local amount = {}
local amountMin = 2
local amountMax = 3

function server.collectMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not user_id then
		--if vRP.computeInvWeight(user_id) + 1 > vRP.itemWeightList(user_id) then
		TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",5000)
		Wait(1)
		else
			vRPclient.stopActived(source)
			TriggerClientEvent("Progress",source,4000,"Colhendo...")
			vRP.upgradeStress(user_id,1)
			vRPclient._playAnim(source,false,{"amb@prop_human_movie_bulb@base","base"},false)
			local random = math.random(config.RandomPayment)
			for k, v in pairs(config.PaymentItem) do 
				if v.item then
					if parseInt(v.biggerorequal) >= parseInt(config.RandomPayment) then
						vRP.tryGiveInventoryItem(user_id,v.item,math.random(v.valuemin, v.valuemax),true)
					end
				end
			end
			config.CollectPoint[source] = nil
			TriggerClientEvent("cancelando",source,true)
			return true
		end
		return false
	end
end