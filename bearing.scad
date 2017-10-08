module bearing(d_out=22,d_in=8,h=7)
{
    difference()
    {
      cylinder(d=d_out,h=h,$fn=32,center=true);
      cylinder(d=d_in,h=h+0.001,$fn=32,center=true);
    }
}


module
rod_bearing_grip(d_rod=3,d_bearing=8,h_bearing=7,clr_d_bearing=0.4,clr_h_bearing=0.4,clr_d_rod=0.4,over=1.5,fn=32)
{
  d1_kuglager=d_bearing;
  h_kuglager=h_bearing;
  spacer_outer_clearance=clr_d_bearing;
  spacer_inner_clearance=clr_d_rod;
  spacer_rim_h=over;
  clearance=clr_h_bearing;

  difference()
  {
    union()
    {
      // fits inside of kuglager
      if(d1_kuglager-spacer_outer_clearance-d_rod-spacer_inner_clearance >
0.1)

cylinder(d=d1_kuglager-spacer_outer_clearance,h=h_kuglager/3+spacer_rim_h,$fn=32,center=true);
      // spacer rim outside of kuglager
      if(spacer_rim_h > 0.01)
      translate([0,0,spacer_rim_h/2-(h_kuglager/3+spacer_rim_h)/2])
        cylinder(d=d1_kuglager+2*clearance,h=spacer_rim_h,$fn=32,center=true);
    }
    // hole for the rod
    cylinder(d=d_rod+spacer_inner_clearance,h=h_kuglager/3+spacer_rim_h+0.01,$fn=32,center=true);
    // half-cut of clearance
    // cylinder(d=d1_kuglager,h=clearance,$fn=32,center=true); 
  }
}