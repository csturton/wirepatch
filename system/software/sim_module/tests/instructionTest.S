/*
 * University of Illinois/NCSA
 * Open Source License
 *
 *  Copyright (c) 2007-2011,The Board of Trustees of the University of
 *  Illinois.  All rights reserved.
 *
 *  Copyright (c) 2011 Matthew Hicks
 *
 *  Developed by:
 *
 *  Graduate Student Matthew Hicks in the Department of Computer Science
 *  The University of Illinois at Urbana-Champaign
 *      http://www.firefalcon.com
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
 *
 * Contains at least one example of every instruction available in the ISA
*/

/*.include "exceptionHandlers.S"*/

#include "spr_defs.h"

.global _main
.section .text
_main:
	/* Test user mode instructions */
	l.jal _user_mode
	l.nop
	/* Test supervisor ins */
	l.jal _super_mode
	l.nop
	/* Exit with success */
	l.ori r3, r0, NOP_EXIT_SUCCESS
	l.nop NOP_EXIT

_user_mode:
	/* Back-up link register and go to supervisor mode tests */
	l.add r8, r0, r9
	/* Init inputs to some value */
	l.ori r3, r0, 1
	l.ori r4, r0, 2

/* Perform each user mode instruction */
/* Trample on r5 */
/* Logic ops */
	l.and r5, r3, r4
	l.andi r5, r3, 0x2
	l.ff1 r5, r4
	l.fl1 r5, r4
	l.or r5, r3, r4
	l.ori r5, r3, 2
	l.ror r5, r3, r4
	l.rori r5, r3, 0x2
	l.sll r5, r3, r4
	l.slli r5, r3, 0x2
	l.sra r5, r3, r4
	l.srai r5, r3, 0x2
	l.srl r5, r3, r4
	l.srli r5, r3, 0x2
	l.xor r5, r3, r4
	l.xori r5, r3, 0x2

	/* Arithmetic ops */
	l.add r5, r3, r4
	l.addc r5, r3, r4
	l.addi r5, r3, 0x2
	l.div r5, r4, r3
	l.divu r5, r4, r3
	l.mul r5, r3, r4
	l.muli r5, r3, 0x2
	l.mulu r5, r3, r4
	l.sub r5, r3, r4

	/* MAC instructions */
	l.mac r3, r4
	l.maci r3, 0x2
	l.msb r3, r4
	l.macrc r5

	/* Data manipulation */
	l.cmov r5, r3, r4
	l.extbs r5, r3
	l.extbz r5, r3
	l.exths r5, r3
	l.exthz r5, r3
	l.extws r5, r3
	l.extwz r5, r3
	l.movhi r5, hi(0xa5a5a5a5)

	l.ori r3, r0, lo(dataSpot)
	/* Memory ops */
	l.sb 0(r3), r5
	l.sh 0(r3), r5
	l.sw 0(r3), r5
	l.lbs r5, 0(r3)
	l.lbz r5, 0(r3)
	l.lhs r5, 0(r3)
	l.lhz r5, 0(r3)
	l.lws r5, 0(r3)
	l.lwz r5, 0(r3)

	/* Control flow */
	l.bf 2
	l.nop
	l.bnf 2
	l.nop
	l.j 2
	l.nop
	l.jal 2
	l.nop
	l.addi r3, r0, lo(.)
	l.addi r3, r3, 16
	l.jalr r3
	l.nop
	l.addi r3, r3, 12
	l.jr r3
	l.nop
	l.sys 0x13

	/* Other */
	l.nop
	l.sfeq r3, r4
	l.sfeqi r3, 0x2
	l.sfges r3, r4
	l.sfgesi r3, 0x2
	l.sfgeu r3, r4
	l.sfgeui r3, 0x2
	l.sfgts r3, r4
	l.sfgtsi r3, 0x2
	l.sfgtu r3, r4
	l.sfgtui r3, 0x2
	l.sfles r3, r4
	l.sflesi r3, 0x2
	l.sfleu r3, r4
	l.sfleui r3, 0x2
	l.sflts r3, r4
	l.sfltsi r3, 0x2
	l.sfltu r3, r4
	l.sfltui r3, 0x2
	l.sfne r3, r4
	l.sfnei r3, 0x2

	/* Go back to caller */
	l.jr r8
	l.nop

_super_mode:
	#l.csync
	l.mfspr r3, r0, SPR_SR
	#l.msync
	l.mtspr r0, r3, SPR_SR
	#l.psync
	/* l.rfe - done as part of l.sys and l.trap */
	l.trap 0x13

	/* Go back to caller */
	l.jr r9
	l.nop

.section .bss
	.set dataSpot, .
	.int
