#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

# ======================================================================
#   $set1->Compare($set2);
# ======================================================================

print "1..32\n";

$set0 = new Bit::Vector(65536);
$set1 = new Bit::Vector(65536);
$set2 = new Bit::Vector(65536);
$set3 = new Bit::Vector(65536);

$set1->Bit_On(1);
$set2->Bit_On(2);
$set3->Bit_On(1);
$set3->Bit_On(2);

$n = 1;
if ($set0->Compare($set0) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set1) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set1) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set2) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set2) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set3) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set0->Empty();
$set1->Empty();
$set2->Empty();
$set3->Empty();

$set1->Bit_On(1);
$set2->Bit_On(32768);
$set3->Bit_On(1);
$set3->Bit_On(32768);

if ($set0->Compare($set0) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set1) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set0->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set1) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set2) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set1->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set2) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set2->Compare($set3) == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set0) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set1) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set2) == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set3->Compare($set3) == 0)
{print "ok $n\n";} else {print "not ok $n\n";}

__END__

