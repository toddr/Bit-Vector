/*
  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.
  This package is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.
*/

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


#include "Definitions.h"
#include "BitVector.h"


typedef   SV *Class_Type;
typedef   SV *BitVector_Object;
typedef   SV *BitVector_Handle;
typedef unit *BitVector_Address;


static  char *Class_Name = "Bit::Vector";


#ifdef  DEBUG_BIT_VECTOR

#define DEBUG_CONSTRUCTOR(elem,ref,hdl,adr) fprintf(stderr, \
"Bit::Vector::new(%u): ref=0x%.8X hdl=0x%.8X adr=0x%.8X\n", elem, \
(N_long) ref, (N_long) hdl, (N_long) adr);

#define DEBUG_DESTRUCTOR(ref,hdl,adr) fprintf(stderr, \
"Bit::Vector::DESTROY(): ref=0x%.8X hdl=0x%.8X adr=0x%.8X\n", \
(N_long) ref, (N_long) hdl, (N_long) adr);

#else

#define DEBUG_CONSTRUCTOR(elem,ref,hdl,adr) ;
#define DEBUG_DESTRUCTOR(ref,hdl,adr) ;

#endif


#ifdef  ENABLE_SUBCLASSING

#define OVERRIDE_CLASS(class,type,name) ;

#define BIT_VECTOR_CHECK(ref,hdl,adr,nam)  \
    ( ref &&                               \
    SvROK(ref) &&                          \
    (hdl = (BitVector_Handle)SvRV(ref)) && \
    SvOBJECT(hdl) &&                       \
    (SvTYPE(hdl) == SVt_PVMG) &&           \
    SvREADONLY(hdl) &&                     \
    (adr = (BitVector_Address)SvIV(hdl)) )

#else

#define OVERRIDE_CLASS(class,type,name) class = (type) name;

#define BIT_VECTOR_CHECK(ref,hdl,adr,nam)  \
    ( ref &&                               \
    SvROK(ref) &&                          \
    (hdl = (BitVector_Handle)SvRV(ref)) && \
    SvOBJECT(hdl) &&                       \
    (SvTYPE(hdl) == SVt_PVMG) &&           \
    (strEQ(HvNAME(SvSTASH(hdl)),nam)) &&   \
    SvREADONLY(hdl) &&                     \
    (adr = (BitVector_Address)SvIV(hdl)) )

#endif


#define BIT_VECTOR_ERROR(name,error) \
    croak("Bit::Vector::" name "(): " error)

#define BIT_VECTOR_TYPE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"not a 'Bit::Vector' object reference")

#define BIT_VECTOR_CREATE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"unable to create new 'Bit::Vector' object")

#define BIT_VECTOR_STRING_ERROR(name) \
    BIT_VECTOR_ERROR(name,"unable to create new string")

#define BIT_VECTOR_LENGTH_ERROR(name) \
    BIT_VECTOR_ERROR(name,"zero length 'Bit::Vector' object not permitted")

#define BIT_VECTOR_INDEX_ERROR(name) \
    BIT_VECTOR_ERROR(name,"index out of range")

#define BIT_VECTOR_MIN_ERROR(name) \
    BIT_VECTOR_ERROR(name,"minimum index out of range")

#define BIT_VECTOR_MAX_ERROR(name) \
    BIT_VECTOR_ERROR(name,"maximum index out of range")

#define BIT_VECTOR_ORDER_ERROR(name) \
    BIT_VECTOR_ERROR(name,"minimum > maximum index")

#define BIT_VECTOR_START_ERROR(name) \
    BIT_VECTOR_ERROR(name,"start index out of range")

#define BIT_VECTOR_SIZE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"bit vector size mismatch")

#define BIT_VECTOR_SET_ERROR(name) \
    BIT_VECTOR_ERROR(name,"set size mismatch")

#define BIT_VECTOR_MATRIX_ERROR(name) \
    BIT_VECTOR_ERROR(name,"matrix size mismatch")

#define BIT_VECTOR_SHAPE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"matrix is not quadratic")


MODULE = Bit::Vector		PACKAGE = Bit::Vector


PROTOTYPES: DISABLE


BOOT:
{
    unit rc;
    if (rc = BitVector_Auto_Config())
    {
        fprintf(stderr,
"'Bit::Vector' failed to auto-configure:\n");
        switch (rc)
        {
            case 1:
                fprintf(stderr,
"the type 'unit' is larger (has more bits) than the type 'size_t'!\n");
                break;
            case 2:
                fprintf(stderr,
"the number of bits of a machine word is not a power of 2!\n");
                break;
            case 3:
                fprintf(stderr,
"the number of bits of a machine word is less than 8!\n");
                break;
            case 4:
                fprintf(stderr,
"the number of bits of a machine word and 'sizeof(unit)' are inconsistent!\n");
                break;
            case 5:
                fprintf(stderr,
"unable to allocate memory with 'malloc()'!\n");
                break;
            default:
                fprintf(stderr,
"unexpected (unknown) error!\n");
                break;
        }
        exit(rc);
    }
}


void
Version()
PPCODE:
{
    EXTEND(sp,1);
    PUSHs(sv_2mortal(newSVpv("4.1",0)));
}


N_int
Size(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = *(address-3);
    }
    else BIT_VECTOR_TYPE_ERROR("Size");
}
OUTPUT:
RETVAL


MODULE = Bit::Vector		PACKAGE = Bit::Vector		PREFIX = BitVector_


void
BitVector_new(class,elements)
Class_Type	class
N_int	elements
PPCODE:
{
    BitVector_Address address;
    BitVector_Handle  handle;
    BitVector_Object  reference;

    if ( class && SvROK(class) && (handle = (SV *)SvRV(class)) &&
         SvOBJECT(handle) && (SvTYPE(handle) == SVt_PVMG) )
    {
        class = (Class_Type)HvNAME(SvSTASH(handle));
    }
    else
    {
        if ( class && SvPOK(class) && SvCUR(class) )
        {
            class = (Class_Type)SvPV(class,na);
        }
        else
        {
            class = (Class_Type)Class_Name;
        }
    }

    /* overrides input parameter unless ENABLE_SUBCLASSING is defined: */

    OVERRIDE_CLASS(class,Class_Type,Class_Name)

    if (elements != 0)
    {
        if ((address = BitVector_Create(elements)) != NULL)
        {
            handle = newSViv((IV)address);
            reference = sv_bless(sv_2mortal(newRV(handle)),
                gv_stashpv((char *)class,1));
            SvREFCNT_dec(handle);
            SvREADONLY_on(handle);
            PUSHs(reference);
        }
        else BIT_VECTOR_CREATE_ERROR("new");
    }
    else BIT_VECTOR_LENGTH_ERROR("new");
    DEBUG_CONSTRUCTOR(elements,reference,handle,address)
}


void
BitVector_DESTROY(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        DEBUG_DESTRUCTOR(reference,handle,address)
        BitVector_Destroy(address);
        SvREADONLY_off(handle);
        sv_setiv(handle,(IV)NULL);
        SvREADONLY_on(handle);
    }
    else BIT_VECTOR_TYPE_ERROR("DESTROY");
}


void
BitVector_Resize(reference,elements)
BitVector_Object	reference
N_int	elements
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (elements != 0)
        {
            if ((address = BitVector_Resize(address,elements)) != NULL)
            {
                SvREADONLY_off(handle);
                sv_setiv(handle,(IV)address);
                SvREADONLY_on(handle);
            }
            else BIT_VECTOR_CREATE_ERROR("Resize");
        }
        else BIT_VECTOR_LENGTH_ERROR("Resize");
    }
    else BIT_VECTOR_TYPE_ERROR("Resize");
}


void
BitVector_Empty(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        BitVector_Empty(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Empty");
}


void
BitVector_Fill(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        BitVector_Fill(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Fill");
}


void
BitVector_Flip(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        BitVector_Flip(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Flip");
}


void
BitVector_Interval_Empty(reference,min,max)
BitVector_Object	reference
N_int	min
N_int	max
ALIAS:
  Empty_Interval = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if      (min >= *(address-3)) BIT_VECTOR_MIN_ERROR("Interval_Empty");
        else if (max >= *(address-3)) BIT_VECTOR_MAX_ERROR("Interval_Empty");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Empty");
        else                          BitVector_Interval_Empty(address,min,max);
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Empty");
}


void
BitVector_Interval_Fill(reference,min,max)
BitVector_Object	reference
N_int	min
N_int	max
ALIAS:
  Fill_Interval = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if      (min >= *(address-3)) BIT_VECTOR_MIN_ERROR("Interval_Fill");
        else if (max >= *(address-3)) BIT_VECTOR_MAX_ERROR("Interval_Fill");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Fill");
        else                          BitVector_Interval_Fill(address,min,max);
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Fill");
}


void
BitVector_Interval_Flip(reference,min,max)
BitVector_Object	reference
N_int	min
N_int	max
ALIAS:
  Flip_Interval = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if      (min >= *(address-3)) BIT_VECTOR_MIN_ERROR("Interval_Flip");
        else if (max >= *(address-3)) BIT_VECTOR_MAX_ERROR("Interval_Flip");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Flip");
        else                          BitVector_Interval_Flip(address,min,max);
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Flip");
}


void
BitVector_Interval_Scan_inc(reference,start)
BitVector_Object	reference
N_int	start
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int min;
    N_int max;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (start < *(address-3))
        {
            if ( BitVector_interval_scan_inc(address,start,&min,&max) )
            {
                EXTEND(sp,2);
                PUSHs(sv_2mortal(newSViv((IV)min)));
                PUSHs(sv_2mortal(newSViv((IV)max)));
            }
            /* else return empty list */
        }
        else BIT_VECTOR_START_ERROR("Interval_Scan_inc");
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Scan_inc");
}


void
BitVector_Interval_Scan_dec(reference,start)
BitVector_Object	reference
N_int	start
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int min;
    N_int max;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (start < *(address-3))
        {
            if ( BitVector_interval_scan_dec(address,start,&min,&max) )
            {
                EXTEND(sp,2);
                PUSHs(sv_2mortal(newSViv((IV)min)));
                PUSHs(sv_2mortal(newSViv((IV)max)));
            }
            /* else return empty list */
        }
        else BIT_VECTOR_START_ERROR("Interval_Scan_dec");
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Scan_dec");
}


void
BitVector_Bit_Off(reference,index)
BitVector_Object	reference
N_int	index
ALIAS:
  Delete = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (index < *(address-3))
        {
            BitVector_Bit_Off(address,index);
        }
        else BIT_VECTOR_INDEX_ERROR("Bit_Off");
    }
    else BIT_VECTOR_TYPE_ERROR("Bit_Off");
}


void
BitVector_Bit_On(reference,index)
BitVector_Object	reference
N_int	index
ALIAS:
  Insert = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (index < *(address-3))
        {
            BitVector_Bit_On(address,index);
        }
        else BIT_VECTOR_INDEX_ERROR("Bit_On");
    }
    else BIT_VECTOR_TYPE_ERROR("Bit_On");
}


boolean
BitVector_bit_flip(reference,index)
BitVector_Object	reference
N_int	index
ALIAS:
  flip = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (index < *(address-3))
        {
            RETVAL = BitVector_bit_flip(address,index);
        }
        else BIT_VECTOR_INDEX_ERROR("bit_flip");
    }
    else BIT_VECTOR_TYPE_ERROR("bit_flip");
}
OUTPUT:
RETVAL


boolean
BitVector_bit_test(reference,index)
BitVector_Object	reference
N_int	index
ALIAS:
  contains = 1
  in       = 2
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (index < *(address-3))
        {
            RETVAL = BitVector_bit_test(address,index);
        }
        else BIT_VECTOR_INDEX_ERROR("bit_test");
    }
    else BIT_VECTOR_TYPE_ERROR("bit_test");
}
OUTPUT:
RETVAL


boolean
BitVector_equal(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            RETVAL = BitVector_equal(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("equal");
    }
    else BIT_VECTOR_TYPE_ERROR("equal");
}
OUTPUT:
RETVAL


boolean
BitVector_lexorder(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            RETVAL = BitVector_lexorder(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("lexorder");
    }
    else BIT_VECTOR_TYPE_ERROR("lexorder");
}
OUTPUT:
RETVAL


Z_int
BitVector_Compare(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            RETVAL = BitVector_Compare(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Compare");
    }
    else BIT_VECTOR_TYPE_ERROR("Compare");
}
OUTPUT:
RETVAL


void
BitVector_Copy(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            BitVector_Copy(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Copy");
    }
    else BIT_VECTOR_TYPE_ERROR("Copy");
}


boolean
BitVector_rotate_left(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = BitVector_rotate_left(address);
    }
    else BIT_VECTOR_TYPE_ERROR("rotate_left");
}
OUTPUT:
RETVAL


boolean
BitVector_rotate_right(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = BitVector_rotate_right(address);
    }
    else BIT_VECTOR_TYPE_ERROR("rotate_right");
}
OUTPUT:
RETVAL


boolean
BitVector_shift_left(reference,carry)
BitVector_Object	reference
boolean	carry
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        carry &= 1;
        RETVAL = BitVector_shift_left(address,carry);
    }
    else BIT_VECTOR_TYPE_ERROR("shift_left");
}
OUTPUT:
RETVAL


boolean
BitVector_shift_right(reference,carry)
BitVector_Object	reference
boolean	carry
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        carry &= 1;
        RETVAL = BitVector_shift_right(address,carry);
    }
    else BIT_VECTOR_TYPE_ERROR("shift_right");
}
OUTPUT:
RETVAL


void
BitVector_Move_Left(reference,bits)
BitVector_Object	reference
N_int	bits
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        BitVector_Move_Left(address,bits);
    }
    else BIT_VECTOR_TYPE_ERROR("Move_Left");
}


void
BitVector_Move_Right(reference,bits)
BitVector_Object	reference
N_int	bits
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        BitVector_Move_Right(address,bits);
    }
    else BIT_VECTOR_TYPE_ERROR("Move_Right");
}


boolean
BitVector_increment(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = BitVector_increment(address);
    }
    else BIT_VECTOR_TYPE_ERROR("increment");
}
OUTPUT:
RETVAL


boolean
BitVector_decrement(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = BitVector_decrement(address);
    }
    else BIT_VECTOR_TYPE_ERROR("decrement");
}
OUTPUT:
RETVAL


void
BitVector_to_String(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    baseptr string;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        string = BitVector_to_String(address);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("to_String");
    }
    else BIT_VECTOR_TYPE_ERROR("to_String");
}


boolean
BitVector_from_string(reference,string)
BitVector_Object	reference
baseptr	string;
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = BitVector_from_string(address,string);
    }
    else BIT_VECTOR_TYPE_ERROR("from_string");
}
OUTPUT:
RETVAL


MODULE = Bit::Vector		PACKAGE = Bit::Vector		PREFIX = Set_


void
Set_Union(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
ALIAS:
  Or = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((*(Xadr-3) == *(Yadr-3)) and (*(Xadr-3) == *(Zadr-3)))
        {
            Set_Union(Xadr,Yadr,Zadr);
        }
        else BIT_VECTOR_SET_ERROR("Union");
    }
    else BIT_VECTOR_TYPE_ERROR("Union");
}


void
Set_Intersection(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
ALIAS:
  And = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((*(Xadr-3) == *(Yadr-3)) and (*(Xadr-3) == *(Zadr-3)))
        {
            Set_Intersection(Xadr,Yadr,Zadr);
        }
        else BIT_VECTOR_SET_ERROR("Intersection");
    }
    else BIT_VECTOR_TYPE_ERROR("Intersection");
}


void
Set_Difference(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
ALIAS:
  And_Not = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((*(Xadr-3) == *(Yadr-3)) and (*(Xadr-3) == *(Zadr-3)))
        {
            Set_Difference(Xadr,Yadr,Zadr);
        }
        else BIT_VECTOR_SET_ERROR("Difference");
    }
    else BIT_VECTOR_TYPE_ERROR("Difference");
}


void
Set_ExclusiveOr(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
ALIAS:
  Xor = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((*(Xadr-3) == *(Yadr-3)) and (*(Xadr-3) == *(Zadr-3)))
        {
            Set_ExclusiveOr(Xadr,Yadr,Zadr);
        }
        else BIT_VECTOR_SET_ERROR("ExclusiveOr");
    }
    else BIT_VECTOR_TYPE_ERROR("ExclusiveOr");
}


void
Set_Complement(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
ALIAS:
  Not = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            Set_Complement(Xadr,Yadr);
        }
        else BIT_VECTOR_SET_ERROR("Complement");
    }
    else BIT_VECTOR_TYPE_ERROR("Complement");
}


boolean
Set_subset(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
ALIAS:
  inclusion = 1
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) )
    {
        if (*(Xadr-3) == *(Yadr-3))
        {
            RETVAL = Set_subset(Xadr,Yadr);
        }
        else BIT_VECTOR_SET_ERROR("subset");
    }
    else BIT_VECTOR_TYPE_ERROR("subset");
}
OUTPUT:
RETVAL


N_int
Set_Norm(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Norm(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Norm");
}
OUTPUT:
RETVAL


Z_long
Set_Min(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Min(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Min");
}
OUTPUT:
RETVAL


Z_long
Set_Max(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        RETVAL = Set_Max(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Max");
}
OUTPUT:
RETVAL


MODULE = Bit::Vector		PACKAGE = Bit::Vector		PREFIX = Matrix_


void
Matrix_Multiplication(Xref,rowsX,colsX,Yref,rowsY,colsY,Zref,rowsZ,colsZ)
BitVector_Object	Xref
N_int	rowsX
N_int	colsX
BitVector_Object	Yref
N_int	rowsY
N_int	colsY
BitVector_Object	Zref
N_int	rowsZ
N_int	colsZ
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr,Class_Name) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr,Class_Name) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr,Class_Name) )
    {
        if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
            (*(Xadr-3) == rowsX*colsX) and
            (*(Yadr-3) == rowsY*colsY) and
            (*(Zadr-3) == rowsZ*colsZ))
        {
            Matrix_Multiplication(Xadr,rowsX,colsX,
                                  Yadr,rowsY,colsY,
                                  Zadr,rowsZ,colsZ);
        }
        else BIT_VECTOR_MATRIX_ERROR("Multiplication");
    }
    else BIT_VECTOR_TYPE_ERROR("Multiplication");
}


void
Matrix_Closure(reference,rows,cols)
BitVector_Object	reference
N_int	rows
N_int	cols
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address,Class_Name) )
    {
        if (rows == cols)
        {
            if (*(address-3) == rows*cols)
            {
                Matrix_Closure(address,rows,cols);
            }
            else BIT_VECTOR_MATRIX_ERROR("Closure");
        }
        else BIT_VECTOR_SHAPE_ERROR("Closure");
    }
    else BIT_VECTOR_TYPE_ERROR("Closure");
}


