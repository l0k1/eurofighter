var MFD_SCREEN = {

    new: func(placement, name) {
        var m = {parents: [MFD_SCREEN]};
        m.mfd = canvas.new({
                            "name": name,
                            "size": [1024, 1024],
                            "view": [1024, 1024],
                            "mipmapping": 1
                        });
        # can use the full 1024 pixels yay

        m.cur_main_func = nil;
        m.cur_init_func = nil;
        m.cur_end_func = nil;
        m.cur_state = nil;
        
        ###############################
        ###################### settings
        ###############################
        m.font_size = 30;
        m.font = "arial_black.txf";
        
        m.mfd.addPlacement(placement);

        m.mfd.setColorBackground(0,0,0,1);
        m.white = [1,1,1,1];
        m.offwhite = [1,0.98,0.95,1];
        m.blue = [0,0,1,1];
        m.lw = 4;

        ##################################################
        # ENGINE PAGE
        ##################################################

        m.engine_page = m.mfd.createGroup();

        # settings
        m.ep_cw = 228;
        m.ep_cwh = m.ep_cw / 2;
        m.blue_width = 8;
        m.white_width = 18;
        m.gauge_width = 5;

        # blue circles
        m.engine_page.createChild("path")
                                .moveTo(246 - m.ep_cwh, 200)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .moveTo(246 - m.ep_cwh, 846)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .moveTo(778 - m.ep_cwh, 200)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .moveTo(778 - m.ep_cwh, 846)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .setStrokeLineWidth(m.blue_width)
                                .setColor(m.blue);

        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("AJ")
                                .setTranslation(223,135);
        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("AJ")
                                .setTranslation(758,135);
        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("NL")
                                .setTranslation(223,292);
        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("NL")
                                .setTranslation(758,292);

        m.n1_readout_left = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(223,243);

        m.n1_readout_right = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(757,243);

        m.aj_readout_left = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(236,184);

        m.aj_readout_right = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(768,184);

        m.temp_readout_left = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(106,837);

        m.temp_readout_right = m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(640,837);


        m.n1_gauge_left = m.engine_page.createChild("path")
                                .setTranslation(246,200 - m.ep_cwh)
                                .setStrokeLineWidth(m.white_width)
                                .setColor(m.white);
        m.n1_gauge_right = m.engine_page.createChild("path")
                                .setTranslation(778,200 - m.ep_cwh)
                                .setStrokeLineWidth(m.white_width)
                                .setColor(m.white);
        m.tbt_gauge_left = m.engine_page.createChild("path")
                                .setTranslation(246,846 - m.ep_cwh)
                                .setStrokeLineWidth(m.white_width)
                                .setColor(m.white);
        m.tbt_gauge_right = m.engine_page.createChild("path")
                                .setTranslation(778,846 - m.ep_cwh)
                                .setStrokeLineWidth(m.white_width)
                                .setColor(m.white);

        m.engine_page.show();
        return m;
    },

    off_mode_init: func() {
        me.engine_page.hide();
    },
    off_mode_update: func() {
        # the hud is off, we do nothing
        return;
    },
    
    dev_mode_init: func() {
        me.engine_page.show();
    },
    
    dev_mode_update: func() {
        me.engine_screen();
    },

    engine_screen: func() {
        me.angle = (180 / 80 * prop_io.engine0_n1) - 90;
        me.x = me.ep_cwh * math.cos(me.angle * D2R);
        me.y = me.ep_cwh * math.sin(me.angle * D2R) + me.ep_cwh;
        if (me.angle > 90) {
            me.n1_gauge_left.reset()
                            .arcLargeCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        } else {
            me.n1_gauge_left.reset()
                            .arcSmallCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        }
        me.angle = (180 / 80 * prop_io.engine1_n1) - 90;
        me.x = me.ep_cwh * math.cos(me.angle * D2R);
        me.y = me.ep_cwh * math.sin(me.angle * D2R) + me.ep_cwh;
        if (me.angle > 90) {
            me.n1_gauge_right.reset()
                            .arcLargeCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        } else {
            me.n1_gauge_right.reset()
                            .arcSmallCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        }
        me.n1_readout_left.setText(sprintf("%.1f",prop_io.engine0_n1));
        me.n1_readout_right.setText(sprintf("%.1f",prop_io.engine1_n1));
        me.aj_readout_left.setText(int(100 * prop_io.engine0_nz));
        me.aj_readout_right.setText(int(100 * prop_io.engine1_nz));
        return;
    },
        
    change_state: func(state) {
        if (state.main_func == nil) { return; }
        if (state.temp == 0) {
            me.cur_state = state;
            if (me.cur_end_func != nil) {
                #print('calling the end func');
                call(me.cur_end_func, nil, me);
            }
            me.cur_main_func = state.main_func;
            me.cur_init_func = state.init_func;
            me.cur_end_func = state.end_func;
            if (me.cur_init_func != nil) {
                #print('calling the init func');
                call(me.cur_init_func, nil, me);
            }
        } else if (state.temp == 1) {
            if (state.init_func != nil) {
                call(state.init_func, nil, me);
            }
            if (state.main_func != nil) {
                call(state.main_func, nil, me);
            }
            if (state.end_func != nil) {
                call(state.end_func, nil, me);
            }
        }
    },

    main_loop: func() {
        # check for electricity power
        #if (me.cur_state != hud_state_off and prop_io.hud_power < 0.8) {
        #    me.change_state(hud_state_off);
        #} elsif (me.cur_state == hud_state_off and prop_io.hud_power > 0.8) {
        #    me.change_state(hud_dev_mode);
        #}
        if (me.cur_main_func != nil) {
            call(me.cur_main_func, nil, me);
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
var mfd_off         = {parents: [state_arch], main_func: MFD_SCREEN.off_mode_update,   init_func: MFD_SCREEN.off_mode_init};
var mfd_dev_mode    = {parents: [state_arch], main_func: MFD_SCREEN.dev_mode_update,   init_func: MFD_SCREEN.dev_mode_init};

# temps
# if temp == 1, it will only fire the init, main, and end functions once.
#var hud_switch_gs_m = {parents: [state_arch], main_func: hud_ref.groundspeed_mach_switch, temp: 1};

#hud_ref.change_state(hud_dev_mode);
mfd_left.change_state(mfd_dev_mode);
mfd_center.change_state(mfd_dev_mode);
mfd_right.change_state(mfd_dev_mode);
