#ifndef AUTO_CONFIG_BIT_VECTORS
#define AUTO_CONFIG_BIT_VECTORS
/*****************************************************************************/
/*  MODULE NAME:  BitVector.c                           MODULE TYPE:  (adt)  */
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

/*
unit    BitVector_Auto_Config(void);                 (* 0 = ok, 1..5 = error *)

unit    BitVector_Size    (N_int elements); (* bit vector size (# of units)  *)
unit    BitVector_Mask    (N_int elements); (* bit vector mask (unused bits) *)

unitptr BitVector_Create  (N_int   elements);               (* malloc        *)
void    BitVector_Destroy (unitptr addr);                   (* free          *)
unitptr BitVector_Resize  (unitptr oldaddr, N_int elements);(* realloc       *)

void    BitVector_Empty   (unitptr addr);                   (* X = {}        *)
void    BitVector_Fill    (unitptr addr);                   (* X = ~{}       *)
void    BitVector_Flip    (unitptr addr);                   (* X = ~X        *)

void    BitVector_Interval_Empty   (unitptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Fill    (unitptr addr, N_int lower, N_int upper);
void    BitVector_Interval_Flip    (unitptr addr, N_int lower, N_int upper);

boolean BitVector_interval_scan_inc(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max);
boolean BitVector_interval_scan_dec(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max);

void    BitVector_Bit_Off (unitptr addr, N_int index);      (* X = X \ {x}   *)
void    BitVector_Bit_On  (unitptr addr, N_int index);      (* X = X + {x}   *)
boolean BitVector_bit_flip(unitptr addr, N_int index);  (* X=(X+{x})\(X*{x}) *)

boolean BitVector_bit_test(unitptr addr, N_int index);      (* {x} in X ?    *)

boolean BitVector_is_empty(unitptr addr);                   (* X == {} ?     *)
boolean BitVector_is_full (unitptr addr);                   (* X == ~{} ?    *)

boolean BitVector_equal   (unitptr X, unitptr Y);           (* X == Y ?      *)
boolean BitVector_lexorder(unitptr X, unitptr Y);           (* X <= Y ?      *)
Z_int   BitVector_Compare (unitptr X, unitptr Y);           (* X <,=,> Y ?   *)

void    BitVector_Copy    (unitptr X, unitptr Y);           (* X = Y         *)

boolean BitVector_rotate_left (unitptr addr);
boolean BitVector_rotate_right(unitptr addr);
boolean BitVector_shift_left  (unitptr addr, boolean carry_in);
boolean BitVector_shift_right (unitptr addr, boolean carry_in);

void    BitVector_Word_Insert (unitptr addr, unit words);
void    BitVector_Word_Delete (unitptr addr, unit words);

void    BitVector_Move_Left   (unitptr addr, N_int bits);
void    BitVector_Move_Right  (unitptr addr, N_int bits);

boolean BitVector_increment   (unitptr addr);               (* X++           *)
boolean BitVector_decrement   (unitptr addr);               (* X--           *)

baseptr BitVector_to_String   (unitptr addr);
void    BitVector_Dispose     (baseptr string);
boolean BitVector_from_string (unitptr addr, baseptr string);

(*      set operations: *)

void    Set_Union       (unitptr X, unitptr Y, unitptr Z);  (* X = Y + Z     *)
void    Set_Intersection(unitptr X, unitptr Y, unitptr Z);  (* X = Y * Z     *)
void    Set_Difference  (unitptr X, unitptr Y, unitptr Z);  (* X = Y \ Z     *)
void    Set_ExclusiveOr (unitptr X, unitptr Y, unitptr Z);  (* X=(Y+Z)\(Y*Z) *)
void    Set_Complement  (unitptr X, unitptr Y);             (* X = ~Y        *)

(*      set functions: *)

boolean Set_subset      (unitptr X, unitptr Y);             (* X subset Y ?  *)

N_int   Set_Norm        (unitptr addr);                     (* = | X |       *)
Z_long  Set_Min         (unitptr addr);                     (* = min(X)      *)
Z_long  Set_Max         (unitptr addr);                     (* = max(X)      *)

(*      matrix-of-booleans operations: *)

void    Matrix_Multiplication(unitptr X, unit rowsX, unit colsX,
                              unitptr Y, unit rowsY, unit colsY,
                              unitptr Z, unit rowsZ, unit colsZ);

void    Matrix_Closure       (unitptr addr, unit rows, unit cols);

*/
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

#ifdef ENABLE_BOUNDS_CHECKING
#define HIDDEN_WORDS 3
#else
#define HIDDEN_WORDS 2
#endif

    /*****************************************************************/
    /* machine dependent constants (set by "BitVector_Auto_Config"): */
    /*****************************************************************/

static unit BITS;       /* = # of bits in machine word (must be power of 2)  */
static unit MODMASK;    /* = BITS - 1 (mask for calculating modulo BITS)     */
static unit LOGBITS;    /* = ld(BITS) (logarithmus dualis)                   */
static unit FACTOR;     /* = ld(BITS / 8) (ld of # of bytes)                 */

static unit LSB = 1;    /* mask for least significant bit                    */
static unit MSB;        /* mask for most significant bit                     */

    /********************************************************************/
    /* bit mask table for fast access (set by "BitVector_Auto_Config"): */
    /********************************************************************/

static unitptr BITMASKTAB;

    /***************************************/
    /* automatic self-configuring routine: */
    /***************************************/

    /*******************************************************/
    /*                                                     */
    /*   MUST be called once prior to any other function   */
    /*   to initialize the machine dependent constants     */
    /*   of this package! (But call only ONCE!)            */
    /*                                                     */
    /*******************************************************/

unit BitVector_Auto_Config(void)
{
    unit sample = LSB;
    unit lsb;

    if (sizeof(unit) > sizeof(size_t)) return(1);

    BITS = 1;

    while (sample <<= 1) ++BITS;    /* determine # of bits in a machine word */

    LOGBITS = 0;
    sample = BITS;
    lsb = (sample AND LSB);
    while ((sample >>= 1) and (not lsb))
    {
        ++LOGBITS;
        lsb = (sample AND LSB);
    }

    if (sample) return(2);                 /* # of bits is not a power of 2! */

    if (LOGBITS < 3) return(3);       /* # of bits too small - minimum is 8! */

    if (BITS != (sizeof(unit) << 3)) return(4);    /* BITS != sizeof(unit)*8 */

    MODMASK = BITS - 1;
    FACTOR = LOGBITS - 3;  /* ld(BITS / 8) = ld(BITS) - ld(8) = ld(BITS) - 3 */
    MSB = (LSB << MODMASK);

    BITMASKTAB = (unitptr) malloc((size_t) (BITS << FACTOR));

    if (BITMASKTAB == NULL) return(5);

    for ( sample = 0; sample < BITS; ++sample )
    {
        BITMASKTAB[sample] = (LSB << sample);
    }

    return(0);
}

unit BitVector_Size(N_int elements)         /* bit vector size (# of units)  */
{
    unit size;

    size = elements >> LOGBITS;
    if (elements AND MODMASK) ++size;
    return(size);
}

unit BitVector_Mask(N_int elements)         /* bit vector mask (unused bits) */
{
    unit mask;

    mask = elements AND MODMASK;
    if (mask) mask = (LSB << mask) - 1; else mask = (unit) ~0L;
    return(mask);
}

void BitVector_Empty(unitptr addr)                        /* X = {}  clr all */
{
    unit size;

    size = *(addr-2);
    while (size-- > 0) *addr++ = 0;
}

void BitVector_Fill(unitptr addr)                         /* X = ~{} set all */
{
    unit size;
    unit mask;
    unit fill;

    size = *(addr-2);
    mask = *(addr-1);
    fill = (unit) ~0L;
    if (size > 0)
    {
        while (size-- > 0) *addr++ = fill;
        *(--addr) &= mask;
    }
}

void BitVector_Flip(unitptr addr)                         /* X = ~X flip all */
{
    unit size;
    unit mask;
    unit fill;

    size = *(addr-2);
    mask = *(addr-1);
    fill = (unit) ~0L;
    if (size > 0)
    {
        while (size-- > 0) *addr++ ^= fill;
        *(--addr) &= mask;
    }
}

unitptr BitVector_Create(N_int elements)                    /* malloc        */
{
    unit    size;
    unit    mask;
    unit    bytes;
    unitptr addr;

    addr = NULL;
    size = BitVector_Size(elements);
    mask = BitVector_Mask(elements);
    if (size > 0)
    {
        bytes = (size + HIDDEN_WORDS) << FACTOR;
        addr = (unitptr) malloc((size_t) bytes);
        if (addr != NULL)
        {
#ifdef ENABLE_BOUNDS_CHECKING
            *addr++ = elements;
#endif
            *addr++ = size;
            *addr++ = mask;
            BitVector_Empty(addr);
        }
    }
    return(addr);
}

void BitVector_Destroy(unitptr addr)                        /* free          */
{
    if (addr != NULL)
    {
        addr -= HIDDEN_WORDS;
        free((voidptr) addr);
    }
}

unitptr BitVector_Resize(unitptr oldaddr, N_int elements)   /* realloc       */
{
    unit bytes;
    unit oldsize;
    unit newsize;
    unit oldmask;
    unit newmask;
    unitptr source;
    unitptr target;
    unitptr newaddr;

    newaddr = NULL;
    newsize = BitVector_Size(elements);
    newmask = BitVector_Mask(elements);
    oldsize = *(oldaddr-2);
    oldmask = *(oldaddr-1);
    if ((oldsize > 0) and (newsize > 0))
    {
        *(oldaddr+oldsize-1) &= oldmask;
        if (oldsize >= newsize)
        {
            newaddr = oldaddr;
#ifdef ENABLE_BOUNDS_CHECKING
            *(newaddr-3) = elements;
#endif
            *(newaddr-2) = newsize;
            *(newaddr-1) = newmask;
            *(newaddr+newsize-1) &= newmask;
        }
        else
        {
            bytes = (newsize + HIDDEN_WORDS) << FACTOR;
            newaddr = (unitptr) malloc((size_t) bytes);
            if (newaddr != NULL)
            {
#ifdef ENABLE_BOUNDS_CHECKING
                *newaddr++ = elements;
#endif
                *newaddr++ = newsize;
                *newaddr++ = newmask;
                source = oldaddr;
                target = newaddr;
                while (newsize-- > 0)
                {
                    if (oldsize > 0)
                    {
                        --oldsize;
                        *target++ = *source++;
                    }
                    else *target++ = 0;
                }
            }
            BitVector_Destroy(oldaddr);
        }
    }
    else BitVector_Destroy(oldaddr);
    return(newaddr);
}

void BitVector_Interval_Empty(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X \ [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) ~0L;

    if (size == 0)
    {
        *loaddr &= NOT (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ &= NOT lomask;
        while (--size > 0)
        {
            *loaddr++ = 0;
        }
        *hiaddr &= NOT himask;
    }
}

void BitVector_Interval_Fill(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X + [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;
    unit    fill;

    fill = (unit) ~0L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) ~0L;

    if (size == 0)
    {
        *loaddr |= (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ |= lomask;
        while (--size > 0)
        {
            *loaddr++ = fill;
        }
        *hiaddr |= himask;
    }
    *(addr + (*(addr-2) - 1))  &=  *(addr-1);
}

void BitVector_Interval_Flip(unitptr addr, N_int lower, N_int upper)
{                                                  /* X = X ^ [lower..upper] */
    unitptr loaddr;
    unitptr hiaddr;
    unit    lobase;
    unit    hibase;
    unit    lomask;
    unit    himask;
    unit    size;
    unit    fill;

    fill = (unit) ~0L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = NOT ( (LSB << (lower AND MODMASK)) - 1 );
    himask = (upper AND MODMASK) + 1;
    if (himask < BITS) himask = (LSB << himask) - 1; else himask = (unit) ~0L;

    if (size == 0)
    {
        *loaddr ^= (lomask AND himask);
    }
    else if (size > 0)
    {
        *loaddr++ ^= lomask;
        while (--size > 0)
        {
            *loaddr++ ^= fill;
        }
        *hiaddr ^= himask;
    }
    *(addr + (*(addr-2) - 1))  &=  *(addr-1);
}

boolean BitVector_interval_scan_inc(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max)
{
    unit size;
    unit mask;
    unit offset;
    unit bitmask;
    unit value;
    boolean empty;

    *min = start;
    *max = start;

    size = *(addr-2);
    mask = *(addr-1);

    offset = start >> LOGBITS;

    if (offset >= size) return(false);

    *(addr+size-1) &= mask;

    addr += offset;
    size -= offset;

    bitmask = BITMASKTAB[start AND MODMASK];
    mask = NOT (bitmask OR (bitmask - 1));

    value = *addr++;
    if ((value AND bitmask) == 0)
    {
        value &= mask;
        if (value == 0)
        {
            ++offset;
            empty = true;
            while (empty and (--size > 0))
            {
                if (value = *addr++) empty = false; else ++offset;
            }
            if (empty) return(false);
        }
        start = offset << LOGBITS;
        bitmask = LSB;
        mask = value;
        while (not (mask AND LSB))
        {
            bitmask <<= 1;
            mask >>= 1;
            ++start;
        }
        mask = NOT (bitmask OR (bitmask - 1));
        *min = start;
        *max = start;
    }
    value = NOT value;
    value &= mask;
    if (value == 0)
    {
        ++offset;
        empty = true;
        while (empty and (--size > 0))
        {
            if (value = NOT *addr++) empty = false; else ++offset;
        }
        if (empty) value = LSB;
    }
    start = offset << LOGBITS;
    while (not (value AND LSB))
    {
        value >>= 1;
        ++start;
    }
    *max = --start;
    return(true);
}

boolean BitVector_interval_scan_dec(unitptr addr, N_int start,
                                    N_intptr min, N_intptr max)
{
    unit size;
    unit mask;
    unit offset;
    unit bitmask;
    unit value;
    boolean empty;

    *min = start;
    *max = start;

    size = *(addr-2);
    mask = *(addr-1);

    offset = start >> LOGBITS;

    if (offset >= size) return(false);

    *(addr+size-1) &= mask;

    addr += offset;
    size = ++offset;

    bitmask = BITMASKTAB[start AND MODMASK];
    mask = (bitmask - 1);

    value = *addr--;
    if ((value AND bitmask) == 0)
    {
        value &= mask;
        if (value == 0)
        {
            --offset;
            empty = true;
            while (empty and (--size > 0))
            {
                if (value = *addr--) empty = false; else --offset;
            }
            if (empty) return(false);
        }
        start = offset << LOGBITS;
        bitmask = MSB;
        mask = value;
        while (not (mask AND MSB))
        {
            bitmask >>= 1;
            mask <<= 1;
            --start;
        }
        mask = (bitmask - 1);
        *max = --start;
        *min = start;
    }
    value = NOT value;
    value &= mask;
    if (value == 0)
    {
        --offset;
        empty = true;
        while (empty and (--size > 0))
        {
            if (value = NOT *addr--) empty = false; else --offset;
        }
        if (empty) value = MSB;
    }
    start = offset << LOGBITS;
    while (not (value AND MSB))
    {
        value <<= 1;
        --start;
    }
    *min = start;
    return(true);
}

void BitVector_Bit_Off(unitptr addr, N_int index)           /* X = X \ {x}   */
{
    *(addr+(index>>LOGBITS)) &= NOT BITMASKTAB[index AND MODMASK];
}

void BitVector_Bit_On(unitptr addr, N_int index)            /* X = X + {x}   */
{
    *(addr+(index>>LOGBITS)) |= BITMASKTAB[index AND MODMASK];
}

boolean BitVector_bit_flip(unitptr addr, N_int index)   /* X=(X+{x})\(X*{x}) */
{
    unit mask;

    return( (
        ( *(addr+(index>>LOGBITS)) ^= (mask = BITMASKTAB[index AND MODMASK]) )
        AND mask ) != 0 );
}

boolean BitVector_bit_test(unitptr addr, N_int index)       /* {x} in X ?    */
{
    return( (*(addr+(index>>LOGBITS)) AND BITMASKTAB[index AND MODMASK]) != 0 );
}

boolean BitVector_is_empty(unitptr addr)                    /* X == {} ?     */
{
    unit    size;
    boolean r = true;

    size = *(addr-2);
    *(addr+size-1) &= *(addr-1);
    while (r and (size-- > 0)) r = ( *addr++ == 0 );
    return(r);
}

boolean BitVector_is_full(unitptr addr)                     /* X == ~{} ?    */
{
    unit    size;
    unit    mask;
    unitptr last;
    boolean r = true;

    size = *(addr-2);
    mask = *(addr-1);
    last = addr + size - 1;
    *last |= NOT mask;
    while (r and (size-- > 0)) r = ( NOT *addr++ == 0 );
    *last &= mask;
    return(r);
}

boolean BitVector_equal(unitptr X, unitptr Y)               /* X == Y ?      */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = (*X++ == *Y++);
    return(r);
}

boolean BitVector_lexorder(unitptr X, unitptr Y)            /* X <= Y ?      */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    X += size;
    Y += size;
    while (r and (size-- > 0)) r = (*(--X) == *(--Y));
    return(*X <= *Y);
}

Z_int BitVector_Compare(unitptr X, unitptr Y)               /* X <,=,> Y ?   */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    X += size;
    Y += size;
    while (r and (size-- > 0)) r = (*(--X) == *(--Y));
    if (r) return((Z_int) 0);
    else
    {
        if (*X < *Y) return((Z_int) -1); else return((Z_int) 1);
    }
}

void BitVector_Copy(unitptr X, unitptr Y)                   /* X = Y         */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++;
        *(--X) &= mask;
    }
}

boolean BitVector_rotate_left(unitptr addr)
{
    unit    size;
    unit    mask;
    unit    msb;
    boolean carry_in;
    boolean carry_out;

    size = *(addr-2);
    mask = *(addr-1);
    if (size > 0)
    {
        msb = mask AND NOT (mask >> 1);
        carry_in = ((*(addr+size-1) AND msb) != 0);
        while (size-- > 1)
        {
            carry_out = ((*addr AND MSB) != 0);
            *addr <<= 1;
            if (carry_in) *addr |= LSB;
            carry_in = carry_out;
            addr++;
        }
        carry_out = ((*addr AND msb) != 0);
        *addr <<= 1;
        if (carry_in) *addr |= LSB;
        *addr &= mask;
        return(carry_out);
    }
    else return(false);
}

boolean BitVector_rotate_right(unitptr addr)
{
    unit    size;
    unit    mask;
    unit    msb;
    boolean carry_in;
    boolean carry_out;

    size = *(addr-2);
    mask = *(addr-1);
    if (size > 0)
    {
        msb = mask AND NOT (mask >> 1);
        carry_in = ((*addr AND LSB) != 0);
        addr += size-1;
        *addr &= mask;
        carry_out = ((*addr AND LSB) != 0);
        *addr >>= 1;
        if (carry_in) *addr |= msb;
        carry_in = carry_out;
        addr--;
        size--;
        while (size-- > 0)
        {
            carry_out = ((*addr AND LSB) != 0);
            *addr >>= 1;
            if (carry_in) *addr |= MSB;
            carry_in = carry_out;
            addr--;
        }
        return(carry_out);
    }
    else return(false);
}

boolean BitVector_shift_left(unitptr addr, boolean carry_in)
{
    unit    size;
    unit    mask;
    unit    msb;
    boolean carry_out;

    size = *(addr-2);
    mask = *(addr-1);
    if (size > 0)
    {
        msb = mask AND NOT (mask >> 1);
        while (size-- > 1)
        {
            carry_out = ((*addr AND MSB) != 0);
            *addr <<= 1;
            if (carry_in) *addr |= LSB;
            carry_in = carry_out;
            addr++;
        }
        carry_out = ((*addr AND msb) != 0);
        *addr <<= 1;
        if (carry_in) *addr |= LSB;
        *addr &= mask;
        return(carry_out);
    }
    else return(false);
}

boolean BitVector_shift_right(unitptr addr, boolean carry_in)
{
    unit    size;
    unit    mask;
    unit    msb;
    boolean carry_out;

    size = *(addr-2);
    mask = *(addr-1);
    if (size > 0)
    {
        msb = mask AND NOT (mask >> 1);
        addr += size-1;
        *addr &= mask;
        carry_out = ((*addr AND LSB) != 0);
        *addr >>= 1;
        if (carry_in) *addr |= msb;
        carry_in = carry_out;
        addr--;
        size--;
        while (size-- > 0)
        {
            carry_out = ((*addr AND LSB) != 0);
            *addr >>= 1;
            if (carry_in) *addr |= MSB;
            carry_in = carry_out;
            addr--;
        }
        return(carry_out);
    }
    else return(false);
}

void BitVector_Word_Insert(unitptr addr, unit words)
{
    unit    size;
    unit    mask;
    unit    length;
    unitptr source;
    unitptr target;

    size = *(addr-2);
    mask = *(addr-1);
    if (words > 0)
    {
        if (words > size) words = size;
        length = size - words;
        target = addr + (size - 1);
        source = addr + (length - 1);
        while (length-- > 0) *target-- = *source--;
        while (words-- > 0) *target-- = 0;
    }
    *(addr+size-1) &= mask;
}

void BitVector_Word_Delete(unitptr addr, unit words)
{
    unit    size;
    unit    mask;
    unit    length;
    unitptr source;
    unitptr target;

    size = *(addr-2);
    mask = *(addr-1);
    if (words > 0)
    {
        if (words > size) words = size;
        length = size - words;
        target = addr;
        source = addr + words;
        while (length-- > 0) *target++ = *source++;
        while (words-- > 0) *target++ = 0;
    }
    *(addr+size-1) &= mask;
}

void BitVector_Move_Left(unitptr addr, N_int bits)
{
    unit    count;
    unit    words;

    if (bits > 0)
    {
        count = bits AND MODMASK;
        words = bits >> LOGBITS;
#ifdef ENABLE_BOUNDS_CHECKING
        if (bits >= *(addr-3)) BitVector_Empty(addr);
#else
        if (words >= *(addr-2)) BitVector_Empty(addr);
#endif
        else
        {
            while (count-- > 0) BitVector_shift_left(addr,0);
            BitVector_Word_Insert(addr,words);
        }
    }
}

void BitVector_Move_Right(unitptr addr, N_int bits)
{
    unit    count;
    unit    words;

    if (bits > 0)
    {
        count = bits AND MODMASK;
        words = bits >> LOGBITS;
#ifdef ENABLE_BOUNDS_CHECKING
        if (bits >= *(addr-3)) BitVector_Empty(addr);
#else
        if (words >= *(addr-2)) BitVector_Empty(addr);
#endif
        else
        {
            while (count-- > 0) BitVector_shift_right(addr,0);
            BitVector_Word_Delete(addr,words);
        }
    }
}

boolean BitVector_increment(unitptr addr)                   /* X++           */
{
    unit    size;
    unit    mask;
    unitptr last;
    boolean carry = true;

    size = *(addr-2);
    mask = *(addr-1);

    last = addr + size - 1;
    *last |= NOT mask;

    if (size > 0)
    {
        while (carry and (size-- > 0))
        {
            carry = (++(*addr++) == 0);
        }
        *last &= mask;
    }
    return(carry);
}

boolean BitVector_decrement(unitptr addr)                   /* X--           */
{
    unit    size;
    unit    mask;
    unitptr last;
    boolean carry = true;

    size = *(addr-2);
    mask = *(addr-1);

    last = addr + size - 1;
    *last &= mask;

    if (size > 0)
    {
        while (carry and (size-- > 0))
        {
            carry = (*addr == 0);
            --(*addr++);
        }
        *last &= mask;
    }
    return(carry);
}

baseptr BitVector_to_String(unitptr addr)
{
    unit    size;
    unit    value;
    unit    count;
    unit    digit;
    unit    length;
    baseptr string;

    size = *(addr-2);
    if (size > 0)
    {
        length = (size * (BITS >> 2)) + 1;
        string = (baseptr) malloc((size_t) length);
        if (string == NULL) return(NULL);
        string += length;
        *(--string) = '\0';
        while (size-- > 0)
        {
            value = *addr++;
            count = (BITS >> 2);
            while (count-- > 0)
            {
                digit = value AND 0x0F;
                value >>= 4;
                if (digit > 9) digit += (unit) 'A' - 10;
                else           digit += (unit) '0';
                *(--string) = (base) digit;
            }
        }
        return(string);
    }
    return(NULL);
}

void BitVector_Dispose(baseptr string)
{
    if (string != NULL) free((voidptr) string);
}

boolean BitVector_from_string(unitptr addr, baseptr string)
{
    unit    size;
    unit    mask;
    unit    length;
    unit    value;
    unit    count;
    int     digit;
    boolean ok = true;

    size = *(addr-2);
    mask = *(addr-1);
    length = strlen(string);
    string += length;
    while (size-- > 0)
    {
        value = 0;
        if (ok and (length > 0))
        {
            for ( count = 0;
                  (ok and (count < BITS) and (length > 0));
                  count += 4 )
            {
                digit = (int) *(--string); length--;
                digit = toupper(digit); /* separate because could be a macro */
                if (ok = (isxdigit(digit) != 0))
                {
                    if (digit >= (int) 'A') digit -= (int) 'A' - 10;
                    else                    digit -= (int) '0';
                    value |= (((unit) digit) << count);
                }
            }
        }
        *addr++ = value;
    }
    *(--addr) &= mask;
    return(ok);
}

    /*******************/
    /* set operations: */
    /*******************/

void Set_Union(unitptr X, unitptr Y, unitptr Z)             /* X = Y + Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ OR *Z++;
        *(--X) &= mask;
    }
}

void Set_Intersection(unitptr X, unitptr Y, unitptr Z)      /* X = Y * Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND *Z++;
        *(--X) &= mask;
    }
}

void Set_Difference(unitptr X, unitptr Y, unitptr Z)        /* X = Y \ Z     */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND NOT *Z++;
        *(--X) &= mask;
    }
}

void Set_ExclusiveOr(unitptr X, unitptr Y, unitptr Z)       /* X=(Y+Z)\(Y*Z) */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ XOR *Z++;
        *(--X) &= mask;
    }
}

void Set_Complement(unitptr X, unitptr Y)                   /* X = ~Y        */
{
    unit size;
    unit mask;

    size = *(X-2);
    mask = *(X-1);
    if (size > 0)
    {
        while (size-- > 0) *X++ = NOT *Y++;
        *(--X) &= mask;
    }
}

    /******************/
    /* set functions: */
    /******************/

boolean Set_subset(unitptr X, unitptr Y)                    /* X subset Y ?  */
{
    unit size;
    boolean r = true;

    size = *(X-2);
    while (r and (size-- > 0)) r = ((*X++ AND NOT *Y++) == 0);
    return(r);
}

N_int Set_Norm(unitptr addr)                                /* = | X |       */
{
    unit c;
    unit size;
    N_int count = 0;

    size = *(addr-2);
    while (size-- > 0)
    {
        c = *addr++;
        while (c)
        {
            if (c AND LSB) ++count;
            c >>= 1;
        }
    }
    return(count);
}

Z_long Set_Min(unitptr addr)                                /* = min(X)      */
{
    unit c;
    unit i;
    unit size;
    boolean empty = true;

    size = *(addr-2);
    i = 0;
    while (empty and (size-- > 0))
    {
        if (c = *addr++) empty = false; else ++i;
    }
    if (empty) return((Z_long) LONG_MAX);                  /* plus infinity  */
    i <<= LOGBITS;
    while (not (c AND LSB))
    {
        c >>= 1;
        ++i;
    }
    return((Z_long) i);
}

Z_long Set_Max(unitptr addr)                                /* = max(X)      */
{
    unit c;
    unit i;
    unit size;
    boolean empty = true;

    size = *(addr-2);
    i = size;
    addr += size-1;
    while (empty and (size-- > 0))
    {
        if (c = *addr--) empty = false; else --i;
    }
    if (empty) return((Z_long) LONG_MIN);                  /* minus infinity */
    i <<= LOGBITS;
    while (not (c AND MSB))
    {
        c <<= 1;
        --i;
    }
    return((Z_long) --i);
}

    /**********************************/
    /* matrix-of-booleans operations: */
    /**********************************/

void Matrix_Multiplication(unitptr X, unit rowsX, unit colsX,
                           unitptr Y, unit rowsY, unit colsY,
                           unitptr Z, unit rowsZ, unit colsZ)
{
    unit i;
    unit j;
    unit k;
    unit indxX;
    unit indxY;
    unit indxZ;
    unit termX;
    unit termY;
    unit sum;

#ifdef ENABLE_BOUNDS_CHECKING
  if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
      (*(X-3) == rowsX*colsX) and
      (*(Y-3) == rowsY*colsY) and
      (*(Z-3) == rowsZ*colsZ))
#else
  if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ))
#endif
  {
    for ( i = 0; i < rowsY; i++ )
    {
        termX = i * colsX;
        termY = i * colsY;
        for ( j = 0; j < colsZ; j++ )
        {
            indxX = termX + j;
            sum = 0;
            for ( k = 0; k < colsY; k++ )
            {
                indxY = termY + k;
                indxZ = k * colsZ + j;
                if ((*(Y+(indxY>>LOGBITS)) AND BITMASKTAB[indxY AND MODMASK]) &&
                    (*(Z+(indxZ>>LOGBITS)) AND BITMASKTAB[indxZ AND MODMASK]))
                    sum ^= 1;
            }
            if (sum)
                 *(X+(indxX>>LOGBITS)) |=     BITMASKTAB[indxX AND MODMASK];
            else
                 *(X+(indxX>>LOGBITS)) &= NOT BITMASKTAB[indxX AND MODMASK];
        }
    }
  }
}

void Matrix_Closure(unitptr addr, unit rows, unit cols)
{
    unit i;
    unit j;
    unit k;
    unit ii;
    unit ij;
    unit ik;
    unit kj;
    unit termi;
    unit termk;

#ifdef ENABLE_BOUNDS_CHECKING
  if ((rows == cols) and (*(addr-3) == rows*cols))
#else
  if (rows == cols)
#endif
  {
    for ( i = 0; i < rows; i++ )
    {
        ii = i * cols + i;
        *(addr+(ii>>LOGBITS)) |= BITMASKTAB[ii AND MODMASK];
    }
    for ( k = 0; k < rows; k++ )
    {
        termk = k * cols;
        for ( i = 0; i < rows; i++ )
        {
            termi = i * cols;
            ik = termi + k;
            for ( j = 0; j < rows; j++ )
            {
                ij = termi + j;
                kj = termk + j;
                if ((*(addr+(ik>>LOGBITS)) AND BITMASKTAB[ik AND MODMASK]) &&
                    (*(addr+(kj>>LOGBITS)) AND BITMASKTAB[kj AND MODMASK]))
                     *(addr+(ij>>LOGBITS)) |=  BITMASKTAB[ij AND MODMASK];
            }
        }
    }
  }
}

/*****************************************************************************/
/*  AUTHOR:  Steffen Beyer                                                   */
/*****************************************************************************/
/*  VERSION:  4.2                                                            */
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
/*****************************************************************************/
/*  COPYRIGHT (C) 1989-1997 BY:  Steffen Beyer                               */
/*****************************************************************************/
#endif
