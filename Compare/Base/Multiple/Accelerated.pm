package List::Compare::Base::Multiple::Accelerated;
$VERSION = 0.24;
# As of:  March 28, 2004

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;

sub get_union {
    return @{ get_union_ref(shift) };
}

sub get_union_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_arrayrefs(\%data);

    my (%union);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        foreach $_ (@{${$aref}[$i]}) {
            $union{$_}++;
        }
    }
    my @union = $unsortflag ? keys %union : sort(keys %union);
    return \@union;
}

sub get_intersection {
    return @{ get_intersection_ref(shift) };
}

sub get_intersection_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_arrayrefs(\%data);

    my ($seenref, $xintersectionref) = 
       _calculate_seen_xintersection_only($aref);
    my %seen = %{$seenref};
    my %xintersection = %{$xintersectionref};

    # Calculate overall intersection
    # Inputs:  %xintersection
    my @xkeys = keys %xintersection;
    my %intersection = %{$xintersection{$xkeys[0]}};
    for (my $m = 1; $m <= $#xkeys; $m++) {
        my %compare = %{$xintersection{$xkeys[$m]}};
        my %result = ();
        foreach (keys %compare) {
            $result{$_}++ if (exists $intersection{$_});
        }
        %intersection = %result;
    }
    my @intersection = 
        $unsortflag ? keys %intersection : sort(keys %intersection);
    return \@intersection;
}

sub get_nonintersection {
    return @{ get_nonintersection_ref(shift) };
}

sub get_nonintersection_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_arrayrefs(\%data);

    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($aref);
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});
    my %xintersection = %{$xintersectionref};

    my @xkeys = keys %xintersection;
    my %intersection = %{$xintersection{$xkeys[0]}};
    for (my $m = 1; $m <= $#xkeys; $m++) {
        my %compare = %{$xintersection{$xkeys[$m]}};
        my %result = ();
        foreach (keys %compare) {
            $result{$_}++ if (exists $intersection{$_});
        }
        %intersection = %result;
    }

    # Calculate nonintersection
    # Inputs:  @union    %intersection
    my (@nonintersection);
    foreach (@union) {
        push(@nonintersection, $_) unless (exists $intersection{$_});
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
    my $aref = _prepare_arrayrefs(\%data);

    my (%xintersection);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach $_ (@{${$aref}[$i]}) {
            $seenthis{$_}++;
        }
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach (@{${$aref}[$j]});
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    # Calculate @shared
    # Inputs:  %xintersection
    my (%shared);
    foreach my $q (keys %xintersection) {
        $shared{$_}++ foreach (keys %{$xintersection{$q}});
    }
    my @shared = $unsortflag ? keys %shared : sort(keys %shared);
    return \@shared;
}

sub get_symmetric_difference {
    return @{ get_symmetric_difference_ref(shift) };
}

sub get_symmetric_difference_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_arrayrefs(\%data);

    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($aref);
    my @union = $unsortflag ? keys %{$unionref} : sort(keys %{$unionref});
    my %xintersection = %{$xintersectionref};

    my (%shared);
    foreach my $q (keys %xintersection) {
        $shared{$_}++ foreach (keys %{$xintersection{$q}});
    }
    my (@symmetric_difference);
    foreach (@union) {
        push(@symmetric_difference, $_) unless (exists $shared{$_});
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
    my $aref = _prepare_arrayrefs(\%data);
    _index_message3($index, $#{$aref});

    my ($seenref, $xintersectionref) = 
        _calculate_seen_xintersection_only(\$aref);
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
    my $aref = _prepare_arrayrefs(\%data);
    _index_message3($index, $#{$aref});

    my (@union, %union, %seen, %xcomplement);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach $_ (@{${$aref}[$i]}) {
            $seenthis{$_}++;
            $union{$_}++;
        }
        $seen{$i} = \%seenthis;
    }
    @union = $unsortflag ? keys %union : sort(keys %union);

    # Calculate %xcomplement
    # Inputs:  $aref @union
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
    my $subset_status = _subset_engine(\%data, @_);
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

    my $subset_status = _subset_engine(\%data, @_);
    return $subset_status;
}

*is_BsubsetA = \&is_RsubsetL;

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
    my $aref = _prepare_arrayrefs(\%data);
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
    my $seenref = _calculate_seen_only(\%data);
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
    my $seenref = _calculate_seen_only(\%data);
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
    my $seenref = _calculate_seen_only(\%data);
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
    my $seenref = _calculate_seen_only(\%data);
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
    my $aref = _prepare_arrayrefs(\%data);
    my $xsubsetref = _subset_subengine($aref);
    my $title = 'subset';
    _chart_engine($xsubsetref, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my $aref = _prepare_arrayrefs(\%data);
    my $xequivalentref = _equivalent_subengine($aref);
    my $title = 'Equivalence';
    _chart_engine($xequivalentref, $title);
}

sub _equivalent_subengine {
    my $aref = shift;
    my $xsubsetref = _subset_subengine($aref);
    my @xsubset = @{$xsubsetref};
    my (@xequivalent);
    for (my $f = 0; $f <= $#xsubset; $f++) {
        for (my $g = 0; $g <= $#xsubset; $g++) {
            $xequivalent[$f][$g] = 0;
            $xequivalent[$f][$g] = 1
                if ($xsubset[$f][$g] and $xsubset[$g][$f]);
        }
    }
    return \@xequivalent;
}

sub get_bag {
    return @{ get_bag_ref(shift) };
}

sub get_bag_ref {
    my $class = shift;
    my %data = %$class;
    my $unsortflag = $data{'unsort'};
    my $aref = _prepare_arrayrefs(\%data);
    my @bag = ();
    foreach my $m (@$aref) {
        foreach my $n (@$m) {
            push(@bag, $n);
        }
    }
    @bag = sort(@bag) unless $unsortflag;
    return \@bag;
}

sub get_version {
    return $List::Comparea::VERSION;
}

#########################################################
##### INTERNAL SUBROUTINES #####
#########################################################

sub _index_message3 {
    my ($index, $maxindex) = @_;
    my $method = (caller(1))[3];
    croak "Argument to method $method must be the array index of the target list \n  in list of arrays passed as arguments to the constructor: $!"
        unless (
                $index =~ /^\d+$/ 
           and  0 <= $index 
           and  $index <= $maxindex
        );
}

sub _index_message4 {
    my $maxindex = shift;
    my ($index_left, $index_right);
    my $method = (caller(1))[3];
    croak "Method $method requires 2 arguments: $!"
        unless (@_ == 0 || @_ == 2);
    if (@_ == 0) {
        $index_left = 0;
        $index_right = 1;
    } else {
        ($index_left, $index_right) = @_;
        foreach ($index_left, $index_right) {
            croak "Each argument to method $method must be a valid array index for the target list \n  in list of arrays passed as arguments to the constructor: $!"
                unless (
                        $_ =~ /^\d+$/ 
                   and  0 <= $_ 
                   and  $_ <= $maxindex
                );
        }
    }
    return ($index_left, $index_right);
}

sub _prepare_arrayrefs {
    my $dataref = shift;
    my (@arrayrefs);
    foreach my $listref (sort {$a <=> $b} keys %{$dataref}) {
        unless ($listref eq 'unsort') {
            push(@arrayrefs, ${$dataref}{$listref});
        }
    };
    return \@arrayrefs;
}

sub _calculate_union_xintersection_only {
    my $aref = shift;
    my (%union, %xintersection);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h (@{${$aref}[$i]}) {
            $seenthis{$h}++;
            $union{$h}++;
        }
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach (@{${$aref}[$j]});
            foreach my $k (keys %seenthat) {
                $seenintersect{$k}++ if (exists $seenthis{$k});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    return (\%union, \%xintersection);
}

sub _calculate_seen_xintersection_only {
    my $aref = shift;
    my (%xintersection, %seen);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach $_ (@{${$aref}[$i]}) {
            $seenthis{$_}++;
        }
        $seen{$i} = \%seenthis;
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach (@{${$aref}[$j]});
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    return (\%seen, \%xintersection);
}

sub _calculate_seen_only {
    my $dataref = shift;
    my $aref = _prepare_arrayrefs($dataref);

    my (%seen);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach $_ (@{${$aref}[$i]}) {
            $seenthis{$_}++;
        }
        $seen{$i} = \%seenthis;
    }
    return \%seen;
}

sub _subset_engine {
    my $dataref = shift;
    my $aref = _prepare_arrayrefs($dataref);
    my ($index_left, $index_right) = _index_message4($#{$aref}, @_);

    my $xsubsetref = _subset_subengine(\$aref);
    return ${$xsubsetref}[$index_left][$index_right];
}

sub _subset_subengine {
    my $aref = shift;
    my (%seen, @xsubset);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $j (@{${$aref}[$i]}) {
            $seenthis{$j}++;
        }
        $seen{$i} = \%seenthis;
    }
    foreach my $i (keys %seen) {
        my %tempi = %{$seen{$i}};
        foreach my $j (keys %seen) {
            my %tempj = %{$seen{$j}};
            $xsubset[$i][$j] = 1;
            foreach my $k (keys %tempi) {
                $xsubset[$i][$j] = 0 if (! $tempj{$k});
            }
        }
    }
    return \@xsubset;
}

sub _chart_engine {
    my $aref = shift;
    my @sub_or_eqv = @$aref;
    my $title = shift;
    my ($v, $w, $t);
    print "\n";
    print $title, ' Relationships', "\n\n";
    print '   Right:';
    for ($v = 0; $v <= $#sub_or_eqv; $v++) {
        print '    ', $v;
    }
    print "\n\n";
    print 'Left:  0:';
    my @firstrow = @{$sub_or_eqv[0]};
    for ($t = 0; $t <= $#firstrow; $t++) {
        print '    ', $firstrow[$t];
    }
    print "\n\n";
    for ($w = 1; $w <= $#sub_or_eqv; $w++) {
        my $length_left = length($w);
        my $x = '';
        print ' ' x (8 - $length_left), $w, ':';
        my @row = @{$sub_or_eqv[$w]};
        for ($x = 0; $x <= $#row; $x++) {
            print '    ', $row[$x];
        }
        print "\n\n";
    }
    1; # force return true value
}

1;

