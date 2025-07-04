-----------------------------------------------------------------------------------------------------------------------------------
----- [ CRIE SEU PRÓPRIO TARGET] --------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- Para criar um target em um determinado local, usando a coordenada preencha esse modelo abaixo e coloque dentro da função
--[[    AddBoxZone('NomeDaBox', vector3(x, y, z), TamanhoLados, TamanhoFrontal, { -- Defina o nome da box e coloque a coordenada dentro do vector3, nos tamanhos você pode escolher o tamanho da caixa.
            name = 'NomeDaBox', -- Recomendamos utilizar o mesmo nome da Caixa acima
            heading = h, -- Adicione a relação de frente do personagem com a caixa
            debugPoly = false, -- Se estiver true você consegue visualizar a caixa criada em tempo real
            minZ = 1.5, -- Altura mínima que a caixa estará em relação ao Z da coordenada
            maxZ = 1.5 -- Altura máxima que a caixa estará em relação ao Z da coordenada
        }, {
            distance = 1.5, -- Distancia do player em relação a caixa
            options = {
                {
                    event = 'Nome:Qualquer', -- O nome do evento que o target irá enviar
                    label = 'Texto', -- Texto que irá aparecer no target criado
                    tunnel = 'client' -- client se o evento for client-side ou server se ele for server-side
                }
            }
        })

        AddTargetModel({ hash, hash }, { -- Defina as hashs que esse target irá buscar
            options = {
                {
                    event = 'Nome:Qualquer', -- O nome do evento que o target irá enviar
                    label = 'Texto', -- Texto que irá aparecer no target criado
                    tunnel = 'client' -- client se o evento for client-side ou server se ele for server-side
                }
            },
            distance = 1.5, -- Distancia do player em relação a caixa
        })
]]
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp', 'lib/Tunnel')
local Tools = module('vrp', 'lib/Tools')
local idgens = Tools.newIDGenerator()
zGARAGES = Tunnel.getInterface('zGarages')

function dataTarget() -- Não altere o nome dessa função!
    
    local garages = zGARAGES.getGaragesList()
    local banks = {
        { 150.01, -1040.03, 29.38, 158.8 },
        { -1213.25, -330.06, 37.79, 202.02 },
        { -2963.47, 482.79, 15.71, 264.51 },
        { -113.63, 6469.63, 31.63, 311.54 },
        { 314.23, -278.37, 54.18, 157.89 },
        { 242.22, 224.38, 106.29, 347.44 },
        { -350.82, -49.12, 49.05, 159.93 },
        { 1175.03, 2706.18, 38.1, 358.93 }
    }
    local barbershop = {
        { 137.6, -1708.58, 29.3, 230.01 },
        { -1282.8, -1118.04, 7.0, 178.07 },
        { 1932.29, 3730.74, 32.85, 299.17 },
        { 1932.29, 3730.74, 32.85, 299.17 },
        { 1212.22, -473.43, 66.21, 164.69 },
        { -33.61, -154.52, 57.08, 164.69 },
        { -278.72, 6227.65, 31.7, 138.48 }
    }
    local skinshop = {
        { 428.47, -800.0, 29.5, 94.31 },
        { 72.68, -1399.14, 29.38, 271.47 },
        { -829.11, -1074.34, 11.33, 221.63 },
        { -1188.31, -765.26, 17.32, 138.23 },
        { -158.81, -296.32, 39.74, 159.87 },
        { 123.22, -228.6, 54.56, 340.62 },
        { -708.15, -160.96, 37.42, 31.71 },
        { -1457.34, -241.74, 49.81, 317.52 },
        { -3173.37, 1038.94, 20.87, 338.00 },
        { -1107.87, 2708.42, 19.11, 229.84 },
        { 614.55, 2768.46, 42.09, 177.90 },
        { 1190.47, 2712.88, 38.23, 182.06 }, 
        { 1695.82, 4829.31, 42.07, 99.29 }, 
        { 11.13, 6514.7, 31.88, 48.03 }
    }

	for a, b  in pairs(garages) do
        local id = idgens:gen()
		AddBoxZone('zGarages:'..b.name..':'..id, vector3(b.x, b.y, b.z), 3.5, 3.5, {
			name = 'zGarages:'..b.name..':'..id,
			heading = b.h,
			debugPoly = false,
			minZ = b.z-1.0,
			maxZ = b.z+2.0
			
		}, {
			distance = 5.0,
			options = {
				{
					event = 'zGarages:open',
					label = 'Abrir Garagem',
					tunnel = 'client'
				}
			}
		})
	end
    
    for _, v in pairs(banks) do
        local id = idgens:gen()
        AddBoxZone('zBank:openBank'..id, vector3(v[1], v[2], v[3]), 4.5, 4.5, {
            name = 'zBank:openBank'..id,
            heading = v[4],
            debugPoly = false,
            minZ = v[3]-1.0,
            maxZ = v[3]+3.0
        }, {
            distance = 5.0,
            options = {
                {
                    event = 'zBank:open',
                    label = 'Acessar Banco',
                    tunnel = 'client'
                }
            }
        })
    end
    
    for _, v in pairs(barbershop) do 
        local id = idgens:gen()
        AddBoxZone('zBarberShops:'..id, vector3(v[1], v[2], v[3]), 4.5, 4.5, {
            name = 'zBarberShops:'..id,
            heading = v[4],
            debugPoly = false,
            minZ = v[3]-1.0,
            maxZ = v[3]+4.0
        }, {
            distance = 5.0,
            options = {
                {
                    event = 'zBarberShops:open',
                    label = 'Acessar Barbearia',
                    tunnel = 'client'
                }
            }
        })
    end

    for _, v in pairs(skinshop) do
        local id = idgens:gen()
        AddBoxZone('zSkinshops:'..id, vector3(v[1], v[2], v[3]), 11.5, 11.5, {
            name = 'zSkinshops:'..id,
            heading = v[4],
            debugPoly = false,
            minZ = v[3]-1.0,
            maxZ = v[3]+4.0
        }, {
            distance = 8.0,
            options = {
                {
                    event = 'zSkinShops:open',
                    label = 'Loja de Roupa',
                    tunnel = 'client'
                }
            }
        })
    end

    AddTargetModel({ 506770882, -870868698, -1364697528, -1126237515 }, { 
        options = {
            {
                event = 'zBank:open',
                label = 'Acessar Banco',
                tunnel = 'client'
            },
            {
                event = 'zCashmachine:machineRobbery',
                label = 'Iniciar Roubo',
                tunnel = 'client'
            }
        },
        distance = 1.50
    })

         -- zMedical

    -- AddTargetModel({ 1631638868, 2117668672, -1498379115, -1519439119, -289946279 }, {
    --     options = {
    --         {
    --             event = 'zTarget:animDeitar',
    --             label = 'Deitar',
    --             tunnel = 'client'
    --         }
    --     },
    --     distance = 1.00
    -- })

    -- AddTargetModel({ 1631638868, 2117668672, -1498379115, -1519439119, -289946279 }, {
    --     options = {
    --         {
    --             event = 'zTarget:animTratamento',
    --             label = 'Tratamento',
    --             tunnel = 'client'
    --         }
    --     },
    --     distance = 1.00
    -- })


    AddTargetModel({ -171943901, -109356459, 1805980844, -99500382, 1262298127, 1737474779, 2040839490, 1037469683, 867556671, -1521264200, -741944541, -591349326, -293380809, -628719744, -1317098115, 1630899471, 38932324, -523951410, 725259233, 764848282, 2064599526, 536071214, 589738836, 146905321, 47332588, -1118419705, 538002882, -377849416, 96868307 }, {
        options = {
            {
                event = 'zTarget:animSentar',
                label = 'Sentar',
                tunnel = 'client'
            }
        },
        distance = 1.00
    })

    AddTargetModel({ 0x18CE57D0, 0x07DD91AC, 0x4117D39B, 0x6E122C06, 0x2307A353, 0x5DCA2528 }, {
        options = {
            {
                event = 'zShops:openShop',
                label = 'Comprar',
                tunnel = 'client'
            }
        },
        distance = 2.00
    })

    AddTargetModel({ -1291993936 }, {
        options = {
            {
                event = 'zBarberShops:open',
                label = 'Acessar Barbearia',
                tunnel = 'client'
            }
        },
        distance = 1.50
    })

    AddBoxZone('zDealership:openNui', vector3(-29.76, -1104.29, 26.43), 5.5, 5.5, {
        name = 'zDealership:openNui',
        heading = 158.21,
        debugPoly = false,
        minZ = 25.43,
        maxZ = 30.43
    }, {
        distance = 8.0,
        options = {
            {
                event = 'zDealership:openNui',
                label = 'Loja de Carros',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zDismantle:Start', vector3(2340.99, 3128.2, 48.21), 3.5, 3.5, {
        name = 'zDismantle:Start',
        heading = 174.82,
        debugPoly = false,
        minZ = 47.21,
        maxZ = 52.21
    }, {
        distance = 8.0,
        options = {
            {
                event = 'zDismantle:Start',
                label = 'Iniciar Desmanche',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zDriver:Start', vector3(455.19, -600.62, 28.55), 5.5, 5.5, {
        name = 'zDriver:Start',
        heading = 86.61,
        debugPoly = false,
        minZ = 27.55,
        maxZ = 32.55
    }, {
        distance = 8.0,
        options = {
            {
                event = 'zDriver:Start', 
                label = 'Iniciar | Trabalho de Motorista',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zGarbargeman:start', vector3(-349.65, -1568.97, 25.23), 2.5, 2.5, {
        name = 'zGarbargeman:start',
        heading = 114.14,
        debugPoly = false,
        minZ = 24.23,
        maxZ = 26.23
    }, {
        distance = 8.0,
        options = {
            {
                event = 'zGarbargeman:start',
                label = 'Iniciar | Trabalho de Lixeiro',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zHarvest:start', vector3(349.99, 6519.06, 28.62), 70.5, 40.5, {
        name = 'zHarvest:start',
        heading = 265.71,
        debugPoly = false,
        minZ = 27.62,
        maxZ = 32.62
    }, {
        distance = 40.0,
        options = {
            {
                event = 'zHarvest:start',
                label = 'Iniciar/Parar | Trabalho de Colheita',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zMiner:startJob', vector3(-594.69, 2083.89, 131.39), 10.5, 5.5, {
        name = 'zMiner:startJob',
        heading = 194.36,
        debugPoly = false,
        minZ = 130.39,
        maxZ = 133.39
    }, {
        distance = 40.0,
        options = {
            {
                event = 'zMiner:startJob',
                label = 'Iniciar/Parar | Trabalho de Minerador',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zLumberman:startJob', vector3(-563.1, 5350.44, 70.22), 8.0, 8.0, {
        name = 'zLumberman:startJob',
        heading = 246.765,
        debugPoly = false,
        minZ = 69.22,
        maxZ = 73.22
    }, {
        distance = 5.0,
        options = {
            {
                event = 'zLumberman:startJob',
                label = 'Iniciar/Parar | Trabalho de Lenhador',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zTaxi:StartJob', vector3(905.05, -164.93, 74.1), 1.0, 1.0, {
        name = 'zTaxi:StartJob',
        heading = 236.09,
        debugPoly = false,
        minZ = 72.72,
        maxZ = 75.05
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zTaxi:StartJob',
                label = 'Iniciar/Parar | Trabalho de Taxista',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zPostman:StartJob', vector3(53.62, 114.67, 79.2), 1.5, 1.5, {
        name = 'zPostman:StartJob',
        heading = 339.69,
        debugPoly = false,
        minZ = 77.72,
        maxZ = 80.30
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zPostman:StartJob',
                label = 'Iniciar rota de entregador',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zPostman:BoxRem', vector3(78.93, 112.55, 81.17), 1.5, 1.5, {
        name = 'zPostman:BoxRem',
        heading = 158.27,
        debugPoly = false,
        minZ = 80.17,
        maxZ = 82.20
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zPostman:BoxRem',
                label = 'Pegar encomenda',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zDelivery:StartJob', vector3(81.32, 274.92, 110.22), 1.5, 1.5, {
        name = 'zDelivery:StartJob',
        heading = 158.31,
        debugPoly = false,
        minZ = 109.22,
        maxZ = 111.70
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zDelivery:StartJob',
                label = 'Iniciar/Parar | Trabalho de Delivery',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zContructor:StartJob', vector3(141.47, -379.63, 43.26), 1.5, 1.5, {
        name = 'zContructor:StartJob',
        heading = 68.61,
        debugPoly = false,
        minZ = 42.26,
        maxZ = 44.56
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zContructor:StartJob',
                label = 'Iniciar/Parar | Trabalho na Construção',
                tunnel = 'client'
            },
            {
                event = 'zContructor:CollectMaterial',
                label = 'Coletar Ferramenta',
                tunnel = 'client'
            }
        }
    })

    -- zPlumber
    AddBoxZone('zPlumber:StartJob', vector3(153.07,-3208.56,5.91), 1.5, 1.5, {
        name = 'zPlumber:StartJob',
        heading = 96.35,
        debugPoly = false,
        minZ = 3.91,
        maxZ = 6.91
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zPlumber:StartJob',
                label = 'Iniciar/Parar | Trabalho de encanador',
                tunnel = 'client'
            },
            {
                event = 'zPlumber:CollectMaterial',
                label = 'Coletar Ferramenta',
                tunnel = 'client'
            }
        }
    })

    -- zTransporter 

    AddBoxZone('zPlumber:StartJob', vector3(153.07,-3208.56,5.91), 1.5, 1.5, {
        name = 'zPlumber:StartJob',
        heading = 96.35,
        debugPoly = false,
        minZ = 3.91,
        maxZ = 6.91
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zPlumber:StartJob',
                label = 'Iniciar/Parar | Trabalho de encanador',
                tunnel = 'client'
            },
            {
                event = 'zPlumber:CollectMaterial',
                label = 'Coletar Ferramenta',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zPilot:StartJob', vector3(-1070.49, -2867.82, 13.96), 1.5, 1.5, {
        name = 'zPilot:StartJob',
        heading = 151.95,
        debugPoly = false,
        minZ = 12.96,
        maxZ = 14.96
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zPilot:StartJob',
                label = 'Iniciar/Parar | Trabalho de Piloto',
                tunnel = 'client'
            }
        }
    })
    
    AddBoxZone('zMilkman:StartJob', vector3(416.69, 6522.13, 27.73), 1.1, 1.1, {
        name = 'zMilkman:StartJob',
        heading = 258.06,
        debugPoly = false,
        minZ = 26.72,
        maxZ = 28.79
    }, {
        distance = 10.0,
        options = {
            {
                event = 'zMilkman:StartJob',
                label = 'Iniciar/Parar | Trabalho de Leiteiro',
                tunnel = 'client'
            },
            {
                event = 'zMilkman:DeliveryRoute',
                label = 'Iniciar entregas',
                tunnel = 'client'
            }
        }
    })

    AddBoxZone('zMilkman:CollectMaterial', vector3(425.70, 6463.80, 28.79), 2.5, 0.8, {
        name = 'zMilkman:CollectMaterial',
        heading = 314.58,
        debugPoly = false,
        minZ = 26.79,
        maxZ = 29.79
    }, {
        distance = 2.0,
        options = {
            {
                event = 'zMilkman:CollectMaterial',
                label = 'Iniciar extração de Leite',
                tunnel = 'client'
            }
        }
    })

    AddTargetModel({ 0x59511A6C }, {
        options = {
            {
                event = 'zTruckdriver:StartJob',
                label = 'Iniciar/Parar | Trabalho de Caminhoneiro',
                tunnel = 'client'
            }
        },
        distance = 1.5
    })

    AddTargetModel({ -2007231801, 1339433404, 1694452750, 1933174915, -462817101, -469694731, -164877493 }, {
        options = {
            {
                event = 'zFuel:getTarget',
                label = 'Abastecer',
                tunnel = 'client'
            }
        },
        distance = 1.5
    })

end