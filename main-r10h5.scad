// to see animation:
// view->animate, FPS=11, Steps=22
// assembly(disc_out=0,disc_in=0,bearing=0);

thick=1.5; // mm general thickness

tilt=15; // ring tilt
ring_distance=50; // mm from center
d_magnet=10;
h_magnet=5;
n_magnets=16;
magnet_d_clr=1; // clearance in d
magnet_h_clr=0.5; // clearance in h
d_ring=70;
magnet_distance=16;
magnet_over=ring_distance*0.3;
polarity=-1;

// bearing
bearing_d_out=22;
bearing_d_in=8;
bearing_h=7;

// plastic outer ring dimension
out_d_out=d_ring+h_magnet+2*thick;
out_d_in=d_ring-h_magnet;
out_d_h=d_magnet+2*thick;

// pastic inner ring dimension (holds bearing to the outer ring)
in_out_d_clr=0.7; // inner-to-outer ring clearance
in_bearing_d_clr=0.3;
in_bearing_h_clr=0.0;
in_d_out=out_d_in+2*thick; // inner dia
in_d_in=bearing_d_out+in_bearing_d_clr;
in_h=out_d_h+2*thick;

// screw
l_screw=6; // thread length
d_screw=2.2; // thread dia
d_screw_head=5; // screw head dia
h_screw_transition=d_screw; // easy 3dprint

include <magnet.scad>
include <bearing.scad>
include <vgate.scad>


if(1)
  view_assembly(disc_out=1,disc_in=1,bearing=1,bearing_grip=1,threaded_rod=1);

if(0)
  print_outer_ring();

if(0)
  print_inner_ring();

if(0)
  print_bearing_grips();
