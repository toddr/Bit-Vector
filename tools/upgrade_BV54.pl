#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;
no strict "vars";

$self = $0;
$self =~ s!^.*/!!;

unless (@ARGV)
{
    print "\nUsage: perl $self <filename> [<filename>]*\n\n";
    print "This utility tries to upgrade your Perl application(s) \"<filename>\"\n";
    print "from \"Bit::Vector\" version 4.x to \"Bit::Vector\" version 5.4.\n\n";
    exit(0);
}

FILE:
foreach $file (@ARGV)
{
    unless (-f $file)
    {
        warn "$self: unable to find \"$file\"!\n";
        next FILE;
    }
    unless (rename($file,"$file.bak"))
    {
        warn "$self: unable to rename \"$file\" to \"$file.bak\": $!\n";
        next FILE;
    }
    unless (open(INPUT, "<$file.bak"))
    {
        warn "$self: unable to read \"$file.bak\": $!\n";
        next FILE;
    }
    unless (open(OUTPUT, ">$file"))
    {
        warn "$self: unable to write \"$file\": $!\n";
        close(INPUT);
        next FILE;
    }
    print "$self: upgrading \"$file\"...\n";
    while (<INPUT>)
    {
        s/\buse\s+Bit::Vector\s+4\.\d\b/use Bit::Vector 5.4/g;
        s/\bto_ASCII\b/to_Enum/g;
        s/\bfrom_ASCII\b/from_Enum/g;
        s/\bto_String\b/to_Hex/g;
        s/(\$.+?)\s*->\s*from_string\s*\((.*?)\)/( eval { $1->from_Hex($2); !\$\@; } )/g;
        s/\bfrom_string\b/from_Hex/g;
        s/(\$.+?)\s*->\s*lexorder\s*\((.*?)\)/($1->Lexicompare($2) <= 0)/g;
        s/\blexorder\b/Lexicompare/g;
        s/(\$.+?)\s*=\s*Bit::Vector\s*->\s*new_from_String\s*\((.*?)\)/$1 = Bit::Vector->new_Hex(length($2)<<2,$2)/g;
        s/\bnew_from_String\b/new_Hex/g;
        print OUTPUT;
    }
    close(INPUT);
    close(OUTPUT);
}

__END__

