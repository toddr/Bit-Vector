#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

# ======================================================================
#   $ver = Bit::Vector::Version();
#   $Bit::Vector::VERSION
# ======================================================================

print "1..2\n";

$n = 1;
if (Bit::Vector::Version() eq "4.0")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($Bit::Vector::VERSION eq "4.0")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

