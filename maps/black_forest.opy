#!mainFile "../team_gungame.opy"

rule "black forest":
    @Condition getCurrentMap() in [Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER]

    if createWorkshopSetting(bool, "", "Make spawns closer", false):
        team1SpawnPos = [vect(6.52, 10.66, 33.65), vect(17.24, 11.47, 29.48)]
        team1SpawnPos = [vect(6.52, 10.66, 33.65 * -1 + 5*2), vect(17.24, 11.47, 29.48 * -1 + 5*2)]
    else:
        team1SpawnPos = [vect(11.079, 6.890, 34.397), vect(2.416, 7.099, 37.399)]
        team2SpawnPos = [vect(2.416, 7.099, -37.399), vect(11.079, 6.890, -34.397)]

    wallPos = [
        [vect(29.520, 15.35, 26.099), vect(27.658, 15.35, 29.154), vect(27.657, 12.121, 29.154), vect(29.519, 12.121, 26.099)],
        [vect(25.525, 15.35, 32.942), vect(23.715, 15.35, 35.962), vect(23.714, 12.086, 35.962), vect(25.524, 12.086, 32.942)],
        
        [vect(29.520, 15.35, 26.099 * -1 + 5*2), vect(27.658, 15.35, 29.154 * -1 + 5*2), vect(27.657, 12.121, 29.154 * -1 + 5*2), vect(29.519, 12.121, 26.099 * -1 + 5*2)],
        [vect(25.525, 15.35, 32.942 * -1 + 5*2), vect(23.715, 15.35, 35.962 * -1 + 5*2), vect(23.714, 12.086, 35.962 * -1 + 5*2), vect(25.524, 12.086, 32.942 * -1 + 5*2)],
    ]


rule "walls application - black forest":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x > 23 and eventPlayer.getPosition().y < 16.85 and eventPlayer.getPosition().z > 25:
                if getWallSideSign(0, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(0, eventPlayer) > -1:
                    eventPlayer.doNotSavePosition = true

            #check wall 2
            if eventPlayer.getPosition().x > 23 and eventPlayer.getPosition().y < 16.85 and eventPlayer.getPosition().z < 25 * -1 + 5*2:
                if getWallSideSign(2, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(2, eventPlayer) < 1:
                    eventPlayer.doNotSavePosition = true

            /*#check wall 1
            if eventPlayer.getPosition().z > 39:
                if getWallSideSign(1, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(1, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 2
            if eventPlayer.getPosition().x > 1.50 and eventPlayer.getPosition().z < -39:
                if getWallSideSign(2, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(2, eventPlayer) < 1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 3
            if eventPlayer.getPosition().z < -39:
                if getWallSideSign(3, eventPlayer) < 0.4:
                    goto in_wall
                if getWallSideSign(3, eventPlayer) < 1.5:
                    eventPlayer.doNotSavePosition = true*/


        if not eventPlayer.doNotSavePosition:
            eventPlayer.lastValidPosition = eventPlayer.getPosition()
        wait(0.1)
        continue

        in_wall:
        #eventPlayer.applyImpulse(getWallImpulseDirection(2, +1), eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.teleport(eventPlayer.lastValidPosition)
        eventPlayer.setStatusEffect(null, Status.ROOTED, 0.016)
        wait()
        