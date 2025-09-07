use <tuya-tall-sensor-backplate.scad>;
use <base_model.scad>

$fn=50;

module import_model_base(height=0)
{  
    difference() {
        objNE();        
            translate([100,80,43.26])
                rotate([0,0,45])
                    cube([20, 40, 76.5], center=true);
    }
}

//
// height is how high the sensor mount should sit above the top face of the base plate.
//
module sensor(height = 0, show_sensor=false)
{
  translate([90, 90, 41.5+height]) {      
      
    if(show_sensor){       
        translate([-5, -5, 0])
            rotate([90,90,45]) 
              rotate([-90,0,0]) 
                cube([71.5, 25,20], center=true);       
                //import("1x2_basic_base_v4.stl");    
    }
    translate([0, 0, -2])
        rotate([90,0,45])
           rotate([0,90,0])
            backplate(30, solid_base_width = 17);
    }
}

module screw_hole()
{
    forward = 55;
     translate([35+forward, 35+forward, 32])
        rotate([0,90,45])
        cylinder(h=20, r=2.5, center=true);
}

module tuya_base() {
    import_model_base();      
    sensor(16, false);
}




module build_base() {    
    difference() 
    {
        tuya_base();
        translate([90, 90, 41.5+height])        
        screw_hole();
    }
}


build_base();


