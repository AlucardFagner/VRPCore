local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

server = {}
Tunnel.bindInterface("zTaxi",server)

local taxiMeter = {}

function server.addGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.insertPermission(user_id,config.group)
    TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.",9000)
end

function server.removeGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.removePermission(user_id,config.remgroup)
    TriggerClientEvent("Notify",source, "aviso","Você saiu de serviço.",9000)
end

function server.checkPermission()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id,config.permgroup)
end

function server.checkPayment(payment)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randmoney = parseInt(math.random(config.taxipayment[1],config.taxipayment[2])*payment)
        vRP.tryGiveInventoryItem(user_id,'dinheiro',parseInt(randmoney))
        TriggerClientEvent("zSounds:source",source,'coin',0.5)
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.",8000)
    end
end

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.3) / mult
end

function splitString(str, sep)
    if sep == nil then sep = "%s" end
    local t={}
    local i=1
    for str in string.gmatch(str, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end