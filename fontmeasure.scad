include <arial.scad>;

FONTS = [ FONT_ArialMT ];

echo(FONTS[0][0]);

BOLD = 1;
ITALIC = 2;
CONDENSED = 32;

function startswith(a,b,offset=0,position=0) =
    len(a)-offset < len(b) ? false : 
    position >= len(b) ? true :
    a[offset+position] != b[position] ? false :
    startswith(a,b,offset=offset,position=position+1);

function findsubstring(a,b,position=0) =
    len(a)-position < len(b) ? -1 :
    startswith(a,b,offset=position) ? position :
    findsubstring(a,b,position=position+1);
    
function style(a,b,n) =
    findsubstring(a,b) >= 0 ? n : 0;
    
function substring(a,start,end=undef,soFar="") =
    start >= len(a) || (end != undef && start >= end) ? soFar :
    substring(a,start+1,end=end,soFar=str(soFar,a[start]));
    
function styleNumber(s) = 
    style(s, "Bold", BOLD) + 
    style(s, "Italic", ITALIC) + 
    style(s, "Oblique", ITALIC) +
    style(s, "Condensed", CONDENSED);

function familyAndStyle(s) =
    let(n=findsubstring(s,":style="))
    n < 0 ? [s, 0] :
    [substring(s,0,n), styleNumber(s, substring(s,n+7))];
    
function findEntry(data, index, offset=0) =
    offset >= len(data) ? undef :
    data[offset] == index ? data[offset][0] :
    findEntry(data, index, offset=offset+1);
    
function findFont(fonts, s) = findEntry(fonts, familyAndStyle(s));

function measureAt(string,font,offset) =
    let(g=findEntry(font[4],string[offset]))
    g == undef ? 0 :
    offset + 1 < len(string) ? g[1] : // at end of string
    let(kern=findEntry(g[2], string[offset+1]))
    kern == undef ? g[1] :
    g[1] + kern;
    
function measure(string, font, offset=0, soFar=0) =
    offset >= len(string) ? soFar :
    measure(string,font,offset=offset+1,soFar=soFar+measureAt(string,font,offset));
