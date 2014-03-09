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

#include "cpu.h"

struct CPU cpu;

#ifndef STANDALONE
void cpu_reset(struct CPU *cpu) 
    _(requires \thread_local(cpu))
    _(requires \wrapped(cpu))
    _(ensures \wrapped(cpu))
    _(ensures cpu_get_maclo(cpu) == 0)
    _(ensures cpu_get_machi(cpu) == 0)
    _(ensures cpu_get_pc(cpu) == 0x100)
    _(ensures cpu_get_npc(cpu) == cpu_get_pc(cpu) + 4)
    _(ensures cpu_get_sr(cpu) == 0x00008001)
    _(writes cpu)
{
    _(unwrap cpu)
    _(unwrap cpu->regs)
    int idx;
    for(idx = 0; idx < NUM_REGS; idx++) 
        _(writes \array_range(cpu->regs->gpr, NUM_REGS))
        _(invariant \forall int i; (i >= 0 && i < idx) ==> cpu->regs->gpr[i] == 0)
    {
        cpu_set_gpr(cpu, idx, 0);
    }
    _(assert \forall u32 i; i<NUM_REGS ==> cpu->regs->gpr[i] == 0)
    cpu_set_sr(cpu, 0x00008001);
    cpu_set_maclo(cpu, 0);
    cpu_set_machi(cpu, 0);
    cpu_set_pc(cpu, 0x100);
    cpu_set_npc(cpu, cpu_get_pc(cpu) + 4);
    _(wrap cpu->regs)
    _(wrap cpu);
}

/* Links the passed register file to the passed cpu structure */
static void cpu_initvars(struct CPU *cpu) 
    _(requires \mutable(cpu))
    _(requires \wrapped(regs))
    _(requires \malloc_root(cpu))
    _(requires regs->\valid && \thread_local(regs))
    _(ensures cpu->regs == regs)
    _(ensures cpu_get_npc(cpu) == _(unchecked) (cpu_get_pc(cpu) + 4))
    _(ensures cpu_get_branch_pc(cpu) == 0xffffffff)
    _(ensures \wrapped(cpu) && \nested(regs) )
    _(writes \extent(cpu), regs)
{
    cpu_set_npc(cpu, (cpu_get_pc(cpu) + 4));
    cpu_set_branch_pc(cpu, 0xffffffff);
    _(wrap cpu)
}

/* Initializes the cpu structure and links in the register file */
void cpu_init0(struct CPU *cpu) 
    _(requires \thread_local(regs))
    _(requires \wrapped(regs))
    _(ensures \result ==> \wrapped(\result))
    _(ensures \result ==> \result->regs == regs)
    _(ensures \result ==> \result->npc == _(unchecked) (regs->pc+4))
    _(ensures \result ==> \result->branch_pc == 0xffffffff)
    _(ensures !\result <==> !\wrapped(result))
    _(ensures !\result <==> !\thread_local(result))
    _(writes regs)
{
    //_(assert \thread_local(regs) ==> regs != NULL)

    _(assume \malloc_root(cpu))

    //TODO: write contract for the memset function
    memset(cpu, 0, sizeof(struct CPU));
    //FIXME: can I get rid of the assumption
    _(assume \forall size_t i; i < sizeof(struct CPU) ==> cpu+i == 0) // this is the postcondition of memset
    _(assert \mutable(cpu))
    _(assert \mutable(&cpu_get_branch_pc(cpu)))
    _(assert \mutable(&cpu->regs))
    _(assert \mutable(&cpu->npc))
    cpu_initvars(cpu);

    _(assert cpu->regs == regs)
    _(assert cpu->npc == _(unchecked) (regs->pc + 4))
    _(assert cpu_get_branch_pc(cpu) == 0xffffffff)
    _(assert \wrapped(cpu))
}
#endif

void cpu_advance_pc(struct CPU *cpu) 
    _(requires \thread_local(cpu))
    _(requires \wrapped(cpu))
    _(ensures \wrapped(cpu))
    _(ensures cpu_get_pc(cpu) == \old(cpu_get_npc(cpu)))
    _(ensures \old(cpu_get_branch_pc(cpu)) != (0xffffffff) ==> (cpu_get_npc(cpu) == \old(cpu_get_branch_pc(cpu))))
    _(ensures \old(cpu_get_branch_pc(cpu)) != (0xffffffff) ==> (cpu_get_branch_pc(cpu) == 0xffffffff))
    _(ensures \old(cpu_get_branch_pc(cpu)) == (0xffffffff) ==> (cpu_get_npc(cpu) == _(unchecked)(\old(cpu_get_npc(cpu)) + 4)))
    _(writes cpu)
{
    _(unwrap cpu)
    _(unwrap cpu->regs)
    cpu_set_pc(cpu, cpu_get_npc(cpu));
    _(wrap cpu->regs)
      if(cpu_get_branch_pc(cpu) != 0xffffffff) {
        cpu_set_npc(cpu, cpu_get_branch_pc(cpu));
        cpu_set_branch_pc(cpu, 0xffffffff);
    } else {
        _(unchecked) cpu_set_npc(cpu, cpu_get_npc(cpu) + 4);
    }
    
    _(wrap cpu)
}

void cpu_set_gpr(struct CPU *cpu, u32 reg, u32 value)
{
  /* Assumes 0 <= reg <=  31 */
  /* gpr[0] is always 0 */
  cpu->gpr[reg] = (reg == 0) ? 0 : value;
}

/* We only handle writes and reads to certain SPRs */
void cpu_set_spr(struct CPU *cpu, u32 spr, u32 value) 
    _(requires \thread_local(cpu))
    _(requires \wrapped(cpu))
    _(ensures \wrapped(cpu))
    _(ensures spr == SPR_SR ==> 
              (cpu_get_sr(cpu) == ((value & 0xf001ffff) | 0x00008000)))
    _(writes cpu)
{
    assert((cpu_get_sr(cpu) & SPR_SR_SM) != 0);
    switch(spr)
    {
      case SPR_NPC:
	cpu_set_npc(cpu, value);
	break;
      case SPR_SR:
	cpu_set_sr(cpu, (value & 0xf001ffff) | 0x00008000);
	break;
      case SPR_PPC:
	cpu_set_pc(cpu, value);
	break;
      case SPR_EPCR_BASE:
	cpu_set_epcr(cpu, value);
	break;
      case SPR_EEAR_BASE:
	cpu_set_eear(cpu, value);
	break;
      case SPR_ESR_BASE:
	cpu_set_esr(cpu, value);
	break;
      case SPR_DSR:
	cpu_set_dsr(cpu, value);
	break;
      case SPR_MACLO:
	cpu_set_maclo(cpu, value);
	break;
      case SPR_MACHI:
	cpu_set_machi(cpu, value);
	break;
	/* In standalone mode, no timer support, so timing does get ruined */
#ifndef STANDALONE
      case SPR_TTMR:
	cpu_set_ttmr(cpu, value);
	break;
      case SPR_TTCR:
	cpu_set_ttcr(cpu, value);
	break;
#endif
      default:
	#ifdef STANDALONE
	  asm volatile("l.mtspr %0, %1, 0 \n\t": :"r"(spr), "r"(value));
	#else
	  _(assert false);
          myprint("ERROR: Unknown spr = 0x%08x\n", spr);
          assert(false);
	#endif
    }
}

/* We only handle writes and reads to certain SPRs */
u32 cpu_get_spr(struct CPU *cpu, u32 spr) 
{
    /* Can only read in supervisor mode */
    assert((cpu_get_sr(cpu) & SPR_SR_SM) != 0);

    switch(spr)
    {
      case SPR_NPC:
	return cpu_get_npc(cpu);
      case SPR_SR:
	return cpu_get_sr(cpu);
      case SPR_PPC:
	return cpu_get_pc(cpu);
      case SPR_EPCR_BASE:
	return cpu_get_epcr(cpu);
      case SPR_EEAR_BASE:
	return cpu_get_eear(cpu);
      case SPR_ESR_BASE:
	return cpu_get_esr(cpu);
      case SPR_DSR:
	return cpu_get_dsr(cpu);
      case SPR_MACLO:
	return cpu_get_maclo(cpu);
      case SPR_MACHI:
	return cpu_get_machi(cpu);
#ifndef STANDALONE
      case SPR_TTMR:
	return cpu_get_ttmr(cpu);
      case SPR_TTCR:
	return cpu_get_ttcr(cpu);
#endif
      default:
	#ifdef STANDALONE
	{
	  u32 ret;
	  asm volatile("l.mfspr %0, %1, 0 \n\t":"=r"(ret):"r"(spr));
	  return ret;
	}
        #else
	  myprint("ERROR: Unknown spr 0x%08x\n", spr);
	  assert(false);
	#endif
    }

    _(assert false)
    return 0;
}
