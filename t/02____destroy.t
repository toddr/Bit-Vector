#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $set->DESTROY();
# ======================================================================

print "1..15\n";

$n = 1;
$set = 1;
if (ref($set) eq '')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->DESTROY(); };
if ($@ =~ /Can't call method "DESTROY" without a package or object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { Set::IntegerFast::DESTROY($set); };
if ($@ =~ /[^:]+::[^:]+::DESTROY\(\): not a '[^']+' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$obj = 0x00088850;
$set = \$obj;
if (ref($set) eq 'SCALAR')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->DESTROY(); };
if ($@ =~ /Can't call method "DESTROY" on unblessed reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { Set::IntegerFast::DESTROY($set); };
if ($@ =~ /[^:]+::[^:]+::DESTROY\(\): not a '[^']+' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$obj = 0x000E9CE0;
$set = \$obj;
bless($set, 'Set::IntegerFast');
if (ref($set) eq 'Set::IntegerFast')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->DESTROY(); };
if ($@ =~ /[^:]+::[^:]+::DESTROY\(\): not a '[^']+' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { Set::IntegerFast::DESTROY($set); };
if ($@ =~ /[^:]+::[^:]+::DESTROY\(\): not a '[^']+' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set = new Set::IntegerFast(1);
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->DESTROY(); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) =~ /^Set::IntegerFast$|^Bit::Vector$/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined(${$set}) && (${$set} == 0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set->DESTROY(); };
if ($@ =~ /[^:]+::[^:]+::DESTROY\(\): not a '[^']+' object reference/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

