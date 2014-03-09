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

#include "spr_defs.h"

#define EXCEPTION_COUNT_REG SPR_PCCR(0)
#define COUNTER_INIT_REG SPR_PCCR(1)
#define INSTRUCTION_COUNT_REG SPR_PCCR(2)
#define BAIL_COUNT_REG SPR_PCCR(3)

// Assertion status reg
#define getAssertionReg()  ({	\
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (ASSERTION_REG)	\
  );		                \
  x;                            \
})

// PPC at time of assertion violation
#define getEPPCReg()  ({	\
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (EPPC_REG)		\
  );		                \
  x;                            \
})

// EPCR
#define getEPCRReg()  ({	\
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (SPR_EPCR_BASE)	\
  );		                \
  x;                            \
})

// Exception count reg
#define getExceptionCount()  ({ \
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (EXCEPTION_COUNT_REG) \
  );		                \
  x;                            \
})
#define setExceptionCount(x)  asm volatile(\
  "l.mtspr r0, %0, %1 \n\t"                \
  :                                        \
  : "r" (x), "i" (EXCEPTION_COUNT_REG)     \
  )
#define resetExceptionCount() setExceptionCount(0)

// Counter init reg
#define getPeriod()  ({         \
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (COUNTER_INIT_REG)    \
  );		                \
  x;                            \
})
#define setPeriod(x)  asm volatile(     \
  "l.mtspr r0, %0, %1 \n\t"             \
  :                                     \
  : "r" (x), "i" (COUNTER_INIT_REG)     \
  )
#define resetPeriod() setPeriod(0)

// Instruction count reg
#define getInstructionCount()  ({ \
  unsigned int x;                 \
  asm volatile(			  \
    "l.mfspr %0, r0, %1 \n\t"     \
    : "=r" (x)                    \
    : "i" (INSTRUCTION_COUNT_REG) \
  );	                          \
  x;                              \
})
#define setInstructionCount(x)  asm volatile(\
  "l.mtspr r0, %0, %1 \n\t"                  \
  :                                          \
  : "r" (x), "i" (INSTRUCTION_COUNT_REG)     \
  )
#define resetInstructionCount() setInstructionCount(0)

// Bail count reg
#define getBailCount()  ({      \
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (BAIL_COUNT_REG)      \
  );		                \
  x;                            \
})
#define setBailCount(x)  asm volatile(\
  "l.mtspr r0, %0, %1 \n\t"           \
  :                                   \
  : "r" (x), "i" (BAIL_COUNT_REG)     \
  )
#define resetBailCount() setBailCount(0)
