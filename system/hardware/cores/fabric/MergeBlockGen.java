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

public class MergeBlockGen
{
	private static final int NUM_INPUTS = 6;
	
	public static void main(String[] args)
	{
		System.out.println("`include \"globalDefines.vh\"");
		System.out.println("");
		System.out.println("module mergeBlock(");
		System.out.println("\tassert1, assert2, assert3, assert4, assert5, assert6,");
		System.out.println("\tout");
		System.out.println(");");
		System.out.println("\tinput     assert1;");
		System.out.println("\tinput     assert2;");
		System.out.println("\tinput     assert3;");
		System.out.println("\tinput     assert4;");
		System.out.println("\tinput     assert5;");
		System.out.println("\tinput     assert6;");
		System.out.println("\toutput    out;");
		System.out.println("\treg       out;");
		System.out.println("");
		System.out.println("\talways @(assert1 or assert2 or assert3 or assert4 or assert5 or assert6) begin");
		System.out.println("\t\tcase({assert1, assert2, assert3, assert4, assert5, assert6})");
		
		for(int caseNum = 0; caseNum < Math.pow(2.0, NUM_INPUTS); ++caseNum)
			System.out.println("\t\t\t" + caseNum + ": out = 1'b" + (int)Math.rint(Math.random()) + ";");
		
		System.out.println("\t\t\tdefault: out = 1'b0;");
		System.out.println("\t\tendcase");
		System.out.println("\tend");
		System.out.println("endmodule");
	}

}
// does it work correctly
// how does each block scale
	// power, area, and max freq. all on same plot using relative scale
