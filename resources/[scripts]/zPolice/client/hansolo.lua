local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')
zSERVER = Tunnel.getInterface('zPolice')

local prisioneiro = false
local reducaopenal = false

RegisterCommand(config.CommandOpen,function(source,args,rawCommand)
    if zSERVER.checkPermission() then 
        vRP._playAnim(false,{{'anim@heists@prison_heistig1_p1_guard_checks_bus','loop'}},true)
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'abrirTablet'})
    end
end)

RegisterNUICallback('ButtonClick', function(data, cb)
    if data.action == 'fecharTablet' then
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharTablet'})
        ClearPedTasks(PlayerPedId())
    end

    if data.action == 'getPassaporte' then
        local identity, user_id, multas = zSERVER.Identidade(data.passaporte)
        SendNUIMessage({
            type = 'setPassaporte',
            identity = identity,
            user_id = user_id,
            multas = multas
        })
    end

    if data.action == 'getMultas' then
        local id = data.passaporte
        local multas = zSERVER.getFines(id)
        SendNUIMessage({type = 'setListaMultas', multas = multas})
    end

    if data.action == 'getPrisoes' then
        local prisoes = zSERVER.setRegistro(data.passaporte, 'ficha')
        SendNUIMessage({type = 'setListaPrisoes', prisoes = prisoes})
    end

    if data.action == 'getListafugitives' then
        local lista = zSERVER.getfugitives('fugitive')
        SendNUIMessage({type = 'getListafugitives', lista = lista})
    end

    if data.action == 'getListaOcorrencias' then
        local callback = zSERVER.getDatasUser(data.passaporte, 'ocorrencia')
        SendNUIMessage({
            type = 'getListaOcorrencias', 
            lista = callback
        })
    end

    if data.action == 'setMulta' then
        local img = nil
        zSERVER.setRegistro(data.passaporte, 'multa', data.descricao, img, data.valor)
        SendNUIMessage({type = 'reloadPassaporte'})
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharTablet'})
        ClearPedTasks(PlayerPedId())
    end

    if data.action == 'setOcorrencia' then
        zSERVER.setRegistro(data.passaporte, 'ocorrencia', data.descricao, data.img, data.valor)
        SendNUIMessage({type = 'reloadPassaporte'})
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharTablet'})
        ClearPedTasks(PlayerPedId())
    end

    if data.action == 'setfugitive' then
        zSERVER.setRegistro(data.passaporte, 'fugitive', data.descricao, data.img, data.valor)
        SendNUIMessage({type = 'reloadPassaporte'})
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharTablet'})
        ClearPedTasks(PlayerPedId())
    end

    if data.action == 'setPrisao' then
        zSERVER.setRegistro(data.passaporte, 'prisao', data.descricao, data.img, data.pena)
        if data.multa and data.multa > 0 then
            zSERVER.setRegistro(data.passaporte, 'multa', data.descricao, img, data.multa)
        end
        SendNUIMessage({type = 'reloadPassaporte'})
    end
end)

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
	if onScreen then
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)
		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

RegisterNetEvent('zPolice:Prisoner')
AddEventHandler('zPolice:Prisoner',function(status)
	prisioneiro = status
	reducaopenal = false
	local ped = PlayerPedId()
	if prisioneiro then
		SetEntityInvincible(ped,false)--mqcu
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		SetTimeout(10000,function()
			SetEntityInvincible(ped,false)
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true,false)
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
        local player = PlayerPedId()
		local idle = 1000
		if prisioneiro then
            local distance1 = #(GetEntityCoords(PlayerPedId()) - vector3(1691.59,2566.05,45.56))
            local distance2 = #(GetEntityCoords(PlayerPedId()) - vector3(1669.51,2487.71,45.82))
            local distance3 = #(GetEntityCoords(PlayerPedId()) - vector3(1700.5,2605.2,45.5))
			if GetEntityHealth(PlayerPedId()) <= 100 then
				reducaopenal = false
				vRP._DeletarObjeto()
			end
			if distance1 <= 100 and not reducaopenal then
                idle = 5
                DrawText3D(1691.59,2566.05,45.56,'~g~E~w~  PEGAR CAIXA')
				if distance1 <= 1.2 then
                    idle = 5
					if IsControlJustPressed(0,38) then
						reducaopenal = true
						ResetPedMovementClipset(player,0)
                        SetRunSprintMultiplierForPlayer(player,1.0)
						vRP._createObjects('anim@heists@box_carry@','idle','hei_prop_heist_box',50,28422)
					end
				end
			end
			if distance2 <= 100 and reducaopenal then
                idle = 5
                DrawText3D(1669.51,2487.71,45.82,'~g~E~w~  ENTREGAR CAIXA')
				if distance2 <= 1.2 then
                    idle = 5
					if IsControlJustPressed(0,38) then
						reducaopenal = false
						TriggerServerEvent('zPolice:ReducePrison')
						vRP._removeObjects()
					end
				end
			end
			if distance3 >= 150 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent('Notify','negado','O agente penitenciário encontrou você tentando escapar.',3000)
			end
		end
		Citizen.Wait(idle)
	end
end)