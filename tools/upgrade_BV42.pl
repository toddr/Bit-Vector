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
    print "from \"Set::IntegerFast\" version 3.x to \"Bit::Vector\" version 4.2.\n\n";
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
        s!\bSet::IntegerFast\b!Bit::Vector!g;
        s!\buse\s+Bit::Vector\s+3\.\d\b!use Bit::Vector 4.2!g;
        s!=\s*new\s+Bit::Vector\s*\(!= Bit::Vector->new(!g;
        s!=\s*new\s+Bit::Vector\s+(.*?)\s*;!= Bit::Vector->new($1);!g;
        s!\bEmpty_Interval\b!Interval_Empty!g;
        s!\bFill_Interval\b!Interval_Fill!g;
        s!\bFlip_Interval\b!Interval_Flip!g;
        s!\bDelete\b!Bit_Off!g;
        s!\bInsert\b!Bit_On!g;
        s!\bflip\b!bit_flip!g;
        s!->\s*in\b!->contains!g;
        s!\binclusion\b!subset!g;
        print OUTPUT;
    }
    close(INPUT);
    close(OUTPUT);
}

__END__

