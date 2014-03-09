`define SMV
`include "logicBlock.v"


/*                                                                              
 * File: logicBlock_tb.v
 * Test bench for logicBlock.v
 * Includes assertions for verification                                         
 */

module main();


   // Inputs to DUT                                                           
   reg [31:0] stateA;
   reg [31:0] stateB;
   reg [31:0] maskA;
   reg [31:0] maskB;
   reg [31:0] constant;
   reg        opBMux;
   reg [2:0]  resultMux;
   reg        invalidConfig;
       
   
   // Outputs of DUT
   wire       result;
   wire       invalidResult;
   

   logicBlock logicBlock_t(.stateA(stateA),
                           .stateB(stateB),
                           .maskA(maskA),
                           .maskB(maskB),
                           .constant(constant),
                           .opBMux(opBMux),
                           .resultMux(resultMux),
                           .prevConfigInvalid(invalidConfig),
                           .result(result),
                           .configInvalid(invalidResult));


endmodule
/* ********* SMV Assertions *********
//SMV-Assertions
# Properties a_gt_b, a_notgt_b:
# Assert if configured for 'masked(a) > masked(b)', result is 1 iff masked(a) is greater than masked(b).
\a_gt_b : assert G(\opBMux && (\resultMux = 2) && ((\stateA & \maskA ) > (\stateB & \maskB )) -> (\result = 1));
\a_notgt_b : assert G(\opBMux && (\resultMux = 2) && (~((\stateA & \maskA ) > (\stateB & \maskB ))) -> (\result = 0));

# Properties a_ge_b, a_notge_b:
# Assert if configured for 'masked(a) >= masked(b)', result is 1 iff masked(a) is greater than or equal to masked(b).
\a_ge_b : assert G(\opBMux && (\resultMux = 3) && ((\stateA & \maskA ) >= (\stateB & \maskB )) -> (\result = 1));
\a_notge_b : assert G(\opBMux && (\resultMux = 3) && (~((\stateA & \maskA ) >= (\stateB & \maskB ))) -> (\result = 0));

# Properties a_eq_b, a_noteq_b:
# Assert if configured for 'masked(a) = masked(b)', result is 1 iff masked(a) is equal to masked(b).
\a_eq_b : assert G(\opBMux && (\resultMux = 0) && ((\stateA & \maskA ) = (\stateB & \maskB )) -> (\result = 1));
\a_noteq_b : assert G(\opBMux && (\resultMux = 0) && (~((\stateA & \maskA ) = (\stateB & \maskB ))) -> (\result = 0));

# Properties a_le_b, a_notle_b:
# Assert if configured for 'masked(a) <= masked(b)', result is 1 iff masked(a) is less than or equal to masked(b).
\a_le_b : assert G(\opBMux && (\resultMux = 5) && ((\stateA & \maskA ) <= (\stateB & \maskB )) -> (\result = 1));
\a_notle_b : assert G(\opBMux && (\resultMux = 5) && (~((\stateA & \maskA ) <= (\stateB & \maskB ))) -> (\result = 0));

# Properties a_lt_b, a_notlt_b:
# Assert if configured for 'masked(a) < masked(b)', result is 1 iff masked(a) is less than masked(b).
\a_lt_b : assert G(\opBMux && (\resultMux = 4) && ((\stateA & \maskA ) < (\stateB & \maskB )) -> (\result = 1));
\a_notlt_b : assert G(\opBMux && (\resultMux = 4) && (~((\stateA & \maskA ) < (\stateB & \maskB ))) -> (\result = 0));

# Properties a_ne_b, a_notne_b:
# Assert if configured for 'masked(a) != masked(b)', result is 1 iff masked(a) is not equal to masked(b).
\a_ne_b : assert G(\opBMux && (\resultMux = 1) && (~((\stateA & \maskA ) = (\stateB & \maskB ))) -> (\result = 1));
\a_notne_b : assert G(\opBMux && (\resultMux = 1) && (~(~((\stateA & \maskA ) = (\stateB & \maskB )))) -> (\result = 0));
      
# Properties a_gt_const, a_notgt_const:
# Assert if configured for 'masked(a) > constant', result is 1 iff masked(a) is greater than constant.
\a_gt_const : assert G(~\opBMux && (\resultMux = 2) && ((\stateA & \maskA ) > (\constant )) -> (\result = 1));
\a_notgt_const : assert G(~\opBMux && (\resultMux = 2) && (~((\stateA & \maskA ) > (\constant ))) -> (\result = 0));

# Properties a_ge_const, a_notge_const:
# Assert if configured for 'masked(a) >= constant', result is 1 iff masked(a) is greater than or equal to constant. 
\a_ge_const : assert G(~\opBMux && (\resultMux = 3) && ((\stateA & \maskA ) >= (\constant )) -> (\result = 1));
\a_notge_const : assert G(~\opBMux && (\resultMux = 3) && (~((\stateA & \maskA ) >= (\constant ))) -> (\result = 0));

# Properties a_eq_const, a_noteq_const:
# Assert if configured for 'masked(a) = constant', result is 1 iff masked(a) is equal to constant. 
\a_eq_const : assert G(~\opBMux && (\resultMux = 0) && ((\stateA & \maskA ) = (\constant )) -> (\result = 1));
\a_noteq_const : assert G(~\opBMux && (\resultMux = 0) && (~((\stateA & \maskA ) = (\constant ))) -> (\result = 0));

# Properties a_le_const, a_notle_const:
# Assert if configured for 'masked(a) <= constant', result is 1 iff masked(a) is less than or equal to constant. 
\a_le_const : assert G(~\opBMux && (\resultMux = 5) && ((\stateA & \maskA ) <= (\constant )) -> (\result = 1));
\a_notle_const : assert G(~\opBMux && (\resultMux = 5) && (~((\stateA & \maskA ) <= (\constant ))) -> (\result = 0));

# Properties a_lt_const, a_notlt_const:
# Assert if configured for 'masked(a) < constant', result is 1 iff masked(a) is less than constant. 
\a_lt_const : assert G(~\opBMux && (\resultMux = 4) && ((\stateA & \maskA ) < (\constant )) -> (\result = 1));
\a_notlt_const : assert G(~\opBMux && (\resultMux = 4) && (~((\stateA & \maskA ) < (\constant ))) -> (\result = 0));

# Properties a_ne_const, a_notne_const:
# Assert if configured for 'masked(a) != constant', result is 1 iff masked(a) is not equal to constant. 
\a_ne_const : assert G(~\opBMux && (\resultMux = 1) && (~((\stateA & \maskA ) = (\constant ))) -> (\result = 1));
\a_notne_const : assert G(~\opBMux && (\resultMux = 1) && (~(~((\stateA & \maskA ) = (\constant )))) -> (\result = 0));

# Properties prev_config_invalid, config_invalid, config_valid:
# Assert invalidResult is set iff the invalidConfig input was set or the resultMux input was outside the range [0,5].        
\prev_config_invalid : assert G(\invalidConfig -> \invalidResult );
\config_invalid : assert G(((\resultMux < 0) || (\resultMux > 5)) -> \invalidResult );
\config_valid : assert G((~\invalidConfig && (\resultMux < 6) && (\resultMux >= 0)) -> ~\invalidResult ); 

 //SMV-Assertions
*/
