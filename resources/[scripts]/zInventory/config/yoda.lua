config = {}

config.imageService = 'http://images.ziraflix.com/itens'

--[[
    ['index do item'] = { 'não mexer!', 'não mexer!', 'não mexer!', 'Tomando', cede, fome, stress, item ganho após a ação, tempo energético, força do energético },
]]

config.backpackOnBody = true

config.NoStoreItem = {
	['cola'] = true,
	['soda'] = true,
	['coffee'] = true,
	['water'] = true,
	['dirtywater'] = true,
	['emptybottle'] = true,
	['hamburger'] = true,
	['tacos'] = true,
	['chocolate'] = true,
	['donut'] = true
}

config.noalcoholic_drinks = {
    ['agua'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_ld_flow_bottle', 'Tomando', 70, 0, 0, 'garrafa-vazia', 0, 0 },
    ['leite'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_energy_drink', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['cafe'] = { 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'prop_fib_coffee', 'Tomando', 70, 0, 0, nil, 30, 1.15 },
    ['cafecleite'] = { 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'prop_fib_coffee', 'Tomando', 70, 0, 0, nil, 30, 1.15 },
    ['cafeexpresso'] = { 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'prop_fib_coffee', 'Tomando', 70, 0, 0, nil, 30, 1.15 },
    ['capuccino'] = { 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'prop_fib_coffee', 'Tomando', 70, 0, 0, nil, 30, 1.15 },
    ['frappuccino'] = { 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'prop_fib_coffee', 'Tomando', 70, 0, 0, nil, 30, 1.15 },
    ['cha'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_energy_drink', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['icecha'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_energy_drink', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['sprunk'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'ng_proc_sodacan_01b', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['cola'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'ng_proc_sodacan_01a', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['energetico'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_energy_drink', 'Tomando', 70, 0, 0, nil, 90, 1.10 }
}

config.alcoholic_drinks = {
    ['pibwassen'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_amb_beer_bottle', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['tequilya'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_beer_logopen', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['patriot'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_amb_beer_bottle', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['blarneys'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'p_whiskey_notop', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['jakeys'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_beer_logopen', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['barracho'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_amb_beer_bottle', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['ragga'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'p_whiskey_notop', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['nogo'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_beer_logopen', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['mount'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'p_whiskey_notop', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['cherenkov'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_beer_logopen', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['bourgeoix'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'p_whiskey_notop', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['bleuterd'] = { 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'prop_beer_logopen', 'Tomando', 70, 0, 0, nil, 0, 0 }
}

config.foods = {
    ['sanduiche'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['rosquinha'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['hotdog'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['chips'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['batataf'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['pizza'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['frango'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['bcereal'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['bchocolate'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 },
    ['taco'] = { 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_cs_burger_01', 'Tomando', 70, 0, 0, nil, 0, 0 }
}

config.wComponents = {
	['WEAPON_PISTOL'] = {
		'COMPONENT_AT_PI_FLSH'
	},
	['WEAPON_HEAVYPISTOL'] = {
		'COMPONENT_AT_PI_FLSH'
	},
	['WEAPON_PISTOL_MK2'] = {
		'COMPONENT_AT_PI_RAIL',
		'COMPONENT_AT_PI_FLSH_02',
		'COMPONENT_AT_PI_COMP'
	},
	['WEAPON_COMBATPISTOL'] = {
		'COMPONENT_AT_PI_FLSH'
	},
	['WEAPON_APPISTOL'] = {
		'COMPONENT_AT_PI_FLSH'
	},
	['WEAPON_MICROSMG'] = {
		'COMPONENT_AT_PI_FLSH',
		'COMPONENT_AT_SCOPE_MACRO'
	},
	['WEAPON_SMG'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MACRO_02',
		'COMPONENT_AT_PI_SUPP'
	},
	['WEAPON_ASSAULTSMG'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MACRO',
		'COMPONENT_AT_AR_SUPP_02'
	},
	['WEAPON_COMBATPDW'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_AR_AFGRIP',
		'COMPONENT_AT_SCOPE_SMALL'
	},
	['WEAPON_PUMPSHOTGUN'] = {
		'COMPONENT_AT_AR_FLSH'
	},
	['WEAPON_CARBINERIFLE'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MEDIUM',
		'COMPONENT_AT_AR_AFGRIP'
	},
	['WEAPON_ASSAULTRIFLE'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MACRO',
		'COMPONENT_AT_AR_AFGRIP'
	},
	['WEAPON_MACHINEPISTOL'] = {
		'COMPONENT_AT_PI_SUPP'
	},
	['WEAPON_ASSAULTRIFLE_MK2'] = {
		'COMPONENT_AT_AR_AFGRIP_02',
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MEDIUM_MK2',
		'COMPONENT_AT_MUZZLE_01'
	},
	['WEAPON_PISTOL50'] = {
		'COMPONENT_AT_PI_FLSH'
	},
	['WEAPON_SNSPISTOL_MK2'] = {
		'COMPONENT_AT_PI_FLSH_03',
		'COMPONENT_AT_PI_RAIL_02',
		'COMPONENT_AT_PI_COMP_02'
	},
	['WEAPON_SMG_MK2'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2',
		'COMPONENT_AT_MUZZLE_01'
	},
	['WEAPON_BULLPUPRIFLE'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_SMALL',
		'COMPONENT_AT_AR_SUPP'
	},
	['WEAPON_BULLPUPRIFLE_MK2'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MACRO_02_MK2',
		'COMPONENT_AT_MUZZLE_01'
	},
	['WEAPON_SPECIALCARBINE'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MEDIUM',
		'COMPONENT_AT_AR_AFGRIP'
	},
	['WEAPON_SPECIALCARBINE_MK2'] = {
		'COMPONENT_AT_AR_FLSH',
		'COMPONENT_AT_SCOPE_MEDIUM_MK2',
		'COMPONENT_AT_MUZZLE_01'
	}
}

config.permStoreVeh  = {
	["mule3"] = {
		["bait"] = true,
		["shrimp"] = true,
		["octopus"] = true,
		["carp"] = true
	},
	["ratloader"] = {
		["woodlog"] = true
	},
	["stockade"] = {
		["pouch"] = true
	},
	["trash"] = {
		["plastic"] = true,
		["glass"] = true,
		["rubber"] = true,
		["aluminum"] = true,
		["copper"] = true,
		["emptybottle"] = true
	}
}


config.PerssionInspect = { -- Adicione as permissões para revistar sem autorização (True acima)
	'gerente',
	'police'
}

config.CommandChestHouse = 'bau'

config.CommandSchoolbag = 'mochila'
config.SchoolbagSet = {
	[1] = {['id'] = 13, ['color'] = 0},
	[2] = {['id'] = 13, ['color'] = 1},
	[3] = {['id'] = 13, ['color'] = 2},
	[4] = {['id'] = 13, ['color'] = 3},
	[5] = {['id'] = 13, ['color'] = 4}
}