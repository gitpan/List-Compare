package List::Compare::Base::_Auxiliary;
$VERSION = 0.28;
# As of:  04/25/2004
# Holds subroutines used within various List::Compare
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
    _chart_engine_regular 
    _chart_engine_multiple
    _equivalent_subengine
    _index_message1
    _index_message2
    _index_message3
    _index_message4
    _prepare_listrefs 
    _subset_engine_multaccel 
    _calc_seen
    _calc_seen_alt
    _calc_seen1
    _equiv_engine 
    _argument_checker_0 
    _argument_checker 
    _argument_checker_1 
    _argument_checker_2 
    _argument_checker_3 
    _argument_checker_4
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
    checker => [ qw(
        _argument_checker_0 
        _argument_checker 
        _argument_checker_1 
        _argument_checker_2 
        _argument_checker_3 
        _argument_checker_4
    ) ],
);
use strict;

# L:C, L:C:B:_Auxiliary
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

# L:C, L:C:F, L:C:B:_Auxiliary 
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

# L:C:B:_Auxiliary
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

# L:C:B:_Auxiliary
sub _list_builder {
    my ($aref, $x) = @_;
    if (ref(${$aref}[$x]) eq 'HASH') {
        return keys %{${$aref}[$x]};
    } else {
        return      @{${$aref}[$x]};
    }
}

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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
            my (%seenthat, %seenintersect);
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
sub _calculate_xintersection_only {
    my $aref = shift;
    my (%xintersection);
    for (my $i = 0; $i <= $#{$aref}; $i++) {
        my %seenthis = ();
        foreach my $h ( _list_builder($aref, $i) ) {
            $seenthis{$h}++;
        }
        for (my $j = $i+1; $j <=$#{$aref}; $j++) {
            my (%seenthat, %seenintersect);
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
sub _calculate_hash_shared {
    my $xintersectionref = shift;
    my (%shared);
    foreach my $q (keys %{$xintersectionref}) {
        $shared{$_}++ foreach (keys %{${$xintersectionref}{$q}});
    }
    return \%shared;
}

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:B:Regular, L:C:B:_Auxiliary, L:C:B:_Engine
sub _chart_engine_regular {
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

# L:C:Functional, L:C:B:Multiple, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
sub _chart_engine_multiple {
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

# L:C:Functional, L:C:B:_Auxiliary, L:C:Multiple::Accelerated
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

# L:C:B:Multiple, L:C:B:_Auxiliary
sub _index_message1 {
    my ($index, $dataref) = @_;
    my %data = %$dataref;
    my $method = (caller(1))[3];
    croak "Argument to method $method must be the array index of the target list \n  in list of arrays passed as arguments to the constructor: $!"
        unless (
                $index =~ /^\d+$/ 
           and  0 <= $index 
           and  $index <= $data{'maxindex'}
        );
}

# L:C:B:Multiple, L:C:B:_Auxiliary
sub _index_message2 {
    my $dataref = shift;
    my %data =%$dataref;
    my ($index_left, $index_right);
    my $method = (caller(1))[3];
    croak "Method $method requires 2 arguments: $!"
        unless (@_ == 0 || @_ == 2);
    if (@_ == 0) {
        $index_left = 0;
        $index_right = 1;
    } else {
        ($index_left, $index_right) = @_;
        foreach ($index_left, $index_right) {
            croak "Each argument to method $method must be a valid array index for the target list \n  in list of arrays passed as arguments to the constructor: $!"
                unless (
                        $_ =~ /^\d+$/ 
                   and  0 <= $_ 
                   and  $_ <= $data{'maxindex'}
                );
        }
    }
    return ($index_left, $index_right);
}

# L:C:B:_Auxiliary, L:C:B:Multiple::Accelerated 
sub _index_message3 {
    my ($index, $maxindex) = @_;
    my $method = (caller(1))[3];
    croak "Argument to method $method must be the array index of the target list \n  in list of arrays passed as arguments to the constructor: $!"
        unless (
                $index =~ /^\d+$/ 
           and  0 <= $index 
           and  $index <= $maxindex
        );
}

# L:C:B:_Auxiliary, L:C:B:Multiple::Accelerated 
sub _index_message4 {
    my $maxindex = shift;
    my ($index_left, $index_right);
    my $method = (caller(1))[3];
    croak "Method $method requires 2 arguments: $!"
        unless (@_ == 0 || @_ == 2);
    if (@_ == 0) {
        $index_left = 0;
        $index_right = 1;
    } else {
        ($index_left, $index_right) = @_;
        foreach ($index_left, $index_right) {
            croak "Each argument to method $method must be a valid array index for the target list \n  in list of arrays passed as arguments to the constructor: $!"
                unless (
                        $_ =~ /^\d+$/ 
                   and  0 <= $_ 
                   and  $_ <= $maxindex
                );
        }
    }
    return ($index_left, $index_right);
}

# L:C, L:C:B:_Auxiliary, L:C:B:Multiple::Accelerated 
sub _prepare_listrefs {
    my $dataref = shift;
    delete ${$dataref}{'unsort'};
    my (@listrefs);
    foreach my $lref (sort {$a <=> $b} keys %{$dataref}) {
#        push(@listrefs, ${$dataref}{$lref}) unless $lref eq 'unsort';
        push(@listrefs, ${$dataref}{$lref});
    };
    return \@listrefs;
}

# L:C:B:_Auxiliary, L:C:B:Multiple::Accelerated 
sub _subset_engine_multaccel {
    my $dataref = shift;
    my $aref = _prepare_listrefs($dataref);
    my ($index_left, $index_right) = _index_message4($#{$aref}, @_);

    my $xsubsetref = _subset_subengine($aref);
    return ${$xsubsetref}[$index_left][$index_right];
}

# L:C:Functional, L:C:B:_Engine, L:C:B:_Auxiliary
sub _calc_seen {
    my ($refL, $refR) = @_;
    if (ref($refL) eq 'HASH' and ref($refR) eq 'HASH') {
        return ($refL, $refR);
    } elsif (ref($refL) eq 'ARRAY' and ref($refR) eq 'ARRAY') {
        my (%seenL, %seenR);
        foreach (@$refL) { $seenL{$_}++ }
        foreach (@$refR) { $seenR{$_}++ }
        return (\%seenL, \%seenR); 
    } else {
        croak "Improper mixing of arguments; accelerated calculation not possible:  $!";
    }
}

sub _calc_seen_alt {
    my ($refL, $refR) = @_;
    if (ref($refL) eq 'HASH' and ref($refR) eq 'HASH') {
        return ($refL, $refR);
    } elsif (ref($refL) eq 'ARRAY' and ref($refR) eq 'ARRAY') {
        my (%seenL, %seenR);
        @seenL{@$refL} = @$refL;
        @seenR{@$refR} = @$refR;
        return (\%seenL, \%seenR); 
    } else {
        croak "Improper mixing of arguments; accelerated calculation not possible:  $!";
    }
}

# L:C:B:_Engine, L:C:B:_Auxiliary
sub _equiv_engine {
    my ($hrefL, $hrefR) = @_;
    my (%intersection, %Lonly, %Ronly, %LorRonly);
    my $LequivalentR_status = 0;
    
    foreach (keys %{$hrefL}) {
        if (exists ${$hrefR}{$_}) {
            $intersection{$_}++;
        } else {
            $Lonly{$_}++;
        }
    }

    foreach (keys %{$hrefR}) {
        $Ronly{$_}++ unless (exists $intersection{$_});
    }

    $LorRonly{$_}++ foreach ( (keys %Lonly), (keys %Ronly) );
    $LequivalentR_status = 1 if ( (keys %LorRonly) == 0);
    return $LequivalentR_status;
}

# L:C, L:C:B:_Auxiliary
sub _argument_checker_0 {
    my @args = @_;
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

# L:C, L:C:Functional, L:C:B:_Auxiliary
sub _argument_checker {
    my $argref = shift;
    my @args = _argument_checker_0(@{$argref});
    return (@args);
}

# L:C:Functional, L:C:B:_Auxiliary
sub _argument_checker_1 {
    my @argrefs = @_;
    croak "Subroutine call requires 2 references as arguments:  $!"
        unless @argrefs == 2;
    return (_argument_checker($argrefs[0]), ${$argrefs[1]}[0]);
}

# L:C:Functional, L:C:B:_Auxiliary
sub _argument_checker_2 {
    my @argrefs = @_;
    croak "Subroutine call requires 2 references as arguments:  $!"
        unless @argrefs == 2;
    return (_argument_checker($argrefs[0]), $argrefs[1]);
}

# L:C:Functional, L:C:B:_Auxiliary
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
        if (@{$argrefs[1]} == 2) {
            return (_argument_checker($argrefs[0]), $argrefs[1]);
        } else {
            croak "Must provide index positions corresponding to two lists: $!";
        }
    } else {
        croak "Subroutine call requires 1 or 2 references as arguments: $!"
            unless (@argrefs == 1 or @argrefs == 2);
    }
}

# L:C:Functional, L:C:B:_Auxiliary
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

