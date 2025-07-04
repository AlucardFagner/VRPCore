local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

zSERVER = Tunnel.getInterface("zMilkman")

local service = false
local locations = 0
local check = 0
local blips = false
local hour = 0

local extract = {
	[1] = { ['x'] = 425.55, ['y'] = 6463.64, ['z'] = 28.79 }
}

function StartBlip(extract,locations)
	blips = AddBlipForCoord(extract[locations].x,extract[locations].y,extract[locations].z)
	SetBlipSprite(blips,433)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Ordenhar vaca")
	EndTextCommandSetBlipName(blips)
end

function makeBlipsServicesMilk()
	blips = AddBlipForCoord(config.deliverys[check][1],config.deliverys[check][2],config.deliverys[check][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,27)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregas")
	EndTextCommandSetBlipName(blips)
end

function drawTexts(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

RegisterNetEvent('zMilkman:StartJob')
AddEventHandler('zMilkman:StartJob', function()
	if not service then
		service = true
		locations = 1
		check = math.random(#config.deliverys)
		StartBlip(extract,locations)
		TriggerEvent("Notify","sucesso","Você entrou em serviço.",8000)
		SetTimeout(1000,function()
			TriggerEvent("Notify","informação","Vá até o local marcado para extrair o leite, após a extração inicie a rota de entrega.",8000)
		end)
	elseif service then
		service = false
		RemoveBlip(blips)
		TriggerEvent("Notify","importante","Você saiu do serviço.",8000)
	end
end)

RegisterNetEvent('zMilkman:CollectMaterial')
AddEventHandler('zMilkman:CollectMaterial', function()
	if service then
		service = true
		if zSERVER.checkPayment() then
			vRP.playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)						
			TriggerEvent("Notify","informação","Extraindo leite. Aguarde!",8000)
			SetTimeout(8000,function()
				vRP._stopAnim(source, upper)
				zSERVER.checkPayment()
				TriggerEvent("Notify","sucesso","Extração concluída!",8000)
			end)
		else
			TriggerEvent("Notify","negado","Você precisa de 3 Garrafas Vazias.",8000)
		end
	elseif not service then
		service = false
		TriggerEvent("Notify","negado","Você precisa entrar em serviço.",10000)
	end
end)

RegisterNetEvent('zMilkman:DeliveryRoute')
AddEventHandler('zMilkman:DeliveryRoute', function()
	if service then
		RemoveBlip(blips)
		SetTimeout(1000,function()
			CalculateTimeToDisplay()
			service = true
			check = math.random(#config.deliverys)
			makeBlipsServicesMilk()
			TriggerEvent("Notify","sucesso","Rota de entrega inciada.",8000)
		end)
	elseif not service then
		service = false
		TriggerEvent("Notify","negado","Você precisa entrar em serviço.",10000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if service then
			if not IsPedInAnyVehicle(ped) then
				local coord = GetEntityCoords(ped)
				local distance = #(coord - vector3(config.deliverys[check][1], config.deliverys[check][2], config.deliverys[check][3]))
				local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
				if distance < 15.1 then
					idle = 5
					DrawMarker(21,config.deliverys[check][1],config.deliverys[check][2],config.deliverys[check][3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,136, 96, 240, 180,0,0,0,1)
					if distance <= 1.2 then
						drawTexts("PRESSIONE  ~b~E~w~  PARA ENTREGAR GARRAFAS DE LEITE",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(1,38) then
							if lastVehicle == GetHashKey(config.vehicle) then
								CalculateTimeToDisplay()
								if zSERVER.startPayments() then
									RemoveBlip(blips)
									check = math.random(#config.deliverys)
									makeBlipsServicesMilk()
								end
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)