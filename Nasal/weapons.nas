print("*** LOADING weapons.nas ... ***");
################################################################################
#
#                        m2005-5's WEAPONS SETTINGS
#
################################################################################

var dt = 0;
var isFiring = 0;
var splashdt = 0;
var MPMessaging = props.globals.getNode("/controls/armament/mp-messaging", 1);

#var trigger = func(b)
#{
#    setprop("/controls/armament/trigger", b);
#    if(getprop ("/gear/gear[2]/position-norm") == 0)
#    {
#        fire_MG(b);
#    }
#}

setlistener("/controls/armament/trigger", func() {
												#print("inside listener");
												if(getprop ("/gear/gear[2]/position-norm") == 0)
													{
														#print("trigger state: " ~ getprop("/controls/armament/trigger"));
														fire_MG(getprop("/controls/armament/trigger"));
													}
												}
);

setlistener("controls/armament/stick-selector", func() { setprop("/controls/armament/gun-trigger",0); } );
												

fire_MG = func(b) {
    if(getprop("controls/armament/stick-selector") == 1){
          setprop("/controls/armament/gun-trigger", b);
    }
    elsif(getprop("/controls/armament/stick-selector") > 1)
    {
        if(b == 1)
        {
			var pylon = getprop("/controls/armament/missile/current-pylon");
			load.dropLoad(pylon);
        }
    }
}

reload_Cannon = func() {
    setprop("/ai/submodels/submodel/count",    150);
    setprop("/ai/submodels/submodel[1]/count", 150);
    setprop("/ai/submodels/submodel[2]/count", 150);
    setprop("/ai/submodels/submodel[3]/count", 150);
}

# This is to detect collision when balistic are shooted.
# The goal is to put an automatic message for gun splash
#var Mp = props.globals.getNode("ai/models");
#var Impact = func() {
#    var splashOn = "Nothing";
#    var numberOfSplash = 0;
#    var raw_list = Mp.getChildren();
#    # Running threw ballistic list
#    foreach(var c ; raw_list)
#    {
#        # FIXED, with janitor. 5H1N0B1
#        var type = c.getName();
#        if(! c.getNode("valid", 1).getValue())
#        {
#            continue;
#        }
#        var HaveImpactNode = c.getNode("impact", 1);
#        # If there is an impact and the impact is terrain then
#        if(type == "ballistic" and HaveImpactNode != nil)
#        {
#            var type = HaveImpactNode.getNode("type", 1);
#            if(type != "terrain")
#            {
#                var elev = HaveImpactNode.getNode("elevation-m", 1).getValue();
#                var lat = HaveImpactNode.getNode("latitude-deg", 1).getValue();
#                var lon = HaveImpactNode.getNode("longitude-deg", 1).getValue();
#                if(lat != nil and lon != nil and elev != nil)
#                {
#                    #print("lat"~ lat~" lon:"~ lon~ "elev:"~ elev);
#                    ballCoord = geo.Coord.new();
#                    ballCoord.set_latlon(lat, lon, elev);
#                    var tempo = findmultiplayer(ballCoord);
#                    if(tempo != "Nothing")
#                    {
#                        splashOn = tempo;
#                        numberOfSplash += 1;
#                    }
#                }
#            }
#        }
#    }
#    var time = getprop("/sim/time/elapsed-sec");
#    if(splashOn != "Nothing" and (time - splashdt) > 1)
#    {
#        var phrase = "Gun Splash On : " ~ splashOn;
#        if(MPMessaging.getValue() == 1)
#        {
#            setprop("/sim/multiplay/chat", phrase);
#        }
#        else
#        {
#            setprop("/sim/messages/atc", phrase);
#        }
#        splashdt = time;
#    }
#}

input = {
  elapsed:          "/sim/time/elapsed-sec",
  impact:           "/ai/models/model-impact",
};

foreach(var name; keys(input)) {
      input[name] = props.globals.getNode(input[name], 1);
}

var last_impact = 0;

var hit_count = 0;

var impact_listener = func {
	var ballistic_name = input.impact.getValue();
	var ballistic = props.globals.getNode(ballistic_name, 0);
	#print(ballistic_name);
	if (ballistic != nil) {
		var typeNode = ballistic.getNode("impact/type");
		if ( typeNode != nil and ballistic != nil and ballistic.getNode("name") != nil ) {
			var typeOrd = ballistic.getNode("name").getValue();
			var lat = ballistic.getNode("impact/latitude-deg").getValue();
			var lon = ballistic.getNode("impact/longitude-deg").getValue();
			var alt = ballistic.getNode("impact/elevation-m").getValue();
			var impactPos = geo.Coord.new().set_latlon(lat, lon, alt);

			#GAU-8/A impact logic

			if ( find("BK27 round 1", typeOrd) != -1 and typeNode.getValue() != "terrain" and (input.elapsed.getValue()-last_impact) > 1) {
				foreach(var mp; props.globals.getNode("/ai/models").getChildren("multiplayer")){
					#print("Gau impact - hit: " ~ typeNode.getValue());
					var mlat = mp.getNode("position/latitude-deg").getValue();
					var mlon = mp.getNode("position/longitude-deg").getValue();
					var malt = mp.getNode("position/altitude-ft").getValue() * FT2M;
					var selectionPos = geo.Coord.new().set_latlon(mlat, mlon, alt);
					var distance = impactPos.distance_to(selectionPos);

					if (distance < 15) {
						last_impact = input.elapsed.getValue();
						typeOrd = "BK27 cannon";
						defeatSpamFilter(typeOrd ~ " hit: " ~  mp.getNode("callsign").getValue());
					}
				}
			}
		}
	}
}

var spams = 0;

var defeatSpamFilter = func (str) {
  spams += 1;
  if (spams == 15) {
    spams = 1;
  }
  str = str~":";
  for (var i = 1; i <= spams; i+=1) {
    str = str~".";
  }
  var myCallsign = getprop("sim/multiplay/callsign");
  if (myCallsign != nil and find(myCallsign, str) != -1) {
      str = myCallsign~": "~str;
  }
  var newList = [str];
  for (var i = 0; i < size(spamList); i += 1) {
    append(newList, spamList[i]);
  }
  spamList = newList;  
}



setlistener("/ai/models/model-impact", impact_listener, 0, 0);

# Nb of impacts
#var Nb_Impact = func() {
#    var mynumber = 0;
#    var raw_list = Mp.getChildren();
#    foreach(var c ; raw_list)
#    {
#        # FIXED, with janitor. 5H1N0B1
#        var type = c.getName();
#        if(! c.getNode("valid", 1).getValue())
#        {
#            continue;
#        }
#        var HaveImpactNode = c.getNode("impact", 1);
#        if(type == "ballistic")
#        {
#            mynumber +=1;
#        }
#    }
#    return mynumber;
#}

# We mesure the minimum distance to all contact. This allow us to deduce who is the MP
#var findmultiplayer = func(targetCoord, dist = 20) {
#    var raw_list = Mp.getChildren();
#    #var dist  = 20;
#    var SelectedMP = "Nothing";
#    foreach(var c ; raw_list)
#    {
#        # FIXED, with janitor. 5H1N0B1
#        var type = c.getName();
#        if(! c.getNode("valid", 1).getValue())
#        {
#            continue;
#        }
#        var HavePosition = c.getNode("position", 1);
#        var name = c.getNode("callsign", 1);
#        
#        if((type == "multiplayer" or type == "tanker" or type == "aircraft") and HavePosition != nil and targetCoord != nil and name != nil)
#        {
#            var elev = HavePosition.getNode("altitude-m", 1).getValue();
#            var lat = HavePosition.getNode("latitude-deg", 1).getValue();
#            var lon = HavePosition.getNode("longitude-deg", 1).getValue();
#            
#            elev = (elev == nil) ? HavePosition.getNode("altitude-ft", 1).getValue() * FT2M : elev;
#            
#            #print("name:"~name.getValue());
#            #print("lat"~ lat.getValue()~" lon:"~ lon.getValue()~ "elev:"~ elev.getValue());
#            
#            MpCoord = geo.Coord.new();
#            MpCoord.set_latlon(lat, lon, elev);
#            var tempoDist = MpCoord.direct_distance_to(targetCoord);
#            #print("TempoDist:"~tempoDist);
#            if(dist > tempoDist)
#            {
#                dist = tempoDist;
#                SelectedMP = name.getValue();
#                #print("That worked");
#            }
#        }
#    }
#    #print("Splash on : Callsign:"~SelectedMP);
#    return SelectedMP;
#}
