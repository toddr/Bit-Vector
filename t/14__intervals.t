#!perl -w

use strict;
no strict "vars";

use Set::IntegerRange;

# ======================================================================
#   $set->Interval_Empty($lower,$upper);
#   $set->Interval_Fill($lower,$upper);
#   $set->Interval_Flip($lower,$upper);
# ======================================================================

print "1..456\n";

$lim = 16384;

$set = new Set::IntegerRange(-$lim,$lim-1);

$n = 1;
if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Fill();

if ($set->Norm() == $lim * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == $lim-1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Empty();

if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Complement($set);

if ($set->Norm() == $lim * 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == $lim-1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set->Complement($set);

if ($set->Norm() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() > $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() < -$lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

for ( $i = 0; $i < 32; $i++ )
{
    test_set_clr(-$i,$i);      test_flip(-$i,$i);
}

test_set_clr(-63,63);          test_flip(-63,63);
test_set_clr(-127,127);        test_flip(-127,127);
test_set_clr(-255,255);        test_flip(-255,255);

test_set_clr(-$lim,$lim-1);    test_flip(-$lim,$lim-1);

eval { $set->Interval_Empty(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Interval_Empty\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n(16,$@)\n";}
$n++;

eval { $set->Interval_Fill(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Interval_Fill\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Flip(-$lim-1,$lim-1); };
if ($@ =~ /Set::IntegerRange::Interval_Flip\(\): lower index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Empty(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Interval_Empty\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Fill(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Interval_Fill\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Flip(-$lim,$lim); };
if ($@ =~ /Set::IntegerRange::Interval_Flip\(\): upper index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Empty(1,-1); };
if ($@ =~ /Set::IntegerRange::Interval_Empty\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Fill(1,-1); };
if ($@ =~ /Set::IntegerRange::Interval_Fill\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Interval_Flip(1,-1); };
if ($@ =~ /Set::IntegerRange::Interval_Flip\(\): lower > upper index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

exit;

sub test_set_clr
{
    my($lower,$upper) = @_;
    my($span) = $upper - $lower + 1;

    $set->Interval_Fill($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Interval_Empty($lower,$upper);
    if ($set->Norm() == 0)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() > $lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() < -$lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

sub test_flip
{
    my($lower,$upper) = @_;
    my($span) = $upper - $lower + 1;

    $set->Interval_Flip($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Interval_Flip($lower,$upper);
    if ($set->Norm() == 0)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() > $lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() < -$lim)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

__END__

