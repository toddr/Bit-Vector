#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

# ======================================================================
#   $carry_out = $vector->rotate_left();
#   $carry_out = $vector->rotate_right();
#   $carry_out = $vector->shift_left($carry_in);
#   $carry_out = $vector->shift_right($carry_in);
# ======================================================================
#   $vec1 = $vec2->Shadow();
#   $vec1 = $vec2->Clone();
# ======================================================================

print "1..798\n";

$n = 1;

foreach $limit (15,16,31,32,63,64,127,128,255,256,511,512,1023,1024)
{
    $ref = Bit::Vector->new($limit);

    $ref->Fill();
    $ref->Delete(0);
    $ref->Delete(1);
    for ( $j = 4; $j < $limit; $j += 2 ) { $ref->Delete($j); }
    for ( $i = 3; ($j = $i * $i) < $limit; $i += 2 )
    {
        for ( ; $j < $limit; $j += $i ) { $ref->Delete($j); }
    }

    $rol = $ref->Clone();
    $ror = $ref->Clone();
    $shl = $ref->Clone();
    $shr = $ref->Clone();

    $crl = $rol->Shadow();
    $crr = $ror->Shadow();
    $csl = $shl->Shadow();
    $csr = $shr->Shadow();

    &test_rotat_reg_same(0);
    &test_shift_reg_same(0);
    &test_rotat_carry_same(1);
    &test_shift_carry_same(1);

    for ( $i = 0; $i < $limit; $i++ )
    {
        $crl->shift_left ( $rol->rotate_left () );
        $crr->shift_right( $ror->rotate_right() );
        $csl->shift_left ( $shl->shift_left  ( $shl->bit_test($limit-1) ) );
        $csr->shift_right( $shr->shift_right ( $shr->bit_test(0)        ) );

        if (($i == 0) || ($i == ($limit-2)))
        {
            &test_rotat_reg_same(1);
            &test_shift_reg_same(1);
            &test_rotat_carry_same(1);
            &test_shift_carry_same(1);
            &test_rotat_reg_diff;
            &test_rotat_carry_diff if ($i);
            &test_shift_reg_diff;
            &test_shift_carry_diff if ($i);
        }
    }

    &test_rotat_reg_same(0);
    &test_shift_reg_same(0);
    &test_rotat_carry_same(0);
    &test_shift_carry_same(0);
}

foreach $limit (15,16,31,32,63,64,127,128,255,256,511,512,1023,1024)
{
    $ref = Bit::Vector->new($limit);

    $ref->Fill();
    $ref->Delete(0);
    $ref->Delete(1);
    for ( $j = 4; $j < $limit; $j += 2 ) { $ref->Delete($j); }
    for ( $i = 3; ($j = $i * $i) < $limit; $i += 2 )
    {
        for ( ; $j < $limit; $j += $i ) { $ref->Delete($j); }
    }

    $shl = $ref->Clone();
    $shr = $ref->Clone();

    $csl = $shl->Shadow();
    $csr = $shr->Shadow();

    &test_shift_reg_same(0);
    &test_shift_carry_same(1);

    for ( $i = 0; $i < $limit; $i++ )
    {
        $csl <<= ( $shl << $shl->bit_test($limit-1) );
        $csr >>= ( $shr >> $shr->bit_test(0)        );

        if (($i == 0) || ($i == ($limit-2)))
        {
            &test_shift_reg_same(1);
            &test_shift_carry_same(1);
            &test_shift_reg_diff;
            &test_shift_carry_diff if ($i);
        }
    }

    &test_shift_reg_same(0);
    &test_shift_carry_same(0);
}

exit;

sub test_rotat_reg_same
{
    my($flag) = @_;

    if (($ref->equal($rol)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(1)\n";}
    $n++;

    if (($ref->equal($ror)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(2)\n";}
    $n++;
}

sub test_shift_reg_same
{
    my($flag) = @_;

    if (($ref->equal($shl)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(3)\n";}
    $n++;

    if (($ref->equal($shr)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(4)\n";}
    $n++;
}

sub test_rotat_carry_same
{
    my($flag) = @_;

    if (($ref->equal($crl)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(5)\n";}
    $n++;

    if (($ref->equal($crr)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(6)\n";}
    $n++;
}

sub test_shift_carry_same
{
    my($flag) = @_;

    if (($ref->equal($csl)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(7)\n";}
    $n++;

    if (($ref->equal($csr)) ^ $flag)
    {print "ok $n\n";} else {print "not ok $n(8)\n";}
    $n++;
}

sub test_rotat_reg_diff
{
    unless ($rol->equal($ror))
    {print "ok $n\n";} else {print "not ok $n(9)\n";}
    $n++;
}

sub test_rotat_carry_diff
{
    unless ($crl->equal($crr))
    {print "ok $n\n";} else {print "not ok $n(10)\n";}
    $n++;
}

sub test_shift_reg_diff
{
    unless ($shl->equal($shr))
    {print "ok $n\n";} else {print "not ok $n(11)\n";}
    $n++;
}

sub test_shift_carry_diff
{
    unless ($csl->equal($csr))
    {print "ok $n\n";} else {print "not ok $n(12)\n";}
    $n++;
}

__END__

