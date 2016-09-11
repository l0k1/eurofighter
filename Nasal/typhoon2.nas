#### Typhonn systems	
#### from many sources...
#### and also, almursi and algernon work

# need be read again every test
var WOW = getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
#var false = 0;
#var true = 1;
#var TrueHeading = false; # false

#var Reverse_on1 = getprop("/controls/engines/engine[0]/reverser");
#var Reverse_on2 = getppro("/controls/engines/engine[1]/reverser");

var setHook = func() {
  var NoDosVeces=getprop("/controls/tailhook/position-norm");
  if (NoDosVeces!=1) {
	setprop("/controls/tailhook/position-norm", 1);
  	setprop("/controls/gear/tailhook", 1);
	screen.log.write("HOOK extended"); }
    else { 
	setprop("/controls/tailhook/position-norm", 0);
  	setprop("/controls/gear/tailhook", 0);
	screen.log.write("Hook retracted"); 
	}
};


# GearDown Control from f14b gear.nas 
# ----------------
# Hijacked Gear handling so we have a Weight on Wheel security to prevent
# undercarriage retraction when on ground.
# added toggle off launchbar and catapult commands

controls.gearDown = func(v) {
    WOW =getprop ("/gear/gear[1]/wow") or getprop ("/gear/gear[2]/wow");
    if (v < 0 and ! WOW) {
      setprop("/controls/gear/gear-down", 0);
    } elsif (v > 0) {
      setprop("/controls/gear/gear-down", 1);
      setprop("/controls/gear/catapult-launch-cmd", 0);
      setprop("/controls/gear/launchbar", 0);
    }
}


#### Afterburner
# prevent reheat on reverser
setlistener("/controls/engines/engine[0]/throttle", func(n) {
    if ( getprop("/controls/engines/engine[0]/reverser") == 0 ) {
         setprop("/controls/engines/engine[0]/reheat", ( n.getValue() >= 0.95 ) ); }
	else {
		if ( n.getValue() >= 0.40) { n.setValue(0.40) };
	};
#    setprop("/controls/engines/engine[0]/reheat", ( n.getValue() >= 0.95 ) );
},1);


setlistener("/controls/engines/engine[1]/throttle", func(n) {
    if ( getprop("/controls/engines/engine[1]/reverser") == 0 ) {
         setprop("/controls/engines/engine[1]/reheat", ( n.getValue() >= 0.95 ) ); }
	else {
		if ( n.getValue() >= 0.40) { n.setValue(0.40) };
	};
#    setprop("/controls/engines/engine[1]/reheat", ( n.getValue() >= 0.95 ) );
},1);

#### Reverver on test (maybe off on final release)
## only with max 0.40 of throttle
setlistener("/controls/engines/engine[0]/reverser", func(n) {
    if ( getprop("/controls/engines/engine[0]/throttle") > 0.40 ) {
	n.setValue(0);
	};
},1);

setlistener("/controls/engines/engine[1]/reverser", func(n) {
    if ( getprop("/controls/engines/engine[1]/throttle") > 0.40 ) {
	n.setValue(0);
	};
},1);

# turn off hud in external views
setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);

# command typhoon.canopy.toggle();
var canopy = aircraft.door.new ("/controls/canopy/", 3);


aircraft.livery.init("Aircraft/eurofighter/Models2/Liveries");


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

## From seahawk

var tailwheel_lock = props.globals.getNode("/controls/gear/tailwheel-lock", 1);
var launchbar_state = props.globals.getNode("/gear/launchbar/state", 1);

tailwheel_lock.setDoubleValue(1);
launchbar_state.setValue("Disengaged");  

var updateTailwheelLock = func {
	var lock = tailwheel_lock.getValue(); 
	var state = launchbar_state.getValue() ;

	if ( state != "Disengaged" ) {   
		lock = 0;
	} else {
		lock = 1;
	}

	tailwheel_lock.setDoubleValue(lock);

#print("tail-wheel-lock " , lock , " state " , state);

} #end func updateTailwheelLock()

setlistener( launchbar_state , updateTailwheelLock,0,0 );


### Stall warning: ToDo
### #var s_warning_state = getprop("/sim/alarms/stall-warning");

######### lights

# default all on
setprop("systems/electrical/outputs/beacon/state",1);
setprop("systems/electrical/outputs/strobe/state",1);
setprop("systems/electrical/outputs/nav-lights/state",1);
setprop("systems/electrical/outputs/landing-lights/state",1);

# still not used
# setprop("controls/lighting/instrument-lights",1);
# setprop("controls/lighting/nav-lights",1);
# setprop("controls/lighting/beacon",1);
# setprop("controls/lighting/strobe",1);


# Strobe Lights
#strobe_switch = props.globals.getNode("sim/model/livery/strobe", 1);
#aircraft.light.new("/systems/electrical/outputs/strobe", [0.025, 1.05], strobe_switch);
## work fine
strobe_switch = props.globals.getNode("/controls/switches/strobes", 1);
aircraft.light.new("/sim/model/lights/strobe-upper", [0.02, 1.05], strobe_switch);
aircraft.light.new("/sim/model/lights/strobe-lower", [0.02, 1.35], strobe_switch);
# tests
#strobe_switch = props.globals.getNode("/controls/switches/strobe-lights", 1);
#aircraft.light.new("/sim/model/typhoon/strobe-bottom", [0.025, 1.6], strobe_switch);

# Beacons
beacon_switch = props.globals.getNode("sim/model/livery/beacon", 1);
aircraft.light.new("systems/electrical/outputs/beacon", [0.025, 1.05], beacon_switch);
## work fine
#beacon_switch = props.globals.getNode("controls/lighting/beacon", 1);
#aircraft.light.new("systems/electrical/outputs/beacon", [0.025, 1.05], beacon_switch);
# tests
#beacon_switch = props.globals.getNode("controls/switches/beacon", 1);
#aircraft.light.new("/sim/model/typhoon/beacon-top", [0.025, 1.05], beacon_switch);
# beacon_switch = props.globals.getNode("controls/switches/beacon", 1);
# aircraft.light.new("/sim/model/typhoon/beacon-bottom", [0.025, 1.5], beacon_switch);

## Menu dialog Nav Lights
var Luces = gui.Dialog.new("/sim/gui/dialogs/luces/dialog", "Aircraft/eurofighter/menuluces.xml");
## Menu dialog RadarStandBy, Hud (ToDo), IDT radios
var RadarStop = gui.Dialog.new("/sim/gui/dialogs/radarstop/dialog", "Aircraft/eurofighter/menuradar.xml");
## Menu Dialog Autopilot
var APdialog = gui.Dialog.new("/sim/gui/dialogs/ap-dialog/dialog", "Aircraft/eurofighter/Systems/typhoon-apdialog.xml");

#var setTrHead = func() {
	# property adjust fine
        # var TrueHeadingProp = getprop("/autopilot/locks/heading");
	# setprop("/autopilot/locks/heading", "dg-heading-hold");
	# var Estado = getprop("/autopilot/locks/heading",1);
	# var Propiedad = getnode("/autopilot/locks/heading", 1);
	## Es un mentiroso y no se configura correctamente:
	# Con 0 necesita cambio 
	# if (TrueHeadingProp == "") { TrueHeading = false; };
	# if ( TrueHeadingProp == "" ) { TrueHeading = false; };
	# if ( TrueHeadingProp == "true-heading-hold" ) { TrueHeading = true; };
	# if ( TrueHeadingProp == "dg-heading-hold" ) {
	#		screen.log.write("lo hemos puesto a falso porque dice que tiene dg");
	#	 TrueHeading = false; };
	# if ( TrueHeadingProp == "dg-heading-hold" ) { TrueHeading = false; };


#	if ( TrueHeading == true ) {
#		screen.log.write("este cabrón no hace nada");
#		setprop("/autopilot/locks/heading", "");
#		TrueHeading = false;
#		} else {
		# Quiere decir que no hemos pasado por aquí
#		setprop("/autopilot/locks/heading", "true-heading-hold");
#		screen.log.write("lo hemos puesto a cierto después de cambiarlo");
#		TrueHeading = true;
#		};
	

	#if (TrueHeadingProp == "true-heading-hold") {
	#                setprop("/autopilot/locks/heading", "");
	#	} else {  
	#		setprop("/autopilot/locks/heading", "true-heading-hold");
	#		};

#};


### SetupDefaultAutopilot, what is better? * Algernon commented out to try alternative bindings config
#var SetAp = func() {
#	# ToDo: toggle off
#	setprop("/autopilot/locks/heading", "true-heading-hold");
#	setprop("/autopilot/locks/altitude", "altitude-hold");
# };



