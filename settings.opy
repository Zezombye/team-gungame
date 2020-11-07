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
        "description": "ㅤㅤㅤㅤㅤㅤㅤㅤㅤT e a m   G u n g a m e  |  v"+VERSION+"        ______________________________________________________________ ━━━━━━━━》Get to the next hero by dealing a killing blоw. ━━━━━━━━》Be the first to kill with Torbjörn to win! ━━━━━━━━》Kill with Melee to steal a level. ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣ㅤㅤ Made by Zezombyeㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ  discord.io/ZezWorkshop"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "spectatorSlots": 6,
        "team1Slots": 6,
        "team2Slots": 6
    },
    "gamemodes": {
        "elimination": {
            "enabledMaps": [
                "blackForest",
                "blackForestWinter",
                /*"castillo",*/
                "ecopointAntarctica",
                "ecopointAntarcticaWinter",
                /*"necropolis",*/
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
        }
    },
    "workshop": {
        "Make spawns closer": true
    }
}
