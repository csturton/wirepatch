/*
 * University of Illinois/NCSA
 * Open Source License
 *
 *  Copyright (c) 2007-2011,The Board of Trustees of the University of
 *  Illinois.  All rights reserved.
 *
 *  Copyright (c) 2011 Sam King, Matthew Hicks, and Edgar Pek
 *
 *  Developed by:
 *
 *  Professor Sam King in the Department of Computer Science
 *  The University of Illinois at Urbana-Champaign
 *      http://www.cs.uiuc.edu/homes/kingst/Research.html
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

#ifndef __SIMULATOR_H__
#define __SIMULATOR_H__

#include "cpu.h"
#include "counters.h"

#define OP_J    0x0
#define OP_JAL  0x1
#define OP_JALR 0x12
#define OP_BNF  0x3
#define OP_BF   0x4
#define OP_NOP  0x5
#define OP_JR   0x11
#define OP_LWZ  0x21
#define OP_LWS  0x22
#define OP_LBZ  0x23
#define OP_LBS  0x24
#define OP_LHZ  0x25
#define OP_LHS  0x26
#define OP_ADDI 0x27
#define OP_ADDIC 0x28
#define OP_ORI  0x2a
#define OP_XORI 0x2b
#define OP_MULI 0x2c
#define OP_SFI  0x2f
#define OP_SW   0x35
#define OP_SB   0x36
#define OP_SH   0x37
#define OP_ALU  0x38
#define OP_MAC  0x31
#define OP_MACI 0x13
#define OP_MACRC_MOVHI 0x6
#define OP_MTSPR 0x30
#define OP_MFSPR 0x2d
#define OP_ANDI 0x29
#define OP_RO_SHIFT_I 0x2e
#define OP_SF 0x39
#define OP_SYS_TRAP_SYNC 0x08
#define OP_TRAP 0x21
#define OP_PM_SYNC 0x22
#define OP_CSYNC 0x23
#define OP_RFE 0x9

struct control {
    u32 inst;
    u32 opcode; _(invariant \this->opcode == ((\this->inst >> 26) & 0x3f))
    u32 sf_op;  _(invariant \this->sf_op == ((\this->inst >> 21) & 0x1f))
    u32 alu_op; _(invariant \this->alu_op < (1<<10))
    u32 ro_shift_i_op;
    u32 rD;     _(invariant \this->rD == ((\this->inst >> 21) & 0x1f))
    u32 rA;     _(invariant \this->rA == ((\this->inst >> 16) & 0x1f))
    u32 rB;     _(invariant \this->rB == ((\this->inst >> 11) & 0x1f))
    u32 N;      _(invariant \this->N == (\this->inst & 0x03ffffff))
//  u32 K; _(invariant \this->K == (\this->inst & 0x0000ffff)) //OLD INVARIANT
    u32 K;      _(invariant \this->K < (1<<16)) //NEW INVARIANT
    u32 I;      _(invariant \this->I < (1<<16))
    u32 L;
};

// these are the function that the simulator implements and exports
bool cpu_exec_inst(struct CPU *cpu);
void decode(struct control *cont, u32 inst);
u32 fetch(struct CPU *cpu);
u32 calc_ea(struct CPU *cpu, struct control *cont);
i32 sign_extend(u32 value, u32 sign_bit);

#define BAIL() ;
/*#define BAIL() {setBailCount(getBailCount() + 1);	\
  asm volatile("l.j _bail\n\tl.nop\n\t");}*/

#ifdef DIRECT_CALL_SIM
  extern _iieHandler;
  #define CALL_SIMULATOR() /* Set up epcr and esr as if exception occured */ \
  asm volatile( \
      /* Copy SR into ESR */ \
      "l.mfspr %0, r0, %1 \n\t" \
      "l.mtspr r0, %0, %2 \n\t" \
      /* Copy address of returnHere to EPCR */ \
      "l.mfspr %0, r0, %3 \n\t" \
      "l.addi %0, %0, 24 \n\t"  \
      "l.mtspr r0, %0, %4 \n\t" \
      "l.j %5 \n\t"             \
      "l.nop \n\t"              \
      : "=&r"(out)              \
      : "i"(SPR_SR), "i"(SPR_ESR_BASE), "i"(SPR_PPC), "i"(SPR_EPCR_BASE), "i"(&_iieHandler)                   \
  )
#endif

#endif
