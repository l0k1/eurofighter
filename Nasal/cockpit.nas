## Eurofighter Typhoon
## Instrumentation Scripts

props.globals.initNode("/position/altitude-angels", 0, "DOUBLE");

var angels = func {
   var altft = getprop("/position/altitude-ft");
   setprop("/position/altitude-angels", (altft * 0.001) );
   settimer(angels, 0.5);
}

var warn_attention = func {
   setprop("/instrumentation/warnings/attention-lights", 1);
}

var warn_acknowledge = func {
   setprop("/instrumentation/warnings/attention-lights", 0);
}

setlistener("/sim/signals/fdm-initialized", angels);

