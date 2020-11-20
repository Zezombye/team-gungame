#!mainFile "../team_gungame.opy"

rule "nepal sanctum":
    @Condition getCurrentMap() in [Map.NEPAL_SANCTUM]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(83.254, 131.8, 37.964), vect(79.013, 131.8, 37.921), vect(79.004, 131.875, 34.663)],
            [vect(63.722, 128, 37.954), vect(68.363, 128.052, 37.896), vect(68.56, 128.429, 43.317)],
            [vect(109.704, 131.8, 35.206), vect(112.433, 131.8, 35.203), vect(112.505, 132.008, 39.614)],
        ]

    else:
        team1SpawnPos = [[vect(91.28, 130.324, 75.711), vect(74.686, 129.8, 75.672), vect(74.647, 130, 66.752)]]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(1,1,-1)

    wallPos = [
        [vect(68.556, 134.716, 93.625), vect(68.556, 134.716, 86.36), vect(68.555, 131.58, 86.36), vect(68.555, 131.58, 93.625)],
        [vect(93.419, 134.716, 91.364), vect(93.419, 134.716, 96.611), vect(93.418, 131.58, 96.611), vect(93.418, 131.58, 91.364)],
    ]


rule "walls application - nepal sanctum":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.NEPAL_SANCTUM]
    @Disabled

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().z > 86:
                if eventPlayer.getPosition().x < 68.9:
                    goto in_wall
                if eventPlayer.getPosition().x < 69.9:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().z > 91:
                if eventPlayer.getPosition().x > 93.1:
                    goto in_wall
                if eventPlayer.getPosition().x > 92.1:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().z > 98:
                goto in_wall
            
            #check wall 2
            if eventPlayer.getPosition().z < -86:
                if eventPlayer.getPosition().x < 68.9:
                    goto in_wall
                if eventPlayer.getPosition().x < 69.9:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().z < -91:
                if eventPlayer.getPosition().x > 93.1:
                    goto in_wall
                if eventPlayer.getPosition().x > 92.1:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().z < -98:
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
        