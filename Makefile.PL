
###############################################################################
##                                                                           ##
##    Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.                 ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'              => 'Bit::Vector',
    'VERSION_FROM'      => 'Vector.pm',
    'OBJECT'            => '$(O_FILES)',
    'LIBS'              => [''],   # e.g., '-lm'
    'DEFINE'            => '',     # e.g., '-DHAVE_SOMETHING'
    'INC'               => '',     # e.g., '-I/usr/include/other'
    'dist'              => { COMPRESS => "gzip -9", SUFFIX => "gz" }
);

