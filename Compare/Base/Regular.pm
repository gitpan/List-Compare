package List::Compare::Base::Regular;
$VERSION = 0.27;
# As of:  April 18, 2004 
# functions used in List::Compare regular mode
use strict;
use Carp;
use List::Compare::Base::_Auxiliary qw( _chart_engine_regular );

sub get_intersection {
    return @{ get_intersection_ref(shift) };
}

sub get_intersection_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'intersection'};
}

sub get_union {
    return @{ get_union_ref(shift) };
}

sub get_union_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'union'};
}

sub get_shared {
    my $class = shift;
    my $method = (caller(0))[3];
    carp "When comparing only 2 lists, $method defaults to \n  ", 'get_union()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_union($class);
}

sub get_shared_ref {
    my $class = shift;
    my $method = (caller(0))[3];
    carp "When comparing only 2 lists, $method defaults to \n  ", 'get_union_ref()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_union_ref($class);
}

sub get_unique {
    return @{ get_unique_ref(shift) };
}

sub get_unique_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'unique'};
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
    return $data{'complement'};
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
    return $data{'symmetric_difference'};
}

*get_symdiff  = \&get_symmetric_difference;
*get_LorRonly = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;
*get_symdiff_ref  = \&get_symmetric_difference_ref;
*get_LorRonly_ref = \&get_symmetric_difference_ref;
*get_AorBonly_ref = \&get_symmetric_difference_ref;

sub get_nonintersection {
    my $class = shift;
    my $method = (caller(0))[3];
    carp "When comparing only 2 lists, $method defaults to \n  ", 'get_symmetric_difference()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_symmetric_difference($class);
}

sub get_nonintersection_ref {
    my $class = shift;
    my $method = (caller(0))[3];
    carp "When comparing only 2 lists, $method defaults to \n  ", 'get_symmetric_difference_ref()', ".  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    get_symmetric_difference_ref($class);
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

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
    my ($arg, @found);
    $arg = shift;
    if (exists ${$data{'seenL'}}{$arg}) { push @found, 0; }
    if (exists ${$data{'seenR'}}{$arg}) { push @found, 1; }
    if ( (! exists ${$data{'seenL'}}{$arg}) &&
         (! exists ${$data{'seenR'}}{$arg}) )
       { @found = (); }
    return \@found;
}    

sub are_members_which {
    my $class = shift;
    croak "Method call requires exactly 1 argument which must be an anonymous array\n    holding the items to be tested:  $!"
        unless (@_ == 1 and ref($_[0]) eq 'ARRAY');
    my %data = %$class;
    my (@args, %found);
    @args = @{$_[0]};
    for (my $i=0; $i<=$#args; $i++) {
        if (exists ${$data{'seenL'}}{$args[$i]}) { push @{$found{$args[$i]}}, 0; }
        if (exists ${$data{'seenR'}}{$args[$i]}) { push @{$found{$args[$i]}}, 1; }
        if ( (! exists ${$data{'seenL'}}{$args[$i]}) &&
             (! exists ${$data{'seenR'}}{$args[$i]}) )
           { @{$found{$args[$i]}} = (); }
    }
    return \%found;
}    

sub is_member_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
    my $arg = shift;
    ( defined $data{'seenL'}{$arg} ) ||
    ( defined $data{'seenR'}{$arg} ) ? return 1 : return 0;
}    

sub are_members_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument which must be an anonymous array\n    holding the items to be tested:  $!"
        unless (@_ == 1 and ref($_[0]) eq 'ARRAY');
    my %data = %$class;
    my (@args, %present);
    @args = @{$_[0]};
    for (my $i=0; $i<=$#args; $i++) {
    $present{$args[$i]} = ( defined $data{'seenL'}{$args[$i]} ) ||
                              ( defined $data{'seenR'}{$args[$i]} ) ? 1 : 0;
    }
    return \%present;
}    

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
    my @subset_array = ($data{'LsubsetR_status'}, $data{'RsubsetL_status'});
    my $title = 'Subset';
    _chart_engine_regular(\@subset_array, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my @equivalent_array = ($data{'LequivalentR_status'}, 
                            $data{'LequivalentR_status'});
    my $title = 'Equivalence';
    _chart_engine_regular(\@equivalent_array, $title);
}

1;


