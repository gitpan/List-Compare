package List::Compare;

# require 5.005_62;

$VERSION = 0.11;   # June 20, 2002

use strict;
# use warnings;
use Carp;

sub new {
    my $class = shift;
    croak "Program currently compares only 2 lists at a time" if (@_ > 2);
    my ($refA, $refB) = @_;
    my ($self, $dataref);

    # bless a ref to an empty hash into the invoking class
    $self = bless {}, ref($class) || $class;
    
    # do necessary calculations and store results in a hash
    # take a reference to that hash
    $dataref = _init($refA, $refB);
    
    # initialize the object from the prepared values (Damian, p. 98)
    %$self = %$dataref;
    return $self;
}

sub _init {
    my ($refA, $refB) = @_;
    my %data = ();
    my @A = @$refA;
    my @B = @$refB;
    my %seenA = my %seenB = ();
    my @bag = sort(@A, @B);

    my %intersection = my %union = ();
    my %Aonly = my %Bonly = my %AorBonly = ();
    my $AsubsetB_status = my $BsubsetA_status = 1;

    foreach (@A) { $seenA{$_}++ } 
    foreach (@B) { $seenB{$_}++ } 

    foreach (keys %seenA) {
        $union{$_}++;
        if (exists $seenB{$_}) {
            $intersection{$_}++;
        } else {
            $Aonly{$_}++;
        }
    }

    foreach (keys %seenB) {
        $union{$_}++;
        $Bonly{$_}++ unless (exists $intersection{$_});
    }

    foreach ( (keys %Aonly), (keys %Bonly) ) {
        $AorBonly{$_}++;
    }

    foreach (@A) {
        if (! exists $seenB{$_}) {
            $AsubsetB_status = 0;
            last;
        }
    }
    foreach (@B) {
        if (! exists $seenA{$_}) {
            $BsubsetA_status = 0;
            last;
        }
    }
    
    %seenA = %seenB = ();
 
    $data{'Aonly'}           = [ keys %Aonly ];
    $data{'Bonly'}           = [ keys %Bonly ];
    $data{'union'}           = [ keys %union ];
    $data{'intersection'}    = [ keys %intersection ];
    $data{'AorBonly'}        = [ keys %AorBonly ];
    $data{'AsubsetB_status'} = $AsubsetB_status;
    $data{'BsubsetA_status'} = $BsubsetA_status;
    $data{'bag'}             = \@bag;
    return \%data;
}

sub get_unique {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'Aonly'} };
}

*get_Aonly = \&get_unique;

sub get_complement {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'Bonly'} };
}

*get_Bonly = \&get_complement;

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

sub get_symmetric_difference {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'AorBonly'} };
}

*get_symdiff  = \&get_symmetric_difference;
*get_AorBonly = \&get_symmetric_difference;

sub get_bag {
    my $class = shift;
    my %data = %$class;
    return @{ $data{'bag'} };
}

sub is_AsubsetB {
    my $class = shift;
    my %data = %$class;
    return $data{'AsubsetB_status'};
}

sub is_BsubsetA {
    my $class = shift;
    my %data = %$class;
    return $data{'BsubsetA_status'};
}

sub get_version {
    return $List::Compare::VERSION;
}

1;

__END__

=head1 NAME

List::Compare - Simple object-oriented implementation of standard Perl code
for comparing elements of two lists

=head1 VERSION

This document refers to version 0.11 of List::Compare.  This version was
released June 20, 2002.

=head1 SYNOPSIS

Create a List::Compare object.  Put the 2 lists into arrays and pass
references to the arrays to the constructor.

    @Alist = qw(alpha beta beta gamma delta epsilon);
    @Blist = qw(gamma delta delta epsilon zeta eta);
    $cl = List::Compare->new(\@Alist, \@Blist);

Get those items which appear only in the first list by using either of the
following (C<$get_Aonly> is just an alias for C<&get_unique>):

    @Aonly = $cl->get_unique;
    @Aonly = $cl->get_Aonly;

Get those items which appear only in the second list by using either of the
following (C<$get_Bonly> is just an alias for C<&get_complement>):

    @Bonly = $cl->get_complement;
    @Bonly = $cl->get_Bonly;

Get those items which appear in both lists (their intersection):

    @intersection = $cl->get_intersection;

Get those items which appear in either list (their union):

    @union = $cl->get_union;

Get those items which appear in either the first or the second list, but
not both, by using any of the following (C<&get_symdiff> and
C<$get_AorBonly> are just aliases for C<$get_symmetric_difference>):

    @AorBonly = $cl->get_symmetric_difference;
    @AorBonly = $cl->get_symdiff;
    @AorBonly = $cl->get_AorBonly;

Make a bag of all those items in both lists.  The bag differs from the 
union of the two lists in that it holds as many copies of individual 
elements as appear in the original lists:

    @bag = $cl->get_bag;

Return a true value if A is a subset of B:

    $AB = $cl->is_AsubsetB;

Return a true value if B is a subset of A:

    $BA = $cl->is_BsubsetA;

Return current List::Compare version number:

    $vers = $cl->get_version;

=head1 DESCRIPTION

List::Compare is a simple, object-oriented implementation of very common
Perl code (see "History, References and Development" below) used to
determine interesting relationships between two lists at a time.  A
List::Compare object is created and automatically computes the values
needed to supply List::Compare methods with appropriate results.  In the
current implementation List::Compare methods will return new lists
containing the items found in each list alone, in either list but not both
(symmetric difference), the intersection and union of the two lists, the
''bag'' comprised of both lists without eliminating duplicates and Boolean
values indicating whether one list is a subset of the other.

In its current implementation List::Compare, with one exception, generates
its results by means of hash look-up tables.  Hence, multiple instances of
an element in a given list only count once with respect to computing the
intersection, union, etc. of the two lists.  Only when we use C<get_bag>
to compute a bag holding the two lists do we store duplicate values.

=head1 ASSUMPTIONS AND QUALIFICATIONS

The program was created with Perl 5.6. The use of I<h2xs> to prepare the
module's template installed the C<require 5.005_62;> at the top of the
module.  In a future release the author will try to make it more
backwardly compatible so that, I<inter alia>, it can run on older versions
of MacPerl.  As is, the module has been successfully installed on Linux 
(RedHat 7.2, Perl 5.6.0), Windows (ActivePerl 5.6.1) and Cygwin Perl.

=head1 HISTORY, REFERENCES AND DEVELOPMENT

=head2 The Code Itself

List::Compare is based on code presented by Tom Christiansen & Nathan
Torkington in I<Perl Cookbook> L<http://www.oreilly.com/catalog/cookbook/>
(a.k.a. the 'Ram' book), O'Reilly & Associates, 1998, Recipes 4.7 and 4.8. 
Similar code is presented in the Camel book:  I<Programming Perl>, by Larry
Wall, Tom Christiansen, Jon Orwant. 
L<http://www.oreilly.com/catalog/pperl3/>, 3rd ed, O'Reilly & Associates,
2000.  The list comparison code is so basic and Perlish that I suspect it
may have been written by Larry himself at the dawn of Perl time.  All I've
done is to put it in an object-oriented framework.  That framework, not
surprisingly, is taken mostly from Damian Conway's I<Object Oriented Perl>
L<http://www.manning.com/Conway/index.html>, Manning Publications, 2000. 
The C<get_bag()> method was inspired by Jarkko Hietnaiemi's Set::Bag module
and Daniel Berger's Set::Array module, both available on CPAN.

=head2 The Inspiration

I realized the usefulness of putting the list comparison code into a
module while preparing an introductory level Perl course given at the New
School University's Computer Instruction Center in April-May 2002.  I was
comparing lists left and right.  When I found myself writing very similar
functions in different scripts, I knew a module was lurking somewhere. 
Inspiration:  ''Repeated Code is a Mistake''
L<http://www.perl.com/pub/a/2000/11/repair3.html> -- a 2001 talk by
Mark-Jason Dominus L<http://perl.plover.com/> to the New York Perlmongers
L<http://ny.pm.org/>.  The first public presentation of this module took
place at Perl Seminar New York L<http://groups.yahoo.com/group/perlsemny>
on May 21, 2002.  Comments and suggestions have been provided by Glenn 
Maciag, Josh Rabinowitz, Terrence Brannon and Dave Cross.

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
List::Util.

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

Both of these modules are by Jarkko Hietaniemi <jhi@iki.fi>.  Set::Scalar
has methods to return the intersection, union, difference and symmetric
difference of two sets, as well as methods to return items unique to a
first set and complementary to it in a second set.  It has methods for
reporting considerably more variants on subset status than does
List::Compare.

Set::Bag enables one to deal more flexibly with the situation in which one
has more than one instance of an element in a list.

=item *

Set::Array - Arrays as objects with lots of handy methods (including set
comparisons) and support for method chaining.
(L<http://search.cpan.org/doc/DJBERG/Set-Array-0.08/Array.pm>)

Set::Array, by Daniel Berger <djberg96@hotmail.com>, "aims to provide
built-in methods for operations that people are always asking how to do,and
which already exist in languages like Ruby."  Among the many methods in
this module are some for intersection, union, etc.  To install Set::Array,
you must first install the Want module, also available on CPAN.

=back

=head2 To Do

Possible future lines of development include:

=over 4

=item *

Benchmark the module against lists with vastly greater numbers of elements
than the lists which the author encounters in his day job (< 10E3). 
Consider optimizations to save memory and time.

=item *

Extend module to do comparisons on more than two lists at a time.

=back

=head1 AUTHOR

James E. Keenan (jkeen@concentric.net).

Creation date:  May 20, 2002.  Last modification date:  June 20, 2002. 
Copyright (c) 2002 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 



