package List::Compare::Functional;
$VERSION = 0.25;   # April 4, 2004 
@ISA = qw(Exporter);
@EXPORT_OK = qw|
    get_intersection
    get_intersection_ref
    get_union
    get_union_ref
    get_unique
    get_unique_ref
    get_complement
    get_complement_ref
    get_symmetric_difference
    get_symmetric_difference_ref
    is_LsubsetR
    is_RsubsetL
    is_member_which
    is_member_which_ref
    are_members_which
    is_member_any
    are_members_any
    print_subset_chart
    is_LequivalentR
    print_equivalence_chart
    get_shared
    get_shared_ref
    get_nonintersection
    get_nonintersection_ref
    get_symdiff
    get_symdiff_ref
    is_LeqvlntR
    get_bag
    get_bag_ref
|;
%EXPORT_TAGS = (
    main => [ qw(
        get_intersection
        get_union
        get_unique
        get_complement
        get_symmetric_difference
        is_LsubsetR
    ) ],
    mainrefs => [ qw(
        get_intersection_ref
        get_union_ref
        get_unique_ref
        get_complement_ref
        get_symmetric_difference_ref
    ) ],
    originals => [ qw(
        get_intersection
        get_intersection_ref
        get_union
        get_union_ref
        get_unique
        get_unique_ref
        get_complement
        get_complement_ref
        get_symmetric_difference
        get_symmetric_difference_ref
        get_shared
        get_shared_ref
        get_nonintersection
        get_nonintersection_ref
        is_LsubsetR
        is_RsubsetL
        is_member_which
        is_member_which_ref
        are_members_which
        is_member_any
        are_members_any
        print_subset_chart
        is_LequivalentR
        print_equivalence_chart
        get_bag
        get_bag_ref
    ) ],
    aliases => [ qw(
        get_symdiff
        get_symdiff_ref
        is_LeqvlntR
    ) ],
);
use strict;
use Carp;
use List::Compare::Base::_Auxiliary qw(
    _validate_seen_hash
    _validate_multiple_seenhashes
    _subset_subengine
    _chart_engine
    _equivalent_subengine
);
use List::Compare::Base::_Auxiliary qw(:calculate);
use Data::Dumper;

sub get_union {
    return @{ get_union_ref(@_) };
}

sub get_union_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _union_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_union_engine(_argument_checker(@args))} ];
}

sub _union_engine {
    my $seenrefsref = _calc_seen1(@_);
    my $unionhashref = _calculate_union_only($seenrefsref);
    return [ keys %{$unionhashref} ];
}

sub get_intersection {
    return @{ get_intersection_ref(@_) };
}

sub get_intersection_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _intersection_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_intersection_engine(_argument_checker(@args))} ];
}

sub _intersection_engine {
    my $seenrefsref = _calc_seen1(@_);
    my $xintersectionref = _calculate_xintersection_only($seenrefsref);
    my $intersectionref = _calculate_hash_intersection($xintersectionref);
    return [ keys %{$intersectionref} ];
}

sub get_unique {
    return @{ get_unique_ref(@_) };
}

sub get_unique_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _unique_engine(_argument_checker_3(@args[1..$#args]))
        : return [ sort @{_unique_engine(_argument_checker_3(@args))} ];
}

sub _unique_engine {
    my $tested = pop(@_);
    my $seenrefsref = _calc_seen1(@_);
    my ($seenref, $xintersectionref) = 
        _calculate_seen_xintersection_only($seenrefsref);
    my %seen = %{$seenref};
    my %xintersection = %{$xintersectionref};

    # Calculate %xunique
    my (%xunique);
    for (my $i = 0; $i <= $#{$seenrefsref}; $i++) {
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
    return [ @{$xunique{$tested}} ];
}

sub get_complement {
    return @{ get_complement_ref(@_) };
}

sub get_complement_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _complement_engine(_argument_checker_3(@args[1..$#args]))
        : return [ sort @{_complement_engine(_argument_checker_3(@args))} ];
}

sub _complement_engine {
    my $tested = pop(@_);
    my $seenrefsref = _calc_seen1(@_);
    my ($unionref, $seenref) = _calculate_union_seen_only($seenrefsref);
    my %seen = %{$seenref};
    my @union = keys %{$unionref};

    # Calculate %xcomplement
    # Inputs:  $seenrefsref @union %seen
    my (%xcomplement);
    for (my $i = 0; $i <= $#{$seenrefsref}; $i++) {
        my %seenthis = %{$seen{$i}};
        my @complementthis = ();
        foreach (@union) {
            push(@complementthis, $_) unless (exists $seenthis{$_});
        }
        $xcomplement{$i} = \@complementthis;
    }
    return [ @{$xcomplement{$tested}} ];
}

sub get_symmetric_difference {
    return @{ get_symmetric_difference_ref(@_) };
}

sub get_symmetric_difference_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _symmetric_difference_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_symmetric_difference_engine(_argument_checker(@args))} ];
}

*get_symdiff  = \&get_symmetric_difference;
*get_symdiff_ref  = \&get_symmetric_difference_ref;

sub _symmetric_difference_engine {
    my $seenrefsref = _calc_seen1(@_);
    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($seenrefsref);
    my @union = keys %{$unionref};

    my $sharedref = _calculate_hash_shared($xintersectionref);
    my (@symmetric_difference);
    foreach (@union) {
        push(@symmetric_difference, $_) unless exists ${$sharedref}{$_};
    }
    return \@symmetric_difference;
}

sub get_shared {
    return @{ get_shared_ref(@_) };
}

sub get_shared_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _shared_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_shared_engine(_argument_checker(@args))} ];
}

sub _shared_engine {
    my $seenrefsref = _calc_seen1(@_);
    # Calculate @shared
    # Inputs:  %xintersection
    my $xintersectionref = _calculate_xintersection_only($seenrefsref);
    my $sharedref = _calculate_hash_shared($xintersectionref);
    my @shared = keys %{$sharedref};
    return \@shared;
}

sub get_nonintersection {
    return @{ get_nonintersection_ref(@_) };
}

sub get_nonintersection_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _nonintersection_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_nonintersection_engine(_argument_checker(@args))} ];
}

sub _nonintersection_engine {
    my $seenrefsref = _calc_seen1(@_);
    my ($unionref, $xintersectionref) = 
        _calculate_union_xintersection_only($seenrefsref);
    my @union = keys %{$unionref};
    my $intersectionref = _calculate_hash_intersection($xintersectionref);
    # Calculate nonintersection
    # Inputs:  @union    %intersection
    my (@nonintersection);
    foreach (@union) {
        push(@nonintersection, $_) unless exists ${$intersectionref}{$_};
    }
    return \@nonintersection;
}

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    return _is_member_which_engine(_argument_checker_1(@_));
}    

sub _is_member_which_engine {
    my $arg = pop(@_);
    my $seenrefsref = _calc_seen1(@_);
    my $seenref = _calculate_seen_only($seenrefsref);
    my (@found);
    foreach (sort keys %{$seenref}) {
        push @found, $_ if (exists ${$seenref}{$_}{$arg});
    }
    return \@found;
}

sub is_member_any {
    return _is_member_any_engine(_argument_checker_1(@_));
}    

sub _is_member_any_engine {
    my $tested = pop(@_);
    my $seenrefsref = _calc_seen1(@_);
    my $seenref = _calculate_seen_only($seenrefsref);
    my ($k);
    while ( $k = each %{$seenref} ) {
        return 1 if (defined ${$seenref}{$k}{$tested});
    }
    return 0;
}

sub are_members_which {
    return _are_members_which_engine(_argument_checker_2(@_));
}

sub _are_members_which_engine {
    my $testedref = pop(@_);
    my @tested = @{$testedref};
    my $seenrefsref = _calc_seen1(@_);
    my $seenref = _calculate_seen_only($seenrefsref);
    my (%found);
    for (my $i=0; $i<=$#tested; $i++) {
        my (@not_found);
        foreach (sort keys %{$seenref}) {
            exists ${${$seenref}{$_}}{$tested[$i]}
                ? push @{$found{$tested[$i]}}, $_
                : push @not_found, $_;
        }
        $found{$tested[$i]} = [] if (@not_found == keys %{$seenref});
    }
    return \%found;
}

sub are_members_any {
    return _are_members_any_engine(_argument_checker_2(@_));
}    

sub _are_members_any_engine {
    my $testedref = pop(@_);
    my @tested = @{$testedref};
    my $seenrefsref = _calc_seen1(@_);
    my $seenref = _calculate_seen_only($seenrefsref);
    my (%present);
    for (my $i=0; $i<=$#tested; $i++) {
        foreach (keys %{$seenref}) {
            unless (defined $present{$tested[$i]}) {
                $present{$tested[$i]} = 1 if ${$seenref}{$_}{$tested[$i]};
            }
        }
        $present{$tested[$i]} = 0 if (! defined $present{$tested[$i]});
    }
    return \%present;
}

sub is_LsubsetR {
    return _is_LsubsetR_engine(_argument_checker_4(@_));
}

sub _is_LsubsetR_engine {
    my $testedref = pop(@_);
    my $xsubsetref = _subset_engine(@_);
    return ${$xsubsetref}[${$testedref}[0]][${$testedref}[1]];
}

sub is_RsubsetL {
    return _is_RsubsetL_engine(_argument_checker_4(@_));
}

sub _is_RsubsetL_engine {
    my $testedref = pop(@_);
    my $xsubsetref = _subset_engine(@_);
    return ${$xsubsetref}[${$testedref}[1]][${$testedref}[0]];
}

sub _subset_engine {
    my $seenrefsref = _calc_seen1(@_);
    my $xsubsetref = _subset_subengine($seenrefsref);
    return $xsubsetref;
}

sub print_subset_chart {
    _print_subset_chart_engine(_argument_checker(@_));
}

sub _print_subset_chart_engine {
    my $seenrefsref = _calc_seen1(@_);
    my $xsubsetref = _subset_subengine($seenrefsref);
    my $title = 'Subset';
    _chart_engine($xsubsetref, $title);
}

sub is_LequivalentR {
    return _is_LequivalentR_engine(_argument_checker_4(@_));
}

*is_LeqvlntR = \&is_LequivalentR;

sub _is_LequivalentR_engine {
    my $testedref = pop(@_);
    my $seenrefsref = _calc_seen1(@_);
    my $xequivalentref = _equivalent_subengine($seenrefsref);
    return ${$xequivalentref}[${$testedref}[1]][${$testedref}[0]];
}

sub print_equivalence_chart {
    _print_equivalence_chart_engine(_argument_checker(@_));
}

sub _print_equivalence_chart_engine {
    my $seenrefsref = _calc_seen1(@_);
    my $xequivalentref = _equivalent_subengine($seenrefsref);
    my $title = 'Subset';
    _chart_engine($xequivalentref, $title);
}    

sub get_bag {
    return @{ get_bag_ref(@_) };
}

sub get_bag_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _bag_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_bag_engine(_argument_checker(@args))} ];
}

sub _bag_engine {
    my @listrefs = @_;
    my (@bag);
    if (ref($listrefs[0]) eq 'ARRAY') { 
        foreach my $lref (@listrefs) {
            foreach my $el (@{$lref}) {
                push(@bag, $el);
            }
        }
    } elsif (ref($listrefs[0]) eq 'HASH') {
        foreach my $lref (@listrefs) {
            foreach my $key (keys %{$lref}) {
                for (my $j=1; $j <= ${$lref}{$key}; $j++) {
                    push(@bag, $key);
                }
            }
        }
    } else {
        croak "Indeterminate case in _bag_engine: $!";
    }
    return \@bag;
}

######################### INTERNAL SUBROUTINES #########################

sub _argument_checker {
    my $argref = shift;
    my @args = @{$argref};
    my $first_ref = ref($args[0]);
    die "Improper argument: $!" 
        unless ($first_ref eq 'ARRAY' or $first_ref eq 'HASH');
    my @temp = @args[1..$#args];
    my ($testing);
    my $condition = 1;
    while (defined ($testing = shift(@temp)) ) {
        unless (ref($testing) eq $first_ref) {
            $condition = 0;
            last;
        }
    }
    croak "Arguments must be either all array references or all hash references: $!"
        unless $condition;
    _validate_seen_hash(@args) if $first_ref eq 'HASH';
    return (@args);
}

sub _argument_checker_1 {
    my @argrefs = @_;
    croak "Subroutine call requires 2 references as arguments:  $!"
        unless @argrefs == 2;
    return (_argument_checker($argrefs[0]), ${$argrefs[1]}[0]);
}

sub _argument_checker_2 {
    my @argrefs = @_;
    croak "Subroutine call requires 2 references as arguments:  $!"
        unless @argrefs == 2;
    return (_argument_checker($argrefs[0]), $argrefs[1]);
}

sub _argument_checker_3 {
    my @argrefs = @_;
    if (@argrefs == 1) {
        return (_argument_checker($argrefs[0]), 0);
    } elsif (@argrefs == 2) {
        return (_argument_checker($argrefs[0]), ${$argrefs[1]}[0]);
    } else {
        croak "Subroutine call requires 1 or 2 references as arguments:  $!"
            unless (@argrefs == 1 or @argrefs == 2);
    }
}

sub _argument_checker_4 {
    my @argrefs = @_;
    if (@argrefs == 1) {
        return (_argument_checker($argrefs[0]), [0,1]);
    } elsif (@argrefs == 2) {
        return (_argument_checker($argrefs[0]), $argrefs[1]); 
    } else {
        croak "Subroutine call requires 1 or 2 references as arguments:  $!"
            unless (@argrefs == 1 or @argrefs == 2);
    }
}

sub _calc_seen1 {
    my @listrefs = @_;
    # _calc_seen1() is applied after _argument_checker(), which checks to make
    # sure that the references in its output are either all arrayrefs 
    # or all seenhashrefs
    # hence, _calc_seen1 only needs to determine whether it's dealing with 
    # arrayrefs or seenhashrefs, then, if arrayrefs, calculate seenhashes
    if (ref($listrefs[0]) eq 'HASH') {
        return \@listrefs;
    } elsif (ref($listrefs[0]) eq 'ARRAY') {
        my (@seenrefs);
        foreach my $aref (@listrefs) {
            my (%seenthis);
            foreach my $j (@{$aref}) {
                $seenthis{$j}++;
            }
            push(@seenrefs, \%seenthis);
        }
        return \@seenrefs;
    } else {
        croak "Indeterminate case in _calc_seen1: $!";
    }
}


1;

__END__

=head1 NAME

List::Compare::Functional - Compare elements of two or more lists

=head1 VERSION

This document refers to version 0.25 of List::Compare::Functional.  
This version was released April 4, 2004.  The first released 
version of List::Compare::Functional was v0.21.  Its version numbers 
are set to be consistent with the other parts of the List::Compare 
distribution.

=head2 Notice of Interface Changes

Certain significant changes to the interface to List::Compare::Functional 
were made with the introduction of Version 0.25 in April 2004.  The 
documentation immediately below reflects those changes, so if you are 
first using this module with that or a later version, simply read and 
follow the documentation below.  If, however, you used List::Compare::Functional 
prior to that version, see the discussion of interface changes farther 
below: April 2004 Change of Interface.

=head1 SYNOPSIS

=head2 Getting Started

List::Compare::Functional exports no subroutines by default.

    use List::Compare::Functional qw(:originals :aliases);

will import all publicly available subroutines from 
List::Compare::Functional.  The model for importing just one subroutine from 
List::Compare::Functional is:

    use List::Compare::Functional qw( get_intersection );

It will probably be most convenient for the user to import functions by 
using one of the two following export tags:

    use List::Compare::Functional qw(:main :mainrefs);

The assignment of the various comparison functions to export tags is 
discussed below.

For clarity, we shall begin by discussing comparisons of just two lists at 
a time.  Farther below, we shall discuss comparisons among three or more 
lists at a time.

=head2 Comparing Two Lists Held in Arrays

=over 4

=item *

Given two lists:

    @Llist = qw(abel abel baker camera delta edward fargo golfer);
    @Rlist = qw(baker camera delta delta edward fargo golfer hilton);

=item *

Get those items which appear at least once in both lists (their intersection).

    @intersection = get_intersection( [ \@Llist, \@Rlist ] );

=item *

Get those items which appear at least once in either list (their union).

    @union = get_union( [ \@Llist, \@Rlist ] );

=item *

Get those items which appear (at least once) only in the first list.

    @Lonly = get_unique( [ \@Llist, \@Rlist ] );

=item *

Get those items which appear (at least once) only in the second list.

    @Ronly = get_complement( [ \@Llist, \@Rlist ] );

=item *

    @LorRonly = get_symmetric_difference( [ \@Llist, \@Rlist ] );
    @LorRonly = get_symdiff( [ \@Llist, \@Rlist ] );       # alias

=item *

Make a bag of all those items in both lists.  The bag differs from the 
union of the two lists in that it holds as many copies of individual 
elements as appear in the original lists.

    @bag = get_bag( [ \@Llist, \@Rlist ] );

=item *

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref = get_intersection_ref( [ \@Llist, \@Rlist ] );
    $union_ref        = get_union_ref( [ \@Llist, \@Rlist ] );
    $Lonly_ref        = get_unique_ref( [ \@Llist, \@Rlist ] );
    $Ronly_ref        = get_complement_ref( [ \@Llist, \@Rlist ] );
    $LorRonly_ref     = get_symmetric_difference_ref( [ \@Llist, \@Rlist ] );
    $LorRonly_ref     = get_symdiff_ref( [ \@Llist, \@Rlist ] );  # alias
    $bag_ref          = get_bag_ref( [ \@Llist, \@Rlist ] );

=item *

Return a true value if L is a subset of R.

    $LR = is_LsubsetR( [ \@Llist, \@Rlist ] );

Return a true value if R is a subset of L.

    $RL = is_RsubsetL( [ \@Llist, \@Rlist ] );

=item *

Return a true value if L and R are equivalent, I<i.e.> if every element 
in L appears at least once in R and I<vice versa>.

    $eqv = is_LequivalentR( [ \@Llist, \@Rlist ] );
    $eqv = is_LeqvlntR( [ \@Llist, \@Rlist ] );            # alias

=item *

Pretty-print a chart showing whether one list is a subset of the other.

    print_subset_chart( [ \@Llist, \@Rlist ] );

=item *

Pretty-print a chart showing whether the two lists are equivalent (same 
elements found at least once in both).

    print_equivalence_chart( [ \@Llist, \@Rlist ] );

=item *

Determine in I<which> (if any) of the lists a given string can be found.  
In list context, return a list of those indices in the argument list 
corresponding to lists holding the string being tested.

    @memb_arr = is_member_which( [ \@Llist, \@Rlist ] , [ 'abel' ] );

In the example above, C<@memb_arr> will be:

    ( 0 )

because C<'abel'> is found only in C<@Al> which holds position C<0> in the 
list of arguments passed to C<new()>.

=item *

As with other List::Compare methods which return a list, you may wish the 
above method returned a (scalar) reference to an array holding the list:

    $memb_arr_ref = is_member_which_ref( [ \@Llist, \@Rlist ] , [ 'baker' ] );

In the example above, C<$memb_arr_ref> will be:

    [ 0, 1 ]

because C<'baker'> is found in C<@Llist> and C<@Rlist>, which hold positions 
C<0> and C<1>, respectively, in the list of arguments passed to C<new()>.

B<Note:>  methods C<is_member_which()> and C<is_member_which_ref> test
only one string at a time and hence take only one argument.  To test more 
than one string at a time see the next method, C<are_members_which()>.

=item *

Determine in C<which> (if any) of the lists one or more given strings can be 
found.  Get a reference to a hash of arrays.  The key for each element in 
this hash is the string being tested.  Each element's value is a reference 
to an anonymous array whose elements are those indices in the argument list 
corresponding to lists holding the strings being tested.
The strings to be tested are placed in an anonymous array, a 
reference to which is passed to the method.

    $memb_hash_ref = 
        are_members_which( [ \@Llist, \@Rlist ] , 
            [ qw| abel baker fargo hilton zebra | ]);

In the two examples above, C<$memb_hash_ref> will be:

    {
         abel     => [ 0    ],
         baker    => [ 0, 1 ],
         fargo    => [ 0, 1 ],
         hilton   => [    1 ],
         zebra    => [      ],
    };

B<Note:>  C<are_members_which()> can take more than one argument; 
C<is_member_which()> and C<is_member_which_ref()> each take only one argument.  
C<are_members_which()> returns a hash reference; the other methods return 
either a list or a reference to an array holding that list, depending on 
context.

=item *

Determine whether a given string can be found in I<any> of the lists passed as 
arguments.  Return 1 if a specified string can be found in I<any> of the lists 
and 0 if not.

    $found = is_member_any( [ \@Llist, \@Rlist ] , [ 'abel' ] );

In the example above, C<$found> will be C<1> because C<'abel'> is found in one 
or more of the lists passed as arguments to C<new()>.

=item *

Determine whether a specified string or strings can be found in I<any> of the 
lists passed as arguments.  Get a reference to a hash where 
an element's key is the string being tested and the element's value is 1 if 
the string can be found in C<any> of the lists and 0 if not.  The strings to 
be tested are placed in an anonymous array, a reference to which is passed to 
the method.

    $memb_hash_ref = are_members_any( [ \@Llist, \@Rlist ] , 
        [ qw| abel baker fargo hilton zebra | ]);

In the two examples above, C<$memb_hash_ref> will be:

    {
         abel     => 1,
         baker    => 1,
         fargo    => 1,
         hilton   => 1,
         zebra    => 0,
    };

because, I<e.g.,> C<'zebra'> is not found in either of the lists passed as 
arguments to C<new()>.

=item *

Return current List::Compare::Functional version number.

    $vers = get_version;

=back

=head2 Comparing Two Lists Held in Seen-Hashes

What is a seen-hash?  A seen-hash is a hash where the value for a given 
element represents the number 
of times the element's key is observed in a list.  For the purposes of 
List::Compare::Functional, what is crucial is whether an item is observed in a 
list or not; how many times the item occurs in a list is, I<with one exception,> 
irrelevant.  (That exception is the C<get_bag()> function and its fraternal 
twin C<get_bag_ref()>.  In this case only, the key in each element of the 
seen-hash is placed in the bag the number of times indicated by the value of 
that element.)  The value of an element in a List::Compare seen-hash must be 
a positive integer, but whether that integer is 1 or 1,000,001 is immaterial for 
all List::Compare::Functional functions I<except> forming a bag.

The two lists compared above were represented by arrays; references to 
those arrays were passed to the various List::Compare::Functional functions.
They could, however, have been represented by seen-hashes such as the following 
and passed in exactly the same manner to the various functions.

    %Llist = (
        abel   => 2,
        baker  => 1, 
        camera => 1,
        delta  => 1,
        edward => 1,
        fargo  => 1,
        golfer => 1,
    );
    %Rlist = (
        baker  => 1,
        camera => 1,
        delta  => 2,
        edward => 1,
        fargo  => 1,
        golfer => 1,
        hilton => 1,
    );

    @intersection = get_intersection( [ \%Llist, \%Rlist ] );
    @union        = get_union( [ \%Llist, \%Rlist ] );
    @complement   = get_complement( [ \%Llist, \%Rlist ] );

and so forth.

=head2 Faster Results with the Unsorted Option

By default, List::Compare::Function functions return lists sorted in Perl's 
default ASCII-betical mode.  Sorting entails a performance cost, and if you 
do not need a sorted list and do not wish to pay this performance cost, you 
may call the following List::Compare::Function functions with the 'unsorted' 
option:

    @intersection = get_intersection('-u',  [ \@Llist, \@Rlist ] );
    @union = get_union('-u',  [ \@Llist, \@Rlist ] );
    @Lonly = get_unique('-u',  [ \@Llist, \@Rlist ] );
    @Ronly = get_complement('-u',  [ \@Llist, \@Rlist ] );
    @LorRonly = get_symmetric_difference('-u',  [ \@Llist, \@Rlist ] );
    @bag = get_bag('-u',  [ \@Llist, \@Rlist ] );

For greater readability, the option may be spelled out:

    @intersection = get_intersection('--unsorted',  [ \@Llist, \@Rlist ] );

Should you need a reference to an unsorted list as the return value, you 
may call the unsorted option as follows:

    $intersection_ref = get_intersection_ref('-u',  [ \@Llist, \@Rlist ] );
    $intersection_ref = get_intersection_ref('--unsorted',  [ \@Llist, \@Rlist ] );

=head2 Comparing Three or More Lists Held in Arrays

Given five lists:

    @Al     = qw(abel abel baker camera delta edward fargo golfer);
    @Bob    = qw(baker camera delta delta edward fargo golfer hilton);
    @Carmen = qw(fargo golfer hilton icon icon jerky kappa);
    @Don    = qw(fargo icon jerky);
    @Ed     = qw(fargo icon icon jerky);

=over 4

=item *

Get those items which appear at least once in I<each> list (their intersection).

    @intersection = get_intersection( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

Get those items which appear at least once in I<any> of the lists (their union).

    @union = get_union( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

To get those items which are unique to a particular list, pass two array 
references to the C<get_unique()> function:  the first holding references 
to the arrays holding the individual lists being compared; the second holding 
the index position in the first reference of the particular list under 
consideration.  Example:  To get elements unique to C<@Carmen>:  

    @Lonly = get_unique(
                 [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], 
                 [ 2 ]
             );

If no index position is passed to C<get_unique()> it will default to 0 
and report items unique to the first list passed to the function.  Hence,

    @Lonly = get_unique( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

is same as:

    @Lonly = get_unique( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [ 0 ] );

=item *

To get those items which appear only in lists I<other than> one particular 
list, pass two array references to the C<get_complement()>  function:  
the first holding references to the arrays holding the individual lists 
being compared; the second holding the index position in the first reference 
of the particular list under consideration.  Example:  to get all the 
elements found in lists I<other than> C<@Don>:  

    @Ronly = get_complement(
                 [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                 [ 3 ]
             );

If no index position is passed to C<get_complement()> it will default to 0 
and report items found in all lists I<other than> the first list passed to 
C<get_complement()>.

    @Lonly = get_complement( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

is same as:

    @Lonly = get_complement( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [ 0 ] );

=item *

Get those items which do not appear in more than one of several lists 
(their symmetric_difference);

    @LorRonly = get_symmetric_difference( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    @LorRonly = get_symdiff( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] ); # alias

=item *

Get those items found in any of several lists which do not appear in all 
of the lists (I<i.e.,> all items except those found in the intersection 
of the lists):

    @nonintersection = get_nonintersection(
                           [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

Get those items which appear in I<more than one> of several lists 
(I<i.e.,> all items except those found in their symmetric difference);

    @shared = get_shared( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

If you only need a reference to an array as a return value rather than a 
full array, use the following alternative methods:


=item *

Make a bag of every item found in every list.  The bag differs from the 
union of the two lists in that it holds as many copies of individual 
elements as appear in the original lists.

    @bag = get_bag( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref    = get_intersection_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $union_ref           = get_union_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $Lonly_ref           = get_unique_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $Ronly_ref           = get_complement_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $LorRonly_ref        = get_symmetric_difference_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $LorRonly_ref        = get_symdiff_ref(            # alias
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $nonintersection_ref = get_nonintersection_ref(
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $shared_ref          = get_shared_ref(
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );
    $bag_ref             = get_bag_ref( 
                             [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

To determine whether one particular list is a subset of another of the 
lists passed to the function, pass to C<is_LsubsetR()> two array references. 
The first of these references is a reference to an array of array 
references, the arrays holding the lists under consideration.  The 
second of these is a reference to a two-element array consisting of the 
index of the presumed subset, followed by the index position of the presumed 
superset.  A true value (1) is returned if the first (left-hand) element 
in the second reference list is a subset of the second (right-hand) element; 
a false value (0) is returned otherwise.  Example:  To determine whether 
C<@Ed> is a subset of C<@Carmen>, call:

    $LR = is_LsubsetR([ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [4,2] );

If only the first array reference (to the array of lists) is passed to 
C<is_LsubsetR>, then the function's second argument defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.  So,

    $LR = is_LsubsetR([ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

... is equivalent to:

    $LR = is_LsubsetR([ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [0,1] );

=item *

To reverse the order in which the particular lists are evaluated for 
superset/subset status, call C<is_RsubsetL>:

    $LR = is_RsubsetL([ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [2,4] );

=item *

List::Compare::Functional considers two lists to be equivalent if 
every element in one list appears at least once in R and I<vice versa>.  
To determine whether one particular list passed to the function is 
equivalent to another of the lists passed to the function, pass to 
C<is_LequivalentR()> two array references. 
The first of these references is a reference to an array of array 
references, the arrays holding the lists under consideration.  The 
second of these is a reference to a two-element array consisting of the 
two lists being tested for equivalence.  A true value (1) is returned if 
the lists are equivalent; a false value (0) is returned otherwise.  
Example:  To determine whether C<@Don> and C<@Ed> are equivalent, call:

    $eqv = is_LequivalentR( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [3,4] );
    $eqv = is_LeqvlntR( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [3,4] );
                # alias

If no arguments are passed, C<is_LequivalentR> defaults to C<[0,1]> and 
compares the first two lists passed to the function. So,

    $eqv = is_LequivalentR( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

... translates to:

    $eqv = is_LequivalentR( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ], [0,1] );

=item *

Pretty-print a chart showing the subset relationships among the various 
source lists:

    print_subset_chart( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

Pretty-print a chart showing the equivalence relationships among the 
various source lists:

    print_equivalence_chart( [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ] );

=item *

Determine in I<which> (if any) of several lists a given string can be found.  
Pass two array references, the first of which holds references to arrays 
holding the lists under consideration, and the second of which holds a 
single-item list consisting of the string being tested.  In list context, 
return a list of those indices in the function's argument list corresponding 
to lists holding the string being tested.

    @memb_arr = is_member_which( 
                    [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                    [ 'abel' ]
                );

In the example above, C<@memb_arr> will be:

    ( 0 )

because C<'abel'> is found only in C<@Al> which holds position C<0> in the 
list of arguments passed to C<is_member_which()>.

=item *

As with other List::Compare::Functional methods which return a list, you may 
wish the above method returned a reference to an array holding the list:

    $memb_arr_ref = is_member_which_ref(
                        [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                        [ 'jerky' ]
                    );

In the example above, C<$memb_arr_ref> will be:

    [ 3, 4 ]

because C<'jerky'> is found in C<@Don> and C<@Ed>, which hold positions 
C<3> and C<4>, respectively, in the list of arguments passed to 
C<is_member_which()>.

B<Note:>  methods C<is_member_which()> and C<is_member_which_ref> test
only one string at a time and hence take only one element in the second 
array reference argument.  To test more than one string at a time see 
the next method, C<are_members_which()>.

=item *

Determine in C<which> (if any) of several lists one or more given strings 
can be found.  Pass two array references, the first of which holds references 
to arrays holding the lists under consideration, and the second of which 
holds a list of the strings being tested. Return a reference to a hash of 
arrays.  In this hash, each element's value is a reference to an anonymous 
array whose elements are those indices in the argument list corresponding 
to lists holding the strings being tested.

    $memb_hash_ref = are_members_which(
                         [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                         [ qw| abel baker fargo hilton zebra | ]
                     );

In the two examples above, C<$memb_hash_ref> will be:

    {
         abel     => [ 0             ],
         baker    => [ 0, 1          ],
         fargo    => [ 0, 1, 2, 3, 4 ],
         hilton   => [    1, 2       ],
         zebra    => [               ],
    };

B<Note:>  C<are_members_which()> tests more than one string at a time.  Hence, 
its second array reference argument can take more than one element.
C<is_member_which()> and C<is_member_which_ref()> each take only one element 
in their second array reference arguments.  C<are_members_which()> returns a 
hash reference; the other methods return either a list or a reference to an 
array holding that list, depending on context.

=item *

Determine whether a given string can be found in I<any> of several lists.  
Pass two array references, the first of which holds references 
to arrays holding the lists under consideration, and the second of which 
holds a single-item list of the string being tested.  Return 1 if a 
specified string can be found in I<any> of the lists and 0 if not.

    $found = is_member_any(
                    [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                    [ 'abel' ]
                );

In the example above, C<$found> will be C<1> because C<'abel'> is found in one 
or more of the lists passed as arguments to C<is_member_any()>.

=item *

Determine whether a specified string or strings can be found in I<any> of
several lists.  Pass two array references, the first of which holds references 
to arrays holding the lists under consideration, and the second of which 
holds a list of the strings being tested.  Return a reference to a hash where 
an element's key is the string being tested and the element's value is 1 if 
the string can be found in C<any> of the lists and 0 if not.

    $memb_hash_ref = are_members_any(
                         [ \@Al, \@Bob, \@Carmen, \@Don, \@Ed ],
                         [ qw| abel baker fargo hilton zebra | ]
                     );

In the example above, C<$memb_hash_ref> will be:

    {
         abel     => 1,
         baker    => 1,
         fargo    => 1,
         hilton   => 1,
         zebra    => 0,
    };

because, I<e.g.,> C<'zebra'> is not found in any of the lists passed as 
arguments to C<are_members_any()>.

=item *

Return current List::Compare::Functional version number:

    $vers = get_version;

=back

=head1 DESCRIPTION

=head2 General Comments

List::Compare::Functional is a non-object-oriented implementation of very 
common Perl code  used to
determine interesting relationships between two or more lists at a time.  
List::Compare::Functional is based on the same author's List::Compare and 
List::Compare::SeenHash modules found in the same CPAN distribution.  
List::Compare::Functional is closely modeled on the ''Accelerated'' mode in
List::Compare and List::Compare::SeenHash. Like that Accelerated mode, 
List::Compare::Functional compares only two lists at a time -- it cannot, 
in the current implementation, compare three or more lists simultaneously -- 
and it can only carry out one functional comparison at a time.  If you need 
to compare three or more lists simultaneously, use List::Compare's ''Multiple'' 
mode (or the Multiple mode in List::Compare::SeenHash).  Similarly, if you 
need to compute, say, both the intersection and union of two or more lists, 
use List::Compare's Regular or Multiple modes (or their analogues in 
List::Compare::SeenHash).

For a discussion of the antecedents of this module, see the discussion of the 
history and development of this module in the documentation to List::Compare.

=head2 List::Compare::Functional's Export Tag Groups

By default, List::Compare::Functional exports no functions.  You may import 
individual functions into your main package but may find it more convenient to 
import via export tag groups.  Four such groups are currently defined:

    use List::Compare::Functional qw(:main)
    use List::Compare::Functional qw(:mainrefs)
    use List::Compare::Functional qw(:originals)
    use List::Compare::Functional qw(:aliases)

=over 4

=item *

Tag group C<:main> includes what, in the author's opinion, are the six 
List::Compare::Functional subroutines mostly likely to be used:

    get_intersection()
    get_union()
    get_unique()
    get_complement()
    get_symmetric_difference()
    is_LsubsetR()

=item *

Tag group C<:mainrefs> includes five of the six subroutines found in 
C<:main> -- all except C<is_LsubsetR()> -- in the form in which they 
return references to arrays rather than arrays proper:

    get_intersection_ref()
    get_union_ref()
    get_unique_ref()
    get_complement_ref()
    get_symmetric_difference_ref()

=item *

Tag group C<:originals> includes all List::Compare::Functional subroutines 
in their 'original' form, I<i.e.>, no aliases for those subroutines:

    get_intersection
    get_intersection_ref
    get_union
    get_union_ref
    get_unique
    get_unique_ref
    get_complement
    get_complement_ref
    get_symmetric_difference
    get_symmetric_difference_ref
    get_shared
    get_shared_ref
    get_nonintersection
    get_nonintersection_ref
    is_LsubsetR
    is_RsubsetL
    is_member_which
    is_member_which_ref
    are_members_which
    is_member_any
    are_members_any
    print_subset_chart
    is_LequivalentR
    print_equivalence_chart
    get_bag
    get_bag_ref

=item *

Tag group C<:aliases> contains all List::Compare::Functional subroutines 
which are aliases for subroutines found in tag group C<:originals>.  These 
are provided simply for less typing.

    get_symdiff
    get_symdiff_ref
    is_LeqvlntR

=back

=head2 April 2004 Change of Interface

B<Note:>  You can skip this section unless you used List::Compare::Functional 
prior to the release of Version 0.25 in April 2004.

Version 0.25 initiates a significant change in the interface to 
this module's various functions.  In order to be able to accommodate 
comparisons among more than two lists, changing the type of arguments 
passed to the various functions was necessary.  Whereas previously a 
typical List::Compare::Functional function would be called like this:

    @intersection = get_intersection( \@Llist, \@Rlist );

... now the references to the lists being compared must now be placed 
within a wrapper array (anonymous or named), a reference to which is 
now passed to the function, like so:

    @intersection = get_intersection( [ \@Llist, \@Rlist ] );

... or, alternatively:

    @to_be_compared = (\@Llist, \@Rlist);
    @intersection = get_intersection( \@to_be_compared );

In a similar manner, List::Compare::Functional functions could previously 
take arguments in the form of references to 'seenhashes' instead of 
references to arrays:

    @intersection = get_intersection( \%h0, \%h1 );

(See above for discussion of seenhashes.)  Now, those references to 
seenhashes must be placed within a wrapper array (anonymous or named), 
a reference to which is passed to the function, like so:

    @intersection = get_intersection( [ \%h0, \%h1 ] );

Also, in a similar manner, some List::Compare::Functional functions 
previously took arguments in addition to the lists being compared.  
These arguments were simply passed as scalars, like this:

    @memb_arr = is_member_which(\@Llist, \@Rlist, 'abel');

Now these arguments must also be placed within a wrapper array 
(anonymous or named), a reference to which is now passed to the function, 
like so:

    @memb_arr = is_member_which( [ \@Llist, \@Rlist ], [ 'abel' ] );

... or, alternatively:

    @to_be_compared = (\@Llist, \@Rlist);
    @opts = ( 'abel' );
    @memb_arr = is_member_which( \@to_be_compared, \@opts );

As in previous versions, for a speed boost the user may provide the 
C<'-u'> or C<'--unsorted'> option as the I<first> argument to some 
List::Compare::Functional functions.  Using this option, the 
C<get_intersection()> function above would appear as:

    @intersection = get_intersection( '-u', [ \@Llist, \@Rlist ] );

... or, alternatively:

    @intersection = get_intersection( '--unsorted', [ \@Llist, \@Rlist ] );

The arguments to I<any> List::Compare::Functional function will therefore 
consist possibly of the unsorted option, and then of either one or two 
references to arrays, the first of which is a reference to an array of 
arrays or an array of seenhashes.

=head1 AUTHOR

James E. Keenan (jkeenan@cpan.org).

Creation date:  May 20, 2002.  Last modification date:  April 4, 2004. 
Copyright (c) 2002-4 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 

###### DISCONTINUED FUNCTIONS (v0.25) ######

#    get_Lonly
#    get_Aonly
#    get_Lonly_ref
#    get_Aonly_ref
#    get_Ronly
#    get_Bonly
#    get_Ronly_ref
#    get_Bonly_ref
#    get_LorRonly
#    get_AorBonly
#    get_LorRonly_ref
#    get_AorBonly_ref
#    is_AsubsetB
#    is_BsubsetA

#sub _calc_seen {
#    my ($refL, $refR) = @_;
#    if (ref($refL) eq 'HASH' and ref($refR) eq 'HASH') {
#        return ($refL, $refR);
#    } elsif (ref($refL) eq 'ARRAY' and ref($refR) eq 'ARRAY') {
#        my (%seenL, %seenR);
#        foreach (@$refL) { $seenL{$_}++ }
#        foreach (@$refR) { $seenR{$_}++ }
#        return (\%seenL, \%seenR); 
#    } else {
#        croak "Improper mixing of arguments; accelerated calculation not possible:  $!";
#    }
#}
