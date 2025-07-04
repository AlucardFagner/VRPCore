Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zShops', zSERVER)
zCLIENT = Tunnel.getInterface('zShops')

vRP.prepare('vRP/insert_shop','INSERT INTO shops(shop, name, x, y, z, price) VALUES(@shop, @name, @x, @y, @z, @price)')
vRP.prepare('vRP/get_shops', 'SELECT * FROM shops')
vRP.prepare('vRP/get_shop','SELECT * FROM shops WHERE shop = @shop')
vRP.prepare('vRP/update_shop','UPDATE shops SET name = @name, permission = @permission, x = @x, y = @y, z = @z, owner = @owner, security = @security, price = @price, forsale = @forsale, stock = @stock, slots = @slots, vault = @vault, maxstock = @maxstock, maxvault = @maxvault WHERE shop = @shop')
vRP.prepare('vRP/set_stock_shop','UPDATE shops SET stock = @stock WHERE shop = @shop')
vRP.prepare('vRP/set_vault_shop','UPDATE shops SET vault = @vault WHERE shop = @shop')

local shops = {}

function getShopData(shop)
    local rows = vRP.query('vRP/get_shop', {shop = shop})
    if #rows > 0 then
        return rows
    end
    return {}
end

function getStock(shop)
    local rows = vRP.query('vRP/get_shop', {shop = shop})
    if #rows > 0 then
        return json.decode(rows[1].stock)
    end
    return {}
end

function setStock(shop, slot, item, amount, price, gunlicense, require, requireAmount)
    local stock = getStock(shop)
    stock[tostring(slot)] = {
        ['item'] = item,
        ['stock'] = parseInt(amount),
        ['price'] = parseInt(price),
        ['gunlicense'] = gunlicense,
        ['require'] = require,
        ['requireAmount'] = parseInt(requireAmount)
    }
    vRP.execute('vRP/set_stock_shop', {['stock'] = json.encode(stock), ['shop'] = shop })
end

function zSERVER.getThisShop(coords)
    local rows = vRP.query('vRP/get_shops')
    if #rows > 0 then
        for k, v in pairs(rows) do
            local distance = #(coords - vector3(tonumber(v.x),tonumber(v.y), tonumber(v.z)))
            if distance < 5.4 then
                return v.shop
            end
        end
    end
    return false
end

function zSERVER.getDataShop(shop)
    local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        local dataInv = vRP.getInventory(user_id)
        local dataShop = getShopData(shop)
        local shopStock = getStock(shop)

        if dataInv then
            local inventory = {}
            local itens = {}
            for a, b in pairs(dataInv) do
                if (parseInt(b.amount) <= 0 or vRP.itemBodyList(b.item) == nil) then
                    vRP.removeInventoryItem(user_id, b.item, parseInt(b.amount), false)
                else
                    if string.sub(b.item, 1, 9) == b.item then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						b.durability = advDecode[b.item]
					end
                    b.key = b.item
					b.slot = a
					b.index = vRP.itemIndexList(b.item)
					b.name = vRP.itemNameList(b.item)
					b.amount = parseInt(b.amount)
					b.weight = vRP.itemWeightList(b.item)
					b.type = vRP.itemTypeList(b.item)
					inventory[a] = b
                end
            end

            for a, b in pairs(shopStock) do
                if vRP.itemBodyList(b.item) then
                    table.insert(itens, {slot = a, key = b.item, index = vRP.itemIndexList(b.item), name = vRP.itemNameList(b.item), price = parseInt(b.price), stock = parseInt(b.stock)})
                end
            end

            return inventory, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id), itens, dataShop[1].name, dataShop[1].slots
        end
    end
end

function zSERVER.buyItem(item, slot, amount, shop)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local stock = getStock(shop)
    local dataShop = getShopData(shop)
    if user_id then
        if stock[tostring(slot)].item == item then
            if amount > 0 and stock[tostring(slot)].stock >= amount then
                if dataShop[1].owner == user_id then
                    stock[tostring(slot)].stock = stock[tostring(slot)].stock - parseInt(amount)
                    setStock(shop, slot, item, stock[tostring(slot)].stock, stock[tostring(slot)].price, stock[tostring(slot)].gunlicense, stock[tostring(slot)].require, stock[tostring(slot)].requireAmount)
                    vRP.tryGiveInventoryItem(user_id, item, parseInt(amount))
                    TriggerClientEvent('zShops:update', source, shop)
                else
                    if dataShop[1].vault < dataShop[1].maxvault and dataShop[1].vault + stock[tostring(slot)].price * parseInt(amount) <= dataShop[1].maxvault then
                        if stock[tostring(slot)].gunlicense ~= nil and stock[tostring(slot)].gunlicense then
                            if stock[tostring(slot)].require ~= nil and stock[tostring(slot)].require then
                                if vRP.getInventoryItemAmount(user_id, stock[tostring(slot)].require) >= parseInt(stock[tostring(slot)].requireAmount * amount) then
                                    if identity.gunlicense == 1 and vRP.getInventoryItemAmount(user_id,'porte-armas') >= 1 then
                                        if vRP.tryPayment(user_id, parseInt(tonumber(stock[tostring(slot)].price) * amount)) then
                                            stock[tostring(slot)].stock = stock[tostring(slot)].stock - parseInt(amount)
                                            vRP.tryGetInventoryItem(user_id, stock[tostring(slot)].require, parseInt(tonumber(stock[tostring(slot)].requireAmount) * amount))
                                            setStock(shop, slot, item, stock[tostring(slot)].stock, stock[tostring(slot)].price, stock[tostring(slot)].gunlicense, stock[tostring(slot)].require, stock[tostring(slot)].requireAmount)
                                            vRP.tryGiveInventoryItem(user_id, item, amount)
                                            TriggerClientEvent('zShops:update', source, shop)
                                            dataShop[1].vault = dataShop[1].vault + stock[tostring(slot)].price * parseInt(amount)
                                            vRP.execute('vRP/set_vault_shop', {['vault'] = parseInt(dataShop[1].vault), ['shop'] = shop })
                                        else
                                            TriggerClientEvent('Notify',source,'negado','Dinheiro insuficiente.', 5000)
                                        end
                                    else
                                        TriggerClientEvent('Notify',source,'negado','Você precisar ter <b>porte de armas</b>.', 5000)
                                    end
                                else
                                    TriggerClientEvent('Notify',source,'negado','Você precisa de <b>'..parseInt(b.requireAmount * amount)..'x '..vRP.itemNameList(b.require)..'</b>.')
                                end
                            else
                                if identity.gunlicense == 1 and vRP.getInventoryItemAmount(user_id,'porte-armas') >= 1 then
                                    if vRP.tryPayment(user_id, parseInt(tonumber(b.price) * amount)) then
                                        stock[tostring(slot)].stock = stock[tostring(slot)].stock - parseInt(amount)
                                        vRP.tryGetInventoryItem(user_id, b.require, parseInt(tonumber(b.requireAmount) * amount))
                                        vRP.tryGiveInventoryItem(user_id, item, amount)
                                        setStock(shop, slot, item, stock[tostring(slot)].stock, stock[tostring(slot)].price, stock[tostring(slot)].gunlicense, stock[tostring(slot)].require, stock[tostring(slot)].requireAmount)
                                        TriggerClientEvent('zShops:update', source, shop)
                                        dataShop[1].vault = dataShop[1].vault + stock[tostring(slot)].price * parseInt(amount)
                                        vRP.execute('vRP/set_vault_shop', {['vault'] = parseInt(dataShop[1].vault), ['shop'] = shop })
                                    else
                                        TriggerClientEvent('Notify',source,'negado','Dinheiro insuficiente.', 5000)
                                    end
                                else
                                    TriggerClientEvent('Notify',source,'negado','Você precisar ter <b>porte de armas</b>.', 5000)
                                end
                            end
                        else
                            if stock[tostring(slot)].require ~= nil and stock[tostring(slot)].require then
                                if vRP.getInventoryItemAmount(user_id, stock[tostring(slot)].require) >= parseInt(stock[tostring(slot)].requireAmount * amount) then
                                    if vRP.tryPayment(user_id, parseInt(tonumber(stock[tostring(slot)].price) * amount)) then
                                        stock[tostring(slot)].stock = stock[tostring(slot)].stock - parseInt(amount)
                                        vRP.tryGetInventoryItem(user_id, stock[tostring(slot)].require, parseInt(tonumber(stock[tostring(slot)].requireAmount) * amount))
                                        vRP.tryGiveInventoryItem(user_id, item, amount)
                                        setStock(shop, slot, item, stock[tostring(slot)].stock, stock[tostring(slot)].price, stock[tostring(slot)].gunlicense, stock[tostring(slot)].require, stock[tostring(slot)].requireAmount)
                                        TriggerClientEvent('zShops:update', source, shop)
                                        dataShop[1].vault = dataShop[1].vault + stock[tostring(slot)].price * parseInt(amount)
                                        vRP.execute('vRP/set_vault_shop', {['vault'] = parseInt(dataShop[1].vault), ['shop'] = shop })
                                    else
                                        TriggerClientEvent('Notify',source,'negado','Dinheiro insuficiente.', 5000)
                                    end
                                else
                                    TriggerClientEvent('Notify',source,'negado','Você precisa de <b>'..parseInt(stock[tostring(slot)].requireAmount * amount)..'x '..vRP.itemNameList(stock[tostring(slot)].require)..'</b>.', 5000)
                                end
                            else
                                if vRP.tryPayment(user_id, parseInt(tonumber(stock[tostring(slot)].price) * amount)) then
                                    stock[tostring(slot)].stock = stock[tostring(slot)].stock - parseInt(amount)
                                    vRP.tryGiveInventoryItem(user_id, item, amount)
                                    setStock(shop, slot, item, stock[tostring(slot)].stock, stock[tostring(slot)].price, stock[tostring(slot)].gunlicense, stock[tostring(slot)].require, stock[tostring(slot)].requireAmount)
                                    TriggerClientEvent('zShops:update', source, shop)
                                    dataShop[1].vault = dataShop[1].vault + stock[tostring(slot)].price * parseInt(amount)
                                    vRP.execute('vRP/set_vault_shop', {['vault'] = parseInt(dataShop[1].vault), ['shop'] = shop })
                                else
                                    TriggerClientEvent('Notify', source, 'negado','Dinheiro insuficiente.', 5000)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function zSERVER.sellItem(item, slot, amount, shop)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local stock = getStock(shop)
    local dataShop = getShopData(shop)
    local itemExist = false
    if user_id then
        for a, b in pairs(stock) do
            for c, d in pairs(b) do
                if d.name == item then
                    itemExist = true
                end
            end   
        end

        if itemExist then

        else

        end

        if stock[tostring(slot)].item and stock[tostring(slot)].item == item then
            -- ITEM EXISTENTE
        else
            -- ITEM NOVO
        end
    end
end

RegisterCommand('loja',function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local shop = zCLIENT.getIdShop(source)
    if user_id then
        if args[1] == 'criar' then
            if vRP.hasPermission(user_id, 'gerente') then
                local shopId = vRP.prompt(source, 'Qual será o ID da loja? (Único)', '')
                if shopId == '' then
                    TriggerClientEvent('Notify', source, 'negado', 'É obrigatório fornecer um ID para loja!', 5000)
                    return
                end

                local shopName = vRP.prompt(source, 'Qual será o nome da loja?', '')
                if shopName == '' then
                    TriggerClientEvent('Notify', source, 'negado', 'É obrigatório fornecer um Nome para loja!', 5000)
                    return
                end

                local x, y ,z = vRPclient.getPositions(source)

                local shopPrice = vRP.prompt(source, 'Qual será o valor de venda da loja?', '')
                if shopPrice == '' or parseInt(shopPrice) <= 0 then
                    TriggerClientEvent('Notify', source, 'negado', 'É obrigatório fornecer um valor de venda para loja!', 5000)
                    return
                end

                vRP.execute('vRP/insert_shop', { ['shop'] = shopId, ['name'] = shopName, ['x'] = x, ['y'] = y, ['z'] = z, ['price'] = shopPrice })
                local msg = 'Loja '..shopName..' criada com sucesso!'
                TriggerClientEvent('Notify', source, 'sucesso', msg, 5000)
            end
        elseif args[1] == 'item' then
            local stock = shops[shop].stock
            if shops[shop].owner == user_id then
                if args[2] == 'add' then
                    local itemName = vRP.prompt(source, 'Qual será o item?', '')
                    if itemName == '' and vRP.itemIndexList(itemName) then
                        TriggerClientEvent('Notify', source, 'negado', 'Item inválido ou inexistente!', 5000)
                        return
                    end

                    local slot = 0
                    repeat
                        slot = slot + 1
                    until stock[tostring(slot)] == nil or (stock[tostring(slot)] and stock[tostring(slot)].item == itemName)
                    slot = tostring(slot)


                    local itemStock = vRP.prompt(source, 'Qual será a quantidade de itens adicionados?', '')
                    if itemStock == '' and parseInt(tonumber(itemStock)) <= 0 then
                        TriggerClientEvent('Notify', source, 'negado', 'Valor inválido!', 5000)
                        return
                    end

                    local itemGunlicense = false
                    local itemRequire = false
                    local itemPrice = false

                    if stock[slot] == nil then
                        itemPrice = vRP.prompt(source, 'Qual será o valor do item?', '')
                        if itemPrice == '' and parseInt(tonumber(itemPrice)) <= 0 then
                            TriggerClientEvent('Notify', source, 'negado', 'Valor inválido!', 5000)
                            return
                        end

                        itemGunlicense = vRP.prompt(source, 'É preciso de porte de armas para comprar este item? (1: Sim, 2: Não)', '')
                        if parseInt(tonumber(itemGunlicense)) < 1 or parseInt(tonumber(itemGunlicense)) > 2 then
                            TriggerClientEvent('Notify', source, 'negado', 'Essa resposta só pode ser 1 ou 2.', 5000)
                            return
                        elseif parseInt(tonumber(itemGunlicense)) == 1 then
                            itemGunlicense = true
                        elseif parseInt(tonumber(itemGunlicense)) == 2 then
                            itemGunlicense = false
                        end

                        itemRequire = vRP.prompt(source, 'É preciso de algum outro item para comprar este? (1: Sim, 2: Não)', '')
                        if parseInt(tonumber(itemRequire)) < 1 or parseInt(tonumber(itemRequire)) > 2 then
                            TriggerClientEvent('Notify', source, 'negado', 'Essa resposta só pode ser 1 ou 2.', 5000)
                            return
                        elseif parseInt(tonumber(itemRequire)) == 1 then
                            itemRequire = true
                        elseif parseInt(tonumber(itemRequire)) == 2 then
                            itemRequire = false
                        end
                    end

                    local itemNameRequire = false
                    local itemAmountRequire = false

                    if itemRequire then
                        itemNameRequire = vRP.prompt(source, 'Qual será o item requerido?', '')
                        if itemNameRequire == '' and vRP.itemIndexList(itemNameRequire) then
                            TriggerClientEvent('Notify', source, 'negado', 'Item requerido inválido ou inexistente!', 5000)
                            return
                        end

                        itemAmountRequire = vRP.prompt(source, 'Qual é a quantidade de itens requeridos?', '')
                        if itemAmountRequire == '' or parseInt(tonumber(itemAmountRequire)) <= 0 then
                            TriggerClientEvent('Notify', source, 'negado', 'Valor inválido!', 5000)
                            return
                        end
                    end

                    if vRP.tryGetInventoryItem(user_id, itemName, parseInt(tonumber(itemStock)), true) then
                        if stock ~= '[]' or stock ~= nil then
                            if stock[slot] == nil then
                                stock[slot] = {
                                    item = itemName, 
                                    stock = parseInt(tonumber(itemStock)), 
                                    price = parseInt(tonumber(itemPrice)), 
                                    gunlicense = itemGunlicense, 
                                    require = itemNameRequire, 
                                    requireAmount = parseInt(tonumber(itemAmountRequire))
                                }
                            elseif stock[slot] and stock[slot].item == itemName then
                                stock[slot].stock = stock[slot].stock + parseInt(tonumber(itemStock))
                            end
                        else
                            stock[slot] = {
                                item = itemName, 
                                stock = parseInt(tonumber(itemStock)), 
                                price = parseInt(tonumber(itemPrice)), 
                                gunlicense = itemGunlicense, 
                                require = itemNameRequire, 
                                requireAmount = parseInt(tonumber(itemAmountRequire))
                            }
                        end
                        TriggerClientEvent('Notify', source, 'sucesso', 'item adicionado com sucesso!', 5000)
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'Você não possuí o item ou a quantidade indicada.', 5000)
                    end
                elseif args[2] == 'rem' then
                    local itemName = vRP.prompt(source, 'Qual é o nome do item que será removido?', '')
                    if itemName == '' and vRP.itemIndexList(itemName) then
                        TriggerClientEvent('Notify', source, 'negado', 'Item inválido ou inexistente!', 5000)
                        return
                    end

                    for a, b in pairs(stock) do
                        if b.item == itemName then
                            vRP.tryGiveInventoryItem(user_id, itemName, parseInt(tonumber(b.stock)))
                            stock[a] = nil
                        end
                    end

                    TriggerClientEvent('Notify', source, 'sucesso', 'item removido com sucesso!', 5000)
                end
            end
        end
    end
end)