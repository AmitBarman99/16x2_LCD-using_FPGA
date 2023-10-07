`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Octus defence
// Engineer: Amit Barman
// 
// Create Date:    12:24:13 10/07/2023 
// Design Name: 
// Module Name:    hello_lcd 
// Project Name: 		Hello on LCD display using FPGA
// Target Devices: 	Spartan 6
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision:  v1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/*------------------------------------
DISPLAY HELLO ON LCD USING SPARTAN 6
------------------------------------*/


module lcd(clk,rst,data,lcd_e,lcd_rw,lcd_rs,SF_CEO);
input clk,rst;
output [3:0]data;
output reg SF_CEO;      //strata flash enable signal --> need to disable
output reg lcd_e,lcd_rw,lcd_rs;

reg [3:0]lcd_cmd;   //4-bits
reg [7:0]state=0;   //lcd states
reg init_done, disp_done;
reg [30:0]count=0;  //state counter

assign data=lcd_cmd;
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        lcd_e <=0;
        init_done <=0;
        lcd_rs <=0;
        lcd_rw <=0;
        SF_CEO <=1'b1;          // Strata flash enable signal --> disable
    end
    else
    begin               // INITIALIZATION
        case (state)
            0: begin                //ideal
            lcd_e <=0;
            lcd_rw <=0;
            lcd_rs <=0;
            if (count == 750000) begin                  //750000 clk 
                    count <=0;
                    state <= state +1;
            end
            else
            count <= count +1;
            end
            // -------------------------------------------------------
            1:begin
                lcd_e <=1;
                lcd_cmd <=4'h3;     // 03H
                if (count ==12) begin           //12 clk
                    count <=0;
                    state <= state +1;
                end
                else
                count <= count +1;
            end
            //-------------------------------------------------------
            2:begin
                lcd_e <=0;
                if (count==205000) begin            //205000 clk
                    count <=0;
                    state <=state+1;
                end
                else
                count <= count+1;
            end
            //--------------------------------------------------------
            3:begin
                lcd_e <=1;
                lcd_cmd <=4'h3;
                if (count==12) begin            //12 clk
                    count <=0;
                    state <= state +1;
                end
                else
                count <= count+1;
            end
            //--------------------------------------------------------
            4:begin
                lcd_e <=0;
                if (count==500) begin               //500 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //--------------------------------------------------------
            5:begin
                lcd_e <=1;
                lcd_cmd <= 4'h3;
                if (count==12) begin                //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            6:begin
                lcd_e <=0;
                if (count==2000) begin              //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            7:begin
                lcd_e <=1;
                lcd_cmd <= 4'h2;
                if (count==12) begin            //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //------------------------------------------------------
            8:begin
                lcd_e <=0;
                if (count==2000) begin              //2000 clk
                    count <=0;
                    state <= state+1;
                    init_done <=1;
                end
                else
                count <= count+1;
            end
//      INITIALIZATION DONE
// #############################################################################
//      DISPLAY CONFIGURATION
            //  function set = 28H
            9:begin
                lcd_e <=1;
                lcd_cmd <= 4'h2;    // upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //------------------------------------------------
            10:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h8;            //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------
            11:begin
                if (count==12) begin            //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //  Function set done
            //-------------------------------------------------
            12:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end

            //*****************************************************
            //Entry mode set = 06H
            13:begin
                lcd_e <=1;
                lcd_cmd <= 4'h0;            //upper nibble
                if (count==12) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //----------------------------------------------------
            14:begin
                lcd_e <=0;
                if (count==50) begin            //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h6;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //----------------------------------------------------
            15:begin
                lcd_e <=0;
                if (count==12) begin            //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            // Entry mode set done
            //----------------------------------------------------
            16:begin
                if (count==2000) begin      //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //*************************************************************
            // Display ON/OFF = 0CH
            17:begin
                lcd_e <=1;
                lcd_cmd <= 4'h0;            //upper nibble
                if (count==12) begin            //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //--------------------------------------------------------
            18:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hc;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //--------------------------------------------------------
            19:begin
                if (count==12) begin            //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            // Display ON/OFF done
            //------------------------------------------------------
            20:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //*********************************************************
            // Clear display = 01H
            21:begin
                lcd_e <=1;
                lcd_cmd <= 4'h0;            //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------------
            22:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h1;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            23:begin
                if (count==12) begin            //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            // Clear display done
            //------------------------------------------------------
            24:begin
                if (count==82000) begin
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //*******************************************************
//      DISPLAY CONFIGURATION DONE
// ###########################################################################
//      WRITING DATA INTO LCD
            //      For 1st row on lcd = 80H
            25:begin
                lcd_e <=1;
                lcd_cmd <=4'h8;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //------------------------------------------------------------
            26:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h0;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------------
            27:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------------
            28:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //********************************************************
            //      DATA ON LCD
            // Display character - H = 48H
            29:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            30:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h8;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            31:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------
            32:begin
                if (count==2000) begin
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
             // Display character - E = 45H
            33:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            34:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h5;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            35:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------
            36:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
             // Display character - L = 4CH
            37:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            38:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hc;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            39:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------
            40:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
             // Display character - L = 4CH
            41:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            42:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hc;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            43:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------
            44:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
             // Display character - O = 4FH
            45:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            46:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hf;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            47:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            48:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				
				//****************************************************
				//      For 2nd row on lcd = C0H
           49:begin
                lcd_e <=1;
					 lcd_rs <=0;
                lcd_cmd <=4'hc;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //------------------------------------------------------------
            50:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h0;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------------
            51:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //---------------------------------------------------------
            52:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//****************************************************
             // Display character - A = 41H
            53:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            54:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h1;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            55:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            56:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//****************************************************
             // Display character - M = 4DH
            57:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            58:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hd;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            59:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            60:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
             // Display character - I = 49H
            61:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            62:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h9;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            63:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            64:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//****************************************************
             // Display character - T = 54H
            65:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h5;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            66:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h4;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            67:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            68:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
           
            //****************************************************
             // Display character - ' ' = 20H
            69:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h2;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            70:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h0;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            71:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            72:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//****************************************************
             // Display character - B = 42H
            73:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            74:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h2;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            75:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            76:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //****************************************************
				// Display character - A = 41H
            77:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            78:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h1;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            79:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            80:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
           
            //****************************************************
             // Display character - R = 52H
            81:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h5;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            82:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h2;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            83:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            84:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//****************************************************
             // Display character - M = 4DH
            85:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            86:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'hd;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            87:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            88:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
           
            //****************************************************
				// Display character - A = 41H
            89:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            90:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'h1;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            91:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            92:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
           
            //****************************************************
				// Display character - N = 4EH
            93:begin
                lcd_e <=1;
                lcd_rs <=1;
                lcd_cmd <=4'h4;         //upper nibble
                if (count==12) begin        //12 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-------------------------------------------------------
            94:begin
                lcd_e <=0;
                if (count==50) begin        //50 clk
                    lcd_e <=1;
                    lcd_cmd <= 4'he;        //lower nibble
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
            //-----------------------------------------------------
            95:begin
                if (count==12) begin        //12 clk
                    lcd_e <=0;
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
				//---------------------------------------------------
            96:begin
                if (count==2000) begin          //2000 clk
                    count <=0;
                    state <= state+1;
                end
                else
                count <= count+1;
            end
           
            //****************************************************				
//   WRITING DATA INTO LCD DONE
        endcase
    end
end
endmodule

