# x86 NASM Libraries

This repository is dedicated to the development and storage of reusable libraries written in x86 assembly language. The libraries are designed to be assembled with the **Netwide Assembler (NASM)** and aim to provide efficient and modular solutions for various low-level programming tasks.

## Features

- **Modular Design**: Each library is structured to be reusable and easy to integrate into other projects.
- **Performance-Oriented**: Written in x86 assembly for maximum performance and control over hardware.
- **NASM-Compatible**: All code is designed to be assembled with NASM.

## Requirements

- **Assembler**: NASM (Netwide Assembler)
- **Environment**: x86 architecture with access to video memory (e.g., DOSBox or a similar emulator for testing).

## How to Use

### 1. Clone the repository within your directory

```bash
git clone https://github.com/your-username/x86-assembly-libraries.git
```

### 2. Include the library within your files
    
```asm
%include "Graphics/viewport.asm"
```

## Current Libraries

### `viewport.asm`

The `viewport.asm` file is a library that provides macros to **manage and display a viewport** in memory. It includes functionality for **memory allocation, deallocation, and rendering**.
The macros are designed to deal with video memory of the `INT 13h - AH = 13h`. The interrupt should be executed **before using** the graphical library.

#### Content

1. **`initViewport`**
   - Initializes the viewport by allocating a memory block.
   - **Arguments**:
     1. Number of 16-byte sections to allocate.
     2. Address to store the position of the allocated block.
     3. Label to jump to if memory allocation fails.

2. **`deallocationViewport`**
   - Deallocates the memory block used for the viewport.
   - **Arguments**:
     1. Address where the position of the allocated block is stored.
     2. Label to jump to if memory deallocation fails.

3. **`displayPixelBlock`** *can be used, but not necessary for a viewport use*
   - Displays a block of the viewport on the screen.
   - **Arguments**:
     1. Address where the position of the allocated block is stored.

4. **`displayViewport`**
   - Displays the entire viewport on the screen by splitting the task into multiple blocks.
   - **Arguments**:
     1. Address where the position of the allocated block is stored.
     2. Screen's size in bytes (e.g., `SCREEN_HEIGHT * SCREEN_WIDTH`).
