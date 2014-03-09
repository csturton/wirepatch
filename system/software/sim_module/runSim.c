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

#ifndef STANDALONE
  #define DEBUG
  #ifdef DEBUG
    #include <stdio.h>
    #define debug_print(...) printf(__VA_ARGS__)
  #else
    #define debug_print(...)
  #endif
#else
  #define debug_print(...)
#endif

#include "simulator.h"
#include "counters.h"

u32 recalc_ea(struct CPU *cpu, u32 address)
{
    u32 insn;
    u32 ea;
    struct control cont;
    u32 backup_pc = cpu->pc;

    cpu->pc = address;
    cpu->npc = address + 4;

    // With software managed TLBs, last insn must be in I-TLB
    insn = fetch(cpu);
    decode(&cont, insn);
    ea = calc_ea(cpu, &cont);

    cpu->pc = backup_pc;
    cpu->npc = backup_pc + 4;

    return ea;   
}

u32 calc_jump_target(struct CPU *cpu, u32 address)
{
    u32 insn;
    u32 target;
    struct control cont;
    u32 backup_pc = cpu->pc;

    cpu->pc = address;
    cpu->npc = address + 4;

    // With software managed TLBs, last insn must be in I-TLB
    insn = fetch(cpu);
    decode(&cont, insn);
    switch(cont.opcode)
    {
      case OP_RFE:
        target = cpu_get_epcr(cpu);
        break;
      case OP_J:
      case OP_JAL:
      case OP_BF:
      case OP_BNF:
        target = (cpu_get_pc(cpu) + (u32) sign_extend(cont.N << 2, 27));
        break;
      case OP_JALR:
      case OP_JR:
        target = cpu_get_gpr(cpu, cont.rB);
        break;
      case OP_SYS_TRAP_SYNC:
        target = 0xC00;
        break;
      default:
        target = 0;
    }

    cpu->pc = backup_pc;
    cpu->npc = backup_pc + 4;

    return target;
}


void runSim()
{
    u32 insn;
    u32 violated;
    u32 insnCount;

    //insnCount = getExceptionCount();
    //setExceptionCount(++insnCount);

    // Get the assertion violated
    violated = getAssertionReg();

    if((violated & 0x308) != 0)
    {
      insn = cpu_get_sr(&cpu);
      cpu_set_sr(&cpu, insn & 0xFFFFFFFE);

      if((violated & 0x8) == 0)
	   return;
    } 

    if((violated & 0x8000) != 0)
    {
      cpu_set_sr(&cpu, cpu_get_esr(&cpu));
      cpu_set_pc(&cpu, cpu_get_epcr(&cpu));
      return;
    } 

    // Due to our added write gating, the EPCR is the instruction after
    // the one squashed by the assertion violation
    u32 pc = getEPPCReg();
    u32 epcr_t = getEPCRReg();
    
    // Look for when assertion violation occured in delay slot
    // PC in this case is insn before delay slot
    if((epcr_t-pc) > 4 || (pc-epcr_t) > 4)
      pc = pc - 4;

    cpu_set_pc(&cpu, pc);
    cpu_set_npc(&cpu, pc+4);
    

    // Best to create macro assertions based on reg/flag protections
    // instead of on highel-level properties, due to making the recovery
    // strategy easier to determine at runtime
    // What happens mult contaminations
    // What happens contamination on recovery entry

    if((violated & 0x8) != 0)
    {
        u32 epcr;
        u32 eear;
        u32 eppc = getEPPCReg();

        // Handle exception in end (delay slot) of basic block case
        if(cpu_get_dsx(&cpu))
        {
            // Go back to most recent jump
            epcr = eppc;
            eear = ((cpu_get_pc(&cpu) & 0xFFFFFF00) == 0xA00) ? epcr + 4 : recalc_ea(&cpu, epcr + 4);
        }
        // Handle exception in middle of basic block case
        else if((violated & 0x80000) == 0)
        {
            epcr = eppc + 4;
            eear = ((cpu_get_pc(&cpu) & 0xFFFFFF00) == 0xA00) ? epcr : recalc_ea(&cpu, epcr);
        }
        // Handle exception in front of basic block case
        else
        {
            // Go back to most recent jump, in previous basic block
            // Assumes that delay slot instruction doesn't change the EA of the preceeding jump
            u32 target_addr = calc_jump_target(&cpu, eppc - 4);
            // Not all control flow discontinuities have delay slots
            target_addr = target_addr == 0 ? calc_jump_target(&cpu, eppc) : target_addr;
            epcr = target_addr;
            eear = ((cpu_get_pc(&cpu) & 0xFFFFFF00) == 0xA00) ? target_addr : recalc_ea(&cpu, target_addr);
        }

        cpu_set_epcr(&cpu, epcr);
        cpu_set_eear(&cpu, eear);
    }

    /* Perform two instructions */
    #ifndef STANDALONE
      guestLoadI(&cpu, cpu_get_pc(&cpu), &insn);
      debug_print("%8.8x: %8.8x\n\r", cpu_get_pc(&cpu), insn);
    #endif

    cpu_exec_inst(&cpu);

    do
    {
      #ifndef STANDALONE
        guestLoadI(&cpu, cpu_get_pc(&cpu), &insn);
        debug_print("%8.8x: %8.8x\n\r", cpu_get_pc(&cpu), insn);
      #endif

	cpu_exec_inst(&cpu);

    /* Don't return in branch delay slot */
    } while(is_in_delay_slot(&cpu));
}
