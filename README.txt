Sunday, March 7, 1999

This is the Bit::Vector module with shared libraries compiled for MacPerl.  
Shared libraries run only on PPC and CFM68K versions, not non-CFM 68K 
versions.

Installation.

If you're reading this you may have downloaded with a browser, and Stuffit 
Expander helpfully unpacked everything for you.  This is actually not so 
good, as many of your files probably still have the wrong line-ends.

If you've got the RAM and easy access to the Internet, consider using 
CPAN.pm (the Mac version) for future MacPerl installations.  But for this 
one here, the best thing to do is drop the original '.tgz' file onto one of 
Chris Nandor's utility scripts: 'installme.plx' if you're doing OK on RAM, 
and 'untarzipme.plx' if not.

After using only 'untarzipme.plx', install the files in ':blib:lib' into 
your 'site_perl' folder; that, after all, is what it is meant for -

    {MACPERL}site_perl:Bit:Vector.pm
    {MACPERL}site_perl:MacCFM68K:auto:Bit:Vector:Vector
    {MACPERL}site_perl:MacPPC:auto:Bit:Vector:Vector

Also read the original README.txt file for this distribution, included below.
(With special attention to the "What does it do" and "Example Applications" 
sections; try to ignore everything else).

This is my first distribution where I'm rationalizing where files go. The 
'bindist.convention' page on CPAN has guides for naming an overall binary 
distribution, and suggestions for the Readme file, but all bets are off, 
seemingly, as to the organization of a binary.

It seems to make the most sense to me that, since this is a binary for Mac 
users, the distribution is ready to go right out of the box. What I mean by 
that is, someone with Codewarrior MPW can use the MPPE build procedure 
right from the gitgo.

The original files, if changes were made, are in folder 'Original_Files'. 
For extra reference, I've diffed everything, and you can find the patches 
(if you want to consider them that) in folder 'Diffs'.

Technical Notes. There are no separate notes for this distribution. That's 
why I included the diffs, if you're bloody-minded and want to see what was 
changed. :-)

Testing.  The 't' files have been tested using both the MacPerl application 
and the MPW perl tool.  When testing before installation, use the -I switch 
(perl tool in MPW) or Edit>Preferences (MacPerl app) to add ':blib:lib' to 
your path, and make sure it precedes all others.

I also tested Math::MatrixBool against this, since it 'uses' Bit::Vector.

I strongly recommend not running the tests as scripts. Between the various 
't' tests there are 67,211 subtests, each resulting in a line of output. I 
wrote a little script, 'test_harness.plx', which in conjunction with 
the MPW Shell gives you some capability to test en masse. It's pretty easily
adapted for use with the MP application, too. I'm thrashing around with
scoping issues with Version 2. :-)

Here's a test run on MPW that I did (FYI):

For testf In `Files :t:Å.t`
	perl -I ':blib:lib' test_harness.plx {testf}
End

:t:00____version.t.....ok (10/0) (OK/NOK)
:t:01________new.t.....ok (131/0) (OK/NOK)
:t:02____destroy.t.....ok (15/0) (OK/NOK)
:t:03_operations.t.....ok (232/0) (OK/NOK)
:t:04__functions.t.....ok (21/0) (OK/NOK)
:t:05_____primes.t.....ok (2008/0) (OK/NOK)
:t:06_____subset.t.....ok (6/0) (OK/NOK)
:t:07____compare.t.....ok (50/0) (OK/NOK)
:t:08_____resize.t.....ok (57/0) (OK/NOK)
:t:09_parameters.t.....ok (920/0) (OK/NOK)
:t:10__intervals.t.....ok (4024/0) (OK/NOK)
:t:11______shift.t.....ok (36416/0) (OK/NOK)
:t:12_____string.t.....ok (192/0) (OK/NOK)
:t:13__increment.t.....ok (5296/0) (OK/NOK)
:t:14______empty.t.....ok (40/0) (OK/NOK)
:t:15________add.t.....ok (1001/0) (OK/NOK)
:t:16___subtract.t.....ok (1001/0) (OK/NOK)
:t:28__chunklist.t.....ok (96/0) (OK/NOK)
:t:30_overloaded.t.....ok (15695/0) (OK/NOK)

*****

Arved Sandstrom          mailto:Arved_37@chebucto.ns.ca

*****

                    =====================================
                      Package "Bit::Vector" Version 5.6
                    =====================================


This package is available for download either from my web site at

                  http://www.engelschall.com/u/sb/download/

or from any CPAN (= "Comprehensive Perl Archive Network") mirror server:

                  http://www.perl.com/CPAN/authors/id/STBEY/


The package consists of a C library (designed for maximum efficiency)
which is the core of a Perl module (designed for maximum ease of use).

The C library is specifically designed so that it can be used stand-alone,
without Perl.


Legal issues:
-------------

This package with all its parts is

Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.
All rights reserved.

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself, i.e., under the
terms of the "Artistic License" or the "GNU General Public License".

The C library at the core of this Perl module can additionally
be redistributed and/or modified under the terms of the
"GNU Library General Public License".

Please refer to the files "Artistic.txt", "GNU_GPL.txt" and
"GNU_LGPL.txt" in this distribution for details!


Prerequisites:
--------------

Perl version 5.000 or higher, and an ANSI C compiler (!)
                                     ^^^^^^


Installation:
-------------

Please see the file "INSTALL.txt" in this distribution for instructions
on how to install this package.


Changes over previous versions:
-------------------------------

Please refer to the file "CHANGES.txt" in this distribution for a detailed
version history and instructions on how to upgrade existing applications.


Documentation:
--------------

The documentation to this package is included in POD format (= "Plain Old
Documentation") in the file "Vector.pm" in this distribution, the human-
readable markup-language standard for Perl documentation.

By building this package, this documentation will automatically be converted
into a man page, which will automatically be installed in your Perl tree for
further reference in this process, where it can be accessed via the command
"man Bit::Vector" (UNIX) or "perldoc Bit::Vector" (UNIX and Win32).

If Perl is not available on your system, you can also read this documentation
directly.


What does it do:
----------------

This module is useful for a large range of different tasks:

  -  For example for implementing sets and performing set operations
     (like union, difference, intersection, complement, check for subset
     relationship etc.),

  -  as a basis for many efficient algorithms, for instance the
     "Sieve of Erathostenes" (for calculating prime numbers),

     (The complexities of the methods in this module are usually either
      O(1) or O(n/b), where "b" is the number of bits in a machine word
      on your system.)

  -  for shift registers of arbitrary length (for example for cyclic
     redundancy checksums),

  -  to calculate "look-ahead", "first" and "follow" character sets
     for parsers and compiler-compilers,

  -  for graph algorithms,

  -  for efficient storage and retrieval of status information,

  -  for performing text synthesis ruled by boolean expressions,

  -  for "big integer" arithmetic with arbitrarily large integers,

  -  for manipulations of chunks of bits of arbitrary size,

  -  for bitwise processing of audio CD wave files,

  -  to convert formats of data files,

and more.

(A number of example applications is available from my web site at
http://www.engelschall.com/u/sb/download/.)

A large number of import/export methods allow you to access individual
bits, contiguous ranges of bits, machine words, arbitrary chunks of
bits, lists (arrays) of chunks of bits or machine words and a whole
bit vector at once (for instance for blockwrite/-read to and from
a file).

You can also import and export the contents of a bit vector in binary,
hexadecimal and decimal representation as well as ".newsrc" style
enumerations.

Note that this module is specifically designed for efficiency, which is
also the reason why its methods are implemented in C.

To further increase execution speed, the module doesn't use bytes as its
basic storage unit, but rather uses machine words, assuming that a machine
word is the most efficiently handled size of all scalar types on all
machines (that's what the ANSI C standard proposes and assumes anyway).

In order to achieve this, it automatically determines the number of bits
in a machine word on your system and then adjusts its internal configuration
constants accordingly.

The greater the size of this basic storage unit, the better the complexity
(= execution speed) of the methods in this module, but also the greater the
average waste of unused bits in the last word.

The range of available methods is exceptionally large for this kind of library;
in detail:

Version()                Word_Bits()              Long_Bits()
new()                    new_Hex()                new_Bin()
new_Dec()                new_Enum()               Shadow()
Clone()                  Concat()                 Concat_List()
Size()                   Resize()                 Copy()
Empty()                  Fill()                   Flip()
Primes()                 Reverse()                Interval_Empty()
Interval_Fill()          Interval_Flip()          Interval_Reverse()
Interval_Scan_inc()      Interval_Scan_dec()      Interval_Copy()
Interval_Substitute()    is_empty()               is_full()
equal()                  Lexicompare()            Compare()
to_Hex()                 from_Hex()               to_Bin()
from_Bin()               to_Dec()                 from_Dec()
to_Enum()                from_Enum()              Bit_Off()
Bit_On()                 bit_flip()               bit_test()
Bit_Copy()               LSB()                    MSB()
lsb()                    msb()                    rotate_left()
rotate_right()           shift_left()             shift_right()
Move_Left()              Move_Right()             Insert()
Delete()                 increment()              decrement()
add()                    subtract()               Negate()
Absolute()               Sign()                   Multiply()
Divide()                 GCD()                    Block_Store()
Block_Read()             Word_Size()              Word_Store()
Word_Read()              Word_List_Store()        Word_List_Read()
Word_Insert()            Word_Delete()            Chunk_Store()
Chunk_Read()             Chunk_List_Store()       Chunk_List_Read()
Index_List_Remove()      Index_List_Store()       Index_List_Read()
Union()                  Intersection()           Difference()
ExclusiveOr()            Complement()             subset()
Norm()                   Min()                    Max()
Multiplication()         Closure()                Transpose()


Important note to C developers:
-------------------------------

Note again that the C library at the core of this module can also be
used stand-alone (i.e., it contains no inter-dependencies whatsoever
with Perl).

The library itself consists of three files: "BitVector.c", "BitVector.h"
and "ToolBox.h".

Just compile "BitVector.c" (which automatically includes "ToolBox.h")
and link the resulting output file "BitVector.o" with your application,
which in turn should include "ToolBox.h" and "BitVector.h" (in this order).


Example applications:
---------------------

See the module "Set::IntRange" for an easy-to-use module for sets
of integers of arbitrary ranges.

See the module "Math::MatrixBool" for an efficient implementation
of boolean matrices and boolean matrix operations.

(Both modules are also available from my web site or any CPAN server.)

An application relying crucially on this "Bit::Vector" module is "Slice",
a tool for generating different document versions out of a single
master file, ruled by boolean expressions ("include english version
of text plus examples but not ...").

(See also http://www.engelschall.com/sw/slice/.)

This tool is itself part of another tool, "Website META Language" ("WML"),
which allows you to generate and maintain large web sites.

Among many other features, it allows you to define your own HTML tags which
will be expanded either at generation or at run time, depending on your
choice.

(See also http://www.engelschall.com/sw/wml/.)

Both tools are written by Ralf S. Engelschall.


Credits:
--------

Please refer to the file "CREDITS.txt" in this distribution for a list
of contributors.


Author's note:
--------------

If you have any questions, suggestions or need any assistance, please
let me know!

I would in fact be glad to receive any kind of feedback from you!

I hope you will find this module beneficial.

Yours,
--
  Steffen Beyer <sb@engelschall.com> http://www.engelschall.com/u/sb/
       "There is enough for the need of everyone in this world,
         but not for the greed of everyone." - Mahatma Gandhi
