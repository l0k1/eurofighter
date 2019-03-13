# i am convinced there is a more elegant way to do this, but im not sure how
# without having to access a hash. idk. thisll work for now.


#################################### non-instrumentation orientation props
var pitch_prop = props.globals.getNode("orientation/pitch-deg");
var pitch = 0;
var alpha_prop = props.globals.getNode("orientation/alpha-deg");
var alpha = 0;
var roll_prop = props.globals.getNode("orientation/roll-deg");
var roll = 0;
var heading_prop = props.globals.getNode("orientation/heading-deg");
var heading = 0;
var altitude_prop = props.globals.getNode("position/altitude-ft");
var altitude = 0;
var airspeed_prop = props.globals.getNode("velocities/airspeed-kt");
var airspeed = 0;

#################################### electric output props
var hud_power_prop = props.globals.getNode("fdm/jsbsim/systems/electric/distribution/hud");
var hud_power = 0;

var update = func() {
    #################################### non-instrumentation orientation props
    pitch = pitch_prop.getValue();
    alpha = alpha_prop.getValue();
    roll = roll_prop.getValue();
    heading = heading_prop.getValue();
    altitude = altitude_prop.getValue();
    airspeed = airspeed_prop.getValue();
    
    #################################### electric output props
    hud_power = hud_power_prop.getValue();
}
