includeGrip = false;
tolerance = 0.18;
thickness = 2.5;
tabSize = 3.5;
gripLength = 39;
gripWidth = 17.53;
gripHeight = 0;
lip = 3;
// the following only apply if you don't include the grip
extraThickness = 3;
screwHoleDiameter = 4;
screwHoleInsetDepth = 3;
screwHoleInsetDiameter = 9;

module dummy() {}

$fn = 36;

nudge = 0.01;

wiiY = 30.;
size_xsect_0 = [36.240508333,29.876988125];
size_xsect_1 = [size_xsect_0[0],wiiY];
// paths for xsect_1

points_xsect_1_1 = [ [-6.340977708,14.938494063],[-10.041222909,13.991003059],[-11.542611892,13.335288548],[-12.832843571,12.588143262],[-14.843830332,10.909206052],[-16.202173828,9.133482813],[-17.035864698,7.440264924],[-17.472893577,6.008843770],[-17.668927917,4.648557188],[-18.120254167,-5.506045312],[-18.120254167,-13.404016562],[-17.859895898,-14.081701709],[-17.287107708,-14.560520234],[-16.453961250,-14.938494063],[-0.157929792,-14.938494063],[16.454040625,-14.938494063],[17.287147396,-14.560520234],[17.859908301,-14.081701709],[18.120254167,-13.404016562],[18.120254167,-5.506045312],[17.668954375,4.648557188],[17.472919622,6.008843770],[17.035889761,7.440264924],[16.202196979,9.133482813],[14.843850330,10.909206052],[12.832858867,12.588143262],[11.542624159,13.335288548],[8.312682448,14.532875371],[6.340977708,14.938494063],[-6.340977708,14.938494063] ];

module xsect(delta=0) {
 render(convexity=4) {
    rotate(180)
    offset(r=delta)
    scale([1,wiiY/size_xsect_0[1]])
    polygon(points=points_xsect_1_1);
 }
}

module outline() {
    w  = size_xsect_1[0]+2*tolerance-2*tabSize;
    difference() {
        union() {
            xsect(delta=tolerance+thickness);
            w1 = gripWidth;
            translate([-w1/2,-size_xsect_1[1]/2-extraThickness-tolerance-thickness]) square([w1,extraThickness+thickness+nudge]);
        }
        xsect(delta=tolerance);
        translate([-w/2,0]) square([w,size_xsect_1[1]+tolerance+thickness]);
    }
}

module screwHoles() {
    for (i=[0.25,0.75]) 
    translate([0,-size_xsect_1[1]/2-tolerance,i*gripLength])
    rotate([-90,0,0]) {
        translate([0,0,-100+nudge]) cylinder(d=screwHoleDiameter,h=100);
        translate([0,0,-screwHoleInsetDepth+2*nudge]) cylinder(d1=screwHoleDiameter,d2=screwHoleInsetDiameter,h=screwHoleInsetDepth);
    }
}

difference() {
    linear_extrude(height=gripLength)
    outline();

    screwHoles();
}