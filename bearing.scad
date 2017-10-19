module bearing(d_out=22,d_in=8,h=7)
{
    difference()
    {
      cylinder(d=d_out,h=h,$fn=32,center=true);
      cylinder(d=d_in,h=h+0.001,$fn=32,center=true);
    }
}

// one half of a grip
module
rod_half_bearing_grip(d_rod=3,angle_rod=0,d_bearing=8,h_bearing=7,clr_d_bearing=0.4,clr_h_bearing=0.4,clr_d_rod=0.4,over=1.5,fn=32)
{
  d1_kuglager=d_bearing;
  h_kuglager=h_bearing;
  spacer_outer_clearance=clr_d_bearing;
  spacer_inner_clearance=clr_d_rod;
  spacer_rim_h=over;
  clearance=clr_h_bearing;

  difference()
  {
    translate([0,0,-h_bearing/2])
    union()
    {
      // fits inside of kuglager
      if(d1_kuglager-spacer_outer_clearance-d_rod-spacer_inner_clearance >
0.1)
        cylinder(d=d1_kuglager-spacer_outer_clearance,h=h_kuglager/3+spacer_rim_h,$fn=32,center=true);
      // spacer rim outside of kuglager
      if(spacer_rim_h > 0.01)
      translate([0,0,(spacer_rim_h)/2-(h_kuglager/3+(spacer_rim_h))/2])
        cylinder(d=d1_kuglager+2*clearance,h=(spacer_rim_h),$fn=32,center=true);
    }
    // hole for the rod
    rotate([0,angle_rod,0])
      cylinder(d=d_rod+spacer_inner_clearance,h=h_kuglager*3,$fn=32,center=true);
    // half-cut of clearance
    // cylinder(d=d1_kuglager,h=clearance,$fn=32,center=true); 
  }
}

// full grip
module
rod_bearing_grip(d_rod=3,angle_rod=0,d_bearing=8,h_bearing=7,clr_d_bearing=0.4,clr_h_bearing=0.6,clr_d_rod=0.4,over=1.5,upper=1,lower=1,fn=32)
{
  d1_kuglager=d_bearing;
  h_kuglager=h_bearing;
  spacer_outer_clearance=clr_d_bearing;
  spacer_inner_clearance=clr_d_rod;
  spacer_rim_h=over;
  clearance=clr_h_bearing;

  difference()
  {
    // intersection is for limting box perpendicular to the rod
    intersection()
    {
      // make large outside part first, cut out the bearing space
      difference()
      {
        cylinder(d=d1_kuglager+2*over,h=h_bearing*3,$fn=32,center=true); 
        // cutting out bearing space
        difference()
        {
          // large enough in diameter, smaller h for clean cut
          cylinder(d=d1_kuglager*2,h=h_bearing-0.01,$fn=32,center=true);
          // fits inside of kuglager
          cylinder(d=d1_kuglager-spacer_outer_clearance,h=h_bearing,$fn=32,center=true);
        }
      }
      // here's limiting cylinder perpendicular to the rod, large enough
      rotate([0,angle_rod,0])
        cylinder(d=d1_kuglager+2*over,h=(h_bearing+2*over)*(1+sin(angle_rod)),$fn=32,center=true);
    }

    // v-shaped cut in half, prevents rotation
    // and makes clearance to tight-grip the bearing
    // vcut_h=clr_h_bearing;
    vcut_h=clr_h_bearing;
    translate([0,0,-h_bearing/4+vcut_h*0])
    union()
    {
      for(i=[-1:2:1])
      rotate([45*i,0,0])
      translate([0,i*(d1_kuglager-vcut_h/sin(45)/2),0])
        cube([2*d1_kuglager,2*d1_kuglager,vcut_h/sin(45)],center=true);
    }

    vcut_h_above=100;
    if(upper < 0.5) // remove v-inside part
    translate([0,0,-h_bearing/4+vcut_h_above])
    union()
    {
      for(i=[-1:2:1])
      rotate([45*i,0,0])
      translate([0,i*(d1_kuglager-vcut_h_above/sin(45)/2),0])
        cube([2*d1_kuglager,2*d1_kuglager,vcut_h_above/sin(45)],center=true);
    }

    if(lower < 0.5) // remove v-outside part (experimental factors, need rework)
    translate([0,0,-h_bearing/4+vcut_h_above*0.768])
    union()
    {
      for(i=[-1:2:1])
      rotate([45*i,0,0])
      translate([0,i*(d1_kuglager-vcut_h_above/sin(45)/2),0])
        cube([2*d1_kuglager,2*d1_kuglager,vcut_h_above/sin(45)],center=true);
    }



    // hole for the rod
    rotate([0,angle_rod,0])
      cylinder(d=d_rod+spacer_inner_clearance,h=h_kuglager*10,$fn=32,center=true);
  }
}
