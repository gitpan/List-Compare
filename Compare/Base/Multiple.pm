package List::Compare::Base::Multiple;
$VERSION = 0.26;
# As of:  April 11, 2004
# functions used in List::Compare multiple mode
use strict;
use Carp;
use List::Compare::Base::_Auxiliary qw(
    _index_message1
    _index_message2
    _chart_engine_multiple
);

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
    return @{ get_shared_ref(shift) };
}

sub get_shared_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'shared'};
}

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
    _index_message1($index, \%data);
    return ${$data{'xunique'}}{$index};
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
    _index_message1($index, \%data);
    my %temp = %{$data{'xcomplement'}};
    return ${$data{'xcomplement'}}{$index};
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

sub get_symmetric_difference {
    return @{ get_symmetric_difference_ref(shift) };
}

sub get_symmetric_difference_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'symmetric_difference'};
}

*get_symdiff  = \&get_symmetric_difference;
*get_symdiff_ref  = \&get_symmetric_difference_ref;

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

sub get_nonintersection {
    return @{ get_nonintersection_ref(shift) };
}

sub get_nonintersection_ref {
    my $class = shift;
    my %data = %$class;
    return $data{'nonintersection'};
}

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

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
    my %seen = %{$data{'seen'}};
    my ($arg, @found);
    $arg = shift;
    foreach (sort keys %seen) {
        push @found, $_ if (exists $seen{$_}{$arg});
    }
    return \@found;
}    

sub are_members_which {
    my $class = shift;
    croak "Method call requires exactly 1 argument which must be an anonymous array\n    holding the items to be tested:  $!"
        unless (@_ == 1 and ref($_[0]) eq 'ARRAY');
    my %data = %$class;
    my %seen = %{$data{'seen'}};
    my (@args, %found);
    @args = @{$_[0]};
    for (my $i=0; $i<=$#args; $i++) {
        my (@not_found);
        foreach (sort keys %seen) {
            exists ${$seen{$_}}{$args[$i]}
                ? push @{$found{$args[$i]}}, $_
                : push @not_found, $_;
        }
        $found{$args[$i]} = [] if (@not_found == keys %seen);
    }
    return \%found;
}    

sub is_member_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument (no references):  $!"
        unless (@_ == 1 and ref($_[0]) ne 'ARRAY');
    my %data = %$class;
    my %seen = %{$data{'seen'}};
    my ($arg, $k);
    $arg = shift;
    while ( $k = each %seen ) {
        return 1 if (defined $seen{$k}{$arg});
    }
    return 0;
}    

sub are_members_any {
    my $class = shift;
    croak "Method call requires exactly 1 argument which must be an anonymous array\n    holding the items to be tested:  $!"
        unless (@_ == 1 and ref($_[0]) eq 'ARRAY');
    my %data = %$class;
    my %seen = %{$data{'seen'}};
    my (@args, %present);
    @args = @{$_[0]};
    for (my $i=0; $i<=$#args; $i++) {
        foreach (keys %seen) {
            unless (defined $present{$args[$i]}) {
                $present{$args[$i]} = 1 if $seen{$_}{$args[$i]};
            }
        }
        $present{$args[$i]} = 0 if (! defined $present{$args[$i]});
    }
    return \%present;
}    

sub print_subset_chart {
    my $class = shift;
    my %data = %$class;
    my @subset_array = @{$data{'xsubset'}};
    my $title = 'subset';
    _chart_engine_multiple(\@subset_array, $title);
}

sub print_equivalence_chart {
    my $class = shift;
    my %data = %$class;
    my @equivalent_array = @{$data{'xequivalent'}};
    my $title = 'Equivalence';
    _chart_engine_multiple(\@equivalent_array, $title);
}

1;



