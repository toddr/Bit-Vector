#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

# ======================================================================
#   $vector->from_string();
#   $vector->to_String();
#   $vector->to_ASCII();
#   $vector->from_ASCII();
#   $vector = Bit::Vector->new_from_String();
# ======================================================================

print "1..62\n";

$limit = 100;

$vec1 = Bit::Vector->new($limit+1);
$vec2 = Bit::Vector->new($limit+1);

$n = 1;

if ($vec1->from_string("FEDCBA9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_String();
if ($str1 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string("fedcba9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_String();
if ($str2 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->from_string("deadbeef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_String();
if ($str1 =~ /^0*DEADBEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

unless ($vec1->from_string("dead beef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string("beef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_String();
if ($str1 =~ /^0*BEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_ASCII();
if ($str2 eq "0-3,5-7,9-13,15")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1->Fill();
$vec1->Delete(0);
$vec1->Delete(1);

for ( $j = 4; $j <= $limit; $j += 2 ) { $vec1->Delete($j); }

for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
{
    for ( ; $j <= $limit; $j += $i ) { $vec1->Delete($j); }
}

$str1 = $vec1->to_String();
if ($str1 =~ /^0*20208828828208A20A08A28AC$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_ASCII();
if ($str2 eq
"2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string("20208828828208A20A08A28AC"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Flip();
$str1 =
"2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97";
eval { $vec2->from_ASCII($str1); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = "43,4,19,2,12,67,31,11,3,23,29,6-9,79-97,14-16,47,53-59,71,37-41,61";
eval { $vec2->from_ASCII($str2); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec2->to_ASCII();
$str2 = "2-4,6-9,11,12,14-16,19,23,29,31,37-41,43,47,53-59,61,67,71,79-97";
if ($str1 eq $str2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec2->to_String();
if ($str1 =~ /^0*3FFFF80882FE08BE0A089DBDC$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string("0000000000000000"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string("0"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_string(""))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1 = Bit::Vector->new_from_String("FEDCBA9876543210"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_String();
if ($str1 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String("fedcba9876543210"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_String();
if ($str2 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1 = Bit::Vector->new_from_String("DEADbeef"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_String();
if ($str1 =~ /^0*DEADBEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String("DEAD beef"); };
if ($@ =~ /Bit::Vector::new_from_String\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_String();
if ($str2 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1 = Bit::Vector->new_from_String("0000000000000000"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->Size() == 64)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String("00000g0000000000"); };
if ($@ =~ /Bit::Vector::new_from_String\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String(""); };
if ($@ =~
/Bit::Vector::new_from_String\(\): zero length 'Bit::Vector' object not permitted/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1 = Bit::Vector->new($limit+1);

$str1 = 3.1415926 * 2.0E+7;
if ($vec1->from_string($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_String();
if ($str2 =~ /^0*62831852$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String($str1); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_String();
if ($str2 =~ /^0*62831852$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = 3.1415926 * 2.0;
unless ($vec1->from_string($str2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec2 = Bit::Vector->new_from_String($str2); };
if ($@ =~ /Bit::Vector::new_from_String\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = "ERRORFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
#             _123456789ABCDEF_123456789ABCDEF_123456789ABCDEF_123456789ABCDEF
if ($vec1->from_string($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_String();
if ($str2 =~ /^0*1FFFFFFFFFFFFFFFFFFFFFFFFF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = $vec1->Shadow();

eval { $vec1->from_ASCII("0-$limit"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("0..$limit"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("0,$limit"); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Empty();
$vec2->Bit_On(0);
$vec2->Bit_On($limit);
if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("0,$limit,"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("0,\$limit"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): syntax error in input string/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("101-102"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): minimum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("100-102"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): maximum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("100-99"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): minimum > maximum index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("100,101"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $vec1->from_ASCII("101,100"); };
if ($@ =~ /Bit::Vector::from_ASCII\(\): index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

