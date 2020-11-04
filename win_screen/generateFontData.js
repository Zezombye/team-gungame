
const FONT_HEIGHT = 12;
const FULLWIDTH_SPACE = " "

var charLengths = [];
var charGlyphs = [];

//12*10 = 120 < 128, just under the limit

for (var char in font) {
    var currentCharLines = [];
    var currentCharLength = 0;
    for (var line of font[char]) {
        if (line.length > currentCharLength) {
            currentCharLength = line.length;
        }
        currentCharLines.push(line);
    }
    for (var i = currentCharLines.length; i < FONT_HEIGHT; i++) {
        currentCharLines.push("");
    }
    for (var i = 0; i < currentCharLines.length; i++) {
        currentCharLines[i] = currentCharLines[i].padEnd(currentCharLength, " ");
    }

    currentCharLines = currentCharLines.map(x => x.replace(/ /g, FULLWIDTH_SPACE).replace(/#/g, "▒"));

    charGlyphs.push(currentCharLines.join(""));
    charLengths.push(currentCharLength);
}

`
globalvar charLengths = ${JSON.stringify(charLengths)}
globalvar charGlyphs = ${JSON.stringify(charGlyphs)}
`
