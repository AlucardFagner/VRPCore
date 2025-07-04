cfg = cfg or {}

-- local isServer = IsDuplicityVersion()

cfg.storeUrl = "https://discord.gg/ziraflix"

cfg.columnName = "coins"

cfg.commands = {
  openUi = "coins" --[[ /loja ]],
  admin = {
    give = {
      command = "givecoin",
      permission = "Gerente",
    },
    remove = {
      command = "removecoin",
      permission = "Gerente",
    },
    set = {
      command = "setcoin",
      permission = "Gerente",
    },
    giveall = {
      command = "coinstoall",
      permission = "Gerente",
    }
  }
}

-- if isServer then 
   
-- end


cfg.roulette = {
  price = 500,
  types = {
    ["lendario"] = {
      porcent = 0.1,
      notifyAll = {
        chat = {
          enabled = true,
          message = "{nome} {sobrenome} pegou um item LENDÁRIO na Roleta da Sorte! ({item})",
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(255, 200, 0, 1) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>'
        }, 
        notify = true
      },
    },
    ["epico"] = {
      porcent = 0.2,
      notifyAll = {
        chat = {
          enabled = true,
          message = "{nome} {sobrenome} pegou um item ÉPICO na Roleta da Sorte! ({item})",
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(255, 0, 43, 0.8) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>'
        }, 
        notify = true
      },
    },
    ["raro"] = {
      porcent = 0.6,
      notifyAll = {
        chat = {
          enabled = true,
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, #00ddff 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>',
          message = "{nome} {sobrenome} pegou um item RARO na Roleta da Sorte! ({item})"
        }, 
        notify = true
      },
    },
    ["normal"] = {
      porcent = 30.0,
      notifyAll = {
        chat = {
          chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(42,255,142,1) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>',
          enabled = false,
          message = "{nome} {sobrenome} pegou um item NORMAL na Roleta da Sorte! ({item})"
        }, 
        notify = true
      },
    }
  },
  items = {
      {
        productType = "item",
        idname = "fichas",
        name = "100K Fichas",
        amount = 100000,
        type = "normal",
      }, 
      {
        productType = "item",
        idname = "vale50bela",
        name = "Vale R$50",
        amount = 1,
        type = "raro",
      }, 
      {
        productType = "item",
        idname = "vale75bela",
        name = "Vale R$75",
        amount = 1,
        type = "raro",
      },
      {
        productType = "item",
        idname = "vale100bela",
        name = "Vale R$100",
        amount = 1,
        type = "epico",
      },
      {
        productType = "item",
        idname = "vale125bela",
        name = "Vale R$125",
        amount = 1,
        type = "epico",
      },
      {
        productType = "item",
        idname = "vale150bela",
        name = "Vale R$150",
        amount = 1,
        type = "epico",
      },
      {
        productType = "item",
        idname = "vale200bela",
        name = "Vale R$200",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "item",
        idname = "vale300bela",
        name = "Vale R$300",
        amount = 1,
        type = "lendario",
      },
      {
        productType = "item",
        idname = "vale400bela",
        name = "Vale R$400",
        amount = 1,
        type = "lendario",
      },
      --[[{
        productType = "item",
        idname = "vipouro",
        name = "vipouro",
        amount = 1,
        type = 'epico',
        onBuy = function(source,user_id)
          if isServer then 
            local user_id = vRP.getUserId(source)
            vRP.addUserGroup(user_id,"Platinum")
            vRP.giveMoney(user_id,10000)
            cfg.giveCar({user_id = user_id, model = "x6m"})
            --execute this content server-side after buy action
          else 
            --execute this content client-side after buy action
          end
        end,
        temporary = {
          enable = true,
          days = 10,
          onRemove = function(source,user_id)
            if isServer then 
            vRP.removeUserGroup(user_id,"Platinum")
            vRP.removeUserGroup(user_id,"Barco")
            end
          end
        },
      },]]--
      --[[{
        productType = "item",
        idname = "vipdiamante",
        name = "vipdiamante",
        amount = 1,
        type = 'lendario',
        onBuy = function(source,user_id)
          if isServer then 
            local user_id = vRP.getUserId(source)
            vRP.addUserGroup(user_id,"Diamond")
            vRP.giveMoney(user_id,100000)
            --execute this content server-side after buy action
          else 
            --execute this content client-side after buy action
          end
        end,
        temporary = {
          enable = true,
          days = 10,
          onRemove = function(source,user_id)
          end
        },
      },]]--
  }
}


cfg.coinName = 'Coins'

cfg.products = {
  ["Itens"] = {
    --[[{
      productType = "item",
      idname = "vipdiamante",
      name = "VIP Diamante",
      amount = 10,
      price = 3000,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          vRP.addUserGroup(user_id,"Platina")
          vRP.giveMoney(user_id,1000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end,
      temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },
    },]]--
      {
      productType = "item",
      idname = "verificadoinstagram",
      name = "Verify Insta",
      amount = 1,
      price = 200,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          vRP.addUserGroup(user_id,"InstaVerify")
          --vRP.giveMoney(user_id,1000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "2milhoes",
      name = "$2.000.000",
      amount = 1,
      price = 1000,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          --vRP.addUserGroup(user_id,"InstaVerify")
          vRP.giveMoney(user_id,2000000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "5milhoes",
      name = "$5.000.000",
      amount = 1,
      price = 2000,
      onBuy = function(source,user_id)
        if isServer then 
          local user_id = vRP.getUserId(source)
          --vRP.addUserGroup(user_id,"InstaVerify")
          vRP.giveMoney(user_id,5000000)
          --execute this content server-side after buy action
        else 
          --execute this content client-side after buy action
        end
      end
      --[[temporary = {
        enable = true,
        days = 10,
        onRemove = function(source,user_id)
        end
      },]]--
    },
    {
      productType = "item",
      idname = "suspensaoar",
      amount = 1,
      name = "Suspensão Ar",
      price = 200,
    },
    {
      productType = "item",
      idname = "bisturi",
      amount = 1,
      name = "Bisturi",
      price = 100,
    }
  },
  ["Veiculos"] = {
    {
      productType = "car",
      model = "lancerevolutionx",
      name = "Lancer Evolution X",
      price = 1250,
    },
    {
      productType = "car",
      model = "rmodgt63",
      name = "Mercedes AMG C63",
      price = 1500,
    },
    {
      productType = "car",
      model = "pistaspider19",
      name = "Ferrari Pista",
      price = 1500,
    },
    {
      productType = "car",
      model = "g65amg",
      name = "Mercedes AMG G65",
      price = 1600,
    },
    {
      productType = "car",
      model = "bmwg07",
      name = "BMW X7",
      price = 1400,
    },
    {
      productType = "car",
      model = "brickade",
      name = "Caminhão Seguro",
      price = 2150,
    },
    {
      productType = "car",
      model = "rmodjeep",
      name = "Jeep",
      price = 1400,
    },
    {
      productType = "car",
      model = "rs3sedan",
      name = "Audi RS3",
      price = 1500,
    },
    {
      productType = "car",
      model = "m135iwb",
      name = "BMW 135i M",
      price = 1500,
    },
    {
      productType = "car",
      model = "rmodbiposto",
      name = "Fiat 500",
      price = 1500,
    },
    {
      productType = "car",
      model = "rmodskyline34",
      name = "Nissan Skyliner 34",
      price = 1500,
    },
    {
      productType = "car",
      model = "regera",
      name = "Regera",
      price = 1500,
    },
    {
      productType = "car",
      model = "golf7gti",
      name = "Golf GTI",
      price = 1500,
    },
    {
      productType = "car",
      model = "rmodbmwm8",
      name = "BMW M8",
      price = 2000,
    },
    {
      productType = "car",
      model = "palameila",
      name = "Porsche Panamera",
      price = 2000,
    },
    {
      productType = "car",
      model = "18macan",
      name = "Porsche Macan",
      price = 2000,
    },
    {
      productType = "car",
      model = "rmodgtr50",
      name = "Nissan GTR50",
      price = 2000,
    },
    {
      productType = "car",
      model = "rs7c8wb",
      name = "Audi RS7",
      price = 1500,
    },
    {
      productType = "car",
      model = "v4r",
      name = "Ducati V4R",
      price = 1000,
    },
  }
}

cfg.imagesUrl = "127.0.0.1/images/roleta"


cfg.identity = {
  sobrenome = "firstname", --[[ Nome do campo de sobrenome, nome baseado nas tabelas.]]
  nome      = "name",
}


cfg.onlyNotifyPlayersOnStore = true --

cfg.webhooks = {
  buy = "", -- compras feitas na loja da roleta
  roulette = "",  -- prêmios da roleta
  commands = "",  -- comandos utiizados da roleta
  onremove = "",  -- comando de remoção da roleta
  info = {
    title  = 'Coins',
    footer = ''
  }
}

return cfg