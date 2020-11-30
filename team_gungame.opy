
#!define GAMEMODE_VERSION "0.1"
#!define GAMEMODE_CODE "EZ990"

#!include "settings.opy"

#!obfuscate

#!define BUILD_MODE false
#!define DEBUG_MODE false

globalvar heroes = [
    /*Hero.SOLDIER,
    Hero.MERCY,*/

    Hero.ROADHOG,
    Hero.ORISA,
    Hero.ZARYA,
    Hero.REINHARDT,
    Hero.DVA,
    Hero.WINSTON, #counters: genji, sigma
    Hero.SIGMA,

    Hero.GENJI, #soft counters: bastion
    Hero.BASTION, #counters: doomfist
    Hero.MEI, #counters: doomfist
    Hero.SOMBRA, #counters: doomfist
    Hero.TRACER,
    Hero.DOOMFIST,
    Hero.ASHE, #counters: pharah, echo
    Hero.SOLDIER, #counters: pharah, echo
    Hero.MCCREE, #counters: pharah, echo
    Hero.PHARAH, #counters: junkrat, doomfist
    Hero.ECHO, #counters: junkrat, doomfist
    Hero.JUNKRAT, #soft counters: bastion
    Hero.REAPER,
    Hero.HANZO,
    Hero.SYMMETRA,

    Hero.BAPTISTE,
    Hero.ANA,
    Hero.MOIRA,
    Hero.ZENYATTA,
    Hero.MERCY,
    Hero.LUCIO, #counters: widowmaker
    Hero.WIDOWMAKER,
    Hero.BRIGITTE, #counters: tracer

    Hero.HAMMOND,
    Hero.TORBJORN,
]

globalvar practiceRangeTranslations = [p"Practice Range", p"Champ de tir"]

globalvar makeSpawnsCloser = createWorkshopSetting(bool, "", "Make spawns closer", false, 0)
globalvar oneAmmoForWidow = createWorkshopSetting(bool, "", "Widowmaker only has one bullet", true, 1)
globalvar respawnTime = createWorkshopSetting(float[1:3], "", "Respawn time", 1.5, 2)
globalvar invulnTime = createWorkshopSetting(float[2:4], "", "Invulnerability time", 3, 3)

globalvar team1SpawnPos = []
globalvar team2SpawnPos = []
globalvar team1FacingDirection = null
globalvar team2FacingDirection = null
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
playervar spawnIdx

#!include "strings.opy"

rule "init":
    disableGamemodeCompletion()
    disableScoring()
    
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
    
    hudSubheader(getAllPlayers(), "{}{}{}{}".format(STR_MADE_BY_ZEZ_1, GAMEMODE_VERSION, STR_MADE_BY_ZEZ_2, GAMEMODE_CODE), HudPosition.TOP, -899, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "discord.io/zezworkshop\n\n\n", HudPosition.TOP, -898, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getPlayersOnHero(Hero.HAMMOND, Team.ALL), "{}{}{}{}{}".format(STR_HAMMOND_PROGRESS_1, abilityIconString(Hero.HAMMOND, Button.SECONDARY_FIRE), STR_HAMMOND_PROGRESS_2, abilityIconString(Hero.HAMMOND, Button.CROUCH), STR_HAMMOND_PROGRESS_3), HudPosition.TOP, -895, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

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

    hudHeader(eventPlayer if eventPlayer.isDead() and winner == null else [], "{}{}".format(STR_RESPAWN_IN, round(eventPlayer.timeUntilRespawn)), HudPosition.RIGHT, -100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(eventPlayer, eventPlayer.score+1, null, eventPlayer, HudPosition.LEFT, -sorted(getAllPlayers(), lambda x: x.score).index(eventPlayer), Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

    hudHeader(eventPlayer if winner == null else [], "{} {} {} ({}/{})".format(STR_YOU_ARE_ON, heroIcon(heroes[eventPlayer.score]), heroes[eventPlayer.score], eventPlayer.score+1, len(heroes)), HudPosition.TOP, -897, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if winner == null else [], "{} {} {}".format(STR_NEXT_HERO, heroIcon(heroes[eventPlayer.score+1]), heroes[eventPlayer.score+1]) if eventPlayer.score < len(heroes)-1 else STR_FINAL_HERO, HudPosition.TOP, -896, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    #Cannot be healed by teammates
    startHealingModification(eventPlayer, getAllPlayers().exclude(eventPlayer), 0, HealingReeval.RECEIVERS_AND_HEALERS)

    #Set score based on the min score
    eventPlayer.score = max(0, sorted([p for p in getAllPlayers() if p.score > 0], lambda x: x.score)[0].score)

    eventPlayer.setRespawnTime(respawnTime)


rule "player got a kill":
    @Event playerDealtFinalBlow
    @Condition attacker != victim
    #print(eventAbility)
    #Steal level if melee/piledriver kill
    if eventAbility == Button.MELEE or heroes[attacker.score] == Hero.HAMMOND and eventAbility == Button.CROUCH and victim.score > 0:
        victim.score--
        bigMessage(victim, "{}{}{}".format(STR_KILLED_BY_MELEE_1, abilityIconString(Hero.ANA, Button.MELEE), STR_KILLED_BY_MELEE_2))
        bigMessage(attacker, "{}{}{}".format(STR_MELEE_KILL_1, abilityIconString(Hero.ANA, Button.MELEE), STR_MELEE_KILL_2))
    
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
    hudHeader(getAllPlayers(), " \n\n{}{}{}\n\n".format(STR_DONT_START_GAME_1, hostPlayer, STR_DONT_START_GAME_2), HudPosition.TOP, -400, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
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
    @Condition not BUILD_MODE
    if getCurrentMap() not in [
        Map.AYUTTHAYA,
        Map.BLACK_FOREST,
        Map.BLACK_FOREST_WINTER,
        Map.ECOPOINT_ANTARCTICA,
        Map.ECOPOINT_ANTARCTICA_WINTER,
        Map.ILIOS_RUINS,
        Map.LIJIANG_CONTROL_CENTER,
        Map.LIJIANG_CONTROL_CENTER_LNY,
        Map.LIJIANG_GARDEN,
        Map.LIJIANG_GARDEN_LNY,
        Map.LIJIANG_NIGHT_MARKET,
        Map.LIJIANG_NIGHT_MARKET_LNY,
        Map.NECROPOLIS,
        Map.NEPAL_SANCTUM,
        Map.NEPAL_SHRINE,
        Map.NEPAL_VILLAGE,
        Map.OASIS_UNIVERSITY,
    ] or getCurrentGamemode() != Gamemode.ELIMINATION:
        hudHeader(getAllPlayers(), " \n\n{}{}{}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n- {}\n\n".format(STR_UNSUPPORTED_MAP_1, getCurrentMap(), STR_UNSUPPORTED_MAP_2, Map.AYUTTHAYA, Map.BLACK_FOREST, Map.ECOPOINT_ANTARCTICA, Map.ILIOS_RUINS, Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_GARDEN, Map.LIJIANG_NIGHT_MARKET, Map.NECROPOLIS, Map.NEPAL_SANCTUM, Map.NEPAL_SHRINE, Map.NEPAL_VILLAGE, Map.OASIS_UNIVERSITY), HudPosition.TOP, -99999, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    

rule "player suicided":
    @Event playerDied
    @Condition attacker == victim
    @Condition victim.score > 0
    bigMessage(victim, STR_KILLED_YOURSELF)
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


#!include "debug.opy"

rule "player is alive - teleport him and make him invulnerable":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition not BUILD_MODE
    eventPlayer.spawnIdx = random.randint(0, len(team1SpawnPos)-1)
    if eventPlayer.getTeam() == Team.1:
        eventPlayer.teleport(nearestWalkablePosition(
            team1SpawnPos[eventPlayer.spawnIdx][0] 
            + directionTowards(team1SpawnPos[eventPlayer.spawnIdx][0], team1SpawnPos[eventPlayer.spawnIdx][1]) * random.uniform(0, distance(team1SpawnPos[eventPlayer.spawnIdx][0], team1SpawnPos[eventPlayer.spawnIdx][1])) 
            + directionTowards(team1SpawnPos[eventPlayer.spawnIdx][0], team1SpawnPos[eventPlayer.spawnIdx][3]) * random.uniform(0, distance(team1SpawnPos[eventPlayer.spawnIdx][0], team1SpawnPos[eventPlayer.spawnIdx][3]))
        ))
        if team1FacingDirection != null:
            eventPlayer.setFacing(team1FacingDirection, Relativity.TO_WORLD)
        else:
            eventPlayer.setFacing(directionTowards(team1SpawnPos[eventPlayer.spawnIdx][0], team2SpawnPos[eventPlayer.spawnIdx][0]), Relativity.TO_WORLD)
    else:
        eventPlayer.teleport(nearestWalkablePosition(
            team2SpawnPos[eventPlayer.spawnIdx][0]
            + directionTowards(team2SpawnPos[eventPlayer.spawnIdx][0], team2SpawnPos[eventPlayer.spawnIdx][1]) * random.uniform(0, distance(team2SpawnPos[eventPlayer.spawnIdx][0], team2SpawnPos[eventPlayer.spawnIdx][1]))
            + directionTowards(team2SpawnPos[eventPlayer.spawnIdx][0], team2SpawnPos[eventPlayer.spawnIdx][3]) * random.uniform(0, distance(team2SpawnPos[eventPlayer.spawnIdx][0], team2SpawnPos[eventPlayer.spawnIdx][3]))
        ))
        if team2FacingDirection != null:
            eventPlayer.setFacing(team2FacingDirection, Relativity.TO_WORLD)
        else:
            eventPlayer.setFacing(directionTowards(team2SpawnPos[eventPlayer.spawnIdx][0], team1SpawnPos[eventPlayer.spawnIdx][0]), Relativity.TO_WORLD)

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

#!include "maps/ayutthaya.opy"
#!include "maps/black_forest.opy"
##!include "maps/castillo.opy"
#!include "maps/ecopoint_antarctica.opy"
#!include "maps/ilios_ruins.opy"
#!include "maps/lijiang_control_center.opy"
#!include "maps/lijiang_garden.opy"
#!include "maps/lijiang_night_market.opy"
#!include "maps/necropolis.opy"
#!include "maps/nepal_sanctum.opy"
#!include "maps/nepal_shrine.opy"
#!include "maps/nepal_village.opy"
#!include "maps/oasis_university.opy"

rule "mirror walls and spawns":
    for i in range(ceil(len(wallPos)/2)):
        wallPos.append([[
            wallPos[i][0] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][1] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][2] * mapSymVectMult + mapSymVectAdd,
            wallPos[i][3] * mapSymVectMult + mapSymVectAdd,
        ]])

    for i in range(len(team1SpawnPos)):
        #team1SpawnPos[i][3] = team1SpawnPos[i][0] + vectorTowards(team1SpawnPos[i][1], team1SpawnPos[i][2])
        team1SpawnPos[i].append(team1SpawnPos[i][0] + vectorTowards(team1SpawnPos[i][1], team1SpawnPos[i][2]))

        team2SpawnPos.append([[
            team1SpawnPos[i][0] * mapSymVectMult + mapSymVectAdd,
            team1SpawnPos[i][1] * mapSymVectMult + mapSymVectAdd,
            team1SpawnPos[i][2] * mapSymVectMult + mapSymVectAdd,
            team1SpawnPos[i][3] * mapSymVectMult + mapSymVectAdd,
        ]])

    if team1FacingDirection != null:
        team2FacingDirection = team1FacingDirection * mapSymVectMult

#!include "walls.opy"
#!include "build_mode.opy"
##!include "win_screen/winhud.opy"


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

    #if eventPlayer.couldNameBeGuessed:
    #    displayWinHuds = true
    #else:
    hudSubheader(getAllPlayers(), p" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.LEFT, -999, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudSubheader(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -999, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), " \n     {} {}     \n".format(eventPlayer, STR_PLAYER_WINS), HudPosition.TOP, -998, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(getAllPlayers(), " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -997, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
