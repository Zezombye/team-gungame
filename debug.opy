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
/*
globalvar wallPosDebug = []

rule "debug position":
    print("position: {}".format(hostPlayer.getPosition()))
    createBeam(getAllPlayers(), Beam.GOOD, hostPlayer.getPosition()+vect(500, 0, 0), hostPlayer.getPosition()+vect(-500, 0, 0), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers(), Beam.GOOD, hostPlayer.getPosition()+vect(0, 0, 500), hostPlayer.getPosition()+vect(0, 0, -500), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    print("dot product: {}".format(getWallSideSign(0, hostPlayer)))
*/
/*
rule "point position":
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition(), 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers() if len(wallPosDebug) >= 1 else [], Beam.GOOD, wallPosDebug.last(), raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition(), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    print("Pointing at: {}".format(raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition()))

rule "confirm position":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    wallPosDebug.append(raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition())
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, wallPosDebug.last(), 0.25, EffectReeval.VISIBILITY)
    if len(wallPosDebug) >= 2:
        createBeam(getAllPlayers(), Beam.GOOD, wallPosDebug[len(wallPosDebug)-2], wallPosDebug.last(), Color.SKY_BLUE, EffectReeval.VISIBILITY)
*/


rule "lose hp":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    damage(eventPlayer, null, 50)