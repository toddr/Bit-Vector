#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.                 ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;
use vars qw($limit $set $start $stop $min $max $norm $i $j);

use Bit::Vector;

print "\n***** Calculating Prime Numbers - The Sieve Of Erathostenes *****\n";

$limit = $ARGV[0];

$set = Bit::Vector->new($limit+1);

print "Calculating the prime numbers in the range [2..$limit]...\n\n";

$start = time;

$set->Primes();

## Alternative (slower!):

#$set->Fill();
#$set->Bit_Off(0);
#$set->Bit_Off(1);
#for ( $j = 4; $j <= $limit; $j += 2 ) { $set->Bit_Off($j); }
#for ( $i = 3; ($j = $i * $i) <= $limit; $i += 2 )
#{
#    for ( ; $j <= $limit; $j += $i ) { $set->Bit_Off($j); }
#}

$stop = time;

&print_elapsed_time;

$min = $set->Min();
$max = $set->Max();
$norm = $set->Norm();

print "Found $norm prime numbers in the range [2..$limit]:\n\n";

for ( $i = $min, $j = 0; $i <= $max; $i++ )
{
    if ($set->contains($i)) { print "prime number #", ++$j, " = $i\n"; }
}

print "\n";

exit;

sub print_elapsed_time
{
	print "Elapsed time = ", ($stop-$start), " seconds\n";
}

__END__

