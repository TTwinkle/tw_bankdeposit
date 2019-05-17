---------------------------------------------------------------------
--                   tw_bankdeposit by Twinkle                     --
--                     Discord: Twinkle#0110                       --
--     This script was based on esx_bankdeposit by FrostyLucas     --
--            Don't Change the name and don't reupload.            --
--                 https://forum.fivem.net/u/il_creon              --
---------------------------------------------------------------------

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
