print("*** LOADING ext_stores.nas ... ***");
################################################################################
#
#                     m2005-5's EXTERNAL STORES SETTINGS
#
################################################################################

# check then drop
var dropTanks = func()
{
    for(var i = 2 ; i < 5 ; i += 1)
    {
        var select = getprop("/sim/weight["~ i ~"]/selected");
        if(select == "1000 l Droptank" or select == "1500 l Droptank")
        {
            dropLoad(i);
        }
    }
}

# compile all load in a multiplay variable
var Encode_Load = func()
{
    var list = [
        "none",
        "1000 l Droptank",
        "1500 l Droptank",
        "AIM132",
        "AIM9",
        "AIM120",
        "GBU16",
        "ALARM",
        "STORMSHADOW",
        "Matra MICA",
        "Brimstone",
    ];
    var compiled = "";
    
    for(var i = 0 ; i < 9 ; i += 1)
    {
        # Load name
        var select = getprop("sim/weight["~ i ~"]/selected");
        
        # fireable or not : may displays the pylons if there a weight but fire = 0
        var released = getprop("controls/armament/station["~ i ~"]/release");
        
        # selection of the index load for each pylon
        # We get the children of the tree sim weight[actual]
        for(var y = 0 ; y < size(list) ; y += 1)
        {
            if(list[y] == select)
            {
                var select_Index = y;
            }
        }
        
        # now we select the index
        compiled = compiled ~"#"~ i ~ released ~ select_Index;
    }
    
    # we put it in a multiplay string
    setprop("sim/multiplay/generic/string[1]", compiled);
}

### Object decode
var Decode_Load = {
    new: func(mySelf, myString, updateTime)
    {
        var m = { parents: [Decode_Load] };
        m.mySelf = mySelf;
        m.myString = myString;
        m.updateTime = updateTime;
        m.running = 1;
        m.loadList = [
            "none",
			"1000 l Droptank",
			"1500 l Droptank",
			"AIM132",
			"AIM9",
			"AIM120",
			"GBU16",
			"ALARM",
			"STORMSHADOW",
			"Matra MICA",
			"Brimstone",
        ];
        return m;
    },
    
    decode: func()
    {
        #print("Upload On going");
        var myString = me.myString.getValue();
        var myIndexArray = [];
        
        if(myString != nil)
        {
            #print("the string :"~ myString);
            #print("test" ~ me.loadList[3]);
            # Here to detect each substring index
            for(i = 0 ; i < size(myString) ; i += 1)
            {
                #print(chr(myString[i]));
                if(chr(myString[i]) == '#')
                {
                    #print("We got one : " ~ i );
                    append(myIndexArray, i);
                }
                #print(size(myIndexArray));
            }
            
            # now we can split the substring
            for(i = 0 ; i < size(myIndexArray) ; i += 1)
            {
                if(i < size(myIndexArray) - 1)
                {
                    #print(substr(myString, myIndexArray[i], myIndexArray[i + 1] - myIndexArray[i]));
                    
                    # index of weight :
                    var myWeightIndex = substr(myString, myIndexArray[i] + 1, 1);
                    #print("myWeightIndex:"~ myWeightIndex);
                    
                    # has been fired (display pylons or not)
                    var myFired = substr(myString, myIndexArray[i] + 2, 1) == 1;
                    #print(myFired);
                    
                    # what to put in weight[]/selected index
                    var myWeightOptIndex = substr(myString, myIndexArray[i] + 3, (myIndexArray[i + 1] - 1) - (myIndexArray[i] + 2));
                    var myWeight = me.loadList[myWeightOptIndex];
                    #var myWeight = getprop("sim/weight["~ myWeightIndex ~"]/opt[" ~ myWeightOptIndex ~ "]/name");
                    #print("myWeight: " ~ myWeight);
                    
                    # rebuilt the property Tree
                    me.mySelf.getNode("sim/weight["~ myWeightIndex ~"]/selected", 1).setValue(myWeight);
                    me.mySelf.getNode("controls/armament/station["~ myWeightIndex ~"]/release", 1).setValue(myFired);
                }
                else
                {
                    #print(substr(myString, myIndexArray[i], size(myString) - myIndexArray[i]));
                    
                    # index of weight :
                    var myWeightIndex = substr(myString, myIndexArray[i] + 1, 1);
                    #print(myWeightIndex);
                    
                    # has been fired (display pylons or not)
                    var myFired = substr(myString, myIndexArray[i] + 2, 1) == 1;
                    #print(myFired);
                    
                    # what to put in weight[]/selected
                    var myWeightOptIndex = substr(myString, myIndexArray[i] + 3, size(myString) - (myIndexArray[i] + 2));
                    var myWeight = me.loadList[myWeightOptIndex];
                    #var myWeight = getprop("sim/weight["~ myWeightIndex ~"]/opt[" ~ myWeightOptIndex ~ "]/name");
                    #print(myWeight);
                    
                    # rebuilt the property Tree
                    me.mySelf.getNode("sim/weight["~ myWeightIndex ~"]/selected", 1).setValue(myWeight);
                    me.mySelf.getNode("controls/armament/station["~ myWeightIndex ~"]/release", 1).setValue(myFired);
                    
                    if(me.running == 1)
                    {
                        settimer(func(){ me.decode(); }, me.updateTime);
                    }
                }
            }
        }
        #print(me.mySelf.getName() ~ "["~ me.mySelf.getIndex() ~"]");
    },
    stop: func()
    {
        me.running = 0;
    },
};

#Here is where quick load management is managed...
#These functions can't be active when flying : This mean a little preparation for the mission
#It's an anti kiddo script
var Nav_LongRange = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[2]/selected", "none");
        setprop("sim/weight[5]/selected", "none");
        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[3]/selected", "none");

        setprop("sim/weight[13]/selected", "1500 l Droptank");
        setprop("consumables/fuel/tank[6]/selected", 1);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 397.50);
        setprop("consumables/fuel/tank[6]/level-gal_us", 396); 
                
        setprop("sim/weight[14]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[8]/selected", 1);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[8]/level-gal_us", 211);
        
        setprop("sim/weight[15]/selected", "1500 l Droptank");
        setprop("consumables/fuel/tank[7]/selected", 1);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 397.50);
        setprop("consumables/fuel/tank[7]/level-gal_us", 396); 
                
        setprop("sim/weight[7]/selected", "none");
        setprop("sim/weight[8]/selected", "none");
        setprop("sim/weight[9]/selected", "none");
        setprop("sim/weight[10]/selected", "none");
        FireableAgain();
     }
}

var Nav_MidRange = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[2]/selected", "none");
        setprop("sim/weight[5]/selected", "none");
        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[3]/selected", "none");

        setprop("sim/weight[13]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[6]/selected", 1);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[6]/level-gal_us", 211); 
                
        setprop("sim/weight[15]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[7]/selected", 1);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[7]/level-gal_us", 211); 
                
        setprop("sim/weight[7]/selected", "none");
        setprop("sim/weight[8]/selected", "none");
        setprop("sim/weight[9]/selected", "none");
        setprop("sim/weight[10]/selected", "none");
        FireableAgain();
     }
}

var Navigation = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[2]/selected", "none");
        setprop("sim/weight[5]/selected", "none");
        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[3]/selected", "none");
                
        setprop("sim/weight[14]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[8]/selected", 1);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[8]/level-gal_us", 211);
               
        setprop("sim/weight[7]/selected", "none");
        setprop("sim/weight[8]/selected", "none");
        setprop("sim/weight[9]/selected", "none");
        setprop("sim/weight[10]/selected", "none");
        setprop("sim/weight[13]/selected", "none");
        setprop("sim/weight[15]/selected", "none");
        FireableAgain();
     }
}

var Normal = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[1]/selected", "none");
        setprop("sim/weight[2]/selected", "none");
        setprop("sim/weight[3]/selected", "none");
        setprop("sim/weight[4]/selected", "none");                         
        setprop("sim/weight[5]/selected", "none");
        setprop("sim/weight[6]/selected", "none");        
        setprop("sim/weight[7]/selected", "none");
        setprop("sim/weight[8]/selected", "none");
        setprop("sim/weight[9]/selected", "none");
        setprop("sim/weight[10]/selected", "none");        
        setprop("sim/weight[13]/selected", "none");
        setprop("sim/weight[14]/selected", "none");
        setprop("sim/weight[15]/selected", "none");
        FireableAgain();
     }
}

var Fox = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[2]/selected", "AIM120");
        setprop("sim/weight[5]/selected", "AIM120");
        setprop("sim/weight[0]/selected", "AIM132");
        setprop("sim/weight[3]/selected", "AIM132");

        setprop("sim/weight[14]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[8]/selected", 1);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[8]/level-gal_us", 211);
        
        setprop("sim/weight[7]/selected", "AIM120");
        setprop("sim/weight[8]/selected", "AIM120");
        setprop("sim/weight[9]/selected", "AIM120");
        setprop("sim/weight[10]/selected", "AIM120");
        FireableAgain();
     }
}

var Bravo = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM9");
        setprop("sim/weight[12]/selected", "AIM9");
        setprop("sim/weight[2]/selected", "AIM120");
        setprop("sim/weight[5]/selected", "AIM120");
        setprop("sim/weight[0]/selected", "AIM132");
        setprop("sim/weight[3]/selected", "AIM132");
        
        setprop("sim/weight[13]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[6]/selected", 1);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[6]/level-gal_us", 211); 
                
        setprop("sim/weight[15]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[7]/selected", 1);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[7]/level-gal_us", 211); 
        
        setprop("sim/weight[7]/selected", "AIM120");
        setprop("sim/weight[8]/selected", "AIM120");
        setprop("sim/weight[9]/selected", "AIM120");
        setprop("sim/weight[10]/selected", "AIM120");
        FireableAgain();
    }
}

var NoLoad = func() {
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[1]/selected", "none");
        setprop("sim/weight[2]/selected", "none");
        setprop("sim/weight[3]/selected", "none");
        setprop("sim/weight[4]/selected", "none");                         
        setprop("sim/weight[5]/selected", "none");
        setprop("sim/weight[6]/selected", "none");        
        setprop("sim/weight[7]/selected", "none");
        setprop("sim/weight[8]/selected", "none");
        setprop("sim/weight[9]/selected", "none");
        setprop("sim/weight[10]/selected", "none");        
        setprop("sim/weight[11]/selected", "none");
        setprop("sim/weight[12]/selected", "none");
        setprop("sim/weight[13]/selected", "none");
        setprop("sim/weight[14]/selected", "none");
        setprop("sim/weight[15]/selected", "none");
        FireableAgain();        
     }
}

var Air_Ground = func() {
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM132");
        setprop("sim/weight[12]/selected", "AIM132");
        setprop("sim/weight[2]/selected", "ALARM");
        setprop("sim/weight[5]/selected", "ALARM");
        setprop("sim/weight[0]/selected", "GBU16");
        setprop("sim/weight[3]/selected", "GBU16");
        
        setprop("sim/weight[13]/selected", "1500 l Droptank");
        setprop("consumables/fuel/tank[6]/selected", 1);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 397.50);
        setprop("consumables/fuel/tank[6]/level-gal_us", 396); 

        setprop("sim/weight[6]/selected", "ALARM");                         
                
        setprop("sim/weight[15]/selected", "1500 l Droptank");
        setprop("consumables/fuel/tank[7]/selected", 1);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 397.50);
        setprop("consumables/fuel/tank[7]/level-gal_us", 396); 
        
        setprop("sim/weight[7]/selected", "AIM120");
        setprop("sim/weight[8]/selected", "AIM120");
        setprop("sim/weight[9]/selected", "AIM120");
        setprop("sim/weight[10]/selected", "AIM120");
        FireableAgain();
    }        
}

var Air_Ground_2 = func() {
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM132");
        setprop("sim/weight[12]/selected", "AIM132");
        setprop("sim/weight[2]/selected", "GBU16");
        setprop("sim/weight[5]/selected", "GBU16");
        setprop("sim/weight[0]/selected", "GBU16");
        setprop("sim/weight[3]/selected", "GBU16");
        
        setprop("sim/weight[13]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[6]/selected", 1);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[6]/level-gal_us", 211); 

        setprop("sim/weight[6]/selected", "ALARM");                         
                
        setprop("sim/weight[15]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[7]/selected", 1);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[7]/level-gal_us", 211); 
        
        setprop("sim/weight[7]/selected", "AIM120");
        setprop("sim/weight[8]/selected", "AIM120");
        setprop("sim/weight[9]/selected", "AIM120");
        setprop("sim/weight[10]/selected", "AIM120");
        FireableAgain();
    }
}

var Air_Ground_3 = func(){
    if(getprop("/gear/gear[2]/wow")==1){
        setprop("consumables/fuel/tank[6]/selected", 0);
        setprop("consumables/fuel/tank[6]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[6]/level-gal_us", 0);
        setprop("consumables/fuel/tank[7]/selected", 0);
        setprop("consumables/fuel/tank[7]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[7]/level-gal_us", 0);
        setprop("consumables/fuel/tank[8]/selected", 0);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 0);
        setprop("consumables/fuel/tank[8]/level-gal_us", 0);

        setprop("sim/weight[11]/selected", "AIM120");
        setprop("sim/weight[12]/selected", "AIM120");
        setprop("sim/weight[2]/selected", "GBU16");
        setprop("sim/weight[5]/selected", "GBU16");
        setprop("sim/weight[1]/selected", "STORMSHADOW");
        setprop("sim/weight[4]/selected", "STORMSHADOW");
        setprop("sim/weight[0]/selected", "none");
        setprop("sim/weight[3]/selected", "none");

        setprop("sim/weight[14]/selected", "1000 l Droptank");
        setprop("consumables/fuel/tank[8]/selected", 1);
        setprop("consumables/fuel/tank[8]/capacity-gal_us", 212);
        setprop("consumables/fuel/tank[8]/level-gal_us", 211);
        
        setprop("sim/weight[7]/selected", "AIM120");
        setprop("sim/weight[8]/selected", "AIM120");
        setprop("sim/weight[9]/selected", "AIM120");
        setprop("sim/weight[10]/selected", "AIM120");
        FireableAgain();
     }
}

var FireableAgain = func() {
       for(var i = 0 ;i < 16 ; i = i + 1 ){
          #to make it fireable again
          setprop("controls/armament/station["~ i ~"]/release", 0);
          
          #To add weight to pylons
          var select = getprop("sim/weight["~ i ~"]/selected");
          
          if(select=="none"){
                setprop("sim/weight["~ i ~"]/weight-lb",0);          
                setprop("controls/armament/station-occup["~ i ~"]",0);          
          }
          if(select=="AIM9"){
                setprop("sim/weight["~ i ~"]/weight-lb",190.0);          
                setprop("controls/armament/station-occup["~ i ~"]",1);          
          }
          if(select=="AIM132"){
                setprop("sim/weight["~ i ~"]/weight-lb",175.0);          
                setprop("controls/armament/station-occup["~ i ~"]",1);          
          }
          if(select=="AIM120"){
                setprop("sim/weight["~ i ~"]/weight-lb",330.0);          
                setprop("controls/armament/station-occup["~ i ~"]",2);          
          }
          if(select=="GBU16"){
                setprop("sim/weight["~ i ~"]/weight-lb",1094.0);          
                setprop("controls/armament/station-occup["~ i ~"]",3);          
          }
          if(select=="ALARM"){
                setprop("sim/weight["~ i ~"]/weight-lb",585.0);          
                setprop("controls/armament/station-occup["~ i ~"]",4);          
          }
          if(select=="Brimstone"){
                setprop("sim/weight["~ i ~"]/weight-lb",95.0);          
                setprop("controls/armament/station-occup["~ i ~"]",4);          
          }
          if(select=="1500 l Droptank"){
                setprop("sim/weight["~ i ~"]/weight-lb",260);          
                setprop("controls/armament/station-occup["~ i ~"]",6);          
          }
          if(select=="1000 l Droptank"){
                setprop("sim/weight["~ i ~"]/weight-lb",200);          
                setprop("controls/armament/station-occup["~ i ~"]",5);          
          }
          if(select=="STORMSHADOW"){
                setprop("sim/weight["~ i ~"]/weight-lb",2350.0);          
                setprop("controls/armament/station-occup["~ i ~"]",7);          
          }
       }
       setprop("controls/armament/name",getprop("sim/weight[0]/selected"));
}


# Begining of the dropable function.
# It has to be simplified and generic made
# Need to know how to make a table
dropLoad = func(number)
{
    var select = getprop("/sim/weight["~ number ~"]/selected");
    if(select != "none")
    {
        if(select == "1000 l Droptank" or select == "1500 l Droptank")
        {
            tank_submodel(number, select);
            setprop("/consumables/fuel/tank["~ number ~"]/selected", 0);
            setprop("/consumables/fuel/tank["~ number ~"]/capacity-m3", 0);
            setprop("/consumables/fuel/tank["~ number ~"]/level-kg", 0);
            setprop("/controls/armament/station["~ number ~"]/release", 1);
            setprop("/sim/weight["~ number ~"]/weight-lb", 0);
        }
        else
        {
            if(getprop("/controls/armament/station["~ number ~"]/release") == 0)
            {
                dropMissile(number);
            }
        }
    }
}

# Need to be changed
dropLoad_stop = func(n)
{
    #setprop("/controls/armament/station["~ n ~"]/release", 0);
}

dropMissile = func(number)
{
    var target = typhoon.myRadar3.GetTarget();
    var typeMissile = getprop("/sim/weight["~ number ~"]/selected");
    var isMissile = missile.Loading_missile(typeMissile);
    if(isMissile != 0)
    {
        if(target == nil)
        {
            return;
        }
        Current_missile = missile.MISSILE.new(number);
        Current_missile.status = 0;
        Current_missile.search(target);
        Current_missile.release();
        setprop("/sim/weight["~ number ~"]/weight-lb", 0);
    }
    setprop("/controls/armament/station["~ number ~"]/release", 1);
    after_fire_next(typeMissile);
}

dropInert = func (number) {
          var select = getprop("sim/weight["~ number ~"]/selected");
          if(select != "none"){
                if(select == "GBU16" or select == "AIM120" or select == "AIM9" or select == "AIM132" or select == "ALARM" or select == "STORMSHADOW"){
                     all_submodel(number,select);
                     setprop("controls/armament/station["~ number ~"]/release", 1);
                     setprop("sim/weight["~ number ~"]/weight-lb", 0);
                }else if(select == "1000 l Droptank" or select == "1500 l Droptank"){
                     all_submodel(number,select);
                     setprop("consumables/fuel/tank["~ number ~"]/selected", 0);
                     setprop("controls/armament/station["~ number ~"]/release", 1);
                     setprop("sim/weight["~ number ~"]/weight-lb", 0);
	           }
           }           
}

dropWeaponInert = func (number) {
          var select = getprop("sim/weight["~ number ~"]/selected");
          if(select != "none"){
                if(select == "GBU16" or select == "AIM120" or select == "AIM9" or select == "AIM132" or select == "ALARM" or select == "STORMSHADOW"){
                     weapon_submodel(number,select);
                     setprop("controls/armament/station["~ number ~"]/release", 1);
                     setprop("sim/weight["~ number ~"]/weight-lb", 0);
	           }
           }           
}

var tank_submodel = func (pylone, select){

        #1000 Tanks
        if(pylone == 13 and select == "1000 l Droptank"){ setprop("controls/armament/station[13]/release-L1000", 1);}
        if(pylone == 14 and select == "1000 l Droptank"){ setprop("controls/armament/station[14]/release-C1000", 1);}
        if(pylone == 15 and select == "1000 l Droptank"){ setprop("controls/armament/station[15]/release-R1000", 1);}

        #1500 Tanks
        if(pylone == 13 and select == "1500 l Droptank"){ setprop("controls/armament/station[13]/release-L1500", 1);}
        if(pylone == 15 and select == "1500 l Droptank"){ setprop("controls/armament/station[15]/release-R1500", 1);}
}

var weapon_submodel = func (pylone, select){

        #GBU
        if(pylone == 0 and select == "GBU16"){ setprop("controls/armament/station[0]/release-GBU16", 1);}
        if(pylone == 1 and select == "GBU16"){ setprop("controls/armament/station[1]/release-GBU16", 1);}
        if(pylone == 2 and select == "GBU16"){ setprop("controls/armament/station[2]/release-GBU16", 1);}
        if(pylone == 3 and select == "GBU16"){ setprop("controls/armament/station[3]/release-GBU16", 1);}
        if(pylone == 4 and select == "GBU16"){ setprop("controls/armament/station[4]/release-GBU16", 1);}
        if(pylone == 5 and select == "GBU16"){ setprop("controls/armament/station[5]/release-GBU16", 1);}
        #ALARM
        if(pylone == 0 and select == "ALARM"){ setprop("controls/armament/station[0]/release-ALARM", 1);}
        if(pylone == 1 and select == "ALARM"){ setprop("controls/armament/station[1]/release-ALARM", 1);}
        if(pylone == 2 and select == "ALARM"){ setprop("controls/armament/station[2]/release-ALARM", 1);}
        if(pylone == 3 and select == "ALARM"){ setprop("controls/armament/station[3]/release-ALARM", 1);}
        if(pylone == 4 and select == "ALARM"){ setprop("controls/armament/station[4]/release-ALARM", 1);}
        if(pylone == 5 and select == "ALARM"){ setprop("controls/armament/station[5]/release-ALARM", 1);}
        if(pylone == 6 and select == "ALARM"){ setprop("controls/armament/station[6]/release-ALARM", 1);}
        #STORMSHADOW
        if(pylone == 1 and select == "STORMSHADOW"){ setprop("controls/armament/station[1]/release-STORMSHADOW", 1);}
        if(pylone == 4 and select == "STORMSHADOW"){ setprop("controls/armament/station[4]/release-STORMSHADOW", 1);}
        if(pylone == 6 and select == "STORMSHADOW"){ setprop("controls/armament/station[6]/release-STORMSHADOW", 1);}
        #AIM132
        if(pylone == 0 and select == "AIM132"){ setprop("controls/armament/station[0]/release-AIM132", 1);}
        if(pylone == 1 and select == "AIM132"){ setprop("controls/armament/station[1]/release-AIM132", 1);}
        if(pylone == 2 and select == "AIM132"){ setprop("controls/armament/station[2]/release-AIM132", 1);}
        if(pylone == 3 and select == "AIM132"){ setprop("controls/armament/station[3]/release-AIM132", 1);}
        if(pylone == 4 and select == "AIM132"){ setprop("controls/armament/station[4]/release-AIM132", 1);}
        if(pylone == 5 and select == "AIM132"){ setprop("controls/armament/station[5]/release-AIM132", 1);}
        if(pylone == 11 and select == "AIM132"){ setprop("controls/armament/station[11]/release-AIM132", 1);}
        if(pylone == 12 and select == "AIM132"){ setprop("controls/armament/station[12]/release-AIM132", 1);}
        #AIM-9 Sidewinder
        if(pylone == 0 and select == "AIM9"){ setprop("controls/armament/station[0]/release-AIM9", 1);}
        if(pylone == 1 and select == "AIM9"){ setprop("controls/armament/station[1]/release-AIM9", 1);}
        if(pylone == 2 and select == "AIM9"){ setprop("controls/armament/station[2]/release-AIM9", 1);}
        if(pylone == 3 and select == "AIM9"){ setprop("controls/armament/station[3]/release-AIM9", 1);}
        if(pylone == 4 and select == "AIM9"){ setprop("controls/armament/station[4]/release-AIM9", 1);}
        if(pylone == 5 and select == "AIM9"){ setprop("controls/armament/station[5]/release-AIM9", 1);}
        if(pylone == 11 and select == "AIM9"){ setprop("controls/armament/station[11]/release-AIM9", 1);}
        if(pylone == 12 and select == "AIM9"){ setprop("controls/armament/station[12]/release-AIM9", 1);}
        #AMRAAM
        if(pylone == 0 and select == "AIM120"){ setprop("controls/armament/station[0]/release-AIM120", 1);}
        if(pylone == 1 and select == "AIM120"){ setprop("controls/armament/station[1]/release-AIM120", 1);}
        if(pylone == 2 and select == "AIM120"){ setprop("controls/armament/station[2]/release-AIM120", 1);}
        if(pylone == 3 and select == "AIM120"){ setprop("controls/armament/station[3]/release-AIM120", 1);}
        if(pylone == 4 and select == "AIM120"){ setprop("controls/armament/station[4]/release-AIM120", 1);}
        if(pylone == 5 and select == "AIM120"){ setprop("controls/armament/station[5]/release-AIM120", 1);}
        if(pylone == 11 and select == "AIM120"){ setprop("controls/armament/station[11]/release-AIM120", 1);}
        if(pylone == 12 and select == "AIM120"){ setprop("controls/armament/station[12]/release-AIM120", 1);}
}

var all_submodel = func (pylone, select){

        #GBU
        if(pylone == 0 and select == "GBU16"){ setprop("controls/armament/station[0]/release-GBU16", 1);}
        if(pylone == 1 and select == "GBU16"){ setprop("controls/armament/station[1]/release-GBU16", 1);}
        if(pylone == 2 and select == "GBU16"){ setprop("controls/armament/station[2]/release-GBU16", 1);}
        if(pylone == 3 and select == "GBU16"){ setprop("controls/armament/station[3]/release-GBU16", 1);}
        if(pylone == 4 and select == "GBU16"){ setprop("controls/armament/station[4]/release-GBU16", 1);}
        if(pylone == 5 and select == "GBU16"){ setprop("controls/armament/station[5]/release-GBU16", 1);}
        #ALARM
        if(pylone == 0 and select == "ALARM"){ setprop("controls/armament/station[0]/release-ALARM", 1);}
        if(pylone == 1 and select == "ALARM"){ setprop("controls/armament/station[1]/release-ALARM", 1);}
        if(pylone == 2 and select == "ALARM"){ setprop("controls/armament/station[2]/release-ALARM", 1);}
        if(pylone == 3 and select == "ALARM"){ setprop("controls/armament/station[3]/release-ALARM", 1);}
        if(pylone == 4 and select == "ALARM"){ setprop("controls/armament/station[4]/release-ALARM", 1);}
        if(pylone == 5 and select == "ALARM"){ setprop("controls/armament/station[5]/release-ALARM", 1);}
        if(pylone == 6 and select == "ALARM"){ setprop("controls/armament/station[6]/release-ALARM", 1);}
        #STORMSHADOW
        if(pylone == 1 and select == "STORMSHADOW"){ setprop("controls/armament/station[1]/release-STORMSHADOW", 1);}
        if(pylone == 4 and select == "STORMSHADOW"){ setprop("controls/armament/station[4]/release-STORMSHADOW", 1);}
        if(pylone == 6 and select == "STORMSHADOW"){ setprop("controls/armament/station[6]/release-STORMSHADOW", 1);}
        #AIM132
        if(pylone == 0 and select == "AIM132"){ setprop("controls/armament/station[0]/release-AIM132", 1);}
        if(pylone == 1 and select == "AIM132"){ setprop("controls/armament/station[1]/release-AIM132", 1);}
        if(pylone == 2 and select == "AIM132"){ setprop("controls/armament/station[2]/release-AIM132", 1);}
        if(pylone == 3 and select == "AIM132"){ setprop("controls/armament/station[3]/release-AIM132", 1);}
        if(pylone == 4 and select == "AIM132"){ setprop("controls/armament/station[4]/release-AIM132", 1);}
        if(pylone == 5 and select == "AIM132"){ setprop("controls/armament/station[5]/release-AIM132", 1);}
        if(pylone == 11 and select == "AIM132"){ setprop("controls/armament/station[11]/release-AIM132", 1);}
        if(pylone == 12 and select == "AIM132"){ setprop("controls/armament/station[12]/release-AIM132", 1);}
        #AIM-9 Sidewinder
        if(pylone == 0 and select == "AIM9"){ setprop("controls/armament/station[0]/release-AIM9", 1);}
        if(pylone == 1 and select == "AIM9"){ setprop("controls/armament/station[1]/release-AIM9", 1);}
        if(pylone == 2 and select == "AIM9"){ setprop("controls/armament/station[2]/release-AIM9", 1);}
        if(pylone == 3 and select == "AIM9"){ setprop("controls/armament/station[3]/release-AIM9", 1);}
        if(pylone == 4 and select == "AIM9"){ setprop("controls/armament/station[4]/release-AIM9", 1);}
        if(pylone == 5 and select == "AIM9"){ setprop("controls/armament/station[5]/release-AIM9", 1);}
        if(pylone == 11 and select == "AIM9"){ setprop("controls/armament/station[11]/release-AIM9", 1);}
        if(pylone == 12 and select == "AIM9"){ setprop("controls/armament/station[12]/release-AIM9", 1);}
        #AMRAAM
        if(pylone == 0 and select == "AIM120"){ setprop("controls/armament/station[0]/release-AIM120", 1);}
        if(pylone == 1 and select == "AIM120"){ setprop("controls/armament/station[1]/release-AIM120", 1);}
        if(pylone == 2 and select == "AIM120"){ setprop("controls/armament/station[2]/release-AIM120", 1);}
        if(pylone == 3 and select == "AIM120"){ setprop("controls/armament/station[3]/release-AIM120", 1);}
        if(pylone == 4 and select == "AIM120"){ setprop("controls/armament/station[4]/release-AIM120", 1);}
        if(pylone == 5 and select == "AIM120"){ setprop("controls/armament/station[5]/release-AIM120", 1);}
        if(pylone == 11 and select == "AIM120"){ setprop("controls/armament/station[11]/release-AIM120", 1);}
        if(pylone == 12 and select == "AIM120"){ setprop("controls/armament/station[12]/release-AIM120", 1);}
        #1000 Tanks
        if(pylone == 13 and select == "1000 l Droptank"){ setprop("controls/armament/station[13]/release-L1000", 1);}
        if(pylone == 14 and select == "1000 l Droptank"){ setprop("controls/armament/station[14]/release-C1000", 1);}
        if(pylone == 15 and select == "1000 l Droptank"){ setprop("controls/armament/station[15]/release-R1000", 1);}
        #1500 Tanks
        if(pylone == 13 and select == "1500 l Droptank"){ setprop("controls/armament/station[13]/release-L1500", 1);}
        if(pylone == 15 and select == "1500 l Droptank"){ setprop("controls/armament/station[15]/release-R1500", 1);}
}

# -1 is none
#  0 is A/A
#  1 is A/G
# -2 is fuel

var load_info = {
    "AIM120": 0,
    "AIM132": 0,
    "AIM9": 0,
    "ALARM": 1,
    "STORMSHADOW": 1,
    "Brimstone": 1,
    "GBU16": 1,
    "none": -1,
    "1500 l Droptank": 2,
    "1000 l Droptank": 2,
};

var increased_selected_pylon = func(){
     var SelectedPylon = getprop("controls/armament/missile/current-pylon");
     var mode = getprop("controls/armament/stick-selector") - 2; # if this prop is 2, we're in A/A, if this prop is 3 we are in A/G
     
     if ( mode < 0 ) {
        return nil;
     }

     var out = 0;
     var mini = loadsmini();
     var max = loadsmaxi();
     if(SelectedPylon==max){SelectedPylon=-1;}
     
     for(var i = SelectedPylon+1 ;i < 16 ; i = i + 1 ){
            if( load_info[getprop("sim/weight["~ i ~"]/selected")] == mode ){
                if(getprop("sim/weight["~ i ~"]/weight-lb")>1){
                   if(mini==-1){mini = i;}
                   max = i;
                   if(out == 0){
                        #print(i);
                        SelectedPylon = i;
                        out = 1;
                   }
                }            
            }
      }
      if(SelectedPylon == getprop("controls/armament/missile/current-pylon")){SelectedPylon = mini;}
      setprop("controls/armament/name",getprop("sim/weight["~ SelectedPylon ~"]/selected"));
      setprop("controls/armament/missile/current-pylon",SelectedPylon);
}

var decreased_selected_pylon = func(){
     var SelectedPylon = getprop("controls/armament/missile/current-pylon");
     var mode = getprop("controls/armament/stick-selector") - 2; # if this prop is 2, we're in A/A, if this prop is 3 we are in A/G
     
     if ( mode < 0 ) {
        return nil;
     }
     
     var out = 0;
     var mini = loadsmini();
     var max = loadsmaxi();
     if(SelectedPylon==mini){SelectedPylon=16;}
     
     for(var i = SelectedPylon-1 ;i >-1 ; i = i - 1 ){
            if( load_info[getprop("sim/weight["~ i ~"]/selected")] == mode ){
                if(getprop("sim/weight["~ i ~"]/weight-lb")>1){
                   if(max==16){max = i;}
                   mini = i;
                   if(out == 0){
                        #print(i);
                        SelectedPylon = i;
                        out = 1;
                   }
                }            
            }
      }
      if(SelectedPylon == getprop("controls/armament/missile/current-pylon")){SelectedPylon = mini;}
      setprop("controls/armament/name",getprop("sim/weight["~ SelectedPylon ~"]/selected"));
      setprop("controls/armament/missile/current-pylon",SelectedPylon);
}

#smallest index of load
var loadsmini = func(){
        var out = 0;        
        for(var i = 0 ;i < 16 ; i = i + 1 ){
                if(getprop("sim/weight["~ i ~"]/weight-lb")>1){
                   if(out == 0){
                        #print("i:",i);
                        var mini = i;
                        out = 1;
                   }
                   var maxi = i;
                }
         }
         return mini;
}

#Biggt index of load
var loadsmaxi = func(){
        var out = 0;
        for(var i = 0 ;i < 16 ; i = i + 1 ){
                if(getprop("sim/weight["~ i ~"]/weight-lb")>1){
                   if(out == 0){
                        #print("i:",i);
                        var mini = i;
                        out = 1;
                   }
                   var maxi = i;
                }
         }
         return maxi;
}
        

#next missile after fire
var after_fire_next = func(typeMissile){
       var SelectedPylon = getprop("controls/armament/missile/current-pylon");
    
        #if(SelectedPylon == 0){SelectedPylon =3;}elsif(SelectedPylon == 3){SelectedPylon =0;}
        #if(SelectedPylon == 1){SelectedPylon =4;}elsif(SelectedPylon == 4){SelectedPylon =1;}
        #if(SelectedPylon == 2){SelectedPylon =5;}elsif(SelectedPylon == 5){SelectedPylon =2;}
        #if(SelectedPylon == 7){SelectedPylon =9;}elsif(SelectedPylon == 9){SelectedPylon =7;}
        #if(SelectedPylon == 8){SelectedPylon =10;}elsif(SelectedPylon == 10){SelectedPylon =8;}
        #if(SelectedPylon == 11){SelectedPylon =12;}elsif(SelectedPylon == 12){SelectedPylon =11;}
        #if(SelectedPylon == 13){SelectedPylon =15;}elsif(SelectedPylon == 15){SelectedPylon =13;}
         
        #find our next pylon
        var nf = 0;

        #see if there's another of the same type, and if so, select it.
        for(var i = 0; i < 16; i = i + 1) {
            if ( i != SelectedPylon and getprop("sim/weight["~i~"]/selected") == typeMissile ) {
                SelectedPylon = i;
                nf = 1;
            }
        }

        #otherwise, lets just increase the pylon.
        if ( nf == 0 ) {
            increased_selected_pylon();
        }

        if(getprop("sim/weight["~ SelectedPylon ~"]/weight-lb")<1){
            for(var i = 0 ;i < 16 ; i = i + 1 ){
                if(getprop("sim/weight["~ i ~"]/weight-lb")>1){
                    #print("i:",i);
                    SelectedPylon = i;
                    setprop("controls/armament/name",getprop("sim/weight["~ SelectedPylon ~"]/selected"));
                    setprop("controls/armament/missile/current-pylon",SelectedPylon);
                    return;
                }
            }       
        }

        
        #print("Test1:",SelectedPylon);
}
