var HUD_SCREEN = {

    canvas_settings: {
        "name": "HUD_SCREEN",
        "size": [1024, 1024],
        "view": [1024, 1024],
        "mipmapping": 1
    },
    new: func(placement) {
        var m = {
            parents: [HUD_SCREEN],
            hud: canvas.new(HUD_SCREEN.canvas_settings)
        };
        
        ###############################
        ###################### settings
        ###############################
        
        m.update_rate = 0.1;
        
        m.line_width = 3;
        m.dot_circ = 5;
        
        m.font_size = 18;
        m.font = "led-5-7.txf";
        
        m.red = 0.3;
        m.green = 1.0;
        m.blue = 0.15;
        
        # pitch bars
        m.pitch_bars_deg_shown = 25;
        m.pitch_bars_deg_spacing = 5;
        m.pitch_bars_size_percent = 0.8; # how much of the hud-y to use for max size
        
        ###############################
        ##################### constants
        ###############################
        
        m.x_res_norm = m.canvas_settings["view"][0] / 1024; # dont change the 1024!
        m.y_res_norm = m.canvas_settings["view"][1] / 1024; # dont change the 852!
        m.avg_norm = (m.x_res_norm + m.y_res_norm) / 2;

        m.hud.addPlacement(placement);
        m.hud.setColorBackground(m.red,m.green,m.blue,0);
        
        ###############################
        ## pitch bars
        ###############################
        
        m.pitch_bars_height = m.canvas_settings["view"][0] * m.pitch_bars_size_percent * m.y_res_norm;
        m.pitch_px_per_degree = m.pitch_bars_height / m.pitch_bars_deg_shown;
        m.pitch_bottom = m.canvas_settings["view"][1] / 2 + m.pitch_bars_height / 2;
        m.pitch_top = m.canvas_settings["view"][1] / 2 - m.pitch_bars_height / 2;
        m.pitch_center_y = (m.pitch_bottom + m.pitch_top) / 2;
        m.pitch_bars_down = [];
        m.pitch_bars_up = [];
        m.pitch_bars_text = [];
                
        # create the actual lines
        m.pitch_bars_canvas_group = m.hud.createGroup();
        m.pitch_bars_canvas_group.setTranslation(m.canvas_settings["view"][0] / 2, m.canvas_settings["view"][1] / 2);
        m.pitch_bar_center = m.pitch_bars_canvas_group.createChild("path")
                                    .move(-273,0)
                                    .line(235,0)
                                    .line(0,15)
                                    .move(76,0)
                                    .line(0,-15)
                                    .line(235,0)
                                    .setStrokeLineWidth(m.line_width)
                                    .setColor(m.red,m.green,m.blue);
        for(var i = 0; i < m.pitch_bars_deg_shown / m.pitch_bars_deg_spacing; i = i + 1) {
            append(m.pitch_bars_down, m.pitch_bars_canvas_group.createChild("path")
                                        .move(-123,-17)
                                        .line(0,17)
                                        .line(19,0)
                                        .move(14,0)
                                        .line(18,0)
                                        .line(8,-9)
                                        .line(8,9)
                                        .line(18,0)
                                        .move(76,0)
                                        .line(18,0)
                                        .line(8,-9)
                                        .line(8,9)
                                        .line(18,0)
                                        .move(14,0)
                                        .line(19,0)
                                        .line(0,-17)
                                        .setStrokeLineWidth(m.line_width)
                                        .setColor(m.red,m.green,m.blue));
            append(m.pitch_bars_up, m.pitch_bars_canvas_group.createChild("path")
                                        .move(-125,17)
                                        .line(0,-17)
                                        .line(87,0)
                                        .move(76,0)
                                        .line(87,0)
                                        .line(0,17)
                                        .setStrokeLineWidth(m.line_width)
                                        .setColor(m.red,m.green,m.blue));
            append(m.pitch_bars_text, m.pitch_bars_canvas_group.createChild("text")
                                        .setAlignment("left-center")
                                        .setFontSize(m.font_size)
                                        .setFont(m.font)
                                        .setColor(m.red,m.green*2,m.blue,1));
        }
        
        ###############################
        ## flight direction indicators
        ###############################
        
        m.flight_dir_indicators = m.hud.createGroup();
        m.climbdive_symbol = m.flight_dir_indicators.createChild("path")
                                .move(-9,0)
                                .arcSmallCW(9,9,0,18,0)
                                .arcSmallCW(9,9,0,-18,0)
                                .line(-25,0)
                                .move(43,0)
                                .line(25,0)
                                .setStrokeLineWidth(m.line_width)
                                .setColor(m.red,m.green,m.blue);
        m.attitude_symbol = m.flight_dir_indicators.createChild("path")
                                .move(-34,0)
                                .line(68,0)
                                .move(-43,9)
                                .line(9,-18)
                                .line(9,18)
                                .setStrokeLineWidth(m.line_width)
                                .setColor(m.red,m.green,m.blue)
                                .setTranslation(m.canvas_settings["view"][0] / 2,m.canvas_settings["view"][0] / 2);
        m.velocity_vector = m.flight_dir_indicators.createChild("path")
                                .move(-8,0)
                                .line(8,9)
                                .line(8,-9)
                                .line(-8,-9)
                                .line(-8,9)
                                .setStrokeLineWidth(m.line_width)
                                .setColor(m.red,m.green,m.blue);
        
        ###############################
        ## compass
        ###############################
        m.compass_spread_deg = 35; # per hud image in docs?
        m.compass_dot_spread_deg = 5; # per hud image in docs
        m.compass_dot_spread_px = 34;
        
        m.compass_px_per_degree = m.compass_dot_spread_px / m.compass_dot_spread_deg;
        m.compass_total_spread = m.compass_spread_deg + m.compass_dot_spread_deg;
        m.compass_left_limit = (m.compass_total_spread / 2) * m.compass_px_per_degree * -1;
        
        m.compass = m.hud.createGroup();
        m.compass.setTranslation(m.canvas_settings["view"][0] / 2, m.canvas_settings["view"][1] / 2 - 316);
        m.compass_dots = [];
        m.compass_text = [];
        for (var i = 0; i < m.compass_spread_deg / m.compass_dot_spread_deg + 1; i = i + 1) {
            append(m.compass_dots, m.compass.createChild("path")
                                    .move(-m.dot_circ/2,0)
                                    .arcSmallCW(m.dot_circ/2, m.dot_circ/2,0,m.dot_circ, 0)
                                    .arcSmallCW(m.dot_circ/2, m.dot_circ/2,0,-m.dot_circ, 0)
                                    .setColor(m.red,m.green,m.blue)
                                    .setColorFill(m.red,m.green,m.blue));
            if (math.mod(i,2) == 0) {
                append(m.compass_text, m.compass.createChild("text")
                                        .setAlignment("center-bottom")
                                        .setFontSize(m.font_size)
                                        .setFont(m.font)
                                        .setColor(m.red,m.green,m.blue,1));
            }
        }
        m.compass_heading_marker = m.compass.createChild("path")
                                    .move(0,3)
                                    .line(0,21)
                                    .move(0,-21)
                                    .line(-8,14)
                                    .move(8,-14)
                                    .line(8,14)
                                    .setColor(m.red,m.green,m.blue)
                                    .setStrokeLineWidth(m.line_width/2);
        m.compass_route_marker = m.compass.createChild("path")
                                    .move(0,-3)
                                    .move(-8,-20)
                                    .arcSmallCW(12,12,0,16,0)
                                    .setColor(m.red,m.green,m.blue)
                                    .setStrokeLineWidth(m.line_width)
                                    .hide();
                                    
        
        ###############################
        ## altitude circle
        ###############################
        m.alt_num_dots = 10;
        m.alt_circle_radius = 92 / 2;
        m.alt_line_inner_radius = 30;
        m.alt_line_outer_radius = 46;
        m.alt_rotations_per_foot = 1/1000; # one rotation every thousand feet
        
        m.alt_deg_per_dot = 360 / m.alt_num_dots;
        
        m.alt_display = m.hud.createGroup();
        m.alt_display.setTranslation(m.canvas_settings["view"][0] / 2 + 211, m.canvas_settings["view"][1] / 2 - 233);
        m.alt_dots = [];
        
        for (var i = 0; i < m.alt_num_dots; i = i + 1) {
            m.angle = (i * m.alt_deg_per_dot + 180) * D2R;
            m.x = math.sin(m.angle) * m.alt_circle_radius;
            m.y = math.cos(m.angle) * m.alt_circle_radius;
            #print(m.x ~ "|" ~ m.y);
            append(m.alt_dots, m.alt_display.createChild("path")
                                    .move(-m.dot_circ/2,0)
                                    .arcSmallCW(m.dot_circ/2, m.dot_circ/2,0,m.dot_circ, 0)
                                    .arcSmallCW(m.dot_circ/2, m.dot_circ/2,0,-m.dot_circ, 0)
                                    .setTranslation(m.x,m.y)
                                    .setColor(m.red,m.green,m.blue)
                                    .setColorFill(m.red,m.green,m.blue));
        }
        m.alt_line = m.alt_display.createChild("path")
                                    .move(0,-m.alt_line_outer_radius)
                                    .line(0,m.alt_line_inner_radius)
                                    .setColor(m.red,m.green,m.blue)
                                    .setStrokeLineWidth(m.line_width);
        m.alt_text = m.alt_display.createChild("text")
                                    .setAlignment("center-center")
                                    .setFontSize(m.font_size)
                                    .setFont(m.font)
                                    .setColor(m.red,m.green,m.blue,1);
            
        
        ###############################
        ## vertical speed indicator
        ###############################
        
        ###############################
        ## IAS text
        ###############################
        m.ias_text = m.hud.createGroup().createChild("text")
                            .setAlignment("center-center")
                            .setFontSize(m.font_size)
                            .setFont(m.font)
                            .setColor(m.red,m.green,m.blue,1)
                            .setTranslation(m.canvas_settings["view"][0] / 2 - 156, m.canvas_settings["view"][1] / 2 - 128);
                                    
        
        #m.test_group = m.hud.createGroup();
        #m.test_text = m.test_group.createChild("text").setAlignment("center-center").setFontSize(50).setTranslation(512,512).setColor(0,1,0).setFont(m.font).setText("foo").show();
        return m;
    },
    
    update: func() {
        
        ###############################
        ## ias
        ###############################
        
        ias_text.setText(sprintf("%i",prop_io.airspeed))
        
        ###############################
        ## pitch bars
        ###############################
        me.pitch_bars_canvas_group.setRotation(-prop_io.roll * D2R);
        
        # determine bottom bar location
        me.b_line = (me.pitch_bars_height - me.pitch_px_per_degree * me.pitch_bars_deg_spacing) + 
                            (math.mod(prop_io.pitch,me.pitch_bars_deg_spacing) * me.pitch_px_per_degree);
        # me.b_pitch is propably off by a spacing or two
        me.b_pitch = prop_io.pitch - math.mod(prop_io.pitch, me.pitch_bars_deg_spacing) - 
                            ((me.pitch_bars_deg_shown / 2) - (math.mod(me.pitch_bars_deg_shown / 2, me.pitch_bars_deg_spacing)));
        me.pitch_bar_center.hide();
        for(var i = 0; i < me.pitch_bars_deg_shown / me.pitch_bars_deg_spacing; i = i + 1) {
            #print('updating i: ' ~ me.b_pitch ~ " " ~ me.b_line);
            if (me.b_line < me.pitch_bottom and me.b_line > me.pitch_top) {
                if (me.b_pitch < 0) {
                    me.pitch_bars_down[i].setTranslation(0,me.b_line - me.pitch_center_y).show();
                    me.pitch_bars_up[i].hide();
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-115 * me.x_res_norm,me.b_line - 25 - me.pitch_center_y).show();
                } elsif (me.b_pitch > 0) {
                    me.pitch_bars_up[i].setTranslation(0,me.b_line - me.pitch_center_y).show();
                    me.pitch_bars_down[i].hide();
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-115 * me.x_res_norm,me.b_line + 25 - me.pitch_center_y).show();
                } else {
                    me.pitch_bar_center.setTranslation(0,me.b_line - me.pitch_center_y).show();
                    me.pitch_bars_down[i].hide();
                    me.pitch_bars_up[i].hide();
                    me.pitch_bars_text[i].hide();
                }
                    
            } else {
                me.pitch_bars_down[i].hide();
                me.pitch_bars_up[i].hide();
                me.pitch_bars_text[i].hide();
            }
            me.b_pitch += me.pitch_bars_deg_spacing;
            me.b_line -= (me.pitch_px_per_degree * me.pitch_bars_deg_spacing);
        }
        
        ###############################
        ## compass
        ###############################
        
        # me.compass_route_marker is used to show AP route heading. currently it is hide()ing.
        
        # determine leftmost dot location
        
        me.b_dot = ((prop_io.heading - (math.mod(prop_io.heading,me.compass_dot_spread_deg)) - prop_io.heading) + me.compass_dot_spread_deg);
        me.b_dot = me.b_dot * me.compass_px_per_degree + me.compass_left_limit;
        
        # determine leftmost dot number
        me.b_text = prop_io.heading - math.mod(prop_io.heading, me.compass_dot_spread_deg) - me.compass_total_spread;
        
        # update the dots
        me.text_idx = 0;
        for (var i = 0; i < me.compass_spread_deg / me.compass_dot_spread_deg + 1; i = i + 1) {
            me.compass_dots[i].setTranslation(me.b_dot,0);
            if (math.mod(me.b_text,me.compass_dot_spread_deg*2) == 0) {
                me.compass_text[me.text_idx].setTranslation(me.b_dot,-4)
                                            .setText(math.periodic(0,360,me.b_text));
                me.text_idx += 1;
            }
            me.b_text += me.compass_dot_spread_deg;
            me.b_dot += me.compass_dot_spread_px;
        }
        
        ###############################
        ## altitude circle
        ###############################
        
        # rotate line
        me.alt_line.setRotation(prop_io.altitude * me.alt_rotations_per_foot * 360 * D2R);
        # display text
        # display resolution is 20ft increments below 5000ft, and 50ft above
        if (prop_io.altitude <= 5000) {
            me.alt_text.setText(prop_io.altitude - math.mod(prop_io.altitude,20));
        } else {
            me.alt_text.setText(prop_io.altitude - math.mod(prop_io.altitude,50));
        }
        
    },
};

hud_ref = HUD_SCREEN.new({"node": "HudCanvas"});
