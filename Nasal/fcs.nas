## FCS
## By Algernon

print("Initialising Flight Control System...");

var powersource = "/systems/electrical/outputs/FCS" ; 
var fcs_branch = "/systems/FCS" ;

var pout = 0;
var rout = 0;
var wow = 0;
var brake = 0;
var velo = 0;
var eng = 0;

var FCS = props.globals.getNode(fcs_branch);
var att = FCS.getNode("internal/attitude");

# Functions
var init = func {
     settimer(loop, 3);
     settimer(loop2, 0.5);
	}
		
var loop = func {
    # Zero variables
	 wow = 0;
	 
	 pout = 1.3;
	 rout = 0;
	 
	 var rollrate = 2;

     var pof = props.globals.getNode("computers/phase-of-flight-num").getValue();
     var gear = props.globals.getNode("gear");
     var gearl = gear.getNode("gear[1]/wow").getValue();
     var gearr = gear.getNode("gear[2]/wow").getValue();
   
    # Weight on Wheels
   
     if ( gearl and gearr ) {
         wow = 1;
	    } 
   
   # Pitch & Roll
   
     var p = att.getNode("pitch-deg").getValue();
     var pa = att.getNode("pitch-adjust").getValue();
     var r = att.getNode("roll-deg").getValue();
     var ra = att.getNode("roll-adjust").getValue();
     var inverted = att.getNode("inverted").getBoolValue();
   
   # Check Phase of Flight and Weight on Wheels
   
     if ( pof > 1 ) { 
	     pout = ( p +  pa ); 	 
	    }
		
     if (!wow) {
	     rout = ( r + ( ra * rollrate ));
        }
       
     setprop("/systems/FCS/internal/attitude/pitch-deg", pout);
     setprop("/systems/FCS/internal/attitude/roll-deg", rout);
   
    # ...and repeat!
   
   settimer(loop,0.033);
   }

var loop2 = func {
    # Zero variables
	 wow = 0;
	 brake = 0;
	 velo = 0;
	 eng = 0;

     var gear = props.globals.getNode("gear");
     var gearl = gear.getNode("gear[1]/wow").getValue();
     var gearr = gear.getNode("gear[2]/wow").getValue();
     var bl = props.globals.getNode("/controls/gear/brake-left").getValue();
     var br = props.globals.getNode("/controls/gear/brake-right").getValue();
     var velocity = props.globals.getNode("/velocities/groundspeed-kt").getValue();
     var rpm0 = props.globals.getNode("engines/engine[0]/rpm").getValue();
     var rpm1 = props.globals.getNode("engines/engine[1]/rpm").getValue();
   
    # Weight on Wheels
   
     if (gearl and gearr) {
         wow = 1;
	    } 
   
     if ( (bl > 0.7) and (br > 0.7) ) {
         brake = 1;
	    } 
          
     if ( (rpm0 < 15) or (rpm1 < 15) ) {
         eng = 1;
	    } 
     if (velocity > 50) {
         velo = 1;
	    } 

     if ( (brake) and (velo) and (wow) ) {
		interpolate("/controls/flight/elevator-trim", -1.0, 0.2);
	    } 
     if ( (wow) and ( (!brake) or (!velo) ) ) {
		interpolate("/controls/flight/elevator-trim", 0, 1);
	    } 
     if ( (wow) and (eng) ) {
		interpolate("/controls/flight/elevator-trim", -1.0, 1);
	    } 

   settimer(loop2, 0.3);
   }
   
settimer(init, 10);
