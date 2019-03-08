var pitch_prop = props.globals.getNode("orientation/pitch-deg");
var pitch = 0;
var roll_prop = props.globals.getNode("orientation/roll-deg");
var roll = 0;
var heading_prop = props.globals.getNode("orientation/heading-deg");
var heading = 0;
var altitude_prop = props.globals.getNode("position/altitude-ft");
var altitude = 0;
var airspeed_prop = props.globals.getNode("velocities/airspeed-kt");
var airspeed = 0;

var update = func() {
    pitch = pitch_prop.getValue();
    roll = roll_prop.getValue();
    heading = heading_prop.getValue();
    altitude = altitude_prop.getValue();
    airspeed = airspeed_prop.getValue();
}
