# Warnings
# By Algernon

monitor_loop_interval = 0.5;

# Attention Getters
   
var attn_get_switch = props.globals.getNode("instrumentation/warnings/attn-get", 2);
var strobe = aircraft.light.new( "/sim/model/lights/attn-get", [0.15, 0.15], "/instrumentation/warnings/attn-get" );

var flash = func {
     var atnget = props.globals.getNode("/instrumentation/warnings/attn-get");
	 var alerts = props.globals.getNode("/systems/warnings/alerts").getChildren();
	 var f = 0;
	 foreach (var g; alerts) {
	     var alerted = g.getNode("alert").getBoolValue();
		 var ackd = g.getNode("acknowledged").getBoolValue();
		 if ((alerted) and (!ackd)) { var f = ( f + 1 ); }
		 }
	 if ( f > 0 ) { atnget.setBoolValue(1); } else { atnget.setBoolValue(0); }
	}

var voice = func(v) {
     setprop("/systems/warnings/alerts/"~v~"/voice-trigger", 1);
	 settimer( func { setprop("/systems/warnings/alerts/"~v~"/voice-trigger", 0); } , 1.5);
	 settimer( func { setprop("/systems/warnings/alerts/"~v~"/voice-trigger", 1); } , 2.5);
	 settimer( func { setprop("/systems/warnings/alerts/"~v~"/voice-trigger", 0); } , 4);
	 }

var acknowledge = func {
     var alerts = props.globals.getNode("/systems/warnings/alerts").getChildren();
	 foreach ( var h; alerts) {
	     var ack = h.getNode("acknowledged", 1);
		 var al = h.getNode("alert", 1);
		 var ald = al.getBoolValue();
		 if (ald) {
	         ack.setBoolValue(1);
		     }
	    }
}   
	 
var alert = {
    
	trigger: func(x) {
	var cat = getprop("/systems/warnings/alerts/"~x~"/category");
	if ( cat == 1 ) {
       setprop("/systems/warnings/alerts/"~x~"/alert", 1);
	   setprop("/instrumentation/warnings/attn-get", 1);
	   voice(x);
	   } 
	},
	
    cancel: func(y) {
    setprop("/systems/warnings/alerts/"~y~"/alert", 0);
	setprop("/systems/warnings/alerts/"~y~"/acknowledged", 0);
	setprop("/instrumentation/warnings/attn-get", 0);
	},
	
	ack: func(z) {
	setprop("/systems/warnings/alerts/"~z~"/acknowledged", 1);
	}
};

var monitor = {

   loop: func {
      monitor.cat1();
	  flash();
	  settimer( monitor.loop, monitor_loop_interval );
   },
   
   cat1: func {
      var airspd = getprop("/velocities/airspeed-kt");
	  var alt = getprop("/position/altitude-ft");
	  var altagl = getprop("/position/altitude-agl-ft");
	  var throt = getprop("/controls/engines/engine/throttle");
	  var vspeed = getprop("/velocities/vertical-speed-fps");
	  var gearpos = getprop("/gear/gear[0]/position-norm");
	  var masspos = getprop("/controls/armament/master-arm");
      var fuelremain = getprop("consumables/fuel/total-fuel-lbs");
      var bingofuel = getprop("/controls/fuel/bingo-set");
	  var pof = getprop("/computers/phase-of-flight-num");
	  
	  #Low Height
	  var setagl = getprop("/instrumentation/radar-altimeter/agl-setting");
	  var agl_al = getprop("/systems/warnings/alerts/low-height/alert");
	  var agl_ack = getprop("/systems/warnings/alerts/low-height/acknowledged");
	  if (( pof == 3 ) or ( pof == 4)) {
	     if ( altagl < setagl ) {
	         if ((!agl_al) and (!agl_ack)) {
	         alert.trigger("low-height");
		     }
		 }
		 else {
		     alert.cancel("low-height");
			 }
		}
	  
	  #Low Speed
	  
	  if (( pof == 3 ) or ( pof == 4 )) {
	     
		 var aspd_al = getprop("/systems/warnings/alerts/speed-low/alert");
	     var aspd_ack = getprop("/systems/warnings/alerts/speed-low/acknowledged");
		     if ( airspd < 110 ) {
			     if ((!aspd_al) and (!aspd_ack)) {
			         alert.trigger("speed-low");
				    }
		    }
		    else { 
			     if (aspd_al) {
			         alert.cancel("speed-low");
				}
		    }
		}     
		
	  #Fuel low
	  
	  if ( pof > 2 ) {
	     
		 var afuel_al = getprop("/systems/warnings/alerts/fuel-low/alert");
	     var afuel_ack = getprop("/systems/warnings/alerts/fuel-low/acknowledged");
		     if ( fuelremain < 700 ) {
			     if ((!afuel_al) and (!afuel_ack)) {
			         alert.trigger("fuel-low");
				    }
		    }
		    else { 
			     if (afuel_al) {
			         alert.cancel("fuel-low");
				}
		    }
		}     
		
	  #Bingo Fuel
	  
	  if ( pof > 1 ) {
	     
		 var bingofuel_al = getprop("/systems/warnings/alerts/bingo-fuel/alert");
	     var bingofuel_ack = getprop("/systems/warnings/alerts/bingo-fuel/acknowledged");
		     if ( fuelremain < bingofuel ) {
				 setprop("/controls/fuel/bingo-fuel", 1);
			     if ((!bingofuel_al) and (!bingofuel_ack)) {
			         alert.trigger("bingo-fuel");
				    }
		    }
		    else { 
				 setprop("/controls/fuel/bingo-fuel", 0);
			     if (bingofuel_al) {
			         alert.cancel("bingo-fuel");
				}
		    }
		}     

	  # Pullup
#	  var impact_sec = ( altagl / vspeed );
#	  if ( pof != "land" ) {
#	     if ( impact_sec < -400 ) { alert.trigger("pull-up"); }
#		 else { alert.cancel("pull-up"); }
#	  }
#
	  # Landing Gear
	  if ( gearpos < 0.1 ) {
	     if (( airspd < 180 ) and ( altagl < 300 ) and ( throt < 0.75 )) {
		     var lgear_al = getprop("/systems/warnings/alerts/landing-gear/alert");
	         var lgear_ack = getprop("/systems/warnings/alerts/landing-gear/acknowledged");
			 if ((!lgear_al) and (!lgear_ack)) {			 
			     alert.trigger("landing-gear"); 
				}
		     else { alert.cancel("landing-gear"); 
			    }
	        }
	    }
	  
	  # Gear Limit
	  
	     var gearlim_al = getprop("/systems/warnings/alerts/gear-limit/alert");
	     var gearlim_ack = getprop("/systems/warnings/alerts/gear-limit/acknowledged");
		 
		 if (( gearpos > 0.9 ) and ( airspd > 280 )) {
		     if ((!gearlim_al) and (!gearlim_ack)) {
			     alert.trigger("gear-limit"); 
			    }
			}
	     else {
		     if (gearlim_al) {
			     alert.cancel("gear-limit");
			    }
		    }
	}
};

var init = func {
    settimer(monitor.loop, 4);
	}

setlistener("/sim/signals/fdm-initialized", init);
	