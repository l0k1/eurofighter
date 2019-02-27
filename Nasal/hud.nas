var HUD_SCREEN = {

    canvas_settings: {
        "name": "HUD_SCREEN",
        "size": [1024, 1024],
        "view": [1024, 852],
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
        
        m.font_size = 14;
        m.font = "LiberationFonts/LiberationMono-Regular.ttf";
        
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
        m.y_res_norm = m.canvas_settings["view"][1] / 852; # dont change the 852!
        m.avg_norm = (m.x_res_norm + m.y_res_norm) / 2;

        m.hud.addPlacement(placement);
        m.hud.setColorBackground(0,0,0,0);
        
        ###############################
        ## pitch bars
        ###############################
        
        m.pitch_bars_height = m.canvas_settings["view"][0] * m.pitch_bars_size_percent * m.y_res_norm;
        m.pitch_px_per_degree = m.pitch_bars_height / m.pitch_bars_deg_shown;
        m.pitch_bottom = m.canvas_settings["view"][0] / 2 + m.pitch_bars_height / 2;
        m.pitch_top = m.canvas_settings["view"][0] / 2 - m.pitch_bars_height / 2;
        m.pitch_bars_down = [];
        m.pitch_bars_up = [];
        m.pitch_bars_text = [];
        
        # set up paths
        me.d_pitch_bar_layout = [["move",38,0],
                                ["line",18,0],
                                ["line",8,-9],
                                ["line",8,9],
                                ["line",18,0],
                                ["move",14,0],
                                ["line",19,0],
                                ["line",0,-17],
                                ];
        m.u_pitch_bar_layout = [["move",38,0],
                                ["line",87,0],
                                ["line",0,17],
                                ];
        m.c_pitch_bar_layout = [["move",38,15],
                                ["line",0,-15],
                                ["line",235,0]
                                ];
        
        # create the actual lines
        m.pitch_bars_canvas_group = m.mfd.createGroup();
        m.pitch_bars_canvas_group.setTranslation(m.canvas_settings["view"][0] / 2, m.canvas_settings["view"][1] / 2);
        m.pitch_bar_center = m.pitch_bars_canvas_group.createChild("path")
                                    .setStrokeLineWidth(m.line_width)
                                    .setColor(m.red,m.green,m.blue));
        m.array_to_path(m.pitch_bar_center,m.c_pitch_bar_layout, 1);
        for(var i = 0; i < m.pitch_bars_deg_shown / m.pitch_bars_deg_spacing; i = i + 1) {
            append(m.pitch_bars_down, m.pitch_bars_canvas_group.createChild("path")
                                        .setStrokeLineWidth(m.line_width)
                                        .setColor(m.red,m.green,m.blue));
            append(m.pitch_bars_up, m.pitch_bars_canvas_group.createChild("path")
                                        .setStrokeLineWidth(m.line_width)
                                        .setColor(m.red,m.green,m.blue));
            m.array_to_path(m.pitch_bars_down[i], m.d_pitch_bar_layout, 1);
            m.array_to_path(m.pitch_bars_up[i], m.u_pitch_bar_layout, 1);
            append(m.pitch_bars_text, m.pitch_bars_canvas_group.createChild("text")
                                        .setAlignment("left-center")
                                        .setFontSize(m.font_size)
                                        .setFont(m.font)
                                        .setColor(m.red,m.green,m.blue));
        }
        
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
                            ((me.pitch_bars_deg_shown / 2) - (math.mod(me.pitch_bars_deg_shown / 2, me.pitch_bars_deg_spacing));
        me.pitch_bar_center.hide();
        for(var i = 0; i < m.pitch_bars_deg_shown / m.pitch_bars_deg_spacing; i = i + 1) {
            if (me.b_line < me.pitch_bottom and me.b_line > me.pitch_top) {
                if (me.b_pitch < 0) {
                    me.pitch_bars_down[i].setTranslation(0,me.b_line);
                    me.pitch_bars_up[i].hide();
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-110 * me.x_res_norm,me.b_line + 20);
                } elsif (me.b_pitch > 0 {
                    me.pitch_bars_up[i].setTranslation(0,me.b_line);
                    me.pitch_bars_down[i].hide();
                    me.pitch_bars_text[i].setText(int(me.b_pitch)).setTranslation(-110 * me.x_res_norm,me.b_line - 20);
                } else {
                    me.pitch_bar_center.setTranslation(0,me.b_line);
                    me.pitch_bars_down[i].hide();
                    me.pitch_bars_up[i].hide();
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
    
    array_to_path: func(path, arr, mirror_x = 0) {
        foreach(var i; arr) {
            if( i[0] == "move" ) {
                path.move(j[1] * m.x_res_norm,j[2] * m.y_res_norm);
            } elsif( i[0] == "line" ) {
                path.line(j[1] * m.x_res_norm,j[2] * m.y_res_norm);
            }
        }
        if( mirror_x ) {
            path.moveTo(0,0);
            if( i[0] == "move" ) {
                path.move(-j[1] * m.x_res_norm,j[2] * m.y_res_norm);
            } elsif( i[0] == "line" ) {
                path.line(-j[1] * m.x_res_norm,j[2] * m.y_res_norm);
            }
        }
    },
}

hud_ref = HUD_SCREEN.new({"node": "hudobjectnamegoeshere"});
