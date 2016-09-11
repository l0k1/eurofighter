##
# NATO Mk XII IFF Transponder

var init = func {
   props.globals.initNode("/instrumentation/transponder/standby", 0, "BOOL");
   props.globals.initNode("/instrumentation/transponder/id-code", "0000", "STRING");
   props.globals.initNode("/instrumentation/transponder/iff-code", "", "STRING");
   xmit();
   }

var xmit = func { 
#  var power = getprop("/systems/electrical/outputs/transponder");
   var standby = getprop("/instrumentation/transponder/standby");
   var id_code = getprop("/instrumentation/transponder/id-code");
   var iff_code = getprop("/instrumentation/transponder/iff-code");
   var altitude = getprop("/position/altitude-ft");
   if ( standby == 1 ) {
      setprop("/sim/multiplay/generic/string[14]", "");
      setprop("/sim/multiplay/generic/string[15]", "");
	  setprop("/sim/multiplay/generic/string[16]", "");
   }
   else {
      setprop("/sim/multiplay/generic/string[14]", id_code);
      setprop("/sim/multiplay/generic/string[15]", iff_code);
	  setprop("/sim/multiplay/generic/string[16]", altitude);
   }
   setprop("/instrumentation/transponder/flight-level", altitude);
   settimer(xmit, 2);
}

var modeC = func() {

        if (getprop("/instrumentation/transponder/switch/on")==1 ){
        if (getprop("/instrumentation/transponder/modes/mode-C/standby")==0 ){
                setprop("/instrumentation/transponder/modes/mode-3A/standby",1);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'ALTITUDE');
				setprop("/instrumentation/transponder/inputs/knob-mode",5);    
        }
		   else {
                setprop("/instrumentation/transponder/modes/mode-C/standby",1);
                setprop("/instrumentation/transponder/modes/mode-3A/standby",0);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'ON');
				setprop("/instrumentation/transponder/inputs/knob-mode",4);    
	   }
	   }

}

var mode3A = func() {

        if (getprop("/instrumentation/transponder/switch/on")==1 ){
        if (getprop("/instrumentation/transponder/modes/mode-C/standby")==0 ){
                setprop("/instrumentation/transponder/modes/mode-C/standby",1);
                setprop("/instrumentation/transponder/modes/mode-3A/standby",0);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'ON');
				setprop("/instrumentation/transponder/inputs/knob-mode",4);    
        }
	   }
}

var xponderoff = func() {

        if (getprop("/instrumentation/transponder/switch/off")==1 ){
                setprop("/instrumentation/transponder/switch/stby",0);
                setprop("/instrumentation/transponder/switch/on",0);
                setprop("/instrumentation/transponder/modes/mode-1/standby",1);
                setprop("/instrumentation/transponder/modes/mode-2/standby",1);
                setprop("/instrumentation/transponder/modes/mode-3A/standby",1);
                setprop("/instrumentation/transponder/modes/mode-C/standby",1);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'OFF');
				setprop("/instrumentation/transponder/inputs/knob-mode",0);    
        }
}

var xponderstby = func() {

        if (getprop("/instrumentation/transponder/switch/stby")==1 ){
                setprop("/instrumentation/transponder/switch/off",0);
                setprop("/instrumentation/transponder/switch/on",0);
                setprop("/instrumentation/transponder/modes/mode-1/standby",0);
                setprop("/instrumentation/transponder/modes/mode-2/standby",0);
                setprop("/instrumentation/transponder/modes/mode-3A/standby",1);
                setprop("/instrumentation/transponder/modes/mode-C/standby",1);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'STANDBY');
				setprop("/instrumentation/transponder/inputs/knob-mode",1);    
        }
}

var xponderon = func() {

        if (getprop("/instrumentation/transponder/switch/on")==1 ){
                setprop("/instrumentation/transponder/switch/stby",0);
                setprop("/instrumentation/transponder/switch/off",0);
                setprop("/instrumentation/transponder/modes/mode-1/standby",0);
                setprop("/instrumentation/transponder/modes/mode-2/standby",0);
                setprop("/instrumentation/transponder/modes/mode-3A/standby",0);
                setprop("/instrumentation/transponder/modes/mode-C/standby",1);
                setprop("/sim/gui/dialogs/radios/transponder-mode",'ON');
				setprop("/instrumentation/transponder/inputs/knob-mode",4);    
        }
}

setlistener("/sim/signals/fdm-initialized", init);