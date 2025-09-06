$fn = 64;

// Overall plate dimensions
plate_width = 39.2;
plate_height = 63.5;
plate_thickness = 7;

// Recessed area on the back of the plate
inset_depth = 4;
ridge = 3;

// Circular reference used for additional ridges
circle_d = 30;
circle_center_y = 28;

// Ridge details
right_ridge_height = 10;      // length of ridge joining circle to right wall
bl_ridge_size = [6, 4];       // [width, height] of bottom-left ridge

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

        // recessed interior
        translate([ridge, ridge, 0])
            cube([plate_width - 2*ridge, plate_height - 2*ridge, inset_depth], center=false);
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

module right_ridge() {
    ridge_width = plate_width/2 - ridge - circle_d/2;
    translate([plate_width/2 + circle_d/2, circle_center_y - right_ridge_height/2, 0])
        cube([ridge_width, right_ridge_height, plate_thickness], center=false);
}

module bottom_left_ridge() {
    translate([plate_width/2 - circle_d/2 - bl_ridge_size[0], ridge, 0])
        cube([bl_ridge_size[0], bl_ridge_size[1], plate_thickness], center=false);
}

// Circular ridge with recessed centre
module circle_ridge() {
    translate([plate_width/2, circle_center_y, 0])
        difference() {
            // outer ring at full height
            cylinder(h = plate_thickness, d = circle_d, center=false);
            // recessed centre leaving a ridge equal to "ridge"
            translate([0, 0, plate_thickness - inset_depth])
                cylinder(h = inset_depth, d = circle_d - 2*ridge, center=false);
        }
}

union() {
    base_plate();
    right_ridge();
    bottom_left_ridge();
    circle_ridge();
    posts();
}
