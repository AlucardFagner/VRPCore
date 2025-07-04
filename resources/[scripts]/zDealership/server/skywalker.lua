local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
zSERVER = {}
Proxy.addInterface("zDealership", zSERVER)
Tunnel.bindInterface("zDealership", zSERVER)

RegisterCommand('estoque', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasGroup(user_id, "gerente") then
        if args[1] == "add" then
            if args[2] then
                local quantidade = vRP.prompt(source, "Quantidade", "")
                if quantidade == "" then
                    return TriggerClientEvent("Notify", source, "negado", "Você precisa a quantidade")
                end
                if tonumber(quantidade) then
                    local fac = vRP.request(source, "Você tem certeza que deseja <b>adicionar ".. quantidade .."</b> ao estoque de <b>".. args[2] .."</b> ?", 30)
                    if fac then
                        zSERVER.addStock(args[2], parseInt(quantidade))
                        TriggerClientEvent("Notify", source, "sucesso", "Você <b>adicionou ".. quantidade .."</b> ao estoque de <b>".. args[2])
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Precisa ser um número")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o modelo do veículo")
            end
        elseif args[1] == "rem" then
            if args[2] then
                local quantidade = vRP.prompt(source, "Quantidade", "")
                if quantidade == "" then
                    return TriggerClientEvent("Notify", source, "negado", "Você precisa a quantidade")
                end
                if tonumber(quantidade) then
                    local fac = vRP.request(source, "Você tem certeza que deseja <b>retirar ".. quantidade .."</b> do estoque de <b>".. args[2] .."</b> ?", 30)
                    if fac then
                        if zSERVER.inStock(args[2]) then
                            zSERVER.remStock(args[2], parseInt(quantidade))
                            TriggerClientEvent("Notify", source, "sucesso", "Você <b>retirou ".. quantidade .."</b> do estoque de <b>".. args[2])
                        else
                            TriggerClientEvent("Notify", source, "negado", args[2] .." não tem <b>".. quantidade .."</b> em <b>estoque")
                        end
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Precisa ser um número")
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o modelo do veículo")
            end
        elseif args[1] == "qtd" then
            if args[2] then
                local consulta = vRP.query("vRP/select_veh", { model = args[2] })
                TriggerClientEvent("Notify", source, "aviso", "<b>Veículo:</b> ".. consulta[1].name)
                TriggerClientEvent("Notify", source, "aviso", "<b>Estoque:</b> ".. vRP.format(consulta[1].stock))
            else
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o modelo do veículo")
            end 
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Permissões insuficientes")
    end
end)

RegisterCommand('conce', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasGroup(user_id, "gerente") then
        if args[1] == "add" then
            local veh = vRP.prompt(source, "Veículo", "")
            local preco = vRP.prompt(source, "Preço", "")
            local nome = vRP.prompt(source, "Nome", "")
            local categoria = vRP.prompt(source, "Categoria", "")
            local estoque = vRP.prompt(source, "Estoque Inicial", "")
            if veh == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o <b>Modelo</b> do <b>Veículo")
                return
            elseif preco == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o <b>Preço</b> do <b>Veículo")
                return
            elseif nome == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o <b>Nome</b> do <b>Veículo")
                return
            elseif categoria == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar a <b>Categoria</b> do <b>Veículo")
                return
            elseif estoque == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o <b>Estoque Inicial</b> do <b>Veículo")
                return
            end
            if tonumber(preco) then
                if vRP.request(source, "Deseja anúnciar (<b>Preço:</b> ".. vRP.format(preco) .." - <b>Nome:</b> ".. nome .." - <b>Categoria:</b> ".. categoria .." - <b>Estoque Inicial:</b> ".. vRP.format(estoque) ..") ?", 30) then
                    zSERVER.addVeiculo(nome, veh, preco, categoria, estoque)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Veículo Adicionado</b>")
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Modelo:</b> ".. veh)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Nome:</b> ".. nome)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Preço:</b> ".. vRP.format(preco))
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Categoria:</b> ".. categoria)
                    TriggerClientEvent("Notify", source, "sucesso", "<b>Estoque Inicial:</b> ".. vRP.format(estoque))
                end
            else
                TriggerClientEvent("Notify", source, "negado", "O <b>preço</b> precisa ser um <b>número")
            end
        elseif args[1] == "rem" then
            local veh = vRP.prompt(source, "Veículo (Modelo)", "")
            if veh == "" then
                TriggerClientEvent("Notify", source, "negado", "Você precisa colocar o <b>Modelo</b> do <b>Veículo")
                return
            end
            if vRP.request(source, "Deseja retirar o anúncio do <b>Veículo:</b> ".. veh .." ?", 30) then
                zSERVER.remVeiculo(veh)
                TriggerClientEvent("Notify", source, "sucesso", "<b>Anúncio Removido</b>")
            end
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Permissões insuficientes")
    end
end)

function zSERVER.addStock(veh, qtd)
    local consulta = vRP.query("vRP/select_veh", { model = veh })
    vRP.execute("vRP/update_stock", { stock = parseInt(consulta[1].stock + qtd), model = veh })
end

function zSERVER.remStock(veh, qtd)
    local consulta = vRP.query("vRP/select_veh", { model = veh })
    vRP.execute("vRP/update_stock", { stock = parseInt(consulta[1].stock - qtd), model = veh })
end

function zSERVER.inStock(veh)
    local consulta = vRP.query("vRP/select_veh", { model = veh })
    if consulta[1].stock > 0 then
        return true
    else
        return false
    end
end

function zSERVER.addVeiculo(nome, veh, preco, categoria, estoque)
    vRP.execute("vRP/add_veh", { name = nome, price = preco, model = veh, category = categoria, stock = estoque })
end

function zSERVER.remVeiculo(veh)
    vRP.execute("vRP/rem_veh", { model = veh })
end

function zSERVER.returnValues()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local consult_rg = vRP.getUserIdentity(user_id)
        local bankAccount = vRP.getBankIdData(user_id)
        local result = json.encode(bankAccount)
        local consult_money = 0

        if result ~= '[]' then
            consult_money = vRP.getBankId(user_id) + vRP.getInventoryItemAmount(user_id,'dinheiro')
        else
            consult_money = vRP.getInventoryItemAmount(user_id,'dinheiro')
        end

        return consult_rg.name, vRP.format(parseInt(consult_money))
    end
end

RegisterServerEvent("zdealership-vehs:show")
AddEventHandler("zdealership-vehs:show", function()
    TriggerClientEvent("zdealership-vehs:show_vehs", source, MySQL.Sync.fetchAll('SELECT * FROM dealership'))
end)

RegisterServerEvent("zdealership-vehs:comprar")
AddEventHandler("zdealership-vehs:comprar", function(veh, price, name)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local consulta = vRP.query("vRP/select_veh", { model = veh })
        for _,result in pairs(consulta) do
            if vRP.tryPayment(user_id, price) then
                vRP.execute("vRP/add_vehicle",{ plate = vRP.generatePlateNumber(), user_id = user_id, vehicle = veh, tax = parseInt(os.time()+24*30*60*60 ) })
                vRP.execute("vRP/update_stock", { stock = parseInt(result.stock - 1), model = veh })
                TriggerClientEvent("zdealership-vehs:notify", source, "error", "Você comprou o veículo <b>".. name .."</b> por <b>".. vRP.format(price) .." reais</b>!")
            else
                TriggerClientEvent("zdealership-vehs:notify", source, "error", "Dinheiro Insuficiente.")
            end
        end
    end
end)

