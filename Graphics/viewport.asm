; This file contains all the macros to manage the viewport.

%macro initViewport 3
    ; Initializes the viewport by allocating a memory block.
    ; arg1: resolution's size in bytes (e.g: SCREEN_HEIGHT * SCREEN_WIDTH).
    ; arg2: address to store the position of the allocated block.
    ; arg3: label to jump to if failed to allocate.

    ; calculates the number of 16 bytes chunks we need
    mov ax, %1
    mov bx, 16
    xor dx, dx
    div bx
    
    mov bx, ax
    ; interrupt
    xor ax, ax
    mov ah, 48h
    int 21h
    ; if failed to allocate, exit
    jc %3

    ; save the pos of the allocated block
    mov word [%2], ax
%endmacro


%macro deallocateViewport 2
    ; Deallocates the memory block used for the viewport.
    ; arg1: address where the position of the allocated block is stored.
    ; arg2: label to jump to if failed to deallocate.

    mov ax, [%1]
    mov es, ax
    xor ax, ax
    mov ah, 49h
    int 21h
    ; if failed to deallocate, exit
    jc %2
%endmacro


%macro clearViewport 3
    ; Clears the viewport by setting all pixels to a color.
    ; arg1: address where the position of the allocated block is stored.
    ; arg2: color's hexadecimal code.
    ; arg3: screen's size in bytes (e.g: SCREEN_HEIGHT * SCREEN_WIDTH).

    mov ax, [%1]
    mov es, ax
    mov di, 0
    %%clearEachPixels:
        ; set the pixel selected to the wanted color
        mov byte [es:di], %2
        ; loop until it has done every pixel
        inc di
        cmp di, %3
        jne %%clearEachPixels
%endmacro


%macro displayPixelBlock 1
    ; Displays a block of the viewport on the screen.
    ; arg1: address where the position of the allocated block is stored.

    ; first we go to the memory block of the viewport to take the color of the selected pixel of the viewport
    mov ax, [%1]
    mov es, ax
    %rep 4
        xor eax, eax  ; clear the register ax because we will only use the lower part (al) for the color
        mov eax, dword [es:di]
        push eax
        add di, 4
    %endrep

    ; then we go to the video memory to set the color of the pixel block
    mov ax, 0xA000
    mov es, ax
    %rep 4
        pop eax
        mov dword [es:di-4], eax
        sub di, 4
    %endrep
%endmacro

%macro displayViewport 2
    ; Displays the viewport on the screen, by splitting the task into multiple blocks.
    ; arg1: address where the position of the allocated block is stored.
    ; arg2: screen's size in bytes (e.g: SCREEN_HEIGHT * SCREEN_WIDTH).
    
    ; set the position to the first pixel
    mov di, 0
    .eachPixel:
        displayPixelBlock %1
        add di, 16 ; you're probably wondering how i ended up in this situation
        cmp di, %2
        jne .eachPixel
%endmacro