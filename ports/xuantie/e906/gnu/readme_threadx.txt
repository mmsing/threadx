                    Eclipse Foundation's RTOS, ThreadX for XuanTie E906

                                  Using the GNU Tools

The XuanTie E906 is a fully synthesizable, middle-end, microcontroller-class processor that is compatible to the RISC-V RV32IMA[F][D]C[P] ISA. It
delivers considerable integer and enhanced, energy-efficient floating-point compute performance especially the double precision.

1. Building the ThreadX run-time Library

Prerequisites
- Install a XuanTie bare-metal GNU toolchain with riscv64-unknown-elf prefix
- Download URL: https://www.xrvm.cn/community/download?versionId=4460156621967921152 
- Toolchain archive name: XuanTie-900-gcc-elf-newlib-x86_64-V3.2.0-20250627.tar.gz

Verify the toolchain:
  riscv64-unknown-elf-gcc --version
  riscv64-unknown-elf-objdump --version

Library build script
  ports/xuantie/e906/gnu/example_build/smartl_fpga/build_libthreadx.sh

Example build script

The example demonstration contains a build script. See:

  ports/xuantie/e906/gnu/example_build/smartl_fpga/build_threadx_sample.sh

This script builds the library and the demo application demo_threadx.elf.


2. Demonstration System (QEMU)

Prerequisites
- Install a XuanTie QEMU
- Download URL: https://www.xrvm.cn/community/download?versionId=4468398114511851520
- QEMU archive name: XuanTie-qemu-x86_64-Ubuntu-20.04-V5.2.8-B20250721-0303.tar.gz

The provided example is targeted at XuanTie QEMU's smartl platform. After building the
example, the produced demo_threadx.elf can be executed in QEMU:

  qemu-system-riscv32 -nographic -machine smartl -cpu e906fdp -kernel demo_threadx.elf

Typical QEMU features used:
- Single-core CPU
- UART serial console
- CLIC (Core-Local Interrupt Controller)

3. System Initialization

Entry Point

The example startup code begins at the Reset_Handler label in startup.S. This startup
code performs hardware initialization including:
- Initialize gp register
- Set up the entry for interrupt and exception handler
- Set up initial stack pointer
- Jump to SystemInit() for initialize CLIC、Clear BSS、Cache、System Clock、System Tick
- Jump to pre_main()

In pre_main(), the following initialization is performed:
Board Initialization (board_init.c)
- Initialize UART

Then jump to main().

4. Register Usage and Stack Frames

The RISC-V32 ABI defines t0-t6 and a0-a7 as caller-saved (temporary) registers.
All other registers used by a function must be preserved by the function.

Stack Layout for Task Frame (with FP double and P-extension enabled):

   Index    Offset    Register    Description
   ─────────────────────────────────────────────────
     0       0x00      mepc       machine exception PC
     1       0x04        ra       return address
     2       0x08        t0       temporary register 0
     3       0x0C        t1       temporary register 1
     4       0x10        t2       temporary register 2
     5       0x14        s0       saved register 0 or frame pointer
     6       0x18        s1       saved register 1
     7       0x1C        a0       argument register 0
     8       0x20        a1       argument register 1
     9       0x24        a2       argument register 2
    10       0x28        a3       argument register 3
    11       0x2C        a4       argument register 4
    12       0x30        a5       argument register 5
    13       0x34        a6       argument register 6
    14       0x38        a7       argument register 7
    15       0x3C        s2       saved register 2
    16       0x40        s3       saved register 3
    17       0x44        s4       saved register 4
    18       0x48        s5       saved register 5
    19       0x4C        s6       saved register 6
    20       0x50        s7       saved register 7
    21       0x54        s8       saved register 8
    22       0x58        s9       saved register 9
    23       0x5C       s10       saved register 10
    24       0x60       s11       saved register 11
    25       0x64        t3       temporary register 3
    26       0x68        t4       temporary register 4
    27       0x6C        t5       temporary register 5
    28       0x70        t6       temporary register 6
    29       0x74   mstatus       machine status register

    30       0x78      fcsr       FP control/status register
    31       0x7C       ft0       FP temporary register 0
    32       0x84       ft1       FP temporary register 1
    33       0x8C       ft2       FP temporary register 2
    34       0x94       ft3       FP temporary register 3
    35       0x9C       ft4       FP temporary register 4
    36       0xA4       ft5       FP temporary register 5
    37       0xAC       ft6       FP temporary register 6
    38       0xB4       ft7       FP temporary register 7
    39       0xBC       fs0       FP saved register 0
    40       0xC4       fs1       FP saved register 1
    41       0xCC       fa0       FP argument register 0
    42       0xD4       fa1       FP argument register 1
    43       0xDC       fa2       FP argument register 2
    44       0xE4       fa3       FP argument register 3
    45       0xEC       fa4       FP argument register 4
    46       0xF4       fa5       FP argument register 5
    47       0xFC       fa6       FP argument register 6
    48       0x104      fa7       FP argument register 7
    49       0x10C      fs2       FP saved register 2
    50       0x114      fs3       FP saved register 3
    51       0x11C      fs4       FP saved register 4
    52       0x124      fs5       FP saved register 5
    53       0x12C      fs6       FP saved register 6
    54       0x134      fs7       FP saved register 7
    55       0x13C      fs8       FP saved register 8
    56       0x144      fs9       FP saved register 9
    57       0x14C     fs10       FP saved register 10
    58       0x154     fs11       FP saved register 11
    59       0x15C      ft8       FP temporary register 8
    60       0x164      ft9       FP temporary register 9
    61       0x16C     ft10       FP temporary register 10
    62       0x174     ft11       FP temporary register 11

    63       0x17C    vxsat       fixed-point saturation flag register
   ─────────────────────────────────────────────────


5. Interrupt Handling

Machine Mode Operation

ThreadX operates in machine mode (M-mode), the highest privilege level.
All interrupts and exceptions trap to machine mode.

Interrupt Sources

1. Machine Timer Interrupt (MTI):
   - Triggered by CLINT when mtime >= mtimecmp
   - Handled by _tx_timer_interrupt (src/tx_timer_interrupt.c)
   - Called from tick_irq_handler() in example_build/smartl_fpga/components/chip_riscv_dummy/src/sys/tick.c

2. External Interrupts (MEI):
   - Routed through CLIC
   - Handled by do_irq() in example_build/smartl_fpga/components/chip_riscv_dummy/src/sys/irq.c

3. Software Interrupts (MSI):
   - Routed through CLIC
   - Handled by tspend_handler() in src/tx_thread_context.S

Interrupt Control Macros

TX_DISABLE and TX_RESTORE macros atomically manage the MIE bit in mstatus:

  TX_DISABLE:  Saves and clears MIE bit via csrrci (CSR read-clear immediate)
  TX_RESTORE:  Restores only MIE bit via csrrs (CSR read-set)
               Other mstatus bits remain unchanged

These are defined in ports/xuantie/e906/gnu/inc/tx_port.h and use the
_tx_thread_interrupt_control() function.


6. Thread Scheduling and Context Switching

Fist Thread Switch (src/tx_thread_schedule.S)
1. Enables interrupts while waiting a thread
2. Spins until _tx_thread_execute_ptr becomes non-NULL
3. Disables interrupts (critical section)
4. Sets _tx_thread_current_ptr = _tx_thread_execute_ptr
5. Increments thread's run count
6. Switches to thread's stack
7. Restores the thread's context, then returns via mret

Thread Scheduler (src/tx_thread_system_return.S, src/tx_thread_context.S)
1. Set a software interrupt to trigger context switch
2. Come to software interrupt handler (tspend_handler)
3. Save previous thread's context
4. Check and waiting for _tx_thread_execute_ptr != NULL
5. Switch thread sp to _tx_thread_execute_ptr
6. Restores the thread's context, then returns via mret

Initial Thread Stack Frame (src/tx_thread_stack_build.S)

New threads start with a fake interrupt frame containing:
- All registers initialized to 0
- ra (x1) = _tx_thread_exit
- mepc = entry function pointer
- mstatus = mstatus.FS=1 | mstatus.MPP=3 | mstatus.MPIE=1
- Floating-point registers initialized based on ABI


7. Port Configuration and Macros

Default Configurations (in ports/risc-v64/gnu/inc/tx_port.h):

  TX_MINIMUM_STACK                1024    /* Minimum thread stack size */
  TX_TIMER_THREAD_STACK_SIZE      1024    /* Timer thread stack size */
  TX_TIMER_THREAD_PRIORITY        0       /* Timer thread priority */
  TX_MAX_PRIORITIES               32      /* Must be multiple of 32 */

These can be overridden in tx_user.h or on the compiler command line.


8. Build Configuration

CMake Toolchain File: example_build/smartl_fpga/xuantie_e906_gnu.cmake

Compiler Flags:
  -mcpu=e906fdp          RISC-V RV32IMA[F][D]C[P]
  -mcmodel=medlow        ±2GB addressability
  -D__ASSEMBLER__        For assembly files


9. File Organization

Port-specific files (ports/risc-v64/gnu/):

Core assembly files (src/):
  - tx_port.c                     Initial setup and system state, Build initial stack frame for new thread
  - tx_thread_context.S           Thread context switch by software interrupt
  - tx_thread_schedule.S          Fist Thread scheduler
  - tx_thread_system_return.S     Trigger a software interrupt for voluntary yield
  - tx_thread_interrupt_control.S Interrupt enable/disable control
  - tx_timer_interrupt.S          Timer interrupt handler

Header file (inc/):
  - tx_port.h                     Port-specific defines and macros

Example files (example_build/smartl_fpga/):
  - components/chip_riscv_dummy/src/arch/e906fdp        Startup code, Interrupt handlers
  - components/chip_riscv_dummy/src/drivers             The basic peripheral drivers for the platform
  - components/chip_riscv_dummy/src/sys                 System initialization
  - components/chip_riscv_dummy/gcc_flash_smartl.ld     Linker script for QEMU smartl
  - components/csi                                      CPU core and peripheral API
  - components/libc_threadx                             Minimum printf and malloc implementation
  - boards/board_riscv_dummy/src                        Bsp initialization
  - pre_main.c                                          Call main function
  - tx_user.h                                           ThreadX user defines
  - build_libthreadx.sh                                 Build script


10. Linker Script Requirements

The linker script must provide:

1. Entry point:
   ENTRY(Reset_Handler)

2. Memory layout:
   - .text section (code)
   - .rodata section (read-only data)
   - .data section (initialized data)
   - .bss section (uninitialized data)

3. Symbols:
   - __data_start__, __data_end__: For data copy from Flash when executed in DRAM
   - __bss_start__, __bss_end__: For zero initialization
   - __heap_start, __heap_end: For ThreadX allocation memory

4. Alignment:
   - 4-byte alignment throughout

11. Performance and Debugging

Performance Optimization

Build optimizations:
- Use -O2 or -O3 for production (example uses -O0 for debugging)
- Enable -Wl,--gc-sections to remove unused code
- Define TX_DISABLE_ERROR_CHECKING to remove parameter checks
- Consider -flto for link-time optimization

Debugging with QEMU and GDB

Start QEMU in debug mode:
  qemu-system-riscv32 -nographic -machine smartl -cpu e906fdp -kernel demo_threadx.elf -s -S

  -s: Enable GDB server on TCP port 1234
  -S: Pause at startup waiting for GDB

Connect GDB:
  riscv64-unknown-elf-gdb demo_threadx.elf
  (gdb) target remote :1234
  (gdb) break main
  (gdb) continue

Useful GDB commands:
  (gdb) info registers              # View general registers
  (gdb) info all-registers          # Include CSR and FP registers
  (gdb) p/x $mstatus                # View machine status register
  (gdb) x/32gx $sp                  # Examine stack memory
  (gdb) p *_tx_thread_current_ptr   # View current thread control block


12. Platform-Specific Notes (QEMU smartl)
See https://www.xrvm.com/soft-tools/tools/QEMU

Timer frequency is platform-dependent (example uses 100MHz).


13. Revision History

For generic code revision information, refer to ports/risc-v64/gnu/readme_threadx.txt.

The following details the revision history for this xuantie/e906 GNU port:

12-02-2026  Steven Lin             Support XuanTie E906

01-26-2026  Akif Ejaz              Comprehensive rewrite with accurate
                                   technical details matching implementation,
                                   register naming per RISC-V ABI, and
                                   complete interrupt flow documentation

03-08-2023  Scott Larson           Initial Version 6.2.1


Copyright (c) 1996-2026 Microsoft Corporation

https://azure.com/rtos
