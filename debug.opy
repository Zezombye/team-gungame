#!mainFile "team_gungame.opy"

rule "debug":

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
    @Condition not BUILD_MODE
    damage(eventPlayer, null, 50)