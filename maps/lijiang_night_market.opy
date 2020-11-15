#!mainFile "../team_gungame.opy"

rule "lijiang night market":
    @Condition getCurrentMap() in [Map.LIJIANG_NIGHT_MARKET, Map.LIJIANG_NIGHT_MARKET_LNY]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(-30.038, -2.971, -50.656), vect(-29.968, -2.982, -59.389), vect(-23.107, -2.993, -59.342)], 
            [vect(-38.342, 6, -47.294), vect(-31.717, 6, -47.218), vect(-31.694, 6, -40.836)],
            [vect(-27.894, 6, -8.163), vect(-27.777, 6, -15.423), vect(-24.065, 6, -15.269)],
        ]

    else:
        team1SpawnPos = [
            [vect(-40.828, 4, -15.67), vect(-35.343, 4, -15.638), vect(-35.336, 4, -12.117)],
            [vect(-35.57, -0.14, -24.901), vect(-41.049, -0.001, -24.817), vect(-41.133, -0.14, -35.946)],
            [vect(-35.57, -0.14, -24.901), vect(-41.049, -0.001, -24.817), vect(-41.133, -0.14, -35.946)],
            [vect(-35.57, -0.14, -24.901), vect(-41.049, -0.001, -24.817), vect(-41.133, -0.14, -35.946)],
            [vect(-49.634, 2, -38.618), vect(-49.546, 1.999, -47.101), vect(-54.203, 1.897, -47.173)],
            [vect(-49.634, 2, -38.618), vect(-49.546, 1.999, -47.101), vect(-54.203, 1.897, -47.173)],
        ]

    mapSymVectAdd = vect(1.85,0,0)
    mapSymVectMult = vect(-1,1,1)

    wallPos = [
        [vect(-78.633, 6.735, -38.089), vect(-71.375, 6.735, -38.098), vect(-71.374, 3.5, -38.098), vect(-78.632, 3.5, -38.089)],
        [vect(-82.843, 7.722, -13.708), vect(-87.979, 7.722, -13.72), vect(-87.978, 4.5, -13.72), vect(-82.842, 4.5, -13.708)],
    ]


rule "walls application - lijiang night market":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.LIJIANG_NIGHT_MARKET, Map.LIJIANG_NIGHT_MARKET_LNY]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x < -71:
                if eventPlayer.getPosition().z < -37.7:
                    goto in_wall
                if eventPlayer.getPosition().z < -36.7:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().x < -82.5:
                if eventPlayer.getPosition().z > -14:
                    goto in_wall
                if eventPlayer.getPosition().z > -15:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().x < -89.3:
                goto in_wall
            
            #check wall 2
            if eventPlayer.getPosition().x > 71+1.85:
                if eventPlayer.getPosition().z < -37.7:
                    goto in_wall
                if eventPlayer.getPosition().z < -36.7:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().x > 82.5+1.85:
                if eventPlayer.getPosition().z > -14:
                    goto in_wall
                if eventPlayer.getPosition().z > -15:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().x > 89.3+1.85:
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
        