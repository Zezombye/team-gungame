#!mainFile "team_gungame.opy"

globalvar wallPosDebug = []

rule "debug position":
    @Condition BUILD_MODE
    wait(5)
    print("position: {}".format(hostPlayer.getPosition()))
    createBeam(getAllPlayers(), Beam.GRAPPLE, hostPlayer.getPosition()+vect(500, 0.1, 0), hostPlayer.getPosition()+vect(-500, 0.1, 0), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers(), Beam.GRAPPLE, hostPlayer.getPosition()+vect(0, 0.1, 500), hostPlayer.getPosition()+vect(0, 0.1, -500), Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    for i in range(len(team1SpawnPos)):
        createBeam(getAllPlayers(), Beam.GOOD, team1SpawnPos[i][0], team1SpawnPos[i][1], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team1SpawnPos[i][1], team1SpawnPos[i][2], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team1SpawnPos[i][2], team1SpawnPos[i][3], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team1SpawnPos[i][3], team1SpawnPos[i][0], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team2SpawnPos[i][0], team2SpawnPos[i][1], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team2SpawnPos[i][1], team2SpawnPos[i][2], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team2SpawnPos[i][2], team2SpawnPos[i][3], Color.BLUE, EffectReeval.VISIBILITY)
        createBeam(getAllPlayers(), Beam.GOOD, team2SpawnPos[i][3], team2SpawnPos[i][0], Color.BLUE, EffectReeval.VISIBILITY)
    

    print("dot product: {}".format(getWallSideSign(1, hostPlayer)))


rule "point position":
    @Condition BUILD_MODE
    wait(5)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition(), 0.25, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createBeam(getAllPlayers() if len(wallPosDebug) >= 1 else [], Beam.GOOD, wallPosDebug.last(), raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition(), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    print("Pointing at: {}".format(raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition()))

rule "confirm position":
    @Condition BUILD_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    wallPosDebug.append(raycast(hostPlayer.getEyePosition(), hostPlayer.getEyePosition() + hostPlayer.getFacingDirection()*200, [], [], false).getHitPosition())
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, wallPosDebug.last(), 0.25, EffectReeval.VISIBILITY)
    if len(wallPosDebug) >= 2:
        createBeam(getAllPlayers(), Beam.GOOD, wallPosDebug[len(wallPosDebug)-2], wallPosDebug.last(), Color.SKY_BLUE, EffectReeval.VISIBILITY)
