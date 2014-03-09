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

  // Make index 1 based, otherwise I would need subtraction
  reg  [num_cks_max:1] monitor;
  wire fire_2state_comb;

  always @(posedge clk)
    if (`OVL_RESET_SIGNAL == 1'b0)
      monitor <= {num_cks_max{1'b0}};
    else if(enable)
      monitor <= {monitor[num_cks_max-1:1], start_event};

  wire fire_gate = `OVL_RESET_SIGNAL & enable;

  wire fire_prop = ~test_expr;
  wire fire_always = fire_prop;
  wire fire_edge = monitor[1] & ~monitor[2] & fire_prop;
  wire fire_next = monitor[num_cks] & fire_prop;

  wire fire_selected = (select == 2) ? fire_prop : (select == 3) ? fire_always : (select == 0) ? fire_edge : fire_next;

  assign fire_2state_comb = fire_gate & fire_selected;
  wire fire_xcheck = 1'b0;
  wire fire_cover = 1'b0;