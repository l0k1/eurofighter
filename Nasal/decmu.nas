## DECMU

## Engines

#Initialise

var apu = engines.Jet.new(2 , 0 , 0.01 , 10 , 6 , 6 , 6 , 3);
var engine1 = engines.Jet.new(0 , 0 , 0.01 , 5.21 , 4 , 4 , 0.025 , 1);
var engine2 = engines.Jet.new(1 , 0 , 0.01 , 5.21 , 4 , 4 , 0.025 , 1);

   apu.init();
   engine1.init();
   engine2.init();

#Reheat
props.globals.initNode("/systems/DECMU/internal/require-reheat", 0, "BOOL");

var ThrGateL = func {
   var rhgate = getprop("/systems/DECMU/settings/reheat-gate-norm");
   var throttleL = getprop("/controls/engines/engine[0]/throttle");
   if ( throttleL > rhgate ) { setprop("/controls/engines/engine[0]/reheat", 1); }
   if ( throttleL < rhgate ) { setprop("/controls/engines/engine[0]/reheat", 0); }
   }
   
var ThrGateR = func {
   var rhgate = getprop("/systems/DECMU/settings/reheat-gate-norm");
   var throttleR = getprop("/controls/engines/engine[1]/throttle");   
   if ( throttleR > rhgate ) { setprop("/controls/engines/engine[1]/reheat", 1); }
   if ( throttleR < rhgate ) { setprop("/controls/engines/engine[1]/reheat", 0); }
   }
   
setlistener("/controls/engines/engine[0]/throttle", ThrGateL); 
setlistener("/controls/engines/engine[1]/throttle", ThrGateR); 
   
props.globals.initNode("/engines/engine[0]/bleed-air", 0, "BOOL");
props.globals.initNode("/engines/engine[1]/bleed-air", 0, "BOOL");
props.globals.initNode("/sim/autostart/started", 0, "BOOL");

var apustarter = func { setprop("/controls/engines/engine[2]/starter", 1); }
var apufuelon = func { setprop("/controls/engines/engine[2]/cutoff", 0); }
var apufueloff = func { setprop("/controls/engines/engine[2]/cutoff", 1); }

var eng1fuelon = func { setprop("/controls/engines/engine[0]/cutoff", 0); }
var eng1fueloff = func { setprop("/controls/engines/engine[0]/cutoff", 1); }

var eng2fuelon = func { setprop("/controls/engines/engine[1]/cutoff", 0); }
var eng2fueloff = func { setprop("/controls/engines/engine[1]/cutoff", 1); }

var eng1air = func { 
   var air1relay = getprop("/systems/DECMU/command-outputs/engine[0]/air-start");
   var apurun = getprop("/engines/engine[2]/running");
   if ( air1relay == 1 ) {
      if ( apurun == 1 ) {
	     setprop("/controls/engines/engine[0]/starter", 1);
      }
   }
}
setlistener("/systems/DECMU/command-outputs/engine[0]/air-start", eng1air);

var eng2air = func { 
   var air2relay = getprop("/systems/DECMU/command-outputs/engine[1]/air-start");
   var apurun = getprop("/engines/engine[2]/running");
   if ( air2relay == 1 ) {
      if ( apurun == 1 ) {
	     setprop("/controls/engines/engine[1]/starter", 1);
      }
   }
}
setlistener("/systems/DECMU/command-outputs/engine[1]/air-start", eng2air);

var apustart = func {
   setprop("/systems/DECMU/internal/APU-throttle", 0);
   var aputhrotset = getprop("/systems/DECMU/settings/APU-throttle");
   apustarter();
   settimer( apufuelon, 2);
   settimer( func { setprop("/systems/DECMU/internal/APU-throttle", aputhrotset); },9);
   setprop("/controls/buttons/APU", 1);
}

var apustop = func {
   setprop("/systems/DECMU/internal/APU-throttle", 0);
   settimer(apufueloff, 0.5);
   setprop("/controls/buttons/APU", 0);
}

var eng1start = func {
   eng1fueloff();
   setprop("/systems/DECMU/command-outputs/engine[0]/air-start", 1);
   settimer(eng1fuelon, 2);
}

var eng2start = func {
   eng2fueloff();
   setprop("/systems/DECMU/command-outputs/engine[1]/air-start", 1);
   settimer(eng2fuelon, 2);
}

var engstart = func {
   settimer(eng1start, 5);
   settimer(eng2start, 15);
}

var engstop = func {
   eng1fueloff();
   eng2fueloff();
}

var autostop = func {
   eng1fueloff();
   eng2fueloff();
   apufueloff();
}
   
var apu_button = func {
   var but_state = getprop("/controls/buttons/APU");
   var apu_state = getprop("/engines/engine[2]/running");
   if (but_state and !apu_state) { apustart(); }
   if (!but_state and apu_state) { apustop(); }
}
setlistener("/controls/buttons/APU", apu_button);

# in Decmu 

var start = {

     switch: func {

     # Check Power
	 
	 var volts = props.globals.getNode("/systems/electrical/outputs/FCS").getValue();
	 if ( volts > 105 ) {
	 	  
		 # Check Nogos
		 var x = 0;
		 var nogos = props.globals.getNode("/systems/warnings/nogos").getChildren();
		 foreach (a; nogos) {
		     var b = a.getBoolValue();
			 if (b) {
			     x = ( x + 1 );
		    	}
		    }
		 if ( x == 0 ) {
		 # Make sure engines are off
             var eng1run = props.globals.getNode("/engines/engine[0]/running").getBoolValue();
 			 var eng2run = props.globals.getNode("/engines/engine[1]/running").getBoolValue();
			 if ((!eng1run) and (!eng2run)) {
			     settimer( func { decmu.start.engine(1);} ,0.5);
			     settimer( func { decmu.start.engine(2);} ,15);
				}
		    }
		}
	 },
	 engine: func(c) {
	     var engindex = ( c - 1 );
		 var eng = props.globals.getNode("/controls/engines/engine["~engindex~"]");
		 var cutoff = eng.getNode("cutoff");
		 var starter = eng.getNode("starter");
		 cutoff.setBoolValue(1);
		 starter.setBoolValue(1);
		 settimer( func { cutoff.setBoolValue(0);} ,4);
		}, 
	 
	 apu: func {
	     
		 # Check electric starter has power
		 var volts = props.globals.getNode("/systems/electrical/outputs/APU-starter").getValue();
		 if ( volts > 24 ) {
		     decmu.start.engine(2);
			}
		},

	}
