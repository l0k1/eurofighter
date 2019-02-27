var pitch_prop = props.globals.getNode("orientation/pitch-deg");
var pitch = 0;
var roll_prop = props.globals.getNode("orientation/roll-deg");
var roll = 0;

var update = func() {
    pitch = pitch_prop.getValue();
    roll = roll_prop.getValue();
}
