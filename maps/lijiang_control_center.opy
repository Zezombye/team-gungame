#!mainFile "../team_gungame.opy"

rule "lijiang control center":
    @Condition getCurrentMap() in [Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_CONTROL_CENTER_LNY]

    if makeSpawnsCloser:
        team1SpawnPos = [[vect(-29.686, 267, 314.473), vect(-23.744, 267, 300.64), vect(-31.399, 267, 292.141)]]
    else:
        team1SpawnPos = [[vect(-48.487, 265, 320.664), vect(-58.421, 265, 325.114), vect(-51.437, 265, 338.328)]]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(-1,1,1)

    wallPos = [
        [vect(-70.116, 269.735, 335.894), vect(-64.915, 269.735, 330.805), vect(-64.914, 266.5, 330.805), vect(-70.117, 266.5, 335.894)],
        [vect(-55.943, 270.722, 356.032), vect(-59.616, 270.722, 359.734), vect(-59.615, 267.5, 359.734), vect(-55.942, 267.5, 356.032)],
    ]


rule "walls application - lijiang control center":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_CONTROL_CENTER_LNY]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x < -64 and eventPlayer.getPosition().z > 325:
                if getWallSideSign(0, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(0, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().x < -48 and eventPlayer.getPosition().z > 355:
                if getWallSideSign(1, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(1, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().x < -78 and eventPlayer.getPosition().z > 360:
                goto in_wall

            #check wall 2
            if eventPlayer.getPosition().x > 64 and eventPlayer.getPosition().z > 325:
                if getWallSideSign(2, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(2, eventPlayer) < 1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().x > 48 and eventPlayer.getPosition().z > 355:
                if getWallSideSign(3, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(3, eventPlayer) < 1.5:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().x > 78 and eventPlayer.getPosition().z > 360:
                goto in_wall

        if not eventPlayer.doNotSavePosition:
            eventPlayer.lastValidPosition = eventPlayer.getPosition()
        wait(0.1)
        continue

        in_wall:
        #eventPlayer.applyImpulse(getWallImpulseDirection(2, +1), eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.teleport(eventPlayer.lastValidPosition)
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.016)
        wait()
        