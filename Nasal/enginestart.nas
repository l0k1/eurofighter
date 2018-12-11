var bleed_air = 0;
var startprop0 = props.globals.getNode("/controls/engines/engine[0]/starter");
var startprop1 = props.globals.getNode("/controls/engines/engine[1]/starter");
var cutoffprop0 = props.globals.getNode("/controls/engines/engine[0]/cutoff");
var cutoffprop1 = props.globals.getNode("/controls/engines/engine[1]/cutoff");
var runningprop0 = props.globals.getNode("/engines/engine[0]/running");
var runningprop1 = props.globals.getNode("/engines/engine[1]/running");
var electricprop = props.globals.getNode("/systems/electric/sources/output-norm");

var engine0n1 = props.globals.getNode("/engines/engine[0]/n1");
var engine1n1 = props.globals.getNode("/engines/engine[1]/n1");
var apuspin = props.globals.getNode("/fdm/jsbsim/systems/apu/spinrate"); # norm'd to 0-1
var ext_con = props.globals.getNode("/fdm/jsbsim/systems/electric/sources/ext-power-connected");

var state = 0;

var engine_startup = func() {
	
	if (runningprop0.getValue() and runningprop1.getValue()) {
		state = 0;
		return 1;
	}
	
	if (engine0n1.getValue() == 0 and engine1n1.getValue() == 0 and apuspin.getValue() == 0 and ext_con.getValue() == 0) {
		return 2;
	}
	
	if (electricprop.getValue() < 0.5) {
		return 3;
	}
	
	if (state == 0 and runningprop0.getValue() == 0) {
		state = 1;
		startprop0.setValue(1);
		if (engine0n1.getValue == 0) {
			cutoffprop0.setValue(1);
			settimer(func(){cutoffprop0.setValue(0);},0.2);
		}
	} elsif (state > 0 and runningprop0.getValue() and startprop0.getValue()) {
		startprop0.setValue(0);
	}
	if ((state > 0 and engine0n1.getValue > 15) or (state == 0 and not runningprop1.getValue()) {
		state = 1;
		startprop1.setValue(1);
		if (engine1n1.getValue == 0) {
			cutoffprop1.setValue(1);
			settimer(func(){cutoffprop1.setValue(0);},0.2);
		}
	} elsif (state > 0 and runningprop1.getValue() and startprop1.getValue()) {
		startprop1.setValue(0);
		state = 0;
	}
	settimer(func(){engine_startup();},0.2);
}
	