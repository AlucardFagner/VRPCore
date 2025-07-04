fx_version 'adamant'
game 'gta5'

ui_page "web/darkside.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config/*",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config/*",
	"server/*"
}

files {
	"web/*",
	"web/**/*"
}