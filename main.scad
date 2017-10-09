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
    ring_of_magnets(d=d_ring-magnet_h_clr,n=n_magnets,rot=90,dm=d_magnet+magnet_d_clr,hm=h_magnet+magnet_h_clr*2);

  }
}

module inner_plastic_ring(d_out=60, d_in=30,h=20,in_half_clr=0.5,bulk=3,prongs=4,prong_d=10,d_trench=60,h_trench=12,d_bearing=22,h_bearing=7,d_screw_reinforce=8,fn=32)
{
  difference()
  {
  union()
  {
    // outer ring to hold magnets
    difference()
    {
      cylinder(d=d_out,h=h,$fn=fn,center=true);
      cylinder(d=d_trench-2*bulk,h=h+0.01,$fn=fn,center=true);        
    }
    
    // prongs
    l_prong=(d_out-bulk - (d_in+bulk))/2;
    for(i=[0:prongs-1])
      rotate([0,0,i*360/prongs])
      {
        // the prong
        translate([0.5*(d_in+bulk)+l_prong/2,0,0])
          cube([l_prong,bulk,h],center=true);
        // inner screw reinforcement
        translate([(d_in+2*bulk)/2,0,0])
          rotate([0,0,90])
            cylinder(d=d_screw_reinforce,h=h,$fn=6,center=true);

        // outer screw reinforcement
        translate([(d_trench-2*bulk)/2,0,0])
          rotate([0,0,90])
            cylinder(d=d_screw_reinforce,h=h,$fn=6,center=true);

      }

    // inner ring to hold the baring
    difference()
    {
      cylinder(d=d_in+2*bulk,h=h,$fn=fn,center=true);
      cylinder(d=d_in-2*thick,h=h+0.01,$fn=fn,center=true);        
    }


  }
  
    // drill screw holes
    for(i=[0:prongs-1])
      rotate([0,0,i*360/prongs])
      {
        // inner circle, small hole
        translate([(d_in+2*bulk)/2,0,0])
        {
          // thread
          cylinder(d=1.8,h=h+0.01,$fn=6,center=true);
          // bigger hole, no contact
          translate([0,0,h/2])
            cylinder(d=2.5,h=h+0.01,$fn=6,center=true);
          // head
          translate([0,0,h/2+l_screw/2+h_screw_transition])
            cylinder(d=d_screw_head,h=h,$fn=16,center=true);
          translate([0,0,h_screw_transition/2+l_screw/2])
            cylinder(d2=d_screw_head,d1=1.8,h=h_screw_transition+0.01,$fn=16,center=true);
        }
        // outer circle, small hole
        translate([(d_trench-2*bulk)/2,0,0])
        {
          // thread
          cylinder(d=1.8,h=h+0.01,$fn=6,center=true);
          // bigger hole, no contact
          translate([0,0,h/2])
          cylinder(d=2.5,h=h+0.01,$fn=6,center=true);
          // head
          translate([0,0,h/2+l_screw/2+h_screw_transition])
            cylinder(d=d_screw_head,h=h,$fn=16,center=true);
          // transition
          translate([0,0,h_screw_transition/2+l_screw/2])
            cylinder(d2=d_screw_head,d1=1.8,h=h_screw_transition+0.01,$fn=16,center=true);


        }

      }
      
    // cut trench for outer ring
    difference()
    {
        cylinder(d=2*d_out+0.01,h=h_trench,$fn=fn,center=true);
        cylinder(d=d_trench,h=h_trench+0.01,$fn=fn,center=true);
    }
  
    // cut half-side clearing
    cylinder(d=d_out+0.01,h=in_half_clr,$fn=fn,center=true);
  
    // cut bearing slit
    cylinder(d=d_bearing+in_bearing_d_clr,h=h_bearing+in_bearing_h_clr,$fn=64,center=true);
  }
}

module threaded_rod()
{
  rotate([0,90,0])
    cylinder(d=3,h=ring_distance+3*out_d_h,$fn=6,center=true);
}


module assembly(rotor_magnets=1,bearing=1,disc_out=1,disc_in=1,stator_magnets=1,bearing_grip=1)
{

  // rotors: sign for left/right
  for(sign=[-1:2:1])
  {
    translate([sign*ring_distance/2,0,0])
    rotate([0,90+sign*tilt,0])
      rotate([0,0,-polarity*$t*360/n_magnets])
        union()
        {
          // rotor magnets
          if(rotor_magnets > 0.5)
          %ring_of_magnets(d=d_ring,n=n_magnets,rot=sign*90,dm=d_magnet,hm=h_magnet);
          // holds magnets from outside
          // magnets are in repulsion,
          // trying to increase ring diameter

          if(disc_out > 0.5)
            %outer_plastic_ring(d_out=out_d_out,d_in=out_d_in,h=out_d_h);

          if(bearing > 0.5)
            %bearing();
          
          if(bearing_grip > 0.5)
          {
            //translate([0,0,-bearing_h/2])
              if(0)
              rotate([0,90-90*sign,90+90*sign])
              rod_bearing_grip(angle_rod=tilt);
            //translate([0,0,bearing_h/2])
              if(1)
              rotate([0,90+90*sign,90+90*sign])
              rod_bearing_grip(angle_rod=tilt,upper=1,lower=1);
          }
          
          if(disc_in > 0.5)
            inner_plastic_ring(d_out=in_d_out,d_in=in_d_in,h=in_h,d_trench=out_d_in-in_out_d_clr,h_trench=out_d_h);
        }
    }

    // the rod
    if(threaded_rod > 0.5)
        %threaded_rod();

    // stator magnets
    if(stator_magnets > 0.5)
      for(sign=[-1:2:1])
        translate([0,sign*(d_ring/2+magnet_distance),0])
          rotate([0,sign*polarity*90,0])
            %magnet(d=d_magnet,h=ring_distance+magnet_over);
}

if(1)
assembly(disc_out=1,disc_in=1,bearing=1,bearing_grip=1,threaded_rod=1);

// outer ring
if(0)
  difference()
  {
    outer_plastic_ring(d_out=out_d_out,d_in=out_d_in,h=out_d_h);
  }

// inner ring
if(0)
            difference()
          {
            inner_plastic_ring(d_out=in_d_out,d_in=in_d_in,h=in_h,d_trench=out_d_in-in_out_d_clr,h_trench=out_d_h);
              if(1)
              translate([0,0,-50])
              cube([100,100,100],center=true);
          }

// bearing grips
if(0)
  for(i=[-1:2:1])
  {
   grid=10;
   translate([grid*i,grid,0])
      rotate([0,-tilt,0])
      rod_bearing_grip(angle_rod=tilt,upper=0);
   translate([grid*i,-grid,0])
      rotate([0,180-tilt,0])
      rod_bearing_grip(angle_rod=tilt,lower=0);

  }