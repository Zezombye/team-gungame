#!mainFile "../team_gungame.opy"

rule "nepal shrine":
    @Condition getCurrentMap() in [Map.NEPAL_SHRINE]

    if makeSpawnsCloser:
        team1SpawnPos = [[vect(-33.738, 10.875, 43.735), vect(-68.245, 11, 43.438), vect(-68.378, 11, 39.612)]]
    else:
        team1SpawnPos = [
            [vect(-22.068, 22, 76.953), vect(-25.698, 22, 77.033), vect(-25.719, 22, 70.259)],
            [vect(-32.967, 15, 70.008), vect(-41.322, 15, 70.393), vect(-41.154, 14.8, 63.886)],
            [vect(-32.967, 15, 70.008), vect(-41.322, 15, 70.393), vect(-41.154, 14.8, 63.886)],
            [vect(-55.424, 14.875, 67.452), vect(-67.207, 15, 67.375), vect(-67.575, 15, 64.181)],
            [vect(-55.424, 14.875, 67.452), vect(-67.207, 15, 67.375), vect(-67.575, 15, 64.181)],
        ]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(1,1,-1)

    wallPos = [
        [vect(-30.787, 16.568, -100.485), vect(-30.786, 19.732, -100.485), vect(-30.786, 19.732, -95.26), vect(-30.787, 16.568, -95.26)],
        [vect(-55.489, 16.568, -90.102), vect(-55.488, 19.713, -90.102), vect(-55.488, 19.713, -97.314), vect(-55.489, 16.568, -97.314)],
    ]


rule "walls application - nepal shrine":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.NEPAL_SHRINE]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().z < -94:
                if eventPlayer.getPosition().x > -31:
                    goto in_wall
                if eventPlayer.getPosition().x > -32:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().z < -89:
                if eventPlayer.getPosition().x < -55.30:
                    goto in_wall
                if eventPlayer.getPosition().x < -54.30:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().z < -101:
                goto in_wall
            
            #check wall 2
            if eventPlayer.getPosition().z > 94:
                if eventPlayer.getPosition().x > -31:
                    goto in_wall
                if eventPlayer.getPosition().x > -32:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().z > 89:
                if eventPlayer.getPosition().x < -55.30:
                    goto in_wall
                if eventPlayer.getPosition().x < -54.30:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().z > 101:
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
        