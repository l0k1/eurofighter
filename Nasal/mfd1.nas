#scripts mfd

var RMI1prop="instrumentation/enav[0]/rmi-1-src";
var RMI2prop="instrumentation/enav[0]/rmi-2-src";
var RMI3prop="instrumentation/enav[0]/rmi-3-src";
var RMI1src="instrumentation/enav[0]/rmi-1-bearing-deg";
var RMI2src="instrumentation/enav[0]/rmi-2-bearing-deg";
var RMI3src="instrumentation/enav[0]/rmi-3-bearing-deg";
var RMI1ident="instrumentation/enav[0]/rmi-1-ident";
var RMI2ident="instrumentation/enav[0]/rmi-2-ident";
var RMI3ident="instrumentation/enav[0]/rmi-3-ident";
var RMI1dist="instrumentation/enav[0]/rmi-1-dist";
var RMI2dist="instrumentation/enav[0]/rmi-2-dist";
var RMI3dist="instrumentation/enav[0]/rmi-3-dist";

var count_2=0;
var count_3=0;
var count_4=0;

########### RMI RADIO MAGNETIC INDICATOR#################

########### Update RMI 1

var update_rmi1=func{
    var rmi1_src=getprop(RMI1prop);
    if(rmi1_src==""){
        setprop(RMI1ident,"");
        setprop(RMI1dist,0);
        }
    if(rmi1_src=="NAV1"){
       setprop(RMI1src,getprop("instrumentation/nav[0]/heading-deg"));
       if(getprop("instrumentation/nav[0]/nav-id") != nil){setprop(RMI1ident,getprop("instrumentation/nav[0]/nav-id"));}
		if(getprop("instrumentation/nav[0]/dme-in-range")){
			var rmi1_dist=getprop("instrumentation/nav[0]/nav-distance");
			rmi1_dist=rmi1_dist/1852;
			setprop(RMI1dist,rmi1_dist);
			}
		}
    if(rmi1_src=="ADF1"){
        var adf1_corr=getprop("instrumentation/adf[0]/indicated-bearing-deg");
       adf1_corr=adf1_corr+getprop("orientation/heading-deg");
       if(adf1_corr>360)adf1_corr-=360;
       setprop(RMI1src,adf1_corr);       
       setprop(RMI1ident,getprop("instrumentation/adf[0]/ident"));
       setprop(RMI1dist,0);
       }      
}

########### Update RMI 2
var update_rmi2 = func{
        var rmi2_src=getprop(RMI2prop);
    if(rmi2_src==""){
        setprop(RMI2ident,"");
        setprop(RMI2dist,0);
        }       

    if(rmi2_src=="NAV2"){
       setprop(RMI2src,getprop("instrumentation/nav[1]/heading-deg"));
       setprop(RMI2ident,getprop("instrumentation/nav[1]/nav-id"));       
       if(getprop("instrumentation/nav[1]/dme-in-range")){
           var rmi2_dist=getprop("instrumentation/nav[1]/nav-distance");
           rmi2_dist=rmi2_dist/1852;
           setprop(RMI2dist,rmi2_dist);
           }
       }
    if(rmi2_src=="ADF2"){
       var adf2_corr=getprop("instrumentation/adf[1]/indicated-bearing-deg");
       adf2_corr=adf2_corr+getprop("orientation/heading-deg");
       if(adf2_corr>360)adf2_corr-=360;
       setprop(RMI2src,adf2_corr);
       setprop(RMI2ident,getprop("instrumentation/adf[1]/ident"));
       setprop(RMI2dist,0);
       }
}

########### Update RMI 3

var update_rmi3=func{
    var rmi3_src=getprop(RMI3prop);
    if(rmi3_src==""){
        setprop(RMI3ident,"");
        setprop(RMI3dist,0);
        }
     if(rmi3_src=="TACAN"){
        setprop(RMI3src,getprop("instrumentation/tacan/indicated-bearing-true-deg"));
        setprop(RMI3ident,getprop("instrumentation/tacan/ident"));
        setprop(RMI3dist,getprop("instrumentation/tacan/indicated-distance-nm"));
        }
}

########### Bouton RMI 1
var rmi1_src_set=func(){  
    count_2+=1;
    if(count_2>2)count_2=0;    
    if(count_2==0){
        setprop(RMI1prop,"");
        update_rmi1();
        }
    if(count_2==1){
        setprop(RMI1prop,"NAV1");
        update_rmi1();
        }       
    if(count_2==2){
        setprop(RMI1prop,"ADF1"); 
        update_rmi1();
        }       
}

############ Bouton RMI 2
var rmi2_src_set=func(){    
    count_3+=1;
    if(count_3>2)count_3=0;    
    if(count_3==0){
        setprop(RMI2prop,"");
        update_rmi2();
        }       
    if(count_3==1){
        setprop(RMI2prop,"NAV2");
        update_rmi2();
        }       
    if(count_3==2){
        setprop(RMI2prop,"ADF2");
        update_rmi2();
        }         
}

############ Bouton RMI 3
var rmi3_src_set=func(){    
    count_4+=1;
    if(count_4>1)count_4=0;    
    if(count_4==0){
        setprop(RMI3prop,"");
        update_rmi3();
        }       
    if(count_4==1){
        setprop(RMI3prop,"TACAN");
        update_rmi3();
        }       
}

########## Main Loop
var update_main=func(){
    update_rmi1();
    update_rmi2();    
    update_rmi3();    
settimer(update_main,0.15);
}
