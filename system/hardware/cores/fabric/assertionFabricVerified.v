`include "globalDefines.vh"
`ifdef SMV
`include "routingBlock.v"
`include "logicBlock.v"
`include "ovl_combo_wrapped.v"
`include "ovl_ported/ovl_combo.v"
`include "mergeBlock.v"
`endif
module assertionFabric(
	clk, rst, enable,
	bakedInAssertions,
	routingInput,
	routingBlock_0_inputSelect,
	routingBlock_1_inputSelect,
	routingBlock_2_inputSelect,
	routingBlock_3_inputSelect,
	routingBlock_4_inputSelect,
	routingBlock_5_inputSelect,
	routingBlock_6_inputSelect,
	routingBlock_7_inputSelect,
	routingBlock_8_inputSelect,
	routingBlock_9_inputSelect,
	routingBlock_10_inputSelect,
	routingBlock_11_inputSelect,
	routingBlock_12_inputSelect,
	routingBlock_13_inputSelect,
	routingBlock_14_inputSelect,
	routingBlock_15_inputSelect,
	routingBlock_16_inputSelect,
	routingBlock_17_inputSelect,
	routingBlock_18_inputSelect,
	routingBlock_19_inputSelect,
	logicBlock_0_maskA,
	logicBlock_0_maskB,
	logicBlock_0_constant,
	logicBlock_0_opBMux,
	logicBlock_0_resultMux,
	logicBlock_1_maskA,
	logicBlock_1_maskB,
	logicBlock_1_constant,
	logicBlock_1_opBMux,
	logicBlock_1_resultMux,
	logicBlock_2_maskA,
	logicBlock_2_maskB,
	logicBlock_2_constant,
	logicBlock_2_opBMux,
	logicBlock_2_resultMux,
	logicBlock_3_maskA,
	logicBlock_3_maskB,
	logicBlock_3_constant,
	logicBlock_3_opBMux,
	logicBlock_3_resultMux,
	logicBlock_4_maskA,
	logicBlock_4_maskB,
	logicBlock_4_constant,
	logicBlock_4_opBMux,
	logicBlock_4_resultMux,
	logicBlock_5_maskA,
	logicBlock_5_maskB,
	logicBlock_5_constant,
	logicBlock_5_opBMux,
	logicBlock_5_resultMux,
	logicBlock_6_maskA,
	logicBlock_6_maskB,
	logicBlock_6_constant,
	logicBlock_6_opBMux,
	logicBlock_6_resultMux,
	logicBlock_7_maskA,
	logicBlock_7_maskB,
	logicBlock_7_constant,
	logicBlock_7_opBMux,
	logicBlock_7_resultMux,
	logicBlock_8_maskA,
	logicBlock_8_maskB,
	logicBlock_8_constant,
	logicBlock_8_opBMux,
	logicBlock_8_resultMux,
	logicBlock_9_maskA,
	logicBlock_9_maskB,
	logicBlock_9_constant,
	logicBlock_9_opBMux,
	logicBlock_9_resultMux,
	assertionBlock_0_num_cks,
	assertionBlock_0_select,
	assertionBlock_0_res_sel,
	assertionBlock_1_num_cks,
	assertionBlock_1_select,
	assertionBlock_1_res_sel,
	assertionBlock_2_num_cks,
	assertionBlock_2_select,
	assertionBlock_2_res_sel,
	assertionBlock_3_num_cks,
	assertionBlock_3_select,
	assertionBlock_3_res_sel,
	assertionBlock_4_num_cks,
	assertionBlock_4_select,
	assertionBlock_4_res_sel,
	assertionViolated,
	assertionsViolated
);

	input clk;
	input rst;
	input enable;
	input [31:0] bakedInAssertions;
	input [`ROUTING_INPUT_BITS-1:0] routingInput;
	input [4:0] routingBlock_0_inputSelect;
	input [4:0] routingBlock_1_inputSelect;
	input [4:0] routingBlock_2_inputSelect;
	input [4:0] routingBlock_3_inputSelect;
	input [4:0] routingBlock_4_inputSelect;
	input [4:0] routingBlock_5_inputSelect;
	input [4:0] routingBlock_6_inputSelect;
	input [4:0] routingBlock_7_inputSelect;
	input [4:0] routingBlock_8_inputSelect;
	input [4:0] routingBlock_9_inputSelect;
	input [4:0] routingBlock_10_inputSelect;
	input [4:0] routingBlock_11_inputSelect;
	input [4:0] routingBlock_12_inputSelect;
	input [4:0] routingBlock_13_inputSelect;
	input [4:0] routingBlock_14_inputSelect;
	input [4:0] routingBlock_15_inputSelect;
	input [4:0] routingBlock_16_inputSelect;
	input [4:0] routingBlock_17_inputSelect;
	input [4:0] routingBlock_18_inputSelect;
	input [4:0] routingBlock_19_inputSelect;
	input [31:0] logicBlock_0_maskA;
	input [31:0] logicBlock_0_maskB;
	input [31:0] logicBlock_0_constant;
	input logicBlock_0_opBMux;
	input [2:0] logicBlock_0_resultMux;
	input [31:0] logicBlock_1_maskA;
	input [31:0] logicBlock_1_maskB;
	input [31:0] logicBlock_1_constant;
	input logicBlock_1_opBMux;
	input [2:0] logicBlock_1_resultMux;
	input [31:0] logicBlock_2_maskA;
	input [31:0] logicBlock_2_maskB;
	input [31:0] logicBlock_2_constant;
	input logicBlock_2_opBMux;
	input [2:0] logicBlock_2_resultMux;
	input [31:0] logicBlock_3_maskA;
	input [31:0] logicBlock_3_maskB;
	input [31:0] logicBlock_3_constant;
	input logicBlock_3_opBMux;
	input [2:0] logicBlock_3_resultMux;
	input [31:0] logicBlock_4_maskA;
	input [31:0] logicBlock_4_maskB;
	input [31:0] logicBlock_4_constant;
	input logicBlock_4_opBMux;
	input [2:0] logicBlock_4_resultMux;
	input [31:0] logicBlock_5_maskA;
	input [31:0] logicBlock_5_maskB;
	input [31:0] logicBlock_5_constant;
	input logicBlock_5_opBMux;
	input [2:0] logicBlock_5_resultMux;
	input [31:0] logicBlock_6_maskA;
	input [31:0] logicBlock_6_maskB;
	input [31:0] logicBlock_6_constant;
	input logicBlock_6_opBMux;
	input [2:0] logicBlock_6_resultMux;
	input [31:0] logicBlock_7_maskA;
	input [31:0] logicBlock_7_maskB;
	input [31:0] logicBlock_7_constant;
	input logicBlock_7_opBMux;
	input [2:0] logicBlock_7_resultMux;
	input [31:0] logicBlock_8_maskA;
	input [31:0] logicBlock_8_maskB;
	input [31:0] logicBlock_8_constant;
	input logicBlock_8_opBMux;
	input [2:0] logicBlock_8_resultMux;
	input [31:0] logicBlock_9_maskA;
	input [31:0] logicBlock_9_maskB;
	input [31:0] logicBlock_9_constant;
	input logicBlock_9_opBMux;
	input [2:0] logicBlock_9_resultMux;
	input [2:0] assertionBlock_0_num_cks;
	input [1:0] assertionBlock_0_select;
	input assertionBlock_0_res_sel;
	input [2:0] assertionBlock_1_num_cks;
	input [1:0] assertionBlock_1_select;
	input assertionBlock_1_res_sel;
	input [2:0] assertionBlock_2_num_cks;
	input [1:0] assertionBlock_2_select;
	input assertionBlock_2_res_sel;
	input [2:0] assertionBlock_3_num_cks;
	input [1:0] assertionBlock_3_select;
	input assertionBlock_3_res_sel;
	input [2:0] assertionBlock_4_num_cks;
	input [1:0] assertionBlock_4_select;
	input assertionBlock_4_res_sel;
	output assertionViolated;
	output [31:0] assertionsViolated;

	wire routingBlock_0_configInvalid;
	wire [31:0] routingBlock_0_result;
	routingBlock routingBlock_0(
		.inputState(routingInput),
		.inputSelect(routingBlock_0_inputSelect),
		.out(routingBlock_0_result),
		.configInvalid(routingBlock_0_configInvalid)
	);

	wire routingBlock_1_configInvalid;
	wire [31:0] routingBlock_1_result;
	routingBlock routingBlock_1(
		.inputState(routingInput),
		.inputSelect(routingBlock_1_inputSelect),
		.out(routingBlock_1_result),
		.configInvalid(routingBlock_1_configInvalid)
	);

	wire routingBlock_2_configInvalid;
	wire [31:0] routingBlock_2_result;
	routingBlock routingBlock_2(
		.inputState(routingInput),
		.inputSelect(routingBlock_2_inputSelect),
		.out(routingBlock_2_result),
		.configInvalid(routingBlock_2_configInvalid)
	);

	wire routingBlock_3_configInvalid;
	wire [31:0] routingBlock_3_result;
	routingBlock routingBlock_3(
		.inputState(routingInput),
		.inputSelect(routingBlock_3_inputSelect),
		.out(routingBlock_3_result),
		.configInvalid(routingBlock_3_configInvalid)
	);

	wire routingBlock_4_configInvalid;
	wire [31:0] routingBlock_4_result;
	routingBlock routingBlock_4(
		.inputState(routingInput),
		.inputSelect(routingBlock_4_inputSelect),
		.out(routingBlock_4_result),
		.configInvalid(routingBlock_4_configInvalid)
	);

	wire routingBlock_5_configInvalid;
	wire [31:0] routingBlock_5_result;
	routingBlock routingBlock_5(
		.inputState(routingInput),
		.inputSelect(routingBlock_5_inputSelect),
		.out(routingBlock_5_result),
		.configInvalid(routingBlock_5_configInvalid)
	);

	wire routingBlock_6_configInvalid;
	wire [31:0] routingBlock_6_result;
	routingBlock routingBlock_6(
		.inputState(routingInput),
		.inputSelect(routingBlock_6_inputSelect),
		.out(routingBlock_6_result),
		.configInvalid(routingBlock_6_configInvalid)
	);

	wire routingBlock_7_configInvalid;
	wire [31:0] routingBlock_7_result;
	routingBlock routingBlock_7(
		.inputState(routingInput),
		.inputSelect(routingBlock_7_inputSelect),
		.out(routingBlock_7_result),
		.configInvalid(routingBlock_7_configInvalid)
	);

	wire routingBlock_8_configInvalid;
	wire [31:0] routingBlock_8_result;
	routingBlock routingBlock_8(
		.inputState(routingInput),
		.inputSelect(routingBlock_8_inputSelect),
		.out(routingBlock_8_result),
		.configInvalid(routingBlock_8_configInvalid)
	);

	wire routingBlock_9_configInvalid;
	wire [31:0] routingBlock_9_result;
	routingBlock routingBlock_9(
		.inputState(routingInput),
		.inputSelect(routingBlock_9_inputSelect),
		.out(routingBlock_9_result),
		.configInvalid(routingBlock_9_configInvalid)
	);

	wire routingBlock_10_configInvalid;
	wire [31:0] routingBlock_10_result;
	routingBlock routingBlock_10(
		.inputState(routingInput),
		.inputSelect(routingBlock_10_inputSelect),
		.out(routingBlock_10_result),
		.configInvalid(routingBlock_10_configInvalid)
	);

	wire routingBlock_11_configInvalid;
	wire [31:0] routingBlock_11_result;
	routingBlock routingBlock_11(
		.inputState(routingInput),
		.inputSelect(routingBlock_11_inputSelect),
		.out(routingBlock_11_result),
		.configInvalid(routingBlock_11_configInvalid)
	);

	wire routingBlock_12_configInvalid;
	wire [31:0] routingBlock_12_result;
	routingBlock routingBlock_12(
		.inputState(routingInput),
		.inputSelect(routingBlock_12_inputSelect),
		.out(routingBlock_12_result),
		.configInvalid(routingBlock_12_configInvalid)
	);

	wire routingBlock_13_configInvalid;
	wire [31:0] routingBlock_13_result;
	routingBlock routingBlock_13(
		.inputState(routingInput),
		.inputSelect(routingBlock_13_inputSelect),
		.out(routingBlock_13_result),
		.configInvalid(routingBlock_13_configInvalid)
	);

	wire routingBlock_14_configInvalid;
	wire [31:0] routingBlock_14_result;
	routingBlock routingBlock_14(
		.inputState(routingInput),
		.inputSelect(routingBlock_14_inputSelect),
		.out(routingBlock_14_result),
		.configInvalid(routingBlock_14_configInvalid)
	);

	wire routingBlock_15_configInvalid;
	wire [31:0] routingBlock_15_result;
	routingBlock routingBlock_15(
		.inputState(routingInput),
		.inputSelect(routingBlock_15_inputSelect),
		.out(routingBlock_15_result),
		.configInvalid(routingBlock_15_configInvalid)
	);

	wire routingBlock_16_configInvalid;
	wire [31:0] routingBlock_16_result;
	routingBlock routingBlock_16(
		.inputState(routingInput),
		.inputSelect(routingBlock_16_inputSelect),
		.out(routingBlock_16_result),
		.configInvalid(routingBlock_16_configInvalid)
	);

	wire routingBlock_17_configInvalid;
	wire [31:0] routingBlock_17_result;
	routingBlock routingBlock_17(
		.inputState(routingInput),
		.inputSelect(routingBlock_17_inputSelect),
		.out(routingBlock_17_result),
		.configInvalid(routingBlock_17_configInvalid)
	);

	wire routingBlock_18_configInvalid;
	wire [31:0] routingBlock_18_result;
	routingBlock routingBlock_18(
		.inputState(routingInput),
		.inputSelect(routingBlock_18_inputSelect),
		.out(routingBlock_18_result),
		.configInvalid(routingBlock_18_configInvalid)
	);

	wire routingBlock_19_configInvalid;
	wire [31:0] routingBlock_19_result;
	routingBlock routingBlock_19(
		.inputState(routingInput),
		.inputSelect(routingBlock_19_inputSelect),
		.out(routingBlock_19_result),
		.configInvalid(routingBlock_19_configInvalid)
	);

	wire logicBlock_0_configInvalid;
	wire logicBlock_0_result;
	logicBlock logicBlock_0(
		.stateA(routingBlock_0_result),
		.maskA(logicBlock_0_maskA),
		.stateB(routingBlock_1_result),
		.maskB(logicBlock_0_maskB),
		.constant(logicBlock_0_constant),
		.opBMux(logicBlock_0_opBMux),
		.prevConfigInvalid(routingBlock_0_configInvalid | routingBlock_1_configInvalid),
		.resultMux(logicBlock_0_resultMux),
		.out(logicBlock_0_result),
		.configInvalid(logicBlock_0_configInvalid)
	);

	wire logicBlock_1_configInvalid;
	wire logicBlock_1_result;
	logicBlock logicBlock_1(
		.stateA(routingBlock_2_result),
		.maskA(logicBlock_1_maskA),
		.stateB(routingBlock_3_result),
		.maskB(logicBlock_1_maskB),
		.constant(logicBlock_1_constant),
		.opBMux(logicBlock_1_opBMux),
		.prevConfigInvalid(routingBlock_2_configInvalid | routingBlock_3_configInvalid),
		.resultMux(logicBlock_1_resultMux),
		.out(logicBlock_1_result),
		.configInvalid(logicBlock_1_configInvalid)
	);

	wire logicBlock_2_configInvalid;
	wire logicBlock_2_result;
	logicBlock logicBlock_2(
		.stateA(routingBlock_4_result),
		.maskA(logicBlock_2_maskA),
		.stateB(routingBlock_5_result),
		.maskB(logicBlock_2_maskB),
		.constant(logicBlock_2_constant),
		.opBMux(logicBlock_2_opBMux),
		.prevConfigInvalid(routingBlock_4_configInvalid | routingBlock_5_configInvalid),
		.resultMux(logicBlock_2_resultMux),
		.out(logicBlock_2_result),
		.configInvalid(logicBlock_2_configInvalid)
	);

	wire logicBlock_3_configInvalid;
	wire logicBlock_3_result;
	logicBlock logicBlock_3(
		.stateA(routingBlock_6_result),
		.maskA(logicBlock_3_maskA),
		.stateB(routingBlock_7_result),
		.maskB(logicBlock_3_maskB),
		.constant(logicBlock_3_constant),
		.opBMux(logicBlock_3_opBMux),
		.prevConfigInvalid(routingBlock_6_configInvalid | routingBlock_7_configInvalid),
		.resultMux(logicBlock_3_resultMux),
		.out(logicBlock_3_result),
		.configInvalid(logicBlock_3_configInvalid)
	);

	wire logicBlock_4_configInvalid;
	wire logicBlock_4_result;
	logicBlock logicBlock_4(
		.stateA(routingBlock_8_result),
		.maskA(logicBlock_4_maskA),
		.stateB(routingBlock_9_result),
		.maskB(logicBlock_4_maskB),
		.constant(logicBlock_4_constant),
		.opBMux(logicBlock_4_opBMux),
		.prevConfigInvalid(routingBlock_8_configInvalid | routingBlock_9_configInvalid),
		.resultMux(logicBlock_4_resultMux),
		.out(logicBlock_4_result),
		.configInvalid(logicBlock_4_configInvalid)
	);

	wire logicBlock_5_configInvalid;
	wire logicBlock_5_result;
	logicBlock logicBlock_5(
		.stateA(routingBlock_10_result),
		.maskA(logicBlock_5_maskA),
		.stateB(routingBlock_11_result),
		.maskB(logicBlock_5_maskB),
		.constant(logicBlock_5_constant),
		.opBMux(logicBlock_5_opBMux),
		.prevConfigInvalid(routingBlock_10_configInvalid | routingBlock_11_configInvalid),
		.resultMux(logicBlock_5_resultMux),
		.out(logicBlock_5_result),
		.configInvalid(logicBlock_5_configInvalid)
	);

	wire logicBlock_6_configInvalid;
	wire logicBlock_6_result;
	logicBlock logicBlock_6(
		.stateA(routingBlock_12_result),
		.maskA(logicBlock_6_maskA),
		.stateB(routingBlock_13_result),
		.maskB(logicBlock_6_maskB),
		.constant(logicBlock_6_constant),
		.opBMux(logicBlock_6_opBMux),
		.prevConfigInvalid(routingBlock_12_configInvalid | routingBlock_13_configInvalid),
		.resultMux(logicBlock_6_resultMux),
		.out(logicBlock_6_result),
		.configInvalid(logicBlock_6_configInvalid)
	);

	wire logicBlock_7_configInvalid;
	wire logicBlock_7_result;
	logicBlock logicBlock_7(
		.stateA(routingBlock_14_result),
		.maskA(logicBlock_7_maskA),
		.stateB(routingBlock_15_result),
		.maskB(logicBlock_7_maskB),
		.constant(logicBlock_7_constant),
		.opBMux(logicBlock_7_opBMux),
		.prevConfigInvalid(routingBlock_14_configInvalid | routingBlock_15_configInvalid),
		.resultMux(logicBlock_7_resultMux),
		.out(logicBlock_7_result),
		.configInvalid(logicBlock_7_configInvalid)
	);

	wire logicBlock_8_configInvalid;
	wire logicBlock_8_result;
	logicBlock logicBlock_8(
		.stateA(routingBlock_16_result),
		.maskA(logicBlock_8_maskA),
		.stateB(routingBlock_17_result),
		.maskB(logicBlock_8_maskB),
		.constant(logicBlock_8_constant),
		.opBMux(logicBlock_8_opBMux),
		.prevConfigInvalid(routingBlock_16_configInvalid | routingBlock_17_configInvalid),
		.resultMux(logicBlock_8_resultMux),
		.out(logicBlock_8_result),
		.configInvalid(logicBlock_8_configInvalid)
	);

	wire logicBlock_9_configInvalid;
	wire logicBlock_9_result;
	logicBlock logicBlock_9(
		.stateA(routingBlock_18_result),
		.maskA(logicBlock_9_maskA),
		.stateB(routingBlock_19_result),
		.maskB(logicBlock_9_maskB),
		.constant(logicBlock_9_constant),
		.opBMux(logicBlock_9_opBMux),
		.prevConfigInvalid(routingBlock_18_configInvalid | routingBlock_19_configInvalid),
		.resultMux(logicBlock_9_resultMux),
		.out(logicBlock_9_result),
		.configInvalid(logicBlock_9_configInvalid)
	);

	wire assertionBlock_0_result;
	wire assertionBlock_0_result_comb;
	wire assertionBlock_0_result_delayed;
	wire assertionBlock_0_configInvalid;
	ovl_combo_wrapped assertionBlock_0(
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.num_cks(assertionBlock_0_num_cks),
		.start_event(logicBlock_0_result),
		.test_expr(logicBlock_1_result),
		.prevConfigInvalid(logicBlock_0_configInvalid | logicBlock_1_configInvalid),
		.select(assertionBlock_0_select),
		.out(assertionBlock_0_result_comb),
		.out_delayed(assertionBlock_0_result_delayed),
		.configInvalid(assertionBlock_0_configInvalid)
	);

	assign assertionBlock_0_result = assertionBlock_0_res_sel ? assertionBlock_0_result_delayed : assertionBlock_0_result_comb;

	wire assertionBlock_1_result;
	wire assertionBlock_1_result_comb;
	wire assertionBlock_1_result_delayed;
	wire assertionBlock_1_configInvalid;
	ovl_combo_wrapped assertionBlock_1(
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.num_cks(assertionBlock_1_num_cks),
		.start_event(logicBlock_2_result),
		.test_expr(logicBlock_3_result),
		.prevConfigInvalid(logicBlock_2_configInvalid | logicBlock_3_configInvalid),
		.select(assertionBlock_1_select),
		.out(assertionBlock_1_result_comb),
		.out_delayed(assertionBlock_1_result_delayed),
		.configInvalid(assertionBlock_1_configInvalid)
	);

	assign assertionBlock_1_result = assertionBlock_1_res_sel ? assertionBlock_1_result_delayed : assertionBlock_1_result_comb;

	wire assertionBlock_2_result;
	wire assertionBlock_2_result_comb;
	wire assertionBlock_2_result_delayed;
	wire assertionBlock_2_configInvalid;
	ovl_combo_wrapped assertionBlock_2(
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.num_cks(assertionBlock_2_num_cks),
		.start_event(logicBlock_4_result),
		.test_expr(logicBlock_5_result),
		.prevConfigInvalid(logicBlock_4_configInvalid | logicBlock_5_configInvalid),
		.select(assertionBlock_2_select),
		.out(assertionBlock_2_result_comb),
		.out_delayed(assertionBlock_2_result_delayed),
		.configInvalid(assertionBlock_2_configInvalid)
	);

	assign assertionBlock_2_result = assertionBlock_2_res_sel ? assertionBlock_2_result_delayed : assertionBlock_2_result_comb;

	wire assertionBlock_3_result;
	wire assertionBlock_3_result_comb;
	wire assertionBlock_3_result_delayed;
	wire assertionBlock_3_configInvalid;
	ovl_combo_wrapped assertionBlock_3(
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.num_cks(assertionBlock_3_num_cks),
		.start_event(logicBlock_6_result),
		.test_expr(logicBlock_7_result),
		.prevConfigInvalid(logicBlock_6_configInvalid | logicBlock_7_configInvalid),
		.select(assertionBlock_3_select),
		.out(assertionBlock_3_result_comb),
		.out_delayed(assertionBlock_3_result_delayed),
		.configInvalid(assertionBlock_3_configInvalid)
	);

	assign assertionBlock_3_result = assertionBlock_3_res_sel ? assertionBlock_3_result_delayed : assertionBlock_3_result_comb;

	wire assertionBlock_4_result;
	wire assertionBlock_4_result_comb;
	wire assertionBlock_4_result_delayed;
	wire assertionBlock_4_configInvalid;
	ovl_combo_wrapped assertionBlock_4(
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.num_cks(assertionBlock_4_num_cks),
		.start_event(logicBlock_8_result),
		.test_expr(logicBlock_9_result),
		.prevConfigInvalid(logicBlock_8_configInvalid | logicBlock_9_configInvalid),
		.select(assertionBlock_4_select),
		.out(assertionBlock_4_result_comb),
		.out_delayed(assertionBlock_4_result_delayed),
		.configInvalid(assertionBlock_4_configInvalid)
	);

	assign assertionBlock_4_result = assertionBlock_4_res_sel ? assertionBlock_4_result_delayed : assertionBlock_4_result_comb;

	wire anyConfigInvalid = 
		assertionBlock_0_configInvalid | 
		assertionBlock_1_configInvalid | 
		assertionBlock_2_configInvalid | 
		assertionBlock_3_configInvalid | 
		assertionBlock_4_configInvalid;

	assign assertionsViolated = {
		assertionBlock_0_result, 
		assertionBlock_1_result, 
		assertionBlock_2_result, 
		assertionBlock_3_result, 
		assertionBlock_4_result};

	wire mergeBlock_0_0_result;
	mergeBlock mergeBlock_0_0(
		.assert1(assertionBlock_0_result),
		.assert2(assertionBlock_1_result),
		.assert3(assertionBlock_2_result),
		.assert4(assertionBlock_3_result),
		.assert5(assertionBlock_4_result),
		.assert6(1'b0),
		.out(mergeBlock_0_0_result)
	);

	assign assertionViolated = mergeBlock_0_0_result & ~anyConfigInvalid;
endmodule
