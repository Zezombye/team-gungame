#!mainFile "../team_gungame.opy"


rule "castillo":
    @Condition getCurrentMap() in [Map.CASTILLO]

    if makeSpawnsCloser:
        team1SpawnPos = [[vect(17.837, 11.406, 23.264), vect(-2.976, 13.121, 21.742), vect(-3.291, 13.032, 25.381)]]
    else:
        team1SpawnPos = [[vect(-3.462, 11.619, 38.271), vect(-4.701, 11.303, 35.356), vect(16.713, 11.434, 29.343)]]

    wallPos = [
        [vect(-117.949, 35.282, 34.998), vect(-115.138, 35.282, 34.495), vect(-115.144, 32.62, 34.486), vect(-117.955, 32.62, 34.978)],
        [vect(-106.432, 35.846, 33.665), vect(-104.789, 35.846, 31.253), vect(-104.837, 32.687, 31.272), vect(-106.419, 32.687, 33.62)],
    ]

    #TODO trig shit to get the right vectors
    mapSymVectAdd = vect(0,0,38.79879*2)
    mapSymVectMult = angleToDirection(atan2Deg(-0.19009, 1), 0)

rule "walls application - castillo":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.CASTILLO]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x > 23 and eventPlayer.getPosition().y < 16.85 and eventPlayer.getPosition().z > 25:
                if getWallSideSign(0, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(0, eventPlayer) > -1:
                    eventPlayer.doNotSavePosition = true

            #check wall 2
            if eventPlayer.getPosition().x > 23 and eventPlayer.getPosition().y < 16.85 and eventPlayer.getPosition().z < 25 * -1 + 5*2:
                if getWallSideSign(2, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(2, eventPlayer) < 1:
                    eventPlayer.doNotSavePosition = true

        if not eventPlayer.doNotSavePosition:
            eventPlayer.lastValidPosition = eventPlayer.getPosition()
        wait(0.1)
        continue

        in_wall:
        #eventPlayer.applyImpulse(getWallImpulseDirection(2, +1), eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.teleport(eventPlayer.lastValidPosition)
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.016)
        wait()
        