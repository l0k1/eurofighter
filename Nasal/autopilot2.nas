### Autopilot Modes


## Initialise Nodes

props.globals.initNode("/systems/autopilot/settings/allow-reheat", 0, "BOOL");

## Safety Settings for Autopilot

var altdiff = 0;

var startHDG = getprop("orientation/heading-magnetic-deg");
setprop("/systems/autopilot/settings/heading-bug-deg", startHDG);
setprop("/systems/autopilot/settings/target-altitude-ft", 4000);
setprop("/systems/autopilot/settings/target-agl-ft", 1000);
setprop("/systems/autopilot/settings/target-pitch-deg", 0);
setprop("/systems/autopilot/settings/target-roll-deg", 0);
setprop("/systems/autopilot/settings/target-speed-kt", 350);
setprop("/systems/autopilot/settings/target-speed-mach", 1.2);
setprop("/systems/autopilot/settings/true-heading-deg", startHDG);
setprop("/systems/autopilot/settings/kts-mach-select", "kts");

## Common AP Variables

## Basic Functions

var apCancel = func {
	setprop("/systems/autopilot/locks/heading", "");
	setprop("/systems/autopilot/locks/altitude", "");
	setprop("/systems/autopilot/locks/speed", "");
	}

var panic = func {
setprop("/systems/autopilot/settings/target-roll-deg", "0");
setprop("/systems/autopilot/locks/heading", "roll-hold");
setprop("/systems/autopilot/settings/target-pitch-deg", "5");
setprop("/systems/autopilot/locks/altitude", "pitch-hold");
}

# Feet per sec = (current-altitude - target-altitude) / seconds-to-target

var nav_altitude = func {

   var locked = getprop("/systems/autopilot/settings/nav-lock");
   if ( locked ) {
         var curr_alt = getprop("/position/altitude-ft");
         var des_alt = getprop("/systems/autopilot/internal/nav-altitude-ft");
         var time = getprop("/instrumentation/gps/wp/wp[1]/TTW-sec");
		 var des_fps = ( ( des_alt - curr_alt ) / time );
		 setprop("/systems/autopilot/internal/nav-fps", des_fps );
		 }
    settimer(nav_altitude, 0.3);
	}

setlistener("/sim/signals/fdm-initialized", nav_altitude);

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

var aclmSelect = func {
   var crtAlt = getprop("position/altitude-ft");
   var tgtAlt = getprop("/systems/autopilot/settings/target-altitude-ft");
   var reheat = getprop("/systems/autopilot/settings/autoclimb/allow-reheat");
   var currentKTS = getprop("velocities/airspeed-kt");
   if ((tgtAlt - crtAlt) > 5000) {
      setprop("/systems/autopilot/settings/target-speed-kt", currentKTS);
      setprop("/systems/autopilot/locks/speed", "speed-with-reheat");
	  setprop("/systems/autopilot/locks/altitude", "auto-climb");
	  autoclimb();
	  }
   else  {
      setprop("/systems/autopilot/locks/altitude", "altitude-hold");
	  }
}

var init = func {
     settimer(aclmSelect, 5);
	}
		
var aclmSelect2 = func {
	altdiff = 0;

   var crtAlt = getprop("position/altitude-ft");
   var tgtAlt = getprop("/systems/autopilot/settings/target-altitude-ft");

   if (crtAlt == tgtAlt) {
		altdiff = 1;
	}

   if (!altdiff) {
      setprop("/systems/autopilot/settings/target-speed-kt", 350);
      setprop("/systems/autopilot/locks/speed", 350);
	  setprop("/systems/autopilot/locks/altitude", "altitude-hold");
	  }
   if (altdiff) {
      setprop("/systems/autopilot/settings/target-speed-kt", "");
      setprop("/systems/autopilot/locks/speed", "");
	  setprop("/systems/autopilot/locks/altitude", "");
	  }
     settimer(aclmSelect, 0.3);
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

