#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

$Bit::Vector::CONFIG[2] = 3;

# ======================================================================
#   $vector->to_Hex();
#   $vector->from_hex();
#   $vector->to_Enum();
#   $vector->from_enum();
# ======================================================================

print "1..62\n";

$limit = 100;

$vec1 = Bit::Vector->new($limit+1);
$vec2 = Bit::Vector->new($limit+1);

$n = 1;

if ($vec1->from_hex("FEDCBA9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex("fedcba9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_Hex();
if ($str2 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->from_hex("deadbeef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*DEADBEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

unless ($vec1->from_hex("dead beef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex("beef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*BEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_Enum();
if ($str2 eq "0-3,5-7,9-13,15")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1->Fill();
$vec1->Bit_Off(0);
$vec1->Bit_Off(1);

for ( $j = 4; $j <= $limit; $j += 2 ) { $vec1->Bit_Off($j); }

for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
{
    for ( ; $j <= $limit; $j += $i ) { $vec1->Bit_Off($j); }
}

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*20208828828208A20A08A28AC$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_Enum();
if ($str2 eq
"2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex("20208828828208A20A08A28AC"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Flip();
$str1 =
"2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97";
if ($vec2->from_enum($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = "43,4,19,2,12,67,31,11,3,23,29,6-9,79-97,14-16,47,53-59,71,37-41,61";
if ($vec2->from_enum($str2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec2->to_Enum();
$str2 = "2-4,6-9,11,12,14-16,19,23,29,31,37-41,43,47,53-59,61,67,71,79-97";
if ($str1 eq $str2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec2->to_Hex();
if ($str1 =~ /^0*3FFFF80882FE08BE0A089DBDC$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex("0000000000000000"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex("0"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec2->Norm() == $limit+1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex(""))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1 = Bit::Vector->new(64);
if ($vec1->from_hex("FEDCBA9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = Bit::Vector->new(64);
if ($vec2->from_hex("fedcba9876543210"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_Hex();
if ($str2 =~ /^0*FEDCBA9876543210$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1 = Bit::Vector->new(32);
if ($vec1->from_hex("DEADbeef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = $vec1->to_Hex();
if ($str1 =~ /^0*DEADBEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = Bit::Vector->new(36);
if (!$vec2->from_hex("DEAD beef"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_Hex();
if ($str2 =~ /^0*00000BEEF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1 = Bit::Vector->new(64);
if ($vec1->from_hex("0000000000000000"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->Size() == 64)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = Bit::Vector->new(64);
if (!$vec2->from_hex("00000g0000000000"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec2->from_hex(""))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec1 = Bit::Vector->new($limit+1);

$str1 = 3.1415926 * 2.0E+7;
if ($vec1->from_hex($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_Hex();
if ($str2 =~ /^0*62831852$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = Bit::Vector->new($limit+1);
if ($vec2->from_hex($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec2->to_Hex();
if ($str2 =~ /^0*62831852$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = 3.1415926 * 2.0;
unless ($vec1->from_hex($str2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec2->from_hex($str2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str1 = "ERRORFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
#             _123456789ABCDEF_123456789ABCDEF_123456789ABCDEF_123456789ABCDEF
if ($vec1->from_hex($str1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$str2 = $vec1->to_Hex();
if ($str2 =~ /^0*1FFFFFFFFFFFFFFFFFFFFFFFFF$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2 = $vec1->Shadow();

if ($vec1->from_enum("0-$limit"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Fill();
if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("0..$limit"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($vec1->from_enum("0,$limit"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$vec2->Empty();
$vec2->Bit_On(0);
$vec2->Bit_On($limit);
if ($vec1->equal($vec2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("0,$limit,"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("0,\$limit"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("101-102"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("100-102"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("100-99"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("100,101"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (!$vec1->from_enum("101,100"))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

