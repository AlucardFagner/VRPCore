local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
server = Tunnel.getInterface("zConstructor")
job = Tunnel.getInterface("zConstructor")

local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false

local construtor = {
	[1] = { ['x'] = 83.55, ['y'] = -374.17, ['z'] = 41.51 },
	[2] = { ['x'] = 81.99, ['y'] = -417.63, ['z'] = 37.56 },
	[3] = { ['x'] = 86.31, ['y'] = -442.71, ['z'] = 37.56 },
	[4] = { ['x'] = 90.72, ['y'] = -465.2, ['z'] = 37.86 },
	[5] = { ['x'] = 109.92, ['y'] = -363.3, ['z'] = 42.68 },
	[6] = { ['x'] = 123.13, ['y'] = -342.69, ['z'] = 42.99 },
	[7] = { ['x'] = 63.68, ['y'] = -336.31, ['z'] = 55.51 },
	[8] = { ['x'] = 40.09, ['y'] = -391.12, ['z'] = 39.93 },
	[9] = { ['x'] = 18.5, ['y'] = -447.27, ['z'] = 45.56 },
	[10] = { ['x'] = 30.2, ['y'] = -375.35, ['z'] = 45.51 },
	[11] = { ['x'] = 33.95, ['y'] = -454.65, ['z'] = 45.56 },
	[12] = { ['x'] = 17.71, ['y'] = -1300.08, ['z'] = 29.38 },
	[13] = { ['x'] = 60.41, ['y'] = -385.05, ['z'] = 45.69 },
	[14] = { ['x'] = 33.73, ['y'] = -388.9, ['z'] = 45.51 },
	[15] = { ['x'] = 5.54, ['y'] = -445.97, ['z'] = 39.78 },
	[16] = { ['x'] = 40.83, ['y'] = -393.63, ['z'] = 55.29 },
	[17] = { ['x'] = 5.8, ['y'] = -445.29, ['z'] = 55.23 }
}

function CriandoBlip(construtor,locais)
	blips = AddBlipForCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
	SetBlipSprite(blips,433)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Arrumar Encanamento")
	EndTextCommandSetBlipName(blips)
end

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.50,0.35)
	SetTextColour(255,255,255,500)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/0
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end

RegisterNetEvent('zContructor:StartJob')
AddEventHandler('zContructor:StartJob', function()
	if not servico then
		servico = true
		locais = 1
		CriandoBlip(construtor,locais)
		TriggerEvent("Notify","sucesso","Você entrou em serviço. Pegue suas ferramentas de trabalho.",18000)
	elseif servico then
		servico = false
		TriggerEvent('cancelando',false)
		RemoveBlip(blips)
		TriggerEvent("Notify", "importante", "Você encerrou seu expediente, obrigado por trabalhar conosco.",8000)
	end
end)

RegisterNetEvent('zContructor:CollectMaterial')
AddEventHandler('zContructor:CollectMaterial', function()
	local ped = PlayerPedId()
	if servico then
		balaka = 5
		vRP.playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
		TriggerEvent("Notify","progress","Coletando Equipamento",8000)
		SetTimeout(8000,function()
			vRP._stopAnim(source,false)
			server.giveFerramenta()
			TriggerEvent("Notify","sucesso","Adicionado 3x Ferramentas na mochila.",8000)
		end)
	elseif not servico then
		TriggerEvent("Notify","negado","Você não está em serviço para coletar a ferramenta.",8000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
			local distance = GetDistanceBetweenCoords(construtor[locais].x,construtor[locais].y,cdz,x,y,z,true)
			if distance < 10 then
				balaka = 1
				DrawMarker(20,construtor[locais].x,construtor[locais].y,construtor[locais].z+0.10,0,0,0,0,180.0,130.0,1.0,1.0,1.0,224, 50, 50, 255,1,0,0,1)
				if distance < 2 then
					balaka = 5
					DrawText3Ds(construtor[locais].x,construtor[locais].y,construtor[locais].z + 0.80,"~w~PRESSIONE ~g~E ~w~PARA CONSERTAR")
					if IsControlJustPressed(0, 38) then
						TriggerEvent("progress",10000,"Consertando...")
						RemoveBlip(blips)
						animacao = true
						if animacao then
							vRP.playAnim(false,{"amb@world_human_hammering@male@base","base"},true)
							Citizen.Wait(10000)
							vRP.stopAnim(false)
							server.checkPayment()
							animacao = false
							if locais == #construtor then
								locais = 1
							else
								locais = math.random(1,19)
							end
							CriandoBlip(construtor,locais)
							Desabilitar()
						end
					end	
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)