## CAMU
var rad1tune = func {
   var ind1 = getprop("/systems/CAMU/radio/selected-channel-n");
   var chan1 = ( ind1 - 1 );
   var ident1 = getprop("/systems/CAMU/channel-list/channel["~chan1~"]/identifier");
   var name1 = getprop("/systems/CAMU/channel-list/channel["~chan1~"]/channel-number");
   var freq1 = getprop("/systems/CAMU/channel-list/channel["~chan1~"]/frequency");
   setprop("/instrumentation/comm/frequencies/selected-mhz", freq1);
   setprop("/systems/CAMU/radio[0]/frequency", freq1);
   setprop("/systems/CAMU/radio[0]/channel-number", name1);
   setprop("/systems/CAMU/radio[0]/identifier", ident1);
   };
   
var rad2tune = func {
   var ind2 = getprop("/systems/CAMU/radio[1]/selected-channel-n");
   var chan2 = ( ind2 - 1 );
   var ident2 = getprop("/systems/CAMU/channel-list/channel["~chan2~"]/identifier");
   var name2 = getprop("/systems/CAMU/channel-list/channel["~chan2~"]/channel-number");
   var freq2 = getprop("/systems/CAMU/channel-list/channel["~chan2~"]/frequency");
   setprop("/systems/CAMU/radio[1]/frequency", freq2);
   setprop("/instrumentation/comm[1]/frequencies/selected-mhz", freq2);
   setprop("/systems/CAMU/radio[1]/channel-number", name2);
   setprop("/systems/CAMU/radio[1]/identifier", ident2);
   };
   
var init = func {
   var com1freq = getprop("/instrumentation/comm/frequencies/selected-mhz");
   var com2freq = getprop("/instrumentation/comm[1]/frequencies/selected-mhz");
   setprop("/systems/CAMU/channel-list/channel[8]/frequency", com1freq);
   setprop("/systems/CAMU/channel-list/channel[9]/frequency", com2freq);
   setprop("/systems/CAMU/radio/selected-channel-n", 3);
   setprop("/systems/CAMU/radio[1]/selected-channel-n", 4);
   };

   
setlistener("/systems/CAMU/radio/selected-channel-n", rad1tune);
setlistener("/systems/CAMU/radio[1]/selected-channel-n", rad2tune);
setlistener("/sim/signals/fdm-initialized", init);