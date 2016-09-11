#############################################################################
# Flight Director/Autopilot controller.
# Syd Adams

#Adapte pour Mirage2000 03/2013
###  Initialization #######

var Lateral = "autopilot/locks/heading";
var Lateral_arm = "autopilot/locks/heading-arm";
var Vertical = "autopilot/locks/altitude";
var Vertical_arm = "autopilot/locks/altitude-arm";
var AP = "autopilot/locks/AP-status";
var SPD = "autopilot/locks/speed";
var NAVprop="autopilot/settings/nav-source";
var NAVSRC= getprop(NAVprop);
var DMEprop="instrumentation/dme/frequencies/source";
var pitch_trim="controls/flight/elevator-trim";
var roll_trim="controls/flight/aileron-trim";
var count=0;
var count_1=0;
var minimums=getprop("autopilot/settings/minimums");
var wx_range=[10,25,50,100,200,300];
var wx_index=3;
var deadZ_pitch = 0.05; #0.02
var deadZ_roll = 0.05;  
var stick_pos = 0;
var flag = 0;
#####################################

######initialisation
var init_set=func{
#    setprop("instrumentation/nd/range",wx_range[wx_index]);
    setprop("/autopilot/settings/target-altitude-ft",4000);
    setprop(RMI1prop,"");
    setprop(RMI2prop,"");
    setprop(RMI3prop,"");
    settimer(update_fd, 5);
}

### AP /FD BUTTONS ####

var FD_set_mode = func(btn){
    var Lmode=getprop(Lateral);
    var LAmode=getprop(Lateral_arm);
    var Vmode=getprop(Vertical);
    var VAmode=getprop(Vertical_arm);
    var SPmode=getprop(SPD);

    if(btn=="ap"){
        
        if(getprop(AP)!="AP1"){
            setprop(Lateral_arm,"");
            setprop(Vertical_arm,"");
            if(Vmode=="PTCH")set_pitch();
            if(Lmode=="ROLL")set_roll();
            if(getprop("position/altitude-agl-ft") > minimums) {
                setprop(AP,"AP1");}
        } else kill_Ap("<MINIMUM");

    }elsif(btn=="hdg"){
        if(Lmode!="HDG") setprop(Lateral,"HDG") 
        else set_roll();
        setprop(Lateral_arm,"");
        setprop(Vertical_arm,"");

    }elsif(btn=="alt"){
        setprop(Lateral_arm,"");
        setprop(Vertical_arm,"");
        if(Vmode!="ALT"){
        setprop(Vertical,"ALT");setprop("autopilot/settings/target-altitude_ft",(getprop("instrumentation/altimeter/mode-c-alt-ft")));

        } else set_pitch();
   
    }elsif(btn=="nav"){
        set_nav_mode();       

    }elsif(btn=="vnav"){
        if(Vmode!="VALT"){
            if(NAVSRC=="FMS"){
                setprop(Vertical,"VALT");
                setprop(Lateral,"LNAV");
            }
            }else set_pitch();

    }elsif(btn=="app"){
        setprop(Lateral_arm,"");
        setprop(Vertical_arm,"");
        set_apr(); 

    }elsif(btn=="stby"){
        setprop(Lateral_arm,"");
        setprop(Vertical_arm,"");
        set_pitch();
        set_roll();       
    
    }elsif(btn=="spd"){
        if(SPmode!="SPD") setprop(SPD,"SPD")
        else setprop(SPD,"")}
    }

########  FMS/NAV BUTTONS  ############
var nav_src_set=func(){
    setprop(Lateral_arm,"");
    setprop(Vertical_arm,"");
    count_1+=1;
    if(count_1>2)count_1=0;    
    if(count_1==0)setprop(NAVprop,"NAV1");
    if(count_1==1)setprop(NAVprop,"NAV2");
    if(count_1==2)setprop(NAVprop,"TACAN"); 
#   if(count_1==3)setprop(NAVprop,"FMS");          
}

########### ARM VALID NAV MODE ################
var set_nav_mode=func{
    setprop(Lateral_arm,"");setprop(Vertical_arm,"");
    if(NAVSRC=="NAV1"){
        if(getprop("instrumentation/nav[0]/data-is-valid")){
            if(getprop("instrumentation/nav[0]/nav-loc"))setprop(Lateral_arm,"LOC") 
            else setprop(Lateral_arm,"VOR");
            setprop(Lateral,"HDG");
        }
    }elsif(NAVSRC=="NAV2"){
        if(getprop("instrumentation/nav[1]/data-is-valid")){
            if(getprop("instrumentation/nav[1]/nav-loc"))setprop(Lateral_arm,"LOC") else setprop(Lateral_arm,"VOR");
            setprop(Lateral,"HDG");
        }
    }elsif(NAVSRC=="TACAN"){
        if(getprop("instrumentation/tacan/data-is-valid")){
            if(getprop("instrumentation/nav[2]/nav-loc"))setprop(Lateral_arm,"LOC") 
            else setprop(Lateral_arm,"TACAN");
            setprop(Lateral,"HDG");
        }
    }elsif(NAVSRC=="FMS"){
        if(getprop("autopilot/route-manager/active"))setprop(Lateral,"LNAV");
    }
}

#######  PITCH WHEEL ACTIONS #############

#var pitch_wheel=func(dir){
#    var Vmode=getprop(Vertical);
   
#    var amt=0; 
    
#    if(Vmode=="PTCH"){
#        amt=getprop("autopilot/settings/target-pitch-deg") + (dir*0.1);
#        amt = (amt < -20 ? -20 : amt > 20 ? 20 : amt);
#        setprop("autopilot/settings/target-pitch-deg",amt)
#    }

#}

########    FD INTERNAL ACTIONS  #############

#var set_pitch=func{
#    setprop(Vertical,"PTCH");   
#    var p_inst=getprop("orientation/pitch-deg");
#    if(p_inst < 3 and p_inst > -3){
#    setprop("autopilot/settings/target-pitch-deg",0);
#    }
#    else{    
#    setprop("autopilot/settings/target-pitch-deg",p_inst);
#    }
#    }

var set_roll=func{
    var r_inst=getprop("orientation/roll-deg");    
    setprop(Lateral,"ROLL");      
    if(r_inst < 10 and r_inst > -10){    
       setprop("autopilot/settings/target-roll-deg",0.0)}
    if(r_inst > 10 or r_inst < -10){    
       setprop("autopilot/settings/target-roll-deg",r_inst)}
    }

var set_apr=func{
    if(NAVSRC == "NAV1"){
        if(getprop("instrumentation/nav[0]/nav-loc") and getprop("instrumentation/nav[0]/has-gs")){
            setprop(Lateral_arm,"LOC");
            setprop(Vertical_arm,"GS");
            setprop(Lateral,"HDG");
        }
    }elsif(NAVSRC == "NAV2"){
    if(getprop("instrumentation/nav[1]/nav-loc") and getprop("instrumentation/nav[1]/has-gs")){
            setprop(Lateral_arm,"LOC");
            setprop(Vertical_arm,"GS");
            setprop(Lateral,"HDG");
        }
    }
}

setlistener("autopilot/settings/minimums", func(mn) {
    minimums=mn.getValue();
},1,0);

setlistener(NAVprop, func(Nv) {
    NAVSRC=Nv.getValue();
},1,0);

var update_nav=func{
    var sgnl = "- - -";
    var gs =0;
    if(NAVSRC == "NAV1"){

        if(getprop("instrumentation/nav[0]/data-is-valid"))
        sgnl="VOR1";
        setprop("autopilot/internal/in-range",getprop("instrumentation/nav[0]/in-range"));
        setprop("autopilot/internal/gs-in-range",getprop("instrumentation/nav[0]/gs-in-range"));
        var dst=getprop("instrumentation/nav[0]/nav-distance") or 0;
        dst*=0.000539;
        setprop("autopilot/internal/nav-distance",dst);
        if(getprop("instrumentation/nav[0]/nav-id") != nil){ setprop("autopilot/internal/nav-id",getprop("instrumentation/nav[0]/nav-id"));}
        if(getprop("instrumentation/nav[0]/nav-loc"))sgnl="LOC1";
        if(getprop("instrumentation/nav[0]/has-gs"))sgnl="ILS1";
        if(sgnl=="ILS1")gs = 1;
        setprop("autopilot/internal/gs-valid",gs);
        setprop("autopilot/internal/nav-type",sgnl);
        course_offset("instrumentation/nav[0]/radials/selected-deg");
        setprop("autopilot/internal/radial-selected-deg",getprop("instrumentation/nav[0]/radials/selected-deg"));
        setprop("autopilot/internal/heading-needle-deflection",getprop("instrumentation/nav[0]/heading-needle-deflection"));
        setprop("autopilot/internal/to-flag",getprop("instrumentation/nav[0]/to-flag"));
        setprop("autopilot/internal/from-flag",getprop("instrumentation/nav[0]/from-flag"));
        setprop(DMEprop,"instrumentation/nav[0]/frequencies/selected-mhz");

    }elsif(NAVSRC == "NAV2"){
        if(getprop("instrumentation/nav[1]/data-is-valid"))sgnl="VOR2";
        setprop("autopilot/internal/in-range",getprop("instrumentation/nav[1]/in-range"));
        setprop("autopilot/internal/gs-in-range",getprop("instrumentation/nav[1]/gs-in-range"));
        var dst=getprop("instrumentation/nav[1]/nav-distance") or 0;
        dst*=0.000539;
        setprop("autopilot/internal/nav-distance",dst);
        setprop("autopilot/internal/nav-id",getprop("instrumentation/nav[1]/nav-id"));
        if(getprop("instrumentation/nav[1]/nav-loc"))sgnl="LOC2";
        if(getprop("instrumentation/nav[1]/has-gs"))sgnl="ILS2";
        if(sgnl=="ILS2")gs = 1;
        setprop("autopilot/internal/gs-valid",gs);
        setprop("autopilot/internal/nav-type",sgnl);
        course_offset("instrumentation/nav[1]/radials/selected-deg");
        setprop("autopilot/internal/radial-selected-deg",getprop("instrumentation/nav[1]/radials/selected-deg"));
        setprop("autopilot/internal/heading-needle-deflection",getprop("instrumentation/nav[1]/heading-needle-deflection"));
        setprop("autopilot/internal/to-flag",getprop("instrumentation/nav[1]/to-flag"));
        setprop("autopilot/internal/from-flag",getprop("instrumentation/nav[1]/from-flag"));
        setprop(DMEprop,"instrumentation/nav[1]/frequencies/selected-mhz");

    }elsif(NAVSRC == "TACAN"){
        sgnl="TAC";
        setprop("autopilot/internal/in-range",getprop("instrumentation/tacan/in-range"));
        var dst=getprop("instrumentation/tacan/indicated-distance-nm") or 0;
        dst*=0.000539;
        setprop("autopilot/internal/nav-distance",dst);
        setprop("autopilot/internal/nav-id",getprop("instrumentation/tacan/ident"));
        if(getprop("instrumentation/nav[2]/nav-loc"))sgnl="LOC3";
        setprop("autopilot/internal/nav-type",sgnl);
        course_offset("instrumentation/nav[2]/radials/selected-deg");
        setprop("autopilot/internal/radial-selected-deg",getprop("instrumentation/nav[2]/radials/selected-deg"));
        setprop("autopilot/internal/heading-needle-deflection",getprop("sim/model/eurofighter/instrumentation/enav[0]/needle-deflection"));
        setprop("autopilot/internal/to-flag",getprop("instrumentation/nav[2]/to-flag"));
        setprop("autopilot/internal/from-flag",getprop("instrumentation/nav[2]/from-flag"));
        setprop(DMEprop,"instrumentation/tacan/frequencies/selected-mhz");

    }elsif(NAVSRC == "FMS"){
        setprop("autopilot/internal/nav-type","FMS1");
        setprop("autopilot/internal/in-range",1);
        setprop("autopilot/internal/gs-in-range",0);
        setprop("autopilot/internal/nav-distance",getprop("instrumentation/gps/wp/wp[1]/distance-nm"));
        setprop("autopilot/internal/nav-id",getprop("instrumentation/gps/wp/wp[1]/ID"));
        course_offset("instrumentation/gps/wp/wp[1]/bearing-mag-deg");
        setprop("autopilot/internal/to-flag",getprop("instrumentation/gps/wp/wp[1]/to-flag"));
        setprop("autopilot/internal/from-flag",getprop("instrumentation/gps/wp/wp[1]/from-flag"));
    }
}

var set_range = func(dir){
    wx_index+=dir;
    if(wx_index>5)wx_index=5;
    if(wx_index<0)wx_index=0;
    setprop("instrumentation/nd/range",wx_range[wx_index]);
}

var course_offset = func(src){
    var crs_set=getprop(src);
    var crs_offset= crs_set - getprop("orientation/heading-magnetic-deg");
    if(crs_offset>180)crs_offset-=360;
    if(crs_offset<-180)crs_offset+=360;
    setprop("autopilot/internal/course-offset",crs_offset);
    crs_offset+=getprop("autopilot/internal/cdi");
    if(crs_offset>180)crs_offset-=360;
    if(crs_offset<-180)crs_offset+=360;
    setprop("autopilot/internal/ap_crs",crs_offset);
    setprop("autopilot/internal/selected-crs",crs_set);
}

var monitor_L_armed = func{
    if(getprop(Lateral_arm)!=""){
        if(getprop("autopilot/internal/in-range")){
            var cdi=getprop("autopilot/internal/cdi");
            if(cdi < 40 and cdi > -40){
                setprop(Lateral,getprop(Lateral_arm));
                setprop(Lateral_arm,"");
            }
        }
    }
}

var monitor_V_armed = func{
    var Varm=getprop(Vertical_arm);
    var myalt=getprop("instrumentation/altimeter/indicated-altitude-ft");
    var asel=getprop("autopilot/settings/target-altitude-ft");
    var alterr=myalt-asel;
    if(Varm=="ASEL"){
        if(alterr >-250 and alterr <250){
            setprop(Vertical,"ALT");
            setprop(Vertical_arm,"");
        }
    }elsif(Varm=="VASEL"){
        if(alterr >-250 and alterr <250){
            setprop(Vertical,"VALT");
            setprop("instrumentation/gps/wp/wp[1]/altitude-ft",asel);
            setprop(Vertical_arm,"");
        }
    }elsif(Varm=="GS"){
        if(getprop(Lateral)=="LOC"){
            if(getprop("autopilot/internal/gs-in-range")){
                var gs_err=getprop("autopilot/internal/gs-deflection");
                var gs_dst=getprop("autopilot/internal/nav-distance");
                if(gs_dst <= 12.0){
                    if(gs_err >-0.15 and gs_err < 0.15){
                        setprop(Vertical,"GS");
                        setprop(Vertical_arm,"");
                        minimums=100;                   #mini 100ft si GS
                    }
                }
            }
        }
    }
}

#------Tests PA-Limits
var monitor_AP_errors= func{
    var ralt=getprop("position/altitude-agl-ft");
    if(ralt<minimums)kill_Ap("AP-<MINI-ALTITUDE");
    var rlimit=getprop("orientation/roll-deg");
    if(rlimit > 65 or rlimit< -65)kill_Ap("AP-BANKLIMIT-FAIL");
    var plimit=getprop("orientation/pitch-deg");
    if(plimit > 30 or plimit< -30)kill_Ap("AP-PITCHLIMIT-FAIL");
}
#------PA OFF
var kill_Ap = func(msg){
    setprop(AP,msg);
    setprop(SPD,"");
    set_pitch();
    set_roll();
    flag = 0;
     setprop(pitch_trim,0);
    setprop(roll_trim,0);
}

#---Temporarly disengage Autopilot when control stick steering
var pa_stb_off = func{
    if(stick_pos == 1 and flag==0){
        setprop(AP,"TEMP DISENGAGE");
        setprop(Lateral,"");
        setprop(Vertical,"");
        flag=1;
        }
}    
#---Re-engage Autopilot
var pa_stb_on = func{   
    if(stick_pos == 0 and flag==1){
        setprop(AP,"AP1");
        set_pitch();
        set_roll();
        flag=0;
        }
}
###  Main loop ###

var update_fd = func {
var elev_ctrl=getprop("controls/flight/elevator");
var roll_ctrl=getprop("controls/flight/aileron");

#--Control stick position
# 	stick_pos = ((elev_ctrl > deadZ_pitch or -deadZ_pitch > elev_ctrl) or (roll_ctrl > deadZ_roll or -deadZ_roll > roll_ctrl)) ? 1 : 0;

    var L_mode=getprop(Lateral);
    var V_mode=getprop(Vertical);
    var pa_stat=getprop(AP); 
    if(pa_stat=="AP1" and L_mode=="ROLL" 
                      and V_mode=="PTCH" 
                      and stick_pos==1)pa_stb_off(); 

    if(pa_stat=="TEMP DISENGAGE" and L_mode==""
                                 and V_mode==""
                                 and stick_pos==0)pa_stb_on(); 

    update_nav();    
#    if(count==0)monitor_AP_errors();
    if(count==1)monitor_L_armed();
    if(count==2)monitor_V_armed(); 
     
    count+=1;
    if(count>2)count=0;
    if(pa_stat=="AP1"){
        settimer(update_fd, 0.25);
    }else{
        settimer(update_fd, 1);
    }
}
