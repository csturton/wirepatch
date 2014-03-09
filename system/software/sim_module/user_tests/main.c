#include <stdio.h>
#include <unistd.h>
#include <assert.h>

#include "bugs.h"

int main(void) {
    unsigned int ret;

    bug1();
    /*
    ret = bug3();
    assert(ret);
    */
    bug4();
    bug5();

    return 0;
}
