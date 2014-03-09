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

#include "counters.h"
#include "cpu.h"
#include "mmu_support.h"

#define flushCaches(phyAddr) {		\
    asm volatile(                       \
	"l.mtspr r0, %0, %1 \n\t"       \
	:                               \
	: "r"(phyAddr), "i"(SPR_DCBFR)  \
    );                                  \
    asm volatile(                       \
	"l.mtspr r0, %0, %1 \n\t"       \
	:                               \
	: "r"(phyAddr), "i"(SPR_ICBIR)  \
    );                                  \
    }


#define flushPipeline() {	 \
    asm volatile(		 \
	"l.nop \n\t"             \
	"l.nop \n\t"             \
	"l.nop \n\t"             \
	"l.nop \n\t"             \
	"l.nop \n\t"             \
    );                           \
}

// these functions need to be implemented to be able to link to 
// the simulator code
#ifdef MMU_SUPPORT
// Given a the cpu state and a virtual address
// Returns the physical address or 1 for TLB miss
u32 virtualToPhysicalD(struct CPU *cpu, u32 guestAddr)
{
  // If the DMMU is not enabled, virtual = physical
  if(!cpu_get_dme(cpu))
    return guestAddr;
  
  u32 setIndex = (guestAddr >> 13) & (NUM_SETS_WAY - 1);

  // Walk the D-TLB ways looking for the virtual address mapping
  u32 way;
  for(way = 0; way < NUM_WAYS; ++way)
  {
    u32 tlbMR = SPR_DTLBMR_BASE(way) + setIndex;
    u32 entry;

    // Get the virtual address for this set
    asm volatile(
        "l.mfspr %0, %1, 0 \n\t"
	: "=r"(entry)
	: "r"(tlbMR)
    );

    // Check for valid TLB entry
    if(!tlbEntryValid(entry))
      continue;

    // OR1200 doesn't support large pages
    /*if(tlbLargePage(entry))
      continue;*/

    // Check for virtual address match
    if(tlbVPN(entry) == addressNoOffset(guestAddr))
    {
      u32 tlbTR = SPR_DTLBTR_BASE(way) + setIndex;
      u32 phyAddr;

      // Get the physical address for this set from the translate reg
      asm volatile(
	  "l.mfspr %0, %1, 0 \n\t"
	  : "=r"(phyAddr)
	  : "r"(tlbTR)
      );

      // Check permissions to create page fault
      // OR1200 does not set permissions
      /*if((!cpu_get_sm(cpu) && !tlbUserRead(phyAddr)) || (cpu_get_sm(cpu) && !tlbSuperRead(phyAddr)))
	return 2;*/
      
      phyAddr = tlbPPN(phyAddr) | addressOffset(guestAddr);      
      return phyAddr;
    }
  }

  // Walk the page table to find the mapping
  return 1;
}

// Given a the cpu state and a virtual address
// Returns the physical address or 1 for TLB miss
u32 virtualToPhysicalI(struct CPU *cpu, u32 guestAddr)
{
  // If the IMMU is not enabled, virtual = physical
  if(!cpu_get_ime(cpu))
    return guestAddr;

  u32 setIndex = (guestAddr >> 13) & (NUM_SETS_WAY - 1);

  // Walk the I-TLB ways looking for the virtual address mapping
  u32 way;
  for(way = 0; way < NUM_WAYS; ++way)
  {
    u32 tlbMR = SPR_ITLBMR_BASE(way) + setIndex;
    u32 entry;

    // Get the virtual address for this set
    asm volatile(
        "l.mfspr %0, %1, 0 \n\t"
	: "=r"(entry)
	: "r"(tlbMR)
    );

    // Check for valid TLB entry
    if(!tlbEntryValid(entry))
      continue;

    // OR1200 does not support large pages
    /*if(tlbLargePage(entry))
      continue;*/

    // Check for virtual address match
    if(tlbVPN(entry) == addressNoOffset(guestAddr))
    {
      u32 tlbTR = SPR_ITLBTR_BASE(way) + setIndex;
      u32 phyAddr;

      // Get the physical address for this set from the translate reg
      asm volatile(
	  "l.mfspr %0, %1, 0 \n\t"
	  : "=r"(phyAddr)
	  : "r"(tlbTR)
      );

      // Check permissions to create page fault
      // OR1200 does not set permissions correctly
      /*if((!cpu_get_sm(cpu) && !tlbUserRead(phyAddr)) || (cpu_get_sm(cpu) && !tlbSuperRead(phyAddr)))
	return 2;*/
      
      phyAddr = tlbPPN(phyAddr) | addressOffset(guestAddr);
      return phyAddr;
    }
  }

  // Walk the page table to find the mapping
  return 1;
}

// Given the cpu state and a virtual address, and a value holder
// If the D-TLB contains a phys. to virt. mapping for the address
// Load the address of value with the value at the physical address
// Return 0 on success, 1 for a TLB-miss, 2 for a page fault
char guestLoadD(struct CPU *cpu, u32 guestAddr, u32 *value)
{
  u32 phyAddr;

  phyAddr = virtualToPhysicalD(cpu, guestAddr);

  if(phyAddr > 2)
  {
    guestLoad(phyAddr, value);
    return 0;
  }

  return phyAddr;
}

// Given the cpu state and a virtual address, and a value holder
// If the D-TLB contains a phys. to virt. mapping for the address
// Load the address of value with the value at the physical address
// Return 0 on success, 1 for a TLB-miss, 2 for a page fault
char guestStoreD(struct CPU *cpu, u32 guestAddr, u32 value)
{
  u32 phyAddr;
  u32 temp;

  phyAddr = virtualToPhysicalD(cpu, guestAddr);

  if(phyAddr > 2)
  {
    flushCaches(phyAddr);

    temp = getSPR(SPR_SR);
    setSPR(SPR_SR, temp & 0xffffffe7);
    flushPipeline();

    // Write the value directly to the physical address
    // After flush to prevent write-back overwrites
    guestStore(phyAddr, value);

    setSPR(SPR_SR, temp);
    flushPipeline();

    return 0;
  }
  
  return phyAddr;
}

// Given the cpu state and a virtual address, and a value holder
// If the I-TLB contains a phys. to virt. mapping for the address
// Load the address of value with the value at the physical address
// Return 0 on success, 1 for a TLB-miss, 2 for a page fault
char guestLoadI(struct CPU *cpu, u32 guestAddr, u32 *value)
{
  u32 phyAddr = virtualToPhysicalI(cpu, guestAddr);

  if(phyAddr > 2)
  {
    /* Note that this will get the version of the instruction
       that is in the data cache */
    guestLoad(phyAddr, value);
    return 0;
  }
  
  return phyAddr;
}
#else
  char guestLoadD(struct CPU *cpu, u32 address, u32 *value){guestLoad(address, value); return 0;}
  char guestStoreD(struct CPU *cpu, u32 address, u32 value){guestStore(address, value); return 0;}
  char guestLoadI(struct CPU *cpu, u32 address, u32 *value){guestLoad(address, value); return 0;}
#endif
