package List::Compare::Base::Accelerated;
# As of:  May 22, 2003 

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;

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

sub get_intersection {
    return @{ get_intersection_ref(shift) };
}

sub get_intersection_ref {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %intersection = ();
    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }
    return [ sort keys %intersection ];
}

sub get_union {
    return @{ get_union_ref(shift) };
}

sub get_union_ref {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %union = ();
    $union{$_}++ foreach ( (keys %{$hrefL}), (keys %{$hrefR}) );
    return [ sort keys %union ];
}

sub get_shared {
    return @{ get_shared_ref(shift) };
}

sub get_shared_ref {
    my $class = shift;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing only 2 lists, \&$method defaults to \n  \&get_union_ref.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_union_ref($class);
}

sub get_unique {
    return @{ get_unique_ref(shift) };
}

sub get_unique_ref {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %intersection = my %union = ();
    my %Lonly = ();

    foreach (keys %{$hrefL}) {
        $union{$_}++;
        if (exists ${$hrefR}{$_}) {
            $intersection{$_}++;
        } else {
            $Lonly{$_}++;
        }
    }
    return [ sort keys %Lonly ];
}

*get_Lonly = \&get_unique;
*get_Aonly = \&get_unique;
*get_Lonly_ref = \&get_unique_ref;
*get_Aonly_ref = \&get_unique_ref;

sub get_complement {
    return @{ get_complement_ref(shift) };
}

sub get_complement_ref {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %intersection = my %union = ();
    my %Ronly = ();

    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }

    foreach (keys %{$hrefR}) {
        $Ronly{$_}++ unless (exists $intersection{$_});
    }
    return [ sort keys %Ronly ];
}

*get_Ronly = \&get_complement;
*get_Bonly = \&get_complement;
*get_Ronly_ref = \&get_complement_ref;
*get_Bonly_ref = \&get_complement_ref;

sub get_symmetric_difference {
    return @{ get_symmetric_difference_ref(shift) };
}

sub get_symmetric_difference_ref {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %intersection = ();
    my %Lonly = my %Ronly = my %LorRonly = ();

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
    return [ sort keys %LorRonly ];
}

*get_symdiff  = \&get_symmetric_difference;
*get_LorRonly = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;
*get_symdiff_ref  = \&get_symmetric_difference_ref;
*get_LorRonly_ref = \&get_symmetric_difference_ref;
*get_AorBonly_ref = \&get_symmetric_difference_ref;

sub get_nonintersection {
    return @{ get_nonintersection_ref(shift) };
}

sub get_nonintersection_ref {
    my $class = shift;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing only 2 lists, \&$method defaults to \n  \&get_symmetric_difference_ref.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_symmetric_difference_ref($class);
}

sub is_LsubsetR {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my $LsubsetR_status = 1;
    foreach (keys %{$hrefL}) {
        if (! exists ${$hrefR}{$_}) {
            $LsubsetR_status = 0;
            last;
        }
    }
    return $LsubsetR_status;
}

*is_AsubsetB  = \&is_LsubsetR;

sub is_RsubsetL {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my $RsubsetL_status = 1;
    foreach (keys %{$hrefR}) {
        if (! exists ${$hrefL}{$_}) {
            $RsubsetL_status = 0;
            last;
        }
    }
    return $RsubsetL_status;
}

*is_BsubsetA  = \&is_RsubsetL;

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
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

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my $LequivalentR_status = 0;
    $LequivalentR_status = _equiv_engine($hrefL, $hrefR);
}

*is_LeqvlntR = \&is_LequivalentR;

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my $LequivalentR_status = 0;
    $LequivalentR_status = _equiv_engine($hrefL, $hrefR);
    my @equivalent_array = ($LequivalentR_status, $LequivalentR_status);
    my $title = 'Equivalence';
    _chart_engine(\@equivalent_array, $title);
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
    my %intersection = ();
    my %Lonly = my %Ronly = my %LorRonly = ();
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

__END__

=head1 NAME

List::Compare::Base::Accelerated

=head1 VERSION

This document refers to List::Compare::Base::Accelerated as packaged with 
List::Compare version 0.17.  This version was released May 22, 2003.

=head1 DESCRIPTION

List::Compare::Base::Accelerated is a utility package which holds methods 
shared between the Accelerated modes of packages F<List::Compare> and 
F<List::Compare::SeenHash>.  It has no constructor and is not intended to be 
publicly accessible.  The methods currently packaged herein include:

Please see the documentation for F<List::Compare> and 
F<List::Compare::SeenHash> to learn how to use these methods.

    get_intersection()
    get_union()
    get_unique()
    get_complement()
    get_symmetric_difference()
    get_intersection_ref()
    get_union_ref()
    get_unique_ref()
    get_complement_ref()
    get_symmetric_difference_ref()
    is_LsubsetR()
    is_RsubsetL()
    is_LequivalentR()
    print_subset_chart()
    print_equivalence_chart()

=head1 AUTHOR

James E. Keenan (jkeenan@cpan.org).

Creation date:  May 20, 2002.  Last modification date:  May 22, 2003. 
Copyright (c) 2002-3 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 



