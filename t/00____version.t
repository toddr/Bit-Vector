#!perl -w

use strict;
no strict "vars";

use Set::IntegerFast;

# ======================================================================
#   $ver = Set::IntegerFast::Version();
#   $Set::IntegerFast::VERSION
# ======================================================================

print "1..2\n";

$n = 1;
if (Set::IntegerFast::Version() eq "4.0")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($Set::IntegerFast::VERSION eq "4.0")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

