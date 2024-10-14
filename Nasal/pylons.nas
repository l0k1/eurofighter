#var cannon = stations.SubModelWeapon.new("20mm Cannon", 0.254, 511, 2, [1,3], props.globals.getNode("fdm/jsbsim/fcs/guntrigger",1), 0, func{return getprop("fdm/jsbsim/systems/hydraulics/sysb-psi")>=2000;});
var init = func() {
	# fuel tanks: name, fuel tank #, capacity gallons, path to model prop
	var fuelTank300LeftInside	=	stations.FuelTank.new("Left Drop Tank",	9, 300, "sim/model/AV-8B/wingtankLI");
	var fuelTank300RightMiddle	=	stations.FuelTank.new("Right Drop Tank",	11, 300, "sim/model/AV-8B/wingtankRM");
	#var smokewinderRed1 = stations.Smoker.new("Smokewinder Red", "sim/model/f16/smokewinderR1");
	#var smokewinderGreen1 = stations.Smoker.new("Smokewinder Green", "sim/model/f16/smokewinderG1");
	#var smokewinderBlue1 = stations.Smoker.new("Smokewinder Blue", "sim/model/f16/smokewinderB1");
	#var smokewinderRed9 = stations.Smoker.new("Smokewinder Red", "sim/model/f16/smokewinderR9");
	#var smokewinderGreen9 = stations.Smoker.new("Smokewinder Green", "sim/model/f16/smokewinderG9");
	#var smokewinderBlue9 = stations.Smoker.new("Smokewinder Blue", "sim/model/f16/smokewinderB9");
	var pylonSets = {
		empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#e: {name: "20mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1},
		#f: {name: "300 Gal Fuel tank", content: [fuelTankCenter], fireOrder: [0], launcherDragArea: 0.18, launcherMass: 392, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1},
		#g: {name: "1 x AIM-9", content: ["AIM-9"], fireOrder: [0], launcherDragArea: -0.0785, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},#wingtip
		#h: {name: "1 x AIM-120", content: ["AIM-120"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: 10, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},#non wingtip
		#i: {name: "3 x GBU-12", content: ["GBU-12","GBU-12", "GBU-12"], fireOrder: [0,1,2], launcherDragArea: -0.025, launcherMass: 10, launcherJettisonable: 1, showLongTypeInsteadOfCount: 0},
		#j: {name: "2 x GBU-12", content: ["GBU-12", "GBU-12"], fireOrder: [0,1], launcherDragArea: -0.025, launcherMass: 10, launcherJettisonable: 1, showLongTypeInsteadOfCount: 0},
		#k: {name: "1 x AN-T-17", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		l: {name: "300 Gallon Fuel Tank", content: [fuelTank300LeftInside], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 375, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1},
		m: {name: "300 Gallon Fuel Tank", content: [fuelTank300LeftMiddle], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 375, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1},
		n: {name: "300 Gallon Fuel Tank", content: [fuelTank300RightInside], fireOrder: [0], launcherDragArea: 0.30, launcherMass: 375, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1},
		o: {name: "300 Gallon Fuel Tank", content: [fuelTank300RightMiddle], fireOrder: [0], launcherDragArea: 0.30, launcherMass: 375, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1},
		#q: {name: "1 x AIM-9", content: ["AIM-9"], fireOrder: [0], launcherDragArea: -0.025, launcherMass: 10, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},#non wingtip
		#r: {name: "1 x AIM-120", content: ["AIM-120"], fireOrder: [0], launcherDragArea: -0.05, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},#wingtip
		#s: {name: "1 x Smokewinder Red", content: [smokewinderRed1], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#t: {name: "1 x Smokewinder Green", content: [smokewinderGreen1], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#u: {name: "1 x Smokewinder Blue", content: [smokewinderBlue1], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#v: {name: "1 x Smokewinder Red", content: [smokewinderRed9], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#w: {name: "1 x Smokewinder Green", content: [smokewinderGreen9], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
		#x: {name: "1 x Smokewinder Blue", content: [smokewinderBlue9], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0},
	};

	# sets
	var center			=	[pylonSets.empty];
	var leftinside		=	[pylonSets.empty, pylonSets.l];
	var leftmiddle		=	[pylonSets.empty, pylonSets.m];
	var leftoutside		=	[pylonSets.empty];
	var rightinside		=	[pylonSets.empty, pylonSets.n];
	var righttmiddle	=	[pylonSets.empty, pylonSets.o];
	var rightoutside	=	[pylonSets.empty];
	var sidewinder		=	[pylonSets.empty];
	#var pylon120set = [pylonSets.empty, pylonSets.q, pylonSets.h];
	#var wingtipSet1  = [pylonSets.k,     pylonSets.g, pylonSets.r,pylonSets.s,pylonSets.t,pylonSets.u];# wingtips are normally not empty, so AN-T-17 dummy aim9 is loaded instead.
	#var wingtipSet9  = [pylonSets.k,     pylonSets.g, pylonSets.r,pylonSets.v,pylonSets.w,pylonSets.x];# wingtips are normally not empty, so AN-T-17 dummy aim9 is loaded instead.
	#var pylon9mix   = [pylonSets.empty, pylonSets.q, pylonSets.i, pylonSets.h];
	#var pylon12setL = [pylonSets.empty, pylonSets.j, pylonSets.l, pylonSets.o];
	#var pylon12setR = [pylonSets.empty, pylonSets.j, pylonSets.m, pylonSets.p];

	# pylons
	var pylon1 = stations.Pylon.new("#1 Left Outer",	0,	[0,0,0],	leftoutside,	0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1));
	var pylon2 = stations.Pylon.new("#2 Left Middle",	1,	[0,0,0],	leftmiddle,		1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1));
	var pylon3 = stations.Pylon.new("#3 Left Inside",	2,	[0,0,0],	leftinside,		2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1));
	var pylon4 = stations.Pylon.new("#4 Center",		3,	[0,0,0],	center,			3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1));
	var pylon5 = stations.Pylon.new("#5 Right Inside",	4,	[0,0,0],	rightinside,	4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1));
	var pylon6 = stations.Pylon.new("#6 Right Middle",	5,	[0,0,0],	righttmiddle,	5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1));
	var pylon7 = stations.Pylon.new("#7 Right Outside",	6,	[0,0,0],	rightoutside,	6, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[6]",1),	props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[6]",1));
	#var pylon8 = stations.Pylon.new("#8 Sidewinder Left", 7, [0,0,0], pylon120set, 7, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[8]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[8]",1));
	#var pylon9 = stations.Pylon.new("#9 Sidewinder RIght", 8, [0,0,0], wingtipSet9, 8, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[9]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[9]",1));
	#var pylonI = stations.InternalStation.new("Internal gun mount", 9, [pylonSets.e], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[10]",1));

	var pylons = [pylon1,pylon2,pylon3,pylon4,pylon5,pylon6,pylon7];
	var fcs = fc.FireControl.new(pylons, [0,6,1,5,2,4,3], []);
}