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

module unitTestNext();
  reg clk;
  wire rst;
  reg start;
  reg test_expr;
  wire inv;
  wire assert;
  
  initial begin
    clk = 1'b0;
    start = 1'b0;
    test_expr = 1'b0;
  end
   
  assign rst = 1'b0;
  assign inv = 1'b0;
  
  always begin
    #10 clk = ~clk;
    #10 clk = ~clk;
    // Make sure missing start doesn't fire
    test_expr = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    // Test to make sure test can fire early and stay late as long as it is valid at num cks
    start = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start =1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    // Test normal operation
    start = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start = 1'b0; 
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    // Test for assertion violations
    start = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b1; 
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0; 
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    // Test for overlapping starts
    start = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    start = 1'b0;
    test_expr = 1'b1;    
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b1;
    #10 clk = ~clk;
    #10 clk = ~clk;
    test_expr = 1'b0;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;
    #10 clk = ~clk;     
  end
  
  ovl_next_wrapped onw(
    .clk(clk),
    .rst(rst),
    .num_cks(3'd3),
    .start_event(start),
    .test_expr(test_expr),
    .prevConfigInvalid(inv),
    .out(assert)
  );
endmodule