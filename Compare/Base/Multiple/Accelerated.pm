package List::Compare::Base::Multiple::Accelerated;
$VERSION = 0.27;
# As of:  April 18, 2004
use strict;
use Carp;
use List::Compare::Base::_Auxiliary qw(:calculate);
use List::Compare::Base::_Auxiliary qw(
    _subset_subengine
    _chart_engine_multiple
    _equivalent_subengine
    _index_message3
    _index_message4
    _prepare_listrefs 
    _subset_engine_multaccel 
);

sub get_union {
    return @{ get_union_ref(shift) };
}

sub get_union_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);

    my $unionref = _calculate_union_only($aref);
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});
    return \@union;
}

sub get_intersection {
    return @{ get_intersection_ref(shift) };
}

sub get_intersection_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);

    # Calculate overall intersection
    # Inputs:  %xintersection
    my $xintersectionref = _calculate_xintersection_only($aref);
    my $intersectionref = _calculate_hash_intersection($xintersectionref);
    my @intersection = 
        $unsortflag ? keys %{$intersectionref} : sort(keys %{$intersectionref});
    return \@intersection;
}

sub get_nonintersection {
    return @{ get_nonintersection_ref(shift) };
}

sub get_nonintersection_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);

    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($aref);
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});
    my $intersectionref = _calculate_hash_intersection($xintersectionref);

    # Calculate nonintersection
    # Inputs:  @union    %intersection
    my (@nonintersection);
    foreach (@union) {
        push(@nonintersection, $_) unless exists ${$intersectionref}{$_};
    }
    return \@nonintersection;
}

sub get_shared {
    return @{ get_shared_ref(shift) };
}

sub get_shared_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);

    # Calculate @shared
    # Inputs:  %xintersection
    my $xintersectionref = _calculate_xintersection_only($aref);
    my $sharedref = _calculate_hash_shared($xintersectionref);
    my @shared = $unsortflag ? keys %{$sharedref} : sort(keys %{$sharedref});
    return \@shared;
}

sub get_symmetric_difference {
    return @{ get_symmetric_difference_ref(shift) };
}

sub get_symmetric_difference_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);

    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($aref);
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});

    my $sharedref = _calculate_hash_shared($xintersectionref);
    my (@symmetric_difference);
    foreach (@union) {
        push(@symmetric_difference, $_) unless exists ${$sharedref}{$_};
    }
    return \@symmetric_difference;
}

sub get_LorRonly {
    my $class = shift;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_symmetric_difference()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_symmetric_difference($class);
}    

sub get_LorRonly_ref {
    my $class = shift;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_symmetric_difference_ref()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_symmetric_difference_ref($class);
}    

*get_AorBonly = \&get_LorRonly;
*get_AorBonly_ref = \&get_LorRonly_ref;

sub get_unique {
    my $class = shift;
    my %data = %$class;
    my $index = defined $_[0] ? shift : 0;
    return @{ get_unique_ref($class, $index) };
}

sub get_unique_ref {
    my $class = shift;
    my %data = %$class;
    my $index = defined $_[0] ? shift : 0;
    my $aref = _prepare_listrefs(\%data);
    _index_message3($index, $#{$aref});

    my ($seenref, $xintersectionref) = 
        _calculate_seen_xintersection_only($aref);
    my %seen = %{$seenref};
    my %xintersection = %{$xintersectionref};

    # Calculate %xunique
    # Inputs:  $aref    %seen    %xintersection
    my (%xunique);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = %{$seen{$i}};
        my (@uniquethis, %deductions, %alldeductions);
        # Get those elements of %xintersection which we'll need 
        # to subtract from %seenthis
        foreach (keys %xintersection) {
            my ($left, $right) = split /_/, $_;
            if ($left == $i || $right == $i) {
                $deductions{$_} = $xintersection{$_};
            }
        }
        foreach my $ded (keys %deductions) {
            foreach (keys %{$deductions{$ded}}) {
                $alldeductions{$_}++;
            }
        }
        foreach (keys %seenthis) {
            push(@uniquethis, $_) unless ($alldeductions{$_});
        }
        $xunique{$i} = \@uniquethis;
    }
    return [ @{$xunique{$index}} ];
}

sub get_Lonly {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_unique()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_unique($class, $index);
}    

sub get_Lonly_ref {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_unique_ref()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_unique_ref($class, $index);
}    

*get_Aonly = \&get_Lonly;
*get_Aonly_ref = \&get_Lonly_ref;

sub get_complement {
    my $class = shift;
    my %data = %$class;
    my $index = defined $_[0] ? shift : 0;
    return @{ get_complement_ref($class, $index) };
}

sub get_complement_ref {
    my $class = shift;
    my %data = %$class;
    my $index = defined $_[0] ? shift : 0;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_listrefs(\%data);
    _index_message3($index, $#{$aref});

    my ($unionref, $seenref) = _calculate_union_seen_only($aref);
    my %seen = %{$seenref};
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});

    # Calculate %xcomplement
    # Inputs:  $aref @union %seen
    my (%xcomplement);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = %{$seen{$i}};
        my @complementthis = ();
        foreach (@union) {
            push(@complementthis, $_) unless (exists $seenthis{$_});
        }
        $xcomplement{$i} = \@complementthis;
    }
    return [ @{$xcomplement{$index}} ];
}

sub get_Ronly {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_complement()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_complement($class, $index);
}    

sub get_Ronly_ref {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  ", 'get_complement_ref()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_complement_ref($class, $index);
}    

*get_Bonly = \&get_Ronly;
*get_Bonly_ref = \&get_Ronly_ref;

sub is_LsubsetR {
    my $class = shift;
    my %data = %$class;
    my $subset_status = _subset_engine_multaccel(\%data, @_);
    return $subset_status;
}

*is_AsubsetB = \&is_LsubsetR;

sub is_RsubsetL {
    my $class = shift;
    my %data = %$class;

    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias is restricted to \n  asking if the list which is the 2nd argument to the constructor \n    is a subset of the list which is the 1st argument.\n      For greater flexibility, please re-code with \&is_LsubsetR: $!";
    @_ = (1,0);

    my $subset_status = _subset_engine_multaccel(\%data, @_);
    return $subset_status;
}

*is_BsubsetA = \&is_RsubsetL;

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
    my $aref = _prepare_listrefs(\%data);
    my ($index_left, $index_right) = _index_message4($#{$aref}, @_);

    my $xequivalentref = _equivalent_subengine($aref);
    return ${$xequivalentref}[$index_left][$index_right];
}

*is_LeqvlntR = \&is_LequivalentR;

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %{$class};
    my $aref = _prepare_listrefs(\%data);
    my $seenref = _calculate_seen_only($aref);
    my ($arg, @found);
    $arg = shift;
    foreach (sort keys %{$seenref}) {
        push @found, $_ if (exists ${$seenref}{$_}{$arg});
    }
    return \@found;
}    

sub are_members_which {
    my $class = shift;
    croak "Method call needs at least one argument:  $!" unless (@_);
    my %data = %{$class};
    my $aref = _prepare_listrefs(\%data);
    my $seenref = _calculate_seen_only($aref);
    my (@args, %found);
    @args = (@_ == 1 and ref($_[0]) eq 'ARRAY') 
        ?  @{$_[0]}
        :  @_;
    for (my $i=0; $i<=$#args; $i++) {
        my (@not_found);
        foreach (sort keys %{$seenref}) {
            exists ${${$seenref}{$_}}{$args[$i]}
                ? push @{$found{$args[$i]}}, $_
                : push @not_found, $_;
        }
        $found{$args[$i]} = [] if (@not_found == keys %{$seenref});
    }
    return \%found;
}    

sub is_member_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
    my $aref = _prepare_listrefs(\%data);
    my $seenref = _calculate_seen_only($aref);
    my ($arg, $k);
    $arg = shift;
    while ( $k = each %{$seenref} ) {
        return 1 if (defined ${$seenref}{$k}{$arg});
    }
    return 0;
}    

sub are_members_any {
    my $class = shift;
    croak "Method call needs at least one argument:  $!" unless (@_);
    my %data = %$class;
    my $aref = _prepare_listrefs(\%data);
    my $seenref = _calculate_seen_only($aref);
    my (@args, %present);
    @args = (@_ == 1 and ref($_[0]) eq 'ARRAY') 
        ?  @{$_[0]}
        :  @_;
    for (my $i=0; $i<=$#args; $i++) {
        foreach (keys %{$seenref}) {
            unless (defined $present{$args[$i]}) {
                $present{$args[$i]} = 1 if ${$seenref}{$_}{$args[$i]};
            }
        }
        $present{$args[$i]} = 0 if (! defined $present{$args[$i]});
    }
    return \%present;
}    

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
    my $aref = _prepare_listrefs(\%data);
    my $xsubsetref = _subset_subengine($aref);
    my $title = 'subset';
    _chart_engine_multiple($xsubsetref, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my $aref = _prepare_listrefs(\%data);
    my $xequivalentref = _equivalent_subengine($aref);
    my $title = 'Equivalence';
    _chart_engine_multiple($xequivalentref, $title);
}

1;

