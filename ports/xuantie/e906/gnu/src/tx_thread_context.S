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
.section .text

    .align 3
    .global tspend_handler
    .type tspend_handler, @function
tspend_handler:
    addi    sp, sp, -(30 * 4)
    sw      x1,  1  * 4(sp)    /* RA */
    sw      x5,  2  * 4(sp)
    sw      x6,  3  * 4(sp)
    sw      x7,  4  * 4(sp)
    sw      x8,  5  * 4(sp)
    sw      x9,  6  * 4(sp)
    sw      x10, 7  * 4(sp)
    sw      x11, 8  * 4(sp)
    sw      x12, 9  * 4(sp)
    sw      x13, 10 * 4(sp)
    sw      x14, 11 * 4(sp)
    sw      x15, 12 * 4(sp)
    sw      x16, 13 * 4(sp)
    sw      x17, 14 * 4(sp)
    sw      x18, 15 * 4(sp)
    sw      x19, 16 * 4(sp)
    sw      x20, 17 * 4(sp)
    sw      x21, 18 * 4(sp)
    sw      x22, 19 * 4(sp)
    sw      x23, 20 * 4(sp)
    sw      x24, 21 * 4(sp)
    sw      x25, 22 * 4(sp)
    sw      x26, 23 * 4(sp)
    sw      x27, 24 * 4(sp)
    sw      x28, 25 * 4(sp)
    sw      x29, 26 * 4(sp)
    sw      x30, 27 * 4(sp)
    sw      x31, 28 * 4(sp)

    csrr    t0, mepc
    sw      t0, 0(sp)

    csrr    t3, mstatus
    sw      t3, 29 * 4(sp)

#if __riscv_flen
    addi    sp, sp, -4
    frcsr   t0
    sw      t0, 0(sp)
#if __riscv_float_abi_single
    addi    sp, sp, -(32 * 4)
    fsw     f0,  0  * 4(sp)
    fsw     f1,  1  * 4(sp)
    fsw     f2,  2  * 4(sp)
    fsw     f3,  3  * 4(sp)
    fsw     f4,  4  * 4(sp)
    fsw     f5,  5  * 4(sp)
    fsw     f6,  6  * 4(sp)
    fsw     f7,  7  * 4(sp)
    fsw     f8,  8  * 4(sp)
    fsw     f9,  9  * 4(sp)
    fsw     f10, 10 * 4(sp)
    fsw     f11, 11 * 4(sp)
    fsw     f12, 12 * 4(sp)
    fsw     f13, 13 * 4(sp)
    fsw     f14, 14 * 4(sp)
    fsw     f15, 15 * 4(sp)
    fsw     f16, 16 * 4(sp)
    fsw     f17, 17 * 4(sp)
    fsw     f18, 18 * 4(sp)
    fsw     f19, 19 * 4(sp)
    fsw     f20, 20 * 4(sp)
    fsw     f21, 21 * 4(sp)
    fsw     f22, 22 * 4(sp)
    fsw     f23, 23 * 4(sp)
    fsw     f24, 24 * 4(sp)
    fsw     f25, 25 * 4(sp)
    fsw     f26, 26 * 4(sp)
    fsw     f27, 27 * 4(sp)
    fsw     f28, 28 * 4(sp)
    fsw     f29, 29 * 4(sp)
    fsw     f30, 30 * 4(sp)
    fsw     f31, 31 * 4(sp)
#elif __riscv_float_abi_double
    addi    sp, sp, -(32 * 8)
    fsw     f0,  0  * 8(sp)
    fsw     f1,  1  * 8(sp)
    fsw     f2,  2  * 8(sp)
    fsw     f3,  3  * 8(sp)
    fsw     f4,  4  * 8(sp)
    fsw     f5,  5  * 8(sp)
    fsw     f6,  6  * 8(sp)
    fsw     f7,  7  * 8(sp)
    fsw     f8,  8  * 8(sp)
    fsw     f9,  9  * 8(sp)
    fsw     f10, 10 * 8(sp)
    fsw     f11, 11 * 8(sp)
    fsw     f12, 12 * 8(sp)
    fsw     f13, 13 * 8(sp)
    fsw     f14, 14 * 8(sp)
    fsw     f15, 15 * 8(sp)
    fsw     f16, 16 * 8(sp)
    fsw     f17, 17 * 8(sp)
    fsw     f18, 18 * 8(sp)
    fsw     f19, 19 * 8(sp)
    fsw     f20, 20 * 8(sp)
    fsw     f21, 21 * 8(sp)
    fsw     f22, 22 * 8(sp)
    fsw     f23, 23 * 8(sp)
    fsw     f24, 24 * 8(sp)
    fsw     f25, 25 * 8(sp)
    fsw     f26, 26 * 8(sp)
    fsw     f27, 27 * 8(sp)
    fsw     f28, 28 * 8(sp)
    fsw     f29, 29 * 8(sp)
    fsw     f30, 30 * 8(sp)
    fsw     f31, 31 * 8(sp)
#endif
#endif /* __riscv_flen */

#if __riscv_dsp
    addi    sp, sp, -4
    csrr    t0, vxsat
    sw      t0, 0(sp)
#endif /*__riscv_dsp */

    /* If _tx_thread_current_ptr is null, no sp need to be saved */
    la      t0, _tx_thread_current_ptr
    lw      t0, 0(t0)
    beqz    t0, _tx_thread_switch
    /* Store sp to task stack to _tx_thread_current_ptr -> tx_thread_stack_ptr */
    sw      sp, 2 * 4(t0)

_tx_thread_switch:
    jal     thread_switch_ext
    /*clear software interrupt*/
    /* Edge-triggered vector interrupts do not require software to clear the pending bit. */

    /* Switch task context to _tx_thread_execute_ptr */
    la      t0, _tx_thread_execute_ptr
    lw      t0, 0(t0)
    lw      sp, 2 * 4(t0)

    /* Pop additional registers */
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

    .size tspend_handler, . - tspend_handler
