include <magnet.scad>

module ring_of_magnets(d=70,n=12,dm=6,hm=10,rot=90)
{
  angle=360/n;
  union()
  {
    for(i=[0:n-1])
    {
      rotate([0,0,angle*i])
        translate([d/2,0,0])
           rotate([0,rot,0])
             magnet(d=dm, h=hm+0);
    }
  }
}

module outer_plastic_ring(d_out=80,d_in=60,h=20,fn=32)
{
  difference()
  {
    cylinder(d=d_out,h=h,$fn=fn,center=true);
    cylinder(d=d_in,h=h+0.01,$fn=fn,center=true);
    ring_of_magnets(d=d_ring,n=n_magnets,rot=90,dm=d_magnet+magnet_d_clr,hm=h_magnet+magnet_h_clr);

  }
}


thick=1.5; // mm general thickness

tilt=15; // ring tilt
ring_distance=50; // mm from center
d_magnet=6;
h_magnet=15;
n_magnets=16;
magnet_d_clr=0.4; // clearance in d
magnet_h_clr=1.0; // clearance in h
d_ring=71;
magnet_distance=16;
magnet_over=ring_distance*0.3;
polarity=-1;
// plastic main ring dimension
d_out=d_ring+h_magnet+2*thick;
d_in=d_ring-h_magnet;
d_h=d_magnet+2*thick;

for(sign=[-1:2:1])
{
  translate([sign*ring_distance/2,0,0])
    rotate([0,90+sign*tilt,0])
      rotate([0,0,-polarity*$t*360/n_magnets])
        union()
        {
          if(1)
          %ring_of_magnets(d=d_ring,n=n_magnets,rot=sign*90,dm=d_magnet,hm=h_magnet);
          // holds magnets from outside
          // magnets are in repulsion,
          // trying to increase ring diameter
          if(0)
          outer_plastic_ring(d_out=d_out,d_in=d_in,h=d_h);
        }
}

for(sign=[-1:2:1])
translate([0,sign*(d_ring/2+magnet_distance),0])
  rotate([0,sign*polarity*90,0])
    %magnet(d=d_magnet,h=ring_distance+magnet_over);


