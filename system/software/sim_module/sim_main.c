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
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#include "simulator.h"

#define RAM_SIZE (1024*1024)
static unsigned char *ram = NULL;

//#define DEBUG
#ifdef DEBUG
  #define debug_print(...) printf(__VA_ARGS__)
#else
  #define debug_print(...)
#endif

bool guestLoad(u32 guestAddr, u32 *value) {
    assert((guestAddr & 0x3) == 0);

    if(guestAddr > (RAM_SIZE-4)) {
        return false;
    }
    *value = *((u32 *)(ram + guestAddr));
    return true;
}

bool guestStore(u32 guestAddr, u32 value) {
    assert((guestAddr & 0x3) == 0);

    if(guestAddr > (RAM_SIZE-4)) {
        return false;
    }
    *((u32 *) (ram+guestAddr)) = value;
    
    return true;
}

static void fillState(char *fileName, void *buf, unsigned int size) {
    FILE *fd;

    assert(size > 0);

    fd = fopen(fileName, "r");
    assert(fd != NULL);

    /* Read 32-bits from the file, convert endianess, until end or error */
    /* This is not meant to be fast, but quick to program */
    char word[4];
    unsigned int address = 0x0;
    while(fread(&word, sizeof(word), 1, fd) == 1 && !feof(fd) && !ferror(fd))
    {
      guestStore(address, ((word[0] & 0xff) << 24) | ((word[1] & 0xff) << 16) | ((word[2] & 0xff) << 8) | (word[3] & 0xff));
      address += 0x4;

      /* Ensure RAM is large enough */
      assert(address < size);
    }
    
    fclose(fd);
}


int main(int argc, char *argv[]) {
    struct CPU cpu;

    if(argc != 2) {
        fprintf(stderr, "Usage: %s memory_file\n", argv[0]);
        return 1;
    }

    // initialize our state
    ram = malloc(RAM_SIZE);
    cpu_init0(&cpu);
    cpu_reset(&cpu);

    // setup the stack pointer
    cpu_set_sp(&cpu, RAM_SIZE-4);

    // fetch our memory image and cpu state (if set)
    fillState(argv[1], ram, RAM_SIZE);

    while(true)
    {
      u32 insn;

      guestLoad(cpu_get_pc(&cpu), &insn);
      debug_print("%8.8x: %8.8x\n", cpu_get_pc(&cpu), insn);
      cpu_exec_inst(&cpu);
    }

    return 0;
}
