$fn = 64;

// Overall plate dimensions
plate_width = 39.2;
plate_height = 63.5;
plate_thickness = 7;

// Recessed area on the back of the plate
inset_depth = 4;
ridge = 3;

// Approximate circular area that remains solid
circle_d = 30;
circle_center_y = 28;

// Screw post parameters
post_spacing = 24.6;        // distance between hole centres
post_center_height = 23;    // distance from bottom of plate to hole centres
post_height = 5;            // how far the new posts extend
post_outer_d = 6;           // outer diameter of the post
post_hole_d = 3;            // diameter of screw hole

module base_plate() {
    difference() {
        // full plate
        cube([plate_width, plate_height, plate_thickness], center=false);

        // recessed interior leaving a circular plateau
        translate([ridge, ridge, 0])
            difference() {
                cube([plate_width - 2*ridge, plate_height - 2*ridge, inset_depth], center=false);
                translate([plate_width/2 - ridge, circle_center_y - ridge, -1])
                    cylinder(d = circle_d, h = inset_depth + 2, center=false);
            }
    }
}

module screw_post() {
    difference() {
        translate([0,0,-post_height])
            cylinder(h = post_height, d = post_outer_d, center=false);
        translate([0,0,-post_height-1])
            cylinder(h = post_height + 2, d = post_hole_d, center=false);
    }
}

module posts() {
    for (x = [-post_spacing/2, post_spacing/2])
        translate([plate_width/2 + x, post_center_height, 0])
            screw_post();
}

union() {
    base_plate();
    posts();
}
