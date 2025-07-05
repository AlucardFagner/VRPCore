fx_version 'cerulean' -- use versão mais atual
game 'gta5'
lua54 'yes'

author 'VRPCore Team'
description 'Framework modular baseada na vRP - modernizada'
version '1.0.0'

ui_page 'web/index.html'

dependencies {
    'oxmysql'
}

shared_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/*',
    'shared/*.lua'
}

server_scripts {
    'vrp-core/init.lua',
    'vrp-core/core.lua',
    'vrp-core/modules/*.lua',
    'server/*.lua',
    'queue.lua',
    'base.lua'
}

client_scripts {
    'client/*.lua'
}

files {
    'web/*'
}

escrow_ignore {
    'config/*',
    'web/*',
    'client/*',
    'server/*',
    'queue.lua',
    'base.lua',
    'vrp-core/**/*'
}
