package List::Compare;
$VERSION = 0.14;   # August 18, 2002

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;

sub new {
    my $class = shift;
    my @args = @_;
    my ($option, $self, $dataref);
    $option = $args[0] eq '-a' ? shift(@args) : 0;
    my @arrayrefs = @args;
    foreach (@arrayrefs) {
        croak "Must pass array references: $!" unless ref($_) eq 'ARRAY';
    }

    # bless a ref to an empty hash into the invoking class
    if (@arrayrefs > 2) {
        $class .= '::Multiple';
        $self = bless {}, ref($class) || $class;
    } elsif (@arrayrefs == 2) {
        if ($option eq '-a') {
            $class .= '::Accelerated';
            $self = bless {}, ref($class) || $class;
        } else {
            $self = bless {}, ref($class) || $class;
        }
    } else {
        croak "Must pass at least 2 array references to \&new: $!";
    }
    
    # do necessary calculations and store results in a hash
    # take a reference to that hash
    $dataref = $self->_init(@arrayrefs);
    
    # initialize the object from the prepared values (Damian, p. 98)
    %$self = %$dataref;
    return $self;
}

sub _init {
    my $self = shift;
    my ($refL, $refR) = @_;
    my %data = ();
    my @L = @$refL;
    my @R = @$refR;
    my %seenL = my %seenR = ();
    my @bag = sort(@L, @R);

    my %intersection = my %union = ();
    my %Lonly = my %Ronly = my %LorRonly = ();
    my $LsubsetR_status = my $RsubsetL_status = 1;
    my $LequivalentR_status = 0;

    foreach (@L) { $seenL{$_}++ } 
    foreach (@R) { $seenR{$_}++ } 

    foreach (keys %seenL) {
        $union{$_}++;
        if (exists $seenR{$_}) {
            $intersection{$_}++;
        } else {
            $Lonly{$_}++;
        }
    }
    
    foreach (keys %seenR) {
        $union{$_}++;
        $Ronly{$_}++ unless (exists $intersection{$_});
    }

    foreach ( (keys %Lonly), (keys %Ronly) ) {
        $LorRonly{$_}++;
    }

    $LequivalentR_status = 1 if ( (keys %LorRonly) == 0);

    foreach (@L) {
        if (! exists $seenR{$_}) {
            $LsubsetR_status = 0;
            last;
        }
    }
    foreach (@R) {
        if (! exists $seenL{$_}) {
            $RsubsetL_status = 0;
            last;
        }
    }
    
    %seenL = %seenR = ();
 
    $data{'union'}                = [ sort keys %union ];
    $data{'intersection'}         = [ sort keys %intersection ];
    $data{'unique'}               = [ sort keys %Lonly ];
    $data{'complement'}           = [ sort keys %Ronly ];
    $data{'symmetric_difference'} = [ sort keys %LorRonly ];
    $data{'LsubsetR_status'}      = $LsubsetR_status;
    $data{'RsubsetL_status'}      = $RsubsetL_status;
    $data{'LequivalentR_status'}  = $LequivalentR_status;
    $data{'bag'}                  = \@bag;
    return \%data;
}

sub get_union {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'union'} };
}

sub get_intersection {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'intersection'} };
}

sub get_unique {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'unique'} };
}

*get_Lonly = \&get_unique;
*get_Aonly = \&get_unique;

sub get_complement {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'complement'} };
}

*get_Ronly = \&get_complement;
*get_Bonly = \&get_complement;

sub get_symmetric_difference {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'symmetric_difference'} };
}

*get_symdiff  = \&get_symmetric_difference;
*get_LorRonly = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;

sub get_bag {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'bag'} };
}

sub is_LsubsetR {
    my $class = shift;
    my %data = %$class;
    return $data{'LsubsetR_status'};
}

*is_AsubsetB = \&is_LsubsetR;

sub is_RsubsetL {
    my $class = shift;
    my %data = %$class;
    return $data{'RsubsetL_status'};
}

*is_BsubsetA = \&is_RsubsetL;

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
    return $data{'LequivalentR_status'};
}

*is_LeqvlntR = \&is_LequivalentR;

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
	my @subset_array = ($data{'LsubsetR_status'}, $data{'RsubsetL_status'});
    my $title = 'Subset';
    _chart_engine(\@subset_array, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my @equivalent_array = ($data{'LequivalentR_status'}, $data{'LequivalentR_status'});
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

sub get_version {
    return $List::Compare::VERSION;
}

sub get_shared {
    my $class = shift;
	my $method = (caller(0))[3];
	carp "When comparing only 2 lists, $method defaults to \n  \&get_union.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
	&get_union($class);
}

sub get_nonintersection {
    my $class = shift;
	my $method = (caller(0))[3];
	carp "When comparing only 2 lists, $method defaults to \n  \&get_symmetric_difference.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
	&get_symmetric_difference($class);
}

1;

################################################################################

package List::Compare::Accelerated;
use Carp;

sub _init {
    my $self = shift;
    my ($refL, $refR) = @_;
    my %data = ();
    $data{'L'} = $refL;
    $data{'R'} = $refR;
    return \%data;
}    

sub _calc_seen {
    my ($refL, $refR) = @_;
    my %seenL = my %seenR = ();
    foreach (@$refL) { $seenL{$_}++ }
    foreach (@$refR) { $seenR{$_}++ }
    return (\%seenL, \%seenR); 
}

sub get_unique {
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
    return sort keys %Lonly;
}

*get_Lonly = \&get_unique;
*get_Aonly = \&get_unique;

sub get_complement {
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
    return sort keys %Ronly;
}

*get_Ronly = \&get_complement;
*get_Bonly = \&get_complement;

sub get_union {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %union = ();
    $union{$_}++ foreach ( (keys %{$hrefL}), (keys %{$hrefR}) );
    return sort keys %union;
}

sub get_intersection {
    my $class = shift;
    my %data = %$class;
    my ($hrefL, $hrefR) = _calc_seen($data{'L'}, $data{'R'});
    my %intersection = ();
    foreach (keys %{$hrefL}) {
        $intersection{$_}++ if (exists ${$hrefR}{$_});
    }
    return sort keys %intersection;
}

sub get_symmetric_difference {
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
    return sort keys %LorRonly;
}

*get_symdiff  = \&get_symmetric_difference;
*get_LorRonly = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;

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

sub get_bag {
    my $class = shift;
    my %data = %$class;
    return sort(@{$data{'L'}}, @{$data{'R'}}); 
}

sub get_version {
    return $List::Compare::VERSION;
}

sub get_shared {
    my $class = shift;
	my $method = (caller(0))[3];
	$method =~ s/.*::(\w*)$/$1/;
	carp "When comparing only 2 lists, \&$method defaults to \n  \&get_union.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
	&get_union($class);
}

sub get_nonintersection {
    my $class = shift;
	my $method = (caller(0))[3];
	$method =~ s/.*::(\w*)$/$1/;
	carp "When comparing only 2 lists, \&$method defaults to \n  \&get_symmetric_difference.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
	&get_symmetric_difference($class);
}

1;

################################################################################

package List::Compare::Multiple;
use Carp;

sub _init {
    my $self = shift;
    my @arrayrefs = @_;
    my %data = ();
    my $maxindex = $#arrayrefs;
    
    my @bag = ();
    foreach my $aref (@arrayrefs) {
        push @bag, $_ foreach @$aref;
    }
    @bag = sort(@bag);

    my @intersection = my @union = ();    # will hold overall intersection/union
    my @nonintersection = ();
        # will hold all items except those found in each source list
        # @intersection + @nonintersection = @union
    my @shared = ();    # will hold all items found in at least 2 lists
    my @symmetric_difference = ();
        # will hold each item found in only one list regardless of list;
        # equivalent to @union minus all items found in the lists underlying %xintersection
    my %intersection = my %union = ();    # will be used to generate @intersection & @union
    my %seen = ();
        # will be hash of hashes, holding seen-hashes corresponding to the source lists
    my %xintersection = ();
        # will be hash of hashes, holding seen-hashes corresponding to the lists 
        # containing the intersections of each permutation of the source lists
    my %shared = ();    # will be used to generate @shared
    my %xunique = ();
        # will be hash of arrays, holding the items that are unique to the list 
        # whose index number is passed as an argument
    my %xcomplement = ();
        # will be hash of arrays, holding the items that are found in any list other than 
        # the list whose index number is passed as an argument

    # Calculate overall union
    # and take steps needed to calculate overall intersection, unique, difference, etc.
    for (my $i = 0; $i <= $#arrayrefs; $i++) {
        my %seenthis = ();
        foreach $_ (@{$arrayrefs[$i]}) {
            $seenthis{$_}++;
            $union{$_}++;
        }
        $seen{$i} = \%seenthis;
        for (my $j = $i+1; $j <=$#arrayrefs; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach (@{$arrayrefs[$j]});
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    @union = sort keys %union;
    # At this point we now have %seen, @union and %xintersection available for use
    # in other calculations.


    # Calculate overall intersection
    # Inputs:  %xintersection
    my @xkeys = sort keys %xintersection;
    %intersection = %{$xintersection{$xkeys[0]}};
    for (my $m = 1; $m <= $#xkeys; $m++) {
        my %compare = %{$xintersection{$xkeys[$m]}};
        my %result = ();
        foreach (sort keys %compare) {
            $result{$_}++ if (exists $intersection{$_});
        }
        %intersection = %result;
    }
    @intersection = sort keys %intersection;
    
    
    # Calculate nonintersection
    # Inputs:  @union    %intersection
    foreach (@union) {
        push(@nonintersection, $_) unless (exists $intersection{$_});
    }
    
    
    # Calculate %xunique
    # Inputs:  @arrayrefs    %seen    %xintersection
    for (my $i = 0; $i <= $#arrayrefs; $i++) {
        my %seenthis = %{$seen{$i}};
        my @uniquethis = ();
        # Get those elements of %xintersection which we'll need to subtract from %seenthis
        my %deductions = my %alldeductions = ();
        foreach (sort keys %xintersection) {
            my ($left, $right) = split /_/, $_;
            if ($left == $i || $right == $i) {
                $deductions{$_} = $xintersection{$_};
            }
        }
        foreach my $ded (sort keys %deductions) {
            foreach (sort keys %{$deductions{$ded}}) {
                $alldeductions{$_}++;
            }
        }
        foreach (sort keys %seenthis) {
            push(@uniquethis, $_) unless ($alldeductions{$_});
        }
        $xunique{$i} = \@uniquethis;
    }
    # %xunique is now available for use in further calculations, such as returning the items 
    # unique to a particular source list.


    # Calculate %xcomplement
    # Inputs:  @arrayrefs    %seen    @union
    for (my $i = 0; $i <= $#arrayrefs; $i++) {
        my %seenthis = %{$seen{$i}};
        my @complementthis = ();
        foreach (@union) {
            push(@complementthis, $_) unless (exists $seenthis{$_});
        }
        $xcomplement{$i} = \@complementthis;
    }
    # %xcomplement is now available for use in further calculations, such as returning the items 
    # in all lists different from those in a particular source list.


    # Calculate @shared and @symmetric_difference
    # Inputs:  %xintersection    @union
    foreach my $q (sort keys %xintersection) {
        $shared{$_}++ foreach (sort keys %{$xintersection{$q}});
    }
    @shared = sort keys %shared;
    foreach (@union) {
        push(@symmetric_difference, $_) unless (exists $shared{$_});
    }
    # @shared and @symmetric_difference are now available.
    
    
    my @xsubset = ();
    foreach my $i (keys %seen) {
        my %tempi = %{$seen{$i}};
        foreach my $j (keys %seen) {
            my %tempj = %{$seen{$j}};
            $xsubset[$i][$j] = 1;
            foreach (keys %tempi) {
                $xsubset[$i][$j] = 0 if (! $tempj{$_});
            }
        }
    }
    # @xsubset is now available
    
    my @xequivalent = ();
    for (my $f = 0; $f <= $#xsubset; $f++) {
        for (my $g = 0; $g <= $#xsubset; $g++) {
            $xequivalent[$f][$g] = 0;
            $xequivalent[$f][$g] = 1
                if ($xsubset[$f][$g] 
                 && $xsubset[$g][$f]);
        }
    }
    
    $data{'maxindex'}               = $maxindex;
    $data{'bag'}                    = \@bag;
    $data{'union'}                  = \@union;
    $data{'intersection'}           = \@intersection;
    $data{'nonintersection'}        = \@nonintersection;
    $data{'shared'}                 = \@shared;
    $data{'symmetric_difference'}   = \@symmetric_difference;
    $data{'xunique'}                = \%xunique;
    $data{'xcomplement'}            = \%xcomplement;
    $data{'xsubset'}                = \@xsubset;
    $data{'xequivalent'}            = \@xequivalent;
    return \%data;
}    

sub get_bag {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'bag'} };
}

sub get_union {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'union'} };
}

sub get_intersection {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'intersection'} };
}

sub get_nonintersection {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'nonintersection'} };
}

sub get_shared {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'shared'} };
}

sub get_symmetric_difference {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'symmetric_difference'} };
}

*get_symdiff  = \&get_symmetric_difference;

sub get_LorRonly {
    my $class = shift;
    my $method = (caller(0))[3];
	$method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  \&get_symmetric_difference.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_symmetric_difference($class);
}    

*get_AorBonly = \&get_LorRonly;

sub get_unique {
    my $class = shift;
    my %data = %$class;
    my $index = '';
    $index = defined $_[0] ? shift : 0;
    _index_message1($index, \%data);
    my %temp = %{$data{'xunique'}};
    return @{$temp{$index}};
}

#sub get_Lonly {
#    my $class = shift;
#    my $method = (caller(0))[3];
#	$method =~ s/.*::(\w*)$/$1/;
#    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  \&get_unique.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
#    &get_unique($class);
#}    

sub get_Lonly {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
	$method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  \&get_unique.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_unique($class, $index);
}    

*get_Aonly = \&get_Lonly;

sub get_complement {
    my $class = shift;
    my %data = %$class;
    my $index = '';
    $index = defined $_[0] ? shift : 0;
    _index_message1($index, \%data);
    my %temp = %{$data{'xcomplement'}};
    return @{$temp{$index}};
}

#sub get_Ronly {
#    my $class = shift;
#    my $method = (caller(0))[3];
#	$method =~ s/.*::(\w*)$/$1/;
#    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  \&get_complement.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
#    &get_complement($class);
#}    

sub get_Ronly {
    my ($class, $index) = @_;
    my $method = (caller(0))[3];
	$method =~ s/.*::(\w*)$/$1/;
    carp "When comparing 3 or more lists, \&$method or its alias defaults to \n  \&get_complement.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_complement($class, $index);
}    

*get_Bonly = \&get_Ronly;

sub is_LsubsetR {
    my $class = shift;
    my %data = %$class;
    my ($index_left, $index_right) = _index_message2(\%data, @_);
    my @subset_array = @{$data{'xsubset'}};
    my $subset_status = $subset_array[$index_left][$index_right];
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
    my ($index_left, $index_right) = _index_message2(\%data, @_);
    my @subset_array = @{$data{'xsubset'}};
    my $subset_status = $subset_array[$index_left][$index_right];
    return $subset_status;
}

*is_BsubsetA = \&is_RsubsetL;

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
    my ($index_left, $index_right) = _index_message2(\%data, @_);
    my @equivalent_array = @{$data{'xequivalent'}};
    my $equivalent_status = $equivalent_array[$index_left][$index_right];
    return $equivalent_status;
}

*is_LeqvlntR = \&is_LequivalentR;

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
    my @subset_array = @{$data{'xsubset'}};
    my $title = 'subset';
    _chart_engine(\@subset_array, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my @equivalent_array = @{$data{'xequivalent'}};
    my $title = 'Equivalence';
    _chart_engine(\@equivalent_array, $title);
}

sub get_version {
    return $List::Compare::VERSION;
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

sub _index_message1 {
    my ($index, $dataref) = @_;
    my %data = %$dataref;
    my $method = (caller(1))[3];
    croak "Argument to method $method must be the array index of the target list \n  in list of arrays passed as arguments to the constructor: $!"
        unless (
               $index =~ /^\d+$/ 
            && 0 <= $index 
            && $index <= $data{'maxindex'}
        );
}

sub _index_message2 {
    my $dataref = shift;
    my %data =%$dataref;
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
                    && 0 <= $_ 
                    && $_ <= $data{'maxindex'}
                );
        }
    }
    return ($index_left, $index_right);
}

1;


__END__

=head1 NAME

List::Compare - Compare elements of two or more lists

=head1 VERSION

This document refers to version 0.14 of List::Compare.  This version was
released August 18, 2002.

=head1 SYNOPSIS

=head2 Simple Case:  Compare Two Lists

Create a List::Compare object.  Put the two lists into arrays and pass
references to the arrays to the constructor.

    @Llist = qw(abel abel baker camera delta edward fargo golfer);
    @Rlist = qw(baker camera delta delta edward fargo golfer hilton);

    $lc = List::Compare->new(\@Llist, \@Rlist);

Get those items which appear in both lists (their intersection).

    @intersection = $lc->get_intersection;

Get those items which appear in either list (their union).

    @union = $lc->get_union;

Get those items which appear only in the first list.

    @Lonly = $lc->get_unique;
    @Lonly = $lc->get_Lonly;	# alias

Get those items which appear only in the second list.

    @Ronly = $lc->get_complement;
    @Ronly = $lc->get_Ronly;	# alias

Get those items which appear in either the first or the second list, but
not both.

    @LorRonly = $lc->get_symmetric_difference;
    @LorRonly = $lc->get_symdiff;		# alias
    @LorRonly = $lc->get_LorRonly;		# alias

Make a bag of all those items in both lists.  The bag differs from the 
union of the two lists in that it holds as many copies of individual 
elements as appear in the original lists.

    @bag = $lc->get_bag;

Return a true value if L is a subset of R.

    $LR = $lc->is_LsubsetR;

Return a true value if R is a subset of L.

    $RL = $lc->is_RsubsetL;

Return a true value if L and R are equivalent, I<i.e.> if every element 
in L appears at least once in R and I<vice versa>.

    $eqv = $lc->is_LequivalentR;
    $eqv = $lc->is_LeqvlntR;		# alias

Pretty-print a chart showing whether one list is a subset of the other.

    $lc->print_subset_chart;

Pretty-print a chart showing whether the two lists are equivalent (same 
elements found at least once in both).

    $lc->print_equivalence_chart;

Return current List::Compare version number.

    $vers = $lc->get_version;

=head2 Accelerated Case:  When User Only Wants a Single Comparison

If you are certain that you will only want the results of a single 
comparison, computation may be accelerated by passing C<'-a'> as the first 
argument to the constructor.

    @Llist = qw(abel abel baker camera delta edward fargo golfer);
    @Rlist = qw(baker camera delta delta edward fargo golfer hilton);

    $lca = List::Compare->new('-a', \@Llist, \@Rlist);

All the comparison methods available in the Simple case are available to 
the user in the Accelerated case as well.

    @intersection = $lca->get_intersection;
    @union        = $lca->get_union;
    @Lonly        = $lca->get_unique;
    @Ronly        = $lca->get_complement;
    @LorRonly     = $lca->get_symmetric_difference;
    @bag          = $lca->get_bag;
    $LR           = $lca->is_LsubsetR;
    $RL           = $lca->is_RsubsetL;
    $eqv          = $lca->is_LequivalentR;
                    $lca->print_subset_chart;
                    $lca->print_equivalence_chart;
    $vers         = $lca->get_version;

All the aliases for methods available in the Simple case are available to 
the user in the Accelerated case as well.

=head2 Multiple Case:  Compare Three or More Lists

Create a List::Compare object.  Put each list into an array and pass
references to the arrays to the constructor.

    @Al     = qw(abel abel baker camera delta edward fargo golfer);
    @Bob    = qw(baker camera delta delta edward fargo golfer hilton);
    @Carmen = qw(fargo golfer hilton icon icon jerky kappa);
    @Don    = qw(fargo icon jerky);
    @Ed     = qw(fargo icon icon jerky);

    $lcm = List::Compare->new(\@Al, \@Bob, \@Carmen, \@Don, \@Ed);

=over 4

=item *

Multiple Mode Methods Analogous to Simple and Accelerated Mode Methods

Each List::Compare method available in the Simple and Accelerated cases 
has an analogue in the Multiple case.  However, the results produced 
usually require more careful specification.

Get those items found in each of the lists passed to the constructor 
(their intersection):

    @intersection = $lcm->get_intersection;

Get those items found in any of the lists passed to the constructor 
(their union):

    @union = $lcm->get_union;

To get those items which appear only in one particular list, pass to 
C<get_unique> that list's index position in the list of arguments passed 
to the constructor.  Example:  C<@Carmen> has index position 2 in the 
constructor's C<@_>.  To get elements unique to C<@Carmen>:  

    @Lonly = $lcm->get_unique(2);

If no index position is passed to C<get_unique> it will default to 0 
and report items unique to the first list passed to the constructor.

To get those items which appear in any list other than one particular 
list, pass to C<get_complement> that list's index position in the list 
of arguments passed to the constructor.  Example:  C<@Don> has index 
position 3 in the constructor's C<@_>.  To get elements not found in 
C<@Don>:  

    @Ronly = $lcm->get_complement(3);

If no index position is passed to C<get_complement> it will default to 
0 and report items found in any list other than the first list passed 
to the constructor.

Get those items which do not appear in more than one of the lists 
passed to the constructor (their symmetric_difference);

    @LorRonly = $lcm->get_symmetric_difference;

Make a bag of all items found in any list.  The bag differs from the 
lists' union in that it holds as many copies of individual elements 
as appear in the original lists.

    @bag = $lcm->get_bag;

To determine whether one particular list is a subset of another list 
passed to the constructor, pass to C<is_LsubsetR> the index position of 
the presumed subset, followed by the index position of the presumed 
superset.  A true value (1) is returned if the left-hand list is a 
subset of the right-hand list; a false value (0) is returned otherwise.
Example:  To determine whether C<@Ed> is a subset of C<@Carmen>, call:

    $LR = $lcm->is_LsubsetR(4,2);

If no arguments are passed, C<is_LsubsetR> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

To determine whether any two particular lists are equivalent to each 
other, pass their index positions in the list of arguments passed to 
the constructor to C<is_LequivalentR>. A true value (1) is returned if 
the lists are equivalent; a false value (0) otherwise. Example:  To 
determine whether C<@Don> and C<@Ed> are equivalent, call:

    $eqv = $lcm->is_LequivalentR(3,4);

If no arguments are passed, C<is_LequivalentR> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

Pretty-print a chart showing the subset relationships among the various 
source lists:

    $lcm->print_subset_chart;

Pretty-print a chart showing the equivalence relationships among the 
various source lists:

    $lcm->print_equivalence_chart;

Return current List::Compare version number:

    $vers = $lcm->get_version;

=item *

Multiple Mode Methods Not Analogous to Simple and Accelerated Mode Methods

Get those items found in any of the lists passed to the constructor which 
do not appear in all of the lists (I<i.e.,> all items except those found 
in the intersection of the lists):

    @nonintersection = $lcm->get_nonintersection;

Get those items which appear in more than one of the lists passed to the 
constructor (I<i.e.,> all items except those found in their symmetric 
difference);

    @shared = $lcm->get_shared;

=back

=head1 DESCRIPTION

=head2 General Comments

List::Compare is an object-oriented implementation of very common Perl 
code (see "History, References and Development" below) used to
determine interesting relationships between two or more lists at a time.  
A List::Compare object is created and automatically computes the values
needed to supply List::Compare methods with appropriate results.  In the
current implementation List::Compare methods will return new lists
containing the items found in any designated list alone (unique), any list 
other than a designated list (complement), the intersection and union of 
all lists and so forth.  List::Compare also has (a) methods to return Boolean
values indicating whether one list is a subset of another and whether any 
two lists are equivalent to each other (b) methods to pretty-print very 
simple charts displaying the subset and equivalence relationships among 
lists.

In its current implementation List::Compare, with one exception (C<get_bag>), 
generates its results by means of hash look-up tables.  Hence, multiple 
instances of an element in a given list only count once with respect to 
computing the intersection, union, etc. of the two lists.  In particular, 
List::Compare considers two lists as equivalent if each element of the 
first list can be found in the second list and I<vice versa>.  
'Equivalence' in this usage takes no note of the frequency with which 
elements occur in either list or their order within the lists.  Only when 
we use C<get_bag> to compute a bag holding the two lists do we take into 
account multiple instances of a particular element within a source list.

=head2 List::Compare Modes

In its current implementation List::Compare has three modes of operation.

=over 4

=item *

Simple Mode

List::Compare's Simple mode is based on List::Compare v0.11 -- the first 
version of List::Compare released to CPAN (June 2002).  It compares only 
two lists at a time.  Internally, its initializer does all computations 
needed to report any desired comparison and its constructor stores the 
results of these computations.  Its public methods merely report these 
results.

This approach has the advantage that if the user needs to examine more 
than one form of comparison between two lists (I<e.g.,> the union, 
intersection and symmetric difference of two lists), the comparisons are 
already available.  This approach is efficient because certain types of 
comparison presuppose that other types have already been calculated.  
For example, to calculate the symmetric difference of two lists, one must 
first determine the items unique to each of the two lists.

=item *

Accelerated Mode

The current implementation of List::Compare offers the user the option of 
getting even faster results I<provided> that the user only needs the 
result from one form of comparison between two lists. (I<e.g.,> only the 
union -- nothing else).  In this Accelerated mode, List::Compare's 
initializer does no computation and its constructor stores only references 
to the two source lists.  All computation needed to report results is 
deferred to the method calls.

The user selects this approach by passing the option flag C<'-a'> to the 
constructor before passing references to the two source lists.  
List::Compare notes the option flag and silently switches into Accelerated 
mode.  From the perspective of the user, there is no further difference in 
the code or in the results.

Benchmarking suggests that List::Compare's Accelerated mode (a) is faster 
than its Simple mode when only one comparison is requested; (b) is about as 
fast as Simple mode when two comparisons are requested; and (c) becomes 
considerably slower than Simple mode as each additional comparison above two 
is requested.

=item *

Multiple Mode

List::Compare now offers the possibility of comparing three or more lists at 
a time.  Simply store the extra lists in arrays and pass references to those 
arrays to the constructor.  List::Compare detects that more than two lists 
have been passed to the constructor and silently switches into Multiple mode.

As described in the Synopsis above, comparing more than two lists at a time 
offers the user a wider, more complex palette of comparison methods.  
Individual items may appear in just one source list, in all the source lists, 
or in some number of lists between one and all.  The meaning of 'union', 
'intersection' and 'symmetric difference' is conceptually unchanged 
when we move to multiple lists because these are properties of all the lists 
considered together.  In contrast, the meaning of 'unique', 'complement', 
'subset' and 'equivalent' changes because these are properties of list 
compared with another or with all the other lists combined.

List::Compare takes this complexity into account by allowing the user to pass 
arguments to the public methods requesting results with respect to a specific 
list (for C<get_unique> and C<get_complement>) or a specific pair of lists 
(for C<is_LsubsetR> and C<is_LequivalentR>).

List::Compare further takes this complexity into account by offering the 
new methods C<get_shared> and C<get_nonintersection> described in the Synopsis 
above.

=back

=head2 Miscellaneous Methods

It would not really be appropriate to call C<get_shared> and C<get_nonintersection> 
in Simple or Accelerated mode since they are conceptually based on the notion 
of comparing more than two lists at a time.  However, there is always the 
possibility that a user may be comparing only two lists (accelerated or not) 
and may accidentally call one of those two methods.  To prevent fatal run-time 
errors and to caution the user to use a more appropriate method, these two 
methods are defined for Simple and Accelerated modes so as to return suitable 
results but also generate a carp message that advise the user to re-code.

Similarly, the method C<is_RsubsetL> is appropriate for the Simple and Accelerated 
modes but is not really appropriate for Multiple mode.  As a defensive maneuver, 
it has been defined for Multiple mode so as to return suitable results but also to 
generate a carp message that advises the user to re-code.

In List::Compare v0.11 and earlier, the author provided aliases for various 
methods based on the supposition that the source lists would be referred to as 
'A' and 'B'.  Now that we can compare more than two lists at a time, the author 
feels that it would be more appropriate to refer to the elements of two-argument 
lists as the left-hand and right-hand elements.  Hence, we are discouraging the 
use of methods such as C<get_Aonly>, C<get_Bonly> and C<get_AorBonly> as aliases 
for C<get_unique>, C<get_complement> and C<get_symmetric_difference>.  However, 
to guarantee backwards compatibility for the vast audience of Perl programmers 
using earlier versions of List::Compare (all 10e1 of you) these and similar 
methods for subset relationships are still defined.

=head1 ASSUMPTIONS AND QUALIFICATIONS

The program was created with Perl 5.6. The use of I<h2xs> to prepare 
the module's template installed C<require 5.005_62;> at the top of the
module.  This has been commented out in the actual module as the code 
appears to be compatible with earlier versions of Perl; how earlier the 
author cannot say.  In particular, the author would like the module to 
be installable on older versions of MacPerl.  As is, the author has 
successfully installed the module on Linux (RedHat 7.2, Perl 5.6.0) and 
Windows98 (ActivePerl 5.6.1).  See the CPAN home page for this module for 
a list of other systems on which this version of List::Compare has been 
tested and installed.

=head1 HISTORY, REFERENCES AND DEVELOPMENT

=head2 The Code Itself

List::Compare is based on code presented by Tom Christiansen & Nathan
Torkington in I<Perl Cookbook> L<http://www.oreilly.com/catalog/cookbook/>
(a.k.a. the 'Ram' book), O'Reilly & Associates, 1998, Recipes 4.7 and 4.8. 
Similar code is presented in the Camel book:  I<Programming Perl>, by Larry
Wall, Tom Christiansen, Jon Orwant. 
L<http://www.oreilly.com/catalog/pperl3/>, 3rd ed, O'Reilly & Associates,
2000.  The list comparison code is so basic and Perlish that I suspect it
may have been written by Larry himself at the dawn of Perl time.  The 
C<get_bag()> method was inspired by Jarkko Hietaniemi's Set::Bag module
and Daniel Berger's Set::Array module, both available on CPAN.

List::Compare's original objective was simply to put this code in a modular, 
object-oriented framework.  That framework, not surprisingly, is taken mostly 
from Damian Conway's I<Object Oriented Perl> 
L<http://www.manning.com/Conway/index.html>, Manning Publications, 2000.

With the addition of the Accelerated and Multiple modes, List::Compare 
expands considerably in both size and capabilities.  Nonetheless,  Tom and 
Nat's Cookbook code still lies at its core:  the use of hashes as look-up 
tables to record elements seen in lists.  This approach means that 
List::Compare is not concerned with any concept of 'equality' among lists 
which hinges upon the frequency with which, or the order in which, elements 
appear in the lists to be compared.  If this does not meet your needs, you 
should look elsewhere or write your own module.

=head2 The Inspiration

I realized the usefulness of putting the list comparison code into a
module while preparing an introductory level Perl course given at the New
School University's Computer Instruction Center in April-May 2002.  I was
comparing lists left and right.  When I found myself writing very similar
functions in different scripts, I knew a module was lurking somewhere. 
I learned the truth of the mantra ''Repeated Code is a Mistake'' from a 
2001 talk by Mark-Jason Dominus L<http://perl.plover.com/> to the New York 
Perlmongers L<http://ny.pm.org/>.  See L<http://www.perl.com/pub/a/2000/11/repair3.html>.   
The first public presentation of this module took place at Perl Seminar 
New York L<http://groups.yahoo.com/group/perlsemny>
on May 21, 2002.  Comments and suggestions were provided there and since 
by Glenn Maciag, Gary Benson, Josh Rabinowitz, Terrence Brannon and Dave Cross.

=head2 If You Like List::Compare, You'll Love ...

While preparing this module for distribution via CPAN, I had occasion to
study a number of other modules already available on CPAN.  Each of these
modules is more sophisticated than List::Compare -- which is not surprising
since all that List::Compare originally aspired to do was to avoid typing
Cookbook code repeatedly.  Here is a brief description of the features of
these modules.

=over 4

=item *

Algorithm::Diff - Compute 'intelligent' differences between two files/lists
(L<http://search.cpan.org/doc/NEDKONZ/Algorithm-Diff-1.15/lib/Algorithm/Dif
f.pm>)

Algorithm::Diff is a sophisticated module originally written by Mark-Jason
Dominus and now maintained by Ned Konz. Think of the Unix C<diff> utility 
and you're on the right track.  Algorithm::Diff exports methods such as 
C<diff>, which "computes the smallest set of additions and deletions necessary 
to turn the first sequence into the second, and returns a description of these
changes."  Algorithm::Diff is mainly concerned with the sequence of
elements within two lists.  It does not export functions for intersection,
union, subset status, etc.

=item *

Array::Compare - Perl extension for comparing arrays
(L<http://search.cpan.org/doc/DAVECROSS/Array-Compare-1.03/Compare.pm>)

Array::Compare, by Dave Cross, asks whether two arrays
are the same or different by doing a C<join> on each string with a
separator character and comparing the resulting strings.  Like
List::Compare, it is an object-oriented module.  A sophisticated feature of
Array::Compare is that it allows the user to specify how 'whitespace' in an
array (an element which is undefined, the empty string, or whitespace
within an element) should be evaluated for purpose of determining equality
or difference.	It does not directly provide methods for intersection and
union.

=item *

List::Util - A selection of general-utility list subroutines
(L<http://search.cpan.org/doc/GBARR/Scalar-List-Utils-1.0701/lib/List/Util.
pm>)

List::Util, by Graham Barr, exports a variety of simple,
useful functions for operating on one list at a time.	The C<min> function
returns the lowest numerical value in a list; the C<max> function returns
the highest value; and so forth.  List::Compare differs from List::Util in
that it is object-oriented and that it works on two strings at a time
rather than just one -- but it aims to be as simple and useful as
List::Util.  List::Util will be included in the standard Perl 
distribution as of Perl 5.8.0.

Lists::Util (L<http://search.cpan.org/doc/TBONE/List-Utils-0.01/Utils.pm>), 
by Terrence Brannon, provides methods which extend List::Util's functionality.

=item *

Quantum::Superpositions 
(L<http://search.cpan.org/doc/DCONWAY/Quantum-Superpositions-1.03/lib/Quantum/Superpositions.pm>), 
by Damian Conway, is useful if, in addition to comparing lists, you need to
emulate quantum supercomputing as well.  Not for the eigen-challenged.

=item *

Set::Scalar - basic set operations
(L<http://search.cpan.org/doc/JHI/Set-Scalar-1.17/lib/Set/Scalar.pm>)

Set::Bag - bag (multiset) class
(L<http://search.cpan.org/doc/JHI/Set-Bag-1.007/lib/Set/Bag.pm>)

Both of these modules are by Jarkko Hietaniemi.  Set::Scalar
has methods to return the intersection, union, difference and symmetric
difference of two sets, as well as methods to return items unique to a
first set and complementary to it in a second set.  It has methods for
reporting considerably more variants on subset status than does
List::Compare.  However, benchmarking suggests that List::Compare, at 
least in Simple mode, is considerably faster than Set::Scalar for those 
comparison methods which List::Compare makes available.

Set::Bag enables one to deal more flexibly with the situation in which one
has more than one instance of an element in a list.

=item *

Set::Array - Arrays as objects with lots of handy methods (including set
comparisons) and support for method chaining.
(L<http://search.cpan.org/doc/DJBERG/Set-Array-0.08/Array.pm>)

Set::Array, by Daniel Berger, "aims to provide
built-in methods for operations that people are always asking how to do,and
which already exist in languages like Ruby."  Among the many methods in
this module are some for intersection, union, etc.  To install Set::Array,
you must first install the Want module, also available on CPAN.

=back

=head1 AUTHOR

James E. Keenan (jkeen@concentric.net).

Creation date:  May 20, 2002.  Last modification date:  August 18, 2002. 
Copyright (c) 2002 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 




