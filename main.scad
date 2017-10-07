include <magnet.scad>

module ring_of_magnets(d=70,n=12,rot=90)
{
  angle=360/n;
  union()
  {
    for(i=[0:n-1])
    {
      rotate([0,0,angle*i])
        translate([d/2,0,0])
           rotate([0,rot,0])
             magnet(r=6, h=10);
    }
  }
}



tilt=20;
ring_distance=50;
n_magnets=18;
d_ring=71;
magnet_distance=17;
polarity=-1;

for(sign=[-1:2:1])
  translate([sign*ring_distance/2,0,0])
    rotate([0,90+sign*tilt,0])
      rotate([0,0,-polarity*$t*360/n_magnets])
        ring_of_magnets(d=d_ring,n=n_magnets,rot=sign*90);

for(sign=[-1:2:1])
translate([0,sign*(d_ring/2+magnet_distance),0])
  rotate([0,sign*polarity*90,0])
    magnet(r=6,h=ring_distance);