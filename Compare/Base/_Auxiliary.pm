package List::Compare::Base::_Auxiliary;
$VERSION = 0.25;
# Holds subroutines used within various List::Compare::SeenHash
# and List::Compare::Functional
use Carp;
@ISA = qw(Exporter);
@EXPORT_OK = qw|
    _validate_2_seenhashes
    _validate_seen_hash
    _validate_multiple_seenhashes
    _calculate_union_xintersection_only
    _calculate_seen_xintersection_only
    _calculate_seen_only
    _calculate_xintersection_only
    _calculate_union_only
    _calculate_union_seen_only
    _calculate_hash_intersection
    _calculate_hash_shared
    _subset_subengine
    _chart_engine
    _equivalent_subengine
|;
%EXPORT_TAGS = (
    calculate => [ qw(
        _calculate_union_xintersection_only
        _calculate_seen_xintersection_only
        _calculate_seen_only
        _calculate_xintersection_only
        _calculate_union_only
        _calculate_union_seen_only
        _calculate_hash_intersection
        _calculate_hash_shared
    ) ],
);
use strict;

# L::C::SH::Regular and L::C::SH::Accelerated
sub _validate_2_seenhashes {
    my ($refL, $refR) = @_;
    my (%seenL, %seenR);
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
    return (\%seenL, \%seenR);
}

# L::C::Functional
sub _validate_seen_hash {
    if (@_ > 2) {
        _validate_multiple_seenhashes( [@_] );
    } else { 
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
}

# L::C::SH::Multiple and L::C::Functional
sub _validate_multiple_seenhashes {
    my $hashrefsref = shift;
    my @hashrefs = @{$hashrefsref};
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
}

sub _list_builder {
    my ($aref, $x) = @_;
    if (ref(${$aref}[$x]) eq 'HASH') {
        return keys %{${$aref}[$x]};
    } else {
        return      @{${$aref}[$x]};
    }
}

sub _calculate_union_xintersection_only {
    my $aref = shift;
    my (%union, %xintersection);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
            $union{$h}++;
        }
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach ( _list_builder($aref, $j) );
            foreach my $k (keys %seenthat) {
                $seenintersect{$k}++ if (exists $seenthis{$k});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    return (\%union, \%xintersection);
}

sub _calculate_seen_xintersection_only {
    my $aref = shift;
    my (%xintersection, %seen);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
        }
        $seen{$i} = \%seenthis;
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach ( _list_builder($aref, $j) );
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    return (\%seen, \%xintersection);
}

sub _calculate_seen_only {
    my $aref = shift;
    my (%seen);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
        }
        $seen{$i} = \%seenthis;
    }
    return \%seen;
}

sub _calculate_xintersection_only {
    my $aref = shift;
    my (%xintersection);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
        }
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my %seenthat = ();
            my %seenintersect = ();
            my $ilabel = $i . '_' . $j;
            $seenthat{$_}++ foreach ( _list_builder($aref, $j) );
            foreach (keys %seenthat) {
                $seenintersect{$_}++ if (exists $seenthis{$_});
            }
            $xintersection{$ilabel} = \%seenintersect;
        }
    }
    return \%xintersection;
}

sub _calculate_union_only {
    my $aref = shift;
    my (%union);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        foreach my $h ( _list_builder($aref, $i) ) {
            $union{$h}++;
        }
    }
    return \%union;
}

sub _calculate_union_seen_only {
    my $aref = shift;
    my (%union, %seen);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
            $union{$h}++;
        }
        $seen{$i} = \%seenthis;
    }
    return (\%union, \%seen);
}

sub _calculate_hash_intersection {
    my $xintersectionref = shift;
    my @xkeys = keys %{$xintersectionref};
    my %intersection = %{${$xintersectionref}{$xkeys[0]}};
    for (my $m = 1; $m <= $#xkeys; $m++) {
        my %compare = %{${$xintersectionref}{$xkeys[$m]}};
        my %result = ();
        foreach (keys %compare) {
            $result{$_}++ if (exists $intersection{$_});
        }
        %intersection = %result;
    }
    return \%intersection;
}

sub _calculate_hash_shared {
    my $xintersectionref = shift;
    my (%shared);
    foreach my $q (keys %{$xintersectionref}) {
        $shared{$_}++ foreach (keys %{${$xintersectionref}{$q}});
    }
    return \%shared;
}

sub _subset_subengine {
    my $aref = shift;
    my (@xsubset);
    my $seenref = _calculate_seen_only($aref);
    my %seen = %{$seenref};
    foreach my $i (keys %seen) {
        my %tempi = %{$seen{$i}};
        foreach my $j (keys %seen) {
            my %tempj = %{$seen{$j}};
            $xsubset[$i][$j] = 1;
            foreach my $k (keys %tempi) {
                $xsubset[$i][$j] = 0 if (! $tempj{$k});
            }
        }
    }
    return \@xsubset;
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

sub _equivalent_subengine {
    my $aref = shift;
    my $xsubsetref = _subset_subengine($aref);
    my @xsubset = @{$xsubsetref};
    my (@xequivalent);
    for (my $f = 0; $f <= $#xsubset; $f++) {
        for (my $g = 0; $g <= $#xsubset; $g++) {
            $xequivalent[$f][$g] = 0;
            $xequivalent[$f][$g] = 1
                if ($xsubset[$f][$g] and $xsubset[$g][$f]);
        }
    }
    return \@xequivalent;
}
1;

