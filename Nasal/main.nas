# main controller file w/ centralized looping

var update_rate = 0.05;
var update_idx = 0;

var main_loop = func() {
    prop_io.update();
    hud.hud_ref.update();
}

var init = setlistener("/sim/signals/fdm-initialized", func() {
    removelistener(init); # only call once
    maketimer(update_rate, main_loop).start();
});