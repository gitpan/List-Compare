package List::Compare::Base::_Engine;
$VERSION = 0.22;
# Holds subroutines used within both 
# List::Compare::Base::Accelerated and List::Compare::Functional
# As of November 23, 2003
use Carp;
@ISA = qw(Exporter);
@EXPORT_OK = qw|
    _intersection_engine
    _union_engine
    _unique_engine
    _complement_engine
    _symmetric_difference_engine
    _is_LsubsetR_engine
    _is_RsubsetL_engine
    _is_member_which_engine
    _are_members_which_engine
    _is_member_any_engine
    _are_members_any_engine
    _print_subset_chart_engine
    _is_LequivalentR_engine
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
    _chart_engine(\@subset_array, $title);
}

sub _is_LequivalentR_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    return _equiv_engine($hrefL, $hrefR);
}

sub _print_equivalence_chart_engine {
    my ($l, $r) = @_;
    my ($hrefL, $hrefR) = _calc_seen($l, $r);
    my $LequivalentR_status = _equiv_engine($hrefL, $hrefR);
    my @equivalent_array = ($LequivalentR_status, $LequivalentR_status);
    my $title = 'Equivalence';
    _chart_engine(\@equivalent_array, $title);
}    


######################### INTERNAL SUBROUTINES #########################

sub _calc_seen {
    my ($refL, $refR) = @_;
    if (ref($refL) eq 'HASH' and ref($refR) eq 'HASH') {
        return ($refL, $refR);
    } elsif (ref($refL) eq 'ARRAY' and ref($refR) eq 'ARRAY') {
        my %seenL = my %seenR = ();
        foreach (@$refL) { $seenL{$_}++ }
        foreach (@$refR) { $seenR{$_}++ }
        return (\%seenL, \%seenR); 
    } else {
        croak "Improper mixing of arguments; accelerated calculation not possible:  $!";
    }
}

sub _chart_engine {
    my $aref = shift;
    my @sub_or_eqv = @$aref;
    my $title = shift;
    my ($v, $w, $t);
    print "\n";
    print $title, ' Relationships', "\n\n";
    print '   Right:    0    1', "\n\n";
    print 'Left:  0:    1    ', $sub_or_eqv[0], "\n\n";
    print '       1:    ', $sub_or_eqv[1], '    1', "\n\n";
}

sub _equiv_engine {
    my ($hrefL, $hrefR) = @_;
    my (%intersection, %Lonly, %Ronly, %LorRonly);
    my $LequivalentR_status = 0;
    
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
    $LequivalentR_status = 1 if ( (keys %LorRonly) == 0);
    return $LequivalentR_status;
}

1;

