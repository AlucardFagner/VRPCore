local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

z = {}
Tunnel.bindInterface('zLogin', z)

function z.localizations()
    local locs = {}
    for k, v in pairs(config.localizations) do
        table.insert(locs, { index = k, name = v.name, photo = v.photo, x = v.x, y = v.y, z = v.z })
    end
    return locs
end