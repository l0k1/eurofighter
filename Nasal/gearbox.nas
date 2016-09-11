### Eurofighter Typhoon: Accessory Gearbox

## Initialise Properties
props.globals.initNode("gearbox/main-shaft", 0, "DOUBLE");
props.globals.initNode("gearbox/turbine-shaft", 0, "DOUBLE");
props.globals.initNode("gearbox/APU-shaft", 0, "DOUBLE");
props.globals.initNode("gearbox/DRS-shaft", 0, "DOUBLE");

## Gears Rotation
var maingears = func {
   var eng0shaft = getprop("/engines/engine[0]/n2");
   var eng1shaft = getprop("/engines/engine[1]/n2");
   var apushaft = getprop("/engines/engine[2]/n2");
   var turbshaft = ( ( eng0shaft + eng1shaft ) / 2 );
   if ( turbshaft < 23 )  {
      turbshaft = mainshaft;
	  setprop("engines/engine[0]/n2", turbshaft);
	  setprop("engines/engine[1]/n2", turbshaft);
	  }
   else {
      mainshaft = turbshaft;
	  }
   setprop("gearbox/main-shaft", mainshaft);
   setprop("gearbox/turbine-shaft", turbshaft);
   setprop("gearbox/APU-shaft", apushaft);
   setprop("gearbox/DRS-shaft", ( mainshaft * 26 ) );
   }
  
settimer(maingears,0.25);
