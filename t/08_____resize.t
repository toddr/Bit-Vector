#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Resize($elements);
# ======================================================================

print "1..57\n";

$n = 1;

$set = Set::IntegerFast->new(1);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { ${$set} = 0; };
if ($@ =~ /Modification of a read-only value attempted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Resize(0); };
if ($@ =~ /zero length '[^']+' object not permitted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { ${$set} = 1; };
if ($@ =~ /Modification of a read-only value attempted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set = Set::IntegerFast->new(8);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$old = ${$set};
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Resize(65536);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$old = ${$set};
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == 65536)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Resize(4090);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == 4090)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Resize(4096);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == 4096)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Resize(&binomial(49,6));
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$old = ${$set};
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == &binomial(49,6))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$limit = 65536;
$count = 24;

$set->Resize($limit);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} == $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == $limit)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$inv = Set::IntegerFast->new($limit);

$inv->Fill();

$set->Insert(0);
$inv->Delete(0);

@fib = ( 0, 1 );

while (1)
{
    $index  = ( $fib[0] + $fib[1] );
    $fib[0] = $fib[1];
    $fib[1] = $index;
    last if $index >= $limit;
    $set->Insert($index);
    $inv->Delete($index);
}

if ($set->Norm() == $count)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($limit - $inv->Norm() == $count)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Resize($limit * 2);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != $old)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Size() == $limit * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set->Norm() == $count)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$inv->Resize($limit * 2);
if (defined $inv)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($inv) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$inv} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($inv->Size() == $limit * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($limit - $inv->Norm() == $count)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$inv->Complement($inv);

if ($inv->Norm() == $limit + $count)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set->inclusion($inv))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->ExclusiveOr($inv,$set);

if ($set->Norm() == $limit)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set->Min() == $limit)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set->Max() == (($limit * 2) - 1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

exit;

sub binomial
{
    my($n,$k) = @_;
    my($prod) = 1;
    my($j) = 0;

    if (($n <= 0) || ($k <= 0) || ($n <= $k)) { return(1); }
    if ($k > $n - $k) { $k = $n - $k; }
    while ($j < $k)
    {
        $prod *= $n--;
        $prod /= ++$j;
    }
    return(int($prod + 0.5));
}

__END__

