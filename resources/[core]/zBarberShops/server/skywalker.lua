local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zBarberShops', zSERVER)
zCLIENT = Tunnel.getInterface('zBarberShops')

RegisterCommand('verde', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRPclient.inVehicle(source) then
            local x, y, zSERVER = vRPclient.getPositions(source)
            local data = vRP.getUserDataTable(user_id)
            if data then
                TriggerClientEvent('syncarea', -1, x, y, zSERVER, 2)
                vRPclient._setCustomization(source, data.customization)
                local value = vRP.getUData(user_id, 'currentCharacterMode')
                if value ~= '' then
                    local custom = json.decode(value) or {}            
                    TriggerClientEvent('zBarberShops:setCustomization', player, custom)
                end
            end
        end
    end
end)

function zSERVER.dataHealth()
    local source = source
    local user_id = vRP.getUserId(source)
    local data = vRP.getUserDataTable(user_id)
    return data.health
end

function zSERVER.checkOpen()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
            return true
        end
    end
    return false
end

function zSERVER.updateSkin(myClothes)
    local source = source
    local user_id = vRP.getUserId(source)    
    if user_id then
        vRP.setUData(user_id, 'currentCharacterMode', json.encode(myClothes))
    end
end

function Dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

AddEventHandler('zBarberShops:init', function(user_id)
    local player = vRP.getUserSource(parseInt(user_id))
    if player then
        local value = vRP.getUData(user_id, 'currentCharacterMode')
        if value ~= '' then
            local custom = json.decode(value) or {}      
            TriggerClientEvent('zBarberShops:setCustomization', player, custom, user_id)
        end
    end
end)