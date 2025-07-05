-- vrp-core/core.lua
local Core = {}
Core.__index = Core
Core.users = {}

print("[vrp-core] Core carregado!") -- Log ao carregar o core

function Core.newUser(user_id)
    print("[vrp-core] newUser chamado para user_id:", user_id)
    if not Core.users[user_id] then
        Core.users[user_id] = { money = 0, permissions = {} }
        print("[vrp-core] Novo usuário criado:", user_id)
        return true
    end
    print("[vrp-core] Usuário já existe:", user_id)
    return false
end

function Core.giveMoney(user_id, amount)
    print("[vrp-core] giveMoney chamado para user_id:", user_id, "amount:", amount)
    if Core.users[user_id] then
        Core.users[user_id].money = Core.users[user_id].money + amount
        print("[vrp-core] Dinheiro adicionado. Novo saldo:", Core.users[user_id].money)
        return true
    end
    print("[vrp-core] Usuário não encontrado:", user_id)
    return false
end

function Core.hasPermission(user_id, permission)
    print("[vrp-core] hasPermission chamado para user_id:", user_id, "permission:", permission)
    return Core.users[user_id] and Core.users[user_id].permissions[permission] or false
end

function Core.addPermission(user_id, permission)
    print("[vrp-core] addPermission chamado para user_id:", user_id, "permission:", permission)
    if Core.users[user_id] then
        Core.users[user_id].permissions[permission] = true
        print("[vrp-core] Permissão adicionada:", permission)
        return true
    end
    print("[vrp-core] Usuário não encontrado:", user_id)
    return false
end

function Core.removePermission(user_id, permission)
    print("[vrp-core] removePermission chamado para user_id:", user_id, "permission:", permission)
    if Core.users[user_id] then
        Core.users[user_id].permissions[permission] = nil
        print("[vrp-core] Permissão removida:", permission)
        return true
    end
    print("[vrp-core] Usuário não encontrado:", user_id)
    return false
end

exports("GetCoreObject", function()
    print("[vrp-core] GetCoreObject exportado!")
    return Core
end)

return Core
