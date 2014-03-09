#include "bugs.h"

void bug1(void) {
    unsigned int value; 

    value = 0xff;    
    asm("l.extbs %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xffffffff);

    value = 0x7f;    
    asm("l.extbs %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0x7f);

    value = 0xf0;
    asm("l.extbs %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xfffffff0);

    value = 0xffffffff;
    asm("l.extbz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xff);

    value = 0x7f;    
    asm("l.extbz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0x7f);

    value = 0xf0;
    asm("l.extbz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xf0);


    value = 0xffff;
    asm("l.exths %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xffffffff);

    value = 0x7fff;    
    asm("l.exths %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0x7fff);

    value = 0xf000;
    asm("l.exths %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xfffff000);


    value = 0xffffffff;
    asm("l.exthz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xffff);

    value = 0x7fff;    
    asm("l.exthz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0x7fff);

    value = 0xf000;
    asm("l.exthz %0, %1" : "=r"(value) : "r"(value));
    assert(value == 0xf000);
}
