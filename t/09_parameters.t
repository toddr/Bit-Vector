#!perl -w

use strict;
no strict "vars";

use Bit::Vector;

# ======================================================================
#   parameter checks
# ======================================================================

$prefix = 'Bit::Vector';

$bad_idx = "^[^:]+::[^:]+::[^:]+\\(\\): (?:minimum |maximum |start |)index out of range";

$bad_size = "^[^:]+::[^:]+::[^:]+\\(\\): (?:bit vector|set|matrix) size mismatch";

$bad_type = "^[^:]+::[^:]+::[^:]+\\(\\): item is not a '[^']+' object";

$numeric  = 1 << 3;
$special  = 1 << 4;

$limit = $numeric;

$method_list{'Size'}              = 1;
$method_list{'Resize'}            = 2 + $numeric;
$method_list{'Empty'}             = 1;
$method_list{'Fill'}              = 1;
$method_list{'Flip'}              = 1;
$method_list{'Interval_Empty'}    = 3 + $numeric + $special;
$method_list{'Interval_Fill'}     = 3 + $numeric + $special;
$method_list{'Interval_Flip'}     = 3 + $numeric + $special;
$method_list{'Interval_Scan_inc'} = 2 + $numeric + $special;
$method_list{'Interval_Scan_dec'} = 2 + $numeric + $special;
$method_list{'Empty_Interval'}    = 3 + $numeric + $special;
$method_list{'Fill_Interval'}     = 3 + $numeric + $special;
$method_list{'Flip_Interval'}     = 3 + $numeric + $special;
$method_list{'Bit_Off'}           = 2 + $numeric + $special;
$method_list{'Bit_On'}            = 2 + $numeric + $special;
$method_list{'bit_flip'}          = 2 + $numeric + $special;
$method_list{'flip'}              = 2 + $numeric + $special;
$method_list{'bit_test'}          = 2 + $numeric + $special;
$method_list{'contains'}          = 2 + $numeric + $special;
$method_list{'in'}                = 2 + $numeric + $special;
$method_list{'increment'}         = 1;
$method_list{'decrement'}         = 1;
$method_list{'Norm'}              = 1;
$method_list{'Min'}               = 1;
$method_list{'Max'}               = 1;
$method_list{'Union'}             = 3;
$method_list{'Intersection'}      = 3;
$method_list{'Difference'}        = 3;
$method_list{'ExclusiveOr'}       = 3;
$method_list{'Complement'}        = 2;
$method_list{'is_empty'}          = 1;
$method_list{'is_full'}           = 1;
$method_list{'equal'}             = 2;
$method_list{'subset'}            = 2;
$method_list{'inclusion'}         = 2;
$method_list{'Compare'}           = 2;
$method_list{'Copy'}              = 2;
$method_list{'rotate_left'}       = 1;
$method_list{'rotate_right'}      = 1;
$method_list{'shift_left'}        = 2 + $numeric;
$method_list{'shift_right'}       = 2 + $numeric;
$method_list{'Move_Left'}         = 2 + $numeric;
$method_list{'Move_Right'}        = 2 + $numeric;
$method_list{'to_Hex'}            = 1;
$method_list{'from_hex'}          = 2 + $numeric;

print "1..1144\n";

$n = 1;

$set = Bit::Vector->new($limit);
if (defined $set)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set) eq 'Bit::Vector')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set1 = Bit::Vector->new($limit-1);
if (defined $set1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set1) eq 'Bit::Vector')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set1} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set2 = Bit::Vector->new($limit-2);
if (defined $set2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set2) eq 'Bit::Vector')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set2} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$set3 = Bit::Vector->new($limit-3);
if (defined $set3)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (ref($set3) eq 'Bit::Vector')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (${$set3} != 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (! $set->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_On(0);
if ($set->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_Off(0);
if (! $set->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->flip(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->flip(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->in(0))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (! $set->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_On(1);
if ($set->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_Off(1);
if (! $set->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->flip(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->flip(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->in(1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (! $set->in($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_On($limit-2);
if ($set->in($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_Off($limit-2);
if (! $set->in($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->flip($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->in($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->flip($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->in($limit-2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (! $set->in($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_On($limit-1);
if ($set->in($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
$set->Bit_Off($limit-1);
if (! $set->in($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->flip($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($set->in($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->flip($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (! $set->in($limit-1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

foreach $method (keys %method_list)
{
    $parms = $method_list{$method};
    next unless (($parms & $numeric) && ($parms & $special));
    $parms -= $numeric;
    $parms -= $special;
    next unless ($parms > 1);
    for ( $i = 0; $i <= $limit; $i++ )
    {
        undef @parameters;
        for ( $j = 0; $j < $parms - 1; $j++ )
        {
            $parameters[$j] = $i;
        }
        for ( $j = 1; $j <= 3; $j++ )
        {
            $action = "${prefix}::$method(\$set${j},\@parameters)";
            eval "$action";
            if ($i < ($limit - $j))
            {
                unless ($@)
                {print "ok $n\n";} else {print "not ok $n\n";}
                $n++;
            }
            else
            {
                if ($@ =~ /$bad_idx/o)
                {print "ok $n\n";} else {print "not ok $n\n";}
                $n++;
            }
        }
    }
    undef @parameters;
    for ( $j = 0; $j < $parms - 1; $j++ )
    {
        $parameters[$j] = -1;
    }
    $action = "\$set->$method(\@parameters)";
    eval "$action";
    if ($@ =~ /$bad_idx/o)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

foreach $method (keys %method_list)
{
    $num_flag = 0;
    $idx_flag = 0;
    $parms = $method_list{$method};
    if ($parms & $numeric) { $parms -= $numeric; $num_flag = 1; }
    if ($parms & $special) { $parms -= $special; $idx_flag = 1; }
    for ( $i = 0; $i <= $parms + 1; $i++ )
    {
        undef @parameters;
        for ( $j = 0; $j < $i - 1; $j++ )
        {
            if ($num_flag) { $parameters[$j] = $limit; }
            else           { $parameters[$j] = $set; }
        }
        if ($i == 0)
        {
            $action = "${prefix}::$method()";
        }
        elsif ($i == 1)
        {
            $action = "${prefix}::$method(\$set)";
        }
        else
        {
            $action = "${prefix}::$method(\$set,\@parameters)";
        }
        eval "$action";
        if ($i != $parms)
        {
            if ($@ =~ /^Usage: (?:[^:]+::[^:]+::)?[^:]+\([\w\$,]*\)/)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
        }
        else
        {
            if ($idx_flag)
            {
                if ($@ =~ /$bad_idx/o)
                {print "ok $n\n";} else {print "not ok $n\n";}
                $n++;
            }
            else
            {
                unless ($@)
                {print "ok $n\n";} else {print "not ok $n\n";}
                $n++;
            }
            if ($parms > 0)
            {
                $fake = undef;
                &test_fake;

                $fake = 0x00088850;
                &test_fake;

                $obj = 0x000E9CE0;
                $fake = \$obj;
                &test_fake;

                bless($fake, 'nonsense');
                &test_fake;

                bless($fake, 'Bit::Vector');
                &test_fake;

                $fake = Bit::Vector->new($limit);
                Bit::Vector::DESTROY($fake);
                &test_fake;
            }
            if ((! $num_flag) && ($parms > 1))
            {
                if ($parms == 2)
                {
                    $action = "${prefix}::$method(\$set1,\$set2)";
                    eval "$action";
                    if ($@ =~ /$bad_size/o)
                    {print "ok $n\n";} else {print "not ok $n\n";}
                    $n++;
                }
                elsif ($parms == 3)
                {
                    $action = "${prefix}::$method(\$set1,\$set1,\$set2)";
                    eval "$action";
                    if ($@ =~ /$bad_size/o)
                    {print "ok $n\n";} else {print "not ok $n\n";}
                    $n++;
                    $action = "${prefix}::$method(\$set1,\$set2,\$set1)";
                    eval "$action";
                    if ($@ =~ /$bad_size/o)
                    {print "ok $n\n";} else {print "not ok $n\n";}
                    $n++;
                    $action = "${prefix}::$method(\$set1,\$set2,\$set2)";
                    eval "$action";
                    if ($@ =~ /$bad_size/o)
                    {print "ok $n\n";} else {print "not ok $n\n";}
                    $n++;
                    $action = "${prefix}::$method(\$set1,\$set2,\$set3)";
                    eval "$action";
                    if ($@ =~ /$bad_size/o)
                    {print "ok $n\n";} else {print "not ok $n\n";}
                    $n++;
                }
                else { }
            }
        }
    }
}

exit;

sub test_fake
{
    if ($num_flag)
    {
        if ($parms == 1)
        {
            $action = "${prefix}::$method(\$fake)";
        }
        else
        {
            $action = "${prefix}::$method(\$fake,\@parameters)";
        }
        eval "$action";
        if ($@ =~ /$bad_type/o)
        {print "ok $n\n";} else {print "not ok $n\n";}
        $n++;
    }
    else
    {
        if ($parms == 1)
        {
            $action = "${prefix}::$method(\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
        }
        elsif ($parms == 2)
        {
            $action = "${prefix}::$method(\$set,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$set)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
        }
        elsif ($parms == 3)
        {
            $action = "${prefix}::$method(\$set,\$set,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$set,\$fake,\$set)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$set,\$fake,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$set,\$set)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$set,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$fake,\$set)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
            $action = "${prefix}::$method(\$fake,\$fake,\$fake)";
            eval "$action";
            if ($@ =~ /$bad_type/o)
            {print "ok $n\n";} else {print "not ok $n\n";}
            $n++;
        }
        else { }
    }
}

__END__

