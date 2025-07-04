local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

delivery = {}
Tunnel.bindInterface("zDelivery",delivery)

function delivery.pagar(distancia)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
	local pagamento = distancia * 0.1
        pagamento = pagamento / 0.20 
		vRP.tryGiveInventoryItem(user_id,config.item,math.floor(pagamento)) 
		TriggerClientEvent("zSounds:source",source,"coin",0.5)
		TriggerClientEvent("Notify",source,"sucesso","Entrega feita, vá buscar mais entregas no restaurante",9000)
		return pagamento
	end
end

function delivery.teleport(x,y,z)
	local source = source
 	vRPclient.teleport(source,x,y,z)
end

RegisterServerEvent("trydeleteveh554")
AddEventHandler("trydeleteveh554",function(index)
	TriggerClientEvent("syncdeleteveh",-1,index)
end)