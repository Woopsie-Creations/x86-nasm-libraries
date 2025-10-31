%macro spriteDisplay 7
    ; Set the sprite onto the viewport.
    ; arg1: address of the viewport in memory.
    ; arg2: address of the sprite in memory.
    ; arg3: Y coordinates on the viewport to draw the item. (top left corner of the sprite)
    ; arg4: X coordinates on the viewport to draw the item. (top left corner of the sprite)
    ; arg5: height of the item.
    ; arg6: width of the item.
    ; arg7: is sprite uni-color flag (0 = no, 1 = yes).
    
    mov ax, [%1]
    mov es, ax
    
    ; if the sprite is uni-color, set the color as a byte, and at the address of si
    ; for instance, if the sprite is all red, %2 will contain the color red's hexadecimal code
    mov al, %7
    cmp al, 1
    je %%uniColorSetup

    mov si, %2
    jmp %%afterColorSetup

    %%uniColorSetup:
    mov byte dl, %2
    mov byte [si], dl

    %%afterColorSetup:
    ; calculate the position of the sprite
    mov ax, %3
    mov bx, 320
    mul bx
    add ax, %4
    mov di, ax
    ; draw the item
    mov dx, %5
    %%eachItemRow:
        mov cx, %6
        %%eachItemColumn:
            xor ax, ax
            ; get the color of the sprite at said position in the memory by the register si
            mov al, [si]
            mov byte [es:di], al ; place the pixel on the viewport
            
            ; check if the sprite is uni-color
            mov al, %7
            cmp al, 1
            je %%skipAdd

            ; go to the next pixel
            add si, 1

            %%skipAdd:
            inc di
            ; if it hasn't reached the end of the line, loop
            dec cx
            jnz %%eachItemColumn

        ; go to the next row
        add di, SCREEN_WIDTH
        sub di, %6

        ; if it hasn't reached the last row, loop
        dec dx
        jnz %%eachItemRow
%endmacro

%macro textDisplay 7
    ; Set the text (address of an array of letters' sprites) onto the viewport.
    ; arg1: address of the viewport in memory.
    ; arg2: address of the text.
    ; arg3: number of letters in the text. (length of the text)
    ; arg4: Y coordinates on the viewport to draw the text. (top left corner of the text)
    ; arg5: X coordinates on the viewport to draw the text. (top left corner of the text)
    ; arg6: height of each letter.
    ; arg7: width of each letter.

    mov word [letter_x_pos], %5
    mov word [letter_y_pos], %4
    mov bx, 0
        %%eachLetter:
        push bx
        displayItem %1, [%2+bx], [letter_y_pos], [letter_x_pos], %6, %7, 0
        pop bx
        add word [letter_x_pos], %7 + 1
        add bx, 2
        cmp bx, %3 * 2
        jne %%eachLetter
%endmacro