# This Makefile is for the Bit::Vector extension to perl.
#
# It was generated automatically by MakeMaker version
# 5.6 (Revision: ) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#	ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker Parameters:

#	DEFINE => q[]
#	INC => q[]
#	LIBS => [q[]]
#	NAME => q[Bit::Vector]
#	OBJECT => q[$(O_FILES)]
#	VERSION_FROM => q[Vector.pm]
#	dist => { COMPRESS=>q[gzip -9], SUFFIX=>q[gz] }

# --- MakeMaker constants section:
NAME = Bit::Vector
DISTNAME = Bit-Vector
NAME_SYM = Bit_Vector
VERSION = 5.6
VERSION_SYM = 5_6
XS_VERSION = 5.6
INST_LIB = :::lib
INST_ARCHLIB = :::lib
PERL_LIB = :::lib
PERL_SRC = :::
PERL = perl
FULLPERL = perl
SOURCE =  BitVector.c Vector.c

MODULES = Vector.pm


.INCLUDE : $(PERL_SRC)BuildRules.mk


# FULLEXT = Pathname for extension directory (eg DBD:Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT.
# ROOTEXT = Directory part of FULLEXT (eg DBD)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
FULLEXT = Bit:Vector
BASEEXT = Vector
ROOTEXT = Bit:
DEFINE = 

# Handy lists of source code files:
XS_FILES= Vector.xs
C_FILES = BitVector.c \
	Vector.c
H_FILES = BitVector.h \
	ToolBox.h


.INCLUDE : $(PERL_SRC)ext:ExtBuildRules.mk


# --- MakeMaker dlsyms section:

dynamic :: Vector.exp


Vector.exp: Makefile.PL
	$(PERL) "-I$(PERL_LIB)" -e 'use ExtUtils::Mksymlists; Mksymlists("NAME" => "Bit::Vector", "DL_FUNCS" => {  }, "DL_VARS" => []);'


# --- MakeMaker dynamic section:

all :: dynamic

install :: do_install_dynamic

install_dynamic :: do_install_dynamic


# --- MakeMaker static section:

all :: static

install :: do_install_static

install_static :: do_install_static


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean ::
	$(RM_RF) Vector.c
	$(MV) Makefile.mk Makefile.mk.old


# --- MakeMaker realclean section:

# Delete temporary files (via clean) and also delete installed files
realclean purge ::  clean
	$(RM_RF) Makefile.mk Makefile.mk.old


# --- MakeMaker postamble section:


# --- MakeMaker rulez section:

install install_static install_dynamic :: 
	$(PERL_SRC)PerlInstall -l $(PERL_LIB)

.INCLUDE : $(PERL_SRC)BulkBuildRules.mk


# End.
