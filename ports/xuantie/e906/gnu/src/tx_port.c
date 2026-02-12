 /*
 * Copyright (C) 2017-2024 Alibaba Group Holding Limited
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "tx_api.h"
#include "tx_timer.h"
#include "tx_thread.h"
#include "tx_initialize.h"

void thread_switch_ext(void)
{
#ifdef TX_ENABLE_EXECUTION_CHANGE_NOTIFY
    _tx_execution_thread_exit();
#endif

    if(!_tx_thread_execute_ptr) {
        unsigned long mcause;
        __asm__ volatile(
            "csrr %0, mcause\n\t"
            "csrsi mstatus, 0x8"
            : "=r"(mcause)
            :
            : "memory"
        );
        while (!_tx_thread_execute_ptr) {
            __asm__ volatile("wfi");
        }
        __asm__ volatile(
            "csrci mstatus, 0x8\n\t"
            "csrw mcause, %0"
            :
            : "r"(mcause)
            : "memory"
        );
    }
    /* Determine if the time-slice is active.  */
    if (_tx_timer_time_slice && _tx_thread_current_ptr) {
        /* Preserve current remaining time-slice for the thread and clear the current time-slice.  */
        _tx_thread_current_ptr -> tx_thread_time_slice = _tx_timer_time_slice;
        _tx_timer_time_slice =  0;
    }
    _tx_thread_current_ptr = _tx_thread_execute_ptr;
}

VOID _tx_initialize_low_level(VOID)
{
    _tx_initialize_unused_memory = NULL;
    _tx_thread_interrupt_control(0);
}

VOID _tx_thread_exit(VOID)
{
    while (1) {
        __asm__ volatile("wfi");
    }
}

VOID _tx_thread_stack_build(TX_THREAD *thread_ptr, VOID (*function_ptr)(VOID))
{
    int i;
    uint8_t *stk;
    tx_stack_frame_t *frame;

    stk  = thread_ptr -> tx_thread_stack_end;
    stk  = (uint8_t *)(((unsigned long)stk) & (~(unsigned long)(sizeof(ALIGN_TYPE) - 1)));
    stk -= sizeof(tx_stack_frame_t);

    frame = (tx_stack_frame_t *)stk;

    for (i = 0; i < sizeof(tx_stack_frame_t) / sizeof(unsigned long); i++) {
        ((unsigned long*)frame)[i] = 0;
    }

    frame->epc    = (unsigned long)function_ptr;
    frame->ra     = (unsigned long)_tx_thread_exit;
    frame->mstatus = (3UL << 11) | (1UL << 7);  // mstatus.MPP=3, MPIE=1

#if __riscv_flen
    frame->mstatus |= (1UL << 13);              // mstatus.FS=1
    stk -= sizeof(tx_stack_f_frame_t);
    tx_stack_f_frame_t *f_frame = (tx_stack_f_frame_t *)stk;
    f_frame->fcsr = 0;
    for (int i = 0; i < 32; i++) {
        f_frame->f[i] = 0;
    }
#endif

#if __riscv_dsp
    stk -= sizeof(tx_stack_p_frame_t);
    tx_stack_p_frame_t *p_frame = (tx_stack_p_frame_t *)stk;
    p_frame->vxsat = 0;
#endif

    thread_ptr -> tx_thread_stack_ptr = stk;
}

