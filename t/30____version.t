#!perl -w

use strict;
no strict "vars";

use Math::MatrixReal;

# ======================================================================
#   $Math::MatrixReal::VERSION
# ======================================================================

print "1..1\n";

$n = 1;
if ($Math::MatrixReal::VERSION eq "1.2")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

