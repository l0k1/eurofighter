var interp = func(x,x0,x1,y0,y1) {
    return y0 + (x - x0) * ((y1 - y0) / (x1 - x0));
}

var LEFT = 0;
var CENTER = 1;
var RIGHT = 2;

var MFD_SCREEN = {

    new: func(placement, name, position) {
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
        m.pos = position;
        m.buttons = [];
        for (var i = 0; i < 15; i = i + 1) {
            if (m.pos == LEFT) {
                append(m.buttons,MFD_BUTTON.new({"node": "changeme"},"bleft" ~ i,LEFT));
            } else if (m.pos == CENTER) {
                append(m.buttons,MFD_BUTTON.new({"node": "changeme"},"bcenter" ~ i,CENTER));
            } else if (m.pos == RIGHT) {
                append(m.buttons,MFD_BUTTON.new({"node": "changeme"},"bright" ~ i,RIGHT));
            }
        }
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
        me.clear_buttons();
        me.update_buttons();
        me.engine_page.hide();
    },
    off_mode_update: func() {
        # the hud is off, we do nothing
        return;
    },
    
    dev_mode_init: func() {
        me.engine_page.show();
        me.clear_buttons();
        me.buttons[0].page = mfd_engine;
        me.update_buttons();
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

    clear_buttons: func() {
        for (me.i = 0; me.i < 15; me.i = me.i + 1) {
            me.buttons[me.i].page = mfd_null;
        }
    },

    update_buttons: func() {
        for (me.i = 0; me.i < 15; me.i = me.i + 1) {
            me.buttons[me.i].update();
        }
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

var MFD_BUTTON = {

    new: func(placement, name, position) {
        var m = {parents: [MFD_BUTTON]};
        m.width = 128;
        m.height = 128;
        m.button = canvas.new({
                            "name": name,
                            "size": [m.width, m.height],
                            "view": [m.width, m.height],
                            "mipmapping": 1
                        });
        m.bt = m.button.createGroup();
        ###############################
        # settings
        ###############################
        m.page = nil; # mfd hash assigned to button
        
        m.pos = position; # left = 0, center = 1, right = 2;
        
        m.font_size = 30;
        m.font = "arial_black.txf";
        
        m.button.addPlacement(placement);

        m.button.setColorBackground(0,0,0,1);
        m.white = [1,1,1,1];
        m.offwhite = [1,0.98,0.95,1];
        m.yellow = [1,1,0,1];
        m.blue = [0,0,1,1];
        m.lw = 4;
        m.line_offset = 16;
        
        ###############################
        # settings
        ###############################

        m.top_line = m.bt.createChild("path")
                                .setStrokeLineWidth(m.lw)
                                .setColor(m.yellow)
                                .move(0,m.line_offset)
                                .line(m.width,0)
                                .hide();
        m.mid_line = m.bt.createChild("path")
                                .setStrokeLineWidth(m.lw)
                                .setColor(m.yellow)
                                .move(0,m.height / 2)
                                .line(m.width,0)
                                .hide();
        m.bottom_line = m.bt.createChild("path")
                                .setStrokeLineWidth(m.lw)
                                .setColor(m.yellow)
                                .move(0,m.height - m.line_offset)
                                .line(m.width,0)
                                .hide();

        m.top_text = m.bt.createChild("text")
                                .setAlignment("left-center")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.yellow)
                                .setTranslation(14,m.height/3);
        m.bottom_text = m.bt.createChild("text")
                                .setAlignment("left-center")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.yellow)
                                .setTranslation(14,m.height/3*2);
    },
    press: func() {
        if (me.pos == LEFT) {
            mfd_left.change_state(me.page);
        } else if (me.pos == CENTER) {
            mfd_center.change_state(me.page);
        } else if (me.pos == RIGHT) {
            mfd_right.change_state(me.page);
        }
    },
    clear: func() {
        me.top_text.setText("");
        me.bottom_text.setText("");
        me.page = mfd_null;
    },
    update: func(state = nil) {
        if (state != nil) {
            me.page = state;
        }
        me.top_text.setText(me.page.top_label);
        me.bottom_text.setText(me.page.bottom_label);
        me.top_line.setVisible(me.page.top_line);
        me.mid_line.setVisible(me.page.center_line);
        me.bottom_line.setVisible(me.page.bottom_line);
    },
    top_lines: func() {
        me.top_line.show();
        me.mid_line.show();
        me.bottom_line.hide();
    },
    bottom_lines: func() {
        me.top_line.hide();
        me.mid_line.show();
        me.bottom_line.show();
    },
    surround_lines: func() {
        me.top_line.show();
        me.mid_line.hide();
        me.bottom_line.show();
    },
    all_lines: func() {
        me.top_line.show();
        me.mid_line.show();
        me.bottom_line.show();
    },
    no_lines: func() {
        me.top_line.hide();
        me.mid_line.hide();
        me.bottom_line.hide();
    },
};

mfd_left = MFD_SCREEN.new({"node": "MFDLeftPlane"}, "mfdleft", LEFT);
mfd_center = MFD_SCREEN.new({"node": "MFDCenterPlane"}, "mfdcenter", CENTER);
mfd_right = MFD_SCREEN.new({"node": "MFDRightPlane"}, "mfdright", RIGHT);

var state_arch = {
        label_top:   "",
        label_bottom: "",
        top_line:    0,
        center_line: 0,
        bottom_line: 0,
        main_func: nil,
        init_func: nil,
        end_func:  nil,
        temp:        0,
};

# main modes
# run the init once, loop the main, and then before the mode gets switched again it will run the end function
var mfd_null        = {parents: [state_arch]};
var mfd_off         = {parents: [state_arch],                    main_func: MFD_SCREEN.off_mode_update,    init_func: MFD_SCREEN.off_mode_init};
var mfd_dev_mode    = {parents: [state_arch],                    main_func: MFD_SCREEN.dev_mode_update,    init_func: MFD_SCREEN.dev_mode_init};
var mfd_engine      = {parents: [state_arch], label_top: "ENGI", main_func: MFD_SCREEN.dev_mode_update,    init_func: MFD_SCREEN.dev_mode_init};

# temps
# if temp == 1, it will only fire the init, main, and end functions once.
#var hud_switch_gs_m = {parents: [state_arch], main_func: hud_ref.groundspeed_mach_switch, temp: 1};

mfd_left.change_state(mfd_dev_mode);
mfd_center.change_state(mfd_dev_mode);
mfd_right.change_state(mfd_dev_mode);