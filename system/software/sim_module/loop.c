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

#include <stdio.h>
#include "spr_defs.h"
#define TIMER_REG SPR_PCCR(1)
#define EXCEPTION_COUNT_REG SPR_PCCR(0)

#define getExceptionCount() ({ unsigned int val;    \
                     asm volatile(		    \
                         "l.mfspr %0, r0, %1 \n\t"  \
                         : "=r"(val)                \
                         : "i"(EXCEPTION_COUNT_REG) \
		     );                             \
		     val;                           \
    })

#define getTimerStart() ({ unsigned int val;    \
                     asm volatile(		    \
                         "l.mfspr %0, r0, %1 \n\t"  \
                         : "=r"(val)                \
                         : "i"(TIMER_REG) \
		     );                             \
		     val;                           \
    })

#define setTimerStart(val) {unsigned int x = (val); \
                     asm volatile(                  \
	                 "l.mtspr r0, %0, %1 \n\t"  \
	                 :                          \
	                 : "r"(x), "i"(TIMER_REG) \
		     );}                   

#define setExceptionCount(val) {unsigned int x = (val);	    \
                     asm volatile(                          \
	                 "l.mtspr r0, %0, %1 \n\t"          \
	                 :                                  \
	                 : "r"(x), "i"(EXCEPTION_COUNT_REG) \
		     );}                            

int main(void)
{
  int counter = 0;
  int bigCount = 0;
  unsigned int countStart = 500000;
  unsigned int dsr;

  setTimerStart(0);

  // Ensure that the debug stop register does NOT handle IIEs
  asm volatile(
	       "l.mfspr %0, r0, %1 \n\t"
	       : "=r"(dsr)
	       : "i"(SPR_DSR)
  );
  dsr = dsr & (SPR_DSR_IIE ^ 0xffffffff);
  asm volatile(
	       "l.mtspr r0, %0, %1 \n\t"
	       :
	       : "r"(dsr), "i"(SPR_DSR)
  );          

  setExceptionCount(0);
  setTimerStart(countStart);

  while(1)
  {
    ++counter;
    if(counter == 5000000)
    {
      printf("Hello World! %d %d %d\n\r", bigCount, getExceptionCount(), getTimerStart());
      counter = 0;
      ++bigCount;
    }
  }

  return 0;
}
