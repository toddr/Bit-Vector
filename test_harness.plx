#!perl -w

# test_harness.plx
# Author: A H Sandstro"m
# Date: 7 March 1999

# There are a humongous number of subtests involved with this module.
# Several of the 't' files generate ok/nok output in the order of
# thousands of lines. This script manages the testing.
#
# Notes:
# (1) Test::Harness doesn't work on a Mac. It uses piped open().

use IO::File;

$tfile = $ARGV[0];
print $tfile, ".....";
$tmpfile = IO::File->new_tmpfile or
  die "Can't open temp file for read/write: $!\n";
$tmpfile->autoflush(1);
$oldfh = select($tmpfile);

eval "require \":t:$tfile\"";
die "$@" if $@;

select($oldfh);
seek($tmpfile,0,0);
$exp_n = <$tmpfile>;
$exp_n =~ s/1\.\.(\d+)/$1/;

($n, $ok, $nok) = (0, 0, 0);
while (defined($line = <$tmpfile>)) {
	$nok++ if $line =~ /not ok/;
	$n++;
}
$ok = $n - $nok;

$tmpfile->close;

print "not " if $nok;
print "ok ($ok/$nok) (OK/NOK)\n";
print "$exp_n Tests expected\n" if ($n != $exp_n);
