#!perl -w

use strict;
no strict "vars";

eval
{
    require Storable;
    *freeze = \&Storable::freeze;
    *thaw   = \&Storable::thaw;
    *dclone = \&Storable::dclone;
};

if ($@ or $Storable::VERSION < 2.2)
{
    print "1..0 # skip module Storable 2.20 or newer not found\n";
    exit 0;
}

require Bit::Vector;

# ======================================================================

# Create a set of numbers which will represent vector lengths to be tested:

$limit = 4096;

$set = Bit::Vector->new($limit);

$set->Primes();  # Initialize the set with prime numbers (pseudo-random)

$set->Bit_On(0); # Also test special cases with vectors of 0 and 1 bits length
$set->Bit_On(1);

for ( $i = 4; $i-1 < $limit; $i <<= 1 ) # Also test special cases of multiples of two and +/- 1
{
    $set->Bit_On($i-1) if ($i-1 < $limit);
    $set->Bit_On($i)   if ($i   < $limit);
    $set->Bit_On($i+1) if ($i+1 < $limit);
}

$tests = 20 * $set->Norm() - 12; # Determine number of test cases

print "1..$tests\n";

$n = 1;

$start = 0;
while (($start < $set->Size()) &&
  (($min,$max) = $set->Interval_Scan_inc($start)))
{
    $start = $max + 2;
    for ( $bits = $min; $bits <= $max; $bits++ )
    {
        $vector = Bit::Vector->new($bits);
        $vector->Primes();

        $twin = thaw(freeze($vector));
        if ($twin->Size() == $bits)
        {print "ok $n\n";} else {print "not ok $n\n";} # 01
        $n++;
        if (${$vector} != ${$twin})
        {print "ok $n\n";} else {print "not ok $n\n";} # 02
        $n++;
        if ($vector->equal($twin))
        {print "ok $n\n";} else {print "not ok $n\n";} # 03
        $n++;

        $clone = dclone($vector);
        if ($clone->Size() == $bits)
        {print "ok $n\n";} else {print "not ok $n\n";} # 04
        $n++;
        if (${$vector} != ${$clone})
        {print "ok $n\n";} else {print "not ok $n\n";} # 05
        $n++;
        if ($vector->equal($clone))
        {print "ok $n\n";} else {print "not ok $n\n";} # 06
        $n++;

        if (${$twin} != ${$clone})
        {print "ok $n\n";} else {print "not ok $n\n";} # 07
        $n++;
        if ($twin->equal($clone))
        {print "ok $n\n";} else {print "not ok $n\n";} # 08
        $n++;

        if ($bits > 0)
        {
            $vector->Flip();

            $twin = thaw(freeze($vector));
            if ($twin->Size() == $bits)
            {print "ok $n\n";} else {print "not ok $n\n";} # 09
            $n++;
            if (${$vector} != ${$twin})
            {print "ok $n\n";} else {print "not ok $n\n";} # 10
            $n++;
            if ($vector->equal($twin))
            {print "ok $n\n";} else {print "not ok $n\n";} # 11
            $n++;

            if (${$twin} != ${$clone})
            {print "ok $n\n";} else {print "not ok $n\n";} # 12
            $n++;
            unless ($twin->equal($clone))
            {print "ok $n\n";} else {print "not ok $n\n";} # 13
            $n++;
            $twin->Flip();
            if ($twin->equal($clone))
            {print "ok $n\n";} else {print "not ok $n\n";} # 14
            $n++;

            $clone = dclone($vector);
            if ($clone->Size() == $bits)
            {print "ok $n\n";} else {print "not ok $n\n";} # 15
            $n++;
            if (${$vector} != ${$clone})
            {print "ok $n\n";} else {print "not ok $n\n";} # 16
            $n++;
            if ($vector->equal($clone))
            {print "ok $n\n";} else {print "not ok $n\n";} # 17
            $n++;

            if (${$twin} != ${$clone})
            {print "ok $n\n";} else {print "not ok $n\n";} # 18
            $n++;
            unless ($twin->equal($clone))
            {print "ok $n\n";} else {print "not ok $n\n";} # 19
            $n++;
            $twin->Flip();
            if ($twin->equal($clone))
            {print "ok $n\n";} else {print "not ok $n\n";} # 20
            $n++;
        }
    }
}

__END__

