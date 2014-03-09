#include "bugs.h"

void bug5(void) {
    unsigned int value = 1000;
    
    asm("l.macrc r0; l.maci %0, 0x2; l.maci %0, 0x2; l.macrc %1" : "=r"(value) : "r"(value));
    printf("value = %d\n", value);
    //assert(value == 4000);
}
