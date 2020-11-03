
settings "settings.opy.json"
##!obfuscate noNameObfuscation noInspectorObfuscation noRuleFilling noConstantObfuscation

#!define BUILD_MODE false
#!define DEBUG_MODE true

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
    Hero.SOLDIER,

    /*Hero.ROADHOG,
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

    Hero.ANA,
    Hero.MOIRA,
    Hero.ZENYATTA,
    Hero.MERCY,
    Hero.BAPTISTE,
    Hero.BRIGITTE,
    Hero.LUCIO,

    Hero.HAMMOND,*/
    Hero.TORBJORN,
]

globalvar makeSpawnsCloser = createWorkshopSetting(bool, "", "Make spawns closer", false)

globalvar team1SpawnPos
globalvar team2SpawnPos
globalvar wallPos

globalvar winner = null

globalvar mapSymVectMult
globalvar mapSymVectAdd

globalvar i
globalvar j
globalvar diagStart
globalvar diagEnd
globalvar diagStartPos
globalvar diagEndPos
#!define DIAGONAL_INTERVAL 1

#!define getWallSideSign(wallNb, player) dotProduct(vectorTowards(wallPos[wallNb][0], (player).getPosition()), angleToDirection(horizontalAngleFromDirection(directionTowards(wallPos[wallNb][0], wallPos[wallNb][1]))+90, 0))

#!define getWallImpulseDirection(wallNb, sign) angleToDirection(horizontalAngleFromDirection(directionTowards(wallPos[wallNb][0], wallPos[wallNb][1])) + (sign) * 90, 0)

#!define HERO_STUN_TIME 0.7

#!define sortedScoreHudTeam1(i) hudText(getAllPlayers().exclude(sorted(getAllPlayers(), lambda x: x.score)[i]) if len(getAllPlayers()) > (i) and sorted(getAllPlayers(), lambda x: x.score)[i].getTeam() == Team.1 else [], sorted(getAllPlayers(), lambda x: x.score)[i].score + 1, null, sorted(getAllPlayers(), lambda x: x.score)[i], HudPosition.LEFT, -(i), Color.TEAM_1, Color.WHITE, Color.TEAM_1, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

#!define sortedScoreHudTeam2(i) hudText(getAllPlayers().exclude(sorted(getAllPlayers(), lambda x: x.score)[i]) if len(getAllPlayers()) > (i) and sorted(getAllPlayers(), lambda x: x.score)[i].getTeam() == Team.2 else [], sorted(getAllPlayers(), lambda x: x.score)[i].score + 1, null, sorted(getAllPlayers(), lambda x: x.score)[i], HudPosition.LEFT, -(i), Color.TEAM_2, Color.WHITE, Color.TEAM_2, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

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
    
    sortedScoreHudTeam1(0)
    sortedScoreHudTeam1(1)
    sortedScoreHudTeam1(2)
    sortedScoreHudTeam1(3)
    sortedScoreHudTeam1(4)
    sortedScoreHudTeam1(5)
    sortedScoreHudTeam1(6)
    sortedScoreHudTeam1(7)
    sortedScoreHudTeam1(8)
    sortedScoreHudTeam1(9)
    sortedScoreHudTeam1(10)
    sortedScoreHudTeam1(11)

    sortedScoreHudTeam2(0)
    sortedScoreHudTeam2(1)
    sortedScoreHudTeam2(2)
    sortedScoreHudTeam2(3)
    sortedScoreHudTeam2(4)
    sortedScoreHudTeam2(5)
    sortedScoreHudTeam2(6)
    sortedScoreHudTeam2(7)
    sortedScoreHudTeam2(8)
    sortedScoreHudTeam2(9)
    sortedScoreHudTeam2(10)
    sortedScoreHudTeam2(11)

    #setObjectiveDescription(getAllPlayers(), "Made by Zezombye - discord.gg/somesh1t", HudReeval.VISIBILITY)

rule "init player":
    @Event eachPlayer
    chase(eventPlayer.stunTime, 0, rate=1, ChaseReeval.NONE)
    chase(eventPlayer.timeUntilRespawn, 0, rate=1, ChaseReeval.NONE)
    chase(eventPlayer.invulnTime, 0, rate=1, ChaseReeval.NONE)

    #Invuln ring effects
    for eventPlayer.i in range(0.1, 0.6, 0.1):
        createEffect(getAllPlayers() if eventPlayer.invulnTime else [], Effect.RING, Color.YELLOW, eventPlayer.getPosition() + vect(0,2,0), evalOnce(eventPlayer.i), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    hudSubtext(eventPlayer if eventPlayer.invulnTime else [], " \n\n\n\n\n\n\n\n\n\nInvulnerable: {}".format(eventPlayer.invulnTime), HudPosition.TOP, -100, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudHeader(eventPlayer if eventPlayer.isDead() else [], "Respawn in: {}".format(floor(eventPlayer.timeUntilRespawn)), HudPosition.RIGHT, -100, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

    hudText(eventPlayer, eventPlayer.score+1, null, eventPlayer, HudPosition.LEFT, -sorted(getAllPlayers(), lambda x: x.score).index(eventPlayer), Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

    setObjectiveDescription(eventPlayer, "You are on {} {} ({}/{})".format(heroIcon(heroes[eventPlayer.score]), heroes[eventPlayer.score], eventPlayer.score+1, len(heroes)), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING)

    #Cannot be healed by teammates
    startHealingModification(eventPlayer, getAllPlayers().exclude(eventPlayer), 0, HealingReeval.RECEIVERS_AND_HEALERS)

rule "player got a kill":
    @Event playerDealtFinalBlow
    @Condition attacker != victim
    #print(eventAbility)
    #Steal level if melee/piledriver kill
    if eventAbility == Button.MELEE or heroes[attacker.score] == Hero.HAMMOND and eventAbility == Button.CROUCH:
        victim.score--
    
    #Do not grant score for torb if not primary, or for hammond if not roll/piledriver
    if eventAbility != Button.PRIMARY_FIRE and heroes[attacker.score] == Hero.TORBJORN:
        return
    
    if heroes[attacker.score] == Hero.HAMMOND and eventAbility != Button.CROUCH and eventAbility != Button.SECONDARY_FIRE:
        return

    #Do not grant multiple kills if hog/hammond
    if (heroes[attacker.score] == Hero.HAMMOND or heroes[attacker.score] == Hero.TORBJORN) and heroes[attacker.score] != attacker.getCurrentHero():
        return
    
    
    attacker.score++

rule "player died":
    @Event playerDied
    eventPlayer.timeUntilRespawn = 2.99999
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
        hudHeader(getAllPlayers(), " \n\nThe map {} is not supported!\nSupported maps:"/*"\n- Black Forest\n- Castillo"*/"\n- Ecopoint: Antarctica".format(getCurrentMap()), HudPosition.TOP, -99999, Color.RED, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    

rule "player suicided":
    @Event playerDied
    @Condition attacker == victim
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
    eventPlayer.invulnTime = 2

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
    bigMessage(getAllPlayers(), "{} wins!".format(eventPlayer))
    winner = eventPlayer
    displayWinHuds = true
    setObjectiveDescription(getAllPlayers(), "                      sqdfdfqsqdfsqsdffdqs                                                                                                                                                                                                                                                         \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudReeval.VISIBILITY_AND_STRING)
