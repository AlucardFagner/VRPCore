function vRP.getPremiumById(user_id)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		local consult = vRP.getPlayer(identity.steam)
		if consult[1] and os.time() >= (consult[1].premium + 24 * consult[1].premium_days * 60 * 60) then
			return false
		else
			return true
		end
	end
end

function vRP.getPremiumBySteam(steam)
	local consult = vRP.getPlayer(steam)
	if consult[1] and os.time() >= (consult[1].premium + 24 * consult[1].premium_days * 60 * 60) then
		return false
	else
		return true
	end
end

function vRP.getVehiclePremium(car, user_id)
	local rows2 = vRP.query('vRP/get_vehicle_by_plate', { plate = plate })
    if #rows2 then 
		for k, v in pairs(rows2) do
			if v.vehicle == car then
            	if os.time() >= (v.premiumtime + 24 * 30 * 60 * 60) then
					return true
				else
					return false
				end
			end
        end
    end
end