Proxy = module('vrp', 'lib/Proxy')
Tunnel = module('vrp', 'lib/Tunnel')
vRP = Proxy.getInterface('vRP')

zCLIENT = {}
Tunnel.bindInterface('zOrg', zCLIENT)
zSERVER = Tunnel.getInterface('zOrg')

RegisterNUICallback('closeInterface', function(data, cb)
	SetNuiFocus(false, false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = 'hideInterface' })
end)

RegisterNUICallback('inviteMember', function(data)
	zSERVER.invitePlayer(data.id)
end)

RegisterNUICallback('updatePaycheck', function(data)
	zSERVER.updatePaycheck(data.id, data.amount, data.org)
end)

RegisterNUICallback('updateRole', function(data)
	zSERVER.updateRole(data.id, data.org)
end)

RegisterNUICallback('dongradeRole', function(data)
	zSERVER.dongradeRole(data.id, data.org)
end)

RegisterNUICallback('withdraw', function(data)
	zSERVER.withdraw(data.amount, data.org)
end) 

RegisterNUICallback('deposit', function(data)
	zSERVER.deposit(data.amount, data.org)
end) 

RegisterNUICallback('requestData', function(data, cb)
	local players, members, orgname = zSERVER.getData(data.org)
	if players then
		cb({players = players, members = members, orgname = orgname})
	end
end)

RegisterNUICallback('requestDataMember', function(data, cb)
	local id, name, paycheck, orgname = zSERVER.getDataMember(data.id, data.org)
	if id then
		cb({id = id, name = name, paycheck = paycheck, orgname = orgname})
	end
end)

RegisterNUICallback('requestDataOrg', function(data, cb)
	local members, balance, orgname = zSERVER.getDataOrg(data.org)
	if members then
		cb({members = members, balance = balance, orgname = orgname})
	end
end)

RegisterNetEvent('zOrg:ShowInterface')
AddEventHandler('zOrg:ShowInterface', function(org)
	if not IsPlayerFreeAiming(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 101 then
		SetNuiFocus(true, true)
		SendNUIMessage({ action = 'showInterface', org = org})
	end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30*60000)
		TriggerServerEvent("zOrg:autoPayment")
	end
end)