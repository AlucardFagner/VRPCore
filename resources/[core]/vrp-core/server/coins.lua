function vRP.getCoins(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local infos = vRP.query('vRP/get_player', { steam = identity.steam })
		if infos[1] then
			return infos[1].coins
		end
	end
end

function vRP.remCoins(user_id, amount)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local infos = vRP.query('vRP/get_vrp_infos', { steam = identity.steam })						
        if infos[1].gems >= amount then
			vRP.execute('vRP/rem_coins', { steam = identity.steam, coins = parseInt(amount) })
			return true
		end
		return false
	end
end

function vRP.addCoins(user_id, amount)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		vRP.execute('vRP/add_coins', { steam = identity.steam, coins = parseInt(amount) })
		return true
	end
end