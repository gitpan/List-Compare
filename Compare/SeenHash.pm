package List::Compare::SeenHash;
$VERSION = 0.18;   # June 1, 2003 

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;
use base qw(List::Compare::Base::Regular);

sub new {
    my $class = shift;
    my @hashrefs = @_;
    my ($option, $self, $dataref);
    $option = $hashrefs[0] eq '-a' ? shift(@hashrefs) : 0;
    foreach (@hashrefs) {
        croak "Must pass hash references: $!" unless ref($_) eq 'HASH';
    }

    # bless a ref to an empty hash into the invoking class
    if (@hashrefs > 2) {
        $class .= '::Multiple';
        $self = bless {}, ref($class) || $class;
    } elsif (@hashrefs == 2) {
        if ($option eq '-a') {
            $class .= '::Accelerated';
            $self = bless {}, ref($class) || $class;
        } else {
            $self = bless {}, ref($class) || $class;
        }
    } else {
        croak "Must pass at least 2 hash references to \&new: $!";
    }
    
    # do necessary calculations and store results in a hash
    # take a reference to that hash
    $dataref = $self->_init(@hashrefs);
    
    # initialize the object from the prepared values (Damian, p. 98)
    %$self = %$dataref;
    return $self;
}

sub _init {
    my $self = shift;
    my ($refL, $refR) = @_;
    my (%data, %seenL, %seenR);

    my (%intersection, %union, %Lonly, %Ronly, %LorRonly);
    my $LsubsetR_status = my $RsubsetL_status = 1;
    my $LequivalentR_status = 0;

    my (%badentriesL, %badentriesR);
    foreach (keys %$refL) {
        if (${$refL}{$_} =~ /^\d+$/) {
            $seenL{$_} = ${$refL}{$_};
        } else {
            $badentriesL{$_} = ${$refL}{$_};
        }
    } 
    foreach (keys %$refR) {
        if (${$refR}{$_} =~ /^\d+$/) {
            $seenR{$_} = ${$refR}{$_};
        } else {
            $badentriesR{$_} = ${$refR}{$_};
        }
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
            print "  First hash in arguments:\n\n";
            print "     Key:  $_\tValue:  $badentriesR{$_}\n" 
                foreach (sort keys %badentriesR);
        }
        croak "Correct invalid values before proceeding:  $!";
    }
 
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

    $LorRonly{$_}++ foreach ( (keys %Lonly), (keys %Ronly) );

    $LequivalentR_status = 1 if ( (keys %LorRonly) == 0);

    foreach (keys %seenL) {
        if (! exists $seenR{$_}) {
            $LsubsetR_status = 0;
            last;
        }
    }
    foreach (keys %seenR) {
        if (! exists $seenL{$_}) {
            $RsubsetL_status = 0;
            last;
        }
    }
    
    $data{'seenL'}                = \%seenL; 
    $data{'seenR'}                = \%seenR; 
    $data{'intersection'}         = [ sort keys %intersection ];
    $data{'union'}                = [ sort keys %union ];
    $data{'unique'}               = [ sort keys %Lonly ];
    $data{'complement'}           = [ sort keys %Ronly ];
    $data{'symmetric_difference'} = [ sort keys %LorRonly ];
    $data{'LsubsetR_status'}      = $LsubsetR_status;
    $data{'RsubsetL_status'}      = $RsubsetL_status;
    $data{'LequivalentR_status'}  = $LequivalentR_status;
    return \%data;
}

sub get_version {
    return $List::Compare::SeenHash::VERSION;
}

1;

package List::Compare::SeenHash::Accelerated;
use Carp;
use base qw(List::Compare::Base::Accelerated);

sub _init {
    my $self = shift;
    my ($refL, $refR) = @_;
    my (%data, %seenL, %seenR);

    my (%badentriesL, %badentriesR);
    foreach (keys %$refL) {
        if (${$refL}{$_} =~ /^\d+$/) {
            $seenL{$_} = ${$refL}{$_};
        } else {
            $badentriesL{$_} = ${$refL}{$_};
        }
    } 
    foreach (keys %$refR) {
        if (${$refR}{$_} =~ /^\d+$/) {
            $seenR{$_} = ${$refR}{$_};
        } else {
            $badentriesR{$_} = ${$refR}{$_};
        }
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
            print "  First hash in arguments:\n\n";
            print "     Key:  $_\tValue:  $badentriesR{$_}\n" 
                foreach (sort keys %badentriesR);
        }
        croak "Correct invalid values before proceeding:  $!";
    }

    $data{'L'} = \%seenL;
    $data{'R'} = \%seenR;
    return \%data;
}    

sub get_version {
    return $List::Compare::SeenHash::VERSION;
}

1;

package List::Compare::SeenHash::Multiple;
use Carp;
use base qw(List::Compare::Base::Multiple);

sub _init {
    my $self = shift;
    my @hashrefs = @_;
    my %data = ();
    my $maxindex = $#hashrefs;
    
    my (@intersection, @union);
        # will hold overall intersection/union
    my @nonintersection = ();
        # will hold all items except those found in each source list
        # @intersection + @nonintersection = @union
    my @shared = ();
        # will hold all items found in at least 2 lists
    my @symmetric_difference = ();
        # will hold each item found in only one list regardless of list;
        # equivalent to @union minus all items found in the lists 
        # underlying %xintersection
    my (%intersection, %union);
        # will be used to generate @intersection & @union
    my %seen = ();
        # will be hash of hashes, holding seen-hashes corresponding to 
        # the source lists
    my %xintersection = ();
        # will be hash of hashes, holding seen-hashes corresponding to 
        # the lists containing the intersections of each permutation of 
        # the source lists
    my %shared = ();
        # will be used to generate @shared
    my %xunique = ();
        # will be hash of arrays, holding the items that are unique to 
        # the list whose index number is passed as an argument
    my %xcomplement = ();
        # will be hash of arrays, holding the items that are found in 
        # any list other than the list whose index number is passed 
        # as an argument

    # Calculate overall union and take steps needed to calculate overall 
    # intersection, unique, difference, etc.
    for (my $i = 0; $i <= $#hashrefs; $i++) {
        my %seenthis = ();
        foreach (keys %{$hashrefs[$i]}) {
            $seenthis{$_}++;
            $union{$_}++;
        }
        $seen{$i} = \%seenthis;
        for (my $j = $i+1; $j <=$#hashrefs; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach (keys %{$hashrefs[$j]});
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    @union = sort keys %union;
    # At this point we now have %seen, @union and %xintersection available 
    # for use in other calculations.


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
    # Inputs:  @hashrefs    %seen    %xintersection
    for (my $i = 0; $i <= $#hashrefs; $i++) {
        my %seenthis = %{$seen{$i}};
        my @uniquethis = ();
        # Get those elements of %xintersection which we'll need 
        # to subtract from %seenthis
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
    # %xunique is now available for use in further calculations, 
    # such as returning the items unique to a particular source list.


    # Calculate %xcomplement
    # Inputs:  @hashrefs    %seen    @union
    for (my $i = 0; $i <= $#hashrefs; $i++) {
        my %seenthis = %{$seen{$i}};
        my @complementthis = ();
        foreach (@union) {
            push(@complementthis, $_) unless (exists $seenthis{$_});
        }
        $xcomplement{$i} = \@complementthis;
    }
    # %xcomplement is now available for use in further calculations, 
    # such as returning the items in all lists different from those in a 
    # particular source list.


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
                if ($xsubset[$f][$g] and $xsubset[$g][$f]);
        }
    }
    
    $data{'seen'}                   = \%seen;
    $data{'maxindex'}               = $maxindex;
    $data{'intersection'}           = \@intersection;
    $data{'nonintersection'}        = \@nonintersection;
    $data{'union'}                  = \@union;
    $data{'shared'}                 = \@shared;
    $data{'symmetric_difference'}   = \@symmetric_difference;
    $data{'xunique'}                = \%xunique;
    $data{'xcomplement'}            = \%xcomplement;
    $data{'xsubset'}                = \@xsubset;
    $data{'xequivalent'}            = \@xequivalent;
    return \%data;
}    



sub get_version {
    return $List::Compare::SeenHash::VERSION;
}

1;

__END__

=head1 NAME

List::Compare::SeenHash - Compare elements of two or more lists

=head1 VERSION

This document refers to version 0.18 of List::Compare::SeenHash.  This version 
was released June 1, 2003.

=head1 SYNOPSIS

=head2 What Is a Seen-Hash?

A seen-hash is a hash where the value for a given element represents the number 
of times the element's key is observed in a list.  For the purposes of 
List::Compare::SeenHash, what is crucial is whether an item is observed in a 
list or not; less crucial is how many times the item occurs in a list.

=head2 Regular Case:  Compare Two Lists

Create a List::Compare::SeenHash object.  Build seen-hashes corresponding to 
two lists, then pass references to the seen-hashes to the constructor.

    my %Llist = (
       abel     => 2,
       baker    => 1,
       camera   => 1,
       delta    => 1,
       edward   => 1,
       fargo    => 1,
       golfer   => 1,
    );

    my %Rlist = (
       baker    => 1,
       camera   => 1,
       delta    => 2,
       edward   => 1,
       fargo    => 1,
       golfer   => 1,
       hilton   => 1,
    );

    $lcsh = List::Compare::SeenHash->new(\%Llist, \%Rlist);

Get those items which appear at least once in both lists (their intersection).

    @intersection = $lcsh->get_intersection;

Get those items which appear at least once in either list (their union).

    @union = $lcsh->get_union;

Get those items which appear (at least once) only in the first list.

    @Lonly = $lcsh->get_unique;
    @Lonly = $lcsh->get_Lonly;    # alias

Get those items which appear (at least once) only in the second list.

    @Ronly = $lcsh->get_complement;
    @Ronly = $lcsh->get_Ronly;            # alias

Get those items which appear at least once in either the first or the second 
list, but not both.

    @LorRonly = $lcsh->get_symmetric_difference;
    @LorRonly = $lcsh->get_symdiff;       # alias
    @LorRonly = $lcsh->get_LorRonly;      # alias

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref = $lcsh->get_intersection_ref;
    $union_ref        = $lcsh->get_union_ref;
    $Lonly_ref        = $lcsh->get_unique_ref;
    $Lonly_ref        = $lcsh->get_Lonly_ref;                 # alias
    $Ronly_ref        = $lcsh->get_complement_ref;
    $Ronly_ref        = $lcsh->get_Ronly_ref;                 # alias
    $LorRonly_ref     = $lcsh->get_symmetric_difference_ref;
    $LorRonly_ref     = $lcsh->get_symdiff_ref;               # alias
    $LorRonly_ref     = $lcsh->get_LorRonly_ref;              # alias

Return a true value if L is a subset of R.

    $LR = $lcsh->is_LsubsetR;

Return a true value if R is a subset of L.

    $RL = $lcsh->is_RsubsetL;

Return a true value if L and R are equivalent, I<i.e.> if every element 
in L appears at least once in R and I<vice versa>.

    $eqv = $lcsh->is_LequivalentR;
    $eqv = $lcsh->is_LeqvlntR;            # alias

Pretty-print a chart showing whether one list is a subset of the other.

    $lcsh->print_subset_chart;

Pretty-print a chart showing whether the two lists are equivalent (same 
elements found at least once in both).

    $lcsh->print_equivalence_chart;

Determine in which (if any) of the lists passed to the constructor a given 
string or strings can be found.  Get a reference to a hash of arrays where 
an element's key is the string being tested and the element's value is a 
reference to an anonymous array holding a list of the indices in the list of 
arguments passed to the constructor corresponding to lists holding that key.

    $memb_hash_ref = $lcsh->member_which(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<member_which()>, you may also pass a reference 
to an array.

    $memb_hash_ref = $lcsh->member_which([ qw| abel baker fargo hilton zebra | ]);

In the two examples above, the result will be:

    {
         abel     => [ 0    ],
         baker    => [ 0, 1 ],
         fargo    => [ 0, 1 ],
         hilton   => [    1 ],
         zebra    => [      ],
    };

Similar to the above, but testing only one string at a time.  Determine in 
which (if any) of the lists passed to the constructor a single given 
string can be found.  In list context, get an array holding a list of the 
indices in the list of arguments passed to the constructor corresponding 
to lists holding that key.

    @memb_arr = $lcsh->single_member_which('abel');

In the example above, C<@memb_arr> will be:

    ( 0 )

In scalar context, get a reference to an anonymous array holding a list of 
the indices in the list of arguments passed to the constructor corresponding 
to lists holding that key.

    $memb_arr_ref = $lcsh->single_member_which('baker');

In the example above, C<$memb_arr_ref> will be:

    [ 0, 1 ]

Return current List::Compare::SeenHash version number.

    $vers = $lcsh->get_version;

=head2 Accelerated Case:  When User Only Wants a Single Comparison

If you are certain that you will only want the results of a single 
comparison, computation may be accelerated by passing C<'-a'> as the first 
argument to the constructor.

    my %Llist = (
       abel     => 2,
       baker    => 1,
       camera   => 1,
       delta    => 1,
       edward   => 1,
       fargo    => 1,
       golfer   => 1,
    );

    my %Rlist = (
       baker    => 1,
       camera   => 1,
       delta    => 2,
       edward   => 1,
       fargo    => 1,
       golfer   => 1,
       hilton   => 1,
    );

    $lcsha = List::Compare::SeenHash->new('-a', \@Llist, \@Rlist);

All the comparison methods available in the Regular case are available to 
the user in the Accelerated case as well.

    @intersection     = $lcsha->get_intersection;
    @union            = $lcsha->get_union;
    @Lonly            = $lcsha->get_unique;
    @Ronly            = $lcsha->get_complement;
    @LorRonly         = $lcsha->get_symmetric_difference;
    $intersection_ref = $lcsha->get_intersection_ref;
    $union_ref        = $lcsha->get_union_ref;
    $Lonly_ref        = $lcsha->get_unique_ref;
    $Ronly_ref        = $lcsha->get_complement_ref;
    $LorRonly_ref     = $lcsha->get_symmetric_difference_ref;
    $LR               = $lcsha->is_LsubsetR;
    $RL               = $lcsha->is_RsubsetL;
    $eqv              = $lcsha->is_LequivalentR;
                        $lcsha->print_subset_chart;
                        $lcsha->print_equivalence_chart;
    $memb_hash_ref    = $lcsha->member_which(
                                  qw| abel baker fargo hilton zebra |);
    $memb_hash_ref    = $lcsha->member_which(
                                  [ qw| abel baker fargo hilton zebra | ]);
    @memb_arr         = $lcsha->single_member_which('abel');
    $memb_arr_ref     = $lcsha->single_member_which('baker');
    $vers             = $lcsha->get_version;

All the aliases for methods available in the Regular case are available to 
the user in the Accelerated case as well.

=head2 Multiple Case:  Compare Three or More Lists

Create a List::Compare::SeenHash object.  Put each list into an array and pass
references to the arrays to the constructor.

    %Al = (
        abel    => 2,
        baker   => 1,
        camera  => 1,
        delta   => 1,
        edward  => 1,
        fargo   => 1,
        golfer  => 1,
    );

    %Bob = (
        baker   => 1,
        camera  => 1,
        delta   => 2,
        edward  => 1,
        fargo   => 1,
        golfer  => 1,
        hilton  => 1,
    );

    %Carmen = (
        fargo   => 1,
        golfer  => 1,
        hilton  => 1,
        icon    => 2,
        jerky   => 1,
        kappa   => 1,
    );
    
    %Don = (
        fargo   => 1,
        icon    => 1,
        jerky   => 1,
    );
    
    %Ed = (
        fargo   => 1,
        icon    => 2,
        jerky   => 1,
    );

    $lcshm = List::Compare::SeenHash->new(\%Al, \%Bob, \%Carmen, \%Don, \%Ed);

=over 4

=item *

Multiple Mode Methods Analogous to Regular and Accelerated Mode Methods

Each List::Compare::SeenHash method available in the Regular and Accelerated 
cases has an analogue in the Multiple case.  However, the results produced 
usually require more careful specification.

Get those items found in each of the lists passed to the constructor 
(their intersection):

    @intersection = $lcshm->get_intersection;

Get those items found in any of the lists passed to the constructor 
(their union):

    @union = $lcshm->get_union;

To get those items which appear only in one particular list, pass to 
C<get_unique()> that list's index position in the list of arguments passed 
to the constructor.  Example:  C<@Carmen> has index position 2 in the 
constructor's C<@_>.  To get elements unique to C<@Carmen>:  

    @Lonly = $lcshm->get_unique(2);

If no index position is passed to C<get_unique()> it will default to 0 
and report items unique to the first list passed to the constructor.

To get those items which appear in any list other than one particular 
list, pass to C<get_complement()> that list's index position in the list 
of arguments passed to the constructor.  Example:  C<@Don> has index 
position 3 in the constructor's C<@_>.  To get elements not found in 
C<@Don>:  

    @Ronly = $lcshm->get_complement(3);

If no index position is passed to C<get_complement()> it will default to 
0 and report items found in any list other than the first list passed 
to the constructor.

Get those items which do not appear in more than one of the lists 
passed to the constructor (their symmetric_difference);

    @LorRonly = $lcshm->get_symmetric_difference;

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref = $lcshm->get_intersection_ref;
    $union_ref        = $lcshm->get_union_ref;
    $Lonly_ref        = $lcshm->get_unique_ref(2);
    $Ronly_ref        = $lcshm->get_complement_ref(3);
    $LorRonly_ref     = $lcshm->get_symmetric_difference_ref;

To determine whether one particular list is a subset of another list 
passed to the constructor, pass to C<is_LsubsetR()> the index position of 
the presumed subset, followed by the index position of the presumed 
superset.  A true value (1) is returned if the left-hand list is a 
subset of the right-hand list; a false value (0) is returned otherwise.
Example:  To determine whether C<@Ed> is a subset of C<@Carmen>, call:

    $LR = $lcshm->is_LsubsetR(4,2);

If no arguments are passed, C<is_LsubsetR()> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

To determine whether any two particular lists are equivalent to each 
other, pass their index positions in the list of arguments passed to 
the constructor to C<is_LequivalentR>. A true value (1) is returned if 
the lists are equivalent; a false value (0) otherwise. Example:  To 
determine whether C<@Don> and C<@Ed> are equivalent, call:

    $eqv = $lcshm->is_LequivalentR(3,4);

If no arguments are passed, C<is_LequivalentR> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

Pretty-print a chart showing the subset relationships among the various 
source lists:

    $lcshm->print_subset_chart;

Pretty-print a chart showing the equivalence relationships among the 
various source lists:

    $lcshm->print_equivalence_chart;

Determine in which (if any) of the lists passed to the constructor a given 
string or strings can be found.  Get a reference to a hash of arrays where 
an element's key is the string being tested and the element's value is a 
reference to an anonymous array holding a list of the indices in the list of 
arguments passed to the constructor corresponding to lists holding that key.

    $memb_hash_ref = $lcshm->member_which(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<member_which()>, you may also pass a reference 
to an array.

    $memb_hash_ref = $lcshm->member_which([ qw| abel baker fargo hilton zebra | ]);

In the two examples above, the result will be:

    {
         abel     => [ 0    ],
         baker    => [ 0, 1 ],
         fargo    => [ 0, 1 ],
         hilton   => [    1 ],
         zebra    => [      ],
    };

Similar to the above, but testing only one string at a time.  Determine in 
which (if any) of the lists passed to the constructor a single given 
string can be found.  In list context, get an array holding a list of the 
indices in the list of arguments passed to the constructor corresponding 
to lists holding that key.

    @memb_arr = $lcshm->single_member_which('abel');

In the example above, C<@memb_arr> will be:

    ( 0 )

In scalar context, get a reference to an anonymous array holding a list of 
the indices in the list of arguments passed to the constructor corresponding 
to lists holding that key.

    $memb_arr_ref = $lcshm->single_member_which('baker');

In the example above, C<$memb_arr_ref> will be:

    [ 0, 1 ]

Return current List::Compare::SeenHash version number:

    $vers = $lcshm->get_version;

=item *

Multiple Mode Methods Not Analogous to Regular and Accelerated Mode Methods

Get those items found in any of the lists passed to the constructor which 
do not appear in all of the lists (I<i.e.,> all items except those found 
in the intersection of the lists):

    @nonintersection = $lcshm->get_nonintersection;

Get those items which appear in more than one of the lists passed to the 
constructor (I<i.e.,> all items except those found in their symmetric 
difference);

    @shared = $lcshm->get_shared;

If you only need a reference to an array as a return value rather than a 
full array, use the following alternative methods:

    $nonintersection_ref = $lcshm->get_nonintersection_ref;
    $shared_ref = $lcshm->get_shared_ref;

=back

=head1 DESCRIPTION

=head2 General Comments

List::Compare::SeenHash is an object-oriented implementation of very common Perl 
code (see L<"History, References and Development"> below) used to
determine interesting relationships between two or more lists at a time.  
A List::Compare::SeenHash object is created and automatically computes the 
values needed to supply List::Compare::SeenHash methods with appropriate 
results.  In the current implementation List::Compare::SeenHash methods will 
return new lists containing the items found in any designated list alone 
(unique), any list other than a designated list (complement), the intersection 
and union of all lists and so forth.  List::Compare::SeenHash also has 
(a) methods to return Boolean values indicating whether one list is a subset of 
another and whether any two lists are equivalent to each other (b) methods to 
pretty-print very simple charts displaying the subset and equivalence 
relationships among lists.

In its current implementation List::Compare::SeenHash generates its results by 
means of hash look-up tables ('seen hashes').  Hence, B<multiple instances of 
an element in a given list count only once with respect to computing the 
intersection, union, etc. of the two lists.>  In particular, 
List::Compare::SeenHash considers two lists as equivalent if each element 
of the first list can be found in the second list and I<vice versa>.  
'Equivalence' in this usage takes no note of the frequency with which 
elements occur in either list or their order within the lists.  
List::Compare::SeenHash asks the question:  Did I see this item in this list 
at all?  List::Compare::SeenHash does I<not> ask the question:  How many 
times did this item occur in this list?

=head2 List::Compare::SeenHash Modes

In its current implementation List::Compare::SeenHash has three modes of 
operation.

=over 4

=item *

Regular Mode

List::Compare::SeenHash's Regular mode is based on List::Compare v0.11 -- the 
first version of List::Compare::SeenHash released to CPAN (June 2002).  It 
compares only two lists at a time.  Internally, its initializer does all 
computations needed to report any desired comparison and its constructor 
stores the results of these computations.  Its public methods merely report 
these results.

This approach has the advantage that if the user needs to examine more 
than one form of comparison between two lists (I<e.g.,> the union, 
intersection and symmetric difference of two lists), the comparisons are 
already available.  This approach is efficient because certain types of 
comparison presuppose that other types have already been calculated.  
For example, to calculate the symmetric difference of two lists, one must 
first determine the items unique to each of the two lists.

=item *

Accelerated Mode

The current implementation of List::Compare::SeenHash offers the user the 
option of getting even faster results I<provided> that the user only needs the 
result from a I<single> form of comparison between two lists. (I<e.g.,> only 
the union -- nothing else).  In this Accelerated mode, List::Compare::SeenHash's 
initializer does no computation and its constructor stores only references 
to the two source lists.  All computation needed to report results is 
deferred to the method calls.

The user selects this approach by passing the option flag C<'-a'> to the 
constructor before passing references to the two source lists.  
List::Compare::SeenHash notes the option flag and silently switches into 
Accelerated mode.  From the perspective of the user, there is no further 
difference in the code or in the results.

Benchmarking suggests that List::Compare::SeenHash's Accelerated mode 
(a) is faster than its Regular mode when only one comparison is requested; 
(b) is about as fast as Regular mode when two comparisons are requested; and 
(c) becomes considerably slower than Regular mode as each additional comparison 
above two is requested.

=item *

Multiple Mode

List::Compare::SeenHash now offers the possibility of comparing three or more 
lists at a time.  Simply store the extra lists in arrays and pass references to 
those arrays to the constructor.  List::Compare::SeenHash detects that more 
than two lists have been passed to the constructor and silently switches into 
Multiple mode.

As described in the Synopsis above, comparing more than two lists at a time 
offers the user a wider, more complex palette of comparison methods.  
Individual items may appear in just one source list, in all the source lists, 
or in some number of lists between one and all.  The meaning of 'union', 
'intersection' and 'symmetric difference' is conceptually unchanged 
when we move to multiple lists because these are properties of all the lists 
considered together.  In contrast, the meaning of 'unique', 'complement', 
'subset' and 'equivalent' changes because these are properties of one list 
compared with another or with all the other lists combined.

List::Compare::SeenHash takes this complexity into account by allowing the user 
to pass arguments to the public methods requesting results with respect to a 
specific list (for C<get_unique()> and C<get_complement()>) or a specific pair 
of lists (for C<is_LsubsetR()> and C<is_LequivalentR()>).

List::Compare::SeenHash further takes this complexity into account by offering 
the new methods C<get_shared()> and C<get_nonintersection()> described in the 
Synopsis above.

=back

=head2 Miscellaneous Methods

It would not really be appropriate to call C<get_shared()> and 
C<get_nonintersection()> in Regular or Accelerated mode since they are 
conceptually based on the notion of comparing more than two lists at a time.  
However, there is always the possibility that a user may be comparing only two 
lists (accelerated or not) and may accidentally call one of those two methods.  
To prevent fatal run-time errors and to caution the user to use a more 
appropriate method, these two methods are defined for Regular and Accelerated 
modes so as to return suitable results but also generate a carp message that 
advise the user to re-code.

Similarly, the method C<is_RsubsetL()> is appropriate for the Regular and 
Accelerated modes but is not really appropriate for Multiple mode.  As a 
defensive maneuver, it has been defined for Multiple mode so as to return 
suitable results but also to generate a carp message that advises the user to 
re-code.

=head1 ASSUMPTIONS AND QUALIFICATIONS

The program was created with Perl 5.6. The use of I<h2xs> to prepare 
the module's template installed C<require 5.005_62;> at the top of the
module.  This has been commented out in the actual module as the code 
appears to be compatible with earlier versions of Perl; how earlier the 
author cannot say.  In particular, the author would like the module to 
be installable on older versions of MacPerl.  As is, the author has 
successfully installed the module on Linux (RedHat 7.2, Perl 5.6.0) and 
Windows98 (ActivePerl 5.6.1).  See the CPAN home page for this module for 
a list of other systems on which this version of List::Compare::SeenHash 
has been tested and installed.

=head1 HISTORY, REFERENCES AND DEVELOPMENT

=head2 The Code Itself

List::Compare::SeenHash is based on code presented by Tom Christiansen & Nathan
Torkington in I<Perl Cookbook> L<http://www.oreilly.com/catalog/cookbook/>
(a.k.a. the 'Ram' book), O'Reilly & Associates, 1998, Recipes 4.7 and 4.8. 
Similar code is presented in the Camel book:  I<Programming Perl>, by Larry
Wall, Tom Christiansen, Jon Orwant. 
L<http://www.oreilly.com/catalog/pperl3/>, 3rd ed, O'Reilly & Associates,
2000.  The list comparison code is so basic and Perlish that I suspect it
may have been written by Larry himself at the dawn of Perl time.

List::Compare::SeenHash is an extension of List::Compare, by the same author.
List::Compare's original objective was simply to put this basic code in a 
modular, object-oriented framework.  That framework, not surprisingly, is 
taken mostly from Damian Conway's I<Object Oriented Perl> 
L<http://www.manning.com/Conway/index.html>, Manning Publications, 2000.

With the addition of the Accelerated and Multiple modes, List::Compare::SeenHash 
expands considerably in both size and capabilities.  Nonetheless,  Tom and 
Nat's Cookbook code still lies at its core:  the use of hashes as look-up 
tables to record elements seen in lists.  This approach means that 
List::Compare::SeenHash is not concerned with any concept of 'equality' among 
lists which hinges upon the frequency with which, or the order in which, 
elements appear in the lists to be compared.  If this does not meet your needs, 
you should look elsewhere or write your own module.

=head2 The Inspiration

I realized the usefulness of putting the list comparison code into a
module while preparing an introductory level Perl course given at the New
School University's Computer Instruction Center in April-May 2002.  I was
comparing lists left and right.  When I found myself writing very similar
functions in different scripts, I knew a module was lurking somewhere. 
I learned the truth of the mantra ''Repeated Code is a Mistake'' from a 
2001 talk by Mark-Jason Dominus L<http://perl.plover.com/> to the New York 
Perlmongers L<http://ny.pm.org/>.  
See L<http://www.perl.com/pub/a/2000/11/repair3.html>.   
The first public presentation of this module took place at Perl Seminar 
New York L<http://groups.yahoo.com/group/perlsemny> on May 21, 2002.  
Comments and suggestions were provided there and since by Glenn Maciag, 
Gary Benson, Josh Rabinowitz, Terrence Brannon and Dave Cross.

The inspiration to extend List::Compare to List::Compare::SeenHash emerged 
as I was preparing to attend the first Yet Another Perl Conference::Canada 
conference, held in Ottawa, Ontario, May 15-16, 2003.  (See L<http://yapc.ca>.) 
The placement in the installation tree of Test::ListCompareSpecial came as a 
result of a question answered by Michael Graham in his talk "Test::More to 
Test::Extreme" given at that conference.

=head1 AUTHOR

James E. Keenan (jkeenan@cpan.org).

Creation date:  May 20, 2002.  Last modification date:  June 1, 2003. 
Copyright (c) 2002-3 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 




