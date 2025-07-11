local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRPclient = Tunnel.getInterface('vRP')
vRP = Proxy.getInterface('vRP')
zCLIENT = Tunnel.getInterface('zCoins')
local zSERVER = {}
Tunnel.bindInterface('zCoins',zSERVER)
cfg = module(GetCurrentResourceName(), "config/yoda")

local zCoins = GetCurrentResourceName()
local evalToUser = {}
local lastGive = nil
cachedCoins = {}

sendToDiscord = function(wh,msg)
  if not wh or wh == 'discord webhook' then return end
  local embed = {
    {
        ["color"] = 0x0099ff,
        ["title"] = cfg.webhooks.info.title,
        ["description"] = msg,
        ["footer"] = {
          ["text"] = cfg.webhooks.info.footer.." ("..os.date("%d/%m/%Y %H:%M:%S")..")",
      },
    }
  }
  PerformHttpRequest(wh, function(err, text, headers)  end, 'POST', json.encode({username = cfg.webhooks.info.title, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand(cfg.commands.admin.giveall.command, function(source,args) 
  local source = source 
  local user_id = vRP.getUserId(source)
  if not args or not args[1] or tonumber(args[1]) <= 0 then 
    TriggerClientEvent("Notify", source, "negado","Uso correto: /"..cfg.commands.admin.giveall.command.." [quantidade]",9000)
    return false
  end
  if vRP.hasPermission(user_id,cfg.commands.admin.giveall.permission) then 
    if lastGive and os.time() - lastGive < 60 then 
      local ok = vRP.request(source,cfg.lang.cooldown_warning,15)
      if not ok then 
        TriggerClientEvent("Notify", source, "negado","Ação cancelada.",9000)
        return false 
      end
    end
    local coins = tonumber(args[1])
    for id,src in pairs(vRP.getUsers()) do
      local target = vRP.getUserSource(parseInt(id))
      local steam = vRP.getSteam(target)
      vRP._execute('vRP/giveCoins',{steam = steam, coins = coins})
      if cachedCoins[id] then cachedCoins[id] = cachedCoins[id] + coins end
      zCLIENT._updateCoin(src,cachedCoins[id])
    end
    TriggerClientEvent("Notify", -1, "sucesso", "+"..coins.." "..cfg.coinName.."!",9000)
    sendToDiscord(cfg.webhooks.commands,"STAFF **"..user_id.."** GIVE **"..coins.." coins** TO ALL!")
  end
end)

RegisterCommand(cfg.commands.admin.remove.command, function(source,args) 
  local source = source 
  local user_id = vRP.getUserId(source)
  if not args or not args[1] or tonumber(args[1]) <= 0 or not args[2] or tonumber(args[2]) <= 0 then 
    TriggerClientEvent("Notify", source, "negado","CORRECT: /"..cfg.commands.admin.remove.command.." [id] [quantidade]",9000)
    return false
  end
  if vRP.hasPermission(user_id,cfg.commands.admin.remove.permission) then 
    local nuser_id = tonumber(args[1])
    local target = vRP.getUserSource(parseInt(nuser_id))
    local steam = vRP.getSteam(target)
    local coins = tonumber(args[2])
    if cachedCoins[nuser_id] and cachedCoins[nuser_id] - coins >= 0 then cachedCoins[nuser_id] = cachedCoins[nuser_id] - coins end
    vRP._execute('vRP/removeCoins',{steam = steam, coins = coins})
    local nplayer = vRP.getUserSource(nuser_id)
    if nplayer then 
      zCLIENT._updateCoin(nplayer,cachedCoins[nuser_id])
    end
    sendToDiscord(cfg.webhooks.commands,"O administrador **"..user_id.."** removeu **"..coins.." coins** do usuário **"..nuser_id.."**")
    TriggerClientEvent("Notify", "sucesso", '-'..coins..' para o usuário '..nuser_id,9000)
  end
end)

RegisterCommand(cfg.commands.admin.set.command, function(source,args) 
  local source = source 
  local user_id = vRP.getUserId(source)

  if not args or not args[1] or tonumber(args[1]) <= 0 or not args[2] or tonumber(args[2]) <= 0 then 
    TriggerClientEvent("Notify", source, "negado","CORRECT: /"..cfg.commands.admin.set.command.." [id] [quantidade]",9000)
    return false
  end
  if vRP.hasPermission(user_id,cfg.commands.admin.set.permission) then 
    local nuser_id = tonumber(args[1])
    local target = vRP.getUserSource(parseInt(nuser_id))
    local steam = vRP.getSteam(target)
    local coins = tonumber(args[2])
    vRP._execute('vRP/updateCoins',{steam = steam, coins = coins})
    if cachedCoins[nuser_id] then cachedCoins[nuser_id] =  coins end
    local nplayer = vRP.getUserSource(nuser_id)
    if nplayer then 
      zCLIENT._updateCoin(nplayer,cachedCoins[nuser_id])
    end
    sendToDiscord(cfg.webhooks.commands,"O administrador **"..user_id.."** setou **"..coins.." coins** do usuário **"..nuser_id.."**")

    TriggerClientEvent("Notify", source,"sucesso", 'Setado '..coins..' para o usuário '..nuser_id,9000)
  end
end)

RegisterCommand(cfg.commands.admin.give.command, function(source,args) 
  local source = source 
  local user_id = vRP.getUserId(source)
  if not args or not args[1] or tonumber(args[1]) <= 0 or not args[2] or tonumber(args[2]) <= 0 then 
    TriggerClientEvent("Notify", source, "negado","Correctly: /"..cfg.commands.admin.give.command.." [id] [quantidade]",9000)
    return false
  end
  if vRP.hasPermission(user_id,cfg.commands.admin.give.permission) then 
    local nuser_id = tonumber(args[1])
    local target = vRP.getUserSource(parseInt(nuser_id))
    local steam = vRP.getSteam(target)
    local coins = tonumber(args[2])
    vRP._execute('vRP/giveCoins',{steam = steam, coins = coins})
    if cachedCoins[nuser_id] then cachedCoins[nuser_id] =cachedCoins[nuser_id] + coins end
    local nplayer = vRP.getUserSource(nuser_id)
    if nplayer then 
      zCLIENT._updateCoin(nplayer,cachedCoins[nuser_id])
    end
    sendToDiscord(cfg.webhooks.commands,"STAFF **"..user_id.."** ADD **"..coins.." coins** TO **"..nuser_id.."**")

    TriggerClientEvent("Notify", "sucesso", '+'..coins..' ADD TO '..nuser_id,9000)
  end
end)

function zSERVER.openUi(user_id)
  return {
    coins = cachedCoins[user_id] or 0
  }
end

function zSERVER.getEval()
  local source = source 
  local user_id = vRP.getUserId(source)
  local steam = vRP.getSteam(source)

  if user_id then 
    local coins = vRP.query("vRP/getCoins", {steam = steam})[1][cfg.columnName]
    cachedCoins[user_id] = coins
  end
  if user_id and evalToUser[user_id] then 
    local copyTable = evalToUser[user_id]
    for k,v in ipairs(evalToUser[user_id]) do 
      if v.temporary and v.temporary.onRemove then 
        sendToDiscord(cfg.webhooks.onremove,"Usuário **"..user_id.."** reembolsando (**"..v.name.."**) ")
        v.temporary.onRemove(source,user_id)
      end
      if v.appointament then 
        vRP._execute('vRP/deleteAppointament',{id = v.appointament})
      end
    end
    evalToUser[user_id] = nil
    return {appointaments = copyTable,user_id = user_id}
  end
  return {user_id = user_id}
end

function addExpirateProduct(user_id,product,_expirate)
  vRP._execute('vRP/insertTemporaryData',{
    user_id = user_id,
    product = json.encode(product),
    expirate = os.date("%Y-%m-%d %H:%M:%S",_expirate)
  })
end

function zSERVER.giveRouletteReward(itemInfo)
  local source        = source 
  local user_id       = vRP.getUserId(source)
  local productTable  = cfg.roulette.items[itemInfo.index]
  if productTable then 
    if productTable.onBuy then 
      productTable.onBuy(source,user_id)
    end
    if productTable.temporary and productTable.temporary.enable then 
      addExpirateProduct(user_id,{
        type = "reward",
        index = itemInfo.index
      },os.time()+productTable.temporary.days)
    end
    sendToDiscord(cfg.webhooks.roulette,"user_id **"..user_id.."** get item! (**"..productTable.name.."**). temporary? "..((productTable.temporary and productTable.temporary.enable) and 'Y *('..productTable.temporary.days..'d)*' or 'N').." ")

    if cfg.roulette.types[productTable.type] then 
      if cfg.roulette.types[productTable.type].notifyAll.notify then 
        TriggerClientEvent(zCoins..':notifyAll', -1, {
          identity = vRP.getUserIdentity(user_id),
          name = productTable.name,
          index = ((productTable.idname) and productTable.idname or productTable.model),
          type = productTable.type
        })
      end
      if cfg.roulette.types[productTable.type].notifyAll.chat.enabled then 
        sendMessage({
          chat_template = cfg.roulette.types[productTable.type].notifyAll.chat.chat_template,
          message = cfg.roulette.types[productTable.type].notifyAll.chat.message,
          identity = vRP.getUserIdentity(user_id),
          name = productTable.name,
          index = ((productTable.idname) and productTable.idname or productTable.model),
          type = productTable.type
        })

      end
    end
    if cfg.roulette.types[productTable.productType] then 
      cfg.roulette.types[productTable.productType]({
        src = source,
        user_id = user_id, 
        model = productTable.model, 
        idname = productTable.idname,
        amount = productTable.amount,
        info = productTable.additionalData,
        ammo = productTable.ammo,
      })
    end
    return true
  else 

  end
end

function zSERVER.tryOpenBox(value)
  local source = source 
  local user_id = vRP.getUserId(source)
  local steam = vRP.getSteam(source)

  if cachedCoins[user_id] >= value then 
    vRP._execute('vRP/updateCoins',{steam = steam, coins = cachedCoins[user_id] - value})
    cachedCoins[user_id] = cachedCoins[user_id] - value
    return {success = true}
  end
  return {error = cfg.coinName.." insuficiente", success = false} 
end

function zSERVER.buyProduct(productInfo)
  local source        = source 
  local user_id       = vRP.getUserId(source)
  local steam = vRP.getSteam(source)
  local category      = productInfo.category
  local productTable  = cfg.products[category][productInfo.index]
  if not user_id then 
    return {success = false  }
  end
  if productTable and cachedCoins[user_id] then 
    if cachedCoins[user_id] - productTable.price < 0 then 
      return {error = cfg.coinName.." "..cfg.lang.insuficiente, success = false} 
    end
    vRP._execute('vRP/updateCoins',{steam = steam, coins = cachedCoins[user_id] - productTable.price})
    cachedCoins[user_id] = cachedCoins[user_id] - productTable.price
    if productTable.onBuy then 
      productTable.onBuy(source,user_id)
    end
    sendToDiscord(cfg.webhooks.buy,"user_id **"..user_id.."** get item! (**"..productTable.name.."**) value **"..productTable.price.." coins** temp? "..((productTable.temporary and productTable.temporary.enable) and 'y *('..productTable.temporary.days..'d)*' or 'n').." ")

    if cfg.roulette.types[productTable.productType] then 
      cfg.roulette.types[productTable.productType]({
        src = source,
        user_id = user_id, 
        model = productTable.model, 
        idname = productTable.idname,
        amount = productTable.amount,
        info = productTable.additionalData,
        ammo = productTable.ammo,
      })
    end

    if productTable.temporary and productTable.temporary.enable then 
      addExpirateProduct(user_id,{
        type = "buy",
        category = category,
        index = productInfo.index
      },os.time()+productTable.temporary.days)
    end

    return {success = true, coins = cachedCoins[user_id] or 0 }
  else 
    return {success = false  }
  end
end

function sendMessage(data)
  if string.match(data.message,"nome") or string.match(msgData.message,"sobrenome") then 
    local identity = data.identity
    if cfg.identity then 
      data.message = data.message:gsub("{nome}",identity[cfg.identity.nome])
      data.message =  data.message:gsub("{sobrenome}",identity[cfg.identity.sobrenome])
    end
  end

  data.message = data.message:gsub("{item}",data.name)
  TriggerClientEvent('chat:addMessage', -1, {
    template = data.chat_template,
    args = { data.message }
  })
end

RegisterNetEvent("zCoins:updateGive",function(id,amount)
  if cachedCoins[id] then 
    cachedCoins[id] = cachedCoins[id] + amount 
    local nplayer = vRP.getUserSource(id)
    if nplayer then 
      zCLIENT._updateCoin(nplayer,cachedCoins[id])
    end
  end
end)

CreateThread(function()
  local rows = vRP.query('vRP/getAppointaments')
  for k,v in pairs(rows) do 
    local productInfo = json.decode(v.product)
    if not evalToUser[v.user_id] then 
      evalToUser[v.user_id] = {}
    end
    table.insert(evalToUser[v.user_id],{appointament = v.id, 
      product = ((v.type == 'buy') and cfg.products[productInfo.category][productInfo.index] or cfg.roulette.items[productInfo.index])
    })
  end
end)