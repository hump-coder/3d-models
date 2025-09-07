$fn = 64;

// Overall plate dimensions
plate_width = 39.2;
plate_height = 63.5;
plate_thickness = 7;

// Recessed area on the back of the plate
inset_depth = 4;
ridge = 3;

// Circular reference used for additional ridges
circle_d = 34;
circle_center_y = 22;

// Ridge details
right_ridge_height = 5;      // length of ridge joining circle to right wall
bl_ridge_height = 5;       // [width, height] of bottom-left ridge

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
        translate([ridge, ridge, -1])
            cube([plate_width - 2*ridge, plate_height - 2*ridge, inset_depth+1], center=false);
    }
}

module screw_post() {
    difference() {
        translate([0,0,-post_height])
            cylinder(h = post_height+7, d = post_outer_d, center=false);
        translate([0,0,-post_height])
            cylinder(h = post_height, d = post_hole_d, center=false);
    }
}

module posts() {
    for (x = [-post_spacing/2, post_spacing/2])
        translate([plate_width/2 + x, post_center_height, 0])
            screw_post();
}

module right_ridge() {
    ridge_width = plate_width/2 - ridge - circle_d/2;
    translate([plate_width/2 - ridge/2, 0, 0])
        cube([ridge_width, right_ridge_height, plate_thickness], center=false);
}

module bottom_left_ridge() {
    ridge_width = plate_width/2 - ridge - circle_d/2;
    translate([plate_width/2 - ridge/2, plate_height-bottom, 0])
        cube([ridge_width, bl_ridge_height, plate_thickness], center=false);
}

// Circular ridge with recessed centre
module circle_ridge() {
    translate([plate_width/2, circle_center_y, 0])
        difference() {
            // outer ring at full height
            cylinder(h = plate_thickness, d = circle_d, center=false);
            // recessed centre leaving a ridge equal to "ridge"
            translate([0, 0, -1])
                cylinder(h = plate_thickness+1, d = circle_d-5, center=false);

                //cylinder(h = inset_depth, d = circle_d - 2*ridge, center=false);
        }
}

module cuts() {
    
}

union() {
    base_plate();
    right_ridge();
    bottom_left_ridge();
    circle_ridge();
    posts();
    cuts();
}
