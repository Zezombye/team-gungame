#!mainFile "team_gungame.opy"


rule "display walls":

    #walls must be: top left, top right, bottom right, bottom left
    #0 = top left
    #1 = top right
    #2 = bottom right
    #3 = bottom left
    for i in range(len(wallPos)):
        for j in range(4):
            createBeam(getAllPlayers(), Beam.GRAPPLE, wallPos[i][j], wallPos[i][(j+1)%4], Color.ORANGE, EffectReeval.VISIBILITY)

        diagStart = wallPos[i][0]
        diagEnd = wallPos[i][0]
        #diagonals from top
        while distance(wallPos[i][0], diagStart) < distance(wallPos[i][0], wallPos[i][1]) + distance(wallPos[i][1], wallPos[i][2]):

            diagStart += directionTowards(wallPos[i][0], wallPos[i][1]) * DIAGONAL_INTERVAL
            diagStartPos = diagStart
            if distance(wallPos[i][0], diagStart) > distance(wallPos[i][0], wallPos[i][1]):
                diagStartPos = wallPos[i][1] + directionTowards(wallPos[i][1], wallPos[i][2]) * (distance(wallPos[i][0], diagStart) - distance(wallPos[i][0], wallPos[i][1]))

            diagEnd += directionTowards(wallPos[i][0], wallPos[i][3]) * DIAGONAL_INTERVAL
            diagEndPos = diagEnd
            if distance(wallPos[i][0], diagEnd) > distance(wallPos[i][0], wallPos[i][3]):
                diagEndPos = wallPos[i][3] + directionTowards(wallPos[i][3], wallPos[i][2]) * (distance(wallPos[i][0], diagEnd) - distance(wallPos[i][0], wallPos[i][3]))
            createBeam(getAllPlayers(), Beam.GRAPPLE, diagStartPos, diagEndPos, Color.ORANGE, EffectReeval.VISIBILITY)

            wait()

        wait()