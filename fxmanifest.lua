fx_version "cerulean"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
  "locale.lua",
  "config.lua",
  "languages/*.lua"
}

client_scripts {
  "client/*.lua"
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "server/*.lua",
}

lua54 "yes"
