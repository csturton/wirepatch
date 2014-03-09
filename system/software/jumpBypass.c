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
#include <stdint.h>
#include <stdlib.h>
#include "spr_defs.h"
#include "commonFuncs.h"

void busyWait(void)
{
  int counter;

  for(counter = 0; counter < 10; ++counter)
  {
    ;
  }
}

void SECRET_EXIT(void)
{
  printf("DEFENSE SUCCESS\n\r");
  exit(0);
}

int main(void)
{
  uint32_t sr;

  // Configure the assertion fabric
  printf("Enabling the assertion fabric.\n\r");
  setAttackEnables(0);
  disableFabric();
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
  // Taint the link register
  setAttackEnables(1 << 11);
  asm volatile(
      "l.j 13\n\t"
      "l.nop\n\t"
      "l.movhi r9, hi(SECRET_EXIT)\n\t"
      "l.ori r9, r9, lo(SECRET_EXIT)\n\t"
      "l.jr r9\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop\n\t"
      "l.nop"
  );

  printf("DEFENSE FAILURE\n\r");

  // Exit
  printf("Exit.\n\r");
  return 0;
}
