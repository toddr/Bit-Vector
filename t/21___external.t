#!perl -w

use strict;
no strict "vars";

use Math::MatrixBool;

# ======================================================================
#   $product = $matrix1->Multiplication($matrix2);
#   $kleene = $matrix->Kleene();
# ======================================================================

print "1..12\n";

$n = 1;

$a = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 0 1 1 1 ]
[ 1 0 1 1 ]
[ 0 1 0 1 ]
[ 1 0 0 1 ]
MATRIX

if (ref($a) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$b = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 0 0 0 1 ]
[ 0 0 1 0 ]
[ 0 1 0 0 ]
[ 1 0 0 0 ]
MATRIX

if (ref($b) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$d = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 1 1 1 0 ]
[ 1 1 0 1 ]
[ 1 0 1 0 ]
[ 1 0 0 1 ]
MATRIX

if (ref($d) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$e = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 1 0 0 1 ]
[ 0 1 0 1 ]
[ 1 0 1 1 ]
[ 0 1 1 1 ]
MATRIX

if (ref($e) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$c = $a->Multiplication($b);

if ($c->equal($d))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$c = $b * $a;

if ($c->equal($e))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$matrix = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 0 1 0 0 0 0 0 0 ]
[ 0 0 1 0 0 0 0 0 ]
[ 0 0 0 0 0 1 0 0 ]
[ 1 0 0 0 0 0 0 0 ]
[ 0 0 0 0 0 0 0 1 ]
[ 0 0 0 1 0 0 0 0 ]
[ 0 0 0 0 0 1 0 0 ]
[ 0 0 0 0 0 0 1 0 ]
MATRIX

if (ref($matrix) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$test = Math::MatrixBool->new_from_string(<<"MATRIX");
[ 1 1 1 1 0 1 0 0 ]
[ 1 1 1 1 0 1 0 0 ]
[ 1 1 1 1 0 1 0 0 ]
[ 1 1 1 1 0 1 0 0 ]
[ 1 1 1 1 1 1 1 1 ]
[ 1 1 1 1 0 1 0 0 ]
[ 1 1 1 1 0 1 1 0 ]
[ 1 1 1 1 0 1 1 1 ]
MATRIX

if (ref($test) eq 'Math::MatrixBool')
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$kleene = $matrix->Kleene();

if ($kleene->equal($test))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$prod = $matrix->Shadow();
$sum = $matrix->Shadow();

$prod->One();
$sum->One();

for ( $i = 0; $i < 8; $i++ )
{
    $prod = $prod->Multiplication($matrix);
    $sum->Union($sum,$prod);
}

if ($sum->equal($test))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$matrix->Bit_On(3,5);

$test = $matrix->Shadow();
$test->Fill();

$kleene = $matrix->Kleene();

if ($kleene->equal($test))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

$prod = $matrix->Shadow();
$sum = $matrix->Shadow();

$prod->One();
$sum->One();

for ( $i = 0; $i < 8; $i++ )
{
    $prod *= $matrix;
    $sum |= $prod;
}

if ($sum->equal($test))
{ print "ok $n\n"; } else { print "not ok $n\n"; }
$n++;

__END__

