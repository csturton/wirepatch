`define SMV
`include "routingBlock.v"

/*
 * File: routingBlock_tb.v
 * Test bench for routingblock.v
 * Includes assertions for verification
 */


module main();
   
         
   // Inputs to DUT
   reg [8*32:0] inputState;
   reg [2:0] inputSelect;
   

   // Outputs of DUT
   wire [31:0] result;
   wire        configInvalid;
   
   routingBlock routingBlock_t(.inputState(inputState),
                               .inputSelect(inputSelect),
                               .out(result),
                               .configInvalid(configInvalid),
                               .NUM_INPUTS(8),
                               .NUM_INPUTS_LOG_2(3));
   
endmodule // main


/* ********* SMV Assertions *********
//SMV-Assertions
# Properties select_0, select_1, .., select_7, select_def:
# Assert when inputSelect = X, the Xth 32-bit block of inputState is returned.
# Note that this assumes INPUT_WIDTH = 32 in routingBlock.
# Note this only checks for 0 <= X < 8. If NUM_INPUTS is set to something higher than 8, more checks would need to be added.
\select_0 : assert G((\inputSelect = 0) -> (\result = \inputState [((32*1)-1)..(32*0)]));
\select_1 : assert G((\inputSelect = 1) -> (\result = \inputState [((32*2)-1)..(32*1)]));
\select_2 : assert G((\inputSelect = 2) -> (\result = \inputState [((32*3)-1)..(32*2)]));
\select_3 : assert G((\inputSelect = 3) -> (\result = \inputState [((32*4)-1)..(32*3)]));
\select_4 : assert G((\inputSelect = 4) -> (\result = \inputState [((32*5)-1)..(32*4)]));
\select_5 : assert G((\inputSelect = 5) -> (\result = \inputState [((32*6)-1)..(32*5)]));
\select_6 : assert G((\inputSelect = 6) -> (\result = \inputState [((32*7)-1)..(32*6)]));
\select_7 : assert G((\inputSelect = 7) -> (\result = \inputState [((32*8)-1)..(32*7)]));
\select_def : assert G((\inputSelect > 7) -> (\result = 0));

# Properties select_inv, select_val: 
# Assert configInvalid is set iff inputSelect is outside the range [0,7]
# Note if NUM_INPUTS is changed, the checked range would need to be adjusted.
\select_inv : assert G(((\inputSelect < 0) || (\inputSelect > 7))  -> \configInvalid ); 
\select_val : assert G((\inputSelect < 8) -> ~\configInvalid );

//SMV-Assertions
*/   