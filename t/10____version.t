#!perl -w

use strict;
no strict "vars";

use Set::IntegerRange;

# ======================================================================
#   $Set::IntegerRange::VERSION
# ======================================================================

print "1..1\n";

$n = 1;
if ($Set::IntegerRange::VERSION eq "4.0")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

