
#!define VERSION "0.1"

#!include "settings.opy"

##!obfuscate

#!define BUILD_MODE false
#!define DEBUG_MODE false

/* og order
globalvar heroes = [
    Hero.LUCIO,
    Hero.ANA,
    Hero.MERCY,
    Hero.MOIRA,
    Hero.ZENYATTA,
    Hero.BAPTISTE,
    Hero.BRIGITTE,
    Hero.GENJI,
    Hero.JUNKRAT,
    Hero.MEI,
    Hero.SOMBRA,
    Hero.ASHE,
    Hero.ECHO,
    Hero.TRACER,
    Hero.DOOMFIST,
    Hero.WIDOWMAKER,
    Hero.PHARAH,
    Hero.SOLDIER,
    Hero.MCCREE,
    Hero.REAPER,
    Hero.HANZO,
    Hero.BASTION,
    Hero.SYMMETRA,
    Hero.DVA,
    Hero.ORISA,
    Hero.SIGMA,
    Hero.ZARYA,
    Hero.WINSTON,
    Hero.REINHARDT,
    Hero.ROADHOG,
    Hero.HAMMOND,
    Hero.TORBJORN,
]*/

globalvar heroes = [
    /*Hero.SOLDIER,
    Hero.MERCY,*/

    Hero.ROADHOG,
    Hero.ORISA,
    Hero.SIGMA,
    Hero.ZARYA,
    Hero.REINHARDT,
    Hero.DVA,
    Hero.WINSTON,

    Hero.GENJI,
    Hero.SOMBRA,
    Hero.JUNKRAT,
    Hero.MEI,
    Hero.ECHO,
    Hero.TRACER,
    Hero.DOOMFIST,
    Hero.ASHE,
    Hero.SOLDIER,
    Hero.MCCREE,
    Hero.PHARAH,
    Hero.REAPER,
    Hero.HANZO,
    Hero.BASTION,
    Hero.WIDOWMAKER,
    Hero.SYMMETRA,

    Hero.BAPTISTE,
    Hero.ANA,
    Hero.MOIRA,
    Hero.ZENYATTA,
    Hero.MERCY,
    Hero.LUCIO,
    Hero.BRIGITTE,

    Hero.HAMMOND,
    Hero.TORBJORN,
]

globalvar makeSpawnsCloser = createWorkshopSetting(bool, "", "Make spawns closer", false, 0)
globalvar oneAmmoForWidow = createWorkshopSetting(bool, "", "Widowmaker only has one bullet", true, 1)
globalvar respawnTime = createWorkshopSetting(float[1:3], "", "Respawn time", 3, 2)
globalvar invulnTime = createWorkshopSetting(float[2:4], "", "Invulnerability time", 3, 3)

globalvar team1SpawnPos
globalvar team2SpawnPos
globalvar wallPos

globalvar winner = null

globalvar mapSymVectMult
globalvar mapSymVectAdd

globalvar i
globalvar scoreboardLoopIdx
globalvar j
globalvar diagStart
globalvar diagEnd
globalvar diagStartPos
globalvar diagEndPos
#!define DIAGONAL_INTERVAL 1

#!define getWallSideSign(wallNb, player) dotProduct(vectorTowards(wallPos[wallNb][0], (player).getPosition()), angleToDirection(horizontalAngleFromDirection(directionTowards(wallPos[wallNb][0], wallPos[wallNb][1]))+90, 0))

#!define getWallImpulseDirection(wallNb, sign) angleToDirection(horizontalAngleFromDirection(directionTowards(wallPos[wallNb][0], wallPos[wallNb][1])) + (sign) * 90, 0)

#!define HERO_STUN_TIME 0.7

playervar score = 0
playervar oldscore = -1
playervar hp
playervar stunTime
playervar timeUntilRespawn = 0
playervar lastValidPosition
playervar hasBeenTeleported
playervar doNotSavePosition
playervar invulnTime
playervar i


rule "init":
    disableGamemodeCompletion()
    disableScoring()
    
    #setObjectiveDescription(getAllPlayers(), "                      sqdfdfqsqdfsqsdffdqs                                                                                                                                                                                                                                                         \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudReeval.VISIBILITY_AND_STRING)

    #scoring huds

    #hudHeader(getAllPlayers(), w"                                       \n\n\n\n\n", HudPosition.TOP, -100, Color.BLACK, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    for scoreboardLoopIdx in range(12):
        hudText(
            getAllPlayers().exclude(sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)]) 
            if len(getAllPlayers()) > evalOnce(scoreboardLoopIdx)/* and sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)].getTeam() == Team.1 */
            else [], 
            sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)].score + 1, null, 
            sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)], HudPosition.LEFT, 
            -evalOnce(scoreboardLoopIdx), 
            Color.TEAM_1 if sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)].getTeam() == Team.1 else Color.TEAM_2, 
            Color.WHITE, 
            Color.TEAM_1 if sorted(getAllPlayers(), lambda x: x.score)[evalOnce(scoreboardLoopIdx)].getTeam() == Team.1 else Color.TEAM_2, 
            HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, 
            SpecVisibility.ALWAYS
        )
        wait()
    
    hudSubheader(getAllPlayers(), "Made by Zezombye | v"VERSION, HudPosition.TOP, -899, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "discord.io/zezworkshop\n\n\n", HudPosition.TOP, -898, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getPlayersOnHero(Hero.HAMMOND, Team.ALL), "Do a kill with {} Roll or {} Piledriver to progress".format(abilityIconString(Hero.HAMMOND, Button.SECONDARY_FIRE), abilityIconString(Hero.HAMMOND, Button.CROUCH)), HudPosition.TOP, -895, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "init player":
    @Event eachPlayer
    chase(eventPlayer.stunTime, 0, rate=1, ChaseReeval.NONE)
    chase(eventPlayer.timeUntilRespawn, 0, rate=1, ChaseReeval.NONE)
    chase(eventPlayer.invulnTime, 0, rate=1, ChaseReeval.NONE)
    eventPlayer.disableGamemodeHud()

    #Invuln ring effects
    for eventPlayer.i in range(0.1, 0.6, 0.1):
        createEffect(getAllPlayers() if eventPlayer.invulnTime > 0 else [], Effect.RING, Color.YELLOW, eventPlayer.getPosition() + vect(0,2,0), evalOnce(eventPlayer.i), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        wait()

    hudSubtext(eventPlayer if eventPlayer.invulnTime > 0 and winner == null else [], " \n\n\n\n\nInvulnerable: {}".format(eventPlayer.invulnTime), HudPosition.TOP, -100, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudHeader(eventPlayer if eventPlayer.isDead() and winner == null else [], "Respawn in: {}".format(round(eventPlayer.timeUntilRespawn)), HudPosition.RIGHT, -100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(eventPlayer, eventPlayer.score+1, null, eventPlayer, HudPosition.LEFT, -sorted(getAllPlayers(), lambda x: x.score).index(eventPlayer), Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

    hudHeader(eventPlayer if winner == null else [], "You are on {} {} ({}/{})".format(heroIcon(heroes[eventPlayer.score]), heroes[eventPlayer.score], eventPlayer.score+1, len(heroes)), HudPosition.TOP, -897, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(eventPlayer if winner == null else [], "Next hero: {} {}".format(heroIcon(heroes[eventPlayer.score+1]), heroes[eventPlayer.score+1]) if eventPlayer.score < len(heroes)-1 else "Final hero", HudPosition.TOP, -896, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    #Cannot be healed by teammates
    startHealingModification(eventPlayer, getAllPlayers().exclude(eventPlayer), 0, HealingReeval.RECEIVERS_AND_HEALERS)

    #Set score based on the min score
    eventPlayer.score = max(0, sorted([p for p in getAllPlayers() if p.score > 0], lambda x: x.score)[0]-1)

    eventPlayer.setRespawnTime(respawnTime)


rule "player got a kill":
    @Event playerDealtFinalBlow
    @Condition attacker != victim
    #print(eventAbility)
    #Steal level if melee/piledriver kill
    if eventAbility == Button.MELEE or heroes[attacker.score] == Hero.HAMMOND and eventAbility == Button.CROUCH and victim.score > 0:
        victim.score--
        smallMessage(victim, "Killed by {} Melee! You lost a level!".format(abilityIconString(Hero.ANA, Button.MELEE)))
        smallMessage(attacker, "{} Melee Kill! You stole a level!".format(abilityIconString(Hero.ANA, Button.MELEE)))
    
    #Do not grant score for torb if not primary, or for hammond if not roll/piledriver
    if eventAbility != Button.PRIMARY_FIRE and heroes[attacker.score] == Hero.TORBJORN:
        return
    
    if heroes[attacker.score] == Hero.HAMMOND and eventAbility != Button.CROUCH and eventAbility != Button.SECONDARY_FIRE:
        return

    #Do not grant multiple kills if hog/hammond
    if (heroes[attacker.score] == Hero.HAMMOND or heroes[attacker.score] == Hero.TORBJORN) and heroes[attacker.score] != attacker.getCurrentHero():
        return
    
    if winner == null:
        attacker.score++

rule "player died":
    @Event playerDied
    eventPlayer.timeUntilRespawn = respawnTime
    eventPlayer.hasBeenTeleported = false


rule "assembling heroes?":
    @Condition isAssemblingHeroes()
    setMatchTime(0)

rule "shouldn't be in setup":
    @Condition isInSetup()
    setMatchTime(0)

rule "shouldn't be in progress":
    @Condition isGameInProgress()
    setMatchTime(9999)
    hudSubtext(getAllPlayers(), " \n\n\n\n\n\n", HudPosition.TOP, -500, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    hudHeader(getAllPlayers(), " \n\nDo not start the game!\nHost ({}): please restart the game to play.\n\n".format(hostPlayer), HudPosition.TOP, -400, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    disableAnnouncer()
    disableMusic()

rule "shouldn't be in progress - make all players unable to play":
    @Event eachPlayer
    @Condition isGameInProgress()
    eventPlayer.startForcingHero(Hero.LUCIO)
    eventPlayer.startCamera(vect(0, 500, 0), vect(0, 1000, 0), 0)
    eventPlayer.disableHeroHUD()
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()

rule "wrong map":
    if getCurrentMap() not in [
        Map.BLACK_FOREST,
        Map.BLACK_FOREST_WINTER,
        #Map.CASTILLO,
        Map.ECOPOINT_ANTARCTICA,
        Map.ECOPOINT_ANTARCTICA_WINTER,
    ] or getCurrentGamemode() != Gamemode.ELIMINATION:
        hudHeader(getAllPlayers(), " \n\nThe map {} is not supported!\nSupported maps:\n- Black Forest"/*"\n- Castillo"*/"\n- Ecopoint: Antarctica".format(getCurrentMap()), HudPosition.TOP, -99999, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    

rule "player suicided":
    @Event playerDied
    @Condition attacker == victim
    @Condition victim.score > 0
    smallMessage(victim, "You killed yourself... You lost a level!".format(abilityIconString(Hero.ANA, Button.MELEE)))
    victim.score--

rule "player score changed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.score != eventPlayer.oldscore
    do:
        eventPlayer.score max= 0
        eventPlayer.score min= len(heroes)
        eventPlayer.oldscore = eventPlayer.score
        eventPlayer.hp = eventPlayer.getNormalizedHealth()
        eventPlayer.stunTime = HERO_STUN_TIME
        wait(0.048)
        eventPlayer.startForcingHero(heroes[eventPlayer.score])
        eventPlayer.preloadHero(heroes.slice(eventPlayer.score, 8))
        eventPlayer.setAmmo(0, 0)
        wait()
        eventPlayer.setHealth(eventPlayer.hp * eventPlayer.getMaxHealth())
        wait()
    while RULE_CONDITION
/*
rule "player is 'stunned' and has an infinite ammo hero":
    @Event eachPlayer
    @Condition eventPlayer.stunTime > 0
    @Condition eventPlayer.getCurrentHero() in [Hero.BRIGITTE, Hero.REINHARDT, Hero.SIGMA, Hero.DVA, Hero.HANZO, Hero.MOIRA]
    do:
        eventPlayer.cancelPrimaryAction()
        wait()
    while RULE_CONDITION
*/
rule "player is 'stunned'":
    @Event eachPlayer
    @Condition eventPlayer.stunTime > 0
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    wait(0.25)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.stopForcingButton(Button.ULTIMATE)
    eventPlayer.stopForcingButton(Button.MELEE)

rule "player isn't 'stunned'":
    @Event eachPlayer
    @Condition eventPlayer.stunTime == 0
    #eventPlayer.setPrimaryFireEnabled(heroes[eventPlayer.score] != Hero.HAMMOND)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(heroes[eventPlayer.score] != Hero.TORBJORN)
    eventPlayer.setAbility2Enabled(not heroes[eventPlayer.score] in [Hero.TORBJORN/*, Hero.HAMMOND*/])
    eventPlayer.setUltEnabled(heroes[eventPlayer.score] not in [Hero.TORBJORN, Hero.HAMMOND])
    eventPlayer.setMeleeEnabled(true)
    wait()
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        eventPlayer.startForcingButton(Button.ABILITY_1)
    if eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.startForcingButton(Button.ABILITY_2)
    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.startForcingButton(Button.ULTIMATE)
    if eventPlayer.isHoldingButton(Button.MELEE):
        eventPlayer.startForcingButton(Button.MELEE)


/*
rule "tell user no primary for ana/widow/ashe":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in [Hero.ANA, Hero.ASHE, Hero.WIDOWMAKER, Hero.MOIRA]
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    #eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    if eventPlayer.getCurrentHero() == Hero.MOIRA:
        smallMessage(eventPlayer, "Hold {} to use succ".format(buttonString(Button.SECONDARY_FIRE)))
    else:
        smallMessage(eventPlayer, "Hold {} to use scope".format(buttonString(Button.SECONDARY_FIRE)))
*/
/*
rule "force scope for ana/widow/ashe - release":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in [Hero.ANA, Hero.WIDOWMAKER, Hero.MOIRA]
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    #@Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
*/

#!include "debug.opy"

rule "player is alive - teleport him and make him invulnerable":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition not BUILD_MODE
    if eventPlayer.getTeam() == Team.1:
        eventPlayer.teleport(nearestWalkablePosition(
            team1SpawnPos[0] 
            + directionTowards(team1SpawnPos[0], team1SpawnPos[1]) * random.uniform(0, distance(team1SpawnPos[0], team1SpawnPos[1])) 
            + directionTowards(team1SpawnPos[0], team1SpawnPos[3]) * random.uniform(0, distance(team1SpawnPos[0], team1SpawnPos[3]))
        ))
        eventPlayer.setFacing(directionTowards(team1SpawnPos[0], team2SpawnPos[0]), Relativity.TO_WORLD)
    else:
        eventPlayer.teleport(nearestWalkablePosition(
            team2SpawnPos[0]
            + directionTowards(team2SpawnPos[0], team2SpawnPos[1]) * random.uniform(0, distance(team2SpawnPos[0], team2SpawnPos[1]))
            + directionTowards(team2SpawnPos[0], team2SpawnPos[3]) * random.uniform(0, distance(team2SpawnPos[0], team2SpawnPos[3]))
        ))
        eventPlayer.setFacing(directionTowards(team2SpawnPos[0], team1SpawnPos[0]), Relativity.TO_WORLD)
    eventPlayer.hasBeenTeleported = true
    eventPlayer.invulnTime = invulnTime

    #necessary for dummy bots
    eventPlayer.startForcingHero(heroes[eventPlayer.score])

rule "player has used an ability - disable the invulnerability":
    @Event eachPlayer
    @Condition eventPlayer.invulnTime > 0 and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate())
    eventPlayer.invulnTime = 0


rule "player is invulnerable":
    @Event eachPlayer
    @Condition eventPlayer.invulnTime > 0
    eventPlayer.setDamageReceived(0)

    
rule "player is no longer invulnerable":
    @Event eachPlayer
    @Condition eventPlayer.invulnTime == 0
    eventPlayer.setDamageReceived(100)

rule "1 ammo for widow":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.WIDOWMAKER
    @Condition eventPlayer.getMaxAmmo(0) > 1
    @Condition oneAmmoForWidow
    do:
        eventPlayer.setMaxAmmo(0, 1)
        wait()
    while RULE_CONDITION

rule "failsafe - no ammo for torb":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.TORBJORN
    @Condition eventPlayer.getMaxAmmo(0) > 0 or eventPlayer.getAmmo(0) > 0
    do:
        eventPlayer.setMaxAmmo(0, 0)
        eventPlayer.setAmmo(0, 0)
        wait()
    while RULE_CONDITION

rule "force weapons":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in [Hero.TORBJORN, Hero.MERCY]
    @Condition eventPlayer.getCurrentWeapon() == 1
    do:
        eventPlayer.setWeapon(2)
        wait()
    while RULE_CONDITION

#!include "maps/ecopoint_antarctica.opy"
#!include "maps/black_forest.opy"

rule "mirror walls and spawns":
    for i in range(ceil(len(wallPos)/2)):
        wallPos.append([[
            wallPos[i][0] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][1] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][2] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][3] * mapSymVectMult + mapSymVectAdd,
        ]])

    team1SpawnPos[3] = team1SpawnPos[0] + vectorTowards(team1SpawnPos[1], team1SpawnPos[2])

    team2SpawnPos[0] = team1SpawnPos[0] * mapSymVectMult + mapSymVectAdd
    team2SpawnPos[1] = team1SpawnPos[1] * mapSymVectMult + mapSymVectAdd
    team2SpawnPos[2] = team1SpawnPos[2] * mapSymVectMult + mapSymVectAdd
    team2SpawnPos[3] = team1SpawnPos[3] * mapSymVectMult + mapSymVectAdd

#!include "walls.opy"
#!include "build_mode.opy"
#!include "win_screen/winhud.opy"


rule "player wins":
    @Event eachPlayer
    @Condition eventPlayer.score >= len(heroes)
    @Condition winner == null
    winner = eventPlayer

    setObjectiveDescription(getAllPlayers(), p"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudReeval.VISIBILITY_AND_STRING)
    getAllPlayers().enableGamemodeHud()
    getAllPlayers().disableHeroHUD()
    setSlowMotion(30)
    bigMessage(getAllPlayers(), " \n\n\n\n\n".format(eventPlayer))
    wait(1)

    if eventPlayer.couldNameBeGuessed:
        displayWinHuds = true
    else:
        hudSubheader(getAllPlayers(), p" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.LEFT, -999, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

        hudSubheader(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -999, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudHeader(getAllPlayers(), " \n     {} wins!     \n".format(eventPlayer), HudPosition.TOP, -998, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        hudSubheader(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -997, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
