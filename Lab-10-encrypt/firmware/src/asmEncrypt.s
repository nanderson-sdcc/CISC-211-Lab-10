/*** asmEncrypt.s   ***/

#include <xc.h>

# Declare the following to be in data memory 
.data  

# Define the globals so that the C code can access them
# (in this lab we return the pointer, so strictly speaking,
# doesn't really need to be defined as global)
# .global cipherText
.type cipherText,%gnu_unique_object

.align
# space allocated for cipherText: 200 bytes, prefilled with 0x2A */
cipherText: .space 200,0x2A  
 
# Tell the assembler that what follows is in instruction memory    
.text
.align

# Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

    
/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )
     
where:
     input:
     ptrToInputText: location of first character in null-terminated
                     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.
     
     output:
     pointerToCipherText: mem location (address) of first character of
                          encrypted text. Returned in r0
     
     function description: asmEncrypt reads each character of an input
                           string, uses a shifted alphabet to encrypt it,
                           and stores the new character value in memory
                           location beginning at "cipherText". After copying
                           a character to cipherText, a pointer is incremented 
                           so that the next letter is stored in the bext byte.
                           Only encrypt characters in the range [a-zA-Z].
                           Any other characters should just be copied as-is
                           without modifications
                           Stop processing the input string when a NULL (0)
                           byte is reached. Make sure to add the NULL at the
                           end of the cipherText string.
     
     notes:
        The return value will always be the mem location defined by
        the label "cipherText".
     
     
********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   

    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
    /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    LDRB r2, [r0] /*First, we load the current byte from the pointer */
    CMP r2, 0 /*This checks if it is the terminating character */
    BEQ done
    CMP r2, 97 /*This checks if it is in the possible range for uppercase */
    BHS lower_case
    CMP r2, 65 /*This checks if it is out of range for lower case */
    BLO store
    
upper_case: /* At this point, we can assume it is uppercase. The process here will shift all our characters properly */
   SUB r2, r2, 65
   ADD r2, r1, r2
   MOV r2, r2 MOD 26
   ADD r2, r2, 65
   B store

lower_case: /*This is the process for properly shifting a lowercase character */
    CMP r2, 123
    BHS store
    SUB r2, r2, 97
    ADD r2, r1, r2
    MOV r2, r2 MOD 26
    ADD r2, r2, 97

store: /* Now that we have done the shift, we store the character back into the string and increment our pointer */
    STRB r2, [r0]
    ADD r0, r0, 1
    B asmEncrypt

done: /*This ensures that the function returns the starting address to the string */
    LDR r0, =cipherText
    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmEncrypt return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




