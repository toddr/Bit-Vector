use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Bit::Vector',
    'VERSION_FROM'	=> 'Vector.pm',
    'OBJECT'		=> '$(O_FILES)',
    'LIBS'		=> [''],   # e.g., '-lm'
    'DEFINE'		=> '',     # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '',     # e.g., '-I/opt/pkg/perl5.003/dist'
    'dist'		=> { COMPRESS=>"gzip -9", SUFFIX=>"gz" }
);
