#!mainFile "../team_gungame.opy"

rule "nepal village":
    @Condition getCurrentMap() in [Map.NEPAL_VILLAGE]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(-183.229, -90.014, 37.221), vect(-183.191, -90.017, 33.632), vect(-177.491, -90.111, 33.752)],
            [vect(-163.112, -89.102, 32.825), vect(-160.849, -89.64, 37.239), vect(-156.653, -89.557, 36.962)],
            [vect(-189.021, -93.985, 30.644), vect(-197.257, -93.911, 30.913), vect(-197.261, -93.963, 26.867)],
        ]
    else:
        team1SpawnPos = [
            [vect(-181.977, -99.073, 73.797), vect(-156.424, -97.607, 63.023), vect(-153.579, -98.018, 72.433)]
        ]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(1,1,-1)

    wallPos = [
        [vect(-164.322, -94.215, 94.723), vect(-167.698, -94.215, 88.297), vect(-167.697, -97.33, 88.297), vect(-164.321, -97.33, 94.723)],
        [vect(-143.581, -94.223, 81.383), vect(-141.138, -94.223, 86.065), vect(-141.139, -97.33, 86.065), vect(-143.58, -97.33, 81.383)],
    ]


rule "walls application - nepal village":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.NEPAL_VILLAGE]
    @Disabled

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x > -176 and eventPlayer.getPosition().z > 87:
                if getWallSideSign(0, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(0, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().y < -95 and eventPlayer.getPosition().z > 78:
                if getWallSideSign(1, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(1, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check spawn team 1
            if eventPlayer.getPosition().z > 98:
                goto in_wall

            #check wall 2
            if eventPlayer.getPosition().x > -176 and eventPlayer.getPosition().z < -87:
                if getWallSideSign(2, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(2, eventPlayer) < 1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().y < -95 and eventPlayer.getPosition().z < -78:
                if getWallSideSign(3, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(3, eventPlayer) < 1.5:
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
        