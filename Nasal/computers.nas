# Phase of Flight Computer

# Attack Computer

var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

var attack = {
     select: func(n) {
	     var selind = props.globals.getNode("computers/attack/target-selected-index");
         var new = ( selind.getValue() + n );
		 if ( n == 0 ) {
		     selind.setValue(-1);
			}
		 else {
		     if ( props.globals.getNode("ai/models/multiplayer["~new~"]/valid").getBoolValue()) {
		         selind.setValue(new);
			    }
			 else {
			     attack.select(n*2);
				}
		    }
		},
	 lock: func(l) { # Arguments: c - clear, s - selected, or contact number
	     var locked = props.globals.getNode("/computers/attack/target-locked-index");
		 if ( l == "c" ) { locked.setValue(-1); }
		 else if ( l == "s" ) {
			 sel = props.globals.getNode("/computers/attack/target-selected-index").getValue();
		     locked.setValue(sel);
			 }
		 else {
             locked.setValue(l);
            }
		},
	 loop: func {
	     var atk = props.globals.getNode("/computers/attack");
		 var mp = props.globals.getNode("/ai/models");
		 var selind = atk.getNode("target-selected-index").getValue();
		     
		 if ( selind > -1 ) {
		 
		     var mpnode = mp.getNode("multiplayer["~selind~"]");    
			 var valid = mpnode.getNode("valid").getBoolValue();
			 
			 if ( valid ) {
			 
			 var s = selind;
			 var lett = letters[s];
			 var sbearing = mpnode.getNode("radar/bearing-deg").getValue();
			 var srange = mpnode.getNode("radar/range-nm").getValue();
			 var sspeed = mpnode.getNode("velocities/true-airspeed-kt").getValue();
			 var callsign = mpnode.getNode("callsign").getValue();
			 
			 			 
			  	 var contacts = atk.getNode("contacts").getChildren();
			     foreach(z;contacts) {
			         var index = z.getIndex();
				     var locked = z.getNode("locked");
				     var iff = z.getNode("IFF", 1);
				 
				     if ( index == selind ) {
				         locked.setBoolValue(1);
						 atk.getNode("target-label").setValue(lett);
						 if ( iff.getValue() == 1 ) {
						     atk.getNode("target-description").setValue(callsign);
						     }
						 else {
						     atk.getNode("target-description").setValue("NOINFO");
							}
					    }
				     else {
				         locked.setBoolValue(0);
					    }
				    }
						 
			     atk.getNode("target-bearing-deg").setValue(sbearing);
			     atk.getNode("target-distance-nm").setValue(srange);
				 atk.getNode("target-tas-kt").setValue(sspeed);				
				}
				
			 else {
			     atk.getNode("target-bearing-deg").setValue(0);
			     atk.getNode("target-distance-nm").setValue(0);
				 atk.getNode("target-tas-kt").setValue(0);
				 atk.getNode("target-description").setValue("NOINFO");
				}
			}
         else {	
             atk.getNode("target-bearing-deg").setValue(0);
			 atk.getNode("target-distance-nm").setValue(0);
			 atk.getNode("target-tas-kt").setValue(0);
			 atk.getNode("target-description").setValue("NOINFO");	
            }
		},
	 
	};
	
var iff = {
     loop: func {
	     var atk = props.globals.getNode("/computers/attack");
		 var contacts = atk.getNode("contacts").getChildren();
		 foreach(x; contacts) {
		     var status = 0;
			 var i = x.getIndex();
			 var desig = x.getNode("IFF");
			 var squawk = props.globals.getNode("/instrumentation/transponder/id-code").getValue();
			 var mpnode = props.globals.getNode("/ai/models/multiplayer["~i~"]");
			 var codenode = mpnode.getNode("instrumentation/transponder/transmitted-id");
			 if ( codenode != nil ) {
			     var code = codenode.getValue();
				 if ( squawk == code ) { status = 1; }
				}
			 desig.setValue(status);
			} 
	    },
	};

var loop = func {
     iff.loop();
	 attack.loop();
	 settimer(loop,0.5);
	}
	
var init = func {
     print("Initialising Computers");
	 var atk = props.globals.getNode("/computers/attack");
	 var contacts = atk.getNode("contacts").getChildren();
	 foreach(y; contacts) {
	     y.initNode("IFF", 0, "INT");
		 y.initNode("fired", 0, "BOOL");
		 y.initNode("locked", 0, "BOOL");
		}
	 loop();
	}
