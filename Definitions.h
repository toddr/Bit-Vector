#ifndef DEFINITIONS
#define DEFINITIONS
/*****************************************************************************/
/*  MODULE NAME:  Definitions.h                         MODULE TYPE:  (dat)  */
/*****************************************************************************/
/*  MODULE IMPORTS:                                                          */
/*****************************************************************************/

/*****************************************************************************/
/*  MODULE INTERFACE:                                                        */
/*****************************************************************************/

/*  NOTE: Type names used here are deliberately somewhat weird to avoid      */
/*        name conflicts with system and other applications' header files!   */

typedef  unsigned   char    N_char;
typedef  unsigned   char    N_byte;
typedef  unsigned   short   N_short;
typedef  unsigned   short   N_shortword;
typedef  unsigned   int     N_int;
typedef  unsigned   int     N_word;
typedef  unsigned   long    N_long;
typedef  unsigned   long    N_longword;

/*  Mnemonic 1:  The natural numbers,  N = { 0, 1, 2, 3, ... }               */
/*  Mnemonic 2:  Nnnn = u_N_signed,  _N_ot signed                            */

typedef  signed     char    Z_char;
typedef  signed     char    Z_byte;
typedef  signed     short   Z_short;
typedef  signed     short   Z_shortword;
typedef  signed     int     Z_int;
typedef  signed     int     Z_word;
typedef  signed     long    Z_long;
typedef  signed     long    Z_longword;

/*  Mnemonic 1:  The whole numbers,  Z = { 0, -1, 1, -2, 2, -3, 3, ... }     */
/*  Mnemonic 2:  Zzzz = Ssss_igned                                           */

typedef  void               *voidptr;
typedef  N_char             *charptr;
typedef  N_byte             *byteptr;
typedef  N_short            *shortptr;
typedef  N_shortword        *shortwordptr;
typedef  N_int              *intptr;
typedef  N_word             *wordptr;
typedef  N_long             *longptr;
typedef  N_longword         *longwordptr;

typedef  N_char             *N_charptr;
typedef  N_byte             *N_byteptr;
typedef  N_short            *N_shortptr;
typedef  N_shortword        *N_shortwordptr;
typedef  N_int              *N_intptr;
typedef  N_word             *N_wordptr;
typedef  N_long             *N_longptr;
typedef  N_longword         *N_longwordptr;

typedef  Z_char             *Z_charptr;
typedef  Z_byte             *Z_byteptr;
typedef  Z_short            *Z_shortptr;
typedef  Z_shortword        *Z_shortwordptr;
typedef  Z_int              *Z_intptr;
typedef  Z_word             *Z_wordptr;
typedef  Z_long             *Z_longptr;
typedef  Z_longword         *Z_longwordptr;

#undef  FALSE
#define FALSE       (0==1)

#undef  TRUE
#define TRUE        (0==0)

typedef enum { false = FALSE , true = TRUE } boolean;

#define blockdef(name,size)         unsigned char name[size]
#define blocktypedef(name,size)     typedef unsigned char name[size]

#define and         &&      /* logical (boolean) operators: lower case */
#define or          ||
#define not         !

#define AND         &       /* binary (bitwise) operators: UPPER CASE */
#define OR          |
#define XOR         ^
#define NOT         ~
#define SHL         <<
#define SHR         >>

#ifdef EXTENDED_DEFINITIONS

#define mod         %       /* arithmetic operators */

#define BELL        '\a'    /* bell             0x07 */
#define BEL         '\a'    /* bell             0x07 */
#define BACKSPACE   '\b'    /* backspace        0x08 */
#define BS          '\b'    /* backspace        0x08 */
#define TAB         '\t'    /* tab              0x09 */
#define HT          '\t'    /* horizontal tab   0x09 */
#define LINEFEED    '\n'    /* linefeed         0x0A */
#define NEWLINE     '\n'    /* newline          0x0A */
#define LF          '\n'    /* linefeed         0x0A */
#define VTAB        '\v'    /* vertical tab     0x0B */
#define VT          '\v'    /* vertical tab     0x0B */
#define FORMFEED    '\f'    /* formfeed         0x0C */
#define NEWPAGE     '\f'    /* newpage          0x0C */
#define CR          '\r'    /* carriage return  0x0D */

typedef             struct
{
    N_byte      l;
    N_byte      h;
}                   twobytes;

typedef             struct
{
    N_byte      a;
    N_byte      b;
    N_byte      c;
    N_byte      d;
}                   fourbytes;

typedef             struct
{
    N_word      l;
    N_word      h;
}                   twowords;

/*******************************/
/* implementation dependent!!! */
/*   (assumes int = 2 bytes)   */
/*******************************/

typedef             union
{
    N_word      x;
    twobytes    z;
}                   wordreg;

/**********************************************/
/*        implementation dependent!!!         */
/* (assumes long = 4 bytes and int = 2 bytes) */
/**********************************************/

typedef             union
{
    N_long      x;
    twowords    y;
    fourbytes   z;
}                   longwordreg;

#define lobyte(x)           (((int)(x)) & 0xFF)
#define hibyte(x)           ((((int)(x)) >> 8) & 0xFF)

#endif

/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

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
/*    01.11.93    First version (MS C Compiler on PC with DOS)               */
/*    29.11.95    First version under UNIX (for Perl modules)                */
/*    ??.??.??    ???                                                        */
/*    16.02.97    Version 3.0                                                */
/*    24.03.97    Version 4.0                                                */
/*    12.10.97    Version 5.0                                                */
/*****************************************************************************/
/*  COPYRIGHT (C) 1993-1997 BY:  Steffen Beyer         ALL RIGHTS RESERVED.  */
/*****************************************************************************/
#endif
