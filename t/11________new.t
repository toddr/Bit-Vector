#!perl -w

use strict;
no strict "vars";

use Set::IntegerRange;

@ISA = qw(Set::IntegerRange);

# ======================================================================
#   $set = Set::IntegerRange::new('Set::IntegerRange',$lower,$upper);
#   $set->Size();
#   $set->Norm();
#   $set->Min();
#   $set->Max();
# ======================================================================

print "1..116\n";

$n = 1;

# test if the constructor works at all:

$set = Set::IntegerRange::new('Set::IntegerRange',0,0);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == 0) && ($max == 0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set = Set::IntegerRange::new('Set::IntegerRange',-1,1);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 3)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -1) && ($max == 1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set = Set::IntegerRange::new('Set::IntegerRange',-997,499);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 1497)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -997)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 499)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -997) && ($max == 499))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test various ways of calling the constructor:

# 1: $set = Set::IntegerRange::new('Set::IntegerRange',-1,1);
# 2: $class = 'Set::IntegerRange'; $set = Set::IntegerRange::new($class,-2,2);
# 3: $set = new Set::IntegerRange(-3,3);
# 4: $set = Set::IntegerRange->new(-4,4);
# 5: $ref = $set->new(-5,5);
# 6: $set = $set->new(-6,6);

# (test case #1 has been handled above)

# test case #2:

$class = 'Set::IntegerRange';
$set = Set::IntegerRange::new($class,-2,2);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 5)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -2) && ($max == 2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #3:

$ref = new Set::IntegerRange(-3,3);
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$ref->Fill();
if ($ref->Norm() == 7)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Min() == -3)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Max() == 3)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $ref->Size();
if (($min == -3) && ($max == 3))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #4:

$set = Set::IntegerRange->new(-4,4);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 9)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -4) && ($max == 4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #5:

$ref = $set->new(-5,5);
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$ref->Fill();
if ($ref->Norm() == 11)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Min() == -5)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Max() == 5)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $ref->Size();
if (($min == -5) && ($max == 5))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence tests:

if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Norm() == 9)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# prepare exact copy of object reference:

$ref = $set;
if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Norm() == 9)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Min() == -4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Max() == 4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $ref->Size();
if (($min == -4) && ($max == 4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test case #6 (pseudo auto-destruction test):

$set = $set->new(-6,6);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 13)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -6)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 6)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -6) && ($max == 6))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# coherence tests:

if (defined $ref)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($ref) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Norm() == 9)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Min() == -4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($ref->Max() == 4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $ref->Size();
if (($min == -4) && ($max == 4))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# auto-destruction test:

$set = $set->new(-7,7);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 15)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -7)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 7)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -7) && ($max == 7))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test weird ways of calling the constructor:

eval { $set = Set::IntegerRange::new("",-8,8); };
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new('',-9,9); };
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new(undef,-10,10); };
if (ref($set) eq 'Set::IntegerRange')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new(6502,-11,11); };
if (ref($set) eq '6502')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new('main',-12,12); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'main')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 25)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -12)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 12)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -12) && ($max == 12))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new('nonsense',-13,13); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'nonsense')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
Set::IntegerRange::Fill($set);
if (Set::IntegerRange::Norm($set) == 27)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (Set::IntegerRange::Min($set) == -13)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (Set::IntegerRange::Max($set) == 13)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = Set::IntegerRange::Size($set);
if (($min == -13) && ($max == 13))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = new main(-14,14); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'main')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 29)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -14)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 14)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -14) && ($max == 14))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

@parameters = ( 'main', -15, 15 );
eval { $set = Set::IntegerRange::new(@parameters); };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'main')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Fill();
if ($set->Norm() == 31)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Min() == -15)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->Max() == 15)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
($min,$max) = $set->Size();
if (($min == -15) && ($max == 15))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = 0; };
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

# test syntactically incorrect constructor calls:

eval { $set = Set::IntegerRange::new(-16,16); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new('main'); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new($set); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new('main',-17,17,1); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new($set,'main',-18,18); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange::new($set,-19,19,'main'); };
if ($@ =~ /Usage: \$set = Set::IntegerRange->new\(\$lower,\$upper\)/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange->new(20,-20); };
if ($@ =~ /Set::IntegerRange::new\(\): lower > upper boundary/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $set = Set::IntegerRange->new(21,20); };
if ($@ =~ /Set::IntegerRange::new\(\): lower > upper boundary/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

