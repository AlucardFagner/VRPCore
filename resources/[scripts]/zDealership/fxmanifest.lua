fx_version "adamant"
game "gta5"
lua54 'yes'

ui_page_preload "yes"
ui_page "web/html/darkside.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"@vrp/lib/utils.lua",
	"server/*"
}

files {
	"web/*",
	"web/**/*"
}

escrow_ignore {
	'config/*',
}