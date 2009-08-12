#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 2009 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

###############################################################################
##                                                                           ##
##   Shows how to use Data::Dumper to freeze and thaw Bit::Vector objects:   ##
##                                                                           ##
###############################################################################

package Bit::Vector;

use strict;

sub Data_Dumper_Freeze
{
    my $string = "Bit::Vector->new_Hex(" . $_[0]->Size() . ",q{" . $_[0]->to_Hex() . "})";
    return bless(\$string,'Bit::Vector::Dumper');
}

package Bit::Vector::Dumper;

use strict;

sub Data_Dumper_Thaw { return eval ${$_[0]}; }

package UserSpace;

use strict;

use Bit::Vector;
use Data::Dumper;

$Data::Dumper::Freezer = 'Data_Dumper_Freeze';
$Data::Dumper::Toaster = 'Data_Dumper_Thaw';
$Data::Dumper::Purity = 1;
$Data::Dumper::Indent = 3;

my $original = Bit::Vector->new(4096);

$original->Primes();

my $clone;
my $string = Data::Dumper->Dump([$original], ['clone']); # defines $clone as the output variable name

print "\nDumper says: $string\n";

eval $string; # fills $clone
die $@ if $@;

my $imitation = "Bit::Vector->new_Hex(" . $clone->Size() . ",q{" . $clone->to_Hex() . "})";

print "Our results: \$clone = bless( do{\\(my \$o = '$imitation')}, 'Bit::Vector::Dumper' )->Data_Dumper_Thaw();\n\n";

__END__

