# simple fuelsystem
# this will use fuel from external tanks first. 
# while refueling all tanks are selected

props.globals.initNode("systems/refuel/refueling", 0, "BOOL");
props.globals.initNode("systems/refuel/refueling_grnd", 0, "BOOL");
props.globals.initNode("/orientation/inverted", 0, "BOOL");

var engine = props.globals.getNode("controls/engines").getChildren("engine");
var fueltanks = props.globals.getNode("consumables/fuel").getChildren("tank");
var wow = getprop ("/gear/gear[0]/wow");
var parked = getprop("controls/gear/brake-parking");
var refueling_grnd = props.globals.getNode("systems/refuel/refueling_grnd"); 
var refueling = props.globals.getNode("systems/refuel/refueling"); 

setlistener("systems/refuel/contact", func(n) {
	if (n.getValue() == 1) {
		refueling.setValue(1);
		foreach(f; fueltanks) {
			f.getNode("selected", 1).setBoolValue(1);
		}
	} else {
		refueling.setValue(0);
	}
},1);

# accessible from menu:
var fillup = func {
		if (wow and parked) {
		foreach(f; fueltanks) {		
		var cap 	= f.getNode("capacity-gal_us");
		var level = f.getNode("level-gal_us");
		if (cap.getValue() > level.getValue()) {
			refueling_grnd.setValue(1);
			f.getNode("selected", 1).setBoolValue(1);
			interpolate(f.getNode("level-gal_us"), cap.getValue(), 20);
			} 
		}	
		settimer( func refueling_grnd.setValue(0), 20);
	}	
}

var fuelTanks = func {
	if (refueling.getValue() == 0 and refueling_grnd.getValue() == 0) {

	var levelDropStbd = getprop("consumables/fuel/tank[7]/level-gal_us");
		if(levelDropStbd == nil) { levelDropStbd = 0; }
	var levelDropPort = getprop("consumables/fuel/tank[6]/level-gal_us");
		if(levelDropPort == nil) { levelDropPort = 0; }
	var levelDropCentr = getprop("consumables/fuel/tank[8]/level-gal_us");
		if(levelDropCentr == nil) { levelDropCentr = 0; }
	var wingtanks = getprop("sim/weight[13]/weight-lb") + getprop("sim/weight[15]/weight-lb");
		var centertank = getprop("sim/weight[14]/weight-lb");
		if (getprop("sim/freeze/fuel")) { return registerTimer(fuelTanks); }
		if (getprop("systems/refuel/contact")) {return registerTimer(fuelTanks); }
	
	# first zero all tanks
	foreach(f; fueltanks) {
			if (f.getNode("selected", 1).getBoolValue()){
				f.getNode("selected", 1).setBoolValue(0);
				}
			}
	# centreline	
	if (levelDropCentr > 0) {
		setprop("consumables/fuel/tank[8]/selected", 1);
	# wingtanks	
	} elsif (levelDropStbd > 0 and levelDropPort > 0) { 
		setprop("consumables/fuel/tank[6]/selected", 1);
		setprop("consumables/fuel/tank[7]/selected", 1); 
	# internal: not ordered yet
	} else {
			foreach(f; fueltanks) {
			if (f.getNode("level-lbs").getValue() > 0.01) {
				f.getNode("selected", 0).setBoolValue(1);
				} 
			}
		}
	} 
	settimer(fuelTanks, 0.1);
}

#### Probe ####
# command typhoon.probe.toggle();
#var probe = aircraft.door.new ("/controls/probe/", 1);

## Usefull for future message warning
#setprop("/controls/probe/open",0);

var fuel_probe = func {
   var fuel_probe_switch = getprop("controls/switches/fuel-probe");
    var eng1run = props.globals.getNode("/engines/engine[0]/running").getBoolValue();
 	var eng2run = props.globals.getNode("/engines/engine[1]/running").getBoolValue();
			 if ((eng1run) and (eng2run)) {
   				if ( fuel_probe_switch == 1 ) { interpolate("/sim/multiplay/generic/float[6]", 1, 3.0); }
   				if ( fuel_probe_switch == 0 ) { interpolate("/sim/multiplay/generic/float[6]", 0, 3.0); }
   }
}
   
setlistener("/controls/switches/fuel-probe", fuel_probe);

# Inverted Property

var invpos = func {
   rolldeg = getprop("/orientation/roll-deg");
   if ( ( rolldeg < -150 ) or ( rolldeg > 150 ) ) {
      setprop("/orientation/inverted", 1); }
   else {
      setprop("/orientation/inverted", 0); }
   settimer(invpos,0.25);
   }

setlistener("/sim/signals/fdm-initialized", invpos);

# Fuel Vent
	var pilot_g 		= props.globals.getNode("accelerations/pilot-g", 1);

	pilot_g.setDoubleValue(1); 

	var damp = 0;

var fuel_vent = func {
	var g       = pilot_g.getValue();
	fvalt       = getprop("/position/altitude-ft");
	fvspd       = getprop("/velocities/groundspeed-kt");
	fvinv       = getprop("/orientation/inverted");
	fvdump      = getprop("/consumables/fuel/dump-valve");

	if (g == nil) { g = 0; }

	if ( g < -1 ) {
		setprop("/consumables/fuel/dump-valve", 1);
	}	
	if ( g > 1 ) {
		setprop("/consumables/fuel/dump-valve", 0);
	}	
 
   if ((fvalt > 400) and (fvspd > 100)) {
      if ((fvinv) or (fvdump)) {
	     setprop("/sim/multiplay/generic/int[19]", 1);
		 }
	  else {
	     setprop("/sim/multiplay/generic/int[19]", 0);
	     }
	 }
   settimer(fuel_vent, 1);
   }

setlistener("/sim/signals/fdm-initialized", fuel_vent);   

