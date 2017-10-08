
module magnet(d=10,h=10,fn=32)
{
  magnet_d=d;
  magnet_h=h;
  cylinder_faces=fn;
  color([0.5,0.5,1]) // blue, north
  translate([0,0,magnet_h/4])
    cylinder(d=magnet_d,h=magnet_h/2,$fn=cylinder_faces,center=true);
  color([1,0.5,0.5]) // red, south
  translate([0,0,-magnet_h/4])
    cylinder(d=magnet_d,h=magnet_h/2,$fn=cylinder_faces,center=true);
}
