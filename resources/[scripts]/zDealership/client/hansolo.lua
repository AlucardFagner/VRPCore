local Tunnel = module("vrp", "lib/Tunnel")
zSERVER = Tunnel.getInterface("zDealership")

local ultimo_veh
local perto = false
local build2060 = nil
local hash_list = {}
local vehs_list = {}
local object = {}
local rgb_color = { R = 255, G = 255, B = 255 }
local rgb_color2 = { R = 255, G = 255, B = 255 }
local blip 

RegisterNUICallback("rotate",function(data, cb)
    if (data["key"] == "left") then
        rotation(2)
    else
        rotation(-2)
    end
    cb("ok")
end)

RegisterNUICallback("SpawnVehicle", function(data, cb)
    att_veh(data.modelcar)
end)

RegisterNUICallback("RGBVehicle",function(data, cb)
    if data.primary then
        rgb_color = data
        SetVehicleCustomPrimaryColour(ultimo_veh, data.R, data.G, data.B)
    else
        rgb_color2 = data
        SetVehicleCustomSecondaryColour(ultimo_veh, data.R, data.G, data.B)
    end
end)

RegisterNUICallback("Buy",function(data, cb)
    TriggerServerEvent("zdealership-vehs:comprar", data.modelcar, data.sale*1000, data.name)
end)

RegisterNUICallback("menuSelected",function(data, cb)
    local categoryVehicles
    local playerIdx = GetPlayerFromServerId(source)
    local ped = GetPlayerPed(playerIdx)
    if data.menuId ~= 'all' then
        categoryVehicles = vehs_list[data.menuId]
    else
        SendNUIMessage({ data = vehs_list, type = "display", playerName = GetPlayerName(ped) })
        return
    end
    SendNUIMessage({ data = categoryVehicles, type = "menu"})
end)

RegisterNUICallback("Close",function(data, cb)
    closeNui()       
end)

function openNui()
    perto = true
    local ped = PlayerPedId()
    local nome, dinheiro = zSERVER.returnValues()
    TriggerServerEvent("zdealership-vehs:show")
    Citizen.Wait(1000)
    print(dinheiro)

    SendNUIMessage({ data = vehs_list, type = "display", playerName = nome, playerMoney = dinheiro })
    SetNuiFocus(true, true)
    RequestCollisionAtCoord(x, y, z)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 232.6, -988.99, -98.4, 117.27, 0.00, 0.00, 80.00, false, 0)
    PointCamAtCoord(cam, 224.62, -991.28, -98.99)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
    SetFocusPosAndVel(224.62, -991.28, -98.99, 0.0, 0.0, 0.0)
    DisplayHud(false)
    DisplayRadar(false)

    while perto do
        Citizen.Wait(0)        
    end

    if ultimo_veh ~= nil then
        DeleteEntity(ultimo_veh)
    end
end

function rotation(dir)
    local entityRot = GetEntityHeading(ultimo_veh) + dir
    SetEntityHeading(ultimo_veh, entityRot % 360)
end

function att_veh(model)
    local hash = GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    if ultimo_veh ~= nil then
        DeleteEntity(ultimo_veh)
    end
    ultimo_veh = CreateVehicle(hash, 227.4, -990.79, -98.99, 10, 0, 1)
    SetEntityHeading(ultimo_veh, 265.08)
end

function closeNui()
    SendNUIMessage({ type = "hide" })
    SetNuiFocus(false, false)
    if perto then
        if ultimo_veh ~= nil then
            DeleteEntity(ultimo_veh)
        end
        local ped = PlayerPedId()  
        RenderScriptCams(false)
        DestroyAllCams(true)
        ClearFocus()
        DisplayHud(true)
        DisplayRadar(true)
    end
    perto = false
end

RegisterNetEvent('zdealership-vehs:notify')
AddEventHandler('zdealership-vehs:notify', function(type, message)    
    SendNUIMessage({ type = "notify", typenotify = type, message = message, }) 
end)

RegisterNetEvent('zdealership-vehs:show_vehs')
AddEventHandler('zdealership-vehs:show_vehs', function(consulta)      

    for _,value in pairs(consulta) do
        vehs_list[value.category] = {}
    end

    for _,value in pairs(consulta) do

        local modelo = GetHashKey(value.model)
        local marca

        if build2060 then
            marca = GetLabelText(Citizen.InvokeNative(0xF7AF4F159FF99F97, modelo, Citizen.ResultAsString()))    
        else
            marca = nil
        end

        if marca == nil then
            marca = 'Desconhecida'
        end    

        local nome_veh   

        if GetLabelText(value.model) == "NULL" then
            nome_veh = value.model:gsub("^%l", string.upper)
        else 
            nome_veh = GetLabelText(value.model)
        end

        object = 
        {
            brand = marca,
            name = nome_veh,
            handling = 'none',
            topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(modelo)*3.605936),
            power = math.ceil(GetVehicleModelAcceleration(modelo)*1000),
            price = value.price,
            model = value.model,
            qtd = value.stock
        }
        table.insert(vehs_list[value.category], object)
    end
end)

RegisterNetEvent('zDealership:openNui')
AddEventHandler('zDealership:openNui', function()
    openNui()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        closeNui()
        RemoveBlip(blip)
    end
end)