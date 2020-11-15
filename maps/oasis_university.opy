#!mainFile "../team_gungame.opy"

rule "oasis university":
    @Condition getCurrentMap() in [Map.OASIS_UNIVERSITY]

    if makeSpawnsCloser:
        team1SpawnPos = [
            [vect(-200.428, 16, 21.625), vect(-200.335, 16, 18.52), vect(-195.291, 16, 18.578)],
            [vect(-200.428, 16, 21.625), vect(-200.335, 16, 18.52), vect(-195.291, 16, 18.578)],
            [vect(-180.713, 16, 18.476), vect(-180.736, 16, 21.863), vect(-175.261, 16, 21.906)],
            [vect(-180.713, 16, 18.476), vect(-180.736, 16, 21.863), vect(-175.261, 16, 21.906)],
            [vect(-191.96, 9, 24.034), vect(-195.655, 9, 24.076), vect(-195.635, 9, 20.646)],
        ]
    else:
        team1SpawnPos = [
            [vect(-169.737, 15, 40.898), vect(-199.747, 15, 41.018), vect(-199.907, 15, 37.307)],
        ]

    mapSymVectAdd = vect(0,0,0)
    mapSymVectMult = vect(1,1,-1)

    wallPos = [
        [vect(-186.241, 24.374, 70), vect(-189.728, 24.374, 70), vect(-189.729, 20.062, 70), vect(-186.242, 20.062, 70)],
        [vect(-173.623, 23.474, 70), vect(-176.371, 23.474, 70), vect(-176.372, 20.05, 70), vect(-173.622, 20.05, 70)],
        [vect(-199.602, 23.299, 70), vect(-202.351, 23.299, 70), vect(-202.352, 20.05, 70), vect(-199.603, 20.05, 70)],
    ]


rule "walls application - oasis university":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition getCurrentMap() in [Map.OASIS_UNIVERSITY]

    while true:
        eventPlayer.doNotSavePosition = false
        if eventPlayer.hasBeenTeleported:
            #check wall 0,1,2
            if eventPlayer.getPosition().x > -205:
                if eventPlayer.getPosition().z > 69.6:
                    goto in_wall
                if eventPlayer.getPosition().z > 68.6:
                    eventPlayer.doNotSavePosition = true

            #check wall 3,4,5
            if eventPlayer.getPosition().x > -205:
                if eventPlayer.getPosition().z < -69.6:
                    goto in_wall
                if eventPlayer.getPosition().z < -68.6:
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
        