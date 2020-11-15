#!mainFile "../team_gungame.opy"

rule "ayutthaya":
    @Condition getCurrentMap() in [Map.AYUTTHAYA]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(-6.145, 5, -29.604), vect(-6.138, 5, -26.007), vect(2.044, 5, -26.119)],
            [vect(-6.145, 5, -29.604), vect(-6.138, 5, -26.007), vect(2.044, 5, -26.119)],
            [vect(14.904, 6, -33.77), vect(21.241, 6, -33.841), vect(21.248, 6, -37.733)],
            [vect(14.904, 6, -33.77), vect(21.241, 6, -33.841), vect(21.248, 6, -37.733)],
            [vect(43.131, 5, -39.03), vect(38.001, 5, -39.126), vect(38.008, 5, -35.902)],
        ]
    else:
        team1SpawnPos = [
            [vect(-8.836, 6, -55.562), vect(-2.218, 6, -55.514), vect(-2.113, 6, -50.649)],
            [vect(-8.836, 6, -55.562), vect(-2.218, 6, -55.514), vect(-2.113, 6, -50.649)],
            [vect(14.831, 0.728, -55.215), vect(14.819, 1, -62.366), vect(21.922, 1, -62.367)],
            [vect(14.831, 0.728, -55.215), vect(14.819, 1, -62.366), vect(21.922, 1, -62.367)],
            [vect(37.006, 3, -56.533), vect(41.581, 3, -56.539), vect(41.587, 3, -51.979)],
        ]

    mapSymVectAdd = vect(16+18,0,-7.1125*2)
    mapSymVectMult = vect(-1,1,-1)

    wallPos = [
        [vect(14.712, 5.974, -84.225), vect(21.455, 5.974, -84.225), vect(21.456, 1, -84.225), vect(14.713, 1, -84.225)],
        [vect(34.331, 6.35, -77.141), vect(37.701, 6.35, -77.141), vect(37.7, 3, -77.141), vect(34.33, 3, -77.141)],
    ]

    team1FacingDirection = vect(0,0,1)


rule "walls application - ayutthaya":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.AYUTTHAYA]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().z < -84:
                goto in_wall
            if eventPlayer.getPosition().z < -83:
                eventPlayer.doNotSavePosition = true

            #check wall 1
            if eventPlayer.getPosition().x > 34:
                if eventPlayer.getPosition().z < -77:
                    goto in_wall
                if eventPlayer.getPosition().z < -76:
                    eventPlayer.doNotSavePosition = true
            
            #check wall 2
            if eventPlayer.getPosition().z > 84-7.1125*2:
                goto in_wall
            if eventPlayer.getPosition().z > 83-7.1125*2:
                eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().x < 0:
                if eventPlayer.getPosition().z > 77-7.1125*2:
                    goto in_wall
                if eventPlayer.getPosition().z > 76-7.1125*2:
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
        