/*
 * University of Illinois/NCSA
 * Open Source License
 *
 *  Copyright (c) 2007-2011,The Board of Trustees of the University of
 *  Illinois.  All rights reserved.
 *
 *  Copyright (c) 2011 Matthew Hicks
 *
 *  Developed by:
 *
 *  Graduate Student Matthew Hicks in the Department of Computer Science
 *  The University of Illinois at Urbana-Champaign
 *      http://www.firefalcon.com
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
 *
 * Header file that defines how exceptions are to be handled in the
 * simulator tests
*/

#include "spr_defs.h"
#define STACK_TOP 0x08000000
	
#define printString(args...) \
	.irp char,args		;\
	  l.addi r3, r0, \char 	;\
	  l.nop NOP_CHAR 	;\
	.endr			;\
	l.addi r3, r0, 0xD	;\
	l.nop NOP_CHAR		;\
	l.addi r3, r0, 0xA	;\
	l.nop NOP_CHAR
	
	.macro clearRegs start=1, end=31
	  /* Special set for stack pointer */
	  .ifeq \start-1
	    l.movhi r\start, hi(STACK_TOP)
	    l.ori r\start, r\start, lo(STACK_TOP)
	  .else
	    l.movhi r\start\(), 0
	  .endif
	  .if \end-\start
	    clearRegs "(\start+1)", \end
	  .endif
	.endm

	.section .vectors, "ax"

/* ---[ 0x000: DEATH LOOP ]---------------------------------------------- */
/* Place where bad executions go to die */
	.org 0x000
	/* Load exit failure code */
	.global _death_loop
_death_loop:
	l.addi r3, r0, NOP_EXIT_FAILURE
	l.nop NOP_EXIT
	l.j _death_loop
	l.nop
	
/* ---[ 0x100: RESET exception ]----------------------------------------- */
        .org 0x100
_reset:
.global _start
_start:	
	/* Reset supervisor register */
	l.ori r1, r0, SPR_SR_SM
	l.mtspr r0, r1, SPR_SR

	/* Clear timer  */
	l.mtspr r0, r0, SPR_TTMR

	/* Clear all registers */
	//clearRegs 0,1

	l.ori r1, r0, 0x3000

	/* Jump to program initialisation code */
	l.movhi r9, hi(_main)
	l.ori r9, r9, lo(_main)
	l.jr    r9
	l.nop

/* ---[ 0x200: BUS ERROR exception ]------------------------------------- */
/* Print out bus error using l.nop's and die */
	.org 0x200
	printString('B','U','S',' ','E','R','R','O','R')	
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x300: Data Page Fault exception ]------------------------------------- */
/* Print out data page fault using l.nop's and die */
	.org 0x300
	printString('D','A','T','A',' ','P','A','G','E',' ','F','A','U','L','T')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x400: Data Page Fault exception ]------------------------------------- */
/* Print out instruction page fault using l.nop's and die */
	.org 0x400
	printString('I','N','S','T','R','U','C','T','I','O','N',' ','P','A','G','E',' ','F','A','U','L','T')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x500: Tick Timer exception ]------------------------------------- */
/* Print out Tick Timer using l.nop's and die */
	.org 0x500
	printString('T','I','C','K',' ','T','I','M','E','R')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x600: Alignment exception ]------------------------------------- */
/* Print out Alignment using l.nop's and die */
	.org 0x600
	printString('A','L','I','G','N','M','E','N','T')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x700: Illegal Instruction exception ]------------------------------------- */
/* Print out illegal instruction using l.nop's and die */
	.org 0x700
	printString('I','L','L','E','G','A','L',' ','I','N','S','T','R','U','C','T','I','O','N')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x800: External Interrupt exception ]------------------------------------- */
/* Print out external interrupt using l.nop's and die */
	.org 0x800
	printString('E','X','T','E','R','N','A','L',' ','I','N','T','E','R','R','U','P','T')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0x900: Data TLB Miss exception ]------------------------------------- */
/* Print out data TLB miss using l.nop's and die */
	.org 0x900
	printString('D','A','T','A',' ','T','L','B',' ','M','I','S','S')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0xA00: Instruction TLB Miss exception ]------------------------------------- */
/* Print out instruction TLB miss using l.nop's and die */
	.org 0xA00
	printString('I','N','S','T','R','U','C','T','I','O','N',' ','T','L','B',' ','M','I','S','S')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0xB00: Range exception ]------------------------------------- */
/* Print out range using l.nop's and die */
	.org 0xB00
	printString('R','A','N','G','E')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0xC00: System Call exception ]------------------------------------- */
/* Print out system call using l.nop's and die */
	.org 0xC00
	l.sw 0x0(r1), r3
	printString('S','Y','S','T','E','M',' ','C','A','L','L')
	l.lwz r3, 0x0(r1)
	l.rfe

/* ---[ 0xD00: Floating Point exception ]------------------------------------- */
/* Print out floating point using l.nop's and die */
	.org 0xD00
	printString('F','L','O','A','T','I','N','G',' ','P','O','I','N','T')
	/* Die in death loop */
	l.j _death_loop
	l.nop

/* ---[ 0xE00: Trap exception ]------------------------------------- */
/* Print out trap using l.nop's and die */
	.org 0xE00
	/* Backup temo regs */
	l.sw 0(r1), r3
	l.sw 4(r1), r4

	printString('T','R','A','P')

	/* Rewrite instruction to l.nop */
	/* If trap in delay slot, we need to write over epcr+4 */
	l.mfspr r3, r0, SPR_SR
	l.movhi r4, hi(SPR_SR_DSX)
	l.ori r4, r4, lo(SPR_SR_DSX)
	l.and r3, r3, r4
	l.sfne r3, r0	#Flag set if trap occured in delay slot
	l.movhi r4, hi(0x15000000) #Create l.nop in R4
	l.bnf _except_not_in_delay
	l.mfspr r3, r0, SPR_EPCR_BASE #Move the value of EPCR into R3
	l.addi r3, r3, 4	 #Adjust instruction after branch
_except_not_in_delay:
	l.sw 0(r3), r4 #Store the nop instruction at the address
	/* Restore trampled regs */
	l.lwz r3, 0(r1)
	l.lwz r4, 4(r1)
	l.rfe
