beacon_switch = props.globals.getNode("controls/switches/beacons", 2);
var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0, 3], "/controls/lighting/beacon" );
strobe_switch = props.globals.getNode("controls/switches/strobe-lights", 2);
var strobe = aircraft.light.new( "/sim/model/lights/strobe", [0, 3], "/controls/lighting/strobe" );

# Control both panel and instrument light intensity with one property
var instrumentsNorm = props.globals.getNode("controls/lighting/instruments-norm", 1);
var instrumentLightFactor = props.globals.getNode("sim/model/material/instruments/factor", 1);
var panelLights = props.globals.getNode("controls/lighting/panel-norm", 1);

var update_intensity = func {
    instrumentLightFactor.setDoubleValue(instrumentsNorm.getValue());
    panelLights.setDoubleValue(instrumentsNorm.getValue());

   settimer(update_intensity, 0.1);
}

# Setup listener call to start update loop once the fdm is initialized,
# but only start the update loop _once_.
var fdm_init_listener = setlistener("sim/signals/fdm-initialized", func {
    removelistener(fdm_init_listener);
    update_intensity();
});
