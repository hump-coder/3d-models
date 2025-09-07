// File: Tuya - Base.stl
// X size: 114.0
// Y size: 114.0
// Z size: 80.0
// X position: -39.027
// Y position: -55.149
// Z position: -23.262
NE=1; NW=2; SW=3; SE=4; CTR=5;
module obj2origin (where) {
	if (where == NE) {
		objNE ();
	}

	if (where == NW) {
		translate([ -114.0 , 0 , 0 ])
		objNE ();
	}

	if (where == SW) {
		translate([ -114.0 , -114.0 , 0 ])
		objNE ();
	}

	if (where == SE) {
		translate([ 0 , -114.0 , 0 , ])
		objNE ();
	}

	if (where == CTR) {
	translate([ -57.0 , -57.0 , -40.0 ])
		objNE ();
	}
}

module objNE () {
	translate([ 39.027 , 55.149 , 23.262 ])
		import("Tuya - Base.stl");
}

