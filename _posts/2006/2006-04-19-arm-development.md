---
layout: default
title: ARM Development
tags: arm c c++
comments: true
---
# ARM Development

This post contains some notes on ARM development resulting from participating in a 3-day training course in Austin, Texas.

## ARM Architecture

### About ARM

- Founded in 1990, has about 1000 employees

- ARM licenses RISC processor cores and other IP

- ARM does not fabricate processors

- Provides support to partners and third-parties

- Sells development software, boards, debugging hardware, etc

### ARM based SoC

- System on Chip

- Is composed of

  - A deeply embedded processor core debuggable externally using JTAG

  - Internal and external memory

  - Interrupt controller (core supports two interrupts)

  - Advanced microcontroller bus architecture (AMBA)

  - Other peripherals

### Processor terminology -- with cache

- MPU

  - Memory Protection Unit

  - Controls memory access permissions

  - Controls cacheable and bufferable attributes

- MMU

  - Memory Management Unit

  - All features of an MPU

  - Virtual to physical address translation

- Cache

- TCM -- Tightly coupled memory

- Write buffer

### ARM architecture evolution

- 4

  - Initial version

  - 4T -- Thumb instruction set

  - ARM7TDMI and ARM9TDMI families

- 5TE

  - Improved ARM / Thumb interworking, CLZ instruction, Saturated arithmetic, DSP multiply-accumulate instructions...

  - ARM9E and ARM10E families

  - 5TEJ -- Jazelle (java byte code execution)

- 6

  - SIMD instructions, multi-processing, unaligned data support...

  - 6T2 -- Thumb-2 instruction set

  - 6Z -- TrustZone extensions

  - ARM11 family

- Same architecture can have different implementations

  - Von Neuman core -- 3 stage pipeline with single instruction and data bus

  - Harvard core -- 5 stage pipeline with separate instruction and data busses

### Data size and instruction sets

- ARM is a RISC architecture

  - One cycle per instruction

  - Pipelining to run several instructions per cycle

  - Large number of registers to reduce interactions with memory

- 32 bit load / store architecture

  - Instructions and data

- Memory sizes

  - Byte (always 8-bit)

  - Halfword -- 16-bits (two bytes)

  - Word -- 32-bits (four bytes)

  - Doubleword -- 64-bits (eight bytes)

- Two instruction sets

  - 32-bit ARM

  - 16-bit Thumb

### Registers and processor modes

- 37 registers, each 32-bits long

- Privileged modes

  - Supervisor (SVC)

    - R13 (sp), R14 (lr), spsr accessible

  - High-priority interrupt (FIQ)

    - R8, R9, R10, R11, R12, R13 (sp), R14 (lr), spsr accessible

  - Normal interrupt (IRQ)

    - R13 (sp), R14 (lr), spsr accessible

  - Abort

    - R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13 (sp), R14 (lr), R15 (pc), spsr accessible

    - Undef

      - R13 (sp), R14 (lr), spsr accessible

    - System

      - R13 (sp) and R14 (lr) accessible

- Unprivileged mode

  - User

    - R13 (sp) and R14 (lr) accessible

### Program status register (PSR)

- Condition code flags \[31:28\]

  - N \[31\] -- Negative result from ALU

  - Z \[30\] -- Zero result from ALU

  - C \[29\] -- ALU operation carried over

  - V \[28\] -- ALU operation overflowed

- Sticky overflow flag -- Q flag \[27\]

  - 5TE and later

  - Indicates if saturation has occurred

- J bit \[24\]

  - 5TEJ and later

  - 1 indicates processor in Jazelle state

- Interrupt disable bits

  - I \[7\] = 1 disables IRQ

  - F \[6\] = 1 disables FIQ

- T Bit \[5\]

  - T = 0 means processor in ARM state

  - T = 1 means Thumb state

  - Introduced in 4T

- Mode bits \[4:0\]

  - Specify processor mode

- New bits in V6

  - **GE\[3:0\]** (register bits \[19:16\]) used by some SIMD instructions

  - **E** bit \[9\] controls load / store endianness

  - **A** bit \[8\] disables imprecise data aborts

  - **IT** \[15:10\] IF THEN conditional execution of Thumb2 instruction groups

### Program counter (PC)

- ARM state

  - All instructions 32 bits wide

  - All instructions word aligned

  - PC value is stored in bits \[31:2\] with bits \[1:0\] undefined

- Thumb state

  - All instructions 16 bits

  - All instructions must be halfword aligned

  - PC value is stored in bits \[31:1\] with bit \[0\] undefined

### Data alignment

- Prior to architecture v6 data accesses must be properly aligned or else unexpected results will be produced

  - Byte access should be byte aligned

  - Halfword access should be halfword aligned

  - Word access should be word aligned

- Invalid data accesses can be used to produce an Abort exception using external logic or MMU

  - [Instruction fetches]{.ul} may appear unaligned, be careful

- Unaligned data can be accessed using multiple aligned accesses combined with shifting and masking

- Architecture v6 adds hardware support for unaligned access

### Endianness

- Endianness determines how the contents of registers are recovered from memory

  - ARM registers are word width

  - ARM addresses memory as a sequence of bytes

- ARM processors are little-endian but can be configured to access big-endian memory systems

  - Little-Endian implies that the least significant bit (LSB) is at the lowest address

  - Three models of endianness are supported

    - Little-Endian (LE)

    - Word invariant Big-Endian (BE-32)

    - Byte invariant Big-Endian (BE-8 -- [introduced in v6]{.ul})

### Exception handling

- When an exception occurs the core

  - Copies CPSR into SPSR\_\<mode\>

  - Sets appropriate CPSR bits

    - Change to ARM state

    - Change to exception mode

    - Disable interrupts (if appropriate)

  - Store the return address in LR\_\<mode\>

  - Sets PC to vector address

- To return the exception handler, needs to

  - Restore CPSR from SPSR\_\<mode\>

  - Restore PC from LR\_\<mode\>

  - Can only be done in ARM state

### Vector table or jump table

0x1C -- FIQ

0x18 -- IRQ

0x14 -- Reserved

0x10 -- Abort

0x0C -- Prefetch abort

0x08 -- Software interrupt

0x04 -- Undefined instruction

0x00 -- Reset

### ARM instruction set

- All instructions 32 bits long

- Most execute in a single cycle

- Load / store architecture

- Has conditionally executed instructions

- Some day Thumb-2 may replace ARM instruction set

### Example data processing instructions

```text
SUB r0, r1, #5
```

- r0 = r1 - 5

```text
ADD r2, r3, r3, LSL #2
```

- r2 = r3 + (r3 * 4)

```text
ANDS r4, r4, #0x20
```

- r4 = r4 AND 0x20 (set flags)

```text
ADDEQ r5, r5, r6
```

- IF EQ condition true r5 = r5 + r6

### Example branching instruction

```text
B <label>
```

- Branches forward or backwards relative to PC (+/- 32MB range)

### Example memory access instructions

```text
LDR r0, [r1]
```

- Load word at address in r1 to r0

```text
STRNEB r2, [r3, r4]
```

- IF NE condition true, store bottom byte of r2 to address r3 + r4

```text
STMFD sp!, {r4 - r8, lr}
```

- Store registers r4 to r8 and lr on stack, then update stack pointer.

### Thumb instruction set

- 16-bit instruction set

  - Optimized for code density from C code

  - Improved performance from narrow memory

  - Subset of the functionality of the ARM instruction set

- For most Thumb instructions

  - Flags are always set and conditional execution is not used

  - Source and destination registers identical

  - Only low registers used (R0 to R7)

  - Constants are of limited size (8 bits)

  - Inline barrel shifter not used

- Switch between ARM and Thumb state using BX instruction

- Thumb is not a regular instruction set and is targeted at compiler generation, not hand-coding

  - Thumb-2 can be hand-coded

### ARM7TDMI processor core

- v4T architecture

- Von Neumann architecture with shared instruction and data bus

- 3 stage pipeline

  - Optimal pipeline executes each instruction in three cycles (fetch, decode, execute) but the effective cycle per instruction (CPI) is one

  - Read or write to memory can stall the pipeline

  - Branching breaks the pipeline

  - PC always points to the instruction being fetched

  - Average CPI is approximately 1.9

- ARM720T is an ARM7TDMI with cache, MMU and write buffer

### ARM9TDMI

- v4T architecture

- 5 stage pipeline

  - Fetch, Decode, Execute, Memory, Write

  - Average CPI is 1.5

  - Improved maximum clock frequency

  - Memory load instruction can cause interlock if immediately followed by an instruction that uses the loaded data

- Harvard architecture

  - Simultaneous access to instruction and data memory possible

- Normally supplied with caches

- ARM9E processor cores are derived from ARM9TDMI and have support v5TE architecture

### Other families

- ARM10E

  - v5TE architecture

  - CPI of approximately 1.3

  - 6 stage pipeline

  - Static branch prediction

- ARM11

  - ARM v6 architecture

  - 8 stage pipeline

  - Static and dynamic branch prediction and Return stack

- Intel XScale

  - Intel implementation of ARM v5TE architecture

  - 7 to 8 stage pipeline

  - Data and instruction caches

## Development Tools

### RVDS

- Compilation tools

  - ISO C/C++ compiler (armcc)

  - ABI compliant

  - Allows binary compatibility between tool chains

  - Linker feedback mechanism to inform compiler of unused functions which can be eliminated in subsequent builds

  - ARM / Thumb assembler (armasm)

  - Linker (armlink)

  - Format converter (fromelf)

  - Librarian (armar)

  - C and C++ libraries

- CodeWarrior IDE

- RVD debugger and legacy AXD debugger

- Instruction set simulators (RVISS, ADS ARMulator)

- Previous tools suite (ADS)

### Compiler optimization options

- Optimization levels

  - -O0 -- Best debug view, restricted optimization

  - -O1 -- Most optimizations, good debug view

  - -O2 -- Full optimization (the default), limited debug view

  - -O3 -- Higher optimization (added in RVCT 2.1)

- -Otime OR -Ospace

  - Optimize for reduced space or execution time

- Specify processor

  - Using architecture number, e.g. \-\-cpu 5TE

  - Specific processor, e.g. \-\-cpu ARM7TDMI

  - To see a list of options try armcc \-\-cpu list

- Interleaved C and Assembler listing

  - With -S -fs OR \-\-asm \-\-interleave

### ATPCS

- ARM Thumb procedure call standards

  - Useful for mixing C / C++ and assembly

- Register usage

  - Arguments to function, return values, corruptible: r0, r1, r2, r3

  - Register variables which must be preserved: r4, r5, r6, r7, r8, r9, r10, r11

    - r9 is used as sb (static base) if RWPI option selected

    - r10 is used as sl (stack limit) if software stack checking selected

  - Scratch register (corruptible): r12

### Libraries and Semihosting

- RVDS includes ANSI C and C++ libraries

  - File handling, math, etc

  - Linker automatically links in the correct library variant for an application depending on endianness, floating point usage, position independence, etc

- Semihosting is used to access host debug facilities

  - Provides implementation of standard input and output facilities by invoking a software interrupt trapped by debug tools

- User can provide replacement implementation of specific functions for embedded use (retargeting)

  - No need to rebuild whole library

## C/C++ Hints and Tips

- Background on compiling and linking

- Compiler performs optimizations that are safe, it does not reorder instructions if that would change behavior

- RVCT tools produce and consume elf objects and images

  - ELF files contain one or more section, each section can be either code or data, but not both

  - The code section usually contains constant data values in literal pools

  - A section can be moved independently of other sections

- The compiler has no visibility outside the compilation unit it is compiling

  - No knowledge of absolute addresses, relative addresses between sections (e.g. between code and data) or the source or object code of other files

- The only common knowledge across source files are the included headers which contain layout of structures and classes, and function prototypes

- The linker assigns addresses and lays out sections to form a final image based on a scatter file

- Linker uses compiler generated relocations to patch the object code to take into account the final relationships between sections

  - Linker does not look at the source code

  - Cannot subdivide or insert extra information into sections

  - Can remove a section if it is not required by any part of the program

### Inlining of functions

- Inlining can improve performance, at the expense of a larger image, by
incorporating the body of the inlined function directly into the calling
code

  - Only possible when the caller and callee are in the same compilation unit

- The compiler can choose which functions to inline automatically

  - At -O0 and -O1 it chooses only functions marked with the \_\_inline keyword

  - At -O2 and -O3 the compiler considers all functions

  - Inlining can be disabled by using the \-\-no_inline option

  - A function can be marked with \_\_forceinline to force it to be inlined in all cases

  - Function that is not static (extern) if auto-inlined also has a normal version generated

### Parameter passing

- The first four word sized arguments passed to a function are transferred
in registers r0-r3

  - Arguments smaller than a word will use the entire register anyway

  - Arguments larger than a word are passed in multiple registers

- If more than 4 arguments are passed then the stack is used (slower)

- Therefore, always try to limit arguments to 4 words or fewer

- C++ uses the first argument to pass the this pointer

### Loops

- Subtract and compare to zero can be done in one instruction (SUBS) but must use an unsigned int counter or test not equal to zero, rather than greater than or equal to zero

  Replace

  ```c
  for (loop = 1; loop <= total; loop++)
  ```

  With

  ```c
  for (loop = total; loop != 0; loop--)
  ```

  - Loop limit (total) used only once so the register used for the limit can be reused by the compiler

### Division

- ARM core contains no division hardware

  - Typically implemented by a run-time library

- Compiler will try to optimize division

  - Divide by a constant two will use right shift operation

- Same problem with remainder (modulo) operations

  - Use if statement instead of modulo operation when checking range

### Floating point

- Software floating point library called fplib

  - Use compile time option (default) \-\-fpu softvfp

- VFP floating point coprocessor

  - Use option \-\-fpu vfp

    - Specifying a \-\-cpu will also select option

  - Available for ARM9E, ARM10 and ARM11 cores

  - Actually a mix of hardware coprocessor and emulation, requires VFP support code (provided with RVDS) for unusual cases

- Use \-\-fpu softvfp+vfp when Thumb code uses floating point

  - Thumb does not have coprocessor instructions

  - Compiler calls an ARM state library or compiles the function using floating point as ARM

### Variable types

- Global and static variables are held in RAM (in RW/ZI sections)

  - Requires load / store to memory (slow)

  - External global variables also require extra level of indirection because compiler has to load a pointer to the variable first

- Local variables are held in registers for fast processing but if the compiler runs out of registers it will use the stack

- Prefer int size local variables instead of byte or short because this avoids additional shifts and masks

### Stack issues

- C/C++ code uses stack extensively

- The stack is used to hold

  - Function return addresses

  - Caller's registers that must be preserved according to the procedure call standard (ATPCS)

  - "Spilled" local variables

  - Local arrays, structures and classes (in C++)

- Things to consider

  - Keep functions small with fewer variables

  - Avoid large local structures, classes or arrays, use the heap, especially for Thumb

  - Beware of recursion

- Measure stack usage

  - Link with \-\-callgraph option to see static stack usage information

  - Compile with software stack checking \-\-apcs/swst

### Unaligned accesses

- ARM hardware requires access to memory to be on natural boundaries

  - Compiler will reorder layout of global data in a module unless \-\-O no_data_reorder option is used

  - Compiler cannot reorder structures so it will add padding, you can rearrange structure members so that padding is minimized (smaller members first)

- If unaligned access is required warn the compiler by using the \_\_packed type qualifier

  - Required for network protocols, reusing legacy code

  - Requires additional instructions when loading and storing data

  - Using \_\_packed on a structure will remove all padding, it may be more efficient to specify \_\_packed on an individual member and not the entire structure

- Beware when using pointers to unaligned data

### Multifile compilation

- Default at level -O3 if multiple object files are specified

  - armcc \-\-multifile -c file1.c file2.c ...

  - Compiles multiple source files into a single object file

  - Behaves as if all the source files are one big source file

- Benefits

  - Make more observations

  - Inline more often

  - Can share code segments and literal pool data

  - Improves global data access (same base pointer)

  - Fewer license checkouts

  - Cross file type checking

- Use carefully

  - All code placed in single ELF section

  - All data placed in another ELF section

  - Potential scatter loading or undefined reference type problems

  - Increased compilation time

- Works best with small groups of related source files

## Useful references

### Application Notes and Articles

- Application Notes

  - App Note 34: Writing Efficient C for ARM

  - App Note 36: Using C Global Data

  - App Note 61: Big and Little Endian Byte Addressing

- Manuals

  - Application Binary Interface (ABI) for the ARM Architecture

  - ARM ELF Specification

  - Assembler Guide

  - Compilers and Libraries Guide

  - Linker and Utilities Guide

### Books

- ARM Architecture Reference Manual (ARM ARM), second edition -- David Seal

- ARM system-on-chip architecture, second edition -- Steve Furber
