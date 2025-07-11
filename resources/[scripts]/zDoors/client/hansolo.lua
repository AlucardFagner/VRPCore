local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

src = {}
Tunnel.bindInterface('zDoors', src)
zSERVER = Tunnel.getInterface('zDoors')

local doors = config.doorsList

RegisterNetEvent('zDoors:doorsUpdate')
AddEventHandler('zDoors:doorsUpdate', function(status)
	doors = status
end)

RegisterNetEvent('zDoors:Update')
AddEventHandler('zDoors:Update', function(number, status)
	if doors ~= nil then
		doors[number]['lock'] = status
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if doors ~= nil then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			for k, v in pairs(doors) do
				local distance = #(coords - vector3(v['x'], v['y'], v['z']))
				if distance <= v['distance'] then
					local closestDoor = GetClosestObjectOfType(v['x'], v['y'], v['z'], v['distance'] + 0.0, v['hash'], false, false, false)
					if closestDoor then
						if v['lock'] then
							local _, h = GetStateOfClosestDoorOfType(v['hash'], v['x'], v['y'], v['z'])
							if h > -0.02 and h < 0.02 then
								FreezeEntityPosition(closestDoor, true)
							end
						else
							FreezeEntityPosition(closestDoor, false)
						end

						if distance <= v['press'] then
							timeDistance = 4
							
							if v['text'] then
								if v['lock'] then
									DrawText3D(v['x'], v['y'], v['z'], '~r~FECHADA')
								else
									DrawText3D(v['x'], v['y'], v['z'], '~g~ABERTA')
								end
							end

							if IsControlJustPressed(1, 38) and zSERVER.doorsPermission(k) then
								v['lock'] = not v['lock']
								vRP.playAnim(true, {'anim@heists@keycard@', 'exit'}, false)
								zSERVER.doorsStatistics(k, v['lock'])
								Citizen.Wait(350)
								vRP.stopAnim()
							end
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)

	if onScreen then
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255, 255, 255, 150)
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x, _y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x, _y + 0, 1, width, 0, 0, 0, 0, 150)
	end
end