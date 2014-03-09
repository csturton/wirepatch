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
#include <stdio.h>

#define setSPR(spr, data) asm volatile( \
       "l.mtspr r0, %0, %1 \n\t"        \
       :                                \
       : "r"(data), "i"(spr)            \
   );					  

#define getSPR(spr)  ({         \
  unsigned int x;               \
  asm volatile(			\
    "l.mfspr %0, r0, %1 \n\t"   \
    : "=r" (x)                  \
    : "i" (spr)                 \
  );		                \
  x;                            \
})

#define setConfigAddress(val) setSPR(SPR_PCCR(1), val);
#define setConfigData(val) setSPR(SPR_PCCR(2), val);
#define strobeConfig() setSPR(SPR_PCCR(3), 1); setSPR(SPR_PCCR(3), 0);
#define enableFabric() setConfigAddress(0); setConfigData(1); strobeConfig();
#define disableFabric() setConfigAddress(0); setConfigData(0); strobeConfig();

void busyWait(void)
{
  int counter;

  for(counter = 0; counter < 10; ++counter)
  {
    ;
  }
}

void configureFabric(void);

int main(void)
{
  unsigned int sr;

  // Configure the assertion fabric
  printf("Configuring assertion fabric.\n\r");
  disableFabric();
  configureFabric();
  enableFabric();

  // Go to user mode
  printf("Going to user mode.\n\r");
  sr = getSPR(SPR_SR);
  sr = sr & 0xfffffffe;
  setSPR(SPR_SR, sr);

  // Do some stuff
  printf("Waiting.\n\r");
  busyWait();

  // Trigger attack
  printf("Triggering attack.\n\r");
  setSPR(SPR_PCCR(3), 0x80000000);
  setSPR(SPR_PCCR(3), 0x00000000);

  // Do some stuff
  printf("Waiting.\n\r");
  busyWait();

  // Test
  if((getSPR(SPR_SR) & 0x1) == 0)
    printf("DEFENSE SUCCESS\n\r");
  else
    printf("DEFENSE FAILURE\n\r");

  // Exit
  printf("Exit.\n\r");
  return 0;
}

void configureFabric(void)
{
  unsigned int items[] = {
    0, // Blank---does nothing
    5,
    0,
    4,
    3,
    5,
    0,
    4,
    2,
    5,
    0,
    4,
    2,
    4,
    0,
    1,
    0,
    4,
    0,
    0,
    0,
    0xfc000000,
    0,
    0x24000000, //l.rfe << (32-6),
    0,
    0,
    0x00000001,
    0x00000001,
    0,
    1,
    0,
    0xfc000000,
    0,
    0xc0000000, //l.mtspr,
    0,
    0,
    0x00000001,
    0x00000001,
    0,
    1,
    0,
    0x03e00fff, //.target,
    0,
    17, //SR,
    0,
    0,
    0x00000001,
    0x00000001,
    0,
    1,
    0,
    0x00000001,
    0,
    1,
    0,
    0,
    0xffffffff,
    0,
    0,
    0,
    0,
    0x00000001,
    0,
    1,
    0,
    0,
    0xfffff0ff,
    0,
    0,
    0,
    0};
					       
  int counter;

  for(counter = 0; counter < sizeof(items)/sizeof(unsigned int); ++counter)
  {
    setConfigAddress(counter);
    setConfigData(items[counter]);
    strobeConfig();
  }
}
