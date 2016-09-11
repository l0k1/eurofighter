### Autopilot Modes


## Initialise Nodes

props.globals.initNode("/systems/autopilot/settings/allow-reheat", 0, "BOOL");

## Safety Settings for Autopilot

var altdiff = 0;

var startHDG = getprop("orientation/heading-magnetic-deg");
var startTrueHDG = getprop("orientation/heading-deg");
setprop("/systems/autopilot/settings/heading-bug-deg", startHDG);
setprop("/systems/autopilot/settings/target-altitude-ft", 4000);
setprop("/systems/autopilot/settings/target-agl-ft", 1000);
setprop("/systems/autopilot/settings/target-pitch-deg", 0);
setprop("/systems/autopilot/settings/target-roll-deg", 0);
setprop("/systems/autopilot/settings/target-speed-kt", 350);
setprop("/systems/autopilot/settings/target-speed-mach", 1.2);
setprop("/systems/autopilot/settings/true-heading-deg", startTrueHDG);
setprop("/systems/autopilot/settings/kts-mach-select", "kts");

## Common AP Variables

## Basic Functions
var init = func {
     settimer(panic, 0.5);
	}
		

var apCancel = func {
	setprop("/systems/DRF/command", 0);
	setprop("/systems/autopilot/locks/heading", "");
	setprop("/systems/autopilot/locks/altitude", "");
	setprop("/systems/autopilot/locks/speed", "");
	}

var panic = func {
	var DRFcmd = getprop("/systems/DRF/command");
	var acpitch = getprop("/orientation/pitch-deg");
	var acspd = getprop("/velocities/airspeed-kt");
	var acElev = getprop("/controls/flight/elevator");
	if (DRFcmd == 1) {
		if ( (acpitch < 3) and (acspd < 350) ) {
		setprop("/systems/autopilot/settings/target-roll-deg", "0");
		setprop("/systems/autopilot/locks/heading", "roll-hold");
		setprop("/controls/flight/elevator", -0.8);
		}
		if ( (acpitch < 3) and (acspd >= 350) ) {
		setprop("/systems/autopilot/settings/target-roll-deg", "0");
		setprop("/systems/autopilot/locks/heading", "roll-hold");
		setprop("/controls/flight/elevator", -0.4);
		}
		if (acpitch >= 3) {
			setprop("/controls/flight/elevator", 0);
			setprop("/systems/autopilot/settings/target-roll-deg", "0");
			setprop("/systems/autopilot/locks/heading", "roll-hold");
			setprop("/systems/autopilot/settings/target-pitch-deg", "9");
			setprop("/systems/autopilot/locks/altitude", "pitch-hold");
			setprop("/systems/autopilot/settings/target-speed-kt", "300");
			setprop("/systems/autopilot/locks/speed", "speed-with-throttle");
		}
	}
    settimer(panic, 0.5);
}

# Feet per sec = (current-altitude - target-altitude) / seconds-to-target

## AP Dialog Functions

var ATselKts = func {
setprop("/systems/autopilot/settings/kts-mach-select", "kts");
}

var ATselMach = func {
setprop("/systems/autopilot/settings/kts-mach-select", "mach");
}

## Auto Climb

var autoclimb = func {
   var crtAlt = getprop("position/altitude-ft");
   var tgtAlt = getprop("/systems/autopilot/settings/target-altitude-ft");
   if (crtAlt = tgtAlt) {
      setprop("/systems/autopilot/locks/altitude", "altitude-hold");
	  setprop("/systems/autopilot/locks/speed", "");
	  }
   else {
      setprop("/systems/autopilot/locks/altitude", "auto-climb");
	  setprop("/systems/autopilot/locks/speed", "");
      }
   settimer(autoclimb, 1);
}


var autoTO = func {
   var crtHdg = getprop("orientation/heading-deg");
   var crtAgl = getprop("position/altitude-agl-ft");
   if ( crtAgl <= 10 )  {
      setprop("/systems/autopilot/settings/heading-bug-deg", crtHdg);
	  setprop("/systems/autopilot/locks/heading", "auto-accel");
	  setprop("/systems/autopilot/locks/altitude", "auto-climb");
	  setprop("/systems/autopilot/locks/speed", "speed-with-reheat");
	  }
   else
      {
	  }
}

var autoATK = func {
	var autopTarget = getprop("/autopilot/target-tracking/enable");
	if ( autopTarget < 1) {
   setprop("/autopilot/target-tracking/enable", 1);
   setprop("/systems/autopilot/locks/altitude", "auto-attack");
   setprop("/systems/autopilot/locks/heading", "auto-attack");
   setprop("/systems/autopilot/locks/speed", "auto-attack");
   }
	else
	{
   setprop("/autopilot/target-tracking/enable", 0);
	setprop("/systems/autopilot/locks/heading", "");
	setprop("/systems/autopilot/locks/altitude", "");
	setprop("/systems/autopilot/locks/speed", "");
	}
}

settimer(init, 10);
