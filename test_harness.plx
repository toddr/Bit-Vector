#!perl -w

# test_harness.plx
# Author: A H Sandstro"m
# Date: 7 March 1999

# There are a humongous number of subtests involved with this module.
# Several of the t files generate ok/nok output in the order of
# thousands of lines. This script manages the testing.
#
# Notes:
# (1) Test::Harness doesn't work on a Mac. It uses piped open().
# (2) I never could get around the problem of several of the tests defining
# subroutines with the same name, and pulling them all in with 'require'.
# So for now run this script on one 't' test at a time, or use something
# like my MPW loop described in the 'Readme' file.

use File::Basename;

my $tmpdir = $ENV{TMPDIR};

my ($n, $ok, $nok, $exp_total) = (0, 0, 0, 0);

foreach $tfile (@ARGV) {
   print $tfile, ".....";
   my $basename = basename($tfile, ".t");
   my $tmpfile = "$tmpdir:$basename.tmp";
   open(TMP, "> $tmpfile") or die "Can't open temp file for write $!\n";
   local $oldfh = select(TMP);
   
   require "$tfile";
   
   select($oldfh);
   close(TMP);
   open(TMP, "$tmpfile") or die "Can't open temp file for read $!\n";
   my $exp_n = <TMP>;
   $exp_n =~ s/1\.\.(\d+)/$1/;
   $exp_total += $exp_n;
   my ($local_n, $local_ok, $local_nok) = (0, 0, 0);
   while (defined(my $line = <TMP>)) {
      $local_ok++ if $line !~ /not/;
	  $local_nok++ if $line =~ /not/;
	  $local_n++;
   }
   close(TMP);
   
   print "not " if $local_nok;
   print "ok\n";
   print "$exp_total Tests expected\n" if ($local_n != $exp_n);
   
   # update global counts
   $ok += $local_ok;
   $nok += $local_nok;
   $n += $local_n;
}

print "Files = ", scalar(@ARGV), ", Tests = $n, ($ok/$nok) (OK/NOK)\n";
