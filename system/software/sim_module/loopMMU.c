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

#ifndef LINUX
  #include <or1k-support.h>
#endif
#include <stdio.h>
#include "counters.h"
#include "mmu_support.h"

#define TLB_FLAGS_M 0x0001
#define TLB_FLAGS_T_D 0x03C0
#define TLB_FLAGS_T_I 0x00C0

#ifdef SIM
  #define PERIOD 10
  #define LOOP_SIZE 500
#else
  #define PERIOD 10
  #define LOOP_SIZE 50000
#endif

#define dump_value(value); {u32 backup;\
  asm volatile(                        \
      "l.add %0, r0, r3 \n\t"          \
      "l.add r3, r0, %1 \n\t"          \
      "l.nop 0x2 \n\t"                 \
      "l.add r3, r0, %0 \n\t"          \
      : "=&r"(backup)                  \
      : "r"(value)                     \
  );                                   \
}

void dtlb(void)
{
  unsigned int ea;

  asm volatile("l.mfspr %0, r0, %1 \n\t":"=r"(ea):"i"(SPR_EEAR_BASE));
  dump_value(ea);
  #ifndef SIM
      printf("Data TLB Miss @ 0x%8.8x\n\r", ea);
  #endif

  setDMMUMatchReg(0, ((ea >> 13) & 63), (ea & (-1 << 13)) | TLB_FLAGS_M);
  setDMMUTranslateReg(0, ((ea >> 13) & 63), (ea & (-1 << 13)) | TLB_FLAGS_T_D);
}

void itlb(void)
{
  unsigned int ea;

  asm volatile("l.mfspr %0, r0, %1 \n\t":"=r"(ea):"i"(SPR_EEAR_BASE));
  dump_value(ea);
  #ifndef SIM
      printf("Instruction TLB Miss @ 0x%8.8x\n\r", ea);
  #endif

  setIMMUMatchReg(0, ((ea >> 13) & 63), (ea & (-1 << 13)) | TLB_FLAGS_M);
  setIMMUTranslateReg(0, ((ea >> 13) & 63), (ea & (-1 << 13)) | TLB_FLAGS_T_I);
}

int main(void)
{
  int counter = 0;
  int bigCount = 0;
  unsigned int dsr, sr;

  setPeriod(0);
  resetExceptionCount();

#ifndef LINUX
  // Ensure that the debug stop register does NOT handle IIEs
  dsr = -1 ^ (SPR_DSR_IIE | SPR_DSR_DME | SPR_DSR_IME);
  asm volatile(
	       "l.mtspr r0, %0, %1 \n\t"
	       :
	       : "r"(dsr), "i"(SPR_DSR)
  );
  // Enable interrupt and exception handling
  asm volatile("l.mfspr %0, r0, %1 \n\t":"=r"(sr):"i"(SPR_SR));
  sr = sr | SPR_SR_IEE;
  asm volatile("l.mtspr r0, %0, %1 \n\t": : "r"(sr), "i"(SPR_SR));  
#else
  asm volatile("l.mfspr %0, r0, %1 \n\t":"=r"(dsr):"i"(SPR_DSR));
  // Ensure that the debug stop register does NOT handle IIEs 
  dsr = dsr & (-1 ^ SPR_DSR_IIE);
  asm volatile("l.mtspr r0, %0, %1 \n\t": :"r"(dsr), "i"(SPR_DSR));
#endif

  dump_value(getDMMUWays());
  dump_value(getDMMUSetsPerWay());
  dump_value(getIMMUWays());
  dump_value(getIMMUSetsPerWay());

#ifndef SIMNO
  printf("DMMU number of ways: %d \n\r", getDMMUWays());
  printf("DMMU number of sets: %d \n\r", getDMMUSetsPerWay());
  printf("IMMU number of ways: %d \n\r", getIMMUWays());
  printf("IMMU number of sets: %d \n\r", getIMMUSetsPerWay());
#endif

#ifndef LINUX
  or1k_exception_handler_add(0x9, dtlb);
  or1k_exception_handler_add(0xA, itlb);

  // Printing fails due to caching of UART address
  or1k_dcache_disable();
  or1k_icache_disable();
#endif

  setPeriod(PERIOD);
  dump_value(PERIOD);

  u32 reg1;
  asm volatile("l.add %0, r1, r0 \n\t" :"=r"(reg1));
  dump_value(reg1);

#ifndef SIM
  printf("Reg 1: 0x%8.8x\n\r", reg1);
#endif

#ifndef LINUX
  or1k_immu_enable();
  or1k_dmmu_enable();
#endif

  while(1)
  {
    ++counter;
    if(counter == LOOP_SIZE)
    {
        dump_value(-1);
        dump_value(bigCount);
        dump_value(getExceptionCount());
        dump_value(getInstructionCount());
        dump_value(getBailCount());
      #ifndef SIM
        printf("Hello World! %d %d %d %d\n\r", bigCount, getExceptionCount(), getInstructionCount(), getBailCount());
      #endif
      counter = 0;
      ++bigCount;
    }
  }

  return 0;
}
