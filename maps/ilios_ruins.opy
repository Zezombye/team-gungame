#!mainFile "../team_gungame.opy"

rule "ilios ruins":
    @Condition getCurrentMap() in [Map.ILIOS_RUINS]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(67.068, 60.367, -165.009), vect(63.866, 60.367, -163.745), vect(63.916, 60.367, -140.476)],
            [vect(67.068, 60.367, -165.009), vect(63.866, 60.367, -163.745), vect(63.916, 60.367, -140.476)],
            [vect(67.068, 60.367, -165.009), vect(63.866, 60.367, -163.745), vect(63.916, 60.367, -140.476)],
            [vect(62.691, 60.367, -172.192), vect(62.773, 60.367, -178.948), vect(60.546, 60.367, -178.936)],

        ]

    else:
        team1SpawnPos = [
            [vect(123.665, 62.757, -167.735), vect(123.719, 62.752, -159.475), vect(128.654, 62.728, -159.766)],
            [vect(123.665, 62.757, -167.735), vect(123.719, 62.752, -159.475), vect(128.654, 62.728, -159.766)],
            [vect(123.665, 62.757, -167.735), vect(123.719, 62.752, -159.475), vect(128.654, 62.728, -159.766)],
            [vect(124.798, 64.728, -177.647), vect(125.124, 64.949, -181.247), vect(128.197, 64.728, -181.171)],
        ]

    mapSymVectAdd = vect(28.6*2,0,0)
    mapSymVectMult = vect(-1,1,1)

    wallPos = [
        [vect(134.648, 66.097, -150.105), vect(127.271, 66.097, -150.105), vect(127.27, 62.675, -150.105), vect(134.647, 62.675, -150.105)],
        [vect(133.748, 66.097, -172.03), vect(138.644, 66.097, -172.03), vect(138.645, 62.608, -172.03), vect(133.749, 62.608, -172.03)],
    ]


rule "walls application - ilios ruins":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.ILIOS_RUINS]
    @Disabled

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x > 125:
                if eventPlayer.getPosition().z > -150.4:
                    goto in_wall
                if eventPlayer.getPosition().z > -151.4:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().x > 133:
                if eventPlayer.getPosition().z < -171.7:
                    goto in_wall
                if eventPlayer.getPosition().z < -170.7:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().x > 140:
                goto in_wall
            
            #check wall 2
            if eventPlayer.getPosition().x < -125+28.6*2:
                if eventPlayer.getPosition().z > -150.4:
                    goto in_wall
                if eventPlayer.getPosition().z > -151.4:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().x < -133+28.6*2:
                if eventPlayer.getPosition().z < -171.7:
                    goto in_wall
                if eventPlayer.getPosition().z < -170.7:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 2
            if eventPlayer.getPosition().x < -140+28.6*2:
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
        