/***************************************************************************
 * Copyright (c) 2024 Microsoft Corporation 
 * 
 * This program and the accompanying materials are made available under the
 * terms of the MIT License which is available at
 * https://opensource.org/licenses/MIT.
 * 
 * SPDX-License-Identifier: MIT
 **************************************************************************/


/**************************************************************************/
/**************************************************************************/
/**                                                                       */
/** ThreadX Component                                                     */
/**                                                                       */
/**   Thread                                                              */
/**                                                                       */
/**************************************************************************/
/**************************************************************************/

    .section .text
/**************************************************************************/
/*                                                                        */
/*  FUNCTION                                               RELEASE        */
/*                                                                        */
/*    _tx_thread_schedule                                RISC-V64/GNU     */
/*                                                           6.2.1        */
/*  AUTHOR                                                                */
/*                                                                        */
/*    Scott Larson, Microsoft Corporation                                 */
/*                                                                        */
/*  DESCRIPTION                                                           */
/*                                                                        */
/*    This function waits for a thread control block pointer to appear in */
/*    the _tx_thread_execute_ptr variable.  Once a thread pointer appears */
/*    in the variable, the corresponding thread is resumed.               */
/*                                                                        */
/*  INPUT                                                                 */
/*                                                                        */
/*    None                                                                */
/*                                                                        */
/*  OUTPUT                                                                */
/*                                                                        */
/*    None                                                                */
/*                                                                        */
/*  CALLS                                                                 */
/*                                                                        */
/*    None                                                                */
/*                                                                        */
/*  CALLED BY                                                             */
/*                                                                        */
/*    _tx_initialize_kernel_enter          ThreadX entry function         */
/*    _tx_thread_system_return             Return to system from thread   */
/*    _tx_thread_context_restore           Restore thread's context       */
/*                                                                        */
/*  RELEASE HISTORY                                                       */
/*                                                                        */
/*    DATE              NAME                      DESCRIPTION             */
/*                                                                        */
/*  03-08-2023      Scott Larson            Initial Version 6.2.1         */
/*                                                                        */
/**************************************************************************/
/* VOID   _tx_thread_schedule(VOID)
{  */
    .align 3
    .global  _tx_thread_schedule
    .type _tx_thread_schedule, @function
_tx_thread_schedule:
    /* Enable interrupts.  */
    csrsi   mstatus, 0x08                               // Enable interrupts

    /* Wait for a thread to execute.  */
    /* do
    {  */
    la      t0, _tx_thread_execute_ptr                  // Pickup address of execute ptr
_tx_thread_schedule_loop:
    lw      t1, 0(t0)                                   // Pickup next thread to execute
    beqz    t1, _tx_thread_schedule_loop                // If NULL, wait for thread to execute
    /* }
    while(_tx_thread_execute_ptr == TX_NULL);  */

    /* Yes! We have a thread to execute.  Lockout interrupts and
       transfer control to it.  */
    csrci   mstatus, 0x08                               // Lockout interrupts

    /* Setup the current thread pointer.  */
    /* _tx_thread_current_ptr =  _tx_thread_execute_ptr;  */
    la      t0, _tx_thread_current_ptr                  // Pickup current thread pointer address
    sw      t1, 0(t0)                                   // Set current thread pointer

    /* Increment the run count for this thread.  */
    /* _tx_thread_current_ptr -> tx_thread_run_count++;  */
    lw      t2, 1 * 4(t1)                               // Pickup run count
    lw      t3, 6 * 4(t1)                               // Pickup time slice value
    addi    t2, t2, 1                                   // Increment run count
    sw      t2, 1 * 4(t1)                               // Store new run count

    /* Setup time-slice, if present.  */
    /* _tx_timer_time_slice =  _tx_thread_current_ptr -> tx_thread_time_slice;  */
    la      t2, _tx_timer_time_slice                    // Pickup time-slice variable address

    /* Switch to the thread's stack.  */
    /* SP =  _tx_thread_execute_ptr -> tx_thread_stack_ptr;  */
    lw      sp, 2 * 4(t1)                               // Switch to thread's stack
    sw      t3, 0(t2)                                   // Store new time-slice*/

#if __riscv_dsp
    lw      t0, 0(sp)
    csrw    vxsat, t0
    addi    sp, sp, 4
#endif /*__riscv_dsp */

#if __riscv_flen
#if __riscv_float_abi_single
    flw     f0,  0  * 4(sp)
    flw     f1,  1  * 4(sp)
    flw     f2,  2  * 4(sp)
    flw     f3,  3  * 4(sp)
    flw     f4,  4  * 4(sp)
    flw     f5,  5  * 4(sp)
    flw     f6,  6  * 4(sp)
    flw     f7,  7  * 4(sp)
    flw     f8,  8  * 4(sp)
    flw     f9,  9  * 4(sp)
    flw     f10, 10 * 4(sp)
    flw     f11, 11 * 4(sp)
    flw     f12, 12 * 4(sp)
    flw     f13, 13 * 4(sp)
    flw     f14, 14 * 4(sp)
    flw     f15, 15 * 4(sp)
    flw     f16, 16 * 4(sp)
    flw     f17, 17 * 4(sp)
    flw     f18, 18 * 4(sp)
    flw     f19, 19 * 4(sp)
    flw     f20, 20 * 4(sp)
    flw     f21, 21 * 4(sp)
    flw     f22, 22 * 4(sp)
    flw     f23, 23 * 4(sp)
    flw     f24, 24 * 4(sp)
    flw     f25, 25 * 4(sp)
    flw     f26, 26 * 4(sp)
    flw     f27, 27 * 4(sp)
    flw     f28, 28 * 4(sp)
    flw     f29, 29 * 4(sp)
    flw     f30, 30 * 4(sp)
    flw     f31, 31 * 4(sp)
    addi    sp, sp, (32 * 4)
#elif __riscv_float_abi_double
    flw     f0,  0  * 8(sp)
    flw     f1,  1  * 8(sp)
    flw     f2,  2  * 8(sp)
    flw     f3,  3  * 8(sp)
    flw     f4,  4  * 8(sp)
    flw     f5,  5  * 8(sp)
    flw     f6,  6  * 8(sp)
    flw     f7,  7  * 8(sp)
    flw     f8,  8  * 8(sp)
    flw     f9,  9  * 8(sp)
    flw     f10, 10 * 8(sp)
    flw     f11, 11 * 8(sp)
    flw     f12, 12 * 8(sp)
    flw     f13, 13 * 8(sp)
    flw     f14, 14 * 8(sp)
    flw     f15, 15 * 8(sp)
    flw     f16, 16 * 8(sp)
    flw     f17, 17 * 8(sp)
    flw     f18, 18 * 8(sp)
    flw     f19, 19 * 8(sp)
    flw     f20, 20 * 8(sp)
    flw     f21, 21 * 8(sp)
    flw     f22, 22 * 8(sp)
    flw     f23, 23 * 8(sp)
    flw     f24, 24 * 8(sp)
    flw     f25, 25 * 8(sp)
    flw     f26, 26 * 8(sp)
    flw     f27, 27 * 8(sp)
    flw     f28, 28 * 8(sp)
    flw     f29, 29 * 8(sp)
    flw     f30, 30 * 8(sp)
    flw     f31, 31 * 8(sp)
    addi    sp, sp, (32 * 8)
#endif

    lw      t0, 0(sp)
    fscsr   t0
    addi    sp, sp, 4
#endif /* __riscv_flen */

    /* Pop PC from stack and set MEPC */
    lw      t0,  0 * 4(sp)
    csrw    mepc, t0

    /* Pop mstatus from stack and set it */
    lw      t0,  29 * 4(sp)
    csrw    mstatus, t0

    /* Interrupt still disable here */
    /* Restore Registers from Stack */
    lw      x1,  1  * 4(sp)    /* RA */
    lw      x5,  2  * 4(sp)
    lw      x6,  3  * 4(sp)
    lw      x7,  4  * 4(sp)
    lw      x8,  5  * 4(sp)
    lw      x9,  6  * 4(sp)
    lw      x10, 7  * 4(sp)
    lw      x11, 8  * 4(sp)
    lw      x12, 9  * 4(sp)
    lw      x13, 10 * 4(sp)
    lw      x14, 11 * 4(sp)
    lw      x15, 12 * 4(sp)
    lw      x16, 13 * 4(sp)
    lw      x17, 14 * 4(sp)
    lw      x18, 15 * 4(sp)
    lw      x19, 16 * 4(sp)
    lw      x20, 17 * 4(sp)
    lw      x21, 18 * 4(sp)
    lw      x22, 19 * 4(sp)
    lw      x23, 20 * 4(sp)
    lw      x24, 21 * 4(sp)
    lw      x25, 22 * 4(sp)
    lw      x26, 23 * 4(sp)
    lw      x27, 24 * 4(sp)
    lw      x28, 25 * 4(sp)
    lw      x29, 26 * 4(sp)
    lw      x30, 27 * 4(sp)
    lw      x31, 28 * 4(sp)
    addi    sp, sp, (30 * 4)

    mret

    .size _tx_thread_schedule, . - _tx_thread_schedule

/* }  */
