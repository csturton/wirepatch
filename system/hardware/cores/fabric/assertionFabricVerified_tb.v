`define SMV

`include "assertionFabricVerified.v"

/*
 
 * File: assertionFabricVerified_tb.v
 * Verification driver for assertionFabricVerified.v
 * Includes assertions for verification
 * 
 */

module main();

   // Inputs to DUT
	reg clk;
	reg rst;
	reg enable;
	reg [31:0] bakedInAssertions;
	reg [`ROUTING_INPUT_BITS-1:0] routingInput;
	reg [4:0] routingBlock_0_inputSelect;
	reg [4:0] routingBlock_1_inputSelect;
	reg [4:0] routingBlock_2_inputSelect;
	reg [4:0] routingBlock_3_inputSelect;
	reg [4:0] routingBlock_4_inputSelect;
	reg [4:0] routingBlock_5_inputSelect;
	reg [4:0] routingBlock_6_inputSelect;
	reg [4:0] routingBlock_7_inputSelect;
	reg [4:0] routingBlock_8_inputSelect;
	reg [4:0] routingBlock_9_inputSelect;
	reg [4:0] routingBlock_10_inputSelect;
	reg [4:0] routingBlock_11_inputSelect;
	reg [4:0] routingBlock_12_inputSelect;
	reg [4:0] routingBlock_13_inputSelect;
	reg [4:0] routingBlock_14_inputSelect;
	reg [4:0] routingBlock_15_inputSelect;
	reg [4:0] routingBlock_16_inputSelect;
	reg [4:0] routingBlock_17_inputSelect;
	reg [4:0] routingBlock_18_inputSelect;
	reg [4:0] routingBlock_19_inputSelect;
	reg [31:0] logicBlock_0_maskA;
	reg [31:0] logicBlock_0_maskB;
	reg [31:0] logicBlock_0_constant;
	reg logicBlock_0_opBMux;
	reg [2:0] logicBlock_0_resultMux;
	reg [31:0] logicBlock_1_maskA;
	reg [31:0] logicBlock_1_maskB;
	reg [31:0] logicBlock_1_constant;
	reg logicBlock_1_opBMux;
	reg [2:0] logicBlock_1_resultMux;
	reg [31:0] logicBlock_2_maskA;
	reg [31:0] logicBlock_2_maskB;
	reg [31:0] logicBlock_2_constant;
	reg logicBlock_2_opBMux;
	reg [2:0] logicBlock_2_resultMux;
	reg [31:0] logicBlock_3_maskA;
	reg [31:0] logicBlock_3_maskB;
	reg [31:0] logicBlock_3_constant;
	reg logicBlock_3_opBMux;
	reg [2:0] logicBlock_3_resultMux;
	reg [31:0] logicBlock_4_maskA;
	reg [31:0] logicBlock_4_maskB;
	reg [31:0] logicBlock_4_constant;
	reg logicBlock_4_opBMux;
	reg [2:0] logicBlock_4_resultMux;
	reg [31:0] logicBlock_5_maskA;
	reg [31:0] logicBlock_5_maskB;
	reg [31:0] logicBlock_5_constant;
	reg logicBlock_5_opBMux;
	reg [2:0] logicBlock_5_resultMux;
	reg [31:0] logicBlock_6_maskA;
	reg [31:0] logicBlock_6_maskB;
	reg [31:0] logicBlock_6_constant;
	reg logicBlock_6_opBMux;
	reg [2:0] logicBlock_6_resultMux;
	reg [31:0] logicBlock_7_maskA;
	reg [31:0] logicBlock_7_maskB;
	reg [31:0] logicBlock_7_constant;
	reg logicBlock_7_opBMux;
	reg [2:0] logicBlock_7_resultMux;
	reg [31:0] logicBlock_8_maskA;
	reg [31:0] logicBlock_8_maskB;
	reg [31:0] logicBlock_8_constant;
	reg logicBlock_8_opBMux;
	reg [2:0] logicBlock_8_resultMux;
	reg [31:0] logicBlock_9_maskA;
	reg [31:0] logicBlock_9_maskB;
	reg [31:0] logicBlock_9_constant;
	reg logicBlock_9_opBMux;
	reg [2:0] logicBlock_9_resultMux;
	reg [2:0] assertionBlock_0_num_cks;
	reg [1:0] assertionBlock_0_select;
	reg assertionBlock_0_res_sel;
	reg [2:0] assertionBlock_1_num_cks;
	reg [1:0] assertionBlock_1_select;
	reg assertionBlock_1_res_sel;
	reg [2:0] assertionBlock_2_num_cks;
	reg [1:0] assertionBlock_2_select;
	reg assertionBlock_2_res_sel;
	reg [2:0] assertionBlock_3_num_cks;
	reg [1:0] assertionBlock_3_select;
	reg assertionBlock_3_res_sel;
	reg [2:0] assertionBlock_4_num_cks;
	reg [1:0] assertionBlock_4_select;
	reg assertionBlock_4_res_sel;

   // Outputs of DUT
   wire assertionViolated;
   wire [31:0] assertionsViolated;
   
   
assertionFabric af_t(.clk(clk),
 .rst(rst),
 .enable(rst),
	.bakedInAssertions(bakedInAssertions),
	.routingInput(routingInput),
	.routingBlock_0_inputSelect(routingBlock_0_inputSelect),
	.routingBlock_1_inputSelect(routingBlock_1_inputSelect),
	.routingBlock_2_inputSelect(routingBlock_2_inputSelect),
	.routingBlock_3_inputSelect(routingBlock_3_inputSelect),
	.routingBlock_4_inputSelect(routingBlock_4_inputSelect),
	.routingBlock_5_inputSelect(routingBlock_5_inputSelect),
	.routingBlock_6_inputSelect(routingBlock_6_inputSelect),
	.routingBlock_7_inputSelect(routingBlock_7_inputSelect),
	.routingBlock_8_inputSelect(routingBlock_8_inputSelect),
	.routingBlock_9_inputSelect(routingBlock_9_inputSelect),
	.routingBlock_10_inputSelect(routingBlock_10_inputSelect),
	.routingBlock_11_inputSelect(routingBlock_11_inputSelect),
	.routingBlock_12_inputSelect(routingBlock_12_inputSelect),
	.routingBlock_13_inputSelect(routingBlock_13_inputSelect),
	.routingBlock_14_inputSelect(routingBlock_14_inputSelect),
	.routingBlock_15_inputSelect(routingBlock_15_inputSelect),
	.routingBlock_16_inputSelect(routingBlock_16_inputSelect),
	.routingBlock_17_inputSelect(routingBlock_17_inputSelect),
	.routingBlock_18_inputSelect(routingBlock_18_inputSelect),
	.routingBlock_19_inputSelect(routingBlock_19_inputSelect),
	.logicBlock_0_maskA(logicBlock_0_maskA),
	.logicBlock_0_maskB(logicBlock_0_maskB),
	.logicBlock_0_constant(logicBlock_0_constant),
	.logicBlock_0_opBMux(logicBlock_0_opBMux),
	.logicBlock_0_resultMux(logicBlock_0_resultMux),
	.logicBlock_1_maskA(logicBlock_1_maskA),
	.logicBlock_1_maskB(logicBlock_1_maskB),
	.logicBlock_1_constant(logicBlock_1_constant),
	.logicBlock_1_opBMux(logicBlock_1_opBMux),
	.logicBlock_1_resultMux(logicBlock_1_resultMux),
	.logicBlock_2_maskA(logicBlock_2_maskA),
	.logicBlock_2_maskB(logicBlock_2_maskB),
	.logicBlock_2_constant(logicBlock_2_constant),
	.logicBlock_2_opBMux(logicBlock_2_opBMux),
	.logicBlock_2_resultMux(logicBlock_2_resultMux),
	.logicBlock_3_maskA(logicBlock_3_maskA),
	.logicBlock_3_maskB(logicBlock_3_maskB),
	.logicBlock_3_constant(logicBlock_3_constant),
	.logicBlock_3_opBMux(logicBlock_3_opBMux),
	.logicBlock_3_resultMux(logicBlock_3_resultMux),
	.logicBlock_4_maskA(logicBlock_4_maskA),
	.logicBlock_4_maskB(logicBlock_4_maskB),
	.logicBlock_4_constant(logicBlock_4_constant),
	.logicBlock_4_opBMux(logicBlock_4_opBMux),
	.logicBlock_4_resultMux(logicBlock_4_resultMux),
	.logicBlock_5_maskA(logicBlock_5_maskA),
	.logicBlock_5_maskB(logicBlock_5_maskB),
	.logicBlock_5_constant(logicBlock_5_constant),
	.logicBlock_5_opBMux(logicBlock_5_opBMux),
	.logicBlock_5_resultMux(logicBlock_5_resultMux),
	.logicBlock_6_maskA(logicBlock_6_maskA),
	.logicBlock_6_maskB(logicBlock_6_maskB),
	.logicBlock_6_constant(logicBlock_6_constant),
	.logicBlock_6_opBMux(logicBlock_6_opBMux),
	.logicBlock_6_resultMux(logicBlock_6_resultMux),
	.logicBlock_7_maskA(logicBlock_7_maskA),
	.logicBlock_7_maskB(logicBlock_7_maskB),
	.logicBlock_7_constant(logicBlock_7_constant),
	.logicBlock_7_opBMux(logicBlock_7_opBMux),
	.logicBlock_7_resultMux(logicBlock_7_resultMux),
	.logicBlock_8_maskA(logicBlock_8_maskA),
	.logicBlock_8_maskB(logicBlock_8_maskB),
	.logicBlock_8_constant(logicBlock_8_constant),
	.logicBlock_8_opBMux(logicBlock_8_opBMux),
	.logicBlock_8_resultMux(logicBlock_8_resultMux),
	.logicBlock_9_maskA(logicBlock_9_maskA),
	.logicBlock_9_maskB(logicBlock_9_maskB),
	.logicBlock_9_constant(logicBlock_9_constant),
	.logicBlock_9_opBMux(logicBlock_9_opBMux),
	.logicBlock_9_resultMux(logicBlock_9_resultMux),
	.assertionBlock_0_num_cks(assertionBlock_0_num_cks),
	.assertionBlock_0_select(assertionBlock_0_select),
	.assertionBlock_0_res_sel(assertionBlock_0_res_sel),
	.assertionBlock_1_num_cks(assertionBlock_1_num_cks),
	.assertionBlock_1_select(assertionBlock_1_select),
	.assertionBlock_1_res_sel(assertionBlock_1_res_sel),
	.assertionBlock_2_num_cks(assertionBlock_2_num_cks),
	.assertionBlock_2_select(assertionBlock_2_select),
	.assertionBlock_2_res_sel(assertionBlock_2_res_sel),
	.assertionBlock_3_num_cks(assertionBlock_3_num_cks),
	.assertionBlock_3_select(assertionBlock_3_select),
	.assertionBlock_3_res_sel(assertionBlock_3_res_sel),
	.assertionBlock_4_num_cks(assertionBlock_4_num_cks),
	.assertionBlock_4_select(assertionBlock_4_select),
	.assertionBlock_4_res_sel(assertionBlock_4_res_sel),
	.assertionViolated(assertionViolated),
	.assertionsViolated(assertionsViolated));

   initial begin
      clk =0;
      rst=1;
      enable=0;
	    bakedInAssertions=0;
      routingInput=0;
      routingBlock_0_inputSelect=0;
      routingBlock_1_inputSelect=0;
      routingBlock_2_inputSelect=0;
      routingBlock_3_inputSelect=0;
      routingBlock_4_inputSelect=0;
      routingBlock_5_inputSelect=0;
      routingBlock_6_inputSelect=0;
      routingBlock_7_inputSelect=0;
      routingBlock_8_inputSelect=0;
      routingBlock_9_inputSelect=0;
      routingBlock_10_inputSelect=0;
      routingBlock_11_inputSelect=0;
      routingBlock_12_inputSelect=0;
      routingBlock_13_inputSelect=0;
      routingBlock_14_inputSelect=0;
      routingBlock_15_inputSelect=0;
      routingBlock_16_inputSelect=0;
      routingBlock_17_inputSelect=0;
      routingBlock_18_inputSelect=0;
      routingBlock_19_inputSelect=0;
      logicBlock_0_maskA=0;
      logicBlock_0_maskB=0;
      logicBlock_0_constant=0;
      logicBlock_0_opBMux=0;
      logicBlock_0_resultMux=0;
      logicBlock_1_maskA=0;
      logicBlock_1_maskB=0;
      logicBlock_1_constant=0;
      logicBlock_1_opBMux=0;
      logicBlock_1_resultMux=0;
      logicBlock_2_maskA=0;
      logicBlock_2_maskB=0;
      logicBlock_2_constant=0;
      logicBlock_2_opBMux=0;
      logicBlock_2_resultMux=0;
      logicBlock_3_maskA=0;
      logicBlock_3_maskB=0;
      logicBlock_3_constant=0;
      logicBlock_3_opBMux=0;
      logicBlock_3_resultMux=0;
      logicBlock_4_maskA=0;
      logicBlock_4_maskB=0;
      logicBlock_4_constant=0;
      logicBlock_4_opBMux=0;
      logicBlock_4_resultMux=0;
      logicBlock_5_maskA=0;
      logicBlock_5_maskB=0;
      logicBlock_5_constant=0;
      logicBlock_5_opBMux=0;
      logicBlock_5_resultMux=0;
      logicBlock_6_maskA=0;
      logicBlock_6_maskB=0;
      logicBlock_6_constant=0;
      logicBlock_6_opBMux=0;
      logicBlock_6_resultMux=0;
      logicBlock_7_maskA=0;
      logicBlock_7_maskB=0;
      logicBlock_7_constant=0;
      logicBlock_7_opBMux=0;
      logicBlock_7_resultMux=0;
      logicBlock_8_maskA=0;
      logicBlock_8_maskB=0;
      logicBlock_8_constant=0;
      logicBlock_8_opBMux=0;
      logicBlock_8_resultMux=0;
      logicBlock_9_maskA=0;
      logicBlock_9_maskB=0;
      logicBlock_9_constant=0;
      logicBlock_9_opBMux=0;
      logicBlock_9_resultMux=0;
      assertionBlock_0_num_cks=0;
      assertionBlock_0_select=0;
      assertionBlock_0_res_sel=0;
      assertionBlock_1_num_cks=0;
      assertionBlock_1_select=0;
      assertionBlock_1_res_sel=0;
      assertionBlock_2_num_cks=0;
      assertionBlock_2_select=0;
      assertionBlock_2_res_sel=0;
      assertionBlock_3_num_cks=0;
      assertionBlock_3_select=0;
      assertionBlock_3_res_sel=0;
      assertionBlock_4_num_cks=0;
      assertionBlock_4_select=0;
      assertionBlock_4_res_sel=0;
           end // initial

   always begin
      clk = #5 !clk;
   end
   

endmodule // main

/* *************** SMV Assertions *****************
//SMV-Assertions
#If any of the configuration data is invalid, no asserts will fire. Start easy. any internal configInvalid signals -> no assert
no_asserts_for_invalid_assertionBlock_configuration : assert \rst -> X(G(((\af_t .\assertionBlock_0_configInvalid ) || (\af_t .\assertionBlock_1_configInvalid ) || (\af_t .\assertionBlock_2_configInvalid ) || (\af_t .\assertionBlock_3_configInvalid ) || (\af_t .\assertionBlock_4_configInvalid )) -> ~\assertionViolated )); 
 
no_asserts_for_invalid_logicBlock_configuration : assert \rst -> X(G((\af_t .\logicBlock_0_configInvalid || \af_t .\logicBlock_1_configInvalid || \af_t .\logicBlock_2_configInvalid || \af_t .\logicBlock_3_configInvalid || \af_t .\logicBlock_4_configInvalid || \af_t .\logicBlock_5_configInvalid || \af_t .\logicBlock_6_configInvalid || \af_t .\logicBlock_7_configInvalid || \af_t .\logicBlock_8_configInvalid || \af_t .\logicBlock_9_configInvalid ) -> ~\assertionViolated ));

no_asserts_for_invalid_routingBlock_configuration : assert \rst -> X(G((\af_t .\routingBlock_0_configInvalid || \af_t .\routingBlock_1_configInvalid || \af_t .\routingBlock_2_configInvalid || \af_t .\routingBlock_3_configInvalid || \af_t .\routingBlock_4_configInvalid || \af_t .\routingBlock_5_configInvalid || \af_t .\routingBlock_6_configInvalid || \af_t .\routingBlock_7_configInvalid || \af_t .\routingBlock_8_configInvalid || \af_t .\routingBlock_9_configInvalid || \af_t .\routingBlock_10_configInvalid || \af_t .\routingBlock_11_configInvalid || \af_t .\routingBlock_12_configInvalid || \af_t .\routingBlock_13_configInvalid || \af_t .\routingBlock_14_configInvalid || \af_t .\routingBlock_15_configInvalid || \af_t .\routingBlock_16_configInvalid || \af_t .\routingBlock_17_configInvalid || \af_t .\routingBlock_18_configInvalid || \af_t .\routingBlock_19_configInvalid ) -> ~\assertionViolated ));
 
  
using \af_t .\routingBlock_0_configInvalid //free ,\af_t .\routingBlock_1_configInvalid //free ,\af_t .\routingBlock_2_configInvalid //free ,\af_t .\routingBlock_3_configInvalid //free ,\af_t .\routingBlock_4_configInvalid //free ,\af_t .\routingBlock_5_configInvalid //free ,\af_t .\routingBlock_6_configInvalid //free ,\af_t .\routingBlock_7_configInvalid //free ,\af_t .\routingBlock_8_configInvalid //free ,\af_t .\routingBlock_9_configInvalid //free ,\af_t .\routingBlock_10_configInvalid //free ,\af_t .\routingBlock_11_configInvalid //free ,\af_t .\routingBlock_12_configInvalid //free ,\af_t .\routingBlock_13_configInvalid //free ,\af_t .\routingBlock_14_configInvalid //free ,\af_t .\routingBlock_15_configInvalid //free ,\af_t .\routingBlock_16_configInvalid //free ,\af_t .\routingBlock_17_configInvalid //free ,\af_t .\routingBlock_18_configInvalid //free ,\af_t .\routingBlock_19_configInvalid //free ,\af_t .\routingBlock_0_result //free ,\af_t .\routingBlock_1_result //free ,\af_t .\routingBlock_2_result //free ,\af_t .\routingBlock_3_result //free ,\af_t .\routingBlock_4_result //free ,\af_t .\routingBlock_5_result //free ,\af_t .\routingBlock_6_result //free ,\af_t .\routingBlock_7_result //free ,\af_t .\routingBlock_8_result //free ,\af_t .\routingBlock_9_result //free ,\af_t .\routingBlock_10_result //free ,\af_t .\routingBlock_11_result //free ,\af_t .\routingBlock_12_result //free ,\af_t .\routingBlock_13_result //free ,\af_t .\routingBlock_14_result //free ,\af_t .\routingBlock_15_result //free ,\af_t .\routingBlock_16_result //free ,\af_t .\routingBlock_17_result //free ,\af_t .\routingBlock_18_result //free ,\af_t .\routingBlock_19_result //free  prove \no_asserts_for_invalid_logicBlock_configuration ,\no_asserts_for_invalid_assertionBlock_configuration ,\no_asserts_for_invalid_routingBlock_configuration ;
  
//SMV-Assertions
*/