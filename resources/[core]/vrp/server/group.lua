local permissions = {}

function vRP.hasPermission(user_id, permission)
	local consult = vRP.query('vRP/get_group', { user_id = user_id, permission = tostring(permission) })
	if consult[1] then
		return true
	else
		return false
	end
end

function vRP.getUsersByPermission(perm)
	local users = {}
	for k,v in pairs(vRP.rusers) do
		if vRP.hasPermission(tonumber(k),perm) then
			table.insert(users,tonumber(k))
		end
	end
	return users
end

function vRP.numPermission(perm)
	local users = {}
	for k, v in pairs(permissions) do
		if v == perm then
			table.insert(users, parseInt(k))
		end
	end
	return users
end

function vRP.insertPermission(user_id, permission)
	local consult = vRP.query('vRP/get_group', {user_id = user_id, permission = tostring(permission)})
	if not consult[1] then
		vRP.execute('vRP/add_group', {user_id = user_id, permission = tostring(permission)})
	end
end

function vRP.removePermission(user_id, permission)
	local consult = vRP.query('vRP/get_group', {user_id = user_id, permission = tostring(permission)})
	if consult[1] then
		vRP.execute('vRP/del_group', {user_id = user_id, permission = tostring(permission)})
	end
end

AddEventHandler('vRP:playerLeave', function(user_id, source)
	if permissions[tostring(source)] then
		permissions[tostring(source)] = nil
	end
end)