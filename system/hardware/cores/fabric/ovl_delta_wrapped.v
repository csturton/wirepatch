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

module ovl_delta_wrapped(
    clk,
    rst,
    min,
    max,
    test_expr,
    prevConfigInvalid,
    out
);

   //Explicit state space exploration not feasible for large values of test_expr
`ifdef SMV
   parameter width = 12;
   parameter limit_width = 3;
`else
   parameter width = 32;
   parameter limit_width = 8;
`endif
   
    input clk;
    input rst;
    input [limit_width-1:0] min;
    input [limit_width-1:0] max;
    input [width-1:0]       test_expr;
    input  prevConfigInvalid;
    output out;

    wire [2:0]  result_3bit;
    wire [2:0] 	result_3bit_comb;
   
`ifdef SMV
   ovl_delta ovl_delta(.width(width),
	                     .limit_width(limit_width),
                       .clock(clk),
	                     .reset(rst),
                       .enable(1'b1),
	                     .min(min),
	                     .max(max),
	                     .test_expr(test_expr),
	                     .fire(result_3bit),
	.fire_comb(result_3bit_comb)
                       );
`else // !`ifdef SMV
   ovl_delta #(
    	.width(width),
	.limit_width(limit_width)
    )
    ovl_delta(
        .clock(clk),
	.reset(rst),
        .enable(1'b1),
	.min(min),
	.max(max),
	.test_expr(test_expr),
	.fire(result_3bit),
	.fire_comb(result_3bit_comb)
    );
`endif // !`ifdef SMV
   
   
    assign out = result_3bit_comb[0] & ~prevConfigInvalid;
endmodule
