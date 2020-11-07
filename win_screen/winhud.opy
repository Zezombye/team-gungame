#!mainFile "../team_gungame.opy"

#https://www.dafont.com/edition-12.font
#https://www.dafont.com/alkhemikal.font

globalvar displayWinHuds
globalvar winHudDisplayIndex

playervar j

playervar currentLetter
playervar playerName = ""
playervar playerLetters = []
playervar hudLines = []
playervar hudPadding = ""
playervar lineLength
playervar couldNameBeGuessed = false

#!include "win_screen/font.opy"

#!define BATTLETAG_MAX_LENGTH 12

#https://docs.oracle.com/cd/E29584_01/webhelp/mdex_basicDev/src/rbdv_chars_mapping.html

globalvar alphabetMappings = [
    p"0",
    p"1",
    p"2",
    p"3",
    p"4",
    p"5",
    p"6",
    p"7",
    p"8",
    p"9",
    p"AaÀÁÂÃÄÅÆàáâãäåæĀāĂăĄą",
    p"Bbß",
    p"CcÇçĆćĈĉĊċČč",
    p"DdĎďĐÐđ",
    p"EeÈÉÊËèéêëĒēĔĕĖėĘęĚě",
    p"Ff",
    p"GgĜĝĞğĠġĢģ",
    p"HhĤĥĦħ",
    p"IiÌÍÎÏìíîïĨĩĪīĬĭĮįİı",
    p"JjĴĵ",
    p"KkĶķĸ",
    p"LlĹĺĻļĽľĿŀŁł",
    p"Mm",
    p"NnÑñŃńŅņŇňŉŊŋ",
    p"OoÒÓÔÕÖØòóôõöøŌōŎŏŐő",
    p"PpÞþ",
    p"Qq",
    p"RrŔŕŖŗŘř",
    p"SsŚśŜŝŞşŠš",
    p"TtŢţŤťŦŧ",
    p"UuÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲų",
    p"Vv",
    p"WwŴŵ",
    p"Xx",
    p"YyÝýÿŶŷŸ",
    p"ZzŹźŻżŽž",
]

#!define HALFWIDTH_SPACE " "
#!define THIN_SPACE " "
#!define FULLWIDTH_SPACE " "
#!define MAX_CHARS_IN_LINE 132

rule "determine player name":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition not BUILD_MODE
    @Condition getTotalTimeElapsed() > 10
    wait(2)

    eventPlayer.playerName = "{}".format(eventPlayer)

    for eventPlayer.i in range(strLen(eventPlayer.playerName)):
        for eventPlayer.j in range(len(alphabetMappings)):
            if strContains(alphabetMappings[eventPlayer.j], eventPlayer.playerName.substring(eventPlayer.i, 1)):
                eventPlayer.playerLetters.append(eventPlayer.j)
                goto letter_found
            wait()

        #the current char is not in the alphabet, the name could not be found :(
        eventPlayer.couldNameBeGuessed = false
        return

        letter_found:
        wait()


    #Calculate the player's line length (not including padding)
    eventPlayer.lineLength = 0
    for eventPlayer.i in range(len(eventPlayer.playerLetters)):
        eventPlayer.lineLength += charLengths[eventPlayer.playerLetters[eventPlayer.i]]
        if eventPlayer.i < len(eventPlayer.playerLetters)-1:
            eventPlayer.lineLength += 2 #account for the space between letters
        wait()
    
    #Put padding
    for eventPlayer.i in range(floor((MAX_CHARS_IN_LINE-eventPlayer.lineLength)/2)):
        eventPlayer.hudPadding = "{}{}".format(eventPlayer.hudPadding, FULLWIDTH_SPACE)
        wait()

    if (MAX_CHARS_IN_LINE-eventPlayer.lineLength)%2 == 1:
        eventPlayer.hudPadding = "{}{}".format(eventPlayer.hudPadding, HALFWIDTH_SPACE)

    for eventPlayer.i in range(FONT_HEIGHT):
        eventPlayer.hudLines[eventPlayer.i] = ""

        for eventPlayer.j in range(len(eventPlayer.playerLetters)):
            eventPlayer.hudLines[eventPlayer.i] = "{}{}{}".format(
                eventPlayer.hudLines[eventPlayer.i], 
                charGlyphs[eventPlayer.playerLetters[eventPlayer.j]].substring(charLengths[eventPlayer.playerLetters[eventPlayer.j]]*eventPlayer.i, charLengths[eventPlayer.playerLetters[eventPlayer.j]]), 
                FONT_LETTER_SPACING if eventPlayer.j < len(eventPlayer.playerLetters)-1 else ""
            )
            wait()
        wait()

    eventPlayer.couldNameBeGuessed = true
        


#!define winHud(str, pos, sortOrder, hudreeval) hudSubheader(getAllPlayers() if displayWinHuds else [], str, pos, sortOrder, Color.GREEN, hudreeval, SpecVisibility.DEFAULT)

##!define winHudLineLeft(index) winHud("{}{}{}".format(winner.hudPadding, THIN_SPACE, winner.hudLines[index]), HudPosition.LEFT, -550+(index), HudReeval.VISIBILITY_AND_STRING)
##!define winHudLineRight(index) winHud("{}{}".format(winner.hudLines[index], winner.hudPadding), HudPosition.RIGHT, -550+(index), HudReeval.VISIBILITY_AND_STRING)

rule "display win huds":

    wait(5)
    winHud(b" \n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, -600, HudReeval.VISIBILITY)
    wait()
    winHud(" \n\n\n\n\n\n\n\n", HudPosition.LEFT, -600, HudReeval.VISIBILITY)
    wait()
    winHud(" \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.TOP, -9999, HudReeval.VISIBILITY)
    #wait()

    #winHud(" \n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, -590, HudReeval.VISIBILITY)
    #winHud(" \n\n\n\n\n\n\n\n\n\n", HudPosition.LEFT, -590, HudReeval.VISIBILITY)

    for winHudDisplayIndex in range(12):
        winHud("{}{}{}".format(winner.hudPadding, THIN_SPACE, winner.hudLines[evalOnce(winHudDisplayIndex)]), HudPosition.LEFT, -550+evalOnce(winHudDisplayIndex), HudReeval.VISIBILITY_AND_STRING)
        winHud("{}{}".format(winner.hudLines[evalOnce(winHudDisplayIndex)], winner.hudPadding), HudPosition.RIGHT, -550+evalOnce(winHudDisplayIndex), HudReeval.VISIBILITY_AND_STRING)
        wait()

    
    winHud(" \n\n", HudPosition.RIGHT, -500, HudReeval.VISIBILITY)
    winHud(" \n\n", HudPosition.LEFT, -500, HudReeval.VISIBILITY)

    winHud(
p"                                                 ▒▒      ▒▒  ▒▒                    ▒▒\n"
"                                                 ▒▒      ▒▒  ▒▒                    ▒▒", HudPosition.LEFT, -484, HudReeval.VISIBILITY)
    winHud(
p"                                                 ▒▒  ▒▒  ▒▒      ▒▒▒▒▒▒    ▒▒▒▒▒▒  ▒▒\n"
"                                                 ▒▒  ▒▒  ▒▒  ▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒", HudPosition.LEFT, -482, HudReeval.VISIBILITY)
    wait()
    winHud(
p"                                                 ▒▒  ▒▒  ▒▒  ▒▒  ▒▒   ▒▒  ▒▒       ▒▒\n"
"                                                 ▒▒▒ ▒▒ ▒▒▒  ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒   ▒▒", HudPosition.LEFT, -480, HudReeval.VISIBILITY)
    wait()
    winHud(
p"                                                  ▒▒ ▒▒ ▒▒   ▒▒  ▒▒   ▒▒   ▒▒▒▒▒▒  ▒▒\n"
"                                                  ▒▒▒▒▒▒▒▒   ▒▒  ▒▒   ▒▒       ▒▒    ", HudPosition.LEFT, -478, HudReeval.VISIBILITY)
    wait()
    winHud("                                                  ▒▒▒▒▒▒▒▒   ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒▒  ▒▒", HudPosition.LEFT, -477, HudReeval.VISIBILITY)
    winHud("                                                   ▒▒  ▒▒    ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒   ▒▒"
    /*"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"*/, HudPosition.LEFT, -476, HudReeval.VISIBILITY)

    winHud(
p"▒▒      ▒▒  ▒▒                    ▒▒                                                \n"
"▒▒      ▒▒  ▒▒                    ▒▒                                                ", HudPosition.RIGHT, -484, HudReeval.VISIBILITY)
    wait()
    winHud(
p"▒▒  ▒▒  ▒▒      ▒▒▒▒▒▒    ▒▒▒▒▒▒  ▒▒                                                \n"
"▒▒  ▒▒  ▒▒  ▒▒  ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒  ▒▒                                                ", HudPosition.RIGHT, -482, HudReeval.VISIBILITY)
    wait()
    winHud(
p"▒▒  ▒▒  ▒▒  ▒▒  ▒▒   ▒▒  ▒▒       ▒▒                                                \n"
"▒▒▒ ▒▒ ▒▒▒  ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒   ▒▒                                                ", HudPosition.RIGHT, -480, HudReeval.VISIBILITY)
    wait()
    winHud(
p" ▒▒ ▒▒ ▒▒   ▒▒  ▒▒   ▒▒   ▒▒▒▒▒▒  ▒▒                                                \n"
" ▒▒▒▒▒▒▒▒   ▒▒  ▒▒   ▒▒       ▒▒                                                    ", HudPosition.RIGHT, -478, HudReeval.VISIBILITY)
    wait()
    winHud(p" ▒▒▒▒▒▒▒▒   ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒▒  ▒▒                                                ", HudPosition.RIGHT, -477, HudReeval.VISIBILITY)
    wait()
    winHud(p"  ▒▒  ▒▒    ▒▒  ▒▒   ▒▒  ▒▒▒▒▒▒   ▒▒                                                
    \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.RIGHT, -476, HudReeval.VISIBILITY)
    
