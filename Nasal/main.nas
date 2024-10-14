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

var stores = {
	"Empty": 0,
	"1000L Drop Tank": 1,
	"1500L Drop Tank": 2,
};

var mp_assign = func(pylon) {
	#print("mp_assign fired!");
	var name = getprop("/payload/weight["~pylon~"]/selected");
	#print(name);
	if ( name != nil ) {
		if (contains(stores,name)) {
			#print("Setting " ~ name ~ " to " ~ pylon);
			setprop("/sim/multiplay/generic/short["~pylon~"]",stores[name]);
		}
	}
}
var fuel_loop = func() {
	#taken from av-8b, need to modify
	#if ( getprop("/payload/weight[1]/selected") != "Left Middle Drop Tank" ) {
	#	setprop("/consumables/fuel/tank[8]/level-gal_us",0);
	#}
	#if ( getprop("/payload/weight[2]/selected") != "Left Inside Drop Tank" ) {
	#	setprop("/consumables/fuel/tank[9]/level-gal_us",0);
	#}
	#if ( getprop("/payload/weight[4]/selected") != "Right Inside Drop Tank" ) {
	#	setprop("/consumables/fuel/tank[10]/level-gal_us",0);
	#}
	#if ( getprop("/payload/weight[5]/selected") != "Right Middle Drop Tank" ) {
	#	setprop("/consumables/fuel/tank[11]/level-gal_us",0);
	#}
	#settimer(func(){fuel_loop();},1);
}

var _init = func() {
	pylons.init();
	#fuel_loop();
	#print("initting");
	setlistener("/payload/weight[0]/selected",func(){mp_assign(0)});
	setlistener("/payload/weight[1]/selected",func(){mp_assign(1)});
	setlistener("/payload/weight[2]/selected",func(){mp_assign(2)});
	setlistener("/payload/weight[3]/selected",func(){mp_assign(3)});
	setlistener("/payload/weight[4]/selected",func(){mp_assign(4)});
	setlistener("/payload/weight[5]/selected",func(){mp_assign(5)});
	setlistener("/payload/weight[6]/selected",func(){mp_assign(6)});
	setlistener("/payload/weight[7]/selected",func(){mp_assign(7)});
	setlistener("/payload/weight[8]/selected",func(){mp_assign(8)});
	setlistener("/payload/weight[8]/selected",func(){mp_assign(9)});
	setlistener("/payload/weight[8]/selected",func(){mp_assign(10)});
	setlistener("/payload/weight[8]/selected",func(){mp_assign(11)});
	setlistener("/payload/weight[8]/selected",func(){mp_assign(12)});
}
 _init();