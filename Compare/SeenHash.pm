package List::Compare::SeenHash;
$VERSION = 0.24;   # March 28, 2004 

use strict;
# use warnings; # commented out so module will run on pre-5.6 versions of Perl
use Carp;
use base qw(List::Compare::Base::Regular);

sub new {
    my $class = shift;
    my @args = @_;
    my ($unsorted, $accelerated, $self, $dataref, $unsortflag);
    $unsorted = ($args[0] eq '-u' or $args[0] eq '--unsorted')
                ? shift(@args) : '';
    $accelerated = shift(@args) 
	if ($args[0] eq '-a' or $args[0] eq '--accelerated');
    foreach (@args) {
        croak "Must pass hash references: $!" unless ref($_) eq 'HASH';
    }

    # bless a ref to an empty hash into the invoking class
    if (@args > 2) {
        $class .= '::Multiple';
        $self = bless {}, ref($class) || $class;
    } elsif (@args == 2) {
        if ($accelerated) {
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
    $unsortflag = $unsorted ? 1 : 0;
    $dataref = $self->_init($unsortflag, @args);
    
    # initialize the object from the prepared values (Damian, p. 98)
    %$self = %$dataref;
    return $self;
}

sub _init {
    my $self = shift;
    my ($unsortflag, $refL, $refR) = @_;
    my (%data, %seenL, %seenR);

    my (%intersection, %union, %Lonly, %Ronly, %LorRonly);
    my $LsubsetR_status = my $RsubsetL_status = 1;
    my $LequivalentR_status = 0;

    my (%badentriesL, %badentriesR);
    foreach (keys %$refL) {
        if (${$refL}{$_} =~ /^\d+$/ and ${$refL}{$_} > 0) {
            $seenL{$_} = ${$refL}{$_};
        } else {
            $badentriesL{$_} = ${$refL}{$_};
        }
    } 
    foreach (keys %$refR) {
        if (${$refR}{$_} =~ /^\d+$/ and ${$refR}{$_} > 0) {
            $seenR{$_} = ${$refR}{$_};
        } else {
            $badentriesR{$_} = ${$refR}{$_};
        }
    }
    if ( (keys %badentriesL) or (keys %badentriesR) ) {
        print "\nValues in a 'seen-hash' may only be positive integers.\n";
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
    $data{'intersection'}         = $unsortflag ? [      keys %intersection ] 
                                                : [ sort keys %intersection ];
    $data{'union'}                = $unsortflag ? [      keys %union ]
                                                : [ sort keys %union ];
    $data{'unique'}               = $unsortflag ? [      keys %Lonly ] 
                                                : [ sort keys %Lonly ];
    $data{'complement'}           = $unsortflag ? [      keys %Ronly ] 
                                                : [ sort keys %Ronly ];
    $data{'symmetric_difference'} = $unsortflag ? [      keys %LorRonly ] 
                                                : [ sort keys %LorRonly ];
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
    my ($unsortflag, $refL, $refR) = @_;
    my (%data, %seenL, %seenR);

    my (%badentriesL, %badentriesR);
    foreach (keys %$refL) {
        if (${$refL}{$_} =~ /^\d+$/ and ${$refL}{$_} > 0) {
            $seenL{$_} = ${$refL}{$_};
        } else {
            $badentriesL{$_} = ${$refL}{$_};
        }
    } 
    foreach (keys %$refR) {
        if (${$refR}{$_} =~ /^\d+$/ and ${$refR}{$_} > 0) {
            $seenR{$_} = ${$refR}{$_};
        } else {
            $badentriesR{$_} = ${$refR}{$_};
        }
    }
    if ( (keys %badentriesL) or (keys %badentriesR) ) {
        print "\nValues in a 'seen-hash' may only be positive integers.\n";
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

    $data{'L'} = \%seenL;
    $data{'R'} = \%seenR;
    $data{'unsort'} = $unsortflag ? 1 : 0; 
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
    my $unsortflag = shift;
    my @hashrefs = @_;
    my %data = ();
    my $maxindex = $#hashrefs;

    # validation of seen-hash values    
    my (%badentries, $badentriesflag);
    for (my $i = 0; $i <= $#hashrefs; $i++) {
        my %seenhash = %{$hashrefs[$i]};
        foreach (keys %seenhash) {
            unless ($seenhash{$_} =~ /^\d+$/ and $seenhash{$_} > 0) {
                $badentries{$i}{$_} = $seenhash{$_};
                $badentriesflag++;
            }
        }
    }
    if ($badentriesflag) {
        print "\nValues in a 'seen-hash' may only be positive integers.\n";
        print "  These elements have invalid values:\n\n";
        foreach (sort keys %badentries) {
            print "    Hash $_:\n";
            my %pairs = %{$badentries{$_}};
            foreach my $val (sort keys %pairs) {
                print "        Bad key-value pair:  $val\t$pairs{$val}\n";
            }
        }
        croak "Correct invalid values before proceeding:  $!";
    }

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
    @union = $unsortflag ? keys %union : sort(keys %union);

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
    @intersection = $unsortflag ? keys %intersection : sort(keys %intersection);
    
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
    foreach my $q (keys %xintersection) {
        $shared{$_}++ foreach (keys %{$xintersection{$q}});
    }
    @shared = $unsortflag ? keys %shared : sort(keys %shared);
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

This document refers to version 0.24 of List::Compare::SeenHash.  This version 
was released March 28, 2004.

=head1 SYNOPSIS

=head2 What Is a Seen-Hash?

A seen-hash is a hash where the value for a given element represents the number 
of times the element's key is observed in a list.  For the purposes of 
List::Compare::SeenHash, what is crucial is whether an item is observed in a 
list or not; less crucial is how many times the item occurs in a list.

=head2 Regular Case:  Compare Two Lists

=over 4

=item *

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

By default, List::Compare::SeenHash's methods return lists which are 
sorted using Perl's default C<sort> mode:  ASCII-betical sorting.  
Should the user not need to have these lists sorted, he/she may achieve 
a speed boost by constructing the List::Compare::SeenHash object with 
the unsorted option:

    $lcsh = List::Compare::SeenHash->new('-u', \%Llist, \%Rlist);

or

    $lcsh = List::Compare::SeenHash->new('--unsorted', '-u', \%Llist, \%Rlist);

=item *

Get those items which appear at least once in both lists (their intersection).

    @intersection = $lcsh->get_intersection;

=item *

Get those items which appear at least once in either list (their union).

    @union = $lcsh->get_union;

=item *

Get those items which appear (at least once) only in the first list.

    @Lonly = $lcsh->get_unique;
    @Lonly = $lcsh->get_Lonly;    # alias

=item *

Get those items which appear (at least once) only in the second list.

    @Ronly = $lcsh->get_complement;
    @Ronly = $lcsh->get_Ronly;            # alias

=item *

Get those items which appear at least once in either the first or the second 
list, but not both.

    @LorRonly = $lcsh->get_symmetric_difference;
    @LorRonly = $lcsh->get_symdiff;       # alias
    @LorRonly = $lcsh->get_LorRonly;      # alias

=item *

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

=item *

Return a true value if L is a subset of R.

    $LR = $lcsh->is_LsubsetR;

Return a true value if R is a subset of L.

    $RL = $lcsh->is_RsubsetL;

=item *

Return a true value if L and R are equivalent, I<i.e.> if every element 
in L appears at least once in R and I<vice versa>.

    $eqv = $lcsh->is_LequivalentR;
    $eqv = $lcsh->is_LeqvlntR;            # alias

=item *

Pretty-print a chart showing whether one list is a subset of the other.

    $lcsh->print_subset_chart;

=item *

Pretty-print a chart showing whether the two lists are equivalent (same 
elements found at least once in both).

    $lcsh->print_equivalence_chart;

=item *

Determine in I<which> (if any) of the lists passed to the constructor a given 
string can be found.  In list context, return a list of those indices in the 
constructor's argument list corresponding to lists holding the string being 
tested.

    @memb_arr = $lcsh->is_member_which('abel');

In the example above, C<@memb_arr> will be:

    ( 0 )

because C<'abel'> is found only in C<@Al> which holds position C<0> in the 
list of arguments passed to C<new()>.

=item *

As with other List::Compare methods which return a list, you may wish the 
above method returned a (scalar) reference to an array holding the list:

    $memb_arr_ref = $lcsh->is_member_which_ref('baker');

In the example above, C<$memb_arr_ref> will be:

    [ 0, 1 ]

because C<'baker'> is found in C<@Llist> and C<@Rlist>, which hold positions 
C<0> and C<1>, respectively, in the list of arguments passed to C<new()>.

B<Note:>  methods C<is_member_which()> and C<is_member_which_ref> test
only one string at a time and hence take only one argument.  To test more 
than one string at a time see the next method, C<are_members_which()>.

=item *

Determine in I<which> (if any) of the lists passed to the constructor one or 
more given strings can be found.  Get a reference to a hash of arrays.  The 
key for each element in this hash is the string being tested.  Each element's 
value is a reference to an anonymous array whose elements are those indices in 
the constructor's argument list corresponding to lists holding the strings 
being tested.

    $memb_hash_ref = 
        $lcsh->are_members_which(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_which()>, you may also pass a 
reference to an array.

    $memb_hash_ref = 
        $lcsh->are_members_which([ qw| abel baker fargo hilton zebra | ]);

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
arguments to the constructor.  Return 1 if a specified string can be found in 
I<any> of the lists and 0 if not.

    $found = $lcsh->is_member_any('abel');

In the example above, C<$found> will be C<1> because C<'abel'> is found in one 
or more of the lists passed as arguments to C<new()>.

=item *

Determine whether a specified string or strings can be found in I<any> of the 
lists passed as arguments to the constructor.  Get a reference to a hash where 
an element's key is the string being tested and the element's value is 1 if 
the string can be found in C<any> of the lists and 0 if not.

    $memb_hash_ref = $lcsh->are_members_any(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_any()>, you may also pass a reference 
to an array.

    $memb_hash_ref = $lcsh->are_members_any([ qw| abel baker fargo hilton zebra | ]);

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

Return current List::Compare::SeenHash version number.

    $vers = $lcsh->get_version;

=back

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

As with List::Compare::SeenHash's Regular case, should the user not need 
to have a sorted list returned by an accelerated List::Compare::SeenHash 
method, he/she may achieve a speed boost by constructing the accelerated 
List::Compare::SeenHash object with the unsorted option:

    $lcsha = List::Compare::SeenHash->new('-u', '-a', \@Llist, \@Rlist);

or

    $lcsha = List::Compare::SeenHash->new(
        '--unsorted', '--accelerated', \@Llist, \@Rlist);

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
    @memb_arr         = $lcsha->is_member_which('abel');
    $memb_arr_ref     = $lcsha->is_member_which_ref('baker');
    $memb_hash_ref    = $lcsha->are_members_which(
                            qw| abel baker fargo hilton zebra |);
    $memb_hash_ref    = $lcsha->are_members_which(
                            [ qw| abel baker fargo hilton zebra | ]);
    $found            = $lcsha->is_member_any('abel');
    $memb_hash_ref    = $lcsha->are_members_any(
                            qw| abel baker fargo hilton zebra |);
    $memb_hash_ref    = $lcsha->are_members_any(
                            [ qw| abel baker fargo hilton zebra | ]);
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

As with List::Compare::SeenHash's Regular case, should the user not 
need to have a sorted list returned by a List::Compare::SeenHash 
method, he/she may achieve a speed boost by constructing the object 
with the unsorted option:

    $lcshm = List::Compare::SeenHash->new(
        '-u', \@Al, \@Bob, \@Carmen, \@Don, \@Ed);

or

    $lcshm = List::Compare::SeenHash->new(
        '--unsorted', \@Al, \@Bob, \@Carmen, \@Don, \@Ed);

B<Multiple Mode Methods Analogous to Regular and Accelerated Mode Methods>

Each List::Compare::SeenHash method available in the Regular and Accelerated 
cases has an analogue in the Multiple case.  However, the results produced 
usually require more careful specification.

=over 4

=item *

Get those items found in each of the lists passed to the constructor 
(their intersection):

    @intersection = $lcshm->get_intersection;

=item *

Get those items found in any of the lists passed to the constructor 
(their union):

    @union = $lcshm->get_union;

=item *

To get those items which appear only in one particular list, pass to 
C<get_unique()> that list's index position in the list of arguments passed 
to the constructor.  Example:  C<@Carmen> has index position 2 in the 
constructor's C<@_>.  To get elements unique to C<@Carmen>:  

    @Lonly = $lcshm->get_unique(2);

If no index position is passed to C<get_unique()> it will default to 0 
and report items unique to the first list passed to the constructor.

=item *

To get those items which appear in any list other than one particular 
list, pass to C<get_complement()> that list's index position in the list 
of arguments passed to the constructor.  Example:  C<@Don> has index 
position 3 in the constructor's C<@_>.  To get elements not found in 
C<@Don>:  

    @Ronly = $lcshm->get_complement(3);

If no index position is passed to C<get_complement()> it will default to 
0 and report items found in any list other than the first list passed 
to the constructor.

=item *

Get those items which do not appear in more than one of the lists 
passed to the constructor (their symmetric_difference);

    @LorRonly = $lcshm->get_symmetric_difference;

=item *

An alternative approach to the above methods:  If you do not immediately 
require an array as the return value of the method call, but simply need 
a I<reference> to an array, use one of the following parallel methods:

    $intersection_ref = $lcshm->get_intersection_ref;
    $union_ref        = $lcshm->get_union_ref;
    $Lonly_ref        = $lcshm->get_unique_ref(2);
    $Ronly_ref        = $lcshm->get_complement_ref(3);
    $LorRonly_ref     = $lcshm->get_symmetric_difference_ref;

=item *

To determine whether one particular list is a subset of another list 
passed to the constructor, pass to C<is_LsubsetR()> the index position of 
the presumed subset, followed by the index position of the presumed 
superset.  A true value (1) is returned if the left-hand list is a 
subset of the right-hand list; a false value (0) is returned otherwise.
Example:  To determine whether C<@Ed> is a subset of C<@Carmen>, call:

    $LR = $lcshm->is_LsubsetR(4,2);

If no arguments are passed, C<is_LsubsetR()> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

=item *

To determine whether any two particular lists are equivalent to each 
other, pass their index positions in the list of arguments passed to 
the constructor to C<is_LequivalentR>. A true value (1) is returned if 
the lists are equivalent; a false value (0) otherwise. Example:  To 
determine whether C<@Don> and C<@Ed> are equivalent, call:

    $eqv = $lcshm->is_LequivalentR(3,4);

If no arguments are passed, C<is_LequivalentR> defaults to C<(0,1)> and 
compares the first two lists passed to the constructor.

=item *

Pretty-print a chart showing the subset relationships among the various 
source lists:

    $lcshm->print_subset_chart;

=item *

Pretty-print a chart showing the equivalence relationships among the 
various source lists:

    $lcshm->print_equivalence_chart;

=item *

Determine in C<which> (if any) of the lists passed to the constructor a given 
string can be found.  In list context, return a list of those indices in the 
constructor's argument list corresponding to lists holding the string being 
tested.

    @memb_arr = $lcshm->is_member_which('abel');

In the example above, C<@memb_arr> will be:

    ( 0 )

because C<'abel'> is found only in C<@Al> which holds position C<0> in the 
list of arguments passed to C<new()>.

=item *

As with other List::Compare methods which return a list, you may wish the 
above method returned a (scalar) reference to an array holding the list:

    $memb_arr_ref = $lcshm->is_member_which_ref('jerky');

In the example above, C<$memb_arr_ref> will be:

    [ 3, 4 ]

because I<'jerky'> is found in C<@Don> and C<@Ed>, which hold positions 
C<3> and C<4>, respectively, in the list of arguments passed to C<new()>.

B<Note:>  methods C<is_member_which()> and C<is_member_which_ref> test
only one string at a time and hence take only one argument.  To test more 
than one string at a time see the next method, C<are_members_which()>.

=item *

Determine in C<which> (if any) of the lists passed to the constructor one or 
more given strings can be found.  Get a reference to a hash of arrays.  The 
key for each element in this hash is the string being tested.  Each element's 
value is a reference to an anonymous array whose elements are those indices in 
the constructor's argument list corresponding to lists holding the strings 
being tested.

    $memb_hash_ref = 
        $lcshm->are_members_which(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_which()>, you may also pass a 
reference to an array.

    $memb_hash_ref = 
        $lcshm->are_members_which([ qw| abel baker fargo hilton zebra | ]);

In the two examples above, C<$memb_hash_ref> will be:

    {
         abel     => [ 0             ],
         baker    => [ 0, 1          ],
         fargo    => [ 0, 1, 2, 3, 4 ],
         hilton   => [    1, 2       ],
         zebra    => [               ],
    };

B<Note:>  C<are_members_which()> can take more than one argument; 
C<is_member_which()> and C<is_member_which_ref()> each take only one argument.  
C<are_members_which()> returns a hash reference; the other methods return 
either a list or a reference to an array holding that list, depending on 
context.

=item *

Determine whether a given string can be found in I<any> of the lists passed as 
arguments to the constructor.  Return 1 if a specified string can be found in 
I<any> of the lists and 0 if not.

    $found = $lcshm->is_member_any('abel');

In the example above, C<$found> will be C<1> because C<'abel'> is found in one 
or more of the lists passed as arguments to C<new()>.

=item *

Determine whether a specified string or strings can be found in I<any> of the 
lists passed as arguments to the constructor.  Get a reference to a hash where 
an element's key is the string being tested and the element's value is 1 if 
the string can be found in C<any> of the lists and 0 if not.

    $memb_hash_ref = $lcshm->are_members_any(qw| abel baker fargo hilton zebra |);

Instead of passing a list to C<are_members_any()>, you may also pass a reference 
to an array.

    $memb_hash_ref = $lcshm->are_members_any([ qw| abel baker fargo hilton zebra | ]);

In the two examples above, C<$memb_hash_ref> will be:

    {
         abel     => 1,
         baker    => 1,
         fargo    => 1,
         hilton   => 1,
         zebra    => 0,
    };

because, I<e.g.,> C<'zebra'> is not found in any of the lists passed as 
arguments to C<new()>.

=item *

Return current List::Compare::SeenHash version number:

    $vers = $lcshm->get_version;

=back

B<Multiple Mode Methods Not Analogous to Regular and Accelerated Mode Methods>

=over 4

=item *

Get those items found in any of the lists passed to the constructor which 
do not appear in all of the lists (I<i.e.,> all items except those found 
in the intersection of the lists):

    @nonintersection = $lcshm->get_nonintersection;

=item *

Get those items which appear in more than one of the lists passed to the 
constructor (I<i.e.,> all items except those found in their symmetric 
difference);

    @shared = $lcshm->get_shared;

=item *

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

=item *

Unsorted Option

When List::Compare::SeenHash is used to return lists representing various 
comparisons of two or more lists (I<e.g.>, the lists' union or intersection), 
the lists returned are, by default, sorted using Perl's default C<sort> mode:  
ASCII-betical sorting.  Sorting produces results which are more easily 
human-readable but entails a performance cost.

Should the user not need sorted results, he/she can avoid the performance 
cost by calling List::Compare::SeenHash's constructor using the unsorted option.  
This is done by calling C<'-u'> or C<'--unsorted'> as the first argument 
passed to the constructor, I<i.e.>, as an argument called before any 
references to lists are passed to the constructor.

Note that if are calling List::Compare::SeenHash in the Accelerated mode 
I<and> wish to have the lists returned in unsorted order, you I<first> pass 
the argument for the unsorted option (C<'-u'> or C<'--unsorted'>) and I<then> 
pass the argument for the Accelerated mode (C<'-a'> or C<'--accelerated'>).
 
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

=head2 A Non-Object-Oriented Approach:  List::Compare::Functional

Version 0.21 of List::Compare introduced List::Compare::Functional, a 
functional (I<i.e.>, non-object-oriented) interface to list comparison 
functions.  List::Compare::Functional supports all the functions currently 
supported in List::Compare::SeenHash's Accelerated mode (described above).  
Like the Accelerated mode, it compares only two lists at a time and yields 
only one comparison at a time.  Unlike the Accelerated mode, however, it 
does not require use of the C<'-a'> flag in the function call.  An 
interesting feature of List::Compare::Functional is that in passing arguments 
to its subroutines you may represent the lists either by array references or 
by references to seen-hashes.  
List::Compare::Functional will return unsorted comparisons of two lists by 
passing C<'-u'> or C<'--unsorted'> as the first argument to the function.  
Please see the documentation for List::Compare::Functional to learn how to 
import its functions into your main package.

=head1 ASSUMPTIONS AND QUALIFICATIONS

See discussion in the documentation to List::Compare.

=head1 HISTORY, REFERENCES AND DEVELOPMENT

See discussion in the documentation to List::Compare.

=head1 AUTHOR

James E. Keenan (jkeenan@cpan.org).

Creation date:  May 20, 2002.  Last modification date:  March 28, 2004. 
Copyright (c) 2002-3 James E. Keenan.  United States.  All rights reserved. 
This is free software and may be distributed under the same terms as Perl
itself.

=cut 




