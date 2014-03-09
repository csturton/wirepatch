#ifndef _BUGS_H__
#define _BUGS_H__

#include <assert.h>

// some defines from the linux kernel
#define MAX_SPRS_PER_GRP_BITS (11)
#define SPRGROUP_SYS    (0<< MAX_SPRS_PER_GRP_BITS)
#define SPR_SR          (SPRGROUP_SYS + 17)
#define SPR_SR_CY          0x00000400  /* Carry flag */

static inline unsigned long mfspr(unsigned long add)
{
    unsigned int ret;
    __asm__ __volatile__("l.mfspr %0, r0, %1" : "=r" (ret) : "K" (add));
    return ret;
}

#endif
