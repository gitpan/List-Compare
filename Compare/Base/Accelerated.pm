package List::Compare::Base::Accelerated;
# as of:  October 26, 2003
use strict;
use Carp;
use List::Compare::Base::_Engine qw|
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

sub get_intersection {
    return @{ get_intersection_ref(shift) };
}

sub get_intersection_ref {
    my $class = shift;
    my %data = %$class;
	return _intersection_engine($data{'L'}, $data{'R'});
}

sub get_union {
    return @{ get_union_ref(shift) };
}

sub get_union_ref {
    my $class = shift;
    my %data = %$class;
	return _union_engine($data{'L'}, $data{'R'});
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
	return _unique_engine($data{'L'}, $data{'R'});
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
	return _complement_engine($data{'L'}, $data{'R'});
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
	return _symmetric_difference_engine($data{'L'}, $data{'R'});
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
	return _is_LsubsetR_engine($data{'L'}, $data{'R'});
}

*is_AsubsetB  = \&is_LsubsetR;

sub is_RsubsetL {
    my $class = shift;
    my %data = %$class;
	return _is_RsubsetL_engine($data{'L'}, $data{'R'});
}

*is_BsubsetA  = \&is_RsubsetL;

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
	return _is_member_which_engine($data{'L'}, $data{'R'}, shift);
}    

sub are_members_which {
    my $class = shift;
    croak "Method call needs at least one argument:  $!" unless (@_);
    my %data = %$class;
    my (@args);
    @args = (@_ == 1 and ref($_[0]) eq 'ARRAY') 
        ?  @{$_[0]}
        :  @_;
	return _are_members_which_engine($data{'L'}, $data{'R'}, \@args);
}

sub is_member_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
	return _is_member_any_engine($data{'L'}, $data{'R'}, shift);
}    

sub are_members_any {
    my $class = shift;
    croak "Method call needs at least one argument:  $!" unless (@_);
    my %data = %$class;
    my (@args);
    @args = (@_ == 1 and ref($_[0]) eq 'ARRAY') 
        ?  @{$_[0]}
        :  @_;
	return _are_members_any_engine($data{'L'}, $data{'R'}, \@args);
}    

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
	_print_subset_chart_engine($data{'L'}, $data{'R'});
}

sub is_LequivalentR {
    my $class = shift;
    my %data = %$class;
	return _is_LequivalentR_engine($data{'L'}, $data{'R'});
}

*is_LeqvlntR = \&is_LequivalentR;

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
	_print_equivalence_chart_engine($data{'L'}, $data{'R'});
}

1;



