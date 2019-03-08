# main controller file w/ centralized looping

var update_rate = 0.05;
var update_idx = 0;

var main_loop = func() {
    prop_io.update();
    hud.hud_ref.update();
}

var timer = maketimer(update_rate, main_loop);
timer.start();

var init = setlistener("/sim/signals/fdm-initialized", func() {
    removelistener(init); # only call once
});

# Prevent a JSB bug
var down = 1;
setlistener("/controls/gear/gear-down", func {
	down = getprop("/controls/gear/gear-down");
	if (!down and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		setprop("/controls/gear/gear-down", 1);
	}
});