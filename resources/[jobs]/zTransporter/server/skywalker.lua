local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
server = {}
Tunnel.bindInterface("zTransporter",server)
client = Tunnel.getInterface("zTransporter")

local collect = {}
local amount = {}
local amountMin = 2
local amountMax = 3
local paymentMin = 75
local paymentMax = 105

function server.collectMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k, v in pairs(config.ItemCollect) do 
			if k ~= nil then
				local collectamount = math.random(v.min,v.max)
				vRP.tryGiveInventoryItem(user_id,v.item,parseInt(collectamount),true)
				vRP.upgradeStress(user_id,1)
				return true
			end
		end
		return false
	end
end

function server.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for a, b in pairs(config.ItemDelivery) do 
			local itemamount = math.random(b.min,b.max)
			if a ~= nil then 
				if vRP.tryGetInventoryItem(user_id,b.item,parseInt(itemamount)) then
					vRP.upgradeStress(user_id,1)
					for c, d in pairs(config.PaymentItem) do 
						if c ~= nil then 
							local paymentamount = math.random(d.min,d.max)
							vRP.tryGiveInventoryItem(user_id,d.item,parseInt(paymentamount))
							TriggerClientEvent("zSounds:source",source,"coin",0.5)
							amount[source] = nil
							return true
						end
					end
				else
					TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..vRP.format(parseInt(amount[source])).."x "..vRP.itemNameList(consumeItem).."</b>.",5000)
					return false
				end
			end
		end
		return false
	end
end

	--- deletar veículo
if vehicle then
	zCLIENT.deleteVehicle(source, vehicle)
end