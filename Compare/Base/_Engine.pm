package List::Compare::Base::_Engine;
$VERSION = 0.3;
# Holds subroutines used within both 
# List::Compare::Base::Accelerated and List::Compare::Functional
# As of 05/21/2004
use Carp;
use List::Compare::Base::_Auxiliary qw(
    _chart_engine_regular
    _calc_seen
    _calc_seen_alt
    _equiv_engine 
);
@ISA = qw(Exporter);
@EXPORT_OK = qw|
    _intersection_engine
    _intersection_alt_engine
    _union_engine
    _unique_engine
    _complement_engine
    _symmetric_difference_engine
    _symmetric_difference_alt_engine 
    _is_LsubsetR_engine
    _is_RsubsetL_engine
    _is_LequivalentR_engine
    _is_LdisjointR_engine 
    _is_member_which_engine
    _are_members_which_engine
    _is_member_any_engine
    _are_members_any_engine
    _print_subset_chart_engine
    _print_equivalence_chart_engine
|;
use strict;

sub _intersection_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my %intersection = ();
    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }
    return [ keys %intersection ];
}

sub _intersection_alt_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen_alt($l, $r);
    my (%count, @intersection);
    @count{keys(%{$hrefL})} = keys(%{$hrefL});
    @intersection = grep { delete $count{$_} } keys(%{$hrefR});
    return \@intersection;
}

sub _union_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my %union = ();
    $union{$_}++ foreach ( (keys %{$hrefL}), (keys %{$hrefR}) );
    return [ keys %union ];
}

sub _unique_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my (%Lonly);
    foreach (keys %{$hrefL}) {
        $Lonly{$_}++ unless exists ${$hrefR}{$_};
    }
    return [ keys %Lonly ];
}

sub _complement_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my (%intersection, %Ronly);
    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }
    foreach (keys %{$hrefR}) {
        $Ronly{$_}++ unless (exists $intersection{$_});
    }
    return [ keys %Ronly ];
}

sub _symmetric_difference_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my (%intersection, %Lonly, %Ronly, %LorRonly);
    foreach (keys %{$hrefL}) {
        if (exists ${$hrefR}{$_}) {
            $intersection{$_}++;
        } else {
            $Lonly{$_}++;
        }
    }
    foreach (keys %{$hrefR}) {
        $Ronly{$_}++ unless (exists $intersection{$_});
    }
    $LorRonly{$_}++ foreach ( (keys %Lonly), (keys %Ronly) );
    return [ keys %LorRonly ];
}

sub _symmetric_difference_alt_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen_alt($l, $r);
    my (%countx, @symmetric_difference);
    $countx{$_}++ foreach (keys %{$hrefL}, keys %{$hrefR});
    @symmetric_difference = grep { $countx{$_} == 1 } keys %countx;
    return \@symmetric_difference;
}

sub _is_LsubsetR_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my $LsubsetR_status = 1;
    foreach (keys %{$hrefL}) {
        if (! exists ${$hrefR}{$_}) {
            $LsubsetR_status = 0;
            last;
        }
    }
    return $LsubsetR_status;
}

sub _is_RsubsetL_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my $RsubsetL_status = 1;
    foreach (keys %{$hrefR}) {
        if (! exists ${$hrefL}{$_}) {
            $RsubsetL_status = 0;
            last;
        }
    }
    return $RsubsetL_status;
}

sub _is_LequivalentR_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    return _equiv_engine($hrefL, $hrefR);
}

sub _is_LdisjointR_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my %intersection = ();
    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }
    keys %intersection == 0 ? 1 : 0;
}

sub _print_subset_chart_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my $LsubsetR_status = my $RsubsetL_status = 1;
    foreach (keys %{$hrefL}) {
        if (! exists ${$hrefR}{$_}) {
            $LsubsetR_status = 0;
            last;
        }
    }
    foreach (keys %{$hrefR}) {
        if (! exists ${$hrefL}{$_}) {
            $RsubsetL_status = 0;
            last;
        }
    }
    my @subset_array = ($LsubsetR_status, $RsubsetL_status);
    my $title = 'Subset';
    _chart_engine_regular(\@subset_array, $title);
}

sub _print_equivalence_chart_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my $LequivalentR_status = _equiv_engine($hrefL, $hrefR);
    my @equivalent_array = ($LequivalentR_status, $LequivalentR_status);
    my $title = 'Equivalence';
    _chart_engine_regular(\@equivalent_array, $title);
}    

sub _is_member_which_engine {
    my ($l, $r, $arg) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my (@found);
    if (exists ${$hrefL}{$arg}) { push @found, 0; }
    if (exists ${$hrefR}{$arg}) { push @found, 1; }
    if ( (! exists ${$hrefL}{$arg}) &&
         (! exists ${$hrefR}{$arg}) )
       { @found = (); }
    return \@found;
}    

sub _are_members_which_engine {
    my ($l, $r, $arg) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my @args = @{$arg};
    my (%found);
    for (my $i=0; $i<=$#args; $i++) {
        if (exists ${$hrefL}{$args[$i]}) { push @{$found{$args[$i]}}, 0; }
        if (exists ${$hrefR}{$args[$i]}) { push @{$found{$args[$i]}}, 1; }
        if ( (! exists ${$hrefL}{$args[$i]}) &&
             (! exists ${$hrefR}{$args[$i]}) )
           { @{$found{$args[$i]}} = (); }
    }
    return \%found;
}

sub _is_member_any_engine {
    my ($l, $r, $arg) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    ( defined ${$hrefL}{$arg} ) ||
    ( defined ${$hrefR}{$arg} ) ? return 1 : return 0;
}

sub _are_members_any_engine {
    my ($l, $r, $arg) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my @args = @{$arg};
    my (%present);
    for (my $i=0; $i<=$#args; $i++) {
        $present{$args[$i]} = ( defined ${$hrefL}{$args[$i]} ) ||
                              ( defined ${$hrefR}{$args[$i]} ) ? 1 : 0;
    }
    return \%present;
}

1;

