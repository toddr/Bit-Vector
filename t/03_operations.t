#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Fill();
#   $set->Empty();
#   $set1->equal($set2);
#   $set1->inclusion($set2);
#   $set1->Union($set2,$set3);
#   $set1->Intersection($set2,$set3);
#   $set1->Difference($set2,$set3);
#   $set1->ExclusiveOr($set2,$set3);
#   $set1->Complement($set2);
#   $set1->Copy($set2);
# ======================================================================

print "1..232\n";

$n = 1;

$limit = 999; # must be odd!

$set0 = new Set::IntegerFast($limit+1);
$set1 = new Set::IntegerFast($limit+1);
$set2 = new Set::IntegerFast($limit+1);
$set3 = new Set::IntegerFast($limit+1);
$set4 = new Set::IntegerFast($limit+1);

$set3->Fill();

for ( $i = 0; $i < $limit; $i+=2 )
{
    $set1->Insert($i);
    $set2->Insert($i+1);
}

&test;

$set1->Fill();
$set2->Empty();

$set1->Delete(0);
$set1->Delete(1);
$set2->Insert(0);
$set2->Insert(1);

for ( $j = 4; $j <= $limit; $j += 2 )
{
    $set1->Delete($j);
    $set2->Insert($j);
}

for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
{
    for ( ; $j <= $limit; $j += $i )
    {
        $set1->Delete($j);
        $set2->Insert($j);
    }
}

&test;

exit;

sub test
{
    # equal

    if ($set0->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set0->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set0->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set0->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set1->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set1->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set1->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set1->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set2->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set2->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set2->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set2->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set3->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # inclusion

    if ($set0->inclusion($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set0->inclusion($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set0->inclusion($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set0->inclusion($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set1->inclusion($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set1->inclusion($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set1->inclusion($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set1->inclusion($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set2->inclusion($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set2->inclusion($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set2->inclusion($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set2->inclusion($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->inclusion($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->inclusion($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (! $set3->inclusion($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set3->inclusion($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # Union

    $set4->Union($set0,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set0,$set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set0,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set0,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set1,$set0);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set1,$set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set1,$set2);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set1,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set2,$set0);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set2,$set1);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set2,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set2,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set3,$set0);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set3,$set1);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set3,$set2);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Union($set3,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # Intersection

    $set4->Intersection($set0,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set0,$set1);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set0,$set2);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set0,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set1,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set1,$set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set1,$set2);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set1,$set3);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set2,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set2,$set1);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set2,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set2,$set3);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set3,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set3,$set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set3,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Intersection($set3,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # Difference

    $set4->Difference($set0,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set0,$set1);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set0,$set2);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set0,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set1,$set0);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set1,$set1);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set1,$set2);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set1,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set2,$set0);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set2,$set1);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set2,$set2);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set2,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set3,$set0);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set3,$set1);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set3,$set2);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Difference($set3,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # ExclusiveOr

    $set4->ExclusiveOr($set0,$set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set0,$set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set0,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set0,$set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set1,$set0);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set1,$set1);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set1,$set2);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set1,$set3);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set2,$set0);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set2,$set1);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set2,$set2);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set2,$set3);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set3,$set0);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set3,$set1);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set3,$set2);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->ExclusiveOr($set3,$set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # Complement

    $set4->Complement($set0);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Complement($set1);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Complement($set2);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Complement($set3);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # Copy

    $set4->Copy($set0);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set1);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set3);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    # in-place:

    $set4->Copy($set1);
    $set4->Union($set2,$set4);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set2);
    $set4->Union($set4,$set1);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set4->Copy($set3);
    $set4->Intersection($set1,$set4);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set3);
    $set4->Intersection($set4,$set2);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set4->Copy($set3);
    $set4->Difference($set4,$set2);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set3);
    $set4->Difference($set2,$set4);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set4->Copy($set1);
    $set4->ExclusiveOr($set4,$set3);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set2);
    $set4->ExclusiveOr($set1,$set4);
    if ($set4->equal($set3))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set4->Copy($set1);
    $set4->Complement($set4);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set3);
    $set4->Complement($set4);
    if ($set4->equal($set0))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set4->Copy($set1);
    $set4->Copy($set4);
    if ($set4->equal($set1))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    $set4->Copy($set2);
    $set4->Copy($set4);
    if ($set4->equal($set2))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

__END__

