config = {}

config.imageService = 'http://images.ziraflix.com/itens'

config.craft = {
    ['weaponfactory'] = {
        ['coords'] = { x = 152.67, y = -992.05, z = 29.36, h = 340.42 }, 
        ['permission'] = 'Gerente',
        ['crafts'] = {
            { 
                item = 'WEAPON_ASSAULTRIFLE_MK2',
                amount = 1,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            { 
                item = 'WEAPON_COMPACTRIFLE',
                amount = 1,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            { 
                item = 'WEAPON_MICROSMG',
                amount = 1,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            { 
                item = 'WEAPON_REVOLVER_MK2',
                amount = 1,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            { 
                item = 'WEAPON_COMBATPISTOL',
                amount = 1,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            }
        }
    },
    ['wammofactory'] = {
        ['coords'] = { x = 161.29, y = -994.9, z = 29.36, h = 247.58 },
        ['permission'] = 'gerente',
        ['crafts'] = {
            {
                item = 'WEAPON_ASSAULTRIFLE_MK2',
                amount = 30,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            {
                item = 'WEAPON_COMPACTRIFLE',
                amount = 30,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            {
                item = 'WEAPON_MICROSMG',
                amount = 30,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            {
                item = 'WEAPON_REVOLVER_MK2',
                amount = 6,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            },
            {
                item = 'WEAPON_COMBATPISTOL',
                amount = 12,
                require = {
                    one_item = 'corpo-fuzil',
                    one_amount = 1,
                    two_item = 'placa-metal',
                    two_amount = 10,
                    three_item = 'molas',
                    three_amount = 3,
                    four_item = 'gatilho',
                    four_amount = 1
                }
            }
        }
    }
}