const translations = {
    //Made by Zezombye | v1.0 | code: ABCDE
    MADE_BY_ZEZ_1: {
        "en-US": "Made by Zezombye | v",
        "fr-FR": "Créé par Zezombye | v"
    },
    MADE_BY_ZEZ_2: {
        "en-US": " | code: ",
        "fr-FR": " | code : "
    },
    //Do a kill with {0} Roll or {1} Piledriver to progress
    HAMMOND_PROGRESS_1: {
        "en-US": "Do a kill with ",
        "fr-FR": "Faites un kill avec "
    },
    HAMMOND_PROGRESS_2: {
        "en-US": " Roll or ",
        "fr-FR": " Roulé-boulé ou "
    },
    HAMMOND_PROGRESS_3: {
        "en-US": " Piledriver to progress",
        "fr-FR": " Pilonnage pour progresser"
    },
    RESPAWN_IN: {
        "en-US": "Respawn in: ",
        "fr-FR": "Réapparition dans : "
    },
    YOU_ARE_ON: {
        "en-US": "You are on",
        "fr-FR": "Vous êtes"
    },
    NEXT_HERO: {
        "en-US": "Next hero:",
        "fr-FR": "Prochain héros :"
    },
    FINAL_HERO: {
        "en-US": "Final hero",
        "fr-FR": "Dernier héros"
    },
    //Killed by {} Melee! You lost a level!
    KILLED_BY_MELEE_1: {
        "en-US": "Killed by ",
        "fr-FR": "Tué par "
    },
    KILLED_BY_MELEE_2: {
        "en-US": " Melee! You lost a level!",
        "fr-FR": " Mêlée ! Vous perdez un niveau !"
    },
    //{} Melee Kill! You stole a level!
    MELEE_KILL_1: {
        "en-US": "",
        "fr-FR": "Kill avec "
    },
    MELEE_KILL_2: {
        "en-US": " Melee Kill! You stole a level!",
        "fr-FR": " Mêlée ! Vous volez un niveau!"
    },
    //Do not start the game!\nHost ({}): please restart the game to play.
    DONT_START_GAME_1: {
        "en-US": "Do not start the game!\nHost (",
        "fr-FR": "Ne commencez pas la partie !\nL'hôte ("
    },
    DONT_START_GAME_2: {
        "en-US": "): please restart the game to play.",
        "fr-FR": ") doit redémarrer la partie pour jouer."
    },
    //The map {} is not supported!\nSupported maps:
    UNSUPPORTED_MAP_1: {
        "en-US": "The map ",
        "fr-FR": "La map "
    },
    UNSUPPORTED_MAP_2: {
        "en-US": " is not supported!\nSupported maps:",
        "fr-FR": " n'est pas supportée !\nMaps supportées :"
    },
    KILLED_YOURSELF: {
        "en-US": "You killed yourself... You lost a level!",
        "fr-FR": "Vous vous êtes suicidé... Vous perdez un niveau!"
    },
    //{} wins!
    PLAYER_WINS: {
        "en-US": "wins!",
        "fr-FR": "a gagné !"
    },
    /*XXXXX: {
        "en-US": "",
        "fr-FR": ""
    },*/

}

const availableLanguages = ["en-US", "fr-FR"]


//check if we put a language that isn't available
/*for (var key in translations) {
    if (!availableLanguages.includes(key)) {
        throw new Error("Language '"+key+"' is invalid");
    }
}*/

result = "";
for (var translation in translations) {

    //check if all languages are here
    for (var lang of availableLanguages) {
        if (translations[translation][lang] === undefined) {
            throw new Error("Missing language '"+lang+"' for translation '"+translation+"'");
        }
    }

    result += "#!define STR_"+translation+" "+JSON.stringify(availableLanguages.map(x => translations[translation][x]))+'[max(false, practiceRangeTranslations.index("{0}".format(Map.PRACTICE_RANGE)))]\n';
}
