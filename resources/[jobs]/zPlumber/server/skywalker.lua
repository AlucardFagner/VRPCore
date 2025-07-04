local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
server = {}
job = {}
Tunnel.bindInterface("zPlumber",server)
Tunnel.bindInterface("zPlumber",job)

local quantidade = {}
local ferramenta = {}

function server.giveFerramenta()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.tryGiveInventoryItem(user_id,config.item,3)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("Notify",source,"sucesso","Pegou 3 Ferramentas.")
		return true
	end
end

function job.SaveIdleCustom(old_custom)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.save_idle_custom(source,old_custom)
end

function server.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(config.quantidadeItem)	
	end
	   TriggerClientEvent("quantidade-ferramenta",source,parseInt(quantidade[source]))
end

function server.checkPayment()
	server.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if ferramenta[user_id] == 0 or not ferramenta[user_id] then
			if vRP.tryGetInventoryItem(user_id,config.item,quantidade[source]) then
				randmoney = (config.quantidadeDinheiroRecebido * quantidade[source])
		        vRP.tryGiveInventoryItem(user_id,"dinheiro",(randmoney))
		        TriggerClientEvent("zSounds:source",source,"coin",0.5)
				TriggerClientEvent("Notify",source,"sucesso","Você recebeu $"..randmoney.. " pelo serviço",18000)
				quantidade[source] = nil
				server.Quantidade()
				ferramenta[user_id] = 15
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x Ferramentas</b>.")
			end
		end
	end
	return false
end

RegisterServerEvent('zPlumber:roupa')
AddEventHandler('zPlumber:roupa', function()
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		vRP.removeCloak(source)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(ferramenta) do
            if v > 0 then
                ferramenta[k] = v - 1
            end
        end
    end
end)