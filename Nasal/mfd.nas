# Here goes
      props.globals.initNode("/instrumentation/MFD/situana/contacts/multiplayer[0]/x-shift",0, "DOUBLE");
      props.globals.initNode("/instrumentation/MFD/situana/contacts/multiplayer[0]/y-shift",0, "DOUBLE");

var contact_pos = func {
  foreach (var ai_aircraft; props.globals.getNode("/ai/models").getChildren("aircraft")) {
     var n = ai_aircraft.getIndex();
	 var xshift = getprop("/ai/models/aircraft[" ~ n ~"]/radar/x-shift");
	 var yshift = getprop("/ai/models/aircraft["~ n ~ "]/radar/y-shift");
	 var factor = getprop("/instrumentation/MFD/situana/grid-scale");
	 
	 var xsout = ( xshift * factor );
	 if (xsout == nil) {xsout = 0;}
	 var ysout = ( yshift * factor);
	 if (ysout == nil) {ysout = 0;}
	 setprop("/instrumentation/MFD/situana/contacts/multiplayer["~n~"]/x-shift", xsout);
	 setprop("/instrumentation/MFD/situana/contacts/multiplayer["~n~"]/y-shift", ysout);
   }
   settimer(contact_pos, 1);
}

setlistener("/sim/signals/fdm-initialized", contact_pos);