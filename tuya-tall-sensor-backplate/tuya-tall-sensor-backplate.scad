$fn = 64;

// Thickness of the plate
thickness = 1.5;

// Overall plate dimensions
plate_height = 69.5;
plate_width  = 21.8;

// Dimensions of the wider bottom section
wide_width  = 25;
wide_height = 12;

// Small side tabs used as guides
// These expand the width by 0.5 mm on each side (22.8 mm total)
// at three locations along the height of the plate
tab_extension = 0.5;                    // how far each tab extends beyond the plate
tab_width  = plate_width + tab_extension * 2;
tab_heights = [9, 9, 16];                // heights for tabs corresponding to tab_positions
// y positions for the centre of each tab relative to the
// centre of the plate (positive is up)
tab_positions = [23, 0, -19];

// Radius for rounding outer corners
corner_radius = 3;

// Screw hole measurements
hole_spacing = 40;        // distance between hole centres
hole_d      = 3;          // diameter of screw shaft
csk_d       = 5.5;        // diameter of countersunk head
csk_depth   = 1;          // depth of countersink

// Distance from top edge to centre of first screw hole
// (used to place both holes)
top_to_first_hole = 13;

module backplate2d() {
    union() {
        // main rectangle
        square([plate_width, plate_height], center=true);
        // wider bottom section
        translate([0, -plate_height/2 + wide_height/2])
            square([wide_width, wide_height], center=true);
    }
}

module tabs2d() {
    for (i = [0:len(tab_positions)-1])
        translate([0, tab_positions[i]])
            square([tab_width, tab_heights[i]], center=true);
}

// Apply rounding to the outer corners of the main plate
// except for the top-right and bottom-left corners which remain square
module rounded_backplate2d() {
    union() {
        offset(r = corner_radius)
            offset(delta = -corner_radius)
                backplate2d();

        // Restore square corner at top-right of the narrow section
        translate([plate_width/2 - corner_radius, plate_height/2 - corner_radius])
            square([corner_radius, corner_radius]);

        // Restore square corner at bottom-left of the wide section
        translate([-wide_width/2, -plate_height/2])
            square([corner_radius, corner_radius]);
    }
}

// Rounded profiles for tabs
module rounded_tabs2d() {
    offset(r = corner_radius)
        offset(delta = -corner_radius)
            tabs2d();
}

module tapered_hole() {
    // Tapered opening for countersunk screw heads
    cylinder(h = thickness, d1 = csk_d, d2 = hole_d, center=false);
}

// Create the 3D plate and remove the countersunk screw holes
module backplate() {
    difference() {
        union() {
            linear_extrude(thickness) rounded_backplate2d();
            linear_extrude(thickness/2) rounded_tabs2d();
        }
        for (i = [0:1]) {
            translate([0, plate_height/2 - top_to_first_hole - i*hole_spacing, 0])
                tapered_hole();
        }
    }
}

// Render the backplate
backplate();
