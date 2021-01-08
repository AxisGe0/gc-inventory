fx_version 'adamant'

game 'gta5'

description "GC INVENTORY"

version "1.0"

ui_page "html/ui.html"

client_scripts {
  "@es_extended/locale.lua",
  "client/main.lua",
  "client/shop.lua",
  "client/glovebox.lua",
  "client/weapons.lua",
  "client/dumpster.lua",
  "client/trunk.lua",
  "client/player.lua",
  "client/beds.lua",
  "client/motels.lua",
  "client/disc-property.lua",
  "client/steal.lua",
  "common/weapons.lua",
  "locales/en.lua",
  "config.lua"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  "@es_extended/locale.lua",
  "server/main.lua",
  "server/steal.lua",
  "common/weapons.lua",
  "locales/en.lua",
  "config.lua"
}

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- JS LOCALES
  "html/locales/cs.js",
  "html/locales/en.js",
  "html/locales/fr.js",
  -- IMAGES
  "html/img/bullet.png",
  "html/img/*.svg",
  "html/img/items/*.png",
  "html/img/*.png"
  -- ITEMSSSSSSSSSSSSSSSSS PICS

}

server_script 'server.lua'
