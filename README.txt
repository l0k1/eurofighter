
EFA Typhoon II (naval version) - Eurofighter Typhoon

This model is released under the terms of the GPLv2

First Model by Maverick Alex

First FDM by Detlef Faber
don@sol2500.net

On carrier options, FDM fixes, new textures by AlMurSi
Nav Lights, MIDS, AP (and much more !) by Algernon


———  HOW TO  ———

use the various Upper Left Panel (ULP) and Manual Data Entry Facility (MDEF) buttons


MDEF

- show the selected item (from the ULP) - here the altitude
- show the  current value - here 4000 feet
- use the keyboard to select the new value
- hit ENT (enter) to validate the entry
- hit CLR (clear) to erase it and retype if needed


ULP

AUTOPILOT buttons :  those in diagonal on the left and the upper row

	AP : 	cancel all AP functions

	AT : 	auto thrust - maintain the speed in kt
			Alt key + AT :	speed in mach

	HDG : 	hold Heading 

	TRK : 	track hold (when used with AIDS/TACAN mode, VOR mode, 
		Nav mode)
		or True heading hold (when used with AIDS / Alt + Nav mode

		Alt key + TRK :	Roll hold

	ALT :	altitude hold
			Alt key + ALT :	Pitch hold

	TFR : 	terrain following, holds AGL altitude (caution in mountains…)

	CLM, ATK, APP :  (top row) work in progress ...


- - - - - - - - - - - - - - >   Each entry now calls a submenu on the ULP panel < - - - - - - - - - - - - - 

MIDS :	Radio facility

	HOME : 	display the radio frequencies in use 
				swap between active and standby freq when  Manual 1 (MAN1) or MAN2 freq are selected.

	COMM : 	Radio 1 and 2 - up and down buttons to change freq

	ATK : 	work in progress

	IFF : 	transponder info page

NAV :	Route Management

	RTE MGR : 	call the Route Manager dialog
	PREV WPT 	
	and NEXT WPT : 	I think you guessed

	When the route is loaded (or written) then activated,  you can see it on any MFD, NAV DISP page
	If you hit NAV MODE (AIDS menu), then TRK, the autopilot follows the nav route

AIDS : 	main panel for navigation (see picture)

	CURR HDG : 	set the nav bug to the current heading - works with AP: HDG button
	CURR ALT : 	feed the current altitude to the autopilot
	CURR SPD : 	feed the current speed to the autopilot
	HDG BUG : 	call the nav bug
	BUG OFF : 	hide the nav bug (on the Head Up Display)
	TACAN PWR :	switch tacan on / off

	BINGO SET :	set the desired bingo fuel 
		(audio warning + red warning btn + Hud indication when reaching)

	The VOR(1 and 2) and TACAN modes work with the Autopilot TRK button

	VOR1 MODE : 	set the nav bug to the VOR1 freq (in range), show the VOR id on the HUD, 
				set the AP to intercept the VOR1 radial entered on the CDI 1 (Course Deviation Indicator) 
	The CDI 1 is seen on the left MFD (NAV page), hit NAV SRC to get the blue CDI
	
	Alt key + VOR1 MODE : Direct course to the selected VOR

	VOR2 MODE : 	same procedure with CDI 2 (the yellow one on the left MFD)

	NAV MODE : 	follow and show (HUD) the route loaded in the route manager
		you can also see the route on the MFDs, NAV DISP page

	TACAN MODE : 	sets the nav bug to the selected TACAN, sets the AP to a direct course to the selected tacan

	The TACAN, VOR1 or 2 and NAV modes work with the autopilot TRK button

NIS : 	not used at this time

INT :   	work in progress

XPDR : transponder set facility - Switch MODES 1, 2, 3A and C as required - IFF codes select and set

INST SET : 	enter the desired TACAN, VOR, ADF and Manual RADIO frequencies with the MDEF 
			here above is an example of the TACAN freq change (current is 101 X)

Caution :
	With the MDEF : 	to enter a TACAN frequency, you need to enter 3 digits before the X or Y 	(for example : nimitz tacan 29Y enter 0 2 9 Y)


XMIT : 	 not used at this time

RAD1 (and RAD2) : 	select the desired freq from the pre-entered list 
		The list is found on the left MFD, FREQ button
		the list on the left MFD updates the manual freq you enter in the MDEF

DAS :	not used at this time

NAV SET : enter the different instrument infos with the MDEF

	ALT :		set the desired altitude (works with AP: ALT)

	AGL : 		set the desired AGL altitude (works with TFR)

	VSI :		work in progress

	HUD TEST : 	shows all entries in the HUD

	MAG HDG : 	magnetic heading set
	TRUE HDG :  	true heading set

	CDI 1 : 		set the desired course to the next VOR1 selected 
			(blue CDI on the NAV panel - left MFD)

	CDI 2 : 		same for the VOR2 (yellow CDI)

	CDI TAC : 	same for the TACAN (white CDI)

	SPD KTS : 	desired speed in kts

	SPD MACH : 	desired speed in mach
		
***** MFDs ***** 

LEFT MFD :
	NAV button : show the nav system (tacan, vor, adf)

	NAV SRC : 	cycle between TACAN, CDI1 and CDI2 needles
	
	NAV 1 :	cycle between VOR1, ADF1 and off (blue needle)
		
	NAV 2 :	cycle between VOR2, ADF2 and off (yellow needle)
		
	NAV 3 :	cycle between TACAN and off
		You need to have NAV1 selected to VOR1 to see the actual range - same for NAV2

RIGHT MFD :
	STOR button : 	show external fuel tanks and/or weapons 
			(updated when you fire/drop weapons or fuel tank)

	ARM Sel + or ARM Sel - :  select the weapon to release (red rectangle on the active weapon)

	A/A : 		set HUD to air to air mode

	A/G : 		set HUD to air to ground mode

	Gun : 		set HUD to Gun mode

RADAR : 	show targets within range (selected R+ or R- to increase/decrease range)
			if you want to track a target, hit the MODE btn to TWS.A :
				- a black diamond will appear on the HUD with the various target infos
		
NAV DISP :	nav data display, showing the route planned on the "Route Manager"
				TCAS functioning
		  	 	R+ and R- buttons change the radar distance

CENTER MFD :
	SIT button: 	situation awareness 
			MAP : 	Moving Map
				TRK button switches between North reference and actual heading
				The right knob allows you to change the map lighting (very different if you fly with Rembrandt)

Each MFD has 2 rotating knobs, used according to the page loaded :

	EADI :	left knob adjust the target speed
				right knob adjust the target altitude

	NAV : (left MFD)
		left knob adjust the target heading
		right knob adjust the Tacan selected radial

	NAV HSI : 	left knob adjust the target heading

	SIT / MAP : 	right knob adjust the map brightness

HUD : 
	weapons : when hitting “w“ key, you cycle between Guns, A/A: and A/G:

	Guns : 	to fire the cannon, shows the remaining bullets

	A/A:    	to fire Air to Air missiles only
	  	shows the Air to Air missiles only, even if you have Air to Ground weapons

	A/G:    	to fire Air to Ground weapons only
	  	shows the Air to Ground weapons only, even if you have Air to Air missiles

New Warning Panel

Countermeasures added (DASS) :
	"l" key to release flares (keep "l" depressed to release more)
	"m" key to release chaffs (same)

CENTER PANEL (behind the stick)

DRF (Disorientation Recovery Facility) button
	to take you safely away from ground if hypoxia 

GND, T/O, A/A, NAV, LDG : the different POF (phase of flight) buttons
		select them as required

NVE, FLIR : night vision and FLIR vision buttons, function with ALS 
		BRT and CONT to adjust brightness and contrast as you see fit


******************   if you fly with ALS on   ***********************

New switches and knobs (right panel) to control the cabin conditioning (heat and flow)
use them to see the new frost/fog features

cockpit shadows added

afterburner flames added



Enjoy your flights with the Typhoon !!!
Any queries/remarks : FGUK forum

A big Thank You to Algernon (Algy) (and his team) for letting me develop this version of the EFA !


