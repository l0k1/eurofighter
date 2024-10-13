# Properties under /consumables/fuel/tank[n]:
# + level-gal_us    - Current fuel load.  Can be set by user code.
# + level-lbs       - OUTPUT ONLY property, do not try to set
# + selected        - boolean indicating tank selection.
# + density-ppg     - Fuel density, in lbs/gallon.
# + capacity-gal_us - Tank capacity
#
# Properties under /engines/engine[n]:
# + fuel-consumed-lbs - Output from the FDM, zeroed by this script
# + out-of-fuel       - boolean, set by this code.


var UPDATE_PERIOD = 0.3;

var enabled = nil;
var serviceable = nil;
var fuel_freeze = nil;
var ai_enabled = nil;
var engines = nil;
var tanks = [];
var refuelingN = nil;
var contactN = nil;
var aimodelsN = nil;
var contactJSB = nil;
var types = {};



var update_loop = func {
	# check for contact with tanker aircraft
	var tankers = [];
	if (ai_enabled) {
		var ac = aimodelsN.getChildren("tanker");
		var mp = aimodelsN.getChildren("multiplayer");

		foreach (var a; ac ~ mp) {
			if (!a.getNode("valid", 1).getValue())
				continue;
			if (!a.getNode("tanker", 1).getValue())
				continue;
			if (!a.getNode("refuel/contact", 1).getValue())
				continue;
			foreach (var t; a.getNode("refuel", 1).getChildren("type")) {
				var type = t.getValue();
				if (contains(types, type) and types[type])
					append(tankers, a);
			}
		}
	}

	var refueling = serviceable and size(tankers) > 0;
	
	if (refuelingN.getNode("report-contact", 1).getValue()) {
	  if (refueling and !contactN.getValue()) {
			setprop("/sim/messages/copilot", "Engaged");
	  }
	  
	  if (!refueling and contactN.getValue()) {
			setprop("/sim/messages/copilot", "Disengaged");
	  }
	}
	
	contactN.setBoolValue(refueling);
	contactJSB.setBoolValue(refueling);

	if (fuel_freeze)
		return settimer(update_loop, UPDATE_PERIOD);

	# calculate fuel received
	if (refueling) {
		# Flow rate is the minimum of the tanker maxium rate
		# and the aircraft maximum rate.  Both are expressed
		# in lbs/min
		var fuel_rate = math.min(tankers[0].getNode("refuel/max-fuel-transfer-lbs-min", 1).getValue() or 6000, 
		                         refuelingN.getNode("max-fuel-transfer-lbs-min", 1).getValue() or 6000);
		var received =  UPDATE_PERIOD * fuel_rate / 60;
		setprop("fdm/jsbsim/systems/fuel/refuel-rate",received);
	}

	settimer(update_loop, UPDATE_PERIOD);
}



setlistener("/sim/signals/fdm-initialized", func {
	if (contains(globals, "fuel") and typeof(fuel) == "hash")
		fuel.loop = func nil;       # kill $FG_ROOT/Nasal/fuel.nas' loop

	contactN = props.globals.initNode("/systems/refuel/contact", 0, "BOOL");
	contactJSB = props.globals.initNode("/fdm/jsbsim/systems/fuel/refuel-contact");
	refuelingN = props.globals.getNode("/systems/refuel", 1);
	aimodelsN = props.globals.getNode("ai/models", 1);

	foreach (var t; props.globals.getNode("systems/refuel", 1).getChildren("type"))
		types[t.getValue()] = 1;

	setlistener("sim/ai/enabled", func(n) ai_enabled = n.getBoolValue(), 1);
	setlistener("systems/refuel/serviceable", func(n) serviceable = n.getBoolValue(), 1);
	update_loop();
});


