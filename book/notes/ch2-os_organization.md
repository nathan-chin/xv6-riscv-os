# Chapter 2 - Operating System Organization

Operating systems must be able to support several activities at once. OS's
_time-share_ computer resources among processes. They must ensure all processes
make progress, stay _isolated_ from each other, and allow for interaction (like
through pipelines). **Thus, OS's fulfill three requirements: multiplexing,
isolation, and interaction.**

This chapter focuses on mainstream designs centered around a _monolithic
kernel_, which is used by many Unix operating systems. It also goes over xv6
processes and the creation of the first process when xv6 starts running.

Xv6 runs on a multi-core RISC-V microprocessor, and most of the low-level
functionality (e.g. process implementation) is specific to RISC-V. RISC-V is a
64-bit CPU, and xv6 is written in "LP64" C (Long Pointers in the C programming
language are 64 bits, but int is 32-bit). A useful reference for RISC-V is "The
RISC-V Reader: An Open Architecture Atlas."

A CPU (or processor, core, or hart) is a hardware element that executes a
computation. Xv6 expects _mulit-core_ RISC-V hardware, or multiple CPUs that
share memory but execute independent programs in parallel. _Multiprocessors_ are
often used as synonyms for multi-core, but these are computer boards with
several distinct processor chips.

The CPU is a complete computer surrounded by support hardware, usually in the
form of I/O interfaces. Xv6 is written for support hardware simulated by qemu's
"-machine virt" option, including RAM, a ROM containing boot code, a serial
connection to the user's keyboard/screen, and a disk for storage.

## 2.1 Abstracting Physical Resources
Cooperative time-sharing may be okay if all applications trust each other and
have no bugs, but it's more typical for applications to not trust each other and
to have bugs, so we want more isolation.

To accomplish this, it's helpful to forbid applications from directly accessing
sensitive hardware resources, and instead abstract resources into services. Unix
transparently switches hardware CPUs among processes, saving and restoring
register state as necessary so that applications don't have to be aware of time
sharing.

Many forms of interaction among Unix processors occur via file descriptors. They
abstract details and simplify interaction.

## 2.2 User Mode, Supervisor Mode, and System Calls
To achieve strong isolation, the OS must arrange that applications cannot modify
or read the OS's data structures and instructions, or other processes' memory.

**RISC-V has three modes in which the CPU can execute instructions: machine mode,
supervisor mode, and user mode.** Machine mode is how the CPU starts and is mostly
intended for configuring a computer. Executed instructions have full privilege in it.

In supervisor mode, the CPU can execute _privileged instructions_ (e.g.
enabling/disabling interrupts, reading/writing to register that holds address of
page table, etc.). User programs execute these by switching first to supervisor
mode. Applications executing user-mode instructions run in _user space_ and
software in supervisor mode (i.e. the _kernel_) run in _kernel space_.

CPUs provide a special instruction that switches from user mode to supervisor
mode to enter kernel function (RISC-V uses _ecall_ for this). The kernel then
validates the arguments of the system call, decides if the requested operation
should be alllowed by the application, and then deny/execute it. The kernel
control entry point is determined by supervisor mode.

## 2.3 Kernel Organization
The _monolithic kernel_ is the idea that the entire OS runs in supervisor mode.
In this organization, the entire OS runs with full hardware privilege, which
provides convenience. A downside of the monolithic organization is the
complexity of the OS. A mistake can be costly and require a restart.

To reduce the risk of mistakes, OS can minimize the amount of OS code in
supervisor mode and execute most of the OS in user mode (_microkernel_
organization).

In a microkernel, the kernel interface has a few low-level functions for
different purposes, allowing the kernel to be relatively simple, since most of
the OS resides in user-level _servers_, or OS services running as processes.

Xv6 is implemented as a monolithic kernel as most Unix OS's. The xv6 kernel
interface corresponds to the OS interface, and the kernel implements the
complete OS. Since xv6 doesn't provide many services, its kernel is smaller
than some microkernels.

## 2..4 Code: Xv6 Organization
The xv6 kernel source is the `/kernel` sub-directory. The interface for each
module is defined in `defs.h`.

## 2.5 Process Overview
The process abstraction prevents one process from reading/writing another
process's memory, CPU, file descriptors, etc. It also prevents access to the
kernel itself. **The mechanisms used by the kernel to implement processes
include the user/supervisor mode flag, address spaces, and time-slicing of
threads.**

To enforce isolation, the process abstraction provides the illusion that a
program has its own private machine. It provides a private memory system, or
_address space_, which cannot be read/written to by other processes. It also
provides a supposed personal CPU to execute instructions.

Xv6 uses page tables (implemented by hardware) to give processes their own
address space. The RISC-V page table translates/maps a _virtual address_
(address manipulated) to a _physical address_ (address that CPU chip sends to
main memory).

---
Layout of a virtual address space of a user process
MAXVA-> Trampoline
        Trapframe
        Heap
        User  stack
0 ->    User text and data
---

Xv6 has a separate page table for each process that defines the process's
address space. A process's _user memory_ starts at virtual address 0.
Instructions come first, followed by global variables, then the stack, finally
a "heap" area (for malloc) that processes can expand as needed. Xv6 runs on
RISC-V with 39 bits for virtual addresses, but only uses 38 bits. The maximum
address is 2^38 - 1 = 0x3fffffffff (or `MAXVA`). The top of the addressspace
reserves a page for a _trampoline_ and a page mapping the process's _trapframe_
to switch to the kernel.

The xv6 kernel maintains many pieces of state for each process, which it gathers
in `struct proc`. The most important pieces of kernel state are its page table,
its kernel stack, and its run state.

Each process has a  _thread_ that executes the process's instructions. A thread
can be suspended and later resumed. To switch transparently between processes,
the kernel suspends the current thread and resumes a different thread. Much of
the state of a thread (local variables, function call return addresses) is
stored on the thread's stacks. Each process has a user stack and a kernel stack.
When executing user instructions, the user stack is in use and the kernel stack
is empty. When entering the kernel, the kernel stack is used (user stack still
maintained but not used). The kernel stack is separate and protected from user
code, so the kernel can execute even if user stack is destroyed.

A process makes a system call by executing RISC-V `ecall` instruction. It raises
the hardware privilege level, changes the PC to a kernel-defined entry point,
swithces to kernel stack, and executes. At completion, stack switches to user by
calling `sret` instruction, which lowers HW privilege and resumes user
instructions. A thread can "block" in the kernel to wait for I/O and then resume
afterwards.

`p->state` indicates whether process is allocated, ready to run, running,
waiting for I/O, or exiting.

`p-> pagetable` holds the process's page table, in the format that the RISC-V HW
expects. A process's page table also serves as the record of the addresses of
the physical pages allocated to store the process's memory.

## 2.6 Code: Starting Xv6 and the First Process
When a RISC-V computer powers on, it initializes itself and runs a boot loader
which is stored in read-only memory. The boot loader loads the xv6 kernel into
memory. Then, in machine mode, the CPU executes xv6 starting at `_entry`. Xv6
starts with RISC-V paging hardware disabled: virtual addresses map directly to
physical addresses.

The loader loads the kernel into memory at PA 0x80000000 because address range
0x0 : 0x80000000 contains I/O devices. The instructions at `_entry` set up a
stack so xv6 can run C code. Space is declared for an initial stack, `stack0`,
in `start.c`, then loads the stack pointer register `sp` with the address
`stack0+4096` because the stack grows down. Now with a stack, call C code at
`start`.

The function `start` performs machine mode configurations, then switches to
supervisor with instruction `mret` (usually used to return from supervisor to
machine). `start` sets previous privilege mode to supervisor in register
`mstatus`, sets return address to `main` by writing `main`'s address into
register `mepc`, disables virtual address translation in supervisor mode by
writing 0 into page-table register `satp`, then delegates all interrupts and
exceptions to supervisor mode. Before jumping to supervisor mode, `start` also
programs the clock chip to generate timer interrupts.

After `main` initializes several devices and subsystems, it creates the first
process by calling `userinit`, which executes a small program (`initcode.S`) to
re-enter the kernel by invoking `exec`. `exec` replaces the memory and registers
of the current process with a new program. Afterwards, it returns to user space
and runs `/init`, which creates a new console device file (if needed) and opens
it as fds 0, 1, and 2. Then it loops, starting a console shell, handles orphaned
zombies until shell exits, and repeats.

## 2.7 Real World
Many Unix kernel are monolithic. Linux has a monolithic kernel, but some OS
functions run as user-level servers (i.e. windowing system). Kernels like L4,
Minix, and QNX are microkernels with servers.

Modern OS's support several threads within a process, to allow a single process
to exploit multiple CPUs. Xv6 doesn't have the machinery (potential interface
changes like Linux's `clone` to control which parts a process threads share) to
support this. 

