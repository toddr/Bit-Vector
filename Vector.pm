
#
#  Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.
#

package Bit::Vector;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION @CONFIG);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '5.0';

$CONFIG[0] = 0;
$CONFIG[1] = 0;
$CONFIG[2] = 0;

#  Configuration:
#
#  0 = Scalar Input:        0 = Bit Index   1 = from_hex
#                           2 = from_bin    3 = from_dec
#                           4 = from_enum
#
#  1 = Operator Semantics:  0 = Set Ops     1 = Arithmetic Ops
#
#      Affected Operators:  "+"  "-"  "*"  "<"  "<="  ">"  ">="  "abs"
#
#  2 = String Output:       0 = to_Hex()    1 = to_Bin()
#                           2 = to_Dec()    3 = to_Enum()

bootstrap Bit::Vector $VERSION;

use Carp;

use overload
      '""' => '_stringify',
     'neg' => '_negate',
       '~' => '_complement',
    'bool' => '_boolean',
       '!' => '_not_boolean',
     'abs' => '_absolute',
       '|' => '_union',
       '&' => '_intersection',
       '^' => '_exclusive_or',
      '<<' => '_move_left',
      '>>' => '_move_right',
       '+' => '_add',
       '-' => '_sub',
       '*' => '_mul',
       '/' => '_div',
       '%' => '_mod',
      '|=' => '_assign_union',
      '&=' => '_assign_intersection',
      '^=' => '_assign_exclusive_or',
     '<<=' => '_assign_move_left',
     '>>=' => '_assign_move_right',
      '+=' => '_assign_add',
      '-=' => '_assign_sub',
      '*=' => '_assign_mul',
      '/=' => '_assign_div',
      '%=' => '_assign_mod',
      '++' => '_increment',
      '--' => '_decrement',
      '==' => '_equal',
      '!=' => '_not_equal',
       '<' => '_less_than',
      '<=' => '_less_equal',
       '>' => '_greater_than',
      '>=' => '_greater_equal',
     'cmp' => '_compare',              # also enables lt, le, gt, ge, eq, ne
       '=' => '_clone',
'fallback' =>   undef;

sub Configuration
{
    my(@commands);
    my($assignment);
    my($which,$value);
    my($m0,$m1,$m2,$m3,$m4);
    my($result);
    my($ok);

    croak
'Usage: $configuration = Bit::Vector->Configuration( [ $configuration ] );'
    if (@_ > 2);

    $ok = 1;
    shift if (@_ > 0);
    if (@_ > 0)
    {
        @commands = split(/[,;:|\/\n&+-]/, $_[0]);
        foreach $assignment (@commands)
        {
            if    ($assignment =~ /^\s*$/) { }  #  ignore empty lines
            elsif ($assignment =~ /^([A-Za-z\s]+)=([A-Za-z\s]+)$/)
            {
                $which = $1;
                $value = $2;
                $m0 = 0;
                $m1 = 0;
                $m2 = 0;
                if ($which =~ /\bScalar|\bInput|\bIn\b/i)       { $m0 = 1; }
                if ($which =~ /\bOperator|\bSemantic|\bOps\b/i) { $m1 = 1; }
                if ($which =~ /\bString|\bOutput|\bOut\b/i)     { $m2 = 1; }
                if    ($m0 && !$m1 && !$m2)
                {
                    $m0 = 0;
                    $m1 = 0;
                    $m2 = 0;
                    $m3 = 0;
                    $m4 = 0;
                    if ($value =~ /\bBit\b|\bIndex|\bIndice/i) { $m0 = 1; }
                    if ($value =~ /\bHex/i)                    { $m1 = 1; }
                    if ($value =~ /\bBin/i)                    { $m2 = 1; }
                    if ($value =~ /\bDec/i)                    { $m3 = 1; }
                    if ($value =~ /\bEnum/i)                   { $m4 = 1; }
                    if    ($m0 && !$m1 && !$m2 && !$m3 && !$m4) { $CONFIG[0] = 0; }
                    elsif (!$m0 && $m1 && !$m2 && !$m3 && !$m4) { $CONFIG[0] = 1; }
                    elsif (!$m0 && !$m1 && $m2 && !$m3 && !$m4) { $CONFIG[0] = 2; }
                    elsif (!$m0 && !$m1 && !$m2 && $m3 && !$m4) { $CONFIG[0] = 3; }
                    elsif (!$m0 && !$m1 && !$m2 && !$m3 && $m4) { $CONFIG[0] = 4; }
                    else                                        { $ok = 0; last; }
                }
                elsif (!$m0 && $m1 && !$m2)
                {
                    $m0 = 0;
                    $m1 = 0;
                    if ($value =~ /\bSet\b/i)      { $m0 = 1; }
                    if ($value =~ /\bArithmetic/i) { $m1 = 1; }
                    if    ($m0 && !$m1) { $CONFIG[1] = 0; }
                    elsif (!$m0 && $m1) { $CONFIG[1] = 1; }
                    else                { $ok = 0; last; }
                }
                elsif (!$m0 && !$m1 && $m2)
                {
                    $m0 = 0;
                    $m1 = 0;
                    $m2 = 0;
                    $m3 = 0;
                    if ($value =~ /\bHex/i)  { $m0 = 1; }
                    if ($value =~ /\bBin/i)  { $m1 = 1; }
                    if ($value =~ /\bDec/i)  { $m2 = 1; }
                    if ($value =~ /\bEnum/i) { $m3 = 1; }
                    if    ($m0 && !$m1 && !$m2 && !$m3) { $CONFIG[2] = 0; }
                    elsif (!$m0 && $m1 && !$m2 && !$m3) { $CONFIG[2] = 1; }
                    elsif (!$m0 && !$m1 && $m2 && !$m3) { $CONFIG[2] = 2; }
                    elsif (!$m0 && !$m1 && !$m2 && $m3) { $CONFIG[2] = 3; }
                    else                                { $ok = 0; last; }
                }
                else { $ok = 0; last; }
            }
            else { $ok = 0; last; }
        }
    }
    if ($ok)
    {
        $result = "Scalar Input       = ";
        if    ($CONFIG[0] == 4) { $result .= "Enumeration"; }
        elsif ($CONFIG[0] == 3) { $result .= "Decimal"; }
        elsif ($CONFIG[0] == 2) { $result .= "Binary"; }
        elsif ($CONFIG[0] == 1) { $result .= "Hexadecimal"; }
        else                    { $result .= "Bit Index"; }
        $result .= "\nOperator Semantics = ";
        if    ($CONFIG[1] == 1) { $result .= "Arithmetic Operators"; }
        else                    { $result .= "Set Operators"; }
        $result .= "\nString Output      = ";
        if    ($CONFIG[2] == 3) { $result .= "Enumeration"; }
        elsif ($CONFIG[2] == 2) { $result .= "Decimal"; }
        elsif ($CONFIG[2] == 1) { $result .= "Binary"; }
        else                    { $result .= "Hexadecimal"; }
        return($result);
    }
    else
    {
        croak
'Bit::Vector::Configuration(): syntax error in configuration string';
    }
}

sub _fetch_operand
{
    my($name,$object,$argument,$build) = @_;
    my($operand);
    my($ok);

    if ((defined $argument) && ref($argument) && (ref($argument) !~ /^[A-Z]+$/))
    {
        if ($build) { $operand = $argument->Clone(); }
        else        { $operand = $argument; }
    }
    elsif ((defined $argument) && !(ref($argument)))
    {
        $operand = $object->Shadow();
        if    ($CONFIG[0] == 4) { $ok = $operand->from_enum($argument); }
        elsif ($CONFIG[0] == 3) { $ok = $operand->from_dec($argument);  }
        elsif ($CONFIG[0] == 2) { $ok = $operand->from_bin($argument);  }
        elsif ($CONFIG[0] == 1) { $ok = $operand->from_hex($argument);  }
        else                    { $ok = 1; $operand->Bit_On($argument); }
        if (!$ok) { croak "Bit::Vector $name: scalar argument error"; }
    }
    else { croak "Bit::Vector $name: argument type error"; }
    return($operand);
}

sub _check_operand
{
    my($name,$argument,$flag) = @_;

    if ((defined $argument) && !(ref($argument)))
    {
        if ((defined $flag) && $flag)
        {
            croak "Bit::Vector $name: reversed arguments error";
        }
    }
    else { croak "Bit::Vector $name: argument type error"; }
}

sub _stringify
{
    my($object) = @_;

    if    ($CONFIG[2] == 3) { return( $object->to_Enum() ); }
    elsif ($CONFIG[2] == 2) { return( $object->to_Dec()  ); }
    elsif ($CONFIG[2] == 1) { return( $object->to_Bin()  ); }
    else                    { return( $object->to_Hex()  ); }
}

sub _negate
{
    my($object) = @_;
    my($result);

    $result = $object->Shadow();
    $result->Negate($object);
    return($result);
}

sub _complement
{
    my($object) = @_;
    my($result);

    $result = $object->Shadow();
    $result->Complement($object);
    return($result);
}

sub _boolean
{
    my($object) = @_;

    return( ! $object->is_empty() );
}

sub _not_boolean
{
    my($object) = @_;

    return( $object->is_empty() );
}

sub _absolute
{
    my($object) = @_;
    my($result);

    if ($CONFIG[1] == 1)
    {
        $result = $object->Shadow();
        $result->Absolute($object);
        return($result);
    }
    else
    {
        return( $object->Norm() );
    }
}

sub _union_
{
    my($object,$operand,$flag) = @_;

    if (defined $flag)
    {
        $operand->Union($object,$operand);
        return($operand);
    }
    else
    {
        $object->Union($object,$operand);
        return($object);
    }
}

sub _union
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'|'",$object,$argument,1);

    return ( &_union_($object,$operand,$flag) );
}

sub _intersection_
{
    my($object,$operand,$flag) = @_;

    if (defined $flag)
    {
        $operand->Intersection($object,$operand);
        return($operand);
    }
    else
    {
        $object->Intersection($object,$operand);
        return($object);
    }
}

sub _intersection
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'&'",$object,$argument,1);

    return ( &_intersection_($object,$operand,$flag) );
}

sub _exclusive_or
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'^'",$object,$argument,1);

    if (defined $flag)
    {
        $operand->ExclusiveOr($object,$operand);
        return($operand);
    }
    else
    {
        $object->ExclusiveOr($object,$operand);
        return($object);
    }
}

sub _move_left
{
    my($object,$argument,$flag) = @_;
    my($result);

    &_check_operand("'<<'",$argument,$flag);
    if (defined $flag)
    {
        $result = $object->Clone();
        $result->Move_Left($argument);
        return($result);
    }
    else
    {
        $object->Move_Left($argument);
        return($object);
    }
}

sub _move_right
{
    my($object,$argument,$flag) = @_;
    my($result);

    &_check_operand("'>>'",$argument,$flag);
    if (defined $flag)
    {
        $result = $object->Clone();
        $result->Move_Right($argument);
        return($result);
    }
    else
    {
        $object->Move_Right($argument);
        return($object);
    }
}

sub _add
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'+'",$object,$argument,1);

    if ($CONFIG[1] == 1)
    {
        if (defined $flag)
        {
            $operand->add($object,$operand,0);
            return($operand);
        }
        else
        {
            $object->add($object,$operand,0);
            return($object);
        }
    }
    else
    {
        return( &_union_($object,$operand,$flag) );
    }
}

sub _sub
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'-'",$object,$argument,1);

    if ($CONFIG[1] == 1)
    {
        if (defined $flag)
        {
            if ($flag) { $operand->subtract($operand,$object,0); }
            else       { $operand->subtract($object,$operand,0); }
            return($operand);
        }
        else
        {
            $object->subtract($object,$operand,0);
            return($object);
        }
    }
    else
    {
        if (defined $flag)
        {
            if ($flag) { $operand->Difference($operand,$object); }
            else       { $operand->Difference($object,$operand); }
            return($operand);
        }
        else
        {
            $object->Difference($object,$operand);
            return($object);
        }
    }
}

sub _mul
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'*'",$object,$argument,1);

    if ($CONFIG[1] == 1)
    {
        if (defined $flag)
        {
            $operand->Multiply($object,$operand);
            return($operand);
        }
        else
        {
            $object->Multiply($object,$operand);
            return($object);
        }
    }
    else
    {
        return( &_intersection_($object,$operand,$flag) );
    }
}

sub _div
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'/'",$object,$argument,1);
    my($temp) = $object->Shadow();

    if (defined $flag)
    {
        if ($flag) { $operand->Divide($operand,$object,$temp); }
        else       { $operand->Divide($object,$operand,$temp); }
        return($operand);
    }
    else
    {
        $object->Divide($object,$operand,$temp);
        return($object);
    }
}

sub _mod
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'%'",$object,$argument,1);
    my($temp) = $object->Shadow();

    if (defined $flag)
    {
        if ($flag) { $temp->Divide($operand,$object,$operand); }
        else       { $temp->Divide($object,$operand,$operand); }
        return($operand);
    }
    else
    {
        $temp->Divide($object,$operand,$object);
        return($object);
    }
}

sub _assign_union
{
    my($object,$argument) = @_;

    return( &_union($object,$argument,undef) );
}

sub _assign_intersection
{
    my($object,$argument) = @_;

    return( &_intersection($object,$argument,undef) );
}

sub _assign_exclusive_or
{
    my($object,$argument) = @_;

    return( &_exclusive_or($object,$argument,undef) );
}

sub _assign_move_left
{
    my($object,$argument) = @_;

    return( &_move_left($object,$argument,undef) );
}

sub _assign_move_right
{
    my($object,$argument) = @_;

    return( &_move_right($object,$argument,undef) );
}

sub _assign_add
{
    my($object,$argument) = @_;

    return( &_add($object,$argument,undef) );
}

sub _assign_sub
{
    my($object,$argument) = @_;

    return( &_sub($object,$argument,undef) );
}

sub _assign_mul
{
    my($object,$argument) = @_;

    return( &_mul($object,$argument,undef) );
}

sub _assign_div
{
    my($object,$argument) = @_;

    return( &_div($object,$argument,undef) );
}

sub _assign_mod
{
    my($object,$argument) = @_;

    return( &_mod($object,$argument,undef) );
}

sub _increment
{
    my($object) = @_;

    return( $object->increment() );
}

sub _decrement
{
    my($object) = @_;

    return( $object->decrement() );
}

sub _equal
{
    my($object,$argument) = @_;
    my($operand) = &_fetch_operand("'=='",$object,$argument,0);

    return( $object->equal($operand) );
}

sub _not_equal
{
    my($object,$argument) = @_;
    my($operand) = &_fetch_operand("'!='",$object,$argument,0);

    return( !$object->equal($operand) );
}

sub _less_than
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'<'",$object,$argument,0);

    if ($CONFIG[1] == 1)
    {
        if ((defined $flag) && $flag)
        {
            return( $operand->Compare($object) < 0 );
        }
        else
        {
            return( $object->Compare($operand) < 0 );
        }
    }
    else
    {
        if ((defined $flag) && $flag)
        {
            return( !($operand->equal($object)) &&
                     ($operand->subset($object)) );
        }
        else
        {
            return( !($object->equal($operand)) &&
                     ($object->subset($operand)) );
        }
    }
}

sub _less_equal
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'<='",$object,$argument,0);

    if ($CONFIG[1] == 1)
    {
        if ((defined $flag) && $flag)
        {
            return( $operand->Compare($object) <= 0 );
        }
        else
        {
            return( $object->Compare($operand) <= 0 );
        }
    }
    else
    {
        if ((defined $flag) && $flag)
        {
            return( $operand->subset($object) );
        }
        else
        {
            return( $object->subset($operand) );
        }
    }
}

sub _greater_than
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'>'",$object,$argument,0);

    if ($CONFIG[1] == 1)
    {
        if ((defined $flag) && $flag)
        {
            return( $operand->Compare($object) > 0 );
        }
        else
        {
            return( $object->Compare($operand) > 0 );
        }
    }
    else
    {
        if ((defined $flag) && $flag)
        {
            return( !($object->equal($operand)) &&
                     ($object->subset($operand)) );
        }
        else
        {
            return( !($operand->equal($object)) &&
                     ($operand->subset($object)) );
        }
    }
}

sub _greater_equal
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'>='",$object,$argument,0);

    if ($CONFIG[1] == 1)
    {
        if ((defined $flag) && $flag)
        {
            return( $operand->Compare($object) >= 0 );
        }
        else
        {
            return( $object->Compare($operand) >= 0 );
        }
    }
    else
    {
        if ((defined $flag) && $flag)
        {
            return( $object->subset($operand) );
        }
        else
        {
            return( $operand->subset($object) );
        }
    }
}

sub _compare
{
    my($object,$argument,$flag) = @_;
    my($operand) = &_fetch_operand("'cmp'",$object,$argument,0);

    if ((defined $flag) && $flag)
    {
        return( $operand->Compare($object) );
    }
    else
    {
        return( $object->Compare($operand) );
    }
}

sub _clone
{
    my($object) = @_;

    return( $object->Clone() );
}

1;

__END__

=head1 NAME

Bit::Vector - arbitrary length bit vectors base class

This module implements efficient methods for handling bit vectors.

It is intended to serve as a base class for other applications or
application classes, such as implementing sets or performing big
integer arithmetic, for example.

All methods are internally implemented in C for maximum performance.

The module also provides overloaded arithmetic and relational operators
for maximum ease of use.

=head1 SYNOPSIS

=head2 CLASS METHODS (implemented in C)

  Version
      $version = Bit::Vector->Version();

  Word_Bits
      $bits = Bit::Vector->Word_Bits();  #  bits in a machine word

  Long_Bits
      $bits = Bit::Vector->Long_Bits();  #  bits in an unsigned long

  new
      $vector = Bit::Vector->new($bits);

=head2 OBJECT METHODS (implemented in C)

  new
      $vec2 = $vec1->new($bits);

  Shadow
      $vec2 = $vec1->Shadow();  #  new vector, same size but empty

  Clone
      $vec2 = $vec1->Clone();  #  new vector, exact copy

  Size
      $bits = $vector->Size();

  Resize
      $vector->Resize($bits);
      $vector->Resize($vector->Size()+5);
      $vector->Resize($vector->Size()-5);

  Copy
      $vec2->Copy($vec1);

  Empty
      $vector->Empty();

  Fill
      $vector->Fill();

  Flip
      $vector->Flip();

  Primes
      $vector->Primes();  #  Sieve of Erathostenes

  Interval_Empty
      $vector->Interval_Empty($min,$max);

  Interval_Fill
      $vector->Interval_Fill($min,$max);

  Interval_Flip
      $vector->Interval_Flip($min,$max);

  Interval_Scan_inc
      if (($min,$max) = $vector->Interval_Scan_inc($start))

  Interval_Scan_dec
      if (($min,$max) = $vector->Interval_Scan_dec($start))

  Interval_Copy
      $vec2->Interval_Copy($vec1,$offset2,$offset1,$length);

  Interval_Substitute
      $vec2->Interval_Substitute($vec1,$off2,$len2,$off1,$len1);

  is_empty
      if ($vector->is_empty())

  is_full
      if ($vector->is_full())

  equal
      if ($vec1->equal($vec2))

  Compare
      if ($vec1->Compare($vec2) == 0)  #  true if $vec1 == $vec2
      if ($vec1->Compare($vec2) != 0)  #  true if $vec1 != $vec2
      if ($vec1->Compare($vec2) <  0)  #  true if $vec1 <  $vec2
      if ($vec1->Compare($vec2) <= 0)  #  true if $vec1 <= $vec2
      if ($vec1->Compare($vec2) >  0)  #  true if $vec1 >  $vec2
      if ($vec1->Compare($vec2) >= 0)  #  true if $vec1 >= $vec2

  to_Hex
      $string = $vector->to_Hex();

  from_hex
      $ok = $vector->from_hex($string);

  to_Bin
      $string = $vector->to_Bin();

  from_bin
      $ok = $vector->from_bin($string);

  to_Dec
      $string = $vector->to_Dec();

  from_dec
      $ok = $vector->from_dec($string);

  to_Enum
      $string = $vector->to_Enum();  #  e.g. "2,3,5-7,11,13-19"

  from_enum
      $ok = $vector->from_enum($string);

  Bit_Off
      $vector->Bit_Off($index);

  Bit_On
      $vector->Bit_On($index);

  bit_flip
      $bit = $vector->bit_flip($index);

  bit_test, contains
      $bit = $vector->bit_test($index);
      $bit = $vector->contains($index);
      if ($vector->bit_test($index))
      if ($vector->contains($index))

  Bit_Copy
      $vector->Bit_Copy($index,$bit);

  lsb
      $bit = $vector->lsb();

  msb
      $bit = $vector->msb();

  rotate_left
      $carry = $vector->rotate_left();

  rotate_right
      $carry = $vector->rotate_right();

  shift_left
      $carry = $vector->shift_left($carry);

  shift_right
      $carry = $vector->shift_right($carry);

  Move_Left
      $vector->Move_Left($bits);  #  shift left "$bits" positions

  Move_Right
      $vector->Move_Right($bits);  #  shift right "$bits" positions

  Insert
      $vector->Insert($offset,$bits);

  Delete
      $vector->Delete($offset,$bits);

  increment
      $carry = $vector->increment();

  decrement
      $carry = $vector->decrement();

  add
      $carry = $vec3->add($vec1,$vec2,$carry);

  subtract
      $carry = $vec3->subtract($vec1,$vec2,$carry);

  Negate
      $vec2->Negate($vec1);

  Absolute
      $vec2->Absolute($vec1);

  Sign
      if ($vector->Sign() == 0)
      if ($vector->Sign() != 0)
      if ($vector->Sign() <  0)
      if ($vector->Sign() <= 0)
      if ($vector->Sign() >  0)
      if ($vector->Sign() >= 0)

  Multiply
      $vec3->Multiply($vec1,$vec2);

  Divide
      $quot->Divide($vec1,$vec2,$rest);

  GCD (Greatest Common Divisor)
      $vec3->GCD($vec1,$vec2);

  Block_Store
      $vector->Block_Store($buffer);

  Block_Read
      $buffer = $vector->Block_Read();

  Word_Size
      $size = $vector->Word_Size();  #  number of words in "$vector"

  Word_Store
      $vector->Word_Store($offset,$word);

  Word_Read
      $word = $vector->Word_Read($offset);

  Word_List_Store
      $vector->Word_List_Store(@words);

  Word_List_Read
      @words = $vector->Word_List_Read();

  Word_Insert
      $vector->Word_Insert($offset,$count);

  Word_Delete
      $vector->Word_Delete($offset,$count);

  Chunk_Store
      $vector->Chunk_Store($chunksize,$offset,$chunk);

  Chunk_Read
      $chunk = $vector->Chunk_Read($chunksize,$offset);

  Chunk_List_Store
      $vector->Chunk_List_Store($chunksize,@chunks);

  Chunk_List_Read
      @chunks = $vector->Chunk_List_Read($chunksize);

  Union
      $set3->Union($set1,$set2);

  Intersection
      $set3->Intersection($set1,$set2);

  Difference
      $set3->Difference($set1,$set2);

  ExclusiveOr
      $set3->ExclusiveOr($set1,$set2);

  Complement
      $set2->Complement($set1);

  subset
      if ($set1->subset($set2))  #  true if $set1 is subset of $set2

  Norm
      $norm = $set->Norm();

  Min
      $min = $set->Min();

  Max
      $max = $set->Max();

  Multiplication
      $matrix3->Multiplication($rows3,$cols3,
                      $matrix1,$rows1,$cols1,
                      $matrix2,$rows2,$cols2);

  Closure
      $matrix->Closure($rows,$cols);

  Transpose
      $matrix2->Transpose($rows2,$cols2,$matrix1,$rows1,$cols1);

=head2 CLASS METHODS (implemented in Perl)

  Configuration
      $config = Bit::Vector->Configuration();
      Bit::Vector->Configuration($config);
      $config = Bit::Vector->Configuration($config);

=head2 OVERLOADED OPERATORS (implemented in Perl)

(under construction)

=head1 IMPORTANT NOTES

=over 2

=item *

Method naming convention

Method names completely in lower case indicate a boolean return value.

(Except for the bit vector constructor method "C<new()>", of course.)

=item *

Boolean return values

Boolean return values from this module are always a numeric
zero ("0") for "false" and a numeric one ("1") for "true".

=item *

Bit indices

All bit indices are handled as unsigned numbers internally.

If you pass a negative number as a bit index to some method
in this module, it will be treated as a (usually very large)
positive number due to its internal 2's complement representation,
usually resulting in an error message "index out of range"
and program abortion.

=back

=head1 DESCRIPTION

(under construction)

=head1 SEE ALSO

Set::IntegerFast(3), Set::IntegerRange(3), Math::MatrixBool(3),
Math::MatrixReal(3), DFA::Kleene(3), Math::Kleene(3), Graph::Kruskal(3).

perl(1), perlsub(1), perlmod(1), perlref(1), perlobj(1), perlbot(1),
perltoot(1), perlxs(1), perlxstut(1), perlguts(1), overload(3).

=head1 VERSION

This man page documents "Bit::Vector" version 5.0.

=head1 AUTHOR

Steffen Beyer <sb@sdm.de>.

=head1 COPYRIGHT

Copyright (c) 1995, 1996, 1997 by Steffen Beyer. All rights reserved.

=head1 LICENSE

You may freely use (and modify) this package and its parts for your
personal and any non-profit use.

This package or its parts may not be included into any commercial product
whatsoever, nor may it be used to provide services to customers against
payment, without prior written consent from its author, Steffen Beyer.

You may also freely redistribute VERBATIM copies of this package
provided that you don't charge for them.

(Shareware CD etc. publishers please contact the author first; you
will usually get permission to include this package on CD etc. free
of charges provided that the costs of the CD (or the like) for the
final customer will be within reasonable limits.)

Modified versions of this package or parts thereof may not be
redistributed without prior written permission from its author.

Patches in form of UNIX "diff" files or from equivalent programs
do not require such a permission and remain the property of their
respective author(s).

=head1 DISCLAIMER

This package is provided "as is", without any warranty, neither express
nor implied, including, but not limited to, the implied warranty of
merchantability, regarding the fitness of this package or any of its
parts for any particular purpose or the accuracy of its documentation.

In no event will the author be liable for any damage that may result
from the use (or non-use) of or inability to use this package and its
documentation, even if the author has been advised of the possibility
of such damage.

