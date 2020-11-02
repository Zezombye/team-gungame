#!mainFile "../team_gungame.opy"

rule "ecopoint":
    @Condition getCurrentMap() in [Map.ECOPOINT_ANTARCTICA, Map.ECOPOINT_ANTARCTICA_WINTER]

    if createWorkshopSetting(bool, "", "Make spawns closer", false):
        team1SpawnPos = [vect(-3.41, 11.63, 26.21), vect(5.72, 11.63, 24)]
        team2SpawnPos = [vect(-3.41, 11.63, -26.21), vect(5.72, 11.63, -24)]
    else:
        team1SpawnPos = [vect(11.079, 6.890, 34.397), vect(2.416, 7.099, 37.399)]
        team2SpawnPos = [vect(2.416, 7.099, -37.399), vect(11.079, 6.890, -34.397)]

    wallPos = [
        [vect(10.250, 11.661, 40.467), vect(6.088, 11.652, 41.794), vect(6.120, 7.169, 41.879), vect(10.238, 7.035, 40.464)],
        [vect(-7.451, 9.833, 41.413), vect(-8.998, 9.804, 39.832), vect(-8.978, 7.080, 39.849), vect(-7.436, 7.080, 41.399)],

        
        [vect(10.250, 11.661, -40.467), vect(6.088, 11.652, -41.794), vect(6.120, 7.169, -41.879), vect(10.238, 7.035, -40.464)],
        [vect(-7.451, 9.833, -41.413), vect(-8.998, 9.804, -39.832), vect(-8.978, 7.080, -39.849), vect(-7.436, 7.080, -41.399)],
    ]


rule "walls application - ecopoint":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.ECOPOINT_ANTARCTICA, Map.ECOPOINT_ANTARCTICA_WINTER]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0
            if eventPlayer.getPosition().x > -1.50 and eventPlayer.getPosition().z > 39:
                if getWallSideSign(0, eventPlayer) > -0.4:
                    goto in_wall
                if getWallSideSign(0, eventPlayer) > -1.5:
                    eventPlayer.doNotSavePosition = true

            #check wall 1
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
        