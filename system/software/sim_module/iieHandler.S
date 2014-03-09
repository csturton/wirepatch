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

#define CPU_PC_OFFSET        4*32
#define CPU_NPC_OFFSET       (CPU_PC_OFFSET+4)
#define CPU_SR_OFFSET        (CPU_NPC_OFFSET+4)
#define	CPU_MACHI_OFFSET     (CPU_SR_OFFSET+4)
#define	CPU_MACLO_OFFSET     (CPU_MACHI_OFFSET+4)
#define	CPU_BRANCH_PC_OFFSET (CPU_MACLO_OFFSET+4)
#define	CPU_ESR_OFFSET       (CPU_BRANCH_PC_OFFSET+4)
#define	CPU_EPCR_OFFSET      (CPU_ESR_OFFSET+4)
#define	CPU_EEAR_OFFSET      (CPU_EPCR_OFFSET+4)
#define	CPU_DSR_OFFSET       (CPU_EEAR_OFFSET+4)
#define	CPU_TTMR_OFFSET      (CPU_DSR_OFFSET+4)
#define	CPU_TTCR_OFFSET      (CPU_TTMR_OFFSET+4)	

/* Backup the state of the system */
#ifdef STANDALONE
  .global _start
_start:
#else
  .global _iieHandler
_iieHandler:	
#endif
	/* Use shadow version of r1 to backup r1, and set change stacks */
	l.mtspr r0, r1, SHADOW_R1_REG
	/* Load the address of the CPU structure */
	.extern cpu
	l.movhi r1, hi(cpu)
	l.ori r1, r1, lo(cpu)
	/* Save the GPRs to the CPU structure */
	l.sw 0(r1), r0
	l.sw 8(r1), r2
	l.sw 12(r1), r3
	l.sw 16(r1), r4
	l.sw 20(r1), r5
	l.sw 24(r1), r6
	l.sw 28(r1), r7
	l.sw 32(r1), r8
	l.sw 36(r1), r9
	l.sw 40(r1), r10
	l.sw 44(r1), r11
	l.sw 48(r1), r12
	l.sw 52(r1), r13
	l.sw 56(r1), r14
	l.sw 60(r1), r15
	l.sw 64(r1), r16
	l.sw 68(r1), r17
	l.sw 72(r1), r18
	l.sw 76(r1), r19
	l.sw 80(r1), r20
	l.sw 84(r1), r21
	l.sw 88(r1), r22
	l.sw 92(r1), r23
	l.sw 96(r1), r24
	l.sw 100(r1), r25
	l.sw 104(r1), r26
	l.sw 108(r1), r27
	l.sw 112(r1), r28
	l.sw 116(r1), r29
	l.sw 120(r1), r30
	l.sw 124(r1), r31
	/* Get the shoadow version of r1 and update cpu struct with it */
	l.add r3, r0, r1
	l.mfspr r1, r0, SHADOW_R1_REG
	l.sw 4(r3), r1
	/* Backup the rest of the system's state */
	l.mfspr r2, r0, SPR_EPCR_BASE /* Program's PC, NPC, and EPCR */
	l.sw CPU_PC_OFFSET(r3), r2
	l.addi r2, r2, 4 /* Calculate program's NPC */
	l.sw CPU_NPC_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_EPCR_SHADOW
	l.sw CPU_EPCR_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_ESR_BASE /* Program's SR and ESR */
	l.sw CPU_SR_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_ESR_SHADOW
	l.sw CPU_ESR_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_EEAR_SHADOW /* Program's EEAR */
	l.sw CPU_EEAR_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_MACHI /* MAC */
	l.sw CPU_MACHI_OFFSET(r3), r2
	l.mfspr r2, r0, SPR_MACLO
	l.sw CPU_MACLO_OFFSET(r3), r2
	/* Back-up DSR and set it so any exception stops all execution */
	l.mfspr r2, r0, SPR_DSR
	l.sw CPU_DSR_OFFSET(r3), r2
	l.addi r2, r0, -1
	l.mtspr r0, r2, SPR_DSR
	/* Init to not being in the branch delay slot */
	l.addi r2, r0, -1
	l.sw CPU_BRANCH_PC_OFFSET(r3), r2
	
/* Turn off the data and instruction caches
	l.mfspr r2, r0, SPR_SR
	l.movhi r1, hi(0xffffffe7)
	l.ori r1, r1, lo(0xffffffe7)
	l.and r2, r1, r2
	l.mtspr r0, r2, SPR_SR*/
/* Change stacks and call the simulator */
	l.movhi r1, hi(0x0f000000)
	l.jal runSim
	l.nop
	
.global _bail
_bail:
/* Restore the state of the system */
	l.movhi r2, hi(cpu)
	l.ori r2, r2, lo(cpu)
	/* Save the GPRs to the CPU structure */
	l.lwz r1, 4(r2)
	l.lwz r4, 16(r2)
	l.lwz r5, 20(r2)
	l.lwz r6, 24(r2)
	l.lwz r7, 28(r2)
	l.lwz r8, 32(r2)
	l.lwz r9, 36(r2)
	l.lwz r10, 40(r2)
	l.lwz r11, 44(r2)
	l.lwz r12, 48(r2)
	l.lwz r13, 52(r2)
	l.lwz r14, 56(r2)
	l.lwz r15, 60(r2)
	l.lwz r16, 64(r2)
	l.lwz r17, 68(r2)
	l.lwz r18, 72(r2)
	l.lwz r19, 76(r2)
	l.lwz r20, 80(r2)
	l.lwz r21, 84(r2)
	l.lwz r22, 88(r2)
	l.lwz r23, 92(r2)
	l.lwz r24, 96(r2)
	l.lwz r25, 100(r2)
	l.lwz r26, 104(r2)
	l.lwz r27, 108(r2)
	l.lwz r28, 112(r2)
	l.lwz r29, 116(r2)
	l.lwz r30, 120(r2)
	l.lwz r31, 124(r2)
	/* Restore the rest of the system's state */
	l.lwz r3, CPU_MACHI_OFFSET(r2)
	l.mtspr r0, r3, SPR_MACHI
	l.lwz r3, CPU_MACLO_OFFSET(r2)
	l.mtspr r0, r3, SPR_MACLO
	/* ESR and EPCR and EEAR */
	l.lwz r3, CPU_ESR_OFFSET(r2)
	l.mtspr r0, r3, SPR_ESR_BASE
	l.lwz r3, CPU_EPCR_OFFSET(r2)
	l.mtspr r0, r3, SPR_EPCR_BASE
	l.lwz r3, CPU_EEAR_OFFSET(r2)
	l.mtspr r0, r3, SPR_EEAR_BASE
	/* Shadow ESR, EPCR, and EEAR become SR, PC
	when l.rfe is execute from this address range */
	l.lwz r3, CPU_SR_OFFSET(r2)
	l.mtspr r0, r3, SPR_ESR_SHADOW
	l.lwz r3, CPU_PC_OFFSET(r2)
	l.mtspr r0, r3, SPR_EPCR_SHADOW
	/* Restore DSR */
	l.lwz r3, CPU_DSR_OFFSET(r2)
	l.mtspr r0, r3, SPR_DSR
	/* Restore r2 and r3 */
	l.lwz r3, 12(r2)
	l.lwz r2, 8(r2)
	/* Return to program */
	l.rfe
	l.nop
