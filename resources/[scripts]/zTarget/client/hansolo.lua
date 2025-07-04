local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')

local Zones = {}
local Models = {}
local success = false
local innerEntity = {}
local dismantleList = {}
local setDistance = 10.0
local playerActive = true
local targetActive = false
local adminService = false
local policeService = false
local paramedicService = false

local paramedicMenu = {
	{
		event = 'paramedic:reanimar',
		label = 'Reanimar',
		tunnel = 'paramedic'
	},
	{
		event = 'paramedic:diagnostico',
		label = 'Diagnóstico',
		tunnel = 'paramedic'
	},
	{
		event = 'paramedic:tratamento',
		label = 'Tratamento',
		tunnel = 'paramedic'
	},
	{
		event = 'paramedic:sangramento',
		label = 'Sangramento',
		tunnel = 'paramedic'
	},
	{
		event = 'paramedic:maca',
		label = 'Deitar Paciente',
		tunnel = 'paramedic'
	}
}

local policeVeh = {
	{
		event = 'police:runPlate',
		label = 'Verificar Placa',
		tunnel = 'police'
	},
	{
		event = 'police:impound',
		label = 'Registrar Veículo',
		tunnel = 'police'
	},
	{
		event = 'police:runArrest',
		label = 'Detenção do Veículo',
		tunnel = 'police'
	}
}

local policePed = {
	{
		event = 'police:runInspect',
		label = 'Revistar',
		tunnel = 'police'
	},
	{
		event = 'police:prisonClothes',
		label = 'Uniforme do Presídio',
		tunnel = 'police'
	}
}

local adminMenu = {
	{
		event = 'tryDeleteObject',
		label = 'Deletar Objeto',
		tunnel = 'admin'
	},
	{
		event = 'garages:deleteVehicle',
		label = 'Deletar Veículo',
		tunnel = 'admin'
	}
}

local userVeh = {
	{
		event = 'zInventory:openTrunkchest',
		label = 'Abrir porta-malas',
		tunnel = 'client'
	}
}

local chairs = {
	[-171943901] = 0.0,
	[-109356459] = 0.5,
	[1805980844] = 0.5,
	[-99500382] = 0.3,
	[1262298127] = 0.0,
	[1737474779] = 0.5,
	[2040839490] = 0.0,
	[1037469683] = 0.4,
	[867556671] = 0.4,
	[-1521264200] = 0.0,
	[-741944541] = 0.4,
	[-591349326] = 0.5,
	[-293380809] = 0.5,
	[-628719744] = 0.5,
	[-1317098115] = 0.5,
	[1630899471] = 0.5,
	[38932324] = 0.5,
	[-523951410] = 0.5,
	[725259233] = 0.5,
	[764848282] = 0.5,
	[2064599526] = 0.5,
	[536071214] = 0.5,
	[589738836] = 0.5,
	[146905321] = 0.5,
	[47332588] = 0.5,
	[-1118419705] = 0.5,
	[538002882] = -0.1,
	[-377849416] = 0.5,
	[96868307] = 0.5
}

local beds = {
	[1631638868] = { 0.0, 0.0 },
	[2117668672] = { 0.0, 0.0 },
	[-1498379115] = { 1.0, 90.0 },
	[-1519439119] = { 1.0, 0.0 },
	[-289946279] = { 1.0, 0.0 }
}

RegisterNUICallback('selectTarget', function(data, cb)
	success = false
	targetActive = false
	SetNuiFocus(false, false)
	local ped = PlayerPedId()
	SendNUIMessage({ response = 'closeTarget' })

	if data['tunnel'] == 'client' then
		TriggerEvent(data['event'], innerEntity)
	elseif data['tunnel'] == 'paramedic' then
		TriggerServerEvent(data['event'], innerEntity[1])
	elseif data['tunnel'] == 'police' then
		TriggerServerEvent(data['event'], innerEntity, data['service'])

		if data['service'] then
			SetEntityHeading(ped, innerEntity[5])
		end
	elseif data['tunnel'] == 'objects' then
		TriggerServerEvent(data['event'], innerEntity[3])
	elseif data['tunnel'] == 'admin' then
		TriggerServerEvent(data['event'], innerEntity[1], innerEntity[2])
	else
		TriggerServerEvent(data['event'])
	end
end)

RegisterNUICallback('closeTarget', function(data, cb)
	success = false
	targetActive = false
	SetNuiFocus(false, false)
end)

function RemoveTargetModel(models)
	for k, v in pairs(models) do
		if Models[v] then
			Models[v] = nil
		end
	end
end

function playerTargetDisable()
	if success or not targetActive then
		return
	end

	if targetActive then
		targetActive = false
		SendNUIMessage({ response = 'closeTarget' })
	end
end

function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation['x'],
		y = (math.pi / 180) * rotation['y'],
		z = (math.pi / 180) * rotation['z']
	}

	local direction = {
		x = -math.sin(adjustedRotation['z']) * math.abs(math.cos(adjustedRotation['x'])),
		y = math.cos(adjustedRotation['z']) * math.abs(math.cos(adjustedRotation['x'])),
		z = math.sin(adjustedRotation['x'])
	}

	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraCoord = GetGameplayCamCoord()
	local cameraRotation = GetGameplayCamRot()
	local direction = RotationToDirection(cameraRotation)

	local destination = {
		x = cameraCoord['x'] + direction['x'] * distance,
		y = cameraCoord['y'] + direction['y'] * distance,
		z = cameraCoord['z'] + direction['z'] * distance
	}

	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord['x'], cameraCoord['y'], cameraCoord['z'], destination['x'], destination['y'], destination['z'], -1, PlayerPedId(), 0))

	return b, c, e
end

function AddCircleZone(name, center, radius, options, targetoptions)
	Zones[name] = CircleZone:Create(center, radius, options)
	Zones[name]['targetoptions'] = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
	Zones[name] = BoxZone:Create(center, length, width, options)
	Zones[name]['targetoptions'] = targetoptions
end

function AddPolyzone(name, points, options, targetoptions)
	Zones[name] = PolyZone:Create(points, options)
	Zones[name]['targetoptions'] = targetoptions
end

function AddTargetModel(models, parameteres)
	for k, v in pairs(models) do
		Models[v] = parameteres
	end
end

function playerTargetEnable()
	if playerActive then
		if success or IsPedArmed(PlayerPedId(), 6) or IsPedInAnyVehicle(PlayerPedId()) then
			return
		end

		innerEntity = {}
		targetActive = true

		SendNUIMessage({ response = 'openTarget' })

		while targetActive do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

			if hit == 1 then
				if GetEntityType(entity) ~= 0 then
					if adminService then
						if DoesEntityExist(entity) then
							if #(coords - entCoords) <= setDistance then
								success = true

								NetworkRegisterEntityAsNetworked(entity)
								while not NetworkGetEntityIsNetworked(entity) do
									NetworkRegisterEntityAsNetworked(entity)
									Citizen.Wait(1)
								end

								local netObjects = NetworkGetNetworkIdFromEntity(entity)
								SetNetworkIdCanMigrate(netObjects, true)
								NetworkSetNetworkIdDynamic(netObjects, false)
								SetNetworkIdExistsOnAllMachines(netObjects, true)

								if IsEntityAVehicle(entity) then
									innerEntity = { netObjects, GetVehicleNumberPlateText(entity) }
								else
									innerEntity = { netObjects }
								end

								SendNUIMessage({ response = 'validTarget', data = adminMenu })

								while success and targetActive do
									local ped = PlayerPedId()
									local coords = GetEntityCoords(ped)
									local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

									DisablePlayerFiring(ped, true)

									if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
										SetCursorLocation(0.5, 0.5)
										SetNuiFocus(true, true)
									end

									if GetEntityType(entity) == 0 or #(coords - entCoords) > setDistance then
										success = false
									end

									Citizen.Wait(1)
								end

								SendNUIMessage({ response = 'leftTarget' })
							end
						end
					elseif IsEntityAVehicle(entity) and policeService then
						if #(coords - entCoords) <= 1.0 then
							success = true

							innerEntity = { GetVehicleNumberPlateText(entity), vRP.vehicleModel(GetEntityModel(entity)) }
							SendNUIMessage({ response = 'validTarget', data = policeVeh })

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped, true)

								if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
									SetCursorLocation(0.5, 0.5)
									SetNuiFocus(true, true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = 'leftTarget' })
						end
					elseif IsEntityAVehicle(entity) and not policeService and not paramedicService and not adminService then
						if #(coords - entCoords) <= 1.0 then
							success = true

							innerEntity = { GetVehicleNumberPlateText(entity), vRP.vehicleModel(GetEntityModel(entity)) }
							SendNUIMessage({ response = 'validTarget', data = userVeh })

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped, true)

								if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
									SetCursorLocation(0.5, 0.5)
									SetNuiFocus(true, true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = 'leftTarget' })
						end
					elseif IsPedAPlayer(entity) and policeService then
						if #(coords - entCoords) <= 1.0 then
							local index = NetworkGetPlayerIndexFromPed(entity)
							local source = GetPlayerServerId(index)

							success = true
							innerEntity = { source }
							SendNUIMessage({ response = 'validTarget', data = policePed })

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped, true)

								if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
									SetCursorLocation(0.5, 0.5)
									SetNuiFocus(true, true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = 'leftTarget' })
						end
					elseif IsPedAPlayer(entity) and paramedicService then
						if #(coords - entCoords) <= 1.0 then
							local index = NetworkGetPlayerIndexFromPed(entity)
							local source = GetPlayerServerId(index)

							success = true
							innerEntity = { source, entity }
							SendNUIMessage({ response = 'validTarget', data = paramedicMenu })

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped, true)

								if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
									SetCursorLocation(0.5, 0.5)
									SetNuiFocus(true, true)
								end

								if GetEntityType(entity) == 0 or #(coords - entCoords) > 1.0 then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = 'leftTarget' })
						end
					else
						for k, v in pairs(Models) do
							if k == GetEntityModel(entity) then
								if #(coords - entCoords) <= Models[k]['distance'] then

									if Models[k]['desmanche'] then
										local distance = #(coords - vector3(2413.07, 3139.35, 48.19))
										if distance > 10 then
											goto scapeModel
										end
									end

									success = true

									NetworkRegisterEntityAsNetworked(entity)
									while not NetworkGetEntityIsNetworked(entity) do
										NetworkRegisterEntityAsNetworked(entity)
										Citizen.Wait(1)
									end

									local netObjects = NetworkGetNetworkIdFromEntity(entity)
									SetNetworkIdCanMigrate(netObjects, true)
									NetworkSetNetworkIdDynamic(netObjects, false)
									SetNetworkIdExistsOnAllMachines(netObjects, true)

									innerEntity = { entity, k, netObjects, GetEntityCoords(entity), GetEntityHeading(entity) }
									SendNUIMessage({ response = 'validTarget', data = Models[k]['options'] })

									while success and targetActive do
										local ped = PlayerPedId()
										local coords = GetEntityCoords(ped)
										local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

										DisablePlayerFiring(ped, true)

										if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
											SetCursorLocation(0.5, 0.5)
											SetNuiFocus(true, true)
										end

										if GetEntityType(entity) == 0 or #(coords - entCoords) > Models[k]['distance'] then
											success = false
										end

										Citizen.Wait(1)
									end

									SendNUIMessage({ response = 'leftTarget' })
								end
							end
						end

						::scapeModel::
					end
				end

				for k, v in pairs(Zones) do
					if Zones[k]:isPointInside(entCoords) then
						if #(coords - Zones[k]['center']) <= v['targetoptions']['distance'] then
							success = true

							SendNUIMessage({ response = 'validTarget', data = Zones[k]['targetoptions']['options'] })

							while success and targetActive do
								local ped = PlayerPedId()
								local coords = GetEntityCoords(ped)
								local hit, entCoords, entity = RayCastGamePlayCamera(setDistance)

								DisablePlayerFiring(ped, true)

								if (IsControlJustReleased(1, 24) or IsDisabledControlJustReleased(1, 24)) then
									SetCursorLocation(0.5, 0.5)
									SetNuiFocus(true, true)
								end

								if not Zones[k]:isPointInside(entCoords) or #(coords - Zones[k]['center']) > v['targetoptions']['distance'] then
									success = false
								end

								Citizen.Wait(1)
							end

							SendNUIMessage({ response = 'leftTarget' })
						end
					end
				end
			end

			Citizen.Wait(250)
		end
	end
end

RegisterNetEvent('police:updateService')
AddEventHandler('police:updateService', function(status)
	policeService = status
end)

RegisterNetEvent('paramedic:updateService')
AddEventHandler('paramedic:updateService', function(status)
	paramedicService = status
end)

RegisterNetEvent('vrp:playerActive')
AddEventHandler('vrp:playerActive', function()
	playerActive = true
end)

RegisterNetEvent('target:toggleAdmin')
AddEventHandler('target:toggleAdmin', function()
	if adminService then
		setDistance = 10.0
		adminService = false
		TriggerEvent('Notify', 'amarelo', 'Sistema desativado.', 5000)
	else
		setDistance = 99.0
		adminService = true
		TriggerEvent('Notify', 'verde', 'Sistema ativado.', 5000)
	end
end)

RegisterNetEvent('zTarget:animDeitar')
AddEventHandler('zTarget:animDeitar', function()
	if not exports['zPlayer']:blockCommands() and not exports['zPlayer']:handCuff() then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			local objCoords = GetEntityCoords(innerEntity[1])

			SetEntityCoords(ped, objCoords['x'], objCoords['y'], objCoords['z'] + beds[innerEntity[2]][1], 1, 0, 0, 0)
			SetEntityHeading(ped, GetEntityHeading(innerEntity[1]) + beds[innerEntity[2]][2] - 180.0)

			vRP.playAnim(false, {'anim@gangops@morgue@table@', 'body_search'}, true)
		end
	end
end)

RegisterNetEvent('target:pacienteDeitar')
AddEventHandler('target:pacienteDeitar', function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k, v in pairs(beds) do
		local object = GetClosestObjectOfType(coords['x'], coords['y'], coords['z'], 0.9, k, 0, 0, 0)
		if DoesEntityExist(object) then
			local objCoords = GetEntityCoords(object)

			SetEntityCoords(ped, objCoords['x'], objCoords['y'], objCoords['z'] + v[1], 1, 0, 0, 0)
			SetEntityHeading(ped, GetEntityHeading(object) + v[2] - 180.0)

			vRP.playAnim(false, {'anim@gangops@morgue@table@', 'body_search'}, true)
			break
		end
	end
end)

RegisterNetEvent('target:dismantleList')
AddEventHandler('target:dismantleList', function(tableList)
	RemoveTargetModel(dismantleList)

	AddTargetModel(tableList, {
		options = {
			{
				event = 'dismantle:checkVehicle',
				label = 'Desmanchar',
				tunnel = 'client'
			}
		},
		distance = 0.75,
		desmanche = true
	})
	dismantleList = tableList
end)

RegisterNetEvent('target:dismantleClear')
AddEventHandler('target:dismantleClear', function(model)
	if Models[model] then
		Models[model] = nil
	end
end)

RegisterNetEvent('zTarget:animSentar')
AddEventHandler('zTarget:animSentar', function()
	if (not exports['zPlayer']:blockCommands() and not exports['zPlayer']:handCuff()) then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			local objCoords = GetEntityCoords(innerEntity[1])

			FreezeEntityPosition(innerEntity[1], true)
			SetEntityCoords(ped, objCoords['x'], objCoords['y'], objCoords['z'] + chairs[innerEntity[2]], 1, 0, 0, 0)
			SetEntityHeading(ped, GetEntityHeading(innerEntity[1]) - 180.0)

			vRP.playAnim(false, { task = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER' }, false)
		end
	end
end)

Citizen.CreateThread(function()
	RegisterCommand('+entityTarget', playerTargetEnable)
	RegisterCommand('-entityTarget', playerTargetDisable)
	RegisterKeyMapping('+entityTarget', 'Target', 'keyboard', 'LMENU')
	dataTarget()
end)

exports('AddBoxZone', AddBoxZone)
exports('AddPolyzone', AddPolyzone)
exports('AddCircleZone', AddCircleZone)
exports('AddTargetModel', AddTargetModel)