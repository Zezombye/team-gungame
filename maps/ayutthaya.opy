#!mainFile "../team_gungame.opy"

rule "lijiang garden":
    @Condition getCurrentMap() in [Map.LIJIANG_GARDEN, Map.LIJIANG_GARDEN_LNY]

    if makeSpawnsCloser:
        team1SpawnPos = [[vect(-41.221, 94.9, 145.369), vect(-45.427, 94.9, 145.351), vect(-45.042, 98, 165.82)]]
    else:
        team1SpawnPos = [[vect(-75.691, 96, 152.582), vect(-82.93, 96, 152.55), vect(-82.952, 96, 142.303)]]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(-1,1,1)

    wallPos = [
        [vect(-83.368, 96, 132.082), vect(-83.369, 99.216, 132.082), vect(-76.413, 99.216, 132.082), vect(-76.414, 96, 132.082)],
        [vect(-87.934, 97, 156.138), vect(-87.935, 100.216, 156.138), vect(-93.048, 100.216, 156.138), vect(-93.049, 97, 156.138)],
    ]


rule "walls application - lijiang garden":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.LIJIANG_GARDEN, Map.LIJIANG_GARDEN_LNY]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x < -75:
                if eventPlayer.getPosition().z < 132.3:
                    goto in_wall
                if eventPlayer.getPosition().z < 133.3:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().x < -87:
                if eventPlayer.getPosition().z > 155.8:
                    goto in_wall
                if eventPlayer.getPosition().z > 154.8:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().x < -95:
                goto in_wall
            
            #check wall 2
            if eventPlayer.getPosition().x > 75:
                if eventPlayer.getPosition().z < 132.3:
                    goto in_wall
                if eventPlayer.getPosition().z < 133.3:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().x > 87:
                if eventPlayer.getPosition().z > 155.8:
                    goto in_wall
                if eventPlayer.getPosition().z > 154.8:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().x > 95:
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
        