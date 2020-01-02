# i am convinced there is a more elegant way to do this, but im not sure how
# without having to access a hash. idk. thisll work for now.


#################################### non-instrumentation orientation props
var pitch_prop = props.globals.getNode("orientation/pitch-deg");
var pitch = 0;
var alpha_prop = props.globals.getNode("orientation/alpha-deg");
var alpha = 0;
var roll_prop = props.globals.getNode("orientation/roll-deg");
var roll = 0;
var roll_rad = 0;
var heading_prop = props.globals.getNode("orientation/heading-deg");
var heading = 0;
var altitude_prop = props.globals.getNode("position/altitude-ft");
var altitude = 0;
var airspeed_prop = props.globals.getNode("velocities/airspeed-kt");
var airspeed = 0;
var mach_prop = props.globals.getNode("velocities/mach");
var mach = 0;
var groundspeed_prop = props.globals.getNode("velocities/groundspeed-kt");
var groundspeed = 0;

#################################### instrumentation props
var normalg_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/normal-g");
var normalg = 0;
var vspeed_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/velocities/vertical_speed_fps");
var vspeed = 0;

var engine0_n1_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[0]/n1");
var engine0_n1 = 0;
var engine0_n2_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[0]/n2");
var engine0_n2 = 0;
var engine0_tat_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[0]/tat");
var engine0_tat = 0;
var engine0_nz_prop = props.globals.getNode("engines/engine[0]/nozzle-pos-norm", 1);
var engine0_nz = 0;

var engine1_n1_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[1]/n1");
var engine1_n1 = 0;
var engine1_n2_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[1]/n2");
var engine1_n2 = 0;
var engine1_tat_prop = props.globals.getNode("fdm/jsbsim/systems/flightcomputer/engine[1]/tat");
var engine1_tat = 0;
var engine1_nz_prop = props.globals.getNode("engines/engine[1]/nozzle-pos-norm", 1);
var engine1_nz = 0;


#################################### landing gear props
var geardown_prop = props.globals.getNode("/controls/gear/gear-down");
var geardown = 0;
var gear0wow_prop = props.globals.getNode("/gear/gear[0]/wow");
var gear0wow = 0;
var gear1wow_prop = props.globals.getNode("/gear/gear[1]/wow");
var gear1wow = 0;
var gear2wow_prop = props.globals.getNode("/gear/gear[2]/wow");
var gear2wow = 0;

#################################### electric output props
var hud_power_prop = props.globals.getNode("fdm/jsbsim/systems/electric/xp2/hud");
var hud_power = 0;

var update = func() {
    #################################### non-instrumentation orientation props
    pitch = pitch_prop.getValue();
    alpha = alpha_prop.getValue();
    roll = roll_prop.getValue();
    roll_rad = roll * D2R;
    heading = heading_prop.getValue();
    altitude = altitude_prop.getValue();
    airspeed = airspeed_prop.getValue();
    mach = mach_prop.getValue();
    groundspeed = groundspeed_prop.getValue();
    
    #################################### instrumentation props
    normalg = normalg_prop.getValue();
    vspeed = vspeed_prop.getValue();
    engine0_n1 = engine0_n1_prop.getValue();
    engine0_n2 = engine0_n2_prop.getValue();
    engine0_tat = engine0_tat_prop.getValue();
    engine0_nz = engine0_nz_prop.getValue();
    engine1_n1 = engine1_n1_prop.getValue();
    engine1_n2 = engine1_n2_prop.getValue();
    engine1_tat = engine1_tat_prop.getValue();
    engine1_nz = engine1_nz_prop.getValue();
    
    #################################### electric output props
    hud_power = hud_power_prop.getValue();
}

# functions for listeners

var main_gear_down_listener = func() {
    geardown = geardown_prop.getValue();
    gear0wow = gear0wow_prop.getValue();
    gear1wow = gear1wow_prop.getValue();
    gear2wow = gear2wow_prop.getValue();
}