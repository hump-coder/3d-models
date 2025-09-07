use <tuya-tall-sensor-backplate.scad>;
use <base_model.scad>


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
  translate([90, 80, 41.5+height]) {
    if(show_sensor){       
        translate([0, 0, 0])
            rotate([90,90,45]) 
                import("1x2_basic_base_v4.stl");    
    }
    translate([10, -10, -2])
        rotate([90,0,45])
            backplate(35);
    }
}


module tuya_base() {
    import_model_base();  
    sensor(20, false);
}


tuya_base();

