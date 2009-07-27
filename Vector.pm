
###############################################################################
##                                                                           ##
##    Copyright (c) 1995 - 2009 by Steffen Beyer.                            ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Bit::Vector;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION @CONFIG);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '6.6';

bootstrap Bit::Vector $VERSION;

sub STORABLE_freeze
{
    my($self, $cloning) = @_;
    return( Storable::freeze( [ $self->Size(), $self->Block_Read() ] ) );
}

sub STORABLE_thaw
{
    my($self, $cloning, $string) = @_;
    my($size,$buffer) = @{ Storable::thaw($string) };
    $self->Unfake($size); # Undocumented new feature (slightly dangerous!) only for @%$&*# Storable! (Grrr)
    $self->Block_Store($buffer);
}

# Why can't Storable just use a module's constructor and provides one of its own instead?!?!
# This breaks the encapsulation of other modules which have their own constructor for a good reason!

1;

__END__

