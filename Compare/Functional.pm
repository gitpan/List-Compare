package List::Compare::Functional;
$VERSION = 0.24;   # March 28, 2004 
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
    get_Lonly
    get_Aonly
    get_Lonly_ref
    get_Aonly_ref
    get_Ronly
    get_Bonly
    get_Ronly_ref
    get_Bonly_ref
    get_symdiff
    get_LorRonly
    get_AorBonly
    get_symdiff_ref
    get_LorRonly_ref
    get_AorBonly_ref
    is_AsubsetB
    is_BsubsetA
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
        get_shared
        get_shared_ref
        get_nonintersection
        get_nonintersection_ref
        get_Lonly
        get_Aonly
        get_Lonly_ref
        get_Aonly_ref
        get_Ronly
        get_Bonly
        get_Ronly_ref
        get_Bonly_ref
        get_symdiff
        get_LorRonly
        get_AorBonly
        get_symdiff_ref
        get_LorRonly_ref
        get_AorBonly_ref
        is_AsubsetB
        is_BsubsetA
        is_LeqvlntR
    ) ],
);
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
    return @{ get_intersection_ref(@_) };
}

sub get_intersection_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _intersection_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_intersection_engine(_argument_checker(@args))} ];
}

sub get_union {
    return @{ get_union_ref(@_) };
}

sub get_union_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _union_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_union_engine(_argument_checker(@args))} ];
}

sub get_shared {
    return @{ get_shared_ref(@_) };
}

sub get_shared_ref {
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing only 2 lists, \&$method defaults to \n  \&get_union_ref.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_union_ref(@_);
}

sub get_unique {
    return @{ get_unique_ref(@_) };
}

sub get_unique_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _unique_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_unique_engine(_argument_checker(@args))} ];
}

*get_Lonly = \&get_unique;
*get_Aonly = \&get_unique;
*get_Lonly_ref = \&get_unique_ref;
*get_Aonly_ref = \&get_unique_ref;

sub get_complement {
    return @{ get_complement_ref(@_) };
}

sub get_complement_ref {
    my @args = @_;
    ($args[0] eq '-u' or $args[0] eq '--unsorted') 
        ? return          _complement_engine(_argument_checker(@args[1..$#args]))
        : return [ sort @{_complement_engine(_argument_checker(@args))} ];
}

*get_Ronly = \&get_complement;
*get_Bonly = \&get_complement;
*get_Ronly_ref = \&get_complement_ref;
*get_Bonly_ref = \&get_complement_ref;

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
*get_LorRonly = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;
*get_symdiff_ref  = \&get_symmetric_difference_ref;
*get_LorRonly_ref = \&get_symmetric_difference_ref;
*get_AorBonly_ref = \&get_symmetric_difference_ref;

sub get_nonintersection {
    return @{ get_nonintersection_ref(@_) };
}

sub get_nonintersection_ref {
    my $method = (caller(0))[3];
    $method =~ s/.*::(\w*)$/$1/;
    carp "When comparing only 2 lists, \&$method defaults to \n  \&get_symmetric_difference_ref.  Though the results returned are valid, \n    please consider re-coding with that method: $!";
    &get_symmetric_difference_ref(@_);
}

sub is_LsubsetR {
    return _is_LsubsetR_engine(_argument_checker(@_));
}

*is_AsubsetB  = \&is_LsubsetR;

sub is_RsubsetL {
    return _is_RsubsetL_engine(_argument_checker(@_));
}

*is_BsubsetA  = \&is_RsubsetL;

sub is_member_which {
    return @{ is_member_which_ref(@_) };
}    

sub is_member_which_ref {
    return _is_member_which_engine(_argument_checker_1(@_));
}    

sub are_members_which {
    return _are_members_which_engine(_argument_checker_2(@_));
}

sub is_member_any {
    return _is_member_any_engine(_argument_checker_1(@_));
}    

sub are_members_any {
    return _are_members_any_engine(_argument_checker_2(@_));
}    

sub print_subset_chart {
    _print_subset_chart_engine(_argument_checker(@_));
}

sub is_LequivalentR {
    return _is_LequivalentR_engine(_argument_checker(@_));
}

*is_LeqvlntR = \&is_LequivalentR;

sub print_equivalence_chart {
    _print_equivalence_chart_engine(_argument_checker(@_));
}

sub get_bag {
    return @{ get_bag_ref(@_) };
}

sub get_bag_ref {
    my @args = @_;
    my ($unsorted, $l, $r);
    $unsorted = shift(@args) if ($args[0] eq '-u' or $args[0] eq '--unsorted');
    ($l, $r) = _argument_checker(@args);
    if ( ref($l) eq 'ARRAY' and ref($r) eq 'ARRAY' ) {
        $unsorted ? return [     ( @$l, @$r ) ]
                  : return [ sort( @$l, @$r ) ];
    } else {
        my (@bag);
        my %l = %{$l};
        my %r = %{$r};
        foreach (keys %l) {
            for (my $j=1; $j <= $l{$_}; $j++) {
                push(@bag, $_);
            }
        } 
        foreach (keys %r) {
            for (my $j=1; $j <= $r{$_}; $j++) {
                push(@bag, $_);
            }
        } 
        $unsorted ? return [      @bag ]
                  : return [ sort @bag ];
    }
}

######################### INTERNAL SUBROUTINES #########################

sub _argument_checker {
    croak "Functional interface can only compare 2 lists at a time: $!"
        unless @_ == 2;
    my ($l, $r) = @_;
    my ($array_condition, $hash_condition);
    $array_condition = 1 if ( ref($l) eq 'ARRAY' and ref($r) eq 'ARRAY' );
    $hash_condition  = 1 if ( ref($l) eq 'HASH'  and ref($r) eq 'HASH'  );
    croak "Arguments must be either both array references or both hash references: $!"
        unless ( $array_condition or $hash_condition );
    _validate_seen_hash($l, $r) if $hash_condition;
    return ($l, $r);
}

sub _argument_checker_1 {
    my @args = @_;
    croak "Subroutine call requires references to 2 arrays or 2 hashes and\n    exactly 1 item to be tested:  $!"
        unless @args == 3;
    my ($array_condition, $hash_condition);
    $array_condition = 1 if ( ref($args[0]) eq 'ARRAY' and ref($args[1]) eq 'ARRAY' );
    $hash_condition  = 1 if ( ref($args[0]) eq 'HASH'  and ref($args[1]) eq 'HASH'  );
    croak "Arguments must be either both array references or both hash references: $!"
        unless ( $array_condition or $hash_condition );
    _validate_seen_hash($args[0], $args[1]) if $hash_condition;
    return @args;
}

sub _argument_checker_2 {
    my @args = @_;
    croak "Subroutine call requires references to 2 arrays or 2 hashes and\n    either a list or a reference to an array to be tested:  $!"
        unless @args >= 3;
    my ($array_condition, $hash_condition);
    $array_condition = 1 if ( ref($args[0]) eq 'ARRAY' and ref($args[1]) eq 'ARRAY' );
    $hash_condition  = 1 if ( ref($args[0]) eq 'HASH'  and ref($args[1]) eq 'HASH'  );
    croak "Arguments must be either both array references or both hash references: $!"
        unless ( $array_condition or $hash_condition );
    _validate_seen_hash($args[0], $args[1]) if $hash_condition;
    my @items = splice(@args, 2);
    @items = @{$items[0]} if (@items == 1 and ref($items[0]) eq 'ARRAY');
    return ($args[0], $args[1], \@items);
}

sub _validate_seen_hash {
    my ($l, $r) = @_;
    my (%badentriesL, %badentriesR);
    foreach (keys %$l) {
        $badentriesL{$_} = ${$l}{$_} 
        unless (${$l}{$_} =~ /^\d+$/ and ${$l}{$_} > 0);
    } 
    foreach (keys %$r) {
        $badentriesR{$_} = ${$r}{$_} 
        unless (${$r}{$_} =~ /^\d+$/ and ${$r}{$_} > 0);
    }
    if ( (keys %badentriesL) or (keys %badentriesR) ) {
        print "\nValues in a 'seen-hash' may only be numeric.\n";
        print "  These elements have invalid values:\n\n";
        if (keys %badentriesL) {
            print "  First hash in arguments:\n\n";
            print "     Key:  $_\tValue:  $badentriesL{$_}\n" 
                foreach (sort keys %badentriesL);
        } 
        if (keys %badentriesR) {
            print "  Second hash in arguments:\n\n";
            print "     Key:  $_\tValue:  $badentriesR{$_}\n" 
                foreach (sort keys %badentriesR);
        }
        croak "Correct invalid values before proceeding:  $!";
    }
}

1;

__END__

=head1 NAME

List::Compare::Functional - Compare elements of two or more lists

=head1 VERSION

This document refers to version 0.24 of List::Compare::Functional.  
This version was released March 28, 2004.  The first released 
version of List::Compare::Functional was v0.21.  Its version numbers 
are set to be consistent with the other parts of the List::Compare 
distribution.
 
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

=head2 Comparing Two Lists Held in Arrays

=over 4

=item *

Given two lists:

    @Llist = qw(abel abel baker camera delta edward fargo golfer);
    @Rlist = qw(baker camera delta delta edward fargo golfer hilton);

=item *

Get those items which appear at least once in both lists (their intersection).

    @intersection = get_intersection(\@Llist, \@Rlist);

=item *

Get those items which appear at least once in either list (their union).

    @union = get_union(\@Llist, \@Rlist);

=item *

Get those items which appear (at least once) only in the first list.

    @Lonly = get_unique(\@Llist, \@Rlist);
    @Lonly = get_Lonly(\@Llist, \@Rlist);    # alias

=item *

Get those items which appear (at least once) only in the second list.

    @Ronly = get_complement(\@Llist, \@Rlist);
    @Ronly = get_Ronly(\@Llist, \@Rlist);            # alias

=item *

Get those items which appear at least once in either the first or the second 
list, but not both.

    @LorRonly = get_symmetric_difference(\@Llist, \@Rlist);
    @LorRonly = get_symdiff(\@Llist, \@Rlist);       # alias
    @LorRonly = get_LorRonly(\@Llist, \@Rlist);      # alias

=item *

Make a bag of all those items in both lists.  The bag differs from the 
union of the two lists in that it holds as many copies of individual 
elements as appear in the original lists.

    @bag = get_bag(\@Llist, \@Rlist);

=item *

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref = get_intersection_ref(\@Llist, \@Rlist);
    $union_ref        = get_union_ref(\@Llist, \@Rlist);
    $Lonly_ref        = get_unique_ref(\@Llist, \@Rlist);
    $Lonly_ref        = get_Lonly_ref(\@Llist, \@Rlist);                 # alias
    $Ronly_ref        = get_complement_ref(\@Llist, \@Rlist);
    $Ronly_ref        = get_Ronly_ref(\@Llist, \@Rlist);                 # alias
    $LorRonly_ref     = get_symmetric_difference_ref(\@Llist, \@Rlist);
    $LorRonly_ref     = get_symdiff_ref(\@Llist, \@Rlist);               # alias
    $LorRonly_ref     = get_LorRonly_ref(\@Llist, \@Rlist);              # alias
    $bag_ref          = get_bag_ref(\@Llist, \@Rlist);

=item *

Return a true value if L is a subset of R.

    $LR = is_LsubsetR(\@Llist, \@Rlist);

Return a true value if R is a subset of L.

    $RL = is_RsubsetL(\@Llist, \@Rlist);

=item *

Return a true value if L and R are equivalent, I<i.e.> if every element 
in L appears at least once in R and I<vice versa>.

    $eqv = is_LequivalentR(\@Llist, \@Rlist);
    $eqv = is_LeqvlntR(\@Llist, \@Rlist);            # alias

=item *

Pretty-print a chart showing whether one list is a subset of the other.

    print_subset_chart(\@Llist, \@Rlist);

=item *

Pretty-print a chart showing whether the two lists are equivalent (same 
elements found at least once in both).

    print_equivalence_chart(\@Llist, \@Rlist);

=item *

Determine in I<which> (if any) of the lists a given string can be found.  
In list context, return a list of those indices in the argument list 
corresponding to lists holding the string being tested.

    @memb_arr = is_member_which(\@Llist, \@Rlist, 'abel');

In the example above, C<@memb_arr> will be:

    ( 0 )

because C<'abel'> is found only in C<@Al> which holds position C<0> in the 
list of arguments passed to C<new()>.

=item *

As with other List::Compare methods which return a list, you may wish the 
above method returned a (scalar) reference to an array holding the list:

    $memb_arr_ref = is_member_which_ref(\@Llist, \@Rlist, 'baker');

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

    $memb_hash_ref = 
        are_members_which(\@Llist, \@Rlist, 
            qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_which()>, you may also pass a 
reference to an array.

    $memb_hash_ref = 
        are_members_which(\@Llist, \@Rlist, 
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

    $found = is_member_any(\@Llist, \@Rlist, 'abel');

In the example above, C<$found> will be C<1> because C<'abel'> is found in one 
or more of the lists passed as arguments to C<new()>.

=item *

Determine whether a specified string or strings can be found in I<any> of the 
lists passed as arguments.  Get a reference to a hash where 
an element's key is the string being tested and the element's value is 1 if 
the string can be found in C<any> of the lists and 0 if not.

    $memb_hash_ref = are_members_any(\@Llist, \@Rlist, 
        qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_any()>, you may also pass a reference 
to an array.

    $memb_hash_ref = are_members_any(\@Llist, \@Rlist, 
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

    @intersection = get_intersection(\%Llist, \%Rlist);
    @union        = get_union(\%Llist, \%Rlist);
    @complement   = get_complement(\%Llist, \%Rlist);

and so forth.

=head2 Faster Results with the Unsorted Option

By default, List::Compare::Function functions return lists sorted in Perl's 
default ASCII-betical mode.  Sorting entails a performance cost, and if you 
do not need a sorted list and do not wish to pay this performance cost, you 
may call the following List::Compare::Function functions with the 'unsorted' 
option:

    @intersection = get_intersection('-u', \@Llist, \@Rlist);
    @union = get_union('-u', \@Llist, \@Rlist);
    @Lonly = get_unique('-u', \@Llist, \@Rlist);
    @Ronly = get_complement('-u', \@Llist, \@Rlist);
    @LorRonly = get_symmetric_difference('-u', \@Llist, \@Rlist);
    @bag = get_bag('-u', \@Llist, \@Rlist);

For greater readability, the option may be spelled out:

    @intersection = get_intersection('--unsorted', \@Llist, \@Rlist);

Should you need a reference to an unsorted list as the return value, you 
may call the unsorted option as follows:

    $intersection_ref = get_intersection_ref('-u', \@Llist, \@Rlist);
    $intersection_ref = get_intersection_ref('--unsorted', \@Llist, \@Rlist);

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

    get_intersection()
    get_intersection_ref()
    get_union()
    get_union_ref()
    get_unique()
    get_unique_ref()
    get_complement()
    get_complement_ref()
    get_symmetric_difference()
    get_symmetric_difference_ref()
    is_LsubsetR()
    is_RsubsetL()
    is_member_which()
    are_members_which()
    is_member_any()
    are_members_any()
    print_subset_chart()
    is_LequivalentR()
    print_equivalence_chart()
    get_bag()
    get_bag_ref()

=item *

Tag group C<:aliases> contains all List::Compare::Functional subroutines 
which are aliases for subroutines found in tag group C<:originals>.  In 
certain cases the aliases involve less typing; in others they are ways of
calling subroutines in a style dating from early versions of List::Compare 
and are included solely for backward compatibility for the one or two 
people on the planet still using those early versions.

=back

=head1 AUTHOR

James E. Keenan (jkeenan@cpan.org).

Creation date:  May 20, 2002.  Last modification date:  March 28, 2004. 
Copyright (c) 2002-3 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 




