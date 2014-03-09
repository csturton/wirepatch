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

`timescale 1ns/1ns

module unitTestOVL();
  reg clk;
  wire rst;
  reg a;
  reg b;
  wire inv;
  wire assert_edge, assert_always;
  
  initial begin
    clk = 1'b0;
    a = 1'b0;
    b = 1'b0;
  end
   
  assign rst = 1'b0;
  assign inv = 1'b0;
  
  //b 0 to 1 then back
  //a 0 to 1 directly followed by b 0 to 1 then b back
  //a 1 to 0
  //a 0 to 1 while b stays at 0
  
  always begin
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    b = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    b = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    a = 1;
    b = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    b = 0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    a = 0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    a = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    a = 0;
    b = 1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
  end
  
  ovl_always_on_edge_wrapped oaoew(
    .clk(clk),
    .rst(rst),
    .sampling_event(a),
    .test_expr(b),
    .prevConfigInvalid(inv),
    .out(assert_edge)
  );
  
  ovl_always_wrapped oaw(
    .clk(clk),
    .rst(rst),
    .test_expr(b),
    .prevConfigInvalid(inv),
    .out(assert_always)
  );
endmodule