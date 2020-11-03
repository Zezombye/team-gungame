#!mainFile "../team_gungame.opy"

rule "black forest":
    @Condition getCurrentMap() in [Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER]

    if makeSpawnsCloser:
        team1SpawnPos = [vect(17.837, 11.406, 23.264), vect(-2.976, 13.121, 21.742), vect(-3.291, 13.032, 25.381)]
    else:
        team1SpawnPos = [vect(-3.462, 11.619, 38.271), vect(-4.701, 11.303, 35.356), vect(16.713, 11.434, 29.343)]

    wallPos = [
        [vect(29.520, 15.35, 26.099), vect(27.658, 15.35, 29.154), vect(27.657, 12.121, 29.154), vect(29.519, 12.121, 26.099)],
        [vect(25.525, 15.35, 32.942), vect(23.715, 15.35, 35.962), vect(23.714, 12.086, 35.962), vect(25.524, 12.086, 32.942)],
    ]

    mapSymVectAdd = vect(0,0,5*2)
    mapSymVectMult = vect(1,1,-1)


rule "walls application - black forest":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER]

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
        