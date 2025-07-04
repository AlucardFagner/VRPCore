client_script "lib/lib.lua"

fx_version 'bodacious'
game 'gta5'
lua54 'yes'

ui_page 'web/index.html'

dependencies {
    'oxmysql'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'lib/utils.lua',
	'base.lua',
	'queue.lua',
	'config/*',
	'server/*'
}

client_scripts {
	'lib/utils.lua',
	'config/*',
	'client/*'
}

files {
	'web/*',
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'lib/Luaseq.lua',
	'lib/Tools.lua'
}

escrow_ignore {
	'config/*',
	'lib/*',
	'web/*',
	'client/*',
	'server/*',
	'base.lua',
	'queue.lua'
}              