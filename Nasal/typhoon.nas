#### Typhonn systems	
#### from many sources...
#### and also, almursi and algernon work

# need be read again every test
var WOW = getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
var ReverseStatus0 = 0;
var ReverseStatus1 = 0;
var ToggleAp = 0;

var setHook = func() {
  var NoDosVeces=getprop("/controls/tailhook/position-norm");
  var battery=getprop("/controls/electric/battery-switch");
  if (battery==1) {
  	if (NoDosVeces!=1) {
		setprop("/controls/tailhook/position-norm", 1);
	  	setprop("/controls/gear/tailhook", 1);
		# screen.log.write("HOOK extended"); 
		}
	    else { 
		setprop("/controls/tailhook/position-norm", 0);
	  	setprop("/controls/gear/tailhook", 0);
		# screen.log.write("Hook retracted"); 
		}
	}
};

# GearDown Control from f14b gear.nas 
# ----------------
# Hijacked Gear handling so we have a Weight on Wheel security to prevent
# undercarriage retraction when on ground.
# added toggle off launchbar and catapult commands,
#   and not retraction when tailwheel-lock enabled

controls.gearDown = func(v) {
    WOW =getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
    if (v < 0 and ! WOW) {
        # if tailwhell-lock do nothing
	WOW = getprop("/controls/gear/tailwheel-lock");
	if ( !WOW ) {
		setprop("/controls/gear/gear-down", 0); 
					avionics.controls.gearLights(2);
					setprop("sim/multiplay/generic/int[7]", 2);
	}
    } elsif (v > 0) {
      setprop("/controls/gear/gear-down", 1);
      setprop("/controls/gear/catapult-launch-cmd", 0);
      setprop("/controls/gear/launchbar", 0);
      # setprop("/controls/gear/tailwheel-lock", 0);
    }
}

# Cockpit switch
gearDownClick = func() {
    var OldValue = getprop ("/controls/gear/gear-down");
    # ChangeValue 1, cierto si está abajo y 0, falso si está arriba
    WOW = getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
    if (OldValue and ! WOW) {
        # if tailwhell-lock do nothing
		WOW = getprop("/controls/gear/tailwheel-lock");
		if ( !WOW ) {
			setprop("/controls/gear/gear-down", 0); 
					avionics.controls.gearLights(2);
					setprop("sim/multiplay/generic/int[7]", 2);
		}
    } elsif (!OldValue) {
      setprop("/controls/gear/gear-down", 1);
      setprop("/controls/gear/catapult-launch-cmd", 0);
      setprop("/controls/gear/launchbar", 0);
      # setprop("/controls/gear/tailwheel-lock", 0);
    }
}

#### Afterburner
## see bottom section file

# turn off HUD in external views
# setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);

var hudvisible = func {
	var viewname = getprop("/sim/current-view/name");

	if (viewname == "Cockpit View" or viewname == "Instruments") {
		setprop("/sim/hud/visibility", 1);
		setprop("/sim/hud/visibility[1]", 1);
	} else {
		setprop("/sim/hud/visibility", 0);
		setprop("/sim/hud/visibility[1]", 0);
	}
	settimer(hudvisible, 0.5);
}

settimer(hudvisible, 1);		

#### Canopy ####
# command typhoon.canopy.toggle();

var canopy = aircraft.door.new ("/controls/canopy/", 4);

## Usefull for future message warning
setprop("/controls/canopy/open",0);

setlistener("/controls/canopy/position-norm", func(n) {
	setprop("/controls/canopy/open", ( n.getValue() > 0.01 ) );
},1);

## Launch bar animation f14b

var listen_launchbar = nil;
listen_launchbar = setlistener( "gear/launchbar/state", func { settimer(update_launchbar, 0.05) },0 ,0 );

var update_launchbar = func() {
	WOW =getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
	if ( getprop("gear/launchbar/position-norm") == 1 and ! WOW ) {
		removelistener( listen_launchbar );
		setprop("controls/gear/launchbar", "false");
		setprop("controls/gear/launchbar", "true");
		settimer(reset_launchbar_listener, 1);
	}
}

var reset_launchbar_listener = func() {
	setprop("controls/gear/launchbar", "false");
	listen_launchbar = setlistener( "gear/launchbar/state", func { settimer(update_launchbar, 0.05) },0 ,0 );
}

######### lights

# default all on
setprop("systems/electrical/outputs/beacon/state",1);
setprop("systems/electrical/outputs/strobe/state",1);
setprop("systems/electrical/outputs/nav-lights/state",1);
setprop("systems/electrical/outputs/landing-lights/state",1);

# still not used
setprop("controls/lighting/instrument-lights",1);

#  Strobe Lights
strobe_switch = props.globals.getNode("/controls/switches/strobe-lights", 1);
aircraft.light.new("/sim/model/lights/strobe-upper", [0.02, 1.05], strobe_switch);
aircraft.light.new("/sim/model/lights/strobe-lower", [0.02, 1.35], strobe_switch);

#  Beacons
beacon_switch = props.globals.getNode("controls/switches/beacons", 1);
aircraft.light.new("/sim/model/lights/beacon-upper", [0.02, 1.35], beacon_switch);
aircraft.light.new("/sim/model/lights/beacon-lower", [0.02, 1.05], beacon_switch);

# ------------------------ Unused now (see autopilot.nas)
### SetupDefaultAutopilot, what is better?
# disabled picks
var SetAp = func() {
	if (!ToggleAp) {
	setprop("/autopilot/locks/heading", "true-heading-hold");
	setprop("/autopilot/locks/altitude", "altitude-hold");
	ToggleAp = 1;
	} else {
		setprop("/autopilot/locks/heading", "");
		setprop("/autopilot/locks/altitude", "");
		ToggleAp = 0;
		}
};

#### chute&reverser ####
# chute is deployed and then (released and repacked) with keyboard "d"
# Chutes, How do they work in yasim? --add the chute to yasim file
# Using reverser + brake parking here 

# TODO: chute animation. Is this the chute of choice?
#				rip it to shreds(release submodel) if deployed at too high speeds ( > 150?)

var chute_state = getprop("/controls/chute");

var toggle_chute = func {
    
    var onground = getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow");
    if (chute_state == nil){chute_state = 0;}
        
    if (!onground) {
    # inadvisable action..    
    screen.log.write("I can't let you do that");
    } else {
       
  	if (chute_state == 0) {
	    # stream the chute - 1 second. 
	    # engage all methods of braking..
	    setprop("autopilot/locks/speed", 0); # in case
	    setprop("controls/chute/position-norm", 1);
	    #screen.log.write("Chute deployed..");
	    interpolate("controls/chute-pos-norm", 1, 1);
            interpolate("/controls/gear/brake-left", 0.8, 0.075);
            interpolate("/controls/gear/brake-right", 0.8, 0.075);
	 		chute_state = 1;
	 	   	
		}	elsif ((chute_state == 1) and (getprop("controls/chute-pos-norm") == 1.0)) {
	    # Jettison the chute
	    # release brakes and reverser
	    #screen.log.write("Chute jettisoned");
	    setprop("controls/chute-pos-norm", 0.0);
	    setprop("controls/chute-jettison", 1);
            interpolate("/controls/gear/brake-left", 0, 0.075);
            interpolate("/controls/gear/brake-right", 0, 0.075);
	    setprop("controls/chute/position-norm", 0);
	    #chute_state = 2;
	    settimer(func setprop("controls/chute-jettison", 0), 0.1);
	    setprop("controls/chute-pos-norm", 0.0);
	    chute_state = 0;
	    
	  } 
  		setprop("controls/chute", chute_state);
  	}
	}

## Afterburner
# Due to the possible connection* to generic autopilot reheat wants to set in on autothrottle 
# (only if engaged via /autopilot/locks/speed-with-throtle). Preventing this.
# With added friction to gears in yasim there is no need for reverser anymore. It is used for the chute,
# since there is no chute declared in yasim and so no drag.
# 
# * autopilotconnectors below in this file allow one to use 'regular' ap/menu/shortcuts for 
# pitch-hold, speed-with-throttle, wings-level and altitude-hold which triggers the systems-ap

var engine 		= props.globals.getNode("controls/engines").getChildren("engine");
var throttle	= props.globals.getNode("controls/engines/engine[0]/throttle");

var no_reheat = func {
	foreach(e; engine) {		 
		var burner = e.getNode("reheat", 1);
		if (burner.getValue()) burner.setValue(0);
	}
}

var reheat = func {
	var reheat_ok = getprop("/systems/autopilot/settings/allow-reheat");
	var autothrottle= (getprop("/autopilot/locks/speed/speed-with-throttle") or
		getprop("/systems/autopilot/settings/speed-with-throttle"));
		
	if (autothrottle and !reheat_ok) {
		foreach(e; engine) {		 
			var burner = e.getNode("reheat", 1);
			var throttle = e.getNode("throttle", 1);	
			burner.setValue(0);	
			throttle.setValue(0.98);
		}
	} else {
		foreach(e; engine) {		 
			burner = e.getNode("reheat", 1);
			burner.setValue(1);
		}	
	}
}

# the reverse of below (listener on [0]) doesn't keep the values in sync	
setlistener("controls/engines/engine[1]/throttle", func {
	var reverser	= getprop("/controls/engines/engine[0]/reverser");
	var t = throttle.getValue();
	if (reverser) {	
		no_reheat();		
		if (t > 0.5) {
			foreach(e; engine) {
			var throttle = e.getNode("throttle", 1);
			throttle.setValue(0.5);
			}
		}		
	} else {
		if (t < 0.98 ) {
			no_reheat();
		} else {
			reheat();		
		}
	}			 
});

## auto-slats --modeling needs work?
# maybe add the variable intake to this?
var airspeed_n = props.globals.getNode("/velocities/airspeed-kt");
var angleoa_n = props.globals.getNode("/orientation/alpha-deg" );
var deploy = getprop("/systems/FCS/settings/slat-threshold");

var auto_slats = func {      
  var airspeed = airspeed_n.getValue();
  var angleoa = angleoa_n.getValue();
  var gearDown = getprop ("/controls/gear/gear-down");
    if ((airspeed < deploy or angleoa > 12) and (! gearDown)) {
      setprop("/controls/flight/slats", 1.0);
      } else {
      setprop("/controls/flight/slats", 0.0);
      }
     settimer(auto_slats, 0.3);
}
	
## starter
setlistener("/sim/signals/fdm-initialized", func {
	#electrical_init();
	settimer(fuelTanks, 1); 
	settimer(auto_slats, 1);
});

###############

var deltaT = 1.0;

setlistener("/controls/engines/engine[0]/throttle", func(n) {
    setprop("/controls/engines/engine[0]/reheat", 105 -( n.getValue() >= 0.75)/(105-95));
},1);

setlistener("/instrumentation/tacan/frequencies/selected-channel[4]", func(n) {
    if(n.getValue() =="X"){
        setprop("instrumentation/tacan/frequencies/XPos",1);
    }else{
        setprop("instrumentation/tacan/frequencies/XPos",-1);
    }
},1);

#setlistener("/controls/gear/gear-down", func(n) {setprop("/controls/flight/flaps", 0);},1);

# turn off hud in external views
# setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);

var InitListener = setlistener("/sim/signals/fdm-initialized", func {
        settimer(main_Init_Loop, 5.0);
        removelistener(InitListener);
});

################################################ Main init loop################################################
#####         Perhaps in the future, make an object for each subsystems, in the same way of "engine"   ########
################################################################################################################
var main_Init_Loop = func(){    
            
    print("Radar ...Check");
    settimer(radar.init, 5.0);
    
    print("Flight Director ...Check");
    settimer(typhoon.init_set, 5.0);
    
    print("MFD ...Check");
    settimer(typhoon.update_main, 5.0);
    
    print("Hydraulics ... Check");
    settimer(hydraulics.Hydraulics_init, 1.0);

    print("Intrumentation ...Check");
#    settimer(instrumentation.initIns, 5.0);
    
    print("Transponder ...Check");
#    settimer(init_Transpondeur, 5.0);
    
    print("system loop ...Check");
    settimer(updatefunction, 5.0);
   
}

#######################
var UpdateHead = func {settimer (updatefunction, 0.05);}

var updatefunction = func(){
     #deltaT = getprop ("sim/time/delta-sec");
   
     typhoon.computeSAS();     
     typhoon.UpdateHead();
}
