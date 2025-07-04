local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

src = {}
Tunnel.bindInterface('zMultiChar', src)
zCLIENT = Tunnel.getInterface('zMultiChar')

local index = 0
local genderIcon = 'zMedia/error.png'
local spawnLogin = {}
local creating = false

function src.verifyChars()
    local source = source
    local steam = vRP.getSteam(source)
    local chars = getPlayerCharacters(steam)
    if chars then
        for a, b in pairs(chars) do
            local currentCharacterModeConsult = vRP.getUData(parseInt(b.user_id), 'currentCharacterMode')
            if currentCharacterModeConsult == '' then
               src.deleteChar(b.user_id)
            else
                return true
            end
        end
    end
    return false
end

function src.getChars()
    local source = source
    local steam = vRP.getSteam(source)
    local chars = getPlayerCharacters(steam)
    local charSlot = 4
    local characters = {}

    if chars then
        for a, b in pairs(chars) do
            local currentCharacterModeConsult = vRP.getUData(parseInt(b.user_id), 'currentCharacterMode')

            if currentCharacterModeConsult == '' then
                return src.deleteChar(b.user_id)
            end

            if currentCharacterModeConsult ~= nil then
                local currentCharacterModeResult = json.decode(currentCharacterModeConsult)
                if currentCharacterModeResult.gender == 1 then
                    genderIcon = 'zMedia/feminino.png'
                else
                    genderIcon = 'zMedia/masculino.png'  
                end
            end
            charSlot = charSlot - 1
            table.insert(characters, { id = b.user_id, name = b.name, firstname = b.firstname, registration = b.registration, phone = b.phone, bank = b.bank, genderIcon = genderIcon })
        end
        return characters, charSlot
    else
        return nil
    end
    characters = nil
end

function src.setupCharacteristics(user_id)
    local clothingsConsult = vRP.getUData(parseInt(user_id), 'Clothings')
	local clothingsResult = json.decode(clothingsConsult)
    
    local currentCharacterModeConsult = vRP.getUData(parseInt(user_id), 'currentCharacterMode')
	local currentCharacterModeResult = json.decode(currentCharacterModeConsult)

    if clothingsResult and currentCharacterModeResult then
        return clothingsResult, currentCharacterModeResult
    end

end

function src.deleteChar(id)
	local source = source
	local steam = vRP.getSteam(source)
	vRP.execute('vRP/remove_user', { user_id = parseInt(id) })
	Citizen.Wait(1000)
	return getPlayerCharacters(steam)
end

function getPlayerCharacters(steam)
	return vRP.query('vRP/get_user_by_steam', { steam = steam })
end

RegisterServerEvent('zMultiChar:teste')
AddEventHandler('zMultiChar:teste', function(user_id)
    local source = source
    zCLIENT.spawnChar(source, user_id)
end)

RegisterServerEvent('zMultiChar:setup')
AddEventHandler('zMultiChar:setup', function(source)
	TriggerClientEvent('zMultiChar:setupChar', source)
end)

RegisterServerEvent('zMultiChar:charChosen')
AddEventHandler('zMultiChar:charChosen', function(id)
	local source = source
    if id ~= nil then
        TriggerEvent('baseModule:idLoaded', source, id, nil)
        TriggerEvent('zCreator:Spawn', source, id)
    else
        local chars = getPlayerCharacters(steam)
        if chars then
            for k, v in pairs(chars) do
                TriggerEvent('baseModule:idLoaded', source, v.user_id, nil)
                TriggerEvent('zCreator:Spawn', source, v.user_id)
                return
            end
        end
    end
end)

RegisterServerEvent('zMultiChar:createChar')
AddEventHandler('zMultiChar:createChar', function()
	local source = source
	local steam = vRP.getSteam(source)
	local persons = getPlayerCharacters(steam)

    if not vRP.getPremium2(steam) and parseInt(#persons) >= 1 then
		TriggerClientEvent('Notify', source, 'importante', 'Você atingiu o limite de personagens.', 5000)
		return
	end

    if not creating then
        TriggerClientEvent('Notify', source, 'importante', 'Aguarde, estamos iniciando o criador de personagem...', 5000)

        local model = 'mp_m_freemode_01'
        vRP.execute('vRP/create_user', { steam = steam, name = 'Individuo', firstname = 'indigente' })
        local newId = 0
        local chars = getPlayerCharacters(steam)
        
        for k, v in pairs(chars) do
            if v.user_id > newId then
                newId = tonumber(v.user_id)
            end
        end

        Citizen.Wait(1000)

        spawnLogin[parseInt(newId)] = true
        TriggerEvent('baseModule:idLoaded', source, newId, model)
        TriggerClientEvent('closeInterfaceCreateChar', source)
        TriggerEvent('zCreator:Spawn', source, newId)
    end
end)