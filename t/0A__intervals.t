#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->Empty_Interval($lower,$upper);
#   $set->Fill_Interval($lower,$upper);
#   $set->Flip_Interval($lower,$upper);
# ======================================================================

print "1..3384\n";

$lim = 32768;

$set = new Set::IntegerFast($lim);

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

if ($set->Norm() == $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == 0)
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

if ($set->Norm() == $lim)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == 0)
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

test_set_clr(1,14);      test_flip(1,14);
test_set_clr(1,30);      test_flip(1,30);
test_set_clr(1,62);      test_flip(1,62);
test_set_clr(1,126);     test_flip(1,126);
test_set_clr(1,254);     test_flip(1,254);
test_set_clr(1,$lim-2);  test_flip(1,$lim-2);

test_set_clr(0,14);      test_flip(0,14);
test_set_clr(0,30);      test_flip(0,30);
test_set_clr(0,62);      test_flip(0,62);
test_set_clr(0,126);     test_flip(0,126);
test_set_clr(0,254);     test_flip(0,254);
test_set_clr(0,$lim-2);  test_flip(0,$lim-2);

test_set_clr(1,15);      test_flip(1,15);
test_set_clr(1,31);      test_flip(1,31);
test_set_clr(1,63);      test_flip(1,63);
test_set_clr(1,127);     test_flip(1,127);
test_set_clr(1,255);     test_flip(1,255);
test_set_clr(1,$lim-1);  test_flip(1,$lim-1);

test_set_clr(0,15);      test_flip(0,15);
test_set_clr(0,31);      test_flip(0,31);
test_set_clr(0,63);      test_flip(0,63);
test_set_clr(0,127);     test_flip(0,127);
test_set_clr(0,255);     test_flip(0,255);
test_set_clr(0,$lim-1);  test_flip(0,$lim-1);

for ( $i = 0; $i < 256; $i++ )
{
    test_set_clr($i,$i); test_flip($i,$i);
}

eval { $set->Empty_Interval(-1,$lim-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Empty_)?Interval(?:_Empty)?\(\): minimum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(-1,$lim-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Fill_)?Interval(?:_Fill)?\(\): minimum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(-1,$lim-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Flip_)?Interval(?:_Flip)?\(\): minimum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Empty_Interval(0,-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Empty_)?Interval(?:_Empty)?\(\): maximum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(0,-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Fill_)?Interval(?:_Fill)?\(\): maximum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(0,-1); };
if ($@ =~ /[^:]+::[^:]+::(?:Flip_)?Interval(?:_Flip)?\(\): maximum index out of range/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Empty_Interval(1,0); };
if ($@ =~ /[^:]+::[^:]+::(?:Empty_)?Interval(?:_Empty)?\(\): minimum > maximum index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Fill_Interval(1,0); };
if ($@ =~ /[^:]+::[^:]+::(?:Fill_)?Interval(?:_Fill)?\(\): minimum > maximum index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set->Flip_Interval(1,0); };
if ($@ =~ /[^:]+::[^:]+::(?:Flip_)?Interval(?:_Flip)?\(\): minimum > maximum index/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

exit;

sub test_set_clr
{
    my($lower,$upper) = @_;
    my($span) = $upper - $lower + 1;

    $set->Fill_Interval($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Empty_Interval($lower,$upper);
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

    $set->Flip_Interval($lower,$upper);
    if ($set->Norm() == $span)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Min() == $lower)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if ($set->Max() == $upper)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;

    $set->Flip_Interval($lower,$upper);
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

