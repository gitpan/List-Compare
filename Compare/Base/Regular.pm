package List::Compare::Base::Regular;
# As of:  May 22, 2003 

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;

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

__END__

=head1 NAME

List::Compare::Base::Regular

=head1 VERSION

This document refers to List::Compare::Base::Regular as packaged with 
List::Compare version 0.17.  This version was released May 22, 2003.

=head1 DESCRIPTION

List::Compare::Base::Regular is a utility package which holds methods 
shared between the Regular modes of packages F<List::Compare> and 
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



