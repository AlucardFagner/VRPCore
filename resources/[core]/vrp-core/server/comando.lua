-- command.lua

local VRPCore = exports['vrp-core']:GetCoreObject()

-- Comando para dar dinheiro
RegisterCommand("giveMoney", function(source, args, rawCommand)
    local user = VRPCore.Functions.GetPlayer(source)
    if user and user.Functions.HasPermission("admin.giveMoney") then
        local target_id = tonumber(args[1])
        local amount = tonumber(args[2])
        if target_id and amount then
            local target = VRPCore.Functions.GetPlayer(target_id)
            if target then
                target.Functions.AddMoney("cash", amount)
                TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Você deu $" .. amount .. " para o jogador " .. target_id } })
            else
                TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Jogador não encontrado." } })
            end
        else
            TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Uso: /giveMoney [id] [quantia]" } })
        end
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Você não tem permissão para usar este comando." } })
    end
end)

-- Comando para teleportar
RegisterCommand("tp", function(source, args, rawCommand)
    local user = VRPCore.Functions.GetPlayer(source)
    if user and user.Functions.HasPermission("admin.teleport") then
        local target_id = tonumber(args[1])
        if target_id then
            local target = VRPCore.Functions.GetPlayer(target_id)
            if target then
                local ped = GetPlayerPed(target_id)
                local x, y, z = table.unpack(GetEntityCoords(ped))
                SetEntityCoords(GetPlayerPed(source), x, y, z)
                TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Você foi teleportado para o jogador " .. target_id } })
            else
                TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Jogador não encontrado." } })
            end
        else
            TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Uso: /tp [id]" } })
        end
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Você não tem permissão para usar este comando." } })
    end
end)

-- Adicione mais comandos conforme necessário