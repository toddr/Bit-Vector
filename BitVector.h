#ifndef AUTO_CONFIG_BIT_VECTORS
#define AUTO_CONFIG_BIT_VECTORS
/*****************************************************************************/
/*  MODULE NAME:  BitVector.h                           MODULE TYPE:  (adt)  */
/*****************************************************************************/
/*  MODULE IMPORTS:                                                          */
/*****************************************************************************/
#include <stdlib.h>                                 /*  MODULE TYPE:  (sys)  */
#include <limits.h>                                 /*  MODULE TYPE:  (sys)  */
#include <string.h>                                 /*  MODULE TYPE:  (sys)  */
#include <ctype.h>                                  /*  MODULE TYPE:  (sys)  */
#include "Definitions.h"                            /*  MODULE TYPE:  (dat)  */
/*****************************************************************************/
/*  MODULE INTERFACE:                                                        */
/*****************************************************************************/

/* ===> INTERNAL FUNCTIONS: <=== */

N_word  BitVector_Auto_Config(void);                 /* 0 = ok, 1..7 = error */

N_word  BitVector_Size  (N_int elements);   /* bit vector size (# of words)  */
N_word  BitVector_Mask  (N_int elements);   /* bit vector mask (unused bits) */

/* ===> CLASS METHODS: <=== */

charptr BitVector_Version    (void);               /* returns version string */

N_int   BitVector_Word_Bits  (void);    /* returns # of bits in machine word */
N_int   BitVector_Long_Bits  (void);   /* returns # of bits in unsigned long */

wordptr BitVector_Create(N_int elements, boolean clear);          /* malloc  */

/* ===> OBJECT METHODS: <=== */

wordptr BitVector_Shadow  (wordptr addr); /* create new, same size but empty */
wordptr BitVector_Clone   (wordptr addr);          /* create exact duplicate */

wordptr BitVector_Resize  (wordptr oldaddr, N_int elements);      /* realloc */
void    BitVector_Destroy (wordptr addr);                         /* free    */

/* ===> bit vector copy function: */

void    BitVector_Copy    (wordptr X, wordptr Y);           /* X = Y         */

/* ===> bit vector initialization: */

void    BitVector_Empty   (wordptr addr);                   /* X = {}        */
void    BitVector_Fill    (wordptr addr);                   /* X = ~{}       */
void    BitVector_Flip    (wordptr addr);                   /* X = ~X        */

void    BitVector_Primes  (wordptr addr);

/* ===> bit vector interval operations and functions: */

void    BitVector_Interval_Empty   (wordptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Fill    (wordptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Flip    (wordptr addr, N_int lower, N_int upper);

boolean BitVector_interval_scan_inc(wordptr addr, N_int start,
                                    N_intptr min, N_intptr max);
boolean BitVector_interval_scan_dec(wordptr addr, N_int start,
                                    N_intptr min, N_intptr max);

void    BitVector_Interval_Copy    (wordptr X, wordptr Y, N_int Xoffset,
                                    N_int Yoffset, N_int length);

wordptr BitVector_Interval_Substitute(wordptr X, wordptr Y,
                                    N_int Xoffset, N_int Xlength,
                                    N_int Yoffset, N_int Ylength);

/* ===> bit vector test functions: */

boolean BitVector_is_empty(wordptr addr);                   /* X == {} ?     */
boolean BitVector_is_full (wordptr addr);                   /* X == ~{} ?    */

boolean BitVector_equal   (wordptr X, wordptr Y);           /* X == Y ?      */
Z_int   BitVector_Compare (wordptr X, wordptr Y);           /* X <,=,> Y ?   */

/* ===> bit vector string conversion functions: */

charptr BitVector_to_Hex  (wordptr addr);
boolean BitVector_from_hex(wordptr addr, charptr string);

charptr BitVector_to_Bin  (wordptr addr);
boolean BitVector_from_bin(wordptr addr, charptr string);

charptr BitVector_to_Dec  (wordptr addr);
boolean BitVector_from_dec(wordptr addr, charptr string);

charptr BitVector_to_Enum (wordptr addr);
boolean BitVector_from_enum(wordptr addr, charptr string);

void    BitVector_Dispose (charptr string);

/* ===> bit vector bit operations, functions & tests: */

void    BitVector_Bit_Off (wordptr addr, N_int index);      /* X = X \ {x}   */
void    BitVector_Bit_On  (wordptr addr, N_int index);      /* X = X + {x}   */
boolean BitVector_bit_flip(wordptr addr, N_int index);  /* X=(X+{x})\(X*{x}) */

boolean BitVector_bit_test(wordptr addr, N_int index);      /* {x} in X ?    */

void    BitVector_Bit_Copy(wordptr addr, N_int index, boolean bit);

/* ===> bit vector bit shift & rotate functions: */

boolean BitVector_lsb         (wordptr addr);
boolean BitVector_msb         (wordptr addr);
boolean BitVector_rotate_left (wordptr addr);
boolean BitVector_rotate_right(wordptr addr);
boolean BitVector_shift_left  (wordptr addr, boolean carry_in);
boolean BitVector_shift_right (wordptr addr, boolean carry_in);
void    BitVector_Move_Left   (wordptr addr, N_int bits);
void    BitVector_Move_Right  (wordptr addr, N_int bits);

/* ===> bit vector insert/delete bits: */

void    BitVector_Insert      (wordptr addr, N_int offset, N_int count);
void    BitVector_Delete      (wordptr addr, N_int offset, N_int count);

/* ===> bit vector arithmetic: */

boolean BitVector_increment   (wordptr addr);               /* X++           */
boolean BitVector_decrement   (wordptr addr);               /* X--           */

boolean BitVector_add     (wordptr X, wordptr Y, wordptr Z, boolean carry);
boolean BitVector_subtract(wordptr X, wordptr Y, wordptr Z, boolean carry);
void    BitVector_Negate  (wordptr X, wordptr Y);
void    BitVector_Absolute(wordptr X, wordptr Y);
Z_int   BitVector_Sign    (wordptr addr);
boolean BitVector_Mul_Pos (wordptr X, wordptr Y, wordptr Z);
N_int   BitVector_Multiply(wordptr X, wordptr Y, wordptr Z);
void    BitVector_Div_Pos (wordptr Q, wordptr X, wordptr Y, wordptr R);
boolean BitVector_Divide  (wordptr Q, wordptr X, wordptr Y, wordptr R);
boolean BitVector_GCD     (wordptr X, wordptr Y, wordptr Z);

/* ===> direct memory access functions: */

void    BitVector_Block_Store (wordptr addr, charptr buffer, N_int length);
charptr BitVector_Block_Read  (wordptr addr, N_intptr length);

/* ===> word array functions: */

void    BitVector_Word_Store  (wordptr addr, N_int offset, N_int value);
N_int   BitVector_Word_Read   (wordptr addr, N_int offset);

void    BitVector_Word_Insert (wordptr addr, N_int offset, N_int count,
                               boolean clear);
void    BitVector_Word_Delete (wordptr addr, N_int offset, N_int count,
                               boolean clear);

/* ===> arbitrary size chunk functions: */

void    BitVector_Chunk_Store (wordptr addr, N_int offset,
                               N_int chunksize, N_long value);
N_long  BitVector_Chunk_Read  (wordptr addr, N_int offset,
                               N_int chunksize);

/* ===> set operations: */

void    Set_Union       (wordptr X, wordptr Y, wordptr Z);  /* X = Y + Z     */
void    Set_Intersection(wordptr X, wordptr Y, wordptr Z);  /* X = Y * Z     */
void    Set_Difference  (wordptr X, wordptr Y, wordptr Z);  /* X = Y \ Z     */
void    Set_ExclusiveOr (wordptr X, wordptr Y, wordptr Z);  /* X=(Y+Z)\(Y*Z) */
void    Set_Complement  (wordptr X, wordptr Y);             /* X = ~Y        */

/* ===> set functions: */

boolean Set_subset      (wordptr X, wordptr Y);             /* X subset Y ?  */

N_int   Set_Norm        (wordptr addr);                     /* = | X |       */
Z_long  Set_Min         (wordptr addr);                     /* = min(X)      */
Z_long  Set_Max         (wordptr addr);                     /* = max(X)      */

/* ===> matrix-of-booleans operations: */

void    Matrix_Multiplication(wordptr X, N_int rowsX, N_int colsX,
                              wordptr Y, N_int rowsY, N_int colsY,
                              wordptr Z, N_int rowsZ, N_int colsZ);

void    Matrix_Closure       (wordptr addr, N_int rows, N_int cols);

void    Matrix_Transpose     (wordptr X, N_int rowsX, N_int colsX,
                              wordptr Y, N_int rowsY, N_int colsY);

/*
// The "mask" that is used in various functions throughout this package avoids
// problems that may arise when the number of bits used in a bit vector (or the
// number of elements used in a set) is not a multiple of 16 (or whatever the
// size of a machine word is on your system).
//
// (Note that in this package, the type name "N_word" is used instead of "word"
// in order to avoid possible name conflicts with any system header files on
// some machines!)
//
// In these cases, comparisons between bit vectors (or sets) would fail to
// produce the expected results if in one vector (or set) the unused bits
// were set, while they were cleared in the other. To prevent this, unused
// bits are systematically turned off by this package using this "mask".
//
// If the number of elements in a set is, say, 500, you need to define a
// contiguous block of memory with 32 words (if a machine word (= a "N_word")
// is worth 16 bits) to store any such set, or
//
//                          N_word your_set[32];
//
// 32 words contain a total of 512 bits, which means (since only one bit
// is needed for each element to flag its presence or absence in the set)
// that 12 bits remain unused.
//
// Since element #0 corresponds to bit #0 in word #0 of "your_set", and
// element 499 corresponds to bit #3 in word #31, the 12 most significant
// bits of word #31 remain unused.
//
// Therefore, the mask word should have the 12 most significant bits cleared
// while the remaining lower bits remain set; in the case of our example,
// the mask word would have the value 0x000F.
//
// Sets or bit vectors in this package cannot be defined like variables in C,
// however.
//
// In order to use a set variable or bit vector, you have to invoke the
// "object constructor method" "BitVector_Create()", which dynamically creates
// a set variable or bit vector of the desired size (maximum number of ele-
// ments) by allocating the appropriate amount of memory on the system heap
// and initializing it to represent an empty set (all bits cleared).
//
// MNEMONIC: If the name of one of the functions in this package (that is,
//           the part of the name after the prefix "BitVector_", "Set_" etc.)
//           consists of only lower case letters, this indicates that it
//           returns a boolean function result.
//
// REMINDER: All indices into your set or bit vector range from zero to the
//           maximum number of elements in your set (or total number of bits
//           in your bit vector) minus one!
//
// WARNING:  It is your, the user's responsibility to make sure that all
//           indices are within the appropriate range for any given set or
//           bit vector! No bounds checking is performed by the functions of
//           this package! If you don't, you may get core dumps and receive
//           "segmentation violation" errors. To do bounds checking in your
//           application, check incoming indices as follows:
//           An index is invalid for any set or bit vector (given by its
//           pointer "addr") if it is greater than or equal to "bits_(addr)"
//           (or if it is less than zero). Note that you don't need to check
//           for negative indices, though, because the type used for indices
//           in this package is UNSIGNED.
//
// WARNING:  You shouldn't perform any set operations with sets of different
//           sizes unless you know exactly what you're doing. If the resulting
//           set is larger than the argument sets, or if the argument sets are
//           of different sizes, this may result in a segmentation violation
//           error, because you are actually reading beyond the allocated
//           length of the argument sets. If the resulting set is smaller
//           than the two argument sets, and if the two argument sets have
//           the same size, no error occurs, but you will of course lose
//           some information (the result will be truncated to the size
//           of the resulting set).
//
// NOTE:     The auto-config initialization routine can fail for 7 reasons:
//
//           Result:                    Meaning:
//
//              1      The type "N_int" is larger (has more bits) than "size_t"
//              2      The number of bits in a word and sizeof(N_int)*8 differ
//              3      The number of bits of a machine word is less than 16
//              4      The type "N_int" is larger (has more bits) than "N_long"
//              5      The number of bits of a machine word is not a power of 2
//              6      Internal error: "bits" and "2^ld(bits)" differ
//              7      The attempt to allocate memory with "malloc()" failed
*/
/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

#define bits_(BitVector) *(BitVector-3)
#define size_(BitVector) *(BitVector-2)
#define mask_(BitVector) *(BitVector-1)

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

/*****************************************************************************/
/*  AUTHOR:  Steffen Beyer                                                   */
/*****************************************************************************/
/*  VERSION:  5.0                                                            */
/*****************************************************************************/
/*  VERSION HISTORY:                                                         */
/*****************************************************************************/
/*    ca. 1989    Created - Turbo Pascal version under CP/M on Apple ][+     */
/*    01.11.93    First C version (MS C Compiler on PC with DOS)             */
/*    29.11.95    First C version under UNIX (for Perl module)               */
/*    14.12.95    Version 1.0                                                */
/*    08.01.96    Version 1.1                                                */
/*    14.12.96    Version 2.0                                                */
/*    12.01.97    Version 3.0                                                */
/*    21.01.97    Version 3.1                                                */
/*    04.02.97    Version 3.2                                                */
/*    14.04.97    Version 4.0                                                */
/*    30.06.97    Version 4.1  added word-ins/del, move-left/right, inc/dec  */
/*    16.07.97    Version 4.2  added is_empty, is_full                       */
/*    12.10.97    Version 5.0                                                */
/*****************************************************************************/
/*  COPYRIGHT (C) 1989-1997 BY:  Steffen Beyer         ALL RIGHTS RESERVED.  */
/*****************************************************************************/
#endif
