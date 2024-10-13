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

        # button numbers go from 0 to 16, starting in the upper left and going counter clockwise
        m.buttons = [];
        for (var i = 0; i < 17; i = i + 1) {
            if (m.pos == LEFT) {
                append(m.buttons,MFD_BUTTON.new({"node": "MFDButtonL."~i},"bleft" ~ i,LEFT));
            } else if (m.pos == CENTER) {
                append(m.buttons,MFD_BUTTON.new({"node": "MFDButtonC."~i},"bcenter" ~ i,CENTER));
            } else if (m.pos == RIGHT) {
                append(m.buttons,MFD_BUTTON.new({"node": "MFDButtonR."~i},"bright" ~ i,RIGHT));
            }
        }
        ###############################
        ###################### settings
        ###############################
        m.font_size = 30;
        m.font = "LiberationFonts/LiberationMono-Regular.ttf";
        
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
        m.ep_cw = 240;
        m.ep_cwh = m.ep_cw / 2;
        m.engine_page_blue_width = 8;
        m.engine_page_white_width = 18;
        m.engine_page_gauge_width = 5;

        # blue circles
        m.engine_page.createChild("path")
                                .moveTo(246 - m.ep_cwh, 200)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .moveTo(246, 846 - m.ep_cwh)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, 0, m.ep_cw)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cwh, -m.ep_cwh)
                                .moveTo(778 - m.ep_cwh, 200)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, m.ep_cw, 0)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cw, 0)
                                .moveTo(778, 846- m.ep_cwh)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0, 0, m.ep_cw)
                                .arcSmallCW(m.ep_cwh, m.ep_cwh, 0,-m.ep_cwh, -m.ep_cwh)
                                .setStrokeLineWidth(m.engine_page_blue_width)
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
        m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("-FF-")
                                .setTranslation(512,20);

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

        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(106,788)
                                .setText("TBT");

        m.engine_page.createChild("text")
                                .setAlignment("left-bottom")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(640,788)
                                .setText("TBT");

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

        m.ff_readout_left = m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(452,20);
        m.ff_readout_right = m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(572,20);

        m.n1_gauge_left = m.engine_page.createChild("path")
                                .setTranslation(246,200 - m.ep_cwh)
                                .setStrokeLineWidth(m.engine_page_white_width)
                                .setColor(m.white);
        m.n1_gauge_right = m.engine_page.createChild("path")
                                .setTranslation(778,200 - m.ep_cwh)
                                .setStrokeLineWidth(m.engine_page_white_width)
                                .setColor(m.white);
        m.tbt_gauge_left = m.engine_page.createChild("path")
                                .setTranslation(246,846 - m.ep_cwh)
                                .setStrokeLineWidth(m.engine_page_white_width)
                                .setColor(m.white);
        m.tbt_gauge_right = m.engine_page.createChild("path")
                                .setTranslation(778,846 - m.ep_cwh)
                                .setStrokeLineWidth(m.engine_page_white_width)
                                .setColor(m.white);

        m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setText("-NH-")
                                .setTranslation(512,370);

        m.n2_readout_left = m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setTranslation(412,370);

        m.n2_readout_right = m.engine_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.font_size)
                                .setFont(m.font)
                                .setColor(m.offwhite)
                                .setTranslation(612,370);

        ##################################################
        # FUEL PAGE
        ##################################################

        m.fuel_page = m.mfd.createGroup();

        # settings
        m.fuel_page_white_width = 8;
        m.fuel_page_fontsize = 40;

        # blue quantity boxes
        m.tank_0_gfx_x0 = 432;
        m.tank_0_gfx_x1 = 592;
        m.tank_0_gfx_y0 = 30;
        m.tank_0_gfx_y1 = 170;
        m.tank_0_gfx_h = m.tank_0_gfx_y1 - m.tank_0_gfx_y0;

        m.tank_0_gfx = m.fuel_page.createChild("path")
                                #top box
                                .moveTo(m.tank_0_gfx_x0,m.tank_0_gfx_y0)
                                .lineTo(m.tank_0_gfx_x0,m.tank_0_gfx_y1)
                                .lineTo(m.tank_0_gfx_x1,m.tank_0_gfx_y1)
                                .lineTo(m.tank_0_gfx_x1,m.tank_0_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_1_gfx_x0 = 420;
        m.tank_1_gfx_x1 = 604;
        m.tank_1_gfx_y0 = 192;
        m.tank_1_gfx_y1 = 347;
        m.tank_1_gfx_h = m.tank_1_gfx_y1 - m.tank_1_gfx_y0;

        m.tank_1_gfx = m.fuel_page.createChild("path")
                                #top box
                                .moveTo(m.tank_1_gfx_x0,m.tank_1_gfx_y0)
                                .lineTo(m.tank_1_gfx_x0,m.tank_1_gfx_y1)
                                .lineTo(m.tank_1_gfx_x1,m.tank_1_gfx_y1)
                                .lineTo(m.tank_1_gfx_x1,m.tank_1_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_1_sub_gfx_x0 = 386;
        m.tank_1_sub_gfx_x1 = 446;
        m.tank_1_sub_gfx_y0 = 246;
        m.tank_1_sub_gfx_y1 = 347;
        m.tank_1_sub_gfx_h = m.tank_1_sub_gfx_y1 - m.tank_1_sub_gfx_y0;
        m.tank_1_sub_gfx = m.fuel_page.createChild("path")
                                #top box
                                .moveTo(m.tank_1_sub_gfx_x0,m.tank_1_sub_gfx_y0)
                                .lineTo(m.tank_1_sub_gfx_x0,m.tank_1_sub_gfx_y1)
                                .lineTo(m.tank_1_sub_gfx_x1,m.tank_1_sub_gfx_y1)
                                .lineTo(m.tank_1_sub_gfx_x1,m.tank_1_sub_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_2_gfx_x0 = 606;
        m.tank_2_gfx_x1 = 418;
        m.tank_2_gfx_y0 = 675;
        m.tank_2_gfx_y1 = 830;
        m.tank_2_gfx_h = m.tank_2_gfx_y1 - m.tank_2_gfx_y0;
        m.tank_2_gfx = m.fuel_page.createChild("path")
                                #top box
                                .moveTo(m.tank_2_gfx_x0,m.tank_2_gfx_y0)
                                .lineTo(m.tank_2_gfx_x0,m.tank_2_gfx_y1)
                                .lineTo(m.tank_2_gfx_x1,m.tank_2_gfx_y1)
                                .lineTo(m.tank_2_gfx_x1,m.tank_2_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_2_sub_gfx_x0 = 640;
        m.tank_2_sub_gfx_x1 = 578;
        m.tank_2_sub_gfx_y0 = 728;
        m.tank_2_sub_gfx_y1 = 830;
        m.tank_2_sub_gfx_h = m.tank_2_sub_gfx_y1 - m.tank_2_sub_gfx_y0;
        m.tank_2_sub_gfx = m.fuel_page.createChild("path")
                                .moveTo(m.tank_2_sub_gfx_x0,m.tank_2_sub_gfx_y0)
                                .lineTo(m.tank_2_sub_gfx_x0,m.tank_2_sub_gfx_y1)
                                .lineTo(m.tank_2_sub_gfx_x1,m.tank_2_sub_gfx_y1)
                                .lineTo(m.tank_2_sub_gfx_x1,m.tank_2_sub_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_3_gfx_x0 = 334;
        m.tank_3_gfx_x1 = 200;
        m.tank_3_gfx_y0 = 400;
        m.tank_3_gfx_y1 = 580;
        m.tank_3_gfx_h = m.tank_3_gfx_y1 - m.tank_3_gfx_y0;
        m.tank_3_gfx_w = m.tank_3_gfx_x0 - m.tank_3_gfx_x1;
        m.tank_3_gfx = m.fuel_page.createChild("path")
                                .moveTo(m.tank_3_gfx_x0,m.tank_3_gfx_y0)
                                .lineTo(m.tank_3_gfx_x0,m.tank_3_gfx_y1)
                                .lineTo(m.tank_3_gfx_x1,m.tank_3_gfx_y1)
                                .close()
                                .setColorFill(m.blue);

        m.tank_4_gfx_x0 = 334;
        m.tank_4_gfx_x1 = 80;
        m.tank_4_gfx_x2 = 150;
        m.tank_4_gfx_y0 = 650;
        m.tank_4_gfx_y1 = 750;
        m.tank_4_gfx_h = m.tank_4_gfx_y1 - m.tank_4_gfx_y0;
        m.tank_4_gfx_w = m.tank_4_gfx_x2 - m.tank_4_gfx_x1;
        m.tank_4_gfx = m.fuel_page.createChild("path")
                                .moveTo(m.tank_4_gfx_x0,m.tank_4_gfx_y0)
                                .lineTo(m.tank_4_gfx_x0,m.tank_4_gfx_y1)
                                .lineTo(m.tank_4_gfx_x1,m.tank_4_gfx_y1)
                                .lineTo(m.tank_4_gfx_x2,m.tank_4_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        m.tank_5_gfx_x0 = 690;
        m.tank_5_gfx_x1 = 824;
        m.tank_5_gfx_y0 = 400;
        m.tank_5_gfx_y1 = 580;
        m.tank_5_gfx_h = m.tank_5_gfx_y1 - m.tank_5_gfx_y0;
        m.tank_5_gfx_w = m.tank_5_gfx_x1 - m.tank_5_gfx_x0;
        m.tank_5_gfx = m.fuel_page.createChild("path")
                                .moveTo(m.tank_5_gfx_x0,m.tank_5_gfx_y0)
                                .lineTo(m.tank_5_gfx_x0,m.tank_5_gfx_y1)
                                .lineTo(m.tank_5_gfx_x1,m.tank_5_gfx_y1)
                                .close()
                                .setColorFill(m.blue);

        m.tank_6_gfx_x0 = 690;
        m.tank_6_gfx_x1 = 944;
        m.tank_6_gfx_x2 = 874;
        m.tank_6_gfx_y0 = 650;
        m.tank_6_gfx_y1 = 750;
        m.tank_6_gfx_h = m.tank_6_gfx_y1 - m.tank_6_gfx_y0;
        m.tank_6_gfx_w = m.tank_6_gfx_x1 - m.tank_6_gfx_x2;
        m.tank_6_gfx = m.fuel_page.createChild("path")
                                .moveTo(m.tank_6_gfx_x0,m.tank_6_gfx_y0)
                                .lineTo(m.tank_6_gfx_x0,m.tank_6_gfx_y1)
                                .lineTo(m.tank_6_gfx_x1,m.tank_6_gfx_y1)
                                .lineTo(m.tank_6_gfx_x2,m.tank_6_gfx_y0)
                                .close()
                                .setColorFill(m.blue);

        #tank interconnect lines

        m.fuelLineWidth = 10;
        m.lightblue = [0.35,0.7,1,1];

        m.fuel_rightacc_line = m.fuel_page.createChild("path")
                                .moveTo(404,350)
                                .lineTo(404,955)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_rightacc_tri = m.fuel_page.createChild("path")
                                .moveTo(390,955)
                                .lineTo(418,955)
                                .lineTo(404,970)
                                .close()
                                .setColor(m.lightblue)
                                .setColorFill(m.lightblue)
                                .setStrokeLineWidth(2);
        m.fuel_leftacc_line = m.fuel_page.createChild("path")
                                .moveTo(621,831)
                                .lineTo(621,955)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_leftacc_tri = m.fuel_page.createChild("path")
                                .moveTo(607,955)
                                .lineTo(635,955)
                                .lineTo(621,970)
                                .close()
                                .setColor(m.lightblue)
                                .setColorFill(m.lightblue)
                                .setStrokeLineWidth(2);
        m.fuel_xfeed_line = m.fuel_page.createChild("path")
                                .moveTo(412,884)
                                .lineTo(612,884)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_wing_line = m.fuel_page.createChild("path")
                                .moveTo(230,619)
                                .lineTo(391,619)
                                .moveTo(417,619)
                                .lineTo(798,619)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_aftwing_line = m.fuel_page.createChild("path")
                                .moveTo(234,619)
                                .lineTo(234,650)
                                .moveTo(795,619)
                                .lineTo(795,650)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_forewing_line = m.fuel_page.createChild("path")
                                .moveTo(234,619)
                                .lineTo(234,582)
                                .moveTo(795,619)
                                .lineTo(795,582)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_interconnect_line = m.fuel_page.createChild("path")
                                .moveTo(454,350)
                                .lineTo(454,610)
                                .moveTo(454,630)
                                .lineTo(454,672)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_ftransfer_line = m.fuel_page.createChild("path")
                                .moveTo(594,148)
                                .lineTo(662,148)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_ftrefuel_line = m.fuel_page.createChild("path")
                                .moveTo(662,148)
                                .lineTo(662,380)
                                .lineTo(568,380)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_leftdrop_line = m.fuel_page.createChild("path")
                                .moveTo(94,380)
                                .lineTo(391,380)
                                .moveTo(417,380)
                                .lineTo(568,380)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_rightdrop_line = m.fuel_page.createChild("path")
                                .moveTo(798,619)
                                .lineTo(928,619)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_centerdrop_line = m.fuel_page.createChild("path")
                                .moveTo(512,581)
                                .lineTo(512,619)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_foreaft_line = m.fuel_page.createChild("path")
                                .moveTo(568,380)
                                .lineTo(568,619)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_aft_line = m.fuel_page.createChild("path")
                                .moveTo(568,619)
                                .lineTo(568,652)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_aft_triangle = m.fuel_page.createChild("path")
                                .moveTo(557,652)
                                .lineTo(579,652)
                                .lineTo(568,672)
                                .close()
                                .setColor(m.lightblue)
                                .setColorFill(m.lightblue)
                                .setStrokeLineWidth(2);
        m.fuel_fore_line = m.fuel_page.createChild("path")
                                .moveTo(568,380)
                                .lineTo(568,370)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);
        m.fuel_fore_triangle = m.fuel_page.createChild("path")
                                .moveTo(557,370)
                                .lineTo(579,370)
                                .lineTo(568,350)
                                .close()
                                .setColor(m.lightblue)
                                .setColorFill(m.lightblue)
                                .setStrokeLineWidth(2);
        m.fuel_refuel_line = m.fuel_page.createChild("path")
                                .moveTo(662,148)
                                .lineTo(714,93)
                                .lineTo(714,79)
                                .moveTo(700,79)
                                .arcSmallCWTo(14,14,0,728,79)
                                .setColor(m.lightblue)
                                .setStrokeLineWidth(m.fuelLineWidth);


        # fuel gauge outlines
        m.fuel_page.createChild("path")
                                #top box
                                .moveTo(m.tank_0_gfx_x0,m.tank_0_gfx_y0)
                                .lineTo(m.tank_0_gfx_x0,m.tank_0_gfx_y1)
                                .lineTo(m.tank_0_gfx_x1,m.tank_0_gfx_y1)
                                .lineTo(m.tank_0_gfx_x1,m.tank_0_gfx_y0)
                                .lineTo(m.tank_0_gfx_x0,m.tank_0_gfx_y0)
                                #mid top boxes
                                .moveTo(420,246)
                                .lineTo(420,192)
                                .lineTo(604,192)
                                .lineTo(604,347)
                                .lineTo(386,347)
                                .lineTo(386,246)
                                .lineTo(446,246)
                                .lineTo(446,347)
                                #left mid triangle
                                .moveTo(334,400)
                                .lineTo(334,580)
                                .lineTo(200,580)
                                .lineTo(334,400)
                                #right mid triangle
                                .moveTo(690,400)
                                .lineTo(690,580)
                                .lineTo(824,580)
                                .lineTo(690,400)
                                #left bottom polygon
                                .moveTo(334,650)
                                .lineTo(334,750)
                                .lineTo(80,750)
                                .lineTo(150,650)
                                .lineTo(334,650)
                                #right bottom polygon
                                .moveTo(690,650)
                                .lineTo(690,750)
                                .lineTo(944,750)
                                .lineTo(874,650)
                                .lineTo(690,650)
                                #bottom boxes
                                .moveTo(606,728)
                                .lineTo(606,675)
                                .lineTo(418,675)
                                .lineTo(418,830)
                                .lineTo(640,830)
                                .lineTo(640,728)
                                .lineTo(578,728)
                                .lineTo(578,830)
                                #center drop tank
                                .moveTo(482,453)
                                .lineTo(482,420) #blaze it
                                .arcSmallCWTo(30,30,0,542,420)
                                .lineTo(542,453)
                                .moveTo(482,515)
                                .lineTo(482,548)
                                .arcSmallCCWTo(30,30,0,542,548)
                                .lineTo(542,515)
                                #left drop tank
                                .moveTo(37,470)
                                .lineTo(37,390)
                                .arcSmallCWTo(30,30,0,97,390)
                                .lineTo(97,470)
                                .moveTo(37,533)
                                .lineTo(37,613)
                                .arcSmallCCWTo(30,30,0,97,613)
                                .lineTo(97,533)
                                #right drop tank
                                .moveTo(927,470)
                                .lineTo(927,390)
                                .arcSmallCWTo(30,30,0,987,390)
                                .lineTo(987,470)
                                .moveTo(927,533)
                                .lineTo(927,613)
                                .arcSmallCCWTo(30,30,0,987,613)
                                .lineTo(987,533)
                                .setStrokeLineWidth(m.fuel_page_white_width)
                                .setColor(m.white);


        m.fueltank_0_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(560,97);
        m.fueltank_1_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(570,243);
        m.fueltank_2_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(580,730);
        m.fueltank_3_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(326,514);
        m.fueltank_4_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(326,678);
        m.fueltank_5_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(770,514);
        m.fueltank_6_txt = m.fuel_page.createChild("text")
                                .setAlignment("right-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(770,678);
        m.fueltank_7_txt = m.fuel_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(512,470);
        m.fueltank_8_txt = m.fuel_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(68,485);
        m.fueltank_9_txt = m.fuel_page.createChild("text")
                                .setAlignment("center-top")
                                .setFontSize(m.fuel_page_fontsize)
                                .setFont(m.font)
                                .setColor(m.white)
                                .setTranslation(958,485);
        m.fuel_page.hide();

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
        print('initing');
        me.buttons[0].page = mfd_engine;
        me.buttons[1].page = mfd_buttontest;
        me.buttons[2].page = mfd_fuel;
        me.update_buttons();
    },
    
    dev_mode_update: func() {
        me.engine_screen();
    },

    fuel_page_init: func() {
        me.fuel_page.show();
        me.clear_buttons();
        print('mfd set to fuel page');
        me.buttons[7].page = mfd_fuel;
        me.buttons[8].page = mfd_engine;
        me.buttons[1].page = mfd_buttontest;
        me.update_buttons();
    },

    fuel_page_end: func() {
        me.fuel_page.hide();
    },

    fuel_page_update: func() {

        t0pct = getprop("fdm/jsbsim/propulsion/tank[0]/pct-full")/100;
        t1pct = getprop("fdm/jsbsim/propulsion/tank[1]/pct-full")/100;
        t2pct = getprop("fdm/jsbsim/propulsion/tank[2]/pct-full")/100;
        t3pct = getprop("fdm/jsbsim/propulsion/tank[3]/pct-full")/100;
        t4pct = getprop("fdm/jsbsim/propulsion/tank[4]/pct-full")/100;
        t5pct = getprop("fdm/jsbsim/propulsion/tank[5]/pct-full")/100;
        t6pct = getprop("fdm/jsbsim/propulsion/tank[6]/pct-full")/100;
        t7pct = getprop("fdm/jsbsim/propulsion/tank[7]/pct-full")/100;
        t8pct = getprop("fdm/jsbsim/propulsion/tank[8]/pct-full")/100;
        t9pct = getprop("fdm/jsbsim/propulsion/tank[9]/pct-full")/100;

        me.tank_0_gfx.reset()
                    .moveTo(me.tank_0_gfx_x0,me.tank_0_gfx_y1)
                    .lineTo(me.tank_0_gfx_x1,me.tank_0_gfx_y1)
                    .lineTo(me.tank_0_gfx_x1,me.tank_0_gfx_y1 - me.tank_0_gfx_h * t0pct)
                    .lineTo(me.tank_0_gfx_x0,me.tank_0_gfx_y1 - me.tank_0_gfx_h * t0pct)
                    .close()
                    .setColorFill(me.blue);

        me.tank_1_gfx.reset()
                    .moveTo(me.tank_1_gfx_x0,me.tank_1_gfx_y1)
                    .lineTo(me.tank_1_gfx_x1,me.tank_1_gfx_y1)
                    .lineTo(me.tank_1_gfx_x1,me.tank_1_gfx_y1 - me.tank_1_gfx_h * t1pct)
                    .lineTo(me.tank_1_gfx_x0,me.tank_1_gfx_y1 - me.tank_1_gfx_h * t1pct)
                    .close()
                    .setColorFill(me.blue);
        if (me.tank_1_gfx_h * t1pct < me.tank_1_sub_gfx_h) {
            me.t1subh = me.tank_1_gfx_h * t1pct;
        } else {
            me.t1subh = me.tank_1_sub_gfx_h;
        }
        me.tank_1_sub_gfx.reset()
                    .moveTo(me.tank_1_sub_gfx_x0,me.tank_1_sub_gfx_y1)
                    .lineTo(me.tank_1_sub_gfx_x1,me.tank_1_sub_gfx_y1)
                    .lineTo(me.tank_1_sub_gfx_x1,me.tank_1_sub_gfx_y1 - me.t1subh)
                    .lineTo(me.tank_1_sub_gfx_x0,me.tank_1_sub_gfx_y1 - me.t1subh)
                    .close()
                    .setColorFill(me.blue);

        me.tank_2_gfx.reset()
                    .moveTo(me.tank_2_gfx_x0,me.tank_2_gfx_y1)
                    .lineTo(me.tank_2_gfx_x1,me.tank_2_gfx_y1)
                    .lineTo(me.tank_2_gfx_x1,me.tank_2_gfx_y1 - me.tank_2_gfx_h * t2pct)
                    .lineTo(me.tank_2_gfx_x0,me.tank_2_gfx_y1 - me.tank_2_gfx_h * t2pct)
                    .close()
                    .setColorFill(me.blue);

        if (me.tank_2_gfx_h * t2pct < me.tank_2_sub_gfx_h) {
            me.t2subh = me.tank_2_gfx_h * t2pct;
        } else {
            me.t2subh = me.tank_2_sub_gfx_h;
        }
        me.tank_2_sub_gfx.reset()
                    .moveTo(me.tank_2_sub_gfx_x0,me.tank_2_sub_gfx_y1)
                    .lineTo(me.tank_2_sub_gfx_x1,me.tank_2_sub_gfx_y1)
                    .lineTo(me.tank_2_sub_gfx_x1,me.tank_2_sub_gfx_y1 - me.t2subh)
                    .lineTo(me.tank_2_sub_gfx_x0,me.tank_2_sub_gfx_y1 - me.t2subh)
                    .close()
                    .setColorFill(me.blue);

        tgx = me.tank_3_gfx_x1 + me.tank_3_gfx_w * t3pct;
        tgy = me.tank_3_gfx_y1 - me.tank_3_gfx_h * t3pct;
        me.tank_3_gfx.reset()
                    .moveTo(me.tank_3_gfx_x0,me.tank_3_gfx_y1)
                    .lineTo(me.tank_3_gfx_x1,me.tank_3_gfx_y1)
                    .lineTo(tgx,tgy)
                    .lineTo(me.tank_3_gfx_x0,tgy)
                    .close()
                    .setColorFill(me.blue);

        tgx = me.tank_4_gfx_x1 + me.tank_4_gfx_w * t4pct;
        tgy = me.tank_4_gfx_y1 - me.tank_4_gfx_h * t4pct;
        me.tank_4_gfx.reset()
                    .moveTo(me.tank_4_gfx_x0,me.tank_4_gfx_y1)
                    .lineTo(me.tank_4_gfx_x1,me.tank_4_gfx_y1)
                    .lineTo(tgx,tgy)
                    .lineTo(me.tank_4_gfx_x0,tgy)
                    .close()
                    .setColorFill(me.blue);

        tgx = me.tank_5_gfx_x1 - me.tank_5_gfx_w * t5pct;
        tgy = me.tank_5_gfx_y1 - me.tank_5_gfx_h * t5pct;
        me.tank_5_gfx.reset()
                    .moveTo(me.tank_5_gfx_x0,me.tank_5_gfx_y1)
                    .lineTo(me.tank_5_gfx_x1,me.tank_5_gfx_y1)
                    .lineTo(tgx,tgy)
                    .lineTo(me.tank_5_gfx_x0,tgy)
                    .close()
                    .setColorFill(me.blue);

        tgx = me.tank_6_gfx_x1 - me.tank_6_gfx_w * t6pct;
        tgy = me.tank_6_gfx_y1 - me.tank_6_gfx_h * t6pct;
        me.tank_6_gfx.reset()
                    .moveTo(me.tank_6_gfx_x0,me.tank_6_gfx_y1)
                    .lineTo(me.tank_6_gfx_x1,me.tank_6_gfx_y1)
                    .lineTo(tgx,tgy)
                    .lineTo(me.tank_6_gfx_x0,tgy)
                    .close()
                    .setColorFill(me.blue);








        # convert to kg, divide by 10, take the floor, multiply by 10
        me.fueltank_0_txt.setText(math.floor(prop_io.tank_0_contents_lb*LB2KG/10)*10);
        me.fueltank_1_txt.setText(math.floor(prop_io.tank_1_contents_lb*LB2KG/10)*10);
        me.fueltank_2_txt.setText(math.floor(prop_io.tank_2_contents_lb*LB2KG/10)*10);
        me.fueltank_3_txt.setText(math.floor(prop_io.tank_3_contents_lb*LB2KG/10)*10);
        me.fueltank_4_txt.setText(math.floor(prop_io.tank_4_contents_lb*LB2KG/10)*10);
        me.fueltank_5_txt.setText(math.floor(prop_io.tank_5_contents_lb*LB2KG/10)*10);
        me.fueltank_6_txt.setText(math.floor(prop_io.tank_6_contents_lb*LB2KG/10)*10);
        me.fueltank_7_txt.setText(math.floor(prop_io.tank_7_contents_lb*LB2KG/10)*10);
        me.fueltank_8_txt.setText(math.floor(prop_io.tank_8_contents_lb*LB2KG/10)*10);
        me.fueltank_9_txt.setText(math.floor(prop_io.tank_9_contents_lb*LB2KG/10)*10);
        return;
    },

    engine_mode_init: func() {
        me.engine_page.show();
        me.clear_buttons();
        print('mfd set to engine page');
        me.buttons[7].page = mfd_fuel;
        me.buttons[8].page = mfd_engine;
        me.buttons[1].page = mfd_buttontest;
        me.update_buttons();
    },

    engine_mode_end: func() {
        me.engine_page.hide();
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

        #we dont have tbt, so substituting it with egt for now
        me.angle = interp(prop_io.engine0_tat,600,1500,-90,180);
        me.x = me.ep_cwh * math.cos(me.angle * D2R);
        me.y = me.ep_cwh * math.sin(me.angle * D2R) + me.ep_cwh;
        if (me.angle > 90) {
            me.tbt_gauge_left.reset()
                            .arcLargeCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        } else {
            me.tbt_gauge_left.reset()
                            .arcSmallCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        }
        me.angle = interp(prop_io.engine1_tat,600,1500,-90,180);
        me.x = me.ep_cwh * math.cos(me.angle * D2R);
        me.y = me.ep_cwh * math.sin(me.angle * D2R) + me.ep_cwh;
        if (me.angle > 90) {
            me.tbt_gauge_right.reset()
                            .arcLargeCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        } else {
            me.tbt_gauge_right.reset()
                            .arcSmallCW(me.ep_cwh, me.ep_cwh, 0, me.x, me.y);
        }



        me.n1_readout_left.setText(sprintf("%.1f",prop_io.engine0_n1));
        me.n1_readout_right.setText(sprintf("%.1f",prop_io.engine1_n1));
        me.n2_readout_left.setText(sprintf("%.1f",prop_io.engine0_n2));
        me.n2_readout_right.setText(sprintf("%.1f",prop_io.engine1_n2));
        me.aj_readout_left.setText(int(100 * prop_io.engine0_nz));
        me.aj_readout_right.setText(int(100 * prop_io.engine1_nz));
        me.temp_readout_left.setText(sprintf("%i",prop_io.engine0_tat));
        me.temp_readout_right.setText(sprintf("%i",prop_io.engine1_tat));
        me.ff_readout_left.setText(sprintf("%i",(prop_io.engine0_ff/10)));
        me.ff_readout_right.setText(sprintf("%i",(prop_io.engine1_ff/10)));
        return;
    },

    clear_buttons: func() {
        for (me.i = 0; me.i < 17; me.i = me.i + 1) {
            me.buttons[me.i].page = mfd_null;
        }
    },

    update_buttons: func() {
        for (me.i = 0; me.i < 17; me.i = me.i + 1) {
            me.buttons[me.i].update();
        }
    },

    buttontest: func() {
        screen.log.write("hi :)");
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
        m._name = name;
        ###############################
        # settings
        ###############################
        m.page = nil; # mfd hash assigned to button
        
        m.pos = position; # left = 0, center = 1, right = 2;
        
        m.font_size = 40;
        m.font = "LiberationFonts/LiberationMono-Regular.ttf";
        
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
        return m;
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
        me.top_text.setText(me.page.label_top);
        me.bottom_text.setText(me.page.label_bottom);
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
var mfd_engine      = {parents: [state_arch], label_top: "ENGI", main_func: MFD_SCREEN.engine_screen,      init_func: MFD_SCREEN.engine_mode_init, end_func: MFD_SCREEN.engine_mode_end};
var mfd_fuel        = {parents: [state_arch], label_top: "FUEL", main_func: MFD_SCREEN.fuel_page_update,   init_func: MFD_SCREEN.fuel_page_init,     end_func: MFD_SCREEN.fuel_page_end};
var mfd_buttontest  = {parents: [state_arch], label_top: "TEST", main_func: MFD_SCREEN.buttontest, temp: 1};

# temps
# if temp == 1, it will only fire the init, main, and end functions once.
#var hud_switch_gs_m = {parents: [state_arch], main_func: hud_ref.groundspeed_mach_switch, temp: 1};

mfd_left.change_state(mfd_engine);
mfd_center.change_state(mfd_engine);
mfd_right.change_state(mfd_engine);