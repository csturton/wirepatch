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

`ifdef SMV
 `include "../or1200/or1200_defines.v"
`else
 `include "or1200_defines.v"
`endif

module ovl_combo_wrapped(
    clk,
    rst,
    enable,
    num_cks,
    start_event,
    test_expr,
    select,
    prevConfigInvalid,
    out,
    out_delayed,
    configInvalid
);

    parameter num_cks_max = 7;
    parameter num_cks_width = 3;
   
    input clk;
    input rst;
    input enable;
    input [num_cks_width-1:0] num_cks;
    input start_event;
    input test_expr;
    input [1:0] select;
    input  prevConfigInvalid;
    output out;
    output out_delayed;
    output configInvalid;

    reg out_delayed;
    wire [2:0] 	result_3bit_comb;

`ifdef SMV
   ovl_combo ovl_combo (.num_cks_max(7),
	           .num_cks_width(3),
             .clock(clk),
	           .reset(rst),
             .enable(enable),
	           .num_cks(num_cks),
	           .start_event(start_event),
	           .test_expr(test_expr),
			.select(select),
	.fire_comb(result_3bit_comb)
             );
`else // !`ifdef SMV
   ovl_combo #(
        .num_cks_max(7),
	.num_cks_width(3)
   ) ovl_combo(
        .clock(clk),
	.reset(rst),
        .enable(enable),
	.num_cks(num_cks),
	.start_event(start_event),
	.test_expr(test_expr),
	.select(select),
	.fire_comb(result_3bit_comb)
   );
`endif // !`ifdef SMV


   always @(posedge clk)
     if(rst == `OR1200_RST_VALUE)
       out_delayed <= 1'b0;
     else if(enable)
       out_delayed <= result_3bit_comb[0];
     
    // It is invalid if num_cks == 0 and next or on edge format selected
   //(CKS) Fixed a bug! was prevConfigInvalid & ...
    assign configInvalid = prevConfigInvalid | (~|num_cks & ~select[1]);

   //(CKS) I added the &configInvalid
   assign out = result_3bit_comb[0];
   

endmodule
