#include "bugs.h"

void bug4(void) {
    unsigned int value; 

    value = 0xff;    
    asm("l.fl1 %0, %1" : "=r"(value) : "r"(value));
    assert(value == 8);

    value = 0x80000000;
    asm("l.fl1 %0, %1" : "=r"(value) : "r"(value));
    assert(value == 32);

    value = 0x0;
    asm("l.fl1 %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0);

    value = 0xffffffff;
    asm("l.fl1 %0, %1" : "=r"(value) : "r"(value));
    assert(value == 32);
}
