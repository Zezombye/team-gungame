#!mainFile "../team_gungame.opy"

rule "necropolis":
    @Condition getCurrentMap() in [Map.NECROPOLIS]

    team1SpawnPos = [
        [vect(-30.825, 4.754, 27.093), vect(-12.177, 7.288, 28.251), vect(-11.35, 3.003, 21.423)],
        [vect(-30.825, 4.754, 27.093), vect(-12.177, 7.288, 28.251), vect(-11.35, 3.003, 21.423)],
        [vect(-30.825, 4.754, 27.093), vect(-12.177, 7.288, 28.251), vect(-11.35, 3.003, 21.423)],
        [vect(-9.597, 8.283, 27.727), vect(10.761, 10.002, 28.448), vect(16.031, 8.255, 23.503)],
        [vect(-9.597, 8.283, 27.727), vect(10.761, 10.002, 28.448), vect(16.031, 8.255, 23.503)],
        [vect(-9.597, 8.283, 27.727), vect(10.761, 10.002, 28.448), vect(16.031, 8.255, 23.503)],
        [vect(-9.597, 8.283, 27.727), vect(10.761, 10.002, 28.448), vect(16.031, 8.255, 23.503)],
    ]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(1,1,-1)

    wallPos = [
        [vect(-9.487, 6.699, 22.212), vect(-9.487, 6.699, 23.843), vect(-9.487, 3, 23.844), vect(-9.487, 3, 22.213)],
        [vect(13.023, 6.699, 19.306), vect(11.874, 6.699, 18.183), vect(11.874, 3.007, 18.184), vect(13.023, 3.007, 19.307)],
    ]


rule "walls application - necropolis":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.NECROPOLIS]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            if eventPlayer.getPosition().y < 7:
                #check wall 0
                if eventPlayer.getPosition().z > 17.85 and eventPlayer.getPosition().x < 11.5:
                    if eventPlayer.getPosition().x > -9.75:
                        goto in_wall
                    if eventPlayer.getPosition().x > -10.75:
                        eventPlayer.doNotSavePosition = true

                #check wall 1
                if eventPlayer.getPosition().z > 17.5 and eventPlayer.getPosition().x < 13 and eventPlayer.getPosition().x > 0:
                    if getWallSideSign(1, eventPlayer) > -0.4:
                        goto in_wall
                    if getWallSideSign(1, eventPlayer) > -1:
                        eventPlayer.doNotSavePosition = true
                
                #check wall 2
                if eventPlayer.getPosition().z < -17.85 and eventPlayer.getPosition().x < 11.5:
                    if eventPlayer.getPosition().x > -9.75:
                        goto in_wall
                    if eventPlayer.getPosition().x > -10.75:
                        eventPlayer.doNotSavePosition = true

                #check wall 3
                if eventPlayer.getPosition().z < -17.5 and eventPlayer.getPosition().x < 13 and eventPlayer.getPosition().x > 0:
                    if getWallSideSign(3, eventPlayer) < 0.4:
                        goto in_wall
                    if getWallSideSign(3, eventPlayer) < 1:
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
        