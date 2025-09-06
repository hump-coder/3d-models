$fn = 64;

// Thickness of the plate
thickness = 1.5;

// Optional thicker back support
back_support_thickness   = 4;  // set to 0 to disable the extra support layer
back_support_offset      = -2;  // border offset applied around the main plate
back_support_wide_offset = 2;  // additional offset for the wider bottom section

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

module wide_section2d() {
    translate([0, -plate_height/2 + wide_height/2])
        square([wide_width, wide_height], center=true);
}

module backplate2d() {
    union() {
        // main rectangle
        square([plate_width, plate_height], center=true);
        // wider bottom section
        wide_section2d();
    }
}

module tabs2d() {
    for (i = [0:len(tab_positions)-1])
        translate([0, tab_positions[i]])
            square([tab_width, tab_heights[i]], center=true);
}

// Apply rounding to the outer corners of the main plate
// except for the top-left and bottom-right corners which remain square
module rounded_backplate2d() {
    union() {
        offset(r = corner_radius)
            offset(delta = -corner_radius)
                backplate2d();

        // Restore square corner at inside corner of the wide section
        translate([wide_width/2 - corner_radius, (-plate_height/2) + (wide_height-corner_radius)])
            square([corner_radius, corner_radius]);
        translate([-wide_width/2, (-plate_height/2) + (wide_height-corner_radius)])
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
    cylinder(h = (thickness+back_support_thickness), csk_d, center=false);
    cylinder(h = (thickness), d1 = csk_d, d2 = hole_d, center=false);
}

// Optional thicker back support with configurable offsets
module back_support2d() {
    union() {
        offset(delta = back_support_offset) rounded_backplate2d();

        difference() {
            translate([0, -plate_height/2 + wide_height/2])
                offset(r = corner_radius)
                    offset(delta = -corner_radius)
                        offset(delta = back_support_offset + back_support_wide_offset)
                            square([wide_width, wide_height], center=true);

            translate([0, -plate_height/2 + wide_height/2])
                offset(r = corner_radius)
                    offset(delta = -corner_radius)
                        offset(delta = back_support_offset)
                            square([wide_width, wide_height], center=true);

            // Remove the top portion so edge 3 matches the main plate
            translate([-(wide_width/2 + back_support_offset + back_support_wide_offset), -plate_height/2 + wide_height + back_support_offset])
                square([wide_width + 2*(back_support_offset + back_support_wide_offset), back_support_wide_offset], center=false);
        }
    }
}

// Create the 3D plate and remove the countersunk screw holes
module backplate() {
    difference() {
        union() {
            linear_extrude(thickness) rounded_backplate2d();
            linear_extrude(thickness/2) rounded_tabs2d();
            if (back_support_thickness > 0)
                linear_extrude(back_support_thickness) back_support2d();
        }
        for (i = [0:1]) {
            translate([0, plate_height/2 - top_to_first_hole - i*hole_spacing, 0])
                tapered_hole();
        }
    }
}

// Render the backplate
backplate();
