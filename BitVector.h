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

/* #define ENABLE_BOUNDS_CHECKING here to do bounds checking! */

#define ENABLE_BOUNDS_CHECKING

unit    BitVector_Auto_Config(void);                 /* 0 = ok, 1..5 = error */

unit    BitVector_Size    (N_int elements); /* bit vector size (# of units)  */
unit    BitVector_Mask    (N_int elements); /* bit vector mask (unused bits) */

unitptr BitVector_Create  (N_int   elements);               /* malloc        */
void    BitVector_Destroy (unitptr addr);                   /* free          */
unitptr BitVector_Resize  (unitptr oldaddr, N_int elements);/* realloc       */

void    BitVector_Empty   (unitptr addr);                   /* X = {}        */
void    BitVector_Fill    (unitptr addr);                   /* X = ~{}       */
void    BitVector_Flip    (unitptr addr);                   /* X = ~X        */

void    BitVector_Interval_Empty   (unitptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Fill    (unitptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Flip    (unitptr addr, N_int lower, N_int upper);

boolean BitVector_interval_scan_inc(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max);
boolean BitVector_interval_scan_dec(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max);

void    BitVector_Bit_Off (unitptr addr, N_int index);      /* X = X \ {x}   */
void    BitVector_Bit_On  (unitptr addr, N_int index);      /* X = X + {x}   */
boolean BitVector_bit_flip(unitptr addr, N_int index);  /* X=(X+{x})\(X*{x}) */

boolean BitVector_bit_test(unitptr addr, N_int index);      /* {x} in X ?    */

boolean BitVector_equal   (unitptr X, unitptr Y);           /* X == Y ?      */
boolean BitVector_lexorder(unitptr X, unitptr Y);           /* X <= Y ?      */
Z_int   BitVector_Compare (unitptr X, unitptr Y);           /* X <,=,> Y ?   */

void    BitVector_Copy    (unitptr X, unitptr Y);           /* X = Y         */

boolean BitVector_rotate_left (unitptr addr);
boolean BitVector_rotate_right(unitptr addr);
boolean BitVector_shift_left  (unitptr addr, boolean carry_in);
boolean BitVector_shift_right (unitptr addr, boolean carry_in);

baseptr BitVector_to_String   (unitptr addr);
void    BitVector_Dispose     (baseptr string);
boolean BitVector_from_string (unitptr addr, baseptr string);

/*      set operations: */

void    Set_Union       (unitptr X, unitptr Y, unitptr Z);  /* X = Y + Z     */
void    Set_Intersection(unitptr X, unitptr Y, unitptr Z);  /* X = Y * Z     */
void    Set_Difference  (unitptr X, unitptr Y, unitptr Z);  /* X = Y \ Z     */
void    Set_ExclusiveOr (unitptr X, unitptr Y, unitptr Z);  /* X=(Y+Z)\(Y*Z) */
void    Set_Complement  (unitptr X, unitptr Y);             /* X = ~Y        */

/*      set functions: */

boolean Set_subset      (unitptr X, unitptr Y);             /* X subset Y ?  */

N_int   Set_Norm        (unitptr addr);                     /* = | X |       */
Z_long  Set_Min         (unitptr addr);                     /* = min(X)      */
Z_long  Set_Max         (unitptr addr);                     /* = max(X)      */

/*      matrix-of-booleans operations: */

void    Matrix_Multiplication(unitptr X, unit rowsX, unit colsX,
                              unitptr Y, unit rowsY, unit colsY,
                              unitptr Z, unit rowsZ, unit colsZ);

void    Matrix_Closure       (unitptr addr, unit rows, unit cols);

/*
// The "mask" that is used in various functions throughout this package avoids
// problems that may arise when the number of bits used in a bit vector (or the
// number of elements used in a set) is not a multiple of 16 (or whatever the
// size of a machine word is on your system).
//
// (Note that in this package, the type name "unit" is used instead of "word"
// in order to avoid possible name conflicts with any system header files on
// some machines!)
//
// In these cases, comparisons between bit vectors (or sets) would fail to
// produce the expected results if in one vector (or set) the unused bits
// were set, while they were cleared in the other. To prevent this, unused
// bits are systematically turned off by this package using this "mask".
//
// If the number of elements in a set is, say, 500, you need to define a
// contiguous block of memory with 32 units (if a unit (a machine word) is
// worth 16 bits) to store any such set, or
//
//                          unit your_set[32];
//
// 32 units contain a total of 512 bits, which means (since only one bit
// is needed for each element to flag its presence or absence in the set)
// that 12 bits remain unused.
//
// Since element #0 corresponds to bit #0 in unit #0 of "your_set", and
// element 499 corresponds to bit #3 in unit #31, the 12 most significant
// bits of unit #31 remain unused.
//
// Therefore, the mask word should have the 12 most significant bits cleared
// while the remaining lower bits remain set; in the case of our example,
// the mask word would have the value 0x000F.
//
// Sets or bit vectors in this package cannot be defined like variables in C,
// however.
//
// In order to use a set variable or bit vector, you have to invoke the
// "object constructor method" "BitVector_Create", which dynamically creates
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
//           application, #define ENABLE_BOUNDS_CHECKING at the top of the
//           file "BitVector.c". Then check incoming indices as follows:
//           An index is invalid for any set or bit vector (given by its
//           pointer "addr") if it is greater than or equal to *(addr-3)
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
// NOTE:     The auto-config initialization routine can fail for 5 reasons:
//
//           Result:                    Meaning:
//
//              1      The type "unit" is larger (has more bits) than "size_t"
//              2      The number of bits of a machine word is not a power of 2
//              3      The number of bits of a machine word is less than 8
//                     (This would constitute a violation of ANSI C standards)
//              4      The number of bits in a word and sizeof(unit)*8 differ
//              5      The attempt to allocate memory with malloc() failed
*/
/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

/*****************************************************************************/
/*  AUTHOR:  Steffen Beyer                                                   */
/*****************************************************************************/
/*  VERSION:  4.0                                                            */
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
/*****************************************************************************/
/*  COPYRIGHT (C) 1989-1997 BY:  Steffen Beyer                               */
/*****************************************************************************/
#endif
