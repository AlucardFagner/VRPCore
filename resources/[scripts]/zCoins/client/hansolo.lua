local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local zCoins = GetCurrentResourceName()
vRP = Proxy.getInterface("vRP")
zSERVER = Tunnel.getInterface('zCoins')
Tunnel.bindInterface('zCoins',zCLIENT)
cfg = module(GetCurrentResourceName(), "config/yoda")

local zCLIENT = {}
local uiStatus = false 
local user_id,appointaments,selectedDict

RegisterCommand(cfg.commands.openUi, function() 
  if not user_id then 
    TriggerEvent("Notify", "negado","Você não foi autenticado ainda.")
    return false 
  end
  if uiStatus then return false end 
  uiStatus = true 
  SetTimecycleModifier("hud_def_blur")
  local coin = zSERVER.openUi(user_id)
  SetNuiFocus(true,true)
  SetTimecycleModifierStrength(1.0)
  SendNUIMessage({
    event = 'open',
    coins = coin.coins
  })
end)

RegisterNUICallback("loadConfig", function(data,cb) 
  local info = cfg
  for k,v in pairs(info.roulette.items) do 
    info.roulette.items[k].position = k
    for i,u in pairs(v) do 
      if i == 'temporary' or type(u) == 'function' then   
        info.roulette.items[k][i] = nil 
      end
     end
   end
  for k,v in pairs(info.products) do 
    for i = 1,#info.products[k]  do 
        info.products[k][i].position = i
        for j,u in pairs(info.products[k][i]) do 
            if type(u) == "function" or j == 'temporary' then 
              info.products[k][i][j] = nil
            end
        end
    end
  end
  SendNUIMessage({
    event   = 'setup',
    config  =  json.encode(info)
  })
end)

RegisterNUICallback("close", function(data,cb) 
  if not data then 
    
  end
  ClearPedTasks(PlayerPedId())
  ClearTimecycleModifier()
  uiStatus = false 
  SetNuiFocus(false, false)
  cb('ok')
end)

RegisterNUICallback("playSound", function(data,cb) 
  
  if data.action == "buy" then 
    PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
  elseif data.action == "error" then 
    if data.error then 
      TriggerEvent("Notify","negado",data.error)
    end
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
  elseif data.action == "click" then 
    PlaySoundFrontend(-1, "TENNIS_POINT_WON", "HUD_AWARDS",true)      
    PlaySound(-1, "Event_Message_Purple","GTAO_FM_Events_Soundset", 0, 0, 1)
  elseif data.action == "select" then 
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
  end
end)

RegisterNUICallback("rewardReedem", function(data,cb) 
  if(data.index) then 
    vRP._playAnim(false,{{selectedDict,"Win_Big"}},false)
    cb(zSERVER.giveRouletteReward({index = data.index}))
  end
end)

RegisterNUICallback("buyProduct", function(data,cb) 
  local retorno       = (zSERVER.buyProduct(data))
  local category      = data.category
  local productTable  = cfg.products[category][data.index]
  if retorno.success and productTable.onBuy then productTable.onBuy() end
  cb(retorno)
end)

RegisterNUICallback("tryOpenBox", function(data,cb) 
  vRP._playAnim(false,{{selectedDict,"SpinningIDLE_High"}},true)
  if(data.multiplier) then 
    local retorno = zSERVER.tryOpenBox(cfg.roulette.price * data.multiplier)
    if retorno.success then 
      vRP._playAnim(false,{{selectedDict,"SpinningIDLE_High"}},true)
    end
    cb(retorno)
  end
end)

function zCLIENT.updateCoin(coins)
  SendNUIMessage({event = 'updateCoin', coins = coins})
end

function requireData()
  selectedDict = ((GetEntityModel(PlayerPedId()) == 1885233650) and 'ANIM_CASINO_A@AMB@CASINO@GAMES@LUCKY7WHEEL@MALE' or 'ANIM_CASINO_A@AMB@CASINO@GAMES@LUCKY7WHEEL@FEMALE')
  if user_id then return false end;
  local data = zSERVER.getEval()
  if data.user_id then 
    user_id = data.user_id 
  else 
    SetTimeout(5000, requireData)
  end
  local appointaments = data.appointaments
  if appointaments then
    for k,v in ipairs(appointaments) do 
      if v.temporary.onRemove then 
        v.temporary.onRemove(nil,user_id)
      end
    end
  end
end

RegisterNetEvent(zCoins..':notifyAll',function(data) 
  SendNUIMessage({
    event = 'notify',
    info = data,
    opened = uiStatus
  })
end)

CreateThread(function() 
  while not zSERVER do 
    Wait(1000) 
  end 
  requireData()
  return;
end)