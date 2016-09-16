#This code is haow to make generic the missile use

var Loading_missile = func(name) {
var address           = "test";
    var NoSmoke           = "test2";
    var Explosion         = "/Aircraft/Mirage-2000/Missiles/MatraMica/explosion.xml";
    var maxdetectionrngnm = 0;
    var fovdeg            = 0;
    var detectionfovdeg   = 0;
    var trackmaxdeg       = 0;
    var maxg              = 0;
    var thrustlbs1        = 0;#stage 1
    var thrustlbs2        = 0;#stage 2
    var thrust1durationsec= 0;
    var thrust2durationsec= 0;
    var weightlaunchlbs   = 0;
    var dragcoeff         = 0;
    var dragarea          = 0;
    var maxExplosionRange = 0;
    var maxspeed          = 0;
    var life              = 0;
    var fox               = "nothing";
    var rail              = "true";
    var cruisealt         = 0;
    var min_guiding_speed_mach   = 0.8;
    var seeker_angular_speed_dps = 30;   # you want this (much) higher for your modern missiles
    var arming_time_sec          = 1.2;  
    var guidance          = "radar";
    var railLength        = 2.667;
    var railForward       = 1;
	var weightwarheadlbs  = 10;

	if(name =="Matra MICA"){
		#MICA max range 80 km for actual version. ->43 nm.. at mach 4 it's about 59 sec. I put a life of 120, and thurst duration to 3/4 the travel time, and have vectorial thurst (So 27 G more than a similar missile wich have not vectorial thrust)

		address="Aircraft/eurofighter/Stores/MatraMica/MatraMica_smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/MatraMica/MatraMica.xml";
		Explosion="Aircraft/eurofighter/Stores/MatraMica/explosion.xml";
		#

		maxdetectionrngnm = 45;                      #  Not real Impact yet
        fovdeg = 30;                                 # seeker optical FOV
        detectionfovdeg = 180;                       # Search pattern diameter (rosette scan)
        trackmaxdeg = 135;                           # Seeker max total angular rotation
        maxg = 50;                                   # In turn
		arming_time_sec = 1.6;
        thrustlbs1 = 4500;
        thrustlbs2 = 1500;
        thrust1durationsec = 8;
        thrust2durationsec = 28;
        weightlaunchlbs = 216;
        weightwarheadlbs = 30;
        seeker_angular_speed_dps = 60;
        dragcoeff = 0.5;                           # guess; original 0.05
        dragarea = 0.30;                            # sq ft
        maxExplosionRange = 65;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 4;                                # In Mach
        life = 100;
        fox = "Fox 3";
        rail = "true";
        cruisealt = 0;

	}elsif(name =="AIM120"){
		#AIM 120 max range 72 km for actual version. ->39 nm.. at mach 4 it's about 53 sec. I put a life of 115, and thurst duration oo 3/4 the travel time.
		address="Aircraft/eurofighter/Stores/AIM-120/AIM-120_smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/AIM-120/AIM-120.xml";
		#
		maxdetectionrngnm = 38.8;                     # Not real Impact yet A little more than the MICA
        fovdeg = 30;                                  # seeker optical FOV
        detectionfovdeg = 180;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 135;                            # Seeker max total angular rotation
        weightlaunchlbs = 291;
        weightwarheadlbs = 44;
        maxExplosionRange = 65;                       # in meter !!Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 4;                                 # In Mach
        life = 90;
        fox = "Fox 3";
        rail = "false";
        cruisealt = 36000;
        maxg = 30;
        min_guiding_speed_mach = 0.9;
        arming_time_sec = 1.6;
        seeker_angular_speed_dps = 30;
        thrustlbs1 = 4500;
        thrustlbs2 = 1500;
        thrust1durationsec = 8;
        thrust2durationsec = 24;
        dragcoeff = 0.50;
        dragarea = 0.2739;

	}elsif(name =="AIM9"){
		#aim-9 max range 18 km for actual version. ->9 nm.. at mach 2.5 it's about 21 sec. I put a life of 40, and thurst duration to 3/4 the travel time.
		address="Aircraft/eurofighter/Stores/aim-9/aim-9_smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/aim-9/aim-9.xml";
		#
        maxdetectionrngnm = 9;                        # Not real Impact yet
        fovdeg = 27;                                  # seeker optical FOV
        detectionfovdeg = 180;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 134;                            # Seeker max total angular rotation
        weightlaunchlbs = 191;
        weightwarheadlbs = 20.8;
        maxExplosionRange = 65;                       # Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 2.5;                               # In Mach
        life = 50;
        fox = "Fox 2";
        rail = "false";
        cruisealt = 0;
        maxg = 32;
        min_guiding_speed_mach = 0.8;
        arming_time_sec = 1.4;
        seeker_angular_speed_dps = 30;
        thrustlbs1 = 2660;
        thrustlbs2 = 0;
        thrust1durationsec = 5.23;
        thrust2durationsec = 0;
        dragcoeff = 0.50;
        dragarea = 0.143;
        guidance = "heat";

	}elsif(name =="AIM132"){
		#aim-132 max range 28 km for actual version. ->
		#sources say max range 50km with top speed of m3+
		address="Aircraft/eurofighter/Stores/aim132/AIM132-smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/aim132/AIM132.xml";
		#
		maxdetectionrngnm = 21;                         #<!-- Not real Impact yet-->
		fovdeg = 25;                                   #<!-- seeker optical FOV -->
		detectionfovdeg=180;                              # <!-- Search pattern diameter (rosette scan) -->
		trackmaxdeg = 110;                               #<!-- Seeker max total angular rotation -->
		maxg = 50;                                       #<!-- In turn -->
		weightlaunchlbs=220.5;
		weightwarheadlbs=22.05;
		dragcoeff=0.50;                                   #<!-- guess; original 0.05-->
		dragarea = 0.143;                                 #<!-- sq ft -->
		maxExplosionRange =65;                             #<!--Due to the code, more the speed is important, more we need to have this figure high-->
		maxspeed = 3.4;                                      #<!-- In Mach -->
		life=70;
		fox="Fox 2";
		rail = "false";
		cruisealt = 0;
		thrustlbs1 = 1600;										#thrust will need to be reworked
        thrustlbs2 = 0;
        thrust1durationsec = 17.5;
        thrust2durationsec = 0;
		min_guiding_speed_mach   = 0.8;
		seeker_angular_speed_dps = 30;   # you want this (much) higher for your modern missiles
		arming_time_sec          = 1.2;  
		guidance          = "heat";

	}elsif(name =="GBU16"){
        address = "/Aircraft/Mirage-2000/Missiles/GBU16/gbu16.xml";
        NoSmoke = "/Aircraft/Mirage-2000/Missiles/GBU16/gbu16.xml";
        maxdetectionrngnm = 14;                       # Not real Impact yet
        fovdeg = 25;                                  # seeker optical FOV
        detectionfovdeg = 180;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 110;                            # Seeker max total angular rotation
        maxg = 15;
        thrustlbs1 = 0;                             
        thrustlbs2 = 0;
        thrust1durationsec =  0;
        thrust2durationsec =  0;
        weightlaunchlbs = 550;
        weightwarheadlbs = 450;
        dragcoeff = 0.10;                             # guess; original 0.05
        dragarea = 0.195;                             # sq ft
        maxExplosionRange = 40;                       # Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 1.5;                               # In Mach
        life = 120;
        fox = "A/G";
        rail = "false";
        cruisealt = 0;
	}elsif(name =="ALARM"){
		#leaving as is for now
		address="Aircraft/eurofighter/Stores/ALARM/alarm-smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/ALARM/alarm.xml";
		#
		maxdetectionrngnm = 14;                         #<!-- Not real Impact yet-->
		fovdeg =25;                                   #<!-- seeker optical FOV -->
		detectionfovdeg=180;                              # <!-- Search pattern diameter (rosette scan) -->
		trackmaxdeg = 110;                               #<!-- Seeker max total angular rotation -->
		maxg = 15;
		thrustlbs1=610;                                    # <!-- guess -->
		thrust1durationsec =700;                           #<!-- Mk.36 Mod.7,8 -->
		weightlaunchlbs=550;
		weightwarheadlbs=450;
		dragcoeff=0.062;                                   #<!-- guess; original 0.05-->
		dragarea = 0.125;                                 #<!-- sq ft -->
		maxExplosionRange =40;                             #<!--Due to the code, more the speed is important, more we need to have this figure high-->
		maxspeed = 1.5;                                      #<!-- In Mach -->
		life=120;
		fox="A/G";
		rail = "true";
		cruisealt = 0;
		min_guiding_speed_mach   = 0.2;
		seeker_angular_speed_dps = 30;   # you want this (much) higher for your modern missiles
		arming_time_sec          = 1.2;  
		guidance          = "radar";
		railLength        = 2.667;
		railForward       = 1;

	}elsif(name =="STORMSHADOW"){
		#leaving as-is for now
		address="Aircraft/eurofighter/Stores/StormShadow/StormShadow-smoke.xml";
		NoSmoke="Aircraft/eurofighter/Stores/StormShadow/StormShadow.xml";
		#
		maxdetectionrngnm = 135;                         #<!-- Not real Impact yet-->
		fovdeg =25;                                   #<!-- seeker optical FOV -->
		detectionfovdeg=180;                              # <!-- Search pattern diameter (rosette scan) -->
		trackmaxdeg = 110;                               #<!-- Seeker max total angular rotation -->
		maxg = 15;
		thrustlb1s=9000;                                    # <!-- guess -->
		thrust1durationsec =890;                           #<!-- Mk.36 Mod.7,8 -->
		weightlaunchlbs=2350;
		weightwarheadlbs=850;
		dragcoeff=0.092;                                   #<!-- guess; original 0.05-->
		dragarea = 0.225;                                 #<!-- sq ft -->
		maxExplosionRange =40;                             #<!--Due to the code, more the speed is important, more we need to have this figure high-->
		maxspeed = 0.8;                                      #<!-- In Mach -->
		life=900;
		fox="A/G";
		rail = "true";
		cruisealt = 1200;
		thrustlbs2        = 0;#stage 2
		thrust2durationsec= 0;
		min_guiding_speed_mach   = 0.2;
		seeker_angular_speed_dps = 30;   # you want this (much) higher for your modern missiles
		arming_time_sec          = 1.2;  
		guidance          = "radar";
		railLength        = 2.667;
		railForward       = 1;
	}

	#print(address);
	#SetProp
	setprop("controls/armament/missile/address",address);
	setprop("controls/armament/missile/addressNoSmoke",NoSmoke);
	setprop("controls/armament/missile/addressExplosion",Explosion);
	setprop("controls/armament/missile/max-detection-rng-nm",maxdetectionrngnm);
	setprop("controls/armament/missile/fov-deg",fovdeg);
	setprop("controls/armament/missile/detection-fov-deg",detectionfovdeg);
	setprop("controls/armament/missile/track-max-deg",trackmaxdeg);
	setprop("controls/armament/missile/max-g",maxg);
	setprop("controls/armament/missile/weight-launch-lbs",weightlaunchlbs);
	setprop("controls/armament/missile/weight-warhead-lbs",weightwarheadlbs);
	setprop("controls/armament/missile/drag-coeff",dragcoeff);
	setprop("controls/armament/missile/drag-area",dragarea);
	setprop("controls/armament/missile/maxExplosionRange",maxExplosionRange);
	setprop("controls/armament/missile/maxspeed",maxspeed);
	setprop("controls/armament/missile/life",life);
	setprop("controls/armament/missile/fox",fox);
	setprop("controls/armament/missile/rail",rail);
	setprop("controls/armament/missile/cruise_alt",cruisealt);
	setprop("controls/armament/missile/thrust-lbs-1",thrustlbs1);
	setprop("controls/armament/missile/thrust-lbs-2",thrustlbs2);
	setprop("controls/armament/missile/thrust-1-duration-sec",thrust1durationsec);
	setprop("controls/armament/missile/thrust-2-duration-sec",thrust2durationsec);
	setprop("controls/armament/missile/min-guiding-speed-mach",min_guiding_speed_mach); #chec this one
	setprop("controls/armament/missile/seeker-angular-speed-dps",seeker_angular_speed_dps); #this'n too
	setprop("controls/armament/missile/arming-time-sec",arming_time_sec);
	setprop("controls/armament/missile/guidance",guidance);
	setprop("controls/armament/missile/rail-length-m",railLength);
	setprop("controls/armament/missile/railForward",railForward);
}