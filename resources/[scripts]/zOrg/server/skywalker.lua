local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zOrg', zSERVER)
zCLIENT = Tunnel.getInterface('zOrg')



RegisterCommand('org', function(source, args)
	local source = source
	local user_id = vRP.getUserId(source)
	for a, b in pairs(config.organizations) do
		for c, d in pairs(b.permissions) do
			if vRP.hasPermission(user_id, d[1]) then
				TriggerClientEvent('zOrg:ShowInterface', source, a)
			end
		end
	end
end)

function getMembers(name)
	local rows = vRP.query('vRP/get_org_members', {organization = name})
	if #rows > 0 then
		return json.decode(rows[1].members)
	else
		return {}
	end
end

function getVault(name)
	local rows = vRP.query('vRP/get_org_balance', {organization = name})
	if #rows > 0 then
		return rows[1].vault
	else
		return {}
	end
end

function setVault(organization, vault)
    vRP.execute('vRP/set_org_balance', { organization = organization, vault = vault })
end

function createOrg()
    local rows = vRP.query('vRP/select_org')
    for k,v in pairs(config.organizations) do
        local create = false
        for x,y in pairs(rows) do
            if rows[x].organization == k then
                create = true
                break
            end
        end
        if not create then
            vRP.execute('vRP/insert_org', {
                ['owner'] = 0,
                ['organization'] = k,
				['members'] = '[]',
                ['vault'] = v.initVault
            })
        end
    end
end

function zSERVER.getDataMember(id, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataOrg = getMembers(org)
		local nameTag = ''
		local paycheck = 0
		local idReady = 0
		for k, v in pairs(dataOrg) do
			if k == tostring(id) then
				idReady = k
				nameTag = v.name..', '..dataOrg[tostring(id)].role
				paycheck = v.paycheck
			end
		end
		return idReady, nameTag, paycheck, org
	end
end

function zSERVER.getDataOrg(org)
	local source = source
	local user_id = vRP.getUserId(source)
	local members = 0
	if user_id then
		local vault = getVault(org)
		local dataOrg = getMembers(org)
		for k, v in pairs(dataOrg) do
			members = members + 1
		end
		return members, vault, org
	end
end

function zSERVER.getData(org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local players = {}
		local members = {}
		for a, b in pairs(config.organizations) do
			if a == org then
				for c, d in pairs(b.permissions) do
					if vRP.hasPermission(user_id, d[1]) then
						local users = vRP.getUsers()
						local dataOrg = getMembers(org)
						for k, v in pairs(users) do
							local target = vRP.getUserSource(parseInt(k))
							if target then
								local target_id = vRP.getUserId(target)
								if target_id ~= user_id then
									if dataOrg[tostring(target_id)] == nil then
										local target_identity = vRP.getUserIdentity(target_id)
										table.insert(players, {passport = k, name = target_identity.name, firstname = target_identity.firstname})
									end
								end
							end
						end
				
						for k, v in pairs(dataOrg) do
							local target = vRP.getUserSource(parseInt(k))
							if target then
								local target_id = vRP.getUserId(target)
								local target_identity = vRP.getUserIdentity(target_id)
								local name = target_identity.name..' '..target_identity.firstname
								table.insert(members, {passport = k, name = name, role = v.role, paycheck = v.paycheck})
							else
								table.insert(members, {passport = k, name = v.name..' offline', role = v.role, paycheck = v.paycheck})
							end
						end
					end
				end
			end
		end
		return players, members, org
	end
end

function zSERVER.invitePlayer(id)
	local target = vRP.getUserSource(parseInt(id))
	if target then
		local target_id = vRP.getUserId(target)
		local target_identity = vRP.getUserIdentity(target_id)
		local request = vRP.request(target, 'Teste teste', 60)
		if request then
			local dataOrg = getMembers('bratva')
			if dataOrg ~= '[]' or dataOrg ~= nil then
				dataOrg[target_id] = {
					['name'] = target_identity.name..' '..target_identity.firstname,
					['roleValue'] = 1,
					['role'] = 'bratvaSoldado',
					['paycheck'] = 1000,
				}
				vRP.execute('vRP/insert_member', {
					['members'] = json.encode(dataOrg),
					['organization'] = 'bratva'
				})
			else
				local member = {
					[target_id] = {
						['name'] = target_identity.name..' '..target_identity.firstname,
						['roleValue'] = 1,
						['role'] = 'bratvaSoldado',
						['paycheck'] = 1000,
					}
				}
				vRP.execute('vRP/insert_member', {
					['members'] = json.encode(member),
					['organization'] = 'bratva'
				})
			end
		end
	end
end

function zSERVER.updatePaycheck(id, amount, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataOrg = getMembers(org)
		if dataOrg[tostring(user_id)].roleValue == 4 then
			dataOrg[tostring(id)].paycheck = parseInt(amount)
			vRP.execute('vRP/insert_member', {['members'] = json.encode(dataOrg), ['organization'] = org})
		else
			TriggerClientEvent('Notify', source, 'negado', 'Você não pode fazer isso!', 5000)
		end
	end
end

function zSERVER.updateRole(id, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataOrg = getMembers(org)
		if dataOrg[tostring(user_id)].roleValue == 4 then
			for a, b in pairs(config.organizations) do
				if a == org then
					for c, d in pairs(b.permissions) do
						if dataOrg[tostring(id)].roleValue < 4 then
							local newRole = parseInt(dataOrg[tostring(id)].roleValue + 1)
							if newRole == c then
								dataOrg[tostring(id)].roleValue = newRole
								dataOrg[tostring(id)].role = d[1]
								vRP.execute('vRP/insert_member', {['members'] = json.encode(dataOrg), ['organization'] = org})
							end
						else
							TriggerClientEvent('Notify', source, 'negado', 'Patente maxíma', 5000)
						end
					end
				end
			end
		else
			TriggerClientEvent('Notify', source, 'negado', 'Você não pode fazer isso!', 5000)
		end
	end
end

function zSERVER.dongradeRole(id, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataOrg = getMembers(org)
		if dataOrg[tostring(user_id)].roleValue == 4 then
			for a, b in pairs(config.organizations) do
				if a == org then
					for c, d in pairs(b.permissions) do
						if dataOrg[tostring(id)].roleValue > 1 then
							local newRole = parseInt(dataOrg[tostring(id)].roleValue - 1)
							if newRole == c then
								dataOrg[tostring(id)].roleValue = newRole
								dataOrg[tostring(id)].role = d[1]
								vRP.execute('vRP/insert_member', {['members'] = json.encode(dataOrg), ['organization'] = org})
							end
						else
							TriggerClientEvent('Notify', source, 'negado', 'Patente minima', 5000)
						end
					end
				end
			end
		else
			TriggerClientEvent('Notify', source, 'negado', 'Você não pode fazer isso!', 5000)
		end
	end
end

function zSERVER.withdraw(amount, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local bank = vRP.getBank(user_id)
		local vault = getVault(org)
		local dataOrg = getMembers(org)
		if dataOrg[tostring(user_id)].roleValue == 4 then
			if parseInt(amount) <= parseInt(vault) and parseInt(amount) > 0 then
				local newVault = parseInt(vault) - parseInt(amount)
				local newBank = parseInt(bank) + parseInt(amount)
				setVault(org, newVault)
				vRP.setBank(user_id, newBank)
			end
		else
			TriggerClientEvent('Notify', source, 'negado', 'Você não pode fazer isso!', 5000)
		end
	end
end

function zSERVER.deposit(amount, org)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local bank = vRP.getBank(user_id)
		local vault = getVault(org)
		if parseInt(amount) <= parseInt(bank) and parseInt(amount) > 0 then
			local newVault = parseInt(vault) + parseInt(amount)
			local newBank = parseInt(bank) - parseInt(amount)
			setVault(org, newVault)
			vRP.setBank(user_id, newBank)
		end
	end
end

RegisterNetEvent("zOrg:autoPayment")
RegisterCommand("zOrg:autoPayment",function(source)
	local user_id = vRP.getUserId(source) 
	local paycheck = nil
	if user_id then
		for a, b in pairs(config.organizations) do
			local dataOrg = getMembers(a)
			for c, d in pairs(dataOrg) do 
				if parseInt(user_id) == parseInt(c) then
					paycheck = d.paycheck
				end
			end
			if b.paymentcity then 
				vRP.tryGiveInventoryItem(user_id, 'dinheiro', paycheck, true)
				return
			else
				local balance = getVault(a)
				if balance >= paycheck then 
					local newbalance = balance - paycheck
					if setVault(a, newbalance) then
						vRP.tryGiveInventoryItem(user_id, 'dinheiro', paycheck, true)
						return
					end
				end
			end
			return false
		end
	end
end)

Citizen.CreateThread(function()
    createOrg()
end)


