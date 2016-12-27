var orientation = func {

	var maghdg = getprop("/orientation/heading-magnetic-deg");
	var truhdg = getprop("/orientation/heading-deg");
	var settrue = getprop("/instrumentation/MFD[0]/PA/true-heading");
	var setnth = getprop("/instrumentation/MFD[0]/PA/orientation-north");
	
	if (setnth) {
		setprop("/instrumentation/MFD[0]/PA/orientation-deg", 0);
				}
		if (!setnth) {
			if (settrue) {	setprop("/instrumentation/MFD[0]/PA/orientation-deg", truhdg); 	};
			if (!settrue) { setprop("/instrumentation/MFD[0]/PA/orientation-deg", maghdg);	};
			}
		settimer(orientation, 0.5);
		}

settimer(orientation, 0.5);

var contact_factor = func {
   var scale = 0.07;
   var pa_zoom = getprop("instrumentation/MFD[0]/PA/zoom-nm");
   result = ( scale / pa_zoom );
   setprop("instrumentation/MFD[0]/PA/contact-factor", result);
   }
   
setlistener("/instrumentation/MFD[0]/PA/zoom-nm", contact_factor);

var fuellevel = func {

	var ftankf1 = getprop("/consumables/fuel/tank[0]/level-lbs");
	var ftankf2 = getprop("/consumables/fuel/tank[1]/level-lbs");
	var ftankf3 = getprop("/consumables/fuel/tank[3]/level-lbs");
	var ftankf4 = getprop("/consumables/fuel/tank[5]/level-lbs");
	var ftankr1 = getprop("/consumables/fuel/tank[4]/level-lbs");
	var ftankr2 = getprop("/consumables/fuel/tank[6]/level-lbs");
	var ftankr3 = getprop("/consumables/fuel/tank[2]/level-lbs");
	
	var ftanksf = ( ftankf1 + ftankf2 + ftankf3 + ftankf4 );
	var ftanksr = ( ftankr1 + ftankr2 + ftankr3 );
	
	setprop("/consumables/fuel/fwd-level-lbs", ftanksf);
	setprop("/consumables/fuel/rear-level-lbs", ftanksr);
	
	settimer(fuellevel, 0.5);	
	}
	
settimer(fuellevel, 2);

var fuelflow = func {

    var rpm1 = getprop("/engines/engine[0]/rpm");
	var rpm2 = getprop("/engines/engine[1]/rpm");
	var adjuster1 = ( rpm1 / 4 );
	var adjuster2 = ( rpm2 / 4 );
	
	var leftgph = getprop("/engines/engine[0]/fuel-flow-gph");
	var rightgph = getprop("/engines/engine[1]/fuel-flow-gph");
	var leftgpm = (( leftgph / 6 ) + adjuster1);
	var rightgpm = (( rightgph / 6 ) + adjuster2);
	setprop("/engines/engine[0]/fuel-flow-gpm", leftgpm);
	setprop("/engines/engine[1]/fuel-flow-gpm", rightgpm);
	settimer(fuelflow, 0.1);	
}
settimer(fuelflow, 0.5);

var LightAls = func {

	var switchPos = getprop("sim/multiplay/generic/int[7]");
	var currView = getprop("/sim/current-view/name");
	var land1 = props.globals.getNode("/controls/switches/landlight1");
	var land2 = props.globals.getNode("/controls/switches/landlight2");
	var lightpower = getprop("/systems/electrical/outputs/bus");

	if (currView != "Cockpit View") {
		land1.setBoolValue(0);
		land2.setBoolValue(0);
	} else {

	if (switchPos == 1 and lightpower > 100) {
			setprop("/sim/rendering/als-secondary-lights/landing-light1-offset-deg", 5.5);
			setprop("/sim/rendering/als-secondary-lights/landing-light2-offset-deg", -5.5);
			setprop("/sim/rendering/als-secondary-lights/landing-light3-offset-deg", 6);
			land1.setBoolValue(1);
			land2.setBoolValue(1);
	}
	if (switchPos == 2) {				
			land1.setBoolValue(0);
			land2.setBoolValue(0);
	}
	if (switchPos == 3 and lightpower > 100) {
			setprop("/sim/rendering/als-secondary-lights/landing-light1-offset-deg", 6.5);
			setprop("/sim/rendering/als-secondary-lights/landing-light2-offset-deg", -6.5);
			setprop("/sim/rendering/als-secondary-lights/landing-light3-offset-deg", 1);
			land1.setBoolValue(1);
			land2.setBoolValue(1);
	}
	}
	settimer(LightAls, 0.5);
}
settimer(LightAls, 0.5);


var controls = {
     windshield: func(a) {
	     var WSswitch = props.globals.getNode("/controls/switches/windshield");
		 WSswitch.setValue(a);
		 if ( a == 0 ) {
				setprop("/controls/windshield-heat", 0);
			 }
		 if ( a == 1 ) {
				setprop("/controls/windshield-heat", 1);
			 }
		},		     
     demist: func(a) {
	     var Demswitch = props.globals.getNode("/controls/switches/demist");
		 Demswitch.setValue(a);
		 if ( a == 0 ) {
				setprop("/controls/demist", 0);
			 }
		 if ( a == 1 ) {
				setprop("/controls/demist", 1);
			 }
		},		     
     gearLights: func(a) {
	     var switch = props.globals.getNode("/controls/switches/gear-lights");
		 var land = props.globals.getNode("/controls/switches/landing-lights");
		 var taxi = props.globals.getNode("/controls/switches/taxi-lights");
		 switch.setValue(a);
		 if ( a == 1 ) {
			 land.setBoolValue(1);
			 taxi.setBoolValue(0);
			 }
		 if ( a == 2 ) {
			 land.setBoolValue(0);
			 taxi.setBoolValue(0);
			 }
		 if ( a == 3 ) {
			 land.setBoolValue(0);
			 taxi.setBoolValue(1);
			 }
		},		     
	 cabinTemp: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/cabin-temp");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.10 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.10 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
	 cabinFlow: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/cabin-flow");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.10 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.10 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
	 suitTemp: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/suit-temp");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.25 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.25 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
	 formLights: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/formation-lights");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.1 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.1 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
	 consoleDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/console-lighting");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.05 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.05 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
	 glareshieldDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/glareshield-lighting");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.05 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.05 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},
     displayDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/display-brightness");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.05 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.05 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},				
     mapDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/map-brightness");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.05 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.05 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.2);
		},				
	 engineStart: func(b) {
	     var engswitch = props.globals.getNode("/controls/switches/engine-start");
		 if ( b == 0 ) { 
		     engswitch.setValue(0);
			 decmu.engstop();
			}
		 if ( b == 1 ) { 
		 	#print("b is 1");
		     engswitch.setValue(2);
			 decmu.start.switch();
				}
		 settimer( func { engswitch.setValue(1); }, 0.5);
		}, 
	 leftLPCockCover: func {
	     var cock = props.globals.getNode("/controls/switches/lp-cock-left-cover");
		 var pos = cock.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/switches/lp-cock-left-cover", 1, 0.2);
			};
		 if ( pos == 1 ) { 
		     interpolate(cock, 0, 0.2);
			};
		},
	 rightLPCockCover: func {
	     var cock = props.globals.getNode("/controls/switches/lp-cock-right-cover");
		 var pos = cock.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/switches/lp-cock-right-cover", 1, 0.2);
			};
		 if ( pos == 1 ) { 
		     interpolate(cock, 0, 0.2);
			};
		},
	 fuelProbeCover: func {
	     var cock = props.globals.getNode("/controls/switches/fuel-probe-cover");
		 var pos = cock.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/switches/fuel-probe-cover", 1, 0.2);
			};
		 if ( pos == 1 ) { 
		     interpolate(cock, 0, 0.2);
			};
		},
	 MASStoggle: func {
	     var mass = props.globals.getNode("/controls/rotary/MASS");
		 var pos = mass.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/rotary/MASS", 1, 0.25);
			 settimer( func { setprop("/controls/armament/master-arm", 1); }, 0.175 );
			 setprop("/controls/armament/master-arm-standby", 0);
			 hud.activate_borsight();
			}
		 if ( pos == 1 ) { 
		     interpolate("/controls/rotary/MASS", 0, 0.25);
			 setprop("/controls/armament/master-arm", 0);
			 setprop("/controls/armament/master-arm-standby", 1);
			 hud.activate_borsight();
			}
		},
	 armSeat: func {
	     var handle = props.globals.getNode("/controls/seat/arming-handle");
		 var pos = handle.getValue();
		  if ( pos == 0 ) { 
		     interpolate(handle, 1, 0.3);
			};
		 if ( pos == 1 ) { 
		     interpolate(handle, 0, 0.3);
			};
	    }
	}

