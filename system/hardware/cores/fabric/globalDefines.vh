//`default net_type none
`ifndef FABRIC_GLOBAL
 `define FABRIC_GLOBAL

 `ifdef SUBDIR
  `include "../../or1200/or1200_defines.v"
 `else
  `include "../or1200/or1200_defines.v"
 `endif
 `ifdef SMV
  `define LTEQ =<
 `else
  `define LTEQ <=
 `endif
 `define ROUTING_INPUT_BITS 544
`endif