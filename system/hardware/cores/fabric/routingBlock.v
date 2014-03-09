/*
 * University of Illinois/NCSA
 * Open Source License
 *
 *  Copyright (c) 2007-2014,The Board of Trustees of the University of
 *  Illinois.  All rights reserved.
 *
 *  Copyright (c) 2014 Matthew Hicks
 *
 *  Developed by:
 *
 *  Matthew Hicks in the Department of Computer Science
 *  The University of Illinois at Urbana-Champaign
 *      http://www.impedimentToProgress.com
 *
 *       Permission is hereby granted, free of charge, to any person
 *       obtaining a copy of this software and associated
 *       documentation files (the "Software"), to deal with the
 *       Software without restriction, including without limitation
 *       the rights to use, copy, modify, merge, publish, distribute,
 *       sublicense, and/or sell copies of the Software, and to permit
 *       persons to whom the Software is furnished to do so, subject
 *       to the following conditions:
 *
 *          Redistributions of source code must retain the above
 *          copyright notice, this list of conditions and the
 *          following disclaimers.
 *
 *          Redistributions in binary form must reproduce the above
 *          copyright notice, this list of conditions and the
 *          following disclaimers in the documentation and/or other
 *          materials provided with the distribution.
 *
 *          Neither the names of Sam King, the University of Illinois,
 *          nor the names of its contributors may be used to endorse
 *          or promote products derived from this Software without
 *          specific prior written permission.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT.  IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS WITH THE SOFTWARE.
 */

`include "globalDefines.vh"

module routingBlock(
   inputState, inputSelect, out, configInvalid
);

   parameter NUM_INPUTS = 17;
   parameter NUM_INPUTS_LOG_2 = 5;  // Add an assertion to check this
   parameter INPUT_WIDTH = 32;
   
   
   input  [(NUM_INPUTS*INPUT_WIDTH)-1:0] inputState;   // Can't pass
                                                // multidimensional arrays
                                                // between modules
   input [NUM_INPUTS_LOG_2-1:0]          inputSelect;  // Configuration
   output [INPUT_WIDTH-1:0]              out;
   output                                configInvalid;

   reg [INPUT_WIDTH-1:0]                 out;

   // Check that the input selected is within the number of possible inputs
   assign configInvalid = inputSelect >= NUM_INPUTS; 

   // Really big MUX
   always @(inputSelect or inputState)begin
      case(inputSelect)
        0: out = inputState[INPUT_WIDTH*1-1:INPUT_WIDTH*0];
        1: out = inputState[INPUT_WIDTH*2-1:INPUT_WIDTH*1];
        2: out = inputState[INPUT_WIDTH*3-1:INPUT_WIDTH*2];
        3: out = inputState[INPUT_WIDTH*4-1:INPUT_WIDTH*3];
        4: out = inputState[INPUT_WIDTH*5-1:INPUT_WIDTH*4];
        5: out = inputState[INPUT_WIDTH*6-1:INPUT_WIDTH*5];
        6: out = inputState[INPUT_WIDTH*7-1:INPUT_WIDTH*6];
        7: out = inputState[INPUT_WIDTH*8-1:INPUT_WIDTH*7];
        8: out = inputState[INPUT_WIDTH*9-1:INPUT_WIDTH*8];
        9: out = inputState[INPUT_WIDTH*10-1:INPUT_WIDTH*9];
        10: out = inputState[INPUT_WIDTH*11-1:INPUT_WIDTH*10];
        11: out = inputState[INPUT_WIDTH*12-1:INPUT_WIDTH*11];
        12: out = inputState[INPUT_WIDTH*13-1:INPUT_WIDTH*12];
        13: out = inputState[INPUT_WIDTH*14-1:INPUT_WIDTH*13];
        14: out = inputState[INPUT_WIDTH*15-1:INPUT_WIDTH*14];
        15: out = inputState[INPUT_WIDTH*16-1:INPUT_WIDTH*15];
        16: out = inputState[INPUT_WIDTH*17-1:INPUT_WIDTH*16];
/*        17: out = inputState[INPUT_WIDTH*18-1:INPUT_WIDTH*17];
        18: out = inputState[INPUT_WIDTH*19-1:INPUT_WIDTH*18];
        19: out = inputState[INPUT_WIDTH*20-1:INPUT_WIDTH*19];
        20: out = inputState[INPUT_WIDTH*21-1:INPUT_WIDTH*20];
        21: out = inputState[INPUT_WIDTH*22-1:INPUT_WIDTH*21];
        22: out = inputState[INPUT_WIDTH*23-1:INPUT_WIDTH*22];
        23: out = inputState[INPUT_WIDTH*24-1:INPUT_WIDTH*23];
        24: out = inputState[INPUT_WIDTH*25-1:INPUT_WIDTH*24];
        25: out = inputState[INPUT_WIDTH*26-1:INPUT_WIDTH*25];
        26: out = inputState[INPUT_WIDTH*27-1:INPUT_WIDTH*26];
        27: out = inputState[INPUT_WIDTH*28-1:INPUT_WIDTH*27];
        28: out = inputState[INPUT_WIDTH*29-1:INPUT_WIDTH*28];
        29: out = inputState[INPUT_WIDTH*30-1:INPUT_WIDTH*29];
        30: out = inputState[INPUT_WIDTH*31-1:INPUT_WIDTH*30];
        31: out = inputState[INPUT_WIDTH*32-1:INPUT_WIDTH*31];
        32: out = inputState[INPUT_WIDTH*33-1:INPUT_WIDTH*32];
        33: out = inputState[INPUT_WIDTH*34-1:INPUT_WIDTH*33];
        34: out = inputState[INPUT_WIDTH*35-1:INPUT_WIDTH*34];
        35: out = inputState[INPUT_WIDTH*36-1:INPUT_WIDTH*35];
        36: out = inputState[INPUT_WIDTH*37-1:INPUT_WIDTH*36];
        37: out = inputState[INPUT_WIDTH*38-1:INPUT_WIDTH*37];
        38: out = inputState[INPUT_WIDTH*39-1:INPUT_WIDTH*38];
        39: out = inputState[INPUT_WIDTH*40-1:INPUT_WIDTH*39];
        40: out = inputState[INPUT_WIDTH*41-1:INPUT_WIDTH*40];
        41: out = inputState[INPUT_WIDTH*42-1:INPUT_WIDTH*41];
        42: out = inputState[INPUT_WIDTH*43-1:INPUT_WIDTH*42];
        43: out = inputState[INPUT_WIDTH*44-1:INPUT_WIDTH*43];
        44: out = inputState[INPUT_WIDTH*45-1:INPUT_WIDTH*44];
        45: out = inputState[INPUT_WIDTH*46-1:INPUT_WIDTH*45];
        46: out = inputState[INPUT_WIDTH*47-1:INPUT_WIDTH*46];
        47: out = inputState[INPUT_WIDTH*48-1:INPUT_WIDTH*47];
        48: out = inputState[INPUT_WIDTH*49-1:INPUT_WIDTH*48];
        49: out = inputState[INPUT_WIDTH*50-1:INPUT_WIDTH*49];
        50: out = inputState[INPUT_WIDTH*51-1:INPUT_WIDTH*50];
        51: out = inputState[INPUT_WIDTH*52-1:INPUT_WIDTH*51];
        52: out = inputState[INPUT_WIDTH*53-1:INPUT_WIDTH*52];
        53: out = inputState[INPUT_WIDTH*54-1:INPUT_WIDTH*53];
        54: out = inputState[INPUT_WIDTH*55-1:INPUT_WIDTH*54];
        55: out = inputState[INPUT_WIDTH*56-1:INPUT_WIDTH*55];
        56: out = inputState[INPUT_WIDTH*57-1:INPUT_WIDTH*56];
        57: out = inputState[INPUT_WIDTH*58-1:INPUT_WIDTH*57];
        58: out = inputState[INPUT_WIDTH*59-1:INPUT_WIDTH*58];
        59: out = inputState[INPUT_WIDTH*60-1:INPUT_WIDTH*59];
        60: out = inputState[INPUT_WIDTH*61-1:INPUT_WIDTH*60];
        61: out = inputState[INPUT_WIDTH*62-1:INPUT_WIDTH*61];
        62: out = inputState[INPUT_WIDTH*63-1:INPUT_WIDTH*62];
        63: out = inputState[INPUT_WIDTH*64-1:INPUT_WIDTH*63];
        64: out = inputState[INPUT_WIDTH*65-1:INPUT_WIDTH*64];
        65: out = inputState[INPUT_WIDTH*66-1:INPUT_WIDTH*65];
        66: out = inputState[INPUT_WIDTH*67-1:INPUT_WIDTH*66];
        67: out = inputState[INPUT_WIDTH*68-1:INPUT_WIDTH*67];
        68: out = inputState[INPUT_WIDTH*69-1:INPUT_WIDTH*68];
        69: out = inputState[INPUT_WIDTH*70-1:INPUT_WIDTH*69];
        70: out = inputState[INPUT_WIDTH*71-1:INPUT_WIDTH*70];
        71: out = inputState[INPUT_WIDTH*72-1:INPUT_WIDTH*71];
        72: out = inputState[INPUT_WIDTH*73-1:INPUT_WIDTH*72];
        73: out = inputState[INPUT_WIDTH*74-1:INPUT_WIDTH*73];
        74: out = inputState[INPUT_WIDTH*75-1:INPUT_WIDTH*74];
        75: out = inputState[INPUT_WIDTH*76-1:INPUT_WIDTH*75];
        76: out = inputState[INPUT_WIDTH*77-1:INPUT_WIDTH*76];
        77: out = inputState[INPUT_WIDTH*78-1:INPUT_WIDTH*77];
        78: out = inputState[INPUT_WIDTH*79-1:INPUT_WIDTH*78];
        79: out = inputState[INPUT_WIDTH*80-1:INPUT_WIDTH*79];
        80: out = inputState[INPUT_WIDTH*81-1:INPUT_WIDTH*80];
        81: out = inputState[INPUT_WIDTH*82-1:INPUT_WIDTH*81];
        82: out = inputState[INPUT_WIDTH*83-1:INPUT_WIDTH*82];
        83: out = inputState[INPUT_WIDTH*84-1:INPUT_WIDTH*83];
        84: out = inputState[INPUT_WIDTH*85-1:INPUT_WIDTH*84];
        85: out = inputState[INPUT_WIDTH*86-1:INPUT_WIDTH*85];
        86: out = inputState[INPUT_WIDTH*87-1:INPUT_WIDTH*86];
        87: out = inputState[INPUT_WIDTH*88-1:INPUT_WIDTH*87];
        88: out = inputState[INPUT_WIDTH*89-1:INPUT_WIDTH*88];
        89: out = inputState[INPUT_WIDTH*90-1:INPUT_WIDTH*89];
        90: out = inputState[INPUT_WIDTH*91-1:INPUT_WIDTH*90];
        91: out = inputState[INPUT_WIDTH*92-1:INPUT_WIDTH*91];
        92: out = inputState[INPUT_WIDTH*93-1:INPUT_WIDTH*92];
        93: out = inputState[INPUT_WIDTH*94-1:INPUT_WIDTH*93];
        94: out = inputState[INPUT_WIDTH*95-1:INPUT_WIDTH*94];
        95: out = inputState[INPUT_WIDTH*96-1:INPUT_WIDTH*95];
        96: out = inputState[INPUT_WIDTH*97-1:INPUT_WIDTH*96];
        97: out = inputState[INPUT_WIDTH*98-1:INPUT_WIDTH*97];
        98: out = inputState[INPUT_WIDTH*99-1:INPUT_WIDTH*98];
        99: out = inputState[INPUT_WIDTH*100-1:INPUT_WIDTH*99];
        100: out = inputState[INPUT_WIDTH*101-1:INPUT_WIDTH*100];
        101: out = inputState[INPUT_WIDTH*102-1:INPUT_WIDTH*101];
        102: out = inputState[INPUT_WIDTH*103-1:INPUT_WIDTH*102];
        103: out = inputState[INPUT_WIDTH*104-1:INPUT_WIDTH*103];
        104: out = inputState[INPUT_WIDTH*105-1:INPUT_WIDTH*104];
        105: out = inputState[INPUT_WIDTH*106-1:INPUT_WIDTH*105];
        106: out = inputState[INPUT_WIDTH*107-1:INPUT_WIDTH*106];
        107: out = inputState[INPUT_WIDTH*108-1:INPUT_WIDTH*107];
        108: out = inputState[INPUT_WIDTH*109-1:INPUT_WIDTH*108];
        109: out = inputState[INPUT_WIDTH*110-1:INPUT_WIDTH*109];
        110: out = inputState[INPUT_WIDTH*111-1:INPUT_WIDTH*110];
        111: out = inputState[INPUT_WIDTH*112-1:INPUT_WIDTH*111];
        112: out = inputState[INPUT_WIDTH*113-1:INPUT_WIDTH*112];
        113: out = inputState[INPUT_WIDTH*114-1:INPUT_WIDTH*113];
        114: out = inputState[INPUT_WIDTH*115-1:INPUT_WIDTH*114];
        115: out = inputState[INPUT_WIDTH*116-1:INPUT_WIDTH*115];
        116: out = inputState[INPUT_WIDTH*117-1:INPUT_WIDTH*116];
        117: out = inputState[INPUT_WIDTH*118-1:INPUT_WIDTH*117];
        118: out = inputState[INPUT_WIDTH*119-1:INPUT_WIDTH*118];
        119: out = inputState[INPUT_WIDTH*120-1:INPUT_WIDTH*119];
        120: out = inputState[INPUT_WIDTH*121-1:INPUT_WIDTH*120];
        121: out = inputState[INPUT_WIDTH*122-1:INPUT_WIDTH*121];
        122: out = inputState[INPUT_WIDTH*123-1:INPUT_WIDTH*122];
        123: out = inputState[INPUT_WIDTH*124-1:INPUT_WIDTH*123];
        124: out = inputState[INPUT_WIDTH*125-1:INPUT_WIDTH*124];
        125: out = inputState[INPUT_WIDTH*126-1:INPUT_WIDTH*125];
        126: out = inputState[INPUT_WIDTH*127-1:INPUT_WIDTH*126];
        127: out = inputState[INPUT_WIDTH*128-1:INPUT_WIDTH*127];
*/	default : out = 0;
      endcase
   end
endmodule
