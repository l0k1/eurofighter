
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

