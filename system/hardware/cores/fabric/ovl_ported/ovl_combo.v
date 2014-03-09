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

`ifdef SMV
 `include "ovl_ported/std_ovl_defines.h"
`else
 `include "std_ovl_defines.h"
`endif

`module ovl_combo (clock, reset, enable, num_cks, start_event, test_expr, select, fire_comb);
  parameter severity_level      = `OVL_SEVERITY_DEFAULT;
  parameter check_overlapping   = 1;
  parameter check_missing_start = 0;
  parameter num_cks_max         = 7;
  parameter num_cks_width       = 3;
  parameter property_type       = `OVL_PROPERTY_DEFAULT;
  parameter msg                 = `OVL_MSG_DEFAULT;
  parameter coverage_level      = `OVL_COVER_DEFAULT;

  parameter clock_edge          = `OVL_CLOCK_EDGE_DEFAULT;
  parameter reset_polarity      = `OVL_RESET_POLARITY_DEFAULT;
  parameter gating_type         = `OVL_GATING_TYPE_DEFAULT;

  input                          clock, reset, enable;
  input	 [num_cks_width-1:0]     num_cks;
  input                          start_event, test_expr;
  input	[1:0]				 select;
  output [`OVL_FIRE_WIDTH-1:0]   fire_comb;

  // Parameters that should not be edited
  parameter assert_name = "OVL_COMBO";

`ifdef SMV
 `include "ovl_ported/std_ovl_reset.h"
 `include "ovl_ported/std_ovl_clock.h"
 `include "ovl_ported/std_ovl_cover.h"
 `include "ovl_ported/std_ovl_init.h"
`else
 `include "std_ovl_reset.h"
 `include "std_ovl_clock.h"
 `include "std_ovl_cover.h"
 `include "std_ovl_task.h"
 `include "std_ovl_init.h"
`endif // !`ifdef SMV

`ifdef SMV
  `include "./ovl_ported/vlog95/ovl_combo_logic.v"
`else
  `include "./vlog95/ovl_combo_logic.v"
`endif

assign fire_comb = {2'b0, fire_2state_comb};

`endmodule