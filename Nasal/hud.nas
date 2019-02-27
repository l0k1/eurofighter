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
        
        m.font_size = 20;
        m.font = "LED-16.ttf";
        
        m.red = 0.1;
        m.green = 1.0;
        m.blue = 0.2;
        
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
        m.hud.setColorBackground(0,0,0,0);
        
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
                                        .setColor(m.red,m.green,m.blue));
        }
        m.test_group = m.hud.createGroup();
        m.test_text = m.test_group.createChild("text").setAlignment("center-center").setFontSize(50).setTranslation(512,512).setColor(0,1,0).setFont(m.font).setText("foo").show();
        return m;
    },
    
    update: func() {
        
        ###############################
        #################### pitch bars
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
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-110 * me.x_res_norm,me.b_line - 20 - me.pitch_center_y).show();
                } elsif (me.b_pitch > 0) {
                    me.pitch_bars_up[i].setTranslation(0,me.b_line - me.pitch_center_y).show();
                    me.pitch_bars_down[i].hide();
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-110 * me.x_res_norm,me.b_line + 20 - me.pitch_center_y).show();
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
        
    },
};

hud_ref = HUD_SCREEN.new({"node": "HudCanvas"});
