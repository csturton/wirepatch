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

/*function [31:0] log2;
   input reg [31:0] value;
   begin
      value = value-1;

      for (log2=0; value>0; log2=log2+1)
	value = value>>1;
   end
endfunction*/

module logicBlock(
		  stateA, maskA, stateB, maskB, constant, opBMux,
		  prevConfigInvalid,
		  resultMux, out,
		  configInvalid
);
   input [31:0] stateA;
   input [31:0] stateB;
   input [31:0] maskA;     // Configuration
   input [31:0] maskB;     // Configuration
   input [31:0] constant;  // Configuration
   input        opBMux;    // Configuration, 1 = stateB, 0 = constant
   input [2:0]  resultMux; // Configuration, 0 = ==, 1 = !=, 2 = >,
                           // 3 = >=, 4 = <, 5 = <=
   input        prevConfigInvalid;					
   output       out;
   output       configInvalid;
   
   reg          out;
   wire         configInvalid;
   
   // Create both operands
   wire 	[31:0] maskedA = stateA & maskA;
   wire 	[31:0] operandA = maskedA;
   wire 	[31:0] maskedB = stateB & maskB;
   wire 	[31:0] operandB = opBMux ? maskedB : constant;

   // Perform the operations in parallel
   wire 	eq = operandA == operandB;
   wire 	neq = operandA != operandB;
   wire 	gt = operandA > operandB;
   wire 	gteq = operandA >= operandB;
   wire 	lt = operandA < operandB;
   wire 	lteq = operandA `LTEQ operandB;

   // Check for valid configurations
   assign configInvalid = prevConfigInvalid | (resultMux > 3'd5);

   
   
   // Send the correct result to the output
   always @(resultMux or eq or neq or gt or gteq or lt or lteq) begin
      case(resultMux)
	0: out = eq;
	1: out = neq;
	2: out = gt;
	3: out = gteq;
	4: out = lt;
	5: out = lteq;
	default : out = 0;
      endcase
   end
endmodule

