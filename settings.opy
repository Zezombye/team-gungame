#!mainFile "team_gungame.opy"

/*
ㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍT e a m   G u n g a m e  |  v0.1
______________________________________________________________ ━━━━━━━━》Get to the next hero by dealing a killing blоw. ━━━━━━━━》Be the first to kill with Torbjörn to win! ━━━━━━━━》Kill with Melee to steal a level. ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣ 
ㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍ discord.io/ZezWorkshop
*/

#with name:
/*
ㆍㆍㆍㆍㆍㆍㆍㆍㆍT e a m   G u n g a m e  |  v0.1
______________________________________________________________ ━━━━━━━━》Get to the next hero by dealing a killing blоw. ━━━━━━━━》Be the first to kill with Torbjörn to win! ━━━━━━━━》Kill with Melee to steal a level. ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣ 
Made by Zezombyeㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍㆍ  discord.io/ZezWorkshop
*/

settings {
    "main": {
        "description": "ㅤㅤㅤㅤㅤㅤㅤ T e a m   G u n g a m e  |  v"+GAMEMODE_VERSION+"  |  "+GAMEMODE_CODE+" ______________________________________________________________ ━━━━━━━━》Get to the next hero by dealing a killing blоw. ━━━━━━━━》Be the first to kill with Torbjörn to win! ━━━━━━━━》Kill with Melee to steal a level. ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣ㅤㅤ Made by Zezombyeㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ  discord.io/ZezWorkshop"
    },
    "lobby": {
        "allowPlayersInQueue": false,
        "spectatorSlots": 6,
        "team1Slots": 6,
        "team2Slots": 6
    },
    "gamemodes": {
        "elimination": {
            "enabledMaps": [
                "ayutthaya",
                "blackForest",
                "blackForestWinter",
                "ecopointAntarctica",
                "ecopointAntarcticaWinter",
                "lijiangGarden",
                "lijiangGardenLny",
                "lijiangControlCenter",
                "lijiangControlCenterLny",
                "lijiangNightMarket",
                "lijiangNightMarketLny",
                "necropolis",
                "nepalSanctum",
                "nepalShrine",
                "nepalVillage",
                "oasisUniversity",
                "iliosRuins",
            ]
        },
        "general": {
            /*"heroLimit": "off",*/
            "enableRandomHeroes": true,
            /*"respawnTime%": 30,*/
            "gamemodeStartTrigger": "manual",
            "enableSkins": false,
            "spawnHealthPacks": "enabled"
        }
    },
    "heroes": {
        "allTeams": {
            "mercy": {
                "weaponsEnabled": "blaster"
            },
            "torbjorn": {
                "weaponsEnabled": "hammer"
            },
            /*"hammond": {
                "enableRollOnly": true
            },*/
            "general": {
                "health%": 100,
                "ultGen%": 200,
                "combatUltGen%": 200,
                "passiveUltGen%": 500,
            }
        },
    },
    "workshop": {
        "Make spawns closer": true
    }
}
