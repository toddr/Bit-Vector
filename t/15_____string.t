#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

use Set::IntegerRange;

# ======================================================================
#   $set->from_String($string);
#   $set->to_String();
#   $set->from_ASCII($string);
#   $set->to_ASCII();
# ======================================================================

print "1..13\n";

$n = 1;

$lower = -500;
$upper =  500;

$limit = $upper - $lower;

$set1 = Bit::Vector->new($limit+1);

$set1->Fill();
$set1->Delete(0);
$set1->Delete(1);
for ( $j = 4; $j <= $limit; $j += 2 ) { $set1->Delete($j); }
for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
{
    for ( ; $j <= $limit; $j += $i ) { $set1->Delete($j); }
}

$set1->Interval_Empty(0,768);
$set1->Interval_Fill(1,2);
$set1->Interval_Fill(4,8);
$set1->Interval_Fill(16,32);
$set1->Interval_Fill(64,128);
$set1->Interval_Fill(256,512);

$str1 = $set1->to_String();

$set2 = Set::IntegerRange->new($lower,$upper);

eval { $set2->from_String($str1); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $set2->to_String();
if ($str1 eq $str2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str3 = $set2->to_ASCII();

$str4 = "-499,-498,-496..-492,-484..-468,-436..-372,-244..12,269,273,287,297,309,311,321,323,327,329,339,353,357,359,363,377,381,383,387,407,411,419,429,437,441,447,453,467,471,477,483,491,497";

if ($str3 eq $str4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set3 = $set2->Shadow();

eval { $set3->from_ASCII($str3); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set2->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str4 = "297,387,329,453,287,327,477,273,309,429,383,441,471,323,497,467,321,437,377,339,447,419,311,359,269,411,363,353,357,-484..-468,-436..-372,-499,491,-244..12,381,407,-496..-492,483,-498";

eval { $set3->from_ASCII($str4); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($set2->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set3->from_ASCII("${lower}..${upper}"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set2->Fill();
if ($set2->equal($set3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str4 = ($lower+1) . '..' . ($upper-1);
eval { $set3->from_ASCII($str4); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str4 = ($lower-1) . '..' . ($upper-1);
eval { $set3->from_ASCII($str4); };
if ($@ =~ /^Set::IntegerRange::from_ASCII\(\): minimum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n$@";}
$n++;

$str4 = ($lower+1) . '..' . ($upper+1);
eval { $set3->from_ASCII($str4); };
if ($@ =~ /^Set::IntegerRange::from_ASCII\(\): maximum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n$@";}
$n++;

eval { $set3->from_ASCII("${upper}..${lower}"); };
if ($@ =~ /^Set::IntegerRange::from_ASCII\(\): minimum > maximum index/)
{print "ok $n\n";} else {print "not ok $n\n$@";}
$n++;

__END__

