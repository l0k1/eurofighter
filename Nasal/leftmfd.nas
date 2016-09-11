#scripts left-mfd
var UPDATE_PERIOD = 0.05;
var main_loop_launched = 0; # Used to avoid to start the main loop twice.

########### TACAN SWAP  ####################
var frequ_swap=func(){
          var stb = "";
          var sel = "";

            var swp=func{            
            var stb_x = getprop(stb);            
            setprop(stb,getprop(sel));
            setprop(sel,stb_x);            
            } 

          var swp_tacan=func{
            var stb_x = getprop(stb);           
            setprop(stb,getprop(sel));
            setprop(sel,stb_x);
            stb="instrumentation/tacan/frequencies/stby-can2";              
            sel="instrumentation/tacan/frequencies/selected-channel[4]";
            var stb_y = getprop(stb);            
            setprop(stb,getprop(sel));
            setprop(sel,stb_y);            
            }           

              stb="instrumentation/tacan/frequencies/stby-can";              
              sel="instrumentation/tacan/frequencies/selected-channel";             
              swp_tacan(); 
        
}

########### TACAN UPDATE  ####################
var nav2_back = 0;

var Tc                = props.globals.getNode("instrumentation/tacan");
var Vtc               = props.globals.getNode("instrumentation/nav[2]");
var Enav              = props.globals.getNode("sim/model/eurofighter/instrumentation/enav[0]", 1);
var TcFreqs           = Tc.getNode("frequencies");
var TcTrueHdg         = Tc.getNode("indicated-bearing-true-deg");
var TcMagHdg          = Tc.getNode("indicated-mag-bearing-deg", 1);
var TcIdent           = Tc.getNode("ident");
var TcServ            = Tc.getNode("serviceable");
var TcXY              = Tc.getNode("frequencies/selected-channel[4]");
var VtcIdent          = Vtc.getNode("nav-id");
var VtcFromFlag       = Vtc.getNode("from-flag");
var VtcToFlag         = Vtc.getNode("to-flag");
var VtcHdgDeflection  = Vtc.getNode("heading-needle-deflection");
var VtcRadialDeg      = Vtc.getNode("radials/selected-deg");
var EnavFromFlag      = Enav.getNode("from-flag", 1);
var EnavToFlag        = Enav.getNode("to-flag", 1);
var EnavCdiDeflection = Enav.getNode("needle-deflection", 1);
var TcModeSwitch      = props.globals.getNode("sim/model/eurofighter/instrumentation/tacan/mode", 1);
var TrueHdg           = props.globals.getNode("orientation/heading-deg");
var MagHdg            = props.globals.getNode("orientation/heading-magnetic-deg");
var MagDev            = props.globals.getNode("orientation/local-mag-dev", 1);
var NAVprop			  ="autopilot/settings/nav-source";
var NAVSRC			  = getprop(NAVprop);

var mag_dev = 0;
var tc_mode = 0;
var tcn_bearing = 0;

aircraft.data.add(VtcRadialDeg, TcModeSwitch);

# Compute local magnetic deviation.
var local_mag_deviation = func {
	var true = TrueHdg.getValue();
	var mag = MagHdg.getValue();
	mag_dev = geo.normdeg( mag - true );
	if ( mag_dev > 180 ) mag_dev -= 360;
	MagDev.setValue(mag_dev); 
}

# Set nav[2] so we can use radials from a TACAN station.
	var nav2_freq_update = func {
	var tc_mode = TcModeSwitch.getValue();
	if ( tc_mode != 0 ) {
		var tacan_freq = getprop( "instrumentation/tacan/frequencies/selected-mhz" );
		var nav2_freq = getprop( "instrumentation/nav[2]/frequencies/selected-mhz" );
		var nav2_back = nav2_freq;
		setprop("instrumentation/nav[2]/frequencies/selected-mhz", tacan_freq);
	} else {
		setprop("instrumentation/nav[2]/frequencies/selected-mhz", nav2_back);
	}
}

var tacan_update = func {
	var tc_mode = TcModeSwitch.getValue();
	if ( tc_mode != 0 ) {

		# Get magnetic tacan bearing.
		var true_bearing = TcTrueHdg.getValue();
		var mag_bearing = geo.normdeg( true_bearing + mag_dev );
		if ( true_bearing != 0 ) {
			TcMagHdg.setDoubleValue( mag_bearing );
		} else {
			TcMagHdg.setDoubleValue(0);
		}

		# Get TACAN radials on HSD's Course Deviation Indicator.
		# CDI works with ils OR tacan OR vortac (which freq is tuned from the tacan panel).
		var tcnid = TcIdent.getValue();
		var vtcid = VtcIdent.getValue();
		if ( tcnid == vtcid ) {
			# We have a VORTAC.
			EnavFromFlag.setBoolValue(VtcFromFlag.getBoolValue());
			EnavToFlag.setBoolValue(VtcToFlag.getBoolValue());
 			EnavCdiDeflection.setValue(VtcHdgDeflection.getValue());
		} else {
			# We have a legacy TACAN.
			var tcn_toflag = 1;
			var tcn_fromflag = 0;
			var tcn_bearing = TcMagHdg.getValue();
			var radial = VtcRadialDeg.getValue();
			var d = tcn_bearing - radial;
			if ( d > 180 ) { d -= 360 } elsif ( d < -180 ) { d += 360 }
			if ( d > 90 ) {
				d -= 180;
				tcn_toflag = 0;
				tcn_fromflag = 1;
			} elsif ( d < - 90 ) {
				d += 180;
				tcn_toflag = 0;
				tcn_fromflag = 1;
			}
			if ( d > 30 ) d = 30 ;
			if ( d < -30 ) d = -30 ;
 			EnavCdiDeflection.setValue(d);
			EnavFromFlag.setBoolValue(tcn_fromflag);
			EnavToFlag.setBoolValue(tcn_toflag);
			}

 		} else {
 		TcMagHdg.setDoubleValue(0);
 	}

}

# Main loop ###############
var cnt = 0;

var main_loop = func {
	cnt += 1;
	var a = cnt / 2;

	if ( ( a ) == int( a )) {
		# done each 0.1 sec, cnt even.
		tacan_update();
 			if ( cnt == 12 ) {
				# done each 0.6 sec.
 				local_mag_deviation();
 				nav2_freq_update();
 				cnt = 0;
 			}
		}
	settimer(main_loop, UPDATE_PERIOD);
}

# Init ####################
 var init = func {
 	aircraft.data.load();
 	local_mag_deviation();
	# properties to be stored
 	foreach (var f_tc; TcFreqs.getChildren()) {
 		aircraft.data.add(f_tc);
 	}
	# launch
 	if ( ! main_loop_launched ) {
 		settimer(main_loop, 0.5);
 		main_loop_launched = 1;
 	}
 }

setlistener("sim/signals/fdm-initialized", init);
