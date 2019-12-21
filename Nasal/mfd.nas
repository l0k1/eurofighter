var MFD_SCREEN = {

    new: func(placement, name) {
        var m = {parents: [MFD_SCREEN]};
        m.mfd = canvas.new({
                            "name": name,
                            "size": [1024, 1024],
                            "view": [1024, 1024],
                            "mipmapping": 1
                        });


        m.cur_main_func = nil;
        m.cur_init_func = nil;
        m.cur_end_func = nil;
        m.cur_state = nil;
        
        ###############################
        ###################### settings
        ###############################
        m.font_size = 21;
        m.font = "led-5-7.txf";
        
        m.mfd.addPlacement(placement);

        m.mfd.setColorBackground(1,0,0,1);
        m.test = m.mfd.createGroup();

        m.test.createChild("text")
            .setTranslation(500,500)
            .setFontSize(40)
            .setText("YOLO")
            .setColor(1,1,1,1);

        m.test.show();

        return m;
    },

    
    main_loop: func() {
        # check for electricity power
        if (me.cur_state != hud_state_off and prop_io.hud_power < 0.8) {
            me.change_state(hud_state_off);
        } elsif (me.cur_state == hud_state_off and prop_io.hud_power > 0.8) {
            me.change_state(hud_dev_mode);
        }
        if (me.cur_main_func != nil) {
            call(me.cur_main_func, nil, hud_ref );
        }
    },
    
};

mfd_left = MFD_SCREEN.new({"node": "MFDLeftPlane"},"mfdleft");
mfd_center = MFD_SCREEN.new({"node": "MFDCenterPlane"},"mfdcenter");
mfd_right = MFD_SCREEN.new({"node": "MFDRightPlane"},"mfdright");

var interp = func(x,x0,x1,y0,y1) {
    return y0 + (x - x0) * ((y1 - y0) / (x1 - x0));
}

var state_arch = {
        main_func: nil,
        init_func: nil,
        end_func:  nil,
        temp:        0,
};

# main modes
# run the init once, loop the main, and then before the mode gets switched again it will run the end function
#var hud_state_off = {parents: [state_arch], main_func: hud_ref.off_mode_update, init_func: hud_ref.off_mode_init};
#var hud_dev_mode  = {parents: [state_arch], main_func: hud_ref.dev_mode_update, init_func: hud_ref.dev_mode_init};

# temps
# if temp == 1, it will only fire the init, main, and end functions once.
#var hud_switch_gs_m = {parents: [state_arch], main_func: hud_ref.groundspeed_mach_switch, temp: 1};

#hud_ref.change_state(hud_dev_mode);
