#!mainFile "team_gungame.opy"

rule "debug":
    @Condition DEBUG_MODE

    createDummy(Hero.ANA, Team.1, -1, null, null)
    createDummy(Hero.ANA, Team.1, -1, null, null)
    createDummy(Hero.ANA, Team.1, -1, null, null)
    createDummy(Hero.ANA, Team.1, -1, null, null)
    createDummy(Hero.ANA, Team.1, -1, null, null)
    createDummy(Hero.ANA, Team.1, -1, null, null)

    createDummy(Hero.ANA, Team.2, -1, null, null)
    createDummy(Hero.ANA, Team.2, -1, null, null)
    createDummy(Hero.ANA, Team.2, -1, null, null)
    createDummy(Hero.ANA, Team.2, -1, null, null)
    createDummy(Hero.ANA, Team.2, -1, null, null)
    createDummy(Hero.ANA, Team.2, -1, null, null)


rule "debug - dummy fire":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    #eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getClosestPlayer(eventPlayer.getPosition(), getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 30, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    while true:
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        wait(1)
/*
globalvar spawnPos = []

rule "spawn pos beam":
    createBeam(getAllPlayers(), Beam.GOOD, spawnPos.last() + Vector.UP, hostPlayer.getPosition()+Vector.UP, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

rule "create spawn positions":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    spawnPos.append(eventPlayer.getPosition())*/

rule "lose hp":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition not BUILD_MODE and DEBUG_MODE
    damage(eventPlayer, null, 50)