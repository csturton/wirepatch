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

#ifndef __MMU_SUPPORT__
#define __MMU_SUPPORT__

#include "cpu.h"

#define NUM_WAYS 1
#define NUM_SETS_WAY 64

// General purpose get and set of SPRs
#define getSPR(spr) ({		 \
    unsigned int temp;           \
    asm volatile(		 \
	"l.mfspr %0, %1, 0 \n\t" \
	: "=r"(temp)		 \
	: "r"((spr))		 \
    );                           \
    temp;			 \
})
#define setSPR(spr, value) {	   \
    asm volatile(		   \
	"l.mtspr %0, %1, 0 \n\t"   \
	:                          \
	: "r"((spr)), "r"((value)) \
    );                             \
}

// Number of DMMU ways is DMMUCFGR(1:0) + 1
#define getDMMUWays() ((getSPR(SPR_DMMUCFGR) & 0x3) + 1)
// Number of DMMU sets per way is 1 << DMMUCFGR(4:2)
#define getDMMUSetsPerWay() (1 << ((getSPR(SPR_DMMUCFGR) >> 2) & 0x7))
// Number of DTLB ATBs is DMMUCFGR(7:5), must be less than 5
#define getDMMUATBs() ((getSPR(SPR_DMMUCFGR) >> 5) & 0x7)
// Number of IMMU ways is IMMUCFGR(1:0) + 1
#define getIMMUWays() ((getSPR(SPR_IMMUCFGR) & 0x3) + 1)
// Number of IMMU sets per way is 1 << IMMUCFGR(4:2)
#define getIMMUSetsPerWay() (1 << ((getSPR(SPR_IMMUCFGR) >> 2) & 0x7))
// Number of ITLB ATBs is IMMUCFGR(7:5), must be less than 5
#define getIMMUATBs() ((getSPR(SPR_IMMUCFGR) >> 5) & 0x7)

// Get and set the DMMU translate register
#define getDMMUTranslateReg(way, set) getSPR((SPR_DTLBTR_BASE(way) + (set)))
#define setDMMUTranslateReg(way, set, value) setSPR((SPR_DTLBTR_BASE(way) + (set)), value)

// Get and set the DMMU match register
#define getDMMUMatchReg(way, set) getSPR((SPR_DTLBMR_BASE(way) + (set)))
#define setDMMUMatchReg(way, set, value) setSPR((SPR_DTLBMR_BASE(way) + (set)), value)

// Get and set the IMMU translate register
#define getIMMUTranslateReg(way, set) getSPR((SPR_ITLBTR_BASE(way) + (set)))
#define setIMMUTranslateReg(way, set, value) setSPR((SPR_ITLBTR_BASE(way) + (set)), value)

// Get and set the IMMU match register
#define getIMMUMatchReg(way, set) getSPR((SPR_ITLBMR_BASE(way) + (set)))
#define setIMMUMatchReg(way, set, value) setSPR((SPR_ITLBMR_BASE(way) + (set)), value)

#define tlbEntryValid(entry)   ((entry) & 0x00000001)
#define tlbLargePage(entry)    ((entry) & 0x00000002)
#define tlbUserRead(entry)     ((entry) & 0x00000070)
#define tlbUserWrite(entry)    ((entry) & 0x00000080)
#define tlbSuperRead(entry)    ((entry) & 0x00000100)
#define tlbSuperWrite(entry)   ((entry) & 0x00000200)
#define tlbUserExecute(entry)  ((entry) & 0x00000080)
#define tlbSuperExecute(entry) ((entry) & 0x00000070)
#define tlbPPN(entry)          ((entry) & 0xffffe000)
#define tlbVPN(entry)          ((entry) & 0xffffe000)

#define addressNoOffset(address) ((address) & 0xffffe000)
#define addressOffset(address)   ((address) & 0x00001fff)

u32 virtualToPhysicalD(struct CPU *cpu, u32 address);
u32 virtualToPhysicalI(struct CPU *cpu, u32 address);
char guestLoadD(struct CPU *cpu, u32 address, u32 *value);
char guestStoreD(struct CPU *cpu, u32 address, u32 value);
char guestLoadI(struct CPU *cpu, u32 address, u32 *value);

#ifndef SIMULATOR_TEST
  #define guestLoad(guestAddr, value) *(value) = *((u32 *)(guestAddr))
  #define guestStore(guestAddr, value) *((u32 *)(guestAddr)) = (value)
#endif

#endif
