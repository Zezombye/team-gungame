#!mainFile "../team_gungame.opy"

rule "lijiang control center":
    @Condition getCurrentMap() in [Map.LIJIANG_CONTROL_CENTER, Map.LIJIANG_CONTROL_CENTER_LNY]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(-26.759, 267, 317.095), vect(-41.585, 267, 302.318), vect(-39.473, 267, 300.071)],
            [vect(-26.759, 267, 317.095), vect(-41.585, 267, 302.318), vect(-39.473, 267, 300.071)],
            [vect(-26.759, 267, 317.095), vect(-41.585, 267, 302.318), vect(-39.473, 267, 300.071)],
            [vect(-26.759, 267, 317.095), vect(-41.585, 267, 302.318), vect(-39.473, 267, 300.071)],
            [vect(-34.482, 267, 293.774), vect(-36.574, 267, 291.523), vect(-34.778, 267, 289.796)],
        ]
    else:
        team1SpawnPos = [
            [vect(-41.684, 265, 326.905), vect(-46.106, 265, 331.261), vect(-50.092, 265, 327.253)],
            [vect(-41.684, 265, 326.905), vect(-46.106, 265, 331.261), vect(-50.092, 265, 327.253)],
            [vect(-41.684, 265, 326.905), vect(-46.106, 265, 331.261), vect(-50.092, 265, 327.253)],
            [vect(-27.178, 270, 340.086), vect(-30.872, 270, 343.392), vect(-28.362, 270, 345.942)],
        ]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(-1,1,1)

    wallPos = [
        [vect(-70.116, 269.735, 335.894), vect(-64.915, 269.735, 330.805), vect(-64.914, 266.5, 330.805), vect(-70.117, 266.5, 335.894)],
        [vect(-55.943, 270.722, 356.032), vect(-59.616, 270.722, 359.734), vect(-59.615, 267.5, 359.734), vect(-55.942, 267.5, 356.032)],
    ]
    
    team1FacingDirection = vect(1,0,-1)


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
        