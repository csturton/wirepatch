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

#include <stdint.h>
#include "spr_defs.h"

#define setSPR(spr, data) asm volatile( \
       "l.mtspr r0, %0, %1 \n\t"        \
       :                                \
       : "r"(data), "i"(spr)            \
   );					  

#define getSPR(spr)  ({         \
  uint32_t x;                   \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (spr)                 \
  );		                \
  x;                            \
})

#define setFabricConfigAddress(val) setSPR(SP_FABRIC_ADDRESS, val)
#define setFabricConfigData(val)    setSPR(SP_FABRIC_DATA, val)
#define strobeFabricConfig()        setSPR(SP_FABRIC_STROBE, 1); setSPR(SP_FABRIC_STROBE, 0)
#define enableFabric()  setFabricConfigAddress(0); setFabricConfigData(1); strobeFabricConfig()
#define disableFabric() setFabricConfigAddress(0); setFabricConfigData(0); strobeFabricConfig()

#define getExceptions() getSPR(SP_EXCEPTION_COUNT)
#define getAssertionViolations() getSPR(SP_ASSERTION_VIOLATIONS)
#define getAttackEnables() getSPR(SP_ATTACK_ENABLES)
#define setAttackEnables(val) setSPR(SP_ATTACK_ENABLES, (val))
