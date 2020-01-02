# main controller file w/ centralized looping

var update_rate = 0.05;
var update_idx = 0;

var main_loop = func() {
    prop_io.update();
    hud.hud_ref.main_loop();

	mfd.mfd_left.main_loop();
	mfd.mfd_center.main_loop();
	mfd.mfd_right.main_loop();
}


var timer = maketimer(update_rate, main_loop);
var init = setlistener("/sim/signals/fdm-initialized", func() {
    removelistener(init); # only call once
	timer.start();
});

# Prevent a JSB bug
setlistener("/controls/gear/gear-down", func {
	prop_io.main_gear_down_listener();
	if (!prop_io.geardown and (prop_io.gear0wow or prop_io.gear1wow or prop_io.gear2wow)) {
		prop_io.geardown_prop.setValue(1);
	}
});