# Settings
var stepTime = 1.5; # Time between each step, before delay, in seconds

props.globals.initNode("/sim/autostart/step", 0, "INT");

var controls = props.globals.getNode("controls");
var buttons = controls.getNode("buttons");
var switches = controls.getNode("switches");
var instruments = props.globals.getNode("instrumentation");
var sim = props.globals.getNode("sim");
var light = props.globals.getNode("sim/time/sun-angle-rad");

 var num=0; var name=1; var go=2; var delay=3; var alert=4;
 var power = [
     [0,"null",0,-1.5,"Executing Power-Up checklist..."],
	 [1,"Canopy opening",func {
	     typhoon.canopy.toggle();
		},0,0],
     [2,"Battery Switch on",func {
	     controls.getNode("electric/battery-switch").setBoolValue(1);
	     switches.getNode("strobe-lights").setBoolValue(1);
		},1,0],
	 [3,"MHDDs on",func {
	     switches.getNode("MIDS-power").setBoolValue(1);
	     switches.getNode("rad-1-power").setBoolValue(1);
	     switches.getNode("com1-power").setBoolValue(1);
	     instruments.getNode("MFD[0]/stand-by").setBoolValue(0);
	     instruments.getNode("MFD[1]/stand-by").setBoolValue(0);
		 instruments.getNode("MFD[2]/stand-by").setBoolValue(0);
		},4,0],
	 [4,"APU Button on",func {
	     buttons.getNode("APU").setBoolValue(1);
		},7,0],
     [5,"Hud on",func {
 	     setprop("/sim/gui/dialogs/radios/transponder-mode", 'ON');
 	     setprop("/sim/hud/current-color", 0);
		},12,0],
	];

var apu_listener = nil;
var remove_apu_listener = func {
	if ( apu_listener != nil ) {
		removelistener(apu_listener);
	}
}

var engineStart = [	
     [0,"null",0,-1,"Executing Engine Start checklist..."],
	 [1,"LP Cocks open",func {
		 var lcock = switches.getNode("lp-cock-left");
		 var rcock = switches.getNode("lp-cock-right");
		 settimer( func { avionics.controls.leftLPCockCover(); }, 0.5);
		 settimer( func { lcock.setBoolValue(1); }, 0.75);
		 settimer( func { avionics.controls.leftLPCockCover(); }, 1.0);
		 settimer( func { avionics.controls.rightLPCockCover(); }, 1.25);
		 settimer( func { rcock.setBoolValue(1); }, 1.75);
		 settimer( func { avionics.controls.rightLPCockCover(); }, 2.0);
	    },0.5,0],
	 [2,"Boost Pumps on",func {
	     switches.getNode("boost-pump-left").setBoolValue(1);
		 switches.getNode("boost-pump-right").setBoolValue(1);
		},6,0],	 
	 [3,"Engine Start",func {
	 	 apu_listener = setlistener("/engines/engine[2]/rpm", func {
	 	 		if ( getprop("engines/engine[2]/rpm") > 75 and getprop("/systems/electrical/outputs/FCS") > 105) {
	 	 			#print("!!!!!!!!!!!!!!!!!ENGINES SHOULD BE STARTING!!!!!!!!!!!!!!!!!!!");
	 	 			avionics.controls.engineStart(1);
	 	 			#remove_apu_listener();
	 	 			removelistener(apu_listener);
	 	 		}
	 	 	});
		},0.5,0],
	];
	
var taxi = [
     [0,"null",0,-1,"Null!"],
	 [1,"APU Button off",func {
	     buttons.getNode("APU").setBoolValue(0);
		},10,0],
	 [2,"Arm Ejection Seat", func {
	     pos = controls.getNode("seat/arming-handle").getValue();
		 if ( pos != 1 ) {
		     avionics.controls.armSeat();};
			}, 1.75,0],
	 [3,"Navigation lights on",func {
	     setprop("/controls/switches/nav-lights", 2);
		},2,0],
	 [4,"Instruments on",func {
	     switches.getNode("voice").setBoolValue(1);
	     switches.getNode("rad-2-power").setBoolValue(1);
	     switches.getNode("com2-power").setBoolValue(1);
		 guns.reload_Cannon();
		},3,0],
	 [5,"Canopy closing",func {
	     typhoon.canopy.toggle();
		},5,0],
	 [6,"Air conditoning on",func {
	     avionics.controls.windshield(1);
		 avionics.controls.demist(1);
 	     setprop("/controls/rotary/cabin-temp", 0.75);
 	     setprop("/controls/rotary/cabin-flow", 0.9);
		},9,0],
	 [7,"G limits",func {
 	     setprop("/sim/rendering/redout/parameters/blackout-onset-g", 10.5);
 	     setprop("/sim/rendering/redout/parameters/blackout-complete-g", 12.5);
 	     setprop("/sim/rendering/redout/parameters/redout-onset-g", -3.5);
 	     setprop("/sim/rendering/redout/parameters/redout-complete-g", -5.5);
 	     setprop("sim/rendering/redout/enabled", 1);
		},12,0],
	];
	
var engineShutdown = [
     [0,"null",0,0,"Null!"],
	 [1,"MHDD shutdown function",func {
#			avionics.mfd.select(1,"proc");
#			avionics.mfd.select(2,"engman");
		},0.5,0],
	 [2,"Navigation lights off",func {
	     setprop("/controls/switches/nav-lights", 0);
 	     setprop("/controls/rotary/formation-lights", 0);
		},0.5,0],
	 [3,"Anticoll lights off",func {
	     switches.getNode("beacons").setBoolValue(0);
		},2,0],
	 [4,"DisArm Ejection Seat", func {
	     pos = controls.getNode("seat/arming-handle").getValue();
		 if ( pos != 0 ) {
		     avionics.controls.armSeat();};
			},2.0,0],
	 [5,"Air conditoning off",func {
	     avionics.controls.windshield(0);
		 avionics.controls.demist(0);
 	     setprop("/controls/rotary/cabin-temp", 0);
 	     setprop("/controls/rotary/cabin-flow", 0);
		},2.5,0],
	 [6,"Canopy open",func {
	     typhoon.canopy.toggle();
	     typhoon.canopy.toggle();
		},3,0],
     [7,"Centre MHDD off",func {
	     instruments.getNode("transponder/switch/off").setBoolValue(1);
		 typhoon.xponderoff();
		},4,0],
	 [8,"Boost Pumps off",func {
	     switches.getNode("boost-pump-left").setBoolValue(0);
		 switches.getNode("boost-pump-right").setBoolValue(0);
		},5,0],	 
	 [9,"Engine Shutdown",func {
	     avionics.controls.engineStart(0);
		},7,0],
	];

var StepOut = [
     [0,"null",0,0,"Null!"],
     [1,"Left & Right MHDDs off",func {
	     instruments.getNode("MFD[0]/stand-by").setBoolValue(1);
	     instruments.getNode("MFD[1]/stand-by").setBoolValue(1);
	     instruments.getNode("MFD[2]/stand-by").setBoolValue(1);
	     switches.getNode("strobe-lights").setBoolValue(0);
		},11.5,0],
	 [2,"Instruments off",func {
	     switches.getNode("voice").setBoolValue(0);
	     switches.getNode("rad-1-power").setBoolValue(0);
	     switches.getNode("rad-2-power").setBoolValue(0);
	     switches.getNode("com1-power").setBoolValue(0);
	     switches.getNode("com2-power").setBoolValue(0);
	     switches.getNode("MIDS-power").setBoolValue(0);
		},13,0],
	 [3,"LP Cocks closed",func {
		 var lcock = switches.getNode("lp-cock-left");
		 var rcock = switches.getNode("lp-cock-right");
		 settimer( func { avionics.controls.rightLPCockCover(); }, 0.5);
		 settimer( func { rcock.setBoolValue(0); }, 0.75);
		 settimer( func { avionics.controls.rightLPCockCover(); }, 1.0);
		 settimer( func { avionics.controls.leftLPCockCover(); }, 1.25);
		 settimer( func { lcock.setBoolValue(0); }, 1.75);
		 settimer( func { avionics.controls.leftLPCockCover(); }, 2.5);
	    },14.5,0],
     [4,"Hud off",func {
 	     setprop("/sim/hud/current-color", 2);
		},16,0],
     [5,"Battery Switch off",func {
	     controls.getNode("electric/battery-switch").setBoolValue(0);
		},17,0],
	];

var autostart = func {
     if ( getprop("/sim/autostart/step") > 0 ) {
	     screen.log.write("Engines already running...");
		}
	 else {
     screen.log.write("Auto starting");
	 group.power();
	 settimer( func { group.engineStart(); }, 15);
	 settimer( func { group.taxi(); }, 45);
		}
	}
	
var shutdown = func {
     if ( getprop("/sim/autostart/step") == 0 ) {
	     screen.log.write("That's done already !...");
		}
	 else {
     screen.log.write("Shutting Down");
	 group.engineShutdown();
	 settimer( func { group.StepOut(); }, 22);
		}
	}
	
var group = {
     power: func {
    	 foreach (x; power) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 }
	     setprop("/sim/autostart/step", 1);
	},
	engineStart: func {
    	 foreach (x; engineStart) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 if ( alert != 0 ) {
		     screen.log.write(alert);
			}
		 }
		 setprop("/sim/autostart/step", 2);
	},
	engineShutdown: func {
    	 foreach (x; engineShutdown) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 }
		setprop("/sim/autostart/step", 0);
	},
	StepOut: func {
    	 foreach (x; StepOut) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 }
	},
	taxi: func {
    	 foreach (x; taxi) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 }
		 setprop("/sim/autostart/step", 3);
	},
}
