

/*  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.  */

/*  Please refer to the file "LICENSE" in this distribution for the exact  */
/*  terms under which this package may be used and distributed!            */


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


#include "Definitions.h"
#include "BitVector.h"


static    char *BitVector_Class = "Bit::Vector";

typedef     SV *BitVector_Object;
typedef     SV *BitVector_Handle;
typedef N_word *BitVector_Address;
typedef     SV *BitVector_Buffer;


#define BIT_VECTOR_CHECK(ref,hdl,adr) \
    ( ref && SvROK(ref) && \
    (hdl = (BitVector_Handle)SvRV(ref)) && \
    SvOBJECT(hdl) && (SvTYPE(hdl) == SVt_PVMG) && \
    (strEQ(HvNAME(SvSTASH(hdl)),BitVector_Class)) && \
    SvREADONLY(hdl) && (adr = (BitVector_Address)SvIV(hdl)) )


#define BIT_VECTOR_ERROR(name,error) \
    croak("Bit::Vector::" name "(): " error)

#define BIT_VECTOR_TYPE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"not a 'Bit::Vector' object reference")

#define BIT_VECTOR_CREATE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"unable to create new object")

#define BIT_VECTOR_STRING_ERROR(name) \
    BIT_VECTOR_ERROR(name,"unable to create new string")

#define BIT_VECTOR_LENGTH_ERROR(name) \
    BIT_VECTOR_ERROR(name,"zero length object not permitted")

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

#define BIT_VECTOR_OVERFLOW_ERROR(name) \
    BIT_VECTOR_ERROR(name,"numeric overflow error")

#define BIT_VECTOR_ZERO_ERROR(name) \
    BIT_VECTOR_ERROR(name,"division by zero error")

#define BIT_VECTOR_OFFSET_ERROR(name) \
    BIT_VECTOR_ERROR(name,"offset out of range")

#define BIT_VECTOR_CHUNK_ERROR(name) \
    BIT_VECTOR_ERROR(name,"chunk size out of range")

#define BIT_VECTOR_DISTINCT_ERROR(name) \
    BIT_VECTOR_ERROR(name,"Q and R must be distinct")

#define BIT_VECTOR_INPLACE_ERROR(name) \
    BIT_VECTOR_ERROR(name,"in-place only with quadratic matrices")

#define BIT_VECTOR_BUFFER_ERROR(name) \
    BIT_VECTOR_ERROR(name,"buffer contains no string")

#define BIT_VECTOR_INTERNAL_ERROR(name) \
    BIT_VECTOR_ERROR(name,"unexpected internal error - please contact author")

#define BIT_VECTOR_NUMERIC_ERROR(name) \
    BIT_VECTOR_ERROR(name,"list item not numeric")

#define BIT_VECTOR_EXCEPTION(code,name) \
    { switch (code) { case ErrCode_Ok: break; \
    case ErrCode_Size: BIT_VECTOR_SIZE_ERROR(name); break; \
    case ErrCode_Same: BIT_VECTOR_DISTINCT_ERROR(name); break; \
    case ErrCode_Zero: BIT_VECTOR_ZERO_ERROR(name); break; \
    case ErrCode_Crea: BIT_VECTOR_CREATE_ERROR(name); break; \
    case ErrCode_Ovfl: BIT_VECTOR_OVERFLOW_ERROR(name); break; \
    default: BIT_VECTOR_INTERNAL_ERROR(name); break; } }


MODULE = Bit::Vector		PACKAGE = Bit::Vector		PREFIX = BitVector_


PROTOTYPES: DISABLE


BOOT:
{
    ErrCode rc;

    if (rc = BitVector_Boot())
    {
        switch (rc)
        {
            case ErrCode_Type:
                BIT_VECTOR_ERROR("Boot","sizeof(word) > sizeof(size_t)");
                break;
            case ErrCode_Bits:
                BIT_VECTOR_ERROR("Boot","bits(word) != sizeof(word)*8");
                break;
            case ErrCode_Word:
                BIT_VECTOR_ERROR("Boot","bits(word) < 16");
                break;
            case ErrCode_Long:
                BIT_VECTOR_ERROR("Boot","bits(word) > bits(long)");
                break;
            case ErrCode_Powr:
                BIT_VECTOR_ERROR("Boot","bits(word) != 2^x");
                break;
            case ErrCode_Loga:
                BIT_VECTOR_ERROR("Boot","bits(word) != 2^ld(bits(word))");
                break;
            case ErrCode_Null:
                BIT_VECTOR_ERROR("Boot","unable to allocate memory");
                break;
            default:
                BIT_VECTOR_INTERNAL_ERROR("Boot");
                break;
        }
        exit(rc);
    }
}


void
BitVector_Version(...)
PPCODE:
{
    charptr string;

    if ((items >= 0) and (items <= 1))
    {
        string = BitVector_Version();
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
        }
        else BIT_VECTOR_STRING_ERROR("Version");
    }
    else croak("Usage: Bit::Vector->Version()");
}


N_int
BitVector_Word_Bits(...)
CODE:
{
    if ((items >= 0) and (items <= 1))
    {
        RETVAL = BitVector_Word_Bits();
    }
    else croak("Usage: Bit::Vector->Word_Bits()");
}
OUTPUT:
RETVAL


N_int
BitVector_Long_Bits(...)
CODE:
{
    if ((items >= 0) and (items <= 1))
    {
        RETVAL = BitVector_Long_Bits();
    }
    else croak("Usage: Bit::Vector->Long_Bits()");
}
OUTPUT:
RETVAL


void
BitVector_Create(class,bits)
BitVector_Object	class
N_int	bits
ALIAS:
  new = 2
PPCODE:
{
    BitVector_Address address;
    BitVector_Handle  handle;
    BitVector_Object  reference;

    if ((address = BitVector_Create(bits,true)) != NULL)
    {
        handle = newSViv((IV)address);
        reference = sv_bless(sv_2mortal(newRV(handle)),
            gv_stashpv(BitVector_Class,1));
        SvREFCNT_dec(handle);
        SvREADONLY_on(handle);
        PUSHs(reference);
    }
    else BIT_VECTOR_CREATE_ERROR("new");
}


void
BitVector_Shadow(reference)
BitVector_Object        reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ((address = BitVector_Shadow(address)) != NULL)
        {
            handle = newSViv((IV)address);
            reference = sv_bless(sv_2mortal(newRV(handle)),
                gv_stashpv(BitVector_Class,1));
            SvREFCNT_dec(handle);
            SvREADONLY_on(handle);
            PUSHs(reference);
        }
        else BIT_VECTOR_CREATE_ERROR("Shadow");
    }
    else BIT_VECTOR_TYPE_ERROR("Shadow");
}


void
BitVector_Clone(reference)
BitVector_Object        reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ((address = BitVector_Clone(address)) != NULL)
        {
            handle = newSViv((IV)address);
            reference = sv_bless(sv_2mortal(newRV(handle)),
                gv_stashpv(BitVector_Class,1));
            SvREFCNT_dec(handle);
            SvREADONLY_on(handle);
            PUSHs(reference);
        }
        else BIT_VECTOR_CREATE_ERROR("Clone");
    }
    else BIT_VECTOR_TYPE_ERROR("Clone");
}


void
BitVector_Concat(Xref,Yref)
BitVector_Object        Xref
BitVector_Object        Yref
PPCODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Object  reference;
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if ((address = BitVector_Concat(Xadr,Yadr)) != NULL)
        {
            handle = newSViv((IV)address);
            reference = sv_bless(sv_2mortal(newRV(handle)),
                gv_stashpv(BitVector_Class,1));
            SvREFCNT_dec(handle);
            SvREADONLY_on(handle);
            PUSHs(reference);
        }
        else BIT_VECTOR_CREATE_ERROR("Concat");
    }
    else BIT_VECTOR_TYPE_ERROR("Concat");
}


void
BitVector_Concat_List(...)
PPCODE:
{
    BitVector_Object  Xref;
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Object  reference;
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int offset;
    N_int bits;
    I32 index;

    bits = 0;
    index = items;
    while (index-- > 0)
    {
        Xref = ST(index);
        if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) )
        {
            bits += bits_(Xadr);
        }
        else BIT_VECTOR_TYPE_ERROR("Concat_List");
    }
    if ((address = BitVector_Create(bits,false)) != NULL)
    {
        offset = 0;
        index = items;
        while (index-- > 0)
        {
            Xref = ST(index);
            if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) )
            {
                if ((bits = bits_(Xadr)) > 0)
                {
                    BitVector_Interval_Copy(address,Xadr,offset,0,bits);
                    offset += bits;
                }
            }
            else BIT_VECTOR_TYPE_ERROR("Concat_List");
        }
        handle = newSViv((IV)address);
        reference = sv_bless(sv_2mortal(newRV(handle)),
            gv_stashpv(BitVector_Class,1));
        SvREFCNT_dec(handle);
        SvREADONLY_on(handle);
        PUSHs(reference);
    }
    else BIT_VECTOR_CREATE_ERROR("Concat_List");
}


N_int
BitVector_Size(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = bits_(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Size");
}
OUTPUT:
RETVAL


void
BitVector_Resize(reference,bits)
BitVector_Object	reference
N_int	bits
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ((address = BitVector_Resize(address,bits)) != NULL)
        {
            SvREADONLY_off(handle);
            sv_setiv(handle,(IV)address);
            SvREADONLY_on(handle);
        }
        else BIT_VECTOR_CREATE_ERROR("Resize");
    }
    else BIT_VECTOR_TYPE_ERROR("Resize");
}


void
BitVector_DESTROY(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        BitVector_Destroy(address);
        SvREADONLY_off(handle);
        sv_setiv(handle,(IV)NULL);
        SvREADONLY_on(handle);
    }
    else BIT_VECTOR_TYPE_ERROR("DESTROY");
}


void
BitVector_Copy(Xref,Yref)
BitVector_Object        Xref
BitVector_Object        Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
        {
            BitVector_Copy(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Copy");
    }
    else BIT_VECTOR_TYPE_ERROR("Copy");
}


void
BitVector_Empty(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        BitVector_Flip(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Flip");
}


void
BitVector_Primes(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        BitVector_Primes(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Primes");
}


void
BitVector_Reverse(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
        {
            BitVector_Reverse(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Reverse");
    }
    else BIT_VECTOR_TYPE_ERROR("Reverse");
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if      (min >= bits_(address)) BIT_VECTOR_MIN_ERROR("Interval_Empty");
        else if (max >= bits_(address)) BIT_VECTOR_MAX_ERROR("Interval_Empty");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Empty");
        else                         BitVector_Interval_Empty(address,min,max);
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if      (min >= bits_(address)) BIT_VECTOR_MIN_ERROR("Interval_Fill");
        else if (max >= bits_(address)) BIT_VECTOR_MAX_ERROR("Interval_Fill");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Fill");
        else                         BitVector_Interval_Fill(address,min,max);
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if      (min >= bits_(address)) BIT_VECTOR_MIN_ERROR("Interval_Flip");
        else if (max >= bits_(address)) BIT_VECTOR_MAX_ERROR("Interval_Flip");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Flip");
        else                         BitVector_Interval_Flip(address,min,max);
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Flip");
}


void
BitVector_Interval_Reverse(reference,min,max)
BitVector_Object	reference
N_int	min
N_int	max
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if      (min >= bits_(address)) BIT_VECTOR_MIN_ERROR("Interval_Reverse");
        else if (max >= bits_(address)) BIT_VECTOR_MAX_ERROR("Interval_Reverse");
        else if (min > max)           BIT_VECTOR_ORDER_ERROR("Interval_Reverse");
        else                         BitVector_Interval_Reverse(address,min,max);
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Reverse");
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (start < bits_(address))
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (start < bits_(address))
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
BitVector_Interval_Copy(Xref,Yref,Xoffset,Yoffset,length)
BitVector_Object	Xref
BitVector_Object	Yref
N_int	Xoffset
N_int	Yoffset
N_int	length
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (length > 0)
        {
            if ((Xoffset < bits_(Xadr)) and (Yoffset < bits_(Yadr)))
            {
                BitVector_Interval_Copy(Xadr,Yadr,Xoffset,Yoffset,length);
            }
            else BIT_VECTOR_OFFSET_ERROR("Interval_Copy");
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Copy");
}


void
BitVector_Interval_Substitute(Xref,Yref,Xoffset,Xlength,Yoffset,Ylength)
BitVector_Object	Xref
BitVector_Object	Yref
N_int	Xoffset
N_int	Xlength
N_int	Yoffset
N_int	Ylength
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if ((Xoffset <= bits_(Xadr)) and (Yoffset <= bits_(Yadr)))
        {
            Xadr = BitVector_Interval_Substitute(Xadr,Yadr,Xoffset,Xlength,
                                                           Yoffset,Ylength);
            if (Xadr != NULL)
            {
                SvREADONLY_off(Xhdl);
                sv_setiv(Xhdl,(IV)Xadr);
                SvREADONLY_on(Xhdl);
            }
            else BIT_VECTOR_CREATE_ERROR("Interval_Substitute");
        }
        else BIT_VECTOR_OFFSET_ERROR("Interval_Substitute");
    }
    else BIT_VECTOR_TYPE_ERROR("Interval_Substitute");
}


boolean
BitVector_is_empty(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_is_empty(address);
    }
    else BIT_VECTOR_TYPE_ERROR("is_empty");
}
OUTPUT:
RETVAL


boolean
BitVector_is_full(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_is_full(address);
    }
    else BIT_VECTOR_TYPE_ERROR("is_full");
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

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
        {
            RETVAL = BitVector_equal(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("equal");
    }
    else BIT_VECTOR_TYPE_ERROR("equal");
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

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
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
BitVector_to_Hex(reference)
BitVector_Object	reference
ALIAS:
  to_String = 1
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        string = BitVector_to_Hex(address);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("to_Hex");
    }
    else BIT_VECTOR_TYPE_ERROR("to_Hex");
}


boolean
BitVector_from_hex(reference,string)
BitVector_Object	reference
charptr	string;
ALIAS:
  from_string = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_from_hex(address,string);
    }
    else BIT_VECTOR_TYPE_ERROR("from_hex");
}
OUTPUT:
RETVAL


void
BitVector_to_Bin(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        string = BitVector_to_Bin(address);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("to_Bin");
    }
    else BIT_VECTOR_TYPE_ERROR("to_Bin");
}


boolean
BitVector_from_bin(reference,string)
BitVector_Object	reference
charptr	string;
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_from_bin(address,string);
    }
    else BIT_VECTOR_TYPE_ERROR("from_bin");
}
OUTPUT:
RETVAL


void
BitVector_to_Dec(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        string = BitVector_to_Dec(address);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("to_Dec");
    }
    else BIT_VECTOR_TYPE_ERROR("to_Dec");
}


boolean
BitVector_from_dec(reference,string)
BitVector_Object	reference
charptr	string;
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    ErrCode           code;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (code = BitVector_from_dec(address,string))
        {
            if (code == ErrCode_Form) RETVAL = false;
            else BIT_VECTOR_EXCEPTION(code,"from_dec");
        }
        else RETVAL = true;
    }
    else BIT_VECTOR_TYPE_ERROR("from_dec");
}
OUTPUT:
RETVAL


void
BitVector_to_Enum(reference)
BitVector_Object	reference
ALIAS:
  to_ASCII = 1
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        string = BitVector_to_Enum(address);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("to_Enum");
    }
    else BIT_VECTOR_TYPE_ERROR("to_Enum");
}


boolean
BitVector_from_enum(reference,string)
BitVector_Object	reference
charptr	string;
ALIAS:
  from_ASCII = 1
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_from_enum(address,string);
    }
    else BIT_VECTOR_TYPE_ERROR("from_enum");
}
OUTPUT:
RETVAL


void
BitVector_Bit_Off(reference,index)
BitVector_Object	reference
N_int	index
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (index < bits_(address))
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
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (index < bits_(address))
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (index < bits_(address))
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
  in = 1
  contains = 2
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (index < bits_(address))
        {
            RETVAL = BitVector_bit_test(address,index);
        }
        else BIT_VECTOR_INDEX_ERROR("bit_test");
    }
    else BIT_VECTOR_TYPE_ERROR("bit_test");
}
OUTPUT:
RETVAL


void
BitVector_Bit_Copy(reference,index,bit)
BitVector_Object	reference
N_int	index
boolean	bit
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (index < bits_(address))
        {
            BitVector_Bit_Copy(address,index,bit);
        }
        else BIT_VECTOR_INDEX_ERROR("Bit_Copy");
    }
    else BIT_VECTOR_TYPE_ERROR("Bit_Copy");
}


boolean
BitVector_lsb(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_lsb(address);
    }
    else BIT_VECTOR_TYPE_ERROR("lsb");
}
OUTPUT:
RETVAL


boolean
BitVector_msb(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_msb(address);
    }
    else BIT_VECTOR_TYPE_ERROR("msb");
}
OUTPUT:
RETVAL


boolean
BitVector_rotate_left(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        BitVector_Move_Right(address,bits);
    }
    else BIT_VECTOR_TYPE_ERROR("Move_Right");
}


void
BitVector_Insert(reference,offset,count)
BitVector_Object	reference
N_int	offset
N_int	count
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < bits_(address))
        {
            BitVector_Insert(address,offset,count,true);
        }
        else BIT_VECTOR_OFFSET_ERROR("Insert");
    }
    else BIT_VECTOR_TYPE_ERROR("Insert");
}


void
BitVector_Delete(reference,offset,count)
BitVector_Object	reference
N_int	offset
N_int	count
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < bits_(address))
        {
            BitVector_Delete(address,offset,count,true);
        }
        else BIT_VECTOR_OFFSET_ERROR("Delete");
    }
    else BIT_VECTOR_TYPE_ERROR("Delete");
}


boolean
BitVector_increment(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_decrement(address);
    }
    else BIT_VECTOR_TYPE_ERROR("decrement");
}
OUTPUT:
RETVAL


boolean
BitVector_add(Xref,Yref,Zref,carry)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
boolean	carry
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
        {
            RETVAL = BitVector_add(Xadr,Yadr,Zadr,carry);
        }
        else BIT_VECTOR_SIZE_ERROR("add");
    }
    else BIT_VECTOR_TYPE_ERROR("add");
}
OUTPUT:
RETVAL


boolean
BitVector_subtract(Xref,Yref,Zref,carry)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
boolean	carry
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
        {
            RETVAL = BitVector_subtract(Xadr,Yadr,Zadr,carry);
        }
        else BIT_VECTOR_SIZE_ERROR("subtract");
    }
    else BIT_VECTOR_TYPE_ERROR("subtract");
}
OUTPUT:
RETVAL


void
BitVector_Negate(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
ALIAS:
  Neg = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
        {
            BitVector_Negate(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Negate");
    }
    else BIT_VECTOR_TYPE_ERROR("Negate");
}


void
BitVector_Absolute(Xref,Yref)
BitVector_Object	Xref
BitVector_Object	Yref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
        {
            BitVector_Absolute(Xadr,Yadr);
        }
        else BIT_VECTOR_SIZE_ERROR("Absolute");
    }
    else BIT_VECTOR_TYPE_ERROR("Absolute");
}


Z_int
BitVector_Sign(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = BitVector_Sign(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Sign");
}
OUTPUT:
RETVAL


void
BitVector_Multiply(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;
    ErrCode           code;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) >= bits_(Yadr)) and (bits_(Yadr) == bits_(Zadr)))
        {
            if (code = BitVector_Multiply(Xadr,Yadr,Zadr))
                BIT_VECTOR_EXCEPTION(code,"Multiply");
        }
        else BIT_VECTOR_SIZE_ERROR("Multiply");
    }
    else BIT_VECTOR_TYPE_ERROR("Multiply");
}


void
BitVector_Divide(Qref,Xref,Yref,Rref)
BitVector_Object	Qref
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Rref
CODE:
{
    BitVector_Handle  Qhdl;
    BitVector_Address Qadr;
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Rhdl;
    BitVector_Address Radr;
    ErrCode           code;

    if ( BIT_VECTOR_CHECK(Qref,Qhdl,Qadr) &&
         BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Rref,Rhdl,Radr) )
    {
        if ((bits_(Qadr) == bits_(Xadr)) and
            (bits_(Qadr) == bits_(Yadr)) and (bits_(Qadr) == bits_(Radr)))
        {
            if (Qadr != Radr)
            {
                if (not BitVector_is_empty(Yadr))
                {
                    if (code = BitVector_Divide(Qadr,Xadr,Yadr,Radr))
                        BIT_VECTOR_EXCEPTION(code,"Divide");
                }
                else BIT_VECTOR_ZERO_ERROR("Divide");
            }
            else BIT_VECTOR_DISTINCT_ERROR("Divide");
        }
        else BIT_VECTOR_SIZE_ERROR("Divide");
    }
    else BIT_VECTOR_TYPE_ERROR("Divide");
}


void
BitVector_GCD(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;
    ErrCode           code;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
        {
            if ((not BitVector_is_empty(Yadr)) and
                (not BitVector_is_empty(Zadr)))
            {
                if (code = BitVector_GCD(Xadr,Yadr,Zadr))
                    BIT_VECTOR_EXCEPTION(code,"GCD");
            }
            else BIT_VECTOR_ZERO_ERROR("GCD");
        }
        else BIT_VECTOR_SIZE_ERROR("GCD");
    }
    else BIT_VECTOR_TYPE_ERROR("GCD");
}


void
BitVector_Block_Store(reference,buffer)
BitVector_Object	reference
BitVector_Buffer	buffer
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;
    N_int length;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ( buffer && SvPOK(buffer) )
        {
            string = (charptr)SvPV(buffer,na);
            length = (N_int)SvCUR(buffer);
            BitVector_Block_Store(address,string,length);
        }
        else BIT_VECTOR_BUFFER_ERROR("Block_Store");
    }
    else BIT_VECTOR_TYPE_ERROR("Block_Store");
}


void
BitVector_Block_Read(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    charptr string;
    N_int length;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        string = BitVector_Block_Read(address,&length);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,(int)length)));
            BitVector_Dispose(string);
        }
        else BIT_VECTOR_STRING_ERROR("Block_Read");
    }
    else BIT_VECTOR_TYPE_ERROR("Block_Read");
}


N_int
BitVector_Word_Size(reference)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        RETVAL = size_(address);
    }
    else BIT_VECTOR_TYPE_ERROR("Word_Size");
}
OUTPUT:
RETVAL


void
BitVector_Word_Store(reference,offset,value)
BitVector_Object	reference
N_int	offset
N_int	value
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < size_(address))
        {
            BitVector_Word_Store(address,offset,value);
        }
        else BIT_VECTOR_OFFSET_ERROR("Word_Store");
    }
    else BIT_VECTOR_TYPE_ERROR("Word_Store");
}


N_int
BitVector_Word_Read(reference,offset)
BitVector_Object	reference
N_int	offset
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < size_(address))
        {
            RETVAL = BitVector_Word_Read(address,offset);
        }
        else BIT_VECTOR_OFFSET_ERROR("Word_Read");
    }
    else BIT_VECTOR_TYPE_ERROR("Word_Read");
}
OUTPUT:
RETVAL


void
BitVector_Word_List_Store(reference, ...)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int offset;
    N_int value;
    N_int size;
    I32 index;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        size = size_(address);
        for ( offset = 0, index = 1;
            ((offset < size) and (index < items)); offset++, index++ )
        {
            if (SvIOK( ST(index) ))
            {
                value = (N_int) SvIV( ST(index) );
                BitVector_Word_Store(address,offset,value);
            }
            else BIT_VECTOR_NUMERIC_ERROR("Word_List_Store");
        }
        for ( ; (offset < size); offset++ )
        {
            BitVector_Word_Store(address,offset,0);
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Word_List_Store");
}


void
BitVector_Word_List_Read(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int offset;
    N_int value;
    N_int size;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        size = size_(address);
        EXTEND(sp,size);
        for ( offset = 0; (offset < size); offset++ )
        {
            value = BitVector_Word_Read(address,offset);
            PUSHs(sv_2mortal(newSViv((IV)value)));
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Word_List_Read");
}


void
BitVector_Word_Insert(reference,offset,count)
BitVector_Object	reference
N_int	offset
N_int	count
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < size_(address))
        {
            BitVector_Word_Insert(address,offset,count,true);
        }
        else BIT_VECTOR_OFFSET_ERROR("Word_Insert");
    }
    else BIT_VECTOR_TYPE_ERROR("Word_Insert");
}


void
BitVector_Word_Delete(reference,offset,count)
BitVector_Object	reference
N_int	offset
N_int	count
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < size_(address))
        {
            BitVector_Word_Delete(address,offset,count,true);
        }
        else BIT_VECTOR_OFFSET_ERROR("Word_Delete");
    }
    else BIT_VECTOR_TYPE_ERROR("Word_Delete");
}


void
BitVector_Chunk_Store(reference,chunksize,offset,value)
BitVector_Object	reference
N_int	chunksize
N_int	offset
N_long	value
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < bits_(address))
        {
            if ((chunksize > 0) and (chunksize <= BitVector_Long_Bits()))
            {
                BitVector_Chunk_Store(address,offset,chunksize,value);
            }
            else BIT_VECTOR_CHUNK_ERROR("Chunk_Store");
        }
        else BIT_VECTOR_OFFSET_ERROR("Chunk_Store");
    }
    else BIT_VECTOR_TYPE_ERROR("Chunk_Store");
}


N_long
BitVector_Chunk_Read(reference,chunksize,offset)
BitVector_Object	reference
N_int	chunksize
N_int	offset
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (offset < bits_(address))
        {
            if ((chunksize > 0) and (chunksize <= BitVector_Long_Bits()))
            {
                RETVAL = BitVector_Chunk_Read(address,offset,chunksize);
            }
            else BIT_VECTOR_CHUNK_ERROR("Chunk_Read");
        }
        else BIT_VECTOR_OFFSET_ERROR("Chunk_Read");
    }
    else BIT_VECTOR_TYPE_ERROR("Chunk_Read");
}
OUTPUT:
RETVAL


void
BitVector_Chunk_List_Store(reference,chunksize, ...)
BitVector_Object	reference
N_int	chunksize
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_long chunkmask;
    N_long mask;
    N_long chunk;
    N_long value;
    N_int chunkbits;
    N_int wordbits;
    N_int wordsize;
    N_int offset;
    N_int size;
    N_int bits;
    I32 index;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ((chunksize > 0) and (chunksize <= BitVector_Long_Bits()))
        {
            wordsize = BitVector_Word_Bits();
            size = size_(address);
            chunkmask = ~((~0L << (chunksize-1)) << 1); /* C bug work-around */
            chunk = 0L;
            value = 0L;
            index = 2;
            offset = 0;
            wordbits = 0;
            chunkbits = 0;
            while (offset < size)
            {
                if ((chunkbits == 0) and (index < items))
                {
                    if (SvIOK( ST(index) ))
                    {
                        chunk = (N_long) SvIV( ST(index) );
                        chunk &= chunkmask;
                        chunkbits = chunksize;
                        index++;
                    }
                    else BIT_VECTOR_NUMERIC_ERROR("Chunk_List_Store");
                }
                bits = wordsize - wordbits;
                if (chunkbits <= bits)
                {
                    chunk <<= wordbits;
                    value |= chunk;
                    wordbits += chunkbits;
                    chunk = 0L;
                    chunkbits = 0;
                }
                else
                {
                    mask = ~(~0L << bits);
                    mask &= chunk;
                    mask <<= wordbits;
                    value |= mask;
                    wordbits += bits;
                    chunk >>= bits;
                    chunkbits -= bits;
                }
                if ((wordbits >= wordsize) or (index >= items))
                {
                    BitVector_Word_Store(address,offset,(N_int)value);
                    value = 0L;
                    wordbits = 0;
                    offset++;
                }
            }
        }
        else BIT_VECTOR_CHUNK_ERROR("Chunk_List_Store");
    }
    else BIT_VECTOR_TYPE_ERROR("Chunk_List_Store");
}


void
BitVector_Chunk_List_Read(reference,chunksize)
BitVector_Object	reference
N_int	chunksize
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_long chunk;
    N_long value;
    N_long mask;
    N_int chunkbits;
    N_int wordbits;
    N_int wordsize;
    N_int length;
    N_int index;
    N_int offset;
    N_int size;
    N_int bits;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if ((chunksize > 0) and (chunksize <= BitVector_Long_Bits()))
        {
            wordsize = BitVector_Word_Bits();
            bits = bits_(address);
            size = size_(address);
            length = (N_int) (bits / chunksize);
            if ((length * chunksize) < bits) length++;
            EXTEND(sp,length);
            chunk = 0L;
            value = 0L;
            index = 0;
            offset = 0;
            wordbits = 0;
            chunkbits = 0;
            while (index < length)
            {
                if ((wordbits == 0) and (offset < size))
                {
                    value = (N_long) BitVector_Word_Read(address,offset);
                    wordbits = wordsize;
                    offset++;
                }
                bits = chunksize - chunkbits;
                if (wordbits <= bits)
                {
                    value <<= chunkbits;
                    chunk |= value;
                    chunkbits += wordbits;
                    value = 0L;
                    wordbits = 0;
                }
                else
                {
                    mask = ~(~0L << bits);
                    mask &= value;
                    mask <<= chunkbits;
                    chunk |= mask;
                    chunkbits += bits;
                    value >>= bits;
                    wordbits -= bits;
                }
                if ((chunkbits >= chunksize) or
                    ((offset >= size) and (chunkbits > 0)))
                {
                    PUSHs(sv_2mortal(newSViv((IV)chunk)));
                    chunk = 0L;
                    chunkbits = 0;
                    index++;
                }
            }
        }
        else BIT_VECTOR_CHUNK_ERROR("Chunk_List_Read");
    }
    else BIT_VECTOR_TYPE_ERROR("Chunk_List_Read");
}


void
BitVector_Index_List_Remove(reference, ...)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int value;
    N_int bits;
    I32 index;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        bits = bits_(address);
        for ( index = 1; index < items; index++ )
        {
            if (SvIOK( ST(index) ))
            {
                value = (N_int) SvIV( ST(index) );
                if (value < bits)
                {
                    BitVector_Bit_Off(address,value);
                }
                else BIT_VECTOR_INDEX_ERROR("Index_List_Remove");
            }
            else BIT_VECTOR_NUMERIC_ERROR("Index_List_Remove");
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Index_List_Remove");
}


void
BitVector_Index_List_Store(reference, ...)
BitVector_Object	reference
CODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int value;
    N_int bits;
    I32 index;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        bits = bits_(address);
        for ( index = 1; index < items; index++ )
        {
            if (SvIOK( ST(index) ))
            {
                value = (N_int) SvIV( ST(index) );
                if (value < bits)
                {
                    BitVector_Bit_On(address,value);
                }
                else BIT_VECTOR_INDEX_ERROR("Index_List_Store");
            }
            else BIT_VECTOR_NUMERIC_ERROR("Index_List_Store");
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Index_List_Store");
}


void
BitVector_Index_List_Read(reference)
BitVector_Object	reference
PPCODE:
{
    BitVector_Handle  handle;
    BitVector_Address address;
    N_int size;
    N_int bits;
    N_int norm;
    N_int base;
    N_int word;
    N_int index;
    N_int value;

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        size = size_(address);
        bits = BitVector_Word_Bits();
        norm = Set_Norm(address);
        if (norm > 0)
        {
            EXTEND(sp,norm);
            for ( base = word = 0; word < size; word++, base += bits )
            {
                index = base;
                value = BitVector_Word_Read(address,word);
                while (value)
                {
                    if (value AND 0x0001)
                      PUSHs(sv_2mortal(newSViv((IV)index)));
                    value >>= 1;
                    index++;
                }
            }
        }
    }
    else BIT_VECTOR_TYPE_ERROR("Index_List_Read");
}


MODULE = Bit::Vector		PACKAGE = Bit::Vector		PREFIX = Set_


void
Set_Union(Xref,Yref,Zref)
BitVector_Object	Xref
BitVector_Object	Yref
BitVector_Object	Zref
ALIAS:
  Or = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
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
  And = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
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
  AndNot = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
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
  Xor = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;
    BitVector_Handle  Zhdl;
    BitVector_Address Zadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((bits_(Xadr) == bits_(Yadr)) and (bits_(Xadr) == bits_(Zadr)))
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
  Not = 2
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
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

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if (bits_(Xadr) == bits_(Yadr))
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
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

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) &&
         BIT_VECTOR_CHECK(Zref,Zhdl,Zadr) )
    {
        if ((colsY == rowsZ) and (rowsX == rowsY) and (colsX == colsZ) and
            (bits_(Xadr) == rowsX*colsX) and
            (bits_(Yadr) == rowsY*colsY) and
            (bits_(Zadr) == rowsZ*colsZ))
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

    if ( BIT_VECTOR_CHECK(reference,handle,address) )
    {
        if (rows == cols)
        {
            if (bits_(address) == rows*cols)
            {
                Matrix_Closure(address,rows,cols);
            }
            else BIT_VECTOR_MATRIX_ERROR("Closure");
        }
        else BIT_VECTOR_SHAPE_ERROR("Closure");
    }
    else BIT_VECTOR_TYPE_ERROR("Closure");
}


void
Matrix_Transpose(Xref,rowsX,colsX,Yref,rowsY,colsY)
BitVector_Object	Xref
N_int	rowsX
N_int	colsX
BitVector_Object	Yref
N_int	rowsY
N_int	colsY
CODE:
{
    BitVector_Handle  Xhdl;
    BitVector_Address Xadr;
    BitVector_Handle  Yhdl;
    BitVector_Address Yadr;

    if ( BIT_VECTOR_CHECK(Xref,Xhdl,Xadr) &&
         BIT_VECTOR_CHECK(Yref,Yhdl,Yadr) )
    {
        if ((rowsX == colsY) and (colsX == rowsY) and
            (bits_(Xadr) == rowsX*colsX) and
            (bits_(Yadr) == rowsY*colsY))
        {
            if ((Xadr != Yadr) or (rowsY == colsY))
            {
                Matrix_Transpose(Xadr,rowsX,colsX,
                                 Yadr,rowsY,colsY);
            }
            else BIT_VECTOR_INPLACE_ERROR("Transpose");
        }
        else BIT_VECTOR_MATRIX_ERROR("Transpose");
    }
    else BIT_VECTOR_TYPE_ERROR("Transpose");
}


