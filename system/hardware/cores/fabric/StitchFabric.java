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

import java.util.ArrayList;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.IOException;

public class StitchFabric {
	private static final int LUT_INPUTS = 6;

	private static final int ROUTING_INPUT_BITS = 544;
        
        private static final int ROUTING_INPUT_INDV_BITS = 32; // Chunk size of the data grouped together and sent to the rounting layer
	private static final int ROUTING_SELECT_BITS = (int) Math.ceil(Math.log(ROUTING_INPUT_BITS / ROUTING_INPUT_INDV_BITS) / Math.log(2));
	private static final int LOGIC_MASK_BITS = 32;
	private static final int LOGIC_CONSTANT_BITS = 32;
	private static final int LOGIC_OPB_MUX_BITS = 1;
	private static final int LOGIC_RESULT_MUX_BITS = 3;
	private static final int ASSERTION_SELECT_BITS = 2;
	private static final int ASSERTION_CLOCK_BITS = 3;
        private static final int MAX_NUM_ASSERTIONS = 32;

	private static final ArrayList<String> inputWires = new ArrayList<String>();
	private static final ArrayList<String> lines = new ArrayList<String>(200);

	public static void main(String args[])throws IOException {
		if (args.length != 1)
		{
			System.out.println("Usage: java StitchFabric numAsserts");
			System.exit(-1);
		}

		int numAssertions = Integer.parseInt(args[0]);
		if(numAssertions <= 0)
		{
		    System.out.println("Usage: java StitchFabric numAsserts");
		    System.out.println("numAsserts > 0");
		    System.exit(-1);
		}
		int numLogicBlocks = numAssertions * 2;
		int numRoutingBlocks = numLogicBlocks * 2;

		printRoutingBlocks(numRoutingBlocks);
		printLogicBlocks(numLogicBlocks);
		printAssertionBlocks(numAssertions);
		printMergeBlock(numAssertions);
		printFooter();
		PrintWriter fabricFile = openForWrite("assertionFabric.v");
		printHeader(numAssertions, fabricFile);
		fabricFile.close();

		printTestRig(numAssertions, openForWrite("assertionFabricDriver.v"));
	}

        private static void printHeader(int pNumAssertions, PrintWriter pOutStream) {
		pOutStream.println("`include \"globalDefines.vh\"");
		pOutStream.println("\n");
		pOutStream.println("module assertionFabric(");
		pOutStream.println("\tclk, rst, enable,");
		pOutStream.println("\tbakedInAssertions,");

		// Print all of the configuration signals
		for (String entry : inputWires) {
			pOutStream.println("\t" + entry + ",");
		}

		pOutStream.println("\tassertionViolated,");
		pOutStream.println("\tassertionsViolated");
		pOutStream.println(");\n");

		// Define all of the configuration signals
		pOutStream.println("\tinput clk;\n\tinput rst;\n\tinput enable;");
		pOutStream.println("\tinput [31:0] bakedInAssertions;");
		for (String entry : inputWires) {
			pOutStream.println("\tinput " + getSizeNameString(entry) + ";");
		}

		pOutStream.println("\toutput assertionViolated;");
		pOutStream.println("\toutput [" + (MAX_NUM_ASSERTIONS-1) + ":0] assertionsViolated;\n");

		// Print the rest of the lines to the screen
		for (String entry : lines) {
			pOutStream.println(entry);
		}
	}

	// When passed the name of a wire, the method determines
	// the number of bits required by the wire and returns a
	// string of the form "['NUM_BITS-1':0] wireName"
	// Defaults to returning an implicit size of 1-bit
	private static String getSizeNameString(String pWireName) {
		String name = pWireName.trim();
		int upperLim = 0;

		if (name.equals("routingInput"))
			return "[`ROUTING_INPUT_BITS-1:0] routingInput";
		else if (name.startsWith("routingBlock") && name.endsWith("_inputSelect"))
		    upperLim = ROUTING_SELECT_BITS - 1;
		else if (name.startsWith("assertionBlock"))
		{
		    if(name.endsWith("_select"))
			upperLim = ASSERTION_SELECT_BITS - 1;
		    else if (name.endsWith("_num_cks"))
			upperLim = ASSERTION_CLOCK_BITS - 1;
		}
		else if (name.startsWith("logicBlock"))
			if (name.contains("_mask"))
				upperLim = LOGIC_MASK_BITS - 1;
			else if (name.endsWith("_constant"))
				upperLim = LOGIC_CONSTANT_BITS - 1;
			else if (name.endsWith("_opBMux"))
				upperLim = LOGIC_OPB_MUX_BITS - 1;
			else if (name.endsWith("_resultMux"))
				upperLim = LOGIC_RESULT_MUX_BITS - 1;

		return (upperLim == 0) ? name : "[" + upperLim + ":0] " + name;
	}

	private static void printRoutingBlocks(int pNumBlocks) {
		inputWires.add("routingInput");

		for (int count = 0; count < pNumBlocks; ++count) {
			String blockName = "routingBlock_" + count;
			String selectName = blockName + "_inputSelect";

			lines.add("\twire " + blockName + "_configInvalid;");
			lines.add("\twire [31:0] " + blockName + "_result;");
			lines.add("\troutingBlock " + blockName + "(");
			lines.add("\t\t.inputState(routingInput),");
			lines.add("\t\t.inputSelect(" + selectName + "),");
			lines.add("\t\t.out(" + blockName + "_result),");
			lines.add("\t\t.configInvalid(" + blockName + "_configInvalid)");
			lines.add("\t);\n");

			// Declare the wires that attach at the border of this module
			inputWires.add(selectName);
		}
	}

	private static void printLogicBlocks(int pNumBlocks) {
		for (int count = 0; count < pNumBlocks; ++count) {
			String blockName = "logicBlock_" + count;
			String routingBlock1 = "routingBlock_" + (count * 2) + "_";
			String routingBlock2 = "routingBlock_" + (count * 2 + 1) + "_";

			lines.add("\twire " + blockName + "_configInvalid;");
			lines.add("\twire " + blockName + "_result;");
			lines.add("\tlogicBlock " + blockName + "(");
			lines.add("\t\t.stateA(" + routingBlock1 + "result),");
			lines.add("\t\t.maskA(" + blockName + "_maskA),");
			lines.add("\t\t.stateB(" + routingBlock2 + "result),");
			lines.add("\t\t.maskB(" + blockName + "_maskB),");
			lines.add("\t\t.constant(" + blockName + "_constant),");
			lines.add("\t\t.opBMux(" + blockName + "_opBMux),");
			lines.add("\t\t.prevConfigInvalid(" + routingBlock1
					+ "configInvalid | " + routingBlock2 + "configInvalid),");
			lines.add("\t\t.resultMux(" + blockName + "_resultMux),");
			lines.add("\t\t.out(" + blockName + "_result),");
			lines.add("\t\t.configInvalid(" + blockName + "_configInvalid)");
			lines.add("\t);\n");

			// Declare the wires that attach at the border of this module
			inputWires.add(blockName + "_maskA");
			inputWires.add(blockName + "_maskB");
			inputWires.add(blockName + "_constant");
			inputWires.add(blockName + "_opBMux");
			inputWires.add(blockName + "_resultMux");
		}
	}

	private static void printAssertionBlocks(int pNumBlocks) {
		for (int count = 0; count < pNumBlocks; ++count) {
			String blockName = "assertionBlock_" + count;
			String logicBlock1 = "logicBlock_" + (count * 2) + "_";
			String logicBlock2 = "logicBlock_" + (count * 2 + 1) + "_";

			lines.add("\twire " + blockName + "_result;");
			lines.add("\twire " + blockName + "_result_comb;");
			lines.add("\twire " + blockName + "_result_delayed;");
			lines.add("\twire " + blockName + "_configInvalid;");
			lines.add("\tovl_combo_wrapped " + blockName + "(");
			lines.add("\t\t.clk(clk),");
			lines.add("\t\t.rst(rst),");
			lines.add("\t\t.enable(enable),");
			lines.add("\t\t.num_cks(" + blockName + "_num_cks),");
    			lines.add("\t\t.start_event(" + logicBlock1 + "result),");
			lines.add("\t\t.test_expr(" + logicBlock2 + "result),");
			lines.add("\t\t.prevConfigInvalid(" + logicBlock1 + "configInvalid | " + logicBlock2 + "configInvalid),");
			lines.add("\t\t.select(" + blockName + "_select),");
			lines.add("\t\t.out(" + blockName + "_result_comb),");
			lines.add("\t\t.out_delayed(" + blockName + "_result_delayed),");
			lines.add("\t\t.configInvalid(" + blockName + "_configInvalid)");
			lines.add("\t);\n");


			lines.add("\tassign " + blockName + "_result = " + blockName + "_res_sel ? " + blockName + "_result_delayed : " + blockName + "_result_comb;\n");

			// Declare the wires that attach at the border of this module
			inputWires.add(blockName + "_num_cks");
			inputWires.add(blockName + "_select");
			inputWires.add(blockName + "_res_sel");
		}


		int count;
		// Merge the config invalids to determine if any config was invalid
		lines.add("\twire anyConfigInvalid = ");
		for(count = 0; count < pNumBlocks-1; ++count)
		{
		    lines.add("\t\tassertionBlock_" + count + "_configInvalid | ");
		}
		lines.add("\t\tassertionBlock_" + count + "_configInvalid;\n");

		// Group the assertion outputs into a single signal
		lines.add("\tassign assertionsViolated = {");
		for(count = 0; count < pNumBlocks-1; ++count)
		{
		    lines.add("\t\tassertionBlock_" + count + "_result, ");
		}
		lines.add("\t\tassertionBlock_" + count + "_result};\n");
	}

	// Use a recursive function to print the appropriate number of
	// LUTs to combine all all assertion results
	private static void printMergeBlock(int pNumInputs) {
		printLevelOfLUTs(pNumInputs, 0);
	}

	// Recursive function that prints a level of LUTs in the merge tree
	private static void printLevelOfLUTs(int pNumInputs, int pLevel) {
		int lutCount = pNumInputs / 6;

		// Round-up to the nearest whole LUT
		lutCount = (pNumInputs % LUT_INPUTS) == 0 ? lutCount : ++lutCount;

		for (int count = 0; count < lutCount; ++count) {
			// For the last LUT, send the number of inputs used
			// If the last LUT isn't full
			if (count == (lutCount - 1) && (pNumInputs % LUT_INPUTS) != 0) {
				printLUT(count, pLevel, (pNumInputs % LUT_INPUTS));
			} else {
				printLUT(count, pLevel, LUT_INPUTS);
			}
		}

		// If this level contains more than one LUT, we will need
		// another level to combine the results of this level
		if(lutCount == 0)
		{
		    lines.add("\tassign assertionViolated = 1'b0;");
		}
		else if(lutCount != 1)
		{
		    printLevelOfLUTs(lutCount, pLevel + 1);
		}
		else
		{
		    lines.add("\tassign assertionViolated = mergeBlock_" + pLevel + "_0_result & ~anyConfigInvalid;");
		}
	}

	// Given the number of the LUT at the passed level, this method
	// prints a block of code that instantiates a LUT and names
	// the input and output signals using a regular pattern
	private static void printLUT(int pID, int pLevel, int pUsedInputs) {
		String lutName = "mergeBlock_" + pLevel + "_" + pID;
		String prevLUTLevelName = "mergeBlock_" + (pLevel - 1) + "_";
		String assertLevelName = "assertionBlock_";
		String prevLevel = pLevel == 0 ? assertLevelName : prevLUTLevelName;

		lines.add("\twire " + lutName + "" + "_result;");
		lines.add("\tmergeBlock " + lutName + "(");

		for (int inCount = 0; inCount < LUT_INPUTS; ++inCount) {
			int inputID = (pID * LUT_INPUTS) + inCount;
			if (inCount < pUsedInputs) {
				lines.add("\t\t.assert" + (inCount + 1) + "(" + prevLevel + ""
						+ inputID + "_result),");
			} else {
				lines.add("\t\t.assert" + (inCount + 1) + "(1'b0),");
			}
		}

		lines.add("\t\t.out(" + lutName + "_result)");
		lines.add("\t);\n");
	}

	// Print what is required to close-out the module
        private static void printFooter() {
		lines.add("endmodule");
	}

    private static PrintWriter openForWrite(String pFilename)throws IOException
    {
	PrintWriter file = new PrintWriter(new BufferedWriter(new FileWriter(pFilename)));
	return file;
    }

    private static void printTestRig(int pNumAssertions, PrintWriter pOutStream) {
	    pOutStream.println("`include \"globalDefines.vh\"\n");
	    pOutStream.println("module assertionFabricDriver(");
	    pOutStream.println("\tclk,");
	    pOutStream.println("\trst,");
	    pOutStream.println("\tenable,");
	    pOutStream.println("\troutingInput,");
	    pOutStream.println("\tbakedInAssertions,");
	    pOutStream.println("\taddress,");
	    pOutStream.println("\tdata,");
	    pOutStream.println("\tstrobe,");
	    pOutStream.println("\tassertionViolated,");
	    pOutStream.println("\tassertionsViolated");
	    pOutStream.println(");");

	    pOutStream.println("\t// Module interface definition");
	    pOutStream.println("\tinput clk;");
	    pOutStream.println("\tinput rst;");
	    pOutStream.println("\tinput enable;");
	    pOutStream.println("\tinput [`ROUTING_INPUT_BITS-1:0] routingInput;");
	    pOutStream.println("\tinput [31:0] bakedInAssertions;");
	    pOutStream.println("\tinput [31:0] address;");
	    pOutStream.println("\tinput [31:0] data;");
	    pOutStream.println("\tinput strobe;");
	    pOutStream.println("\toutput assertionViolated;");
	    pOutStream.println("\toutput [" + (MAX_NUM_ASSERTIONS-1) + ":0] assertionsViolated;");
	    pOutStream.println("\treg [" + (MAX_NUM_ASSERTIONS-1) + ":0] assertionsViolated;");
	    pOutStream.println("");

	    pOutStream.println("\t// Internal wires and registers");
	    pOutStream.println("\twire assertionViolated_in;");
	    pOutStream.println("\twire [" + (MAX_NUM_ASSERTIONS-1) + ":0] assertionsViolated_in;");
	    pOutStream.println("\treg fabric_enable;");
	    pOutStream.println("\treg strobe_prev;");
	    pOutStream.println("");

	    pOutStream.println("\tassign assertionViolated = assertionViolated_in;");
	    pOutStream.println("");

	    pOutStream.println("\t// Latch the set of assertions violated when a higher-level assertion is violated");
	    pOutStream.println("\talways @(posedge clk) begin");
	    pOutStream.println("\t\tif(rst == `OR1200_RST_VALUE)");
	    pOutStream.println("\t\t\tassertionsViolated <= 0;");
	    pOutStream.println("\t\telse if(assertionViolated == 1'b1)");
	    pOutStream.println("\t\t\tassertionsViolated <= assertionsViolated_in & fabric_enable;");
	    pOutStream.println("\tend");
	    pOutStream.println("");

		// Declare all config signals as reg
		for (String entry : inputWires) {
			if (entry.equals("routingInput")) {
				continue;
			}

			pOutStream.println("\treg " + getSizeNameString(entry) + ";");
		}
	    pOutStream.println("");

	    pOutStream.println("\t// Connect this driver to the assertion fabric");
	    pOutStream.println("\tassertionFabric assertionFabric(");
	    pOutStream.println("\t\t.clk(clk),");
	    pOutStream.println("\t\t.rst(rst),");
	    pOutStream.println("\t\t.enable(enable),");
	    pOutStream.println("\t\t.bakedInAssertions(bakedInAssertions),");
	    pOutStream.println("\t\t// Connect the configuration registers of this driver to the configuration ports of the assertion fabric");
	    for (String entry : inputWires) {
		pOutStream.println("\t\t." + entry + "(" + entry + "),");
	    }
	    pOutStream.println("\t\t.assertionViolated(assertionViolated_in),");
	    pOutStream.println("\t\t.assertionsViolated(assertionsViolated_in)");
	    pOutStream.println("\t);");
	    pOutStream.println("");

	    pOutStream.println("\t// Use address, data, and strobe to load the configuration registers and the enable");
	    pOutStream.println("\talways @(posedge clk) begin");
	    pOutStream.println("\t\tstrobe_prev <= strobe;");
	    pOutStream.println("\t\tif(rst == `OR1200_RST_VALUE) begin");
	    pOutStream.println("\t\t\tfabric_enable <= 0;");
	    pOutStream.println("\t\t\tstrobe_prev <= 0;");
	    pOutStream.println("\t\t\t// Reset each config to 0");
	    for (String entry : inputWires) {
		if (entry.equals("routingInput")) {
		    continue;
		}
		pOutStream.println("\t\t\t" + entry + " <= 0;");
	    }
	    pOutStream.println("\t\tend");
	    pOutStream.println("\t\t// Write data to the address only when strobe goes high");
	    pOutStream.println("\t\telse if(~strobe_prev & strobe) begin");
	    pOutStream.println("\t\t\tcase(address)");
	    pOutStream.println("\t\t\t\t32'd0: fabric_enable <= data[0];");
	    int caseNum = 1;
	    for (String entry : inputWires) {
		if (entry.equals("routingInput")) {
		    continue;
		}
		pOutStream.println("\t\t\t\t32'd" + caseNum + ": " + entry + " <= data;");
		++caseNum;
	    }
	    pOutStream.println("\t\t\t\tdefault: ;");
	    pOutStream.println("\t\t\tendcase");
	    pOutStream.println("\t\tend");
	    pOutStream.println("\tend");
	    pOutStream.println("endmodule");
	    
	    pOutStream.close();
	}
}
