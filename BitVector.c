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

#define HIDDEN_WORDS 3

    /*****************************************************************/
    /* machine dependent constants (set by "BitVector_Auto_Config"): */
    /*****************************************************************/

static N_word BITS;     /* = # of bits in machine word (must be power of 2)  */
static N_word MODMASK;  /* = BITS - 1 (mask for calculating modulo BITS)     */
static N_word LOGBITS;  /* = ld(BITS) (logarithmus dualis)                   */
static N_word FACTOR;   /* = ld(BITS / 8) (ld of # of bytes)                 */

static N_word LSB = 1;  /* mask for least significant bit                    */
static N_word MSB;      /* mask for most significant bit                     */

static N_word LONGBITS; /* = # of bits in unsigned long                      */

    /********************************************************************/
    /* bit mask table for fast access (set by "BitVector_Auto_Config"): */
    /********************************************************************/

static wordptr BITMASKTAB;

    /*********************************************************/
    /* private low-level functions (potentially dangerous!): */
    /*********************************************************/

static void move_words(wordptr target, wordptr source, N_word count)
{
    if (target == source) return; else
    {
        if (target < source)
        {
            while (count-- > 0) *target++ = *source++;
        }
        else
        {
            target += count;
            source += count;
            while (count-- > 0) *--target = *--source;
        }
    }
}

static void clear_words(wordptr addr, N_word count)
{
    while (count-- > 0) *addr++ = 0;
}

static void insert_words(wordptr addr, N_word total, N_word count, boolean clear)
{
    N_word length;

    if ((total > 0) and (count > 0))
    {
        if (count > total) count = total;
        length = total - count;
        if (length > 0) move_words(addr+count,addr,length);
        if (clear) clear_words(addr,count);
    }
}

static void delete_words(wordptr addr, N_word total, N_word count, boolean clear)
{
    N_word length;

    if ((total > 0) and (count > 0))
    {
        if (count > total) count = total;
        length = total - count;
        if (length > 0) move_words(addr,addr+count,length);
        if (clear) clear_words(addr+length,count);
    }
}

static void reverse(charptr string, N_word length)
{
    charptr last;
    N_char  temp;

    if (length > 1)
    {
        last = string + length - 1;
        while (string < last)
        {
            temp = *string;
            *string = *last;
            *last = temp;
            string++;
            last--;
        }
    }
}

static N_word int2str(charptr string, N_word value)
{
    N_word  length;
    N_word  digit;
    N_word  rest;
    charptr work;

    work = string;
    if (value > 0)
    {
        length = 0;
        while (value > 0)
        {
            rest = (N_word) (value / 10);
            digit = value - (rest * 10);
            digit += (N_word) '0';
            *work++ = (N_char) digit;
            length++;
            value = rest;
        }
        reverse(string,length);
    }
    else
    {
        length = 1;
        *work++ = (N_char) '0';
    }
    return(length);
}

static N_word str2int(charptr string, N_word *value)
{
    N_word  length;
    N_word  digit;

    *value = 0;
    length = 0;
    digit = (N_word) *string++;
    while (isdigit(digit) != 0)
    {
        length++;
        digit -= (N_word) '0';
        *value *= 10;
        *value += digit;
        digit = (N_word) *string++;
    }
    return(length);
}

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

N_word BitVector_Auto_Config(void)
{
    N_long longsample = 1L;
    N_word sample = LSB;
    N_word lsb;

    if (sizeof(N_word) > sizeof(size_t)) return(1);

    BITS = 1;
    while (sample <<= 1) ++BITS;    /* determine # of bits in a machine word */

    if (BITS != (sizeof(N_word) << 3)) return(2);

    if (BITS < 16) return(3);

    LONGBITS = 1;
    while (longsample <<= 1) ++LONGBITS;  /* = # of bits in an unsigned long */

    if (BITS > LONGBITS) return(4);

    LOGBITS = 0;
    sample = BITS;
    lsb = (sample AND LSB);
    while ((sample >>= 1) and (not lsb))
    {
        ++LOGBITS;
        lsb = (sample AND LSB);
    }

    if (sample) return(5);                 /* # of bits is not a power of 2! */

    if (BITS != (LSB << LOGBITS)) return(6);

    MODMASK = BITS - 1;
    FACTOR = LOGBITS - 3;  /* ld(BITS / 8) = ld(BITS) - ld(8) = ld(BITS) - 3 */
    MSB = (LSB << MODMASK);

    BITMASKTAB = (wordptr) malloc((size_t) (BITS << FACTOR));

    if (BITMASKTAB == NULL) return(7);

    for ( sample = 0; sample < BITS; ++sample )
    {
        BITMASKTAB[sample] = (LSB << sample);
    }

    return(0);
}

N_word BitVector_Size(N_int elements)       /* bit vector size (# of words)  */
{
    N_word size;

    size = elements >> LOGBITS;
    if (elements AND MODMASK) ++size;
    return(size);
}

N_word BitVector_Mask(N_int elements)       /* bit vector mask (unused bits) */
{
    N_word mask;

    mask = elements AND MODMASK;
    if (mask) mask = (N_word) ~(~0L << mask); else mask = (N_word) ~0L;
    return(mask);
}

charptr BitVector_Version(void)
{
    return("5.0");
}

N_int BitVector_Word_Bits(void)
{
    return(BITS);
}

N_int BitVector_Long_Bits(void)
{
    return(LONGBITS);
}

wordptr BitVector_Create(N_int elements, boolean clear)     /* malloc        */
{
    N_word  size;
    N_word  mask;
    N_word  bytes;
    wordptr addr;

    addr = NULL;
    size = BitVector_Size(elements);
    mask = BitVector_Mask(elements);
    if (size > 0)
    {
        bytes = (size + HIDDEN_WORDS) << FACTOR;
        addr = (wordptr) malloc((size_t) bytes);
        if (addr != NULL)
        {
            *addr++ = elements;
            *addr++ = size;
            *addr++ = mask;
            if (clear) BitVector_Empty(addr);
        }
    }
    return(addr);
}

wordptr BitVector_Shadow(wordptr addr)    /* create new, same size but empty */
{
    return( BitVector_Create(bits_(addr),true) );
}

wordptr BitVector_Clone(wordptr addr)              /* create exact duplicate */
{
    wordptr copy;

    copy = BitVector_Create(bits_(addr),false);
    if (copy != NULL)
    {
        BitVector_Copy(copy,addr);
    }
    return(copy);
}

wordptr BitVector_Resize(wordptr oldaddr, N_int elements)   /* realloc       */
{
    N_word bytes;
    N_word oldsize;
    N_word newsize;
    N_word oldmask;
    N_word newmask;
    wordptr source;
    wordptr target;
    wordptr newaddr;

    newaddr = NULL;
    newsize = BitVector_Size(elements);
    newmask = BitVector_Mask(elements);
    oldsize = size_(oldaddr);
    oldmask = mask_(oldaddr);
    if ((oldsize > 0) and (newsize > 0))
    {
        *(oldaddr+oldsize-1) &= oldmask;
        if (oldsize >= newsize)
        {
            newaddr = oldaddr;
            bits_(newaddr) = elements;
            size_(newaddr) = newsize;
            mask_(newaddr) = newmask;
            *(newaddr+newsize-1) &= newmask;
        }
        else
        {
            bytes = (newsize + HIDDEN_WORDS) << FACTOR;
            newaddr = (wordptr) malloc((size_t) bytes);
            if (newaddr != NULL)
            {
                *newaddr++ = elements;
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

void BitVector_Destroy(wordptr addr)                        /* free          */
{
    if (addr != NULL)
    {
        addr -= HIDDEN_WORDS;
        free((voidptr) addr);
    }
}

void BitVector_Copy(wordptr X, wordptr Y)                           /* X = Y */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++;
        *(--X) &= mask;
    }
}

void BitVector_Empty(wordptr addr)                        /* X = {}  clr all */
{
    N_word size = size_(addr);

    while (size-- > 0) *addr++ = 0;
}

void BitVector_Fill(wordptr addr)                         /* X = ~{} set all */
{
    N_word size = size_(addr);
    N_word mask = mask_(addr);
    N_word fill = (N_word) ~0L;

    if (size > 0)
    {
        while (size-- > 0) *addr++ = fill;
        *(--addr) &= mask;
    }
}

void BitVector_Flip(wordptr addr)                         /* X = ~X flip all */
{
    N_word size = size_(addr);
    N_word mask = mask_(addr);
    N_word fill = (N_word) ~0L;

    if (size > 0)
    {
        while (size-- > 0) *addr++ ^= fill;
        *(--addr) &= mask;
    }
}

void BitVector_Primes(wordptr addr)
{
    N_word  bits = bits_(addr);
    N_word  size = size_(addr);
    wordptr work;
    N_word  temp;
    N_word  i,j;

    temp = 0xAAAA;
    i = BITS >> 4;
    while (--i > 0)
    {
        temp <<= 16;
        temp |= 0xAAAA;
    }
    i = size;
    work = addr;
    *work++ = temp XOR 0x0006;
    while (--i > 0) *work++ = temp;
    for ( i = 3; (j = i * i) < bits; i += 2 )
    {
        for ( ; j < bits; j += i )
        {
            *(addr+(j>>LOGBITS)) &= NOT BITMASKTAB[j AND MODMASK];
        }
    }
    *(addr+size-1) &= mask_(addr);
}

void BitVector_Interval_Empty(wordptr addr, N_int lower, N_int upper)
{                                                  /* X = X \ [lower..upper] */
    wordptr loaddr;
    wordptr hiaddr;
    N_word  lobase;
    N_word  hibase;
    N_word  lomask;
    N_word  himask;
    N_word  size;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = (N_word)   (~0L << (lower AND MODMASK));
    himask = (N_word) ~((~0L << (upper AND MODMASK)) << 1);

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

void BitVector_Interval_Fill(wordptr addr, N_int lower, N_int upper)
{                                                  /* X = X + [lower..upper] */
    wordptr loaddr;
    wordptr hiaddr;
    N_word  lobase;
    N_word  hibase;
    N_word  lomask;
    N_word  himask;
    N_word  size;
    N_word  fill;

    fill = (N_word) ~0L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = (N_word)   (~0L << (lower AND MODMASK));
    himask = (N_word) ~((~0L << (upper AND MODMASK)) << 1);

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
    *(addr+size_(addr)-1) &= mask_(addr);
}

void BitVector_Interval_Flip(wordptr addr, N_int lower, N_int upper)
{                                                  /* X = X ^ [lower..upper] */
    wordptr loaddr;
    wordptr hiaddr;
    N_word  lobase;
    N_word  hibase;
    N_word  lomask;
    N_word  himask;
    N_word  size;
    N_word  fill;

    fill = (N_word) ~0L;

    lobase = lower >> LOGBITS;
    hibase = upper >> LOGBITS;
    size = hibase - lobase;
    loaddr = addr + lobase;
    hiaddr = addr + hibase;

    lomask = (N_word)   (~0L << (lower AND MODMASK));
    himask = (N_word) ~((~0L << (upper AND MODMASK)) << 1);

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
    *(addr+size_(addr)-1) &= mask_(addr);
}

boolean BitVector_interval_scan_inc(wordptr addr, N_int start,
                                    N_intptr min, N_intptr max)
{
    N_word size;
    N_word mask;
    N_word offset;
    N_word bitmask;
    N_word value;
    boolean empty;

    *min = start;
    *max = start;

    size = size_(addr);
    mask = mask_(addr);

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

boolean BitVector_interval_scan_dec(wordptr addr, N_int start,
                                    N_intptr min, N_intptr max)
{
    N_word size;
    N_word mask;
    N_word offset;
    N_word bitmask;
    N_word value;
    boolean empty;

    *min = start;
    *max = start;

    size = size_(addr);
    mask = mask_(addr);

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

void BitVector_Interval_Copy(wordptr X, wordptr Y, N_int Xoffset,
                             N_int Yoffset, N_int length)
{
    wordptr Z = X;
    N_word  source;
    N_word  target;
    N_word  s_lo_base;
    N_word  s_hi_base;
    N_word  s_lo_bit;
    N_word  s_hi_bit;
    N_word  s_base;
    N_word  s_lower;
    N_word  s_upper;
    N_word  s_bits;
    N_word  s_min;
    N_word  s_max;
    N_word  t_lo_base;
    N_word  t_hi_base;
    N_word  t_lo_bit;
    N_word  t_hi_bit;
    N_word  t_base;
    N_word  t_lower;
    N_word  t_upper;
    N_word  t_bits;
    N_word  t_min;
    N_word  mask;
    N_word  bits;
    boolean ascending;
    boolean notfirst;
    N_word  select;

    if (length > 0)
    {
        ascending = (Xoffset <= Yoffset);

        s_lo_base = Yoffset >> LOGBITS;
        s_lo_bit = Yoffset AND MODMASK;
        Yoffset += --length;
        s_hi_base = Yoffset >> LOGBITS;
        s_hi_bit = Yoffset AND MODMASK;

        t_lo_base = Xoffset >> LOGBITS;
        t_lo_bit = Xoffset AND MODMASK;
        Xoffset += length;
        t_hi_base = Xoffset >> LOGBITS;
        t_hi_bit = Xoffset AND MODMASK;

        if (ascending)
        {
            s_base = s_lo_base;
            t_base = t_lo_base;
        }
        else
        {
            s_base = s_hi_base;
            t_base = t_hi_base;
        }
        s_bits = 0;
        t_bits = 0;
        Y += s_base;
        X += t_base;
        notfirst = false;
        while (true)
        {
            if (t_bits == 0)
            {
                if (notfirst)
                {
                    *X = target;
                    if (ascending)
                    {
                        if (t_base == t_hi_base) break;
                        t_base++;
                        X++;
                    }
                    else
                    {
                        if (t_base == t_lo_base) break;
                        t_base--;
                        X--;
                    }
                }
                select = ((t_base == t_hi_base) << 1) OR (t_base == t_lo_base);
                switch (select)
                {
                    case 0:
                        t_lower = 0;
                        t_upper = BITS - 1;
                        t_bits = BITS;
                        target = 0;
                        break;
                    case 1:
                        t_lower = t_lo_bit;
                        t_upper = BITS - 1;
                        t_bits = BITS - t_lo_bit;
                        mask = (N_word) (~0L << t_lower);
                        target = *X AND NOT mask;
                        break;
                    case 2:
                        t_lower = 0;
                        t_upper = t_hi_bit;
                        t_bits = t_hi_bit + 1;
                        mask = (N_word) ((~0L << t_upper) << 1);
                        target = *X AND mask;
                        break;
                    case 3:
                        t_lower = t_lo_bit;
                        t_upper = t_hi_bit;
                        t_bits = t_hi_bit - t_lo_bit + 1;
                        mask = (N_word) (~0L << t_lower);
                        mask &= (N_word) ~((~0L << t_upper) << 1);
                        target = *X AND NOT mask;
                        break;
                }
            }
            if (s_bits == 0)
            {
                if (notfirst)
                {
                    if (ascending)
                    {
                        if (s_base == s_hi_base) break;
                        s_base++;
                        Y++;
                    }
                    else
                    {
                        if (s_base == s_lo_base) break;
                        s_base--;
                        Y--;
                    }
                }
                source = *Y;
                select = ((s_base == s_hi_base) << 1) OR (s_base == s_lo_base);
                switch (select)
                {
                    case 0:
                        s_lower = 0;
                        s_upper = BITS - 1;
                        s_bits = BITS;
                        break;
                    case 1:
                        s_lower = s_lo_bit;
                        s_upper = BITS - 1;
                        s_bits = BITS - s_lo_bit;
                        break;
                    case 2:
                        s_lower = 0;
                        s_upper = s_hi_bit;
                        s_bits = s_hi_bit + 1;
                        break;
                    case 3:
                        s_lower = s_lo_bit;
                        s_upper = s_hi_bit;
                        s_bits = s_hi_bit - s_lo_bit + 1;
                        break;
                }
            }
            notfirst = true;
            if (s_bits > t_bits)
            {
                bits = t_bits - 1;
                if (ascending)
                {
                    s_min = s_lower;
                    s_max = s_lower + bits;
                }
                else
                {
                    s_max = s_upper;
                    s_min = s_upper - bits;
                }
                t_min = t_lower;
            }
            else
            {
                bits = s_bits - 1;
                if (ascending) t_min = t_lower;
                else           t_min = t_upper - bits;
                s_min = s_lower;
                s_max = s_upper;
            }
            bits++;
            mask = (N_word) (~0L << s_min);
            mask &= (N_word) ~((~0L << s_max) << 1);
            if (s_min == t_min) target |= (source AND mask);
            else
            {
                if (s_min < t_min) target |= (source AND mask) << (t_min-s_min);
                else               target |= (source AND mask) >> (s_min-t_min);
            }
            if (ascending)
            {
                s_lower += bits;
                t_lower += bits;
            }
            else
            {
                s_upper -= bits;
                t_upper -= bits;
            }
            s_bits -= bits;
            t_bits -= bits;
        }
    }
    *(Z+size_(Z)-1) &= mask_(Z);
}

wordptr BitVector_Interval_Substitute(wordptr X, wordptr Y,
                                      N_int Xoffset, N_int Xlength,
                                      N_int Yoffset, N_int Ylength)
{
    N_word Xbits = bits_(X);
    N_word Ybits = bits_(Y);
    N_word diff;

    /*
       Requirements:
         -  Xoffset must be <= Xbits (note the "<="!) and
            Yoffset must be <= Ybits (note the "<="!)
         -  Xoffset + Xlength must also be <= Xbits,
            as well as Yoffset + Ylength <= Ybits
            (if they aren't, reduce Xlength or Ylength accordingly!)
         -  if Xlength is equal to Xbits (substituting the whole vector),
            then Ylength may not be zero (zero length vectors are forbidden!)
    */

    if (Xlength != Ylength)
    {
        if (Xlength > Ylength)
        {
            diff = Xlength - Ylength;
            if ((Xoffset + Xlength) < Xbits) BitVector_Delete(X,Xoffset,diff);
            if ((X = BitVector_Resize(X,Xbits-diff)) == NULL) return(NULL);
        }
        else
        {
            diff = Ylength - Xlength;
            if ((X = BitVector_Resize(X,Xbits+diff)) == NULL) return(NULL);
            if ((Xoffset + Xlength) < Xbits) BitVector_Insert(X,Xoffset,diff);
        }
    }
    if (Ylength > 0) BitVector_Interval_Copy(X,Y,Xoffset,Yoffset,Ylength);
    return(X);
}

boolean BitVector_is_empty(wordptr addr)                    /* X == {} ?     */
{
    N_word size = size_(addr);
    boolean r = true;

    *(addr+size-1) &= mask_(addr);
    while (r and (size-- > 0)) r = ( *addr++ == 0 );
    return(r);
}

boolean BitVector_is_full(wordptr addr)                     /* X == ~{} ?    */
{
    N_word  size;
    N_word  mask;
    wordptr last;
    boolean r = true;

    size = size_(addr);
    mask = mask_(addr);
    last = addr + size - 1;
    *last |= NOT mask;
    while (r and (size-- > 0)) r = ( NOT *addr++ == 0 );
    *last &= mask;
    return(r);
}

boolean BitVector_equal(wordptr X, wordptr Y)               /* X == Y ?      */
{
    N_word size = size_(X);
    boolean r = true;

    while (r and (size-- > 0)) r = (*X++ == *Y++);
    return(r);
}

Z_int BitVector_Compare(wordptr X, wordptr Y)               /* X <,=,> Y ?   */
{
    N_word size = size_(X);
    boolean r = true;

    X += size;
    Y += size;
    while (r and (size-- > 0)) r = (*(--X) == *(--Y));
    if (r) return((Z_int) 0);
    else
    {
        if (*X < *Y) return((Z_int) -1); else return((Z_int) 1);
    }
}

charptr BitVector_to_Hex(wordptr addr)
{
    N_word  size = size_(addr);
    N_word  value;
    N_word  count;
    N_word  digit;
    N_word  length;
    charptr string;

    length = (size * (BITS >> 2)) + 1;
    string = (charptr) malloc((size_t) length);
    if (string == NULL) return(NULL);
    *(addr+size-1) &= mask_(addr);
    string += length;
    *(--string) = (N_char) '\0';
    while (size-- > 0)
    {
        value = *addr++;
        count = BITS >> 2;
        while (count-- > 0)
        {
            digit = value AND 0x000F;
            if (digit > 9) digit += (N_word) 'A' - 10;
            else           digit += (N_word) '0';
            *(--string) = (N_char) digit;
            if (count > 0) value >>= 4;
        }
    }
    return(string);
}

boolean BitVector_from_hex(wordptr addr, charptr string)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    boolean ok = true;
    N_word  length;
    N_word  value;
    N_word  count;
    int     digit;

    length = strlen((char *) string);
    string += length;
    while (size-- > 0)
    {
        value = 0;
        for ( count = 0; (ok and (length > 0) and (count < BITS)); count += 4 )
        {
            digit = (int) *(--string); length--;
            digit = toupper(digit); /* separate because could be a macro */
            if (ok = (isxdigit(digit) != 0))
            {
                if (digit >= (int) 'A') digit -= (int) 'A' - 10;
                else                    digit -= (int) '0';
                value |= (((N_word) digit) << count);
            }
        }
        *addr++ = value;
    }
    *(--addr) &= mask;
    return(ok);
}

charptr BitVector_to_Bin(wordptr addr)
{
    N_word  size = size_(addr);
    N_word  value;
    N_word  count;
    N_word  digit;
    N_word  length;
    charptr string;

    length = bits_(addr);
    string = (charptr) malloc((size_t) (length+1));
    if (string == NULL) return(NULL);
    *(addr+size-1) &= mask_(addr);
    string += length;
    *string = (N_char) '\0';
    while (size-- > 0)
    {
        value = *addr++;
        count = BITS;
        if (count > length) count = length;
        while (count-- > 0)
        {
            digit = value AND 0x0001;
            digit += (N_word) '0';
            *(--string) = (N_char) digit; length--;
            if (count > 0) value >>= 1;
        }
    }
    return(string);
}

boolean BitVector_from_bin(wordptr addr, charptr string)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    boolean ok = true;
    N_word  length;
    N_word  value;
    N_word  count;
    int     digit;

    length = strlen((char *) string);
    string += length;
    while (size-- > 0)
    {
        value = 0;
        for ( count = 0; (ok and (length > 0) and (count < BITS)); count++ )
        {
            digit = (int) *(--string); length--;
            switch (digit)
            {
                case (int) '0':
                    break;
                case (int) '1':
                    value |= BITMASKTAB[count];
                    break;
                default:
                    ok = false;
                    break;
            }
        }
        *addr++ = value;
    }
    *(--addr) &= mask;
    return(ok);
}

charptr BitVector_to_Dec(wordptr addr)
{
    N_word  bits;
    charptr result;
    N_word  length;
    charptr string;
    N_word  digits;
    wordptr quot;
    wordptr rest;
    wordptr temp;
    wordptr base;
    Z_int   sign;

    bits = bits_(addr);
    length = (N_word) (bits / 3.3);        /* digits = bits * ld(2) / ld(10) */
    length += 2; /* compensate for truncating & provide space for minus sign */
    result = (charptr) malloc((size_t) (length+1));    /* remember the '\0'! */
    if (result == NULL) return(NULL);
    string = result;
    sign = BitVector_Sign(addr);
    if ((bits < 4) or (sign == 0))
    {
        digits = *addr;
        if (sign < 0) digits = ((NOT digits)+1) AND mask_(addr);
        *string++ = (N_char) digits + (N_char) '0';
        digits = 1;
    }
    else
    {
        digits = 0;
        quot = BitVector_Create(bits,false);
        if (quot == NULL)
        {
            BitVector_Dispose(result);
            return(NULL);
        }
        rest = BitVector_Create(bits,false);
        if (rest == NULL)
        {
            BitVector_Dispose(result);
            BitVector_Destroy(quot);
            return(NULL);
        }
        temp = BitVector_Create(bits,false);
        if (temp == NULL)
        {
            BitVector_Dispose(result);
            BitVector_Destroy(quot);
            BitVector_Destroy(rest);
            return(NULL);
        }
        base = BitVector_Create(bits,true);
        if (base == NULL)
        {
            BitVector_Dispose(result);
            BitVector_Destroy(quot);
            BitVector_Destroy(rest);
            BitVector_Destroy(temp);
            return(NULL);
        }
        *base = (N_word) 10;
        if (sign < 0) BitVector_Negate(quot,addr);
        else           BitVector_Copy(quot,addr);
        while ((not BitVector_is_empty(quot)) and (digits < length))
        {
            BitVector_Copy(temp,quot);
            BitVector_Div_Pos(quot,temp,base,rest);
            *string++ = (N_char) *rest + (N_char) '0';
            digits++;
        }
        BitVector_Destroy(quot);
        BitVector_Destroy(rest);
        BitVector_Destroy(temp);
        BitVector_Destroy(base);
    }
    if ((sign < 0) and (digits < length))
    {
        *string++ = (N_char) '-';
        digits++;
    }
    *string = (N_char) '\0';
    reverse(result,digits);
    return(result);
}

boolean BitVector_from_dec(wordptr addr, charptr string)
{
    N_word  bits = bits_(addr);
    boolean ok = true;
    boolean minus;
    wordptr term;
    wordptr prod;
    wordptr temp;
    wordptr rank;
    wordptr base;
    N_word  length;
    int     digit;

    length = strlen((char *) string);
    if (length == 0) return(false);
    digit = (int) *string;
    if ((minus = (digit == (int) '-')) or
                 (digit == (int) '+'))
    {
        string++;
        if (--length == 0) return(false);
    }
    string += length;
    term = BitVector_Create(4,false);
    if (term == NULL) return(false);
    prod = BitVector_Create(bits,false);
    if (prod == NULL)
    {
        BitVector_Destroy(term);
        return(false);
    }
    temp = BitVector_Create(bits,false);
    if (temp == NULL)
    {
        BitVector_Destroy(term);
        BitVector_Destroy(prod);
        return(false);
    }
    rank = BitVector_Create(bits,true);
    if (rank == NULL)
    {
        BitVector_Destroy(term);
        BitVector_Destroy(prod);
        BitVector_Destroy(temp);
        return(false);
    }
    *rank = (N_word) 1;
    base = BitVector_Create(4,false);
    if (base == NULL)
    {
        BitVector_Destroy(term);
        BitVector_Destroy(prod);
        BitVector_Destroy(temp);
        BitVector_Destroy(rank);
        return(false);
    }
    *base = (N_word) 10;
    BitVector_Empty(addr);
    while (ok and (length > 0))
    {
        digit = (int) *(--string); length--;
        if (ok = (isdigit(digit) != 0))
        {
            *term = (N_word) digit - (N_word) '0';
            BitVector_Copy(temp,rank);
            if (ok = BitVector_Mul_Pos(prod,temp,term))
            {
                if ((ok = not BitVector_add(addr,addr,prod,0)) and (length > 0))
                {
                    BitVector_Copy(temp,rank);
                    ok = BitVector_Mul_Pos(rank,temp,base);
                }
            }
        }
    }
    BitVector_Destroy(term);
    BitVector_Destroy(prod);
    BitVector_Destroy(temp);
    BitVector_Destroy(rank);
    BitVector_Destroy(base);
    if (ok and minus) BitVector_Negate(addr,addr);
    return(ok);
}

charptr BitVector_to_Enum(wordptr addr)
{
    N_word  bits = bits_(addr);
    charptr string;
    charptr target;
    N_word  sample;
    N_word  length;
    N_word  digits;
    N_word  factor;
    N_word  power;
    boolean comma;
    N_word  start;
    N_word  min;
    N_word  max;

    sample = bits - 1;  /* greatest possible index */
    length = 2;         /* account for index 0 and terminating '\0' */
    digits = 1;         /* account for intervening dashes and commas */
    factor = 1;
    power = 10;
    while (sample >= (power-1))
    {
        length += ++digits * factor * 6;  /* 9,90,900,9000,... (9*2/3 = 6) */
        factor = power;
        power *= 10;
    }
    if (sample > --factor)
    {
        sample -= factor;
        factor = (N_word) ( sample / 3 );
        factor = (factor << 1) + (sample - (factor * 3));
        length += ++digits * factor;
    }
    string = (charptr) malloc((size_t) length);
    if (string == NULL) return(NULL);
    start = 0;
    comma = false;
    target = string;
    while ((start < bits) and BitVector_interval_scan_inc(addr,start,&min,&max))
    {
        start = max + 2;
        if (comma) *target++ = (N_char) ',';
        if (min == max)
        {
            target += int2str(target,min);
        }
        else
        {
            if (min+1 == max)
            {
                target += int2str(target,min);
                *target++ = (N_char) ',';
                target += int2str(target,max);
            }
            else
            {
                target += int2str(target,min);
                *target++ = (N_char) '-';
                target += int2str(target,max);
            }
        }
        comma = true;
    }
    *target = (N_char) '\0';
    return(string);
}

boolean BitVector_from_enum(wordptr addr, charptr string)
{
    N_word  bits = bits_(addr);
    N_word  state;
    N_word  token;
    N_word  index;
    N_word  start;
    boolean ok;

    BitVector_Empty(addr);
    ok = true;
    state = 1;
    while (ok and (state != 0))
    {
        token = (N_word) *string;
        if (isdigit(token) != 0)
        {
            string += str2int(string,&index);
            if (index < bits) token = (N_word) '0';
            else ok = false;
        }
        else string++;
        if (ok)
        switch (state)
        {
            case 1:
                switch (token)
                {
                    case (N_word) '0':
                        state = 2;
                        break;
                    case (N_word) '\0':
                        state = 0;
                        break;
                    default:
                        ok = false;
                        break;
                }
                break;
            case 2:
                switch (token)
                {
                    case (N_word) '-':
                        start = index;
                        state = 3;
                        break;
                    case (N_word) ',':
                        *(addr+(index>>LOGBITS)) |=
                          BITMASKTAB[index AND MODMASK];
                        state = 5;
                        break;
                    case (N_word) '\0':
                        *(addr+(index>>LOGBITS)) |=
                          BITMASKTAB[index AND MODMASK];
                        state = 0;
                        break;
                    default:
                        ok = false;
                        break;
                }
                break;
            case 3:
                switch (token)
                {
                    case (N_word) '0':
                        if (start < index)
                          BitVector_Interval_Fill(addr,start,index);
                        else ok = false;
                        state = 4;
                        break;
                    default:
                        ok = false;
                        break;
                }
                break;
            case 4:
                switch (token)
                {
                    case (N_word) ',':
                        state = 5;
                        break;
                    case (N_word) '\0':
                        state = 0;
                        break;
                    default:
                        ok = false;
                        break;
                }
                break;
            case 5:
                switch (token)
                {
                    case (N_word) '0':
                        state = 2;
                        break;
                    default:
                        ok = false;
                        break;
                }
                break;
        }
    }
    return(ok);
}

void BitVector_Dispose(charptr string)
{
    if (string != NULL) free((voidptr) string);
}

void BitVector_Bit_Off(wordptr addr, N_int index)           /* X = X \ {x}   */
{
    *(addr+(index>>LOGBITS)) &= NOT BITMASKTAB[index AND MODMASK];
}

void BitVector_Bit_On(wordptr addr, N_int index)            /* X = X + {x}   */
{
    *(addr+(index>>LOGBITS)) |= BITMASKTAB[index AND MODMASK];
}

boolean BitVector_bit_flip(wordptr addr, N_int index)   /* X=(X+{x})\(X*{x}) */
{
    N_word mask;

    return( (
        ( *(addr+(index>>LOGBITS)) ^= (mask = BITMASKTAB[index AND MODMASK]) )
        AND mask ) != 0 );
}

boolean BitVector_bit_test(wordptr addr, N_int index)       /* {x} in X ?    */
{
    return( (*(addr+(index>>LOGBITS)) AND BITMASKTAB[index AND MODMASK]) != 0 );
}

void BitVector_Bit_Copy(wordptr addr, N_int index, boolean bit)
{
    if (bit) *(addr+(index>>LOGBITS)) |= BITMASKTAB[index AND MODMASK];
    else     *(addr+(index>>LOGBITS)) &= NOT BITMASKTAB[index AND MODMASK];
}

boolean BitVector_lsb(wordptr addr)
{
    return( (*addr AND LSB) != 0 );
}

boolean BitVector_msb(wordptr addr)
{
    N_word size = size_(addr);
    N_word mask = mask_(addr);

    return( (*(addr+size-1) AND (mask AND NOT (mask >> 1))) != 0 );
}

boolean BitVector_rotate_left(wordptr addr)
{
    N_word  size;
    N_word  mask;
    N_word  msb;
    boolean carry_in;
    boolean carry_out;

    size = size_(addr);
    mask = mask_(addr);
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

boolean BitVector_rotate_right(wordptr addr)
{
    N_word  size;
    N_word  mask;
    N_word  msb;
    boolean carry_in;
    boolean carry_out;

    size = size_(addr);
    mask = mask_(addr);
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

boolean BitVector_shift_left(wordptr addr, boolean carry_in)
{
    N_word  size;
    N_word  mask;
    N_word  msb;
    boolean carry_out;

    size = size_(addr);
    mask = mask_(addr);
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

boolean BitVector_shift_right(wordptr addr, boolean carry_in)
{
    N_word  size;
    N_word  mask;
    N_word  msb;
    boolean carry_out;

    size = size_(addr);
    mask = mask_(addr);
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

void BitVector_Move_Left(wordptr addr, N_int bits)
{
    N_word count;
    N_word words;

    if (bits > 0)
    {
        count = bits AND MODMASK;
        words = bits >> LOGBITS;
        if (bits >= bits_(addr)) BitVector_Empty(addr);
        else
        {
            while (count-- > 0) BitVector_shift_left(addr,0);
            BitVector_Word_Insert(addr,0,words,true);
        }
    }
}

void BitVector_Move_Right(wordptr addr, N_int bits)
{
    N_word count;
    N_word words;

    if (bits > 0)
    {
        count = bits AND MODMASK;
        words = bits >> LOGBITS;
        if (bits >= bits_(addr)) BitVector_Empty(addr);
        else
        {
            while (count-- > 0) BitVector_shift_right(addr,0);
            BitVector_Word_Delete(addr,0,words,true);
        }
    }
}

void BitVector_Insert(wordptr addr, N_int offset, N_int count)
{
    N_word bits = bits_(addr);
    N_word last;

    if ((count > 0) and (offset < bits))
    {
        last = offset + count;
        if (last < bits)
        {
            BitVector_Interval_Copy(addr,addr,last,offset,(bits-last));
        }
        else last = bits;
        BitVector_Interval_Empty(addr,offset,(last-1));
    }
}

void BitVector_Delete(wordptr addr, N_int offset, N_int count)
{
    N_word bits = bits_(addr);
    N_word last;

    if ((count > 0) and (offset < bits))
    {
        last = offset + count;
        if (last < bits)
        {
            BitVector_Interval_Copy(addr,addr,offset,last,(bits-last));
        }
        else count = bits - offset;
        BitVector_Interval_Empty(addr,(bits-count),(bits-1));
    }
}

boolean BitVector_increment(wordptr addr)                   /* X++           */
{
    N_word  size  = size_(addr);
    N_word  mask  = mask_(addr);
    wordptr last  = addr + size - 1;
    boolean carry = true;

    if (size > 0)
    {
        *last |= NOT mask;
        while (carry and (size-- > 0))
        {
            carry = (++(*addr++) == 0);
        }
        *last &= mask;
    }
    return(carry);
}

boolean BitVector_decrement(wordptr addr)                   /* X--           */
{
    N_word  size  = size_(addr);
    N_word  mask  = mask_(addr);
    wordptr last  = addr + size - 1;
    boolean carry = true;

    if (size > 0)
    {
        *last &= mask;
        while (carry and (size-- > 0))
        {
            carry = (*addr == 0);
            --(*addr++);
        }
        *last &= mask;
    }
    return(carry);
}

boolean BitVector_add(wordptr X, wordptr Y, wordptr Z, boolean carry)
{
    N_word size;
    N_word mask;
    N_word yy;
    N_word zz;
    N_word lo;
    N_word hi;

    size = size_(X);
    mask = mask_(X);
    if (size > 0)
    {
        while (size-- > 0)
        {
            yy = *Y++;
            zz = *Z++;
            lo = (yy AND LSB) + (zz AND LSB) + (carry AND LSB);
            hi = (yy >> 1) + (zz >> 1) + (lo >> 1);
            carry = ((hi AND MSB) != 0);
            *X++ = (hi << 1) OR (lo AND LSB);
        }
        X--;
        if (NOT mask) carry = ((*X AND (mask+1)) != 0);
        *X &= mask;
    }
    return(carry);
}

boolean BitVector_subtract(wordptr X, wordptr Y, wordptr Z, boolean carry)
{
    N_word  size;
    N_word  mask;
    N_word  yy;
    N_word  zz;
    N_word  lo;
    N_word  hi;

    size = size_(X);
    mask = mask_(X);
    if (size > 0)
    {
        carry = not carry;
        while (size-- > 0)
        {
            yy = *Y++;
            zz = NOT *Z++;
            if (size == 0) zz &= mask;
            lo = (yy AND LSB) + (zz AND LSB) + (carry AND LSB);
            hi = (yy >> 1) + (zz >> 1) + (lo >> 1);
            carry = ((hi AND MSB) != 0);
            *X++ = (hi << 1) OR (lo AND LSB);
        }
        X--;
        if (NOT mask) carry = ((*X AND (mask+1)) != 0);
        *X &= mask;
        carry = not carry;
    }
    return(carry);
}

void BitVector_Negate(wordptr X, wordptr Y)
{
    N_word  size  = size_(X);
    N_word  mask  = mask_(X);
    boolean carry = true;

    if (size > 0)
    {
        while (size-- > 0)
        {
            *X = NOT *Y++;
            if (carry)
            {
                carry = (++(*X) == 0);
            }
            X++;
        }
        *(--X) &= mask;
    }
}

void BitVector_Absolute(wordptr X, wordptr Y)
{
    N_word size = size_(Y);
    N_word mask = mask_(Y);

    if (*(Y+size-1) AND (mask AND NOT (mask >> 1))) BitVector_Negate(X,Y);
    else                                             BitVector_Copy(X,Y);
}

Z_int BitVector_Sign(wordptr addr)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    wordptr last = addr + size - 1;
    boolean r    = true;

    *last &= mask;

    while (r and (size-- > 0)) r = ( *addr++ == 0 );

    if (r) return((Z_int) 0);
    else
    {
        if (*last AND (mask AND NOT (mask >> 1))) return((Z_int) -1);
        else                                      return((Z_int)  1);
    }
}

boolean BitVector_Mul_Pos(wordptr X, wordptr Y, wordptr Z)
{
    Z_long  max;
    N_int   limit;
    N_int   count;
    boolean ok = true;

    /*
       Requirements:
         -  X and Y must have equal sizes (whereas Z may be any size!)
         -  Z should always contain the smaller of the two factors Y and Z
       Constraints:
         -  The contents of Y (and of X, of course) are destroyed
            (only Z is preserved!)
    */

    BitVector_Empty(X);
    if (BitVector_is_empty(Y)) return(true);
    if ((max = Set_Max(Z)) < 0L) return(true);
    limit = (N_int) max;
    for ( count = 0; (ok and (count <= limit)); count++ )
    {
        if ((*(Z+(count>>LOGBITS)) AND BITMASKTAB[count AND MODMASK]) != 0)
            ok = not BitVector_add(X,X,Y,0);
        if (ok and (count < limit))
            ok = not BitVector_shift_left(Y,0);
    }
    return(ok);
}

N_int BitVector_Multiply(wordptr X, wordptr Y, wordptr Z)
{
    N_word  bit_x = bits_(X);
    N_word  bit_y = bits_(Y);
    N_word  bit_z = bits_(Z);
    boolean zero = true;
    boolean ok = true;
    N_word  size;
    N_word  mask;
    N_word  msb;
    wordptr ptr_x;
    wordptr ptr_y;
    wordptr ptr_z;
    boolean sgn_x;
    boolean sgn_y;
    boolean sgn_z;
    wordptr A;
    wordptr B;

    /*
       Requirements:
         -  Y and Z must have equal sizes
         -  X must have at least the same size as Y and Z but may be larger (!)
       Features:
         -  The contents of Y and Z are preserved
         -  X may be identical with Y or Z (or both!)
            (in-place multiplication is possible!)
    */

    if (BitVector_is_empty(Y) or BitVector_is_empty(Z))
    {
        BitVector_Empty(X);
    }
    else
    {
        A = BitVector_Create((N_int) bit_y, false);
        if (A == NULL) return(1);
        B = BitVector_Create((N_int) bit_z, false);
        if (B == NULL) { BitVector_Destroy(A); return(1); }
        size  = size_(Y);
        mask  = mask_(Y);
        msb   = (mask AND NOT (mask >> 1));
        sgn_y = (((*(Y+size-1) &= mask) AND msb) != 0);
        sgn_z = (((*(Z+size-1) &= mask) AND msb) != 0);
        sgn_x = sgn_y XOR sgn_z;
        if (sgn_y) BitVector_Negate(A,Y); else BitVector_Copy(A,Y);
        if (sgn_z) BitVector_Negate(B,Z); else BitVector_Copy(B,Z);
        ptr_y = A + size;
        ptr_z = B + size;
        while (zero and (size-- > 0))
        {
            zero = ((*(--ptr_y) == 0) and (*(--ptr_z) == 0));
        }
        mask  = mask_(X);
        msb   = (mask AND NOT (mask >> 1));
        ptr_x = X + size_(X) - 1;
        if (*ptr_y > *ptr_z)
        {
            if (bit_x > bit_y)
            {
                A = BitVector_Resize(A, (N_int) bit_x);
                if (A == NULL) { BitVector_Destroy(B); return(1); }
            }
            ok = (BitVector_Mul_Pos(X,A,B) and ((*ptr_x AND msb) == 0));
        }
        else
        {
            if (bit_x > bit_z)
            {
                B = BitVector_Resize(B, (N_int) bit_x);
                if (B == NULL) { BitVector_Destroy(A); return(1); }
            }
            ok = (BitVector_Mul_Pos(X,B,A) and ((*ptr_x AND msb) == 0));
        }
        if (ok and sgn_x) BitVector_Negate(X,X);
        BitVector_Destroy(A);
        BitVector_Destroy(B);
    }
    if (ok) return(0); else return(2);
}

void BitVector_Div_Pos(wordptr Q, wordptr X, wordptr Y, wordptr R)
{
    N_word  bits  = bits_(Q);
    boolean carry = false;
    boolean valid = true; /* flags wether valid rest is in R (t) or X (f) */

    /*
       Requirements:
         -  All bit vectors must have equal sizes
         -  Q, X, Y and R must all be distinct bit vectors
         -  Y must be non-zero (of course!)
       Constraints:
         -  The contents of X (and Q and R, of course) are destroyed
            (only Y is preserved!)
    */

    BitVector_Empty(R);
    if (BitVector_is_empty(X))
    {
        BitVector_Empty(Q);
    }
    else
    {
        BitVector_Copy(Q,X);
        while (bits-- > 0)
        {
            carry = BitVector_shift_left(Q,carry);
            if (valid)
            {
                BitVector_shift_left(R,carry);
                carry = not BitVector_subtract(X,R,Y,0);
                if (carry) valid = false;
            }
            else
            {
                BitVector_shift_left(X,carry);
                carry = not BitVector_subtract(R,X,Y,0);
                if (carry) valid = true;
            }
        }
        BitVector_shift_left(Q,carry);
        if (not valid) BitVector_Copy(R,X);
    }
}

boolean BitVector_Divide(wordptr Q, wordptr X, wordptr Y, wordptr R)
{
    N_word  bits = bits_(Q);
    N_word  size = size_(Q);
    N_word  mask = mask_(Q);
    N_word  msb = (mask AND NOT (mask >> 1));
    boolean sgn_q;
    boolean sgn_x;
    boolean sgn_y;
    wordptr A;
    wordptr B;

    /*
       Requirements:
         -  All bit vectors must have equal sizes
         -  Q and R must be two distinct bit vectors
         -  Y must be non-zero (of course!)
       Features:
         -  The contents of X and Y are preserved
         -  Q may be identical with X or Y (or both)
            (in-place division is possible!)
         -  R may be identical with X or Y (or both)
            (but not identical with Q!)
    */

    if (BitVector_is_empty(X))
    {
        BitVector_Empty(Q);
        BitVector_Empty(R);
    }
    else
    {
        A = BitVector_Create((N_int) bits, false);
        if (A == NULL) return(false);
        B = BitVector_Create((N_int) bits, false);
        if (B == NULL) { BitVector_Destroy(A); return(false); }
        size--;
        sgn_x = (((*(X+size) &= mask) AND msb) != 0);
        sgn_y = (((*(Y+size) &= mask) AND msb) != 0);
        sgn_q = sgn_x XOR sgn_y;
        if (sgn_x) BitVector_Negate(A,X); else BitVector_Copy(A,X);
        if (sgn_y) BitVector_Negate(B,Y); else BitVector_Copy(B,Y);
        BitVector_Div_Pos(Q,A,B,R);
        if (sgn_q) BitVector_Negate(Q,Q);
        if (sgn_x) BitVector_Negate(R,R);
        BitVector_Destroy(A);
        BitVector_Destroy(B);
    }
    return(true);
}

boolean BitVector_GCD(wordptr X, wordptr Y, wordptr Z)
{
    N_word  bits = bits_(X);
    N_word  size = size_(X);
    N_word  mask = mask_(X);
    N_word  msb = (mask AND NOT (mask >> 1));
    wordptr Q;
    wordptr R;
    wordptr A;
    wordptr B;
    wordptr T;

    /*
       Requirements:
         -  All bit vectors must have equal sizes
         -  Y and Z must be non-zero (of course!)
       Features:
         -  The contents of Y and Z are preserved
         -  X may be identical with Y or Z (or both)
            (in-place is possible!)
    */

    Q = BitVector_Create(bits,false);
    if (Q == NULL)
    {
        return(false);
    }
    R = BitVector_Create(bits,false);
    if (R == NULL)
    {
        BitVector_Destroy(Q);
        return(false);
    }
    A = BitVector_Create(bits,false);
    if (A == NULL)
    {
        BitVector_Destroy(Q);
        BitVector_Destroy(R);
        return(false);
    }
    B = BitVector_Create(bits,false);
    if (B == NULL)
    {
        BitVector_Destroy(Q);
        BitVector_Destroy(R);
        BitVector_Destroy(A);
        return(false);
    }
    size--;
    if (((*(Y+size) &= mask) AND msb) != 0) BitVector_Negate(A,Y);
    else                                    BitVector_Copy(A,Y);
    if (((*(Z+size) &= mask) AND msb) != 0) BitVector_Negate(B,Z);
    else                                    BitVector_Copy(B,Z);
    while (true)
    {
        BitVector_Div_Pos(Q,A,B,R);
        if (BitVector_is_empty(R)) break;
        T = A;
        A = B;
        B = R;
        R = T;
    }
    BitVector_Copy(X,B);
    BitVector_Destroy(Q);
    BitVector_Destroy(R);
    BitVector_Destroy(A);
    BitVector_Destroy(B);
    return(true);
}

void BitVector_Block_Store(wordptr addr, charptr buffer, N_int length)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    N_word  value;
    N_word  count;

    /* provide translation for independence of endian-ness: */
    while (size-- > 0)
    {
        value = 0;
        for ( count = 0; (length > 0) and (count < BITS); count += 8 )
        {
            value |= (((N_word) *buffer++) << count); length--;
        }
        *addr++ = value;
    }
    *(--addr) &= mask;
}

charptr BitVector_Block_Read(wordptr addr, N_intptr length)
{
    N_word size = size_(addr);
    N_word  value;
    N_word  count;
    charptr buffer;
    charptr target;

    /* provide translation for independence of endian-ness: */
    *length = size << FACTOR;
    buffer = (charptr) malloc((size_t) ((*length)+1));
    if (buffer == NULL) return(NULL);
    *(addr+size-1) &= mask_(addr);
    target = buffer;
    while (size-- > 0)
    {
        value = *addr++;
        count = BITS >> 3;
        while (count-- > 0)
        {
            *target++ = (N_char) (value AND 0x00FF);
            if (count > 0) value >>= 8;
        }
    }
    *target = (N_char) '\0';
    return(buffer);
}

void BitVector_Word_Store(wordptr addr, N_int offset, N_int value)
{
    N_word size = size_(addr);

    if (offset < size) *(addr+offset) = value;
    *(addr+size-1) &= mask_(addr);
}

N_int BitVector_Word_Read(wordptr addr, N_int offset)
{
    N_word size = size_(addr);

    *(addr+size-1) &= mask_(addr);
    if (offset < size) return( *(addr+offset) );
    else               return(    (N_int) 0   );
}

void BitVector_Word_Insert(wordptr addr, N_int offset, N_int count,
                           boolean clear)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    wordptr last = addr+size-1;

    *last &= mask;
    if (offset > size) offset = size;
    insert_words(addr+offset,size-offset,count,clear);
    *last &= mask;
}

void BitVector_Word_Delete(wordptr addr, N_int offset, N_int count,
                           boolean clear)
{
    N_word  size = size_(addr);
    N_word  mask = mask_(addr);
    wordptr last = addr+size-1;

    *last &= mask;
    if (offset > size) offset = size;
    delete_words(addr+offset,size-offset,count,clear);
    *last &= mask;
}

void BitVector_Chunk_Store(wordptr addr, N_int offset, N_int chunksize,
                           N_long value)
{
    N_word bits = bits_(addr);
    N_word mask;
    N_word temp;

    if ((chunksize > 0) and (offset < bits))
    {
        if (chunksize > LONGBITS) chunksize = LONGBITS;
        if ((offset + chunksize) > bits) chunksize = bits - offset;
        addr += offset >> LOGBITS;
        offset &= MODMASK;
        while (chunksize > 0)
        {
            mask = (N_word) (~0L << offset);
            bits = offset + chunksize;
            if (bits < BITS)
            {
                mask &= (N_word) ~(~0L << bits);
                bits = chunksize;
            }
            else bits = BITS - offset;
            temp = (N_word) (value << offset);
            temp &= mask;
            *addr &= NOT mask;
            *addr++ |= temp;
            value >>= bits;
            chunksize -= bits;
            offset = 0;
        }
    }
}

N_long BitVector_Chunk_Read(wordptr addr, N_int offset, N_int chunksize)
{
    N_word bits = bits_(addr);
    N_word chunkbits = 0;
    N_long value = 0L;
    N_long temp;
    N_word mask;

    if ((chunksize > 0) and (offset < bits))
    {
        if (chunksize > LONGBITS) chunksize = LONGBITS;
        if ((offset + chunksize) > bits) chunksize = bits - offset;
        addr += offset >> LOGBITS;
        offset &= MODMASK;
        while (chunksize > 0)
        {
            bits = offset + chunksize;
            if (bits < BITS)
            {
                mask = (N_word) ~(~0L << bits);
                bits = chunksize;
            }
            else
            {
                mask = (N_word) ~0L;
                bits = BITS - offset;
            }
            temp = (N_long) ((*addr++ AND mask) >> offset);
            value |= temp << chunkbits;
            chunkbits += bits;
            chunksize -= bits;
            offset = 0;
        }
    }
    return(value);
}

    /*******************/
    /* set operations: */
    /*******************/

void Set_Union(wordptr X, wordptr Y, wordptr Z)             /* X = Y + Z     */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ OR *Z++;
        *(--X) &= mask;
    }
}

void Set_Intersection(wordptr X, wordptr Y, wordptr Z)      /* X = Y * Z     */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND *Z++;
        *(--X) &= mask;
    }
}

void Set_Difference(wordptr X, wordptr Y, wordptr Z)        /* X = Y \ Z     */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ AND NOT *Z++;
        *(--X) &= mask;
    }
}

void Set_ExclusiveOr(wordptr X, wordptr Y, wordptr Z)       /* X=(Y+Z)\(Y*Z) */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = *Y++ XOR *Z++;
        *(--X) &= mask;
    }
}

void Set_Complement(wordptr X, wordptr Y)                   /* X = ~Y        */
{
    N_word size = size_(X);
    N_word mask = mask_(X);

    if (size > 0)
    {
        while (size-- > 0) *X++ = NOT *Y++;
        *(--X) &= mask;
    }
}

    /******************/
    /* set functions: */
    /******************/

boolean Set_subset(wordptr X, wordptr Y)                    /* X subset Y ?  */
{
    N_word size = size_(X);
    boolean r = true;

    while (r and (size-- > 0)) r = ((*X++ AND NOT *Y++) == 0);
    return(r);
}

N_int Set_Norm(wordptr addr)                                /* = | X |       */
{
    N_word  size  = size_(addr);
    N_int   count = 0;
    N_word  c;

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

Z_long Set_Min(wordptr addr)                                /* = min(X)      */
{
    boolean empty = true;
    N_word  size  = size_(addr);
    N_word  i     = 0;
    N_word  c;

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

Z_long Set_Max(wordptr addr)                                /* = max(X)      */
{
    boolean empty = true;
    N_word  size  = size_(addr);
    N_word  i     = size;
    N_word  c;

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

void Matrix_Multiplication(wordptr X, N_int rowsX, N_int colsX,
                           wordptr Y, N_int rowsY, N_int colsY,
                           wordptr Z, N_int rowsZ, N_int colsZ)
{
    N_word i;
    N_word j;
    N_word k;
    N_word indxX;
    N_word indxY;
    N_word indxZ;
    N_word termX;
    N_word termY;
    N_word sum;

  if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
      (bits_(X) == rowsX*colsX) and
      (bits_(Y) == rowsY*colsY) and
      (bits_(Z) == rowsZ*colsZ))
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

void Matrix_Closure(wordptr addr, N_int rows, N_int cols)
{
    N_word i;
    N_word j;
    N_word k;
    N_word ii;
    N_word ij;
    N_word ik;
    N_word kj;
    N_word termi;
    N_word termk;

  if ((rows == cols) and (bits_(addr) == rows*cols))
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

void Matrix_Transpose(wordptr X, N_int rowsX, N_int colsX,
                      wordptr Y, N_int rowsY, N_int colsY)
{
    N_word  i;
    N_word  j;
    N_word  ii;
    N_word  ij;
    N_word  ji;
    N_word  addii;
    N_word  addij;
    N_word  addji;
    N_word  bitii;
    N_word  bitij;
    N_word  bitji;
    N_word  termi;
    N_word  termj;
    boolean swap;

  /* BEWARE that "in-place" is ONLY possible if the matrix is quadratic!! */
  if ((rowsX == colsY) and (colsX == rowsY) and
      (bits_(X) == rowsX*colsX) and
      (bits_(Y) == rowsY*colsY))
  {
    if (rowsY == colsY) /* in-place is possible! */
    {
        for ( i = 0; i < rowsY; i++ )
        {
            termi = i * colsY;
            for ( j = 0; j < i; j++ )
            {
                termj = j * colsX;
                ij = termi + j;
                ji = termj + i;
                addij = ij >> LOGBITS;
                addji = ji >> LOGBITS;
                bitij = BITMASKTAB[ij AND MODMASK];
                bitji = BITMASKTAB[ji AND MODMASK];
                swap = ((*(Y+addij) AND bitij) != 0);
                if ((*(Y+addji) AND bitji) != 0)
                     *(X+addij) |=     bitij;
                else
                     *(X+addij) &= NOT bitij;
                if (swap)
                     *(X+addji) |=     bitji;
                else
                     *(X+addji) &= NOT bitji;
            }
            ii = termi + i;
            addii = ii >> LOGBITS;
            bitii = BITMASKTAB[ii AND MODMASK];
            if ((*(Y+addii) AND bitii) != 0)
                 *(X+addii) |=     bitii;
            else
                 *(X+addii) &= NOT bitii;
        }
    }
    else /* rowsX != colsX, in-place is NOT possible! */
    {
        for ( i = 0; i < rowsY; i++ )
        {
            termi = i * colsY;
            for ( j = 0; j < colsY; j++ )
            {
                termj = j * colsX;
                ij = termi + j;
                ji = termj + i;
                addij = ij >> LOGBITS;
                addji = ji >> LOGBITS;
                bitij = BITMASKTAB[ij AND MODMASK];
                bitji = BITMASKTAB[ji AND MODMASK];
                if ((*(Y+addij) AND bitij) != 0)
                     *(X+addji) |=     bitji;
                else
                     *(X+addji) &= NOT bitji;
            }
        }
    }
  }
}

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
