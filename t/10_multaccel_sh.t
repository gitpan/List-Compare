# 10_multaccel_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
1;
use lib ("./t");
use List::Compare::SeenHash;
use Test::ListCompareSpecial;
use Test::ListCompareSpecial qw(:seen);

$loaded = 1;
ok($loaded);                            # 1
########################## End of black magic.
#
#my %seen = ();
#my (@unique, @complement, @intersection, @union, @symmetric_difference);
#my ($unique_ref, $complement_ref, $intersection_ref, $union_ref, $symmetric_difference_ref);
#my ($LR, $RL, $eqv, $return);
#my (@nonintersection, @shared);
#my ($nonintersection_ref, @shared_ref);
#my ($memb_hash_ref, $memb_arr_ref, @memb_arr);
#
#my %h0 = (
#	abel     => 2,
#	baker    => 1,
#	camera   => 1,
#	delta    => 1,
#	edward   => 1,
#	fargo    => 1,
#	golfer   => 1,
#);
#
#my %h1 = (
#	baker    => 1,
#	camera   => 1,
#	delta    => 2,
#	edward   => 1,
#	fargo    => 1,
#	golfer   => 1,
#	hilton   => 1,
#);
#
#my %h2 = (
#	fargo    => 1,
#	golfer   => 1,
#	hilton   => 1,
#	icon     => 2,
#	jerky    => 1,	
#);
#
#my %h3 = (
#	fargo    => 1,
#	golfer   => 1,
#	hilton   => 1,
#	icon     => 2,
#);
#
#my %h4 = (
#	fargo    => 2,
#	golfer   => 1,
#	hilton   => 1,
#	icon     => 1,
#);
#
#my %h5 = (
#	golfer   => 1,
#	lambda   => 0,
#);
#
#my %h6 = (
#	golfer   => 1,
#	mu       => 00,
#);
#
#my %h7 = (
#	golfer   => 1,
#	nu       => 'nothing',
#);
#
#
#my $lcmash   = List::Compare::SeenHash->new(\%h0, \%h1, \%h2, \%h3, \%h4);
#ok($lcmash);
#
#@union = $lcmash->get_union;
#$seen{$_}++ foreach (@union);
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$union_ref = $lcmash->get_union_ref;
#$seen{$_}++ foreach (@{$union_ref});
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@shared = $lcmash->get_shared;
#$seen{$_}++ foreach (@shared);
#ok(! exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$shared_ref = $lcmash->get_shared_ref;
#$seen{$_}++ foreach (@{$shared_ref});
#ok(! exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@intersection = $lcmash->get_intersection;
#$seen{$_}++ foreach (@intersection);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$intersection_ref = $lcmash->get_intersection_ref;
#$seen{$_}++ foreach (@{$intersection_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@unique = $lcmash->get_unique(2);
#$seen{$_}++ foreach (@unique);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$unique_ref = $lcmash->get_unique_ref(2);
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmash->get_Lonly_ref(2);
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmash->get_Aonly(2);
#}
#$seen{$_}++ foreach (@unique);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmash->get_Aonly_ref(2);
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@unique = $lcmash->get_unique;
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$unique_ref = $lcmash->get_unique_ref;
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmash->get_Lonly;
#}
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmash->get_Lonly_ref;
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmash->get_Aonly;
#}
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmash->get_Aonly_ref;
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@complement = $lcmash->get_complement(1);
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$complement_ref = $lcmash->get_complement_ref(1);
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmash->get_Ronly(1);
#}
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmash->get_Ronly_ref(1);
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmash->get_Bonly(1);
#}
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmash->get_Bonly_ref(1);
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@complement = $lcmash->get_complement;
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$complement_ref = $lcmash->get_complement_ref;
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmash->get_Ronly;
#}
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmash->get_Ronly_ref;
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmash->get_Bonly;
#}
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmash->get_Bonly_ref;
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@symmetric_difference = $lcmash->get_symmetric_difference;
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$symmetric_difference_ref = $lcmash->get_symmetric_difference_ref;
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@symmetric_difference = $lcmash->get_symdiff;
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$symmetric_difference_ref = $lcmash->get_symdiff_ref;
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@symmetric_difference = $lcmash->get_LorRonly;
#}
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$symmetric_difference_ref = $lcmash->get_LorRonly_ref;
#}
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@symmetric_difference = $lcmash->get_AorBonly;
#}
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$symmetric_difference_ref = $lcmash->get_AorBonly_ref;
#}
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@nonintersection = $lcmash->get_nonintersection;
#$seen{$_}++ foreach (@nonintersection);
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$nonintersection_ref = $lcmash->get_nonintersection_ref;
#$seen{$_}++ foreach (@{$nonintersection_ref});
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$LR = $lcmash->is_LsubsetR(3,2);
#ok($LR);
#
#$LR = $lcmash->is_AsubsetB(3,2);
#ok($LR);
#
#$LR = $lcmash->is_LsubsetR(2,3);
#ok(! $LR);
#
#$LR = $lcmash->is_AsubsetB(2,3);
#ok(! $LR);
#
#$LR = $lcmash->is_LsubsetR;
#ok(! $LR);
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$RL = $lcmash->is_RsubsetL;
#}
#ok(! $RL);
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$RL = $lcmash->is_BsubsetA;
#}
#ok(! $RL);
#
#$eqv = $lcmash->is_LequivalentR(3,4);
#ok($eqv);
#
#$eqv = $lcmash->is_LeqvlntR(3,4);
#ok($eqv);
#
#$eqv = $lcmash->is_LequivalentR(2,4);
#ok(! $eqv);
#
#$return = $lcmash->print_subset_chart;
#ok($return);
#
#$return = $lcmash->print_equivalence_chart;
#ok($return);
#
#@memb_arr = $lcmash->is_member_which('abel');
#ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));
#
#@memb_arr = $lcmash->is_member_which('baker');
#ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmash->is_member_which('camera');
#ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmash->is_member_which('delta');
#ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmash->is_member_which('edward');
#ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmash->is_member_which('fargo');
#ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#
#@memb_arr = $lcmash->is_member_which('golfer');
#ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#
#@memb_arr = $lcmash->is_member_which('hilton');
#ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#
#@memb_arr = $lcmash->is_member_which('icon');
#ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));
#
#@memb_arr = $lcmash->is_member_which('jerky');
#ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));
#
#@memb_arr = $lcmash->is_member_which('zebra');
#ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));
#
#
#$memb_arr_ref = $lcmash->is_member_which_ref('abel');
#ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('baker');
#ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('camera');
#ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('delta');
#ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('edward');
#ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('fargo');
#ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('golfer');
#ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('hilton');
#ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('icon');
#ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('jerky');
#ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));
#
#$memb_arr_ref = $lcmash->is_member_which_ref('zebra');
#ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));
#
#
#$memb_hash_ref = $lcmash->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));
#
#$memb_hash_ref = $lcmash->are_members_which( [ qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra | ] );
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));
#
#
#ok($lcmash->is_member_any('abel'));
#ok($lcmash->is_member_any('baker'));
#ok($lcmash->is_member_any('camera'));
#ok($lcmash->is_member_any('delta'));
#ok($lcmash->is_member_any('edward'));
#ok($lcmash->is_member_any('fargo'));
#ok($lcmash->is_member_any('golfer'));
#ok($lcmash->is_member_any('hilton'));
#ok($lcmash->is_member_any('icon' ));
#ok($lcmash->is_member_any('jerky'));
#ok(! $lcmash->is_member_any('zebra'));
#
#$memb_hash_ref = $lcmash->are_members_any(qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra |);
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));
#
#$memb_hash_ref = $lcmash->are_members_any( [ qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra | ] );
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));
#
#$vers = $lcmash->get_version;
#ok($vers);
#
########### BELOW:  Tests for '-u' option ##########
#
#my $lcmashu   = List::Compare::SeenHash->new('-u', \%h0, \%h1, \%h2, \%h3, \%h4);
#ok($lcmashu);
#
#@union = $lcmashu->get_union;
#$seen{$_}++ foreach (@union);
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$union_ref = $lcmashu->get_union_ref;
#$seen{$_}++ foreach (@{$union_ref});
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@shared = $lcmashu->get_shared;
#$seen{$_}++ foreach (@shared);
#ok(! exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$shared_ref = $lcmashu->get_shared_ref;
#$seen{$_}++ foreach (@{$shared_ref});
#ok(! exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@intersection = $lcmashu->get_intersection;
#$seen{$_}++ foreach (@intersection);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$intersection_ref = $lcmashu->get_intersection_ref;
#$seen{$_}++ foreach (@{$intersection_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(exists $seen{'fargo'});
#ok(exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@unique = $lcmashu->get_unique(2);
#$seen{$_}++ foreach (@unique);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$unique_ref = $lcmashu->get_unique_ref(2);
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmashu->get_Lonly_ref(2);
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmashu->get_Aonly(2);
#}
#$seen{$_}++ foreach (@unique);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmashu->get_Aonly_ref(2);
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@unique = $lcmashu->get_unique;
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#$unique_ref = $lcmashu->get_unique_ref;
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmashu->get_Lonly;
#}
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmashu->get_Lonly_ref;
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@unique = $lcmashu->get_Aonly;
#}
#$seen{$_}++ foreach (@unique);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$unique_ref = $lcmashu->get_Aonly_ref;
#}
#$seen{$_}++ foreach (@{$unique_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(! exists $seen{'jerky'});
#%seen = ();
#
#@complement = $lcmashu->get_complement(1);
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$complement_ref = $lcmashu->get_complement_ref(1);
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmashu->get_Ronly(1);
#}
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmashu->get_Ronly_ref(1);
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmashu->get_Bonly(1);
#}
#$seen{$_}++ foreach (@complement);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmashu->get_Bonly_ref(1);
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@complement = $lcmashu->get_complement;
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$complement_ref = $lcmashu->get_complement_ref;
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmashu->get_Ronly;
#}
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmashu->get_Ronly_ref;
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@complement = $lcmashu->get_Bonly;
#}
#$seen{$_}++ foreach (@complement);
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$complement_ref = $lcmashu->get_Bonly_ref;
#}
#$seen{$_}++ foreach (@{$complement_ref});
#ok(! exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@symmetric_difference = $lcmashu->get_symmetric_difference;
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$symmetric_difference_ref = $lcmashu->get_symmetric_difference_ref;
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@symmetric_difference = $lcmashu->get_symdiff;
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$symmetric_difference_ref = $lcmashu->get_symdiff_ref;
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@symmetric_difference = $lcmashu->get_LorRonly;
#}
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$symmetric_difference_ref = $lcmashu->get_LorRonly_ref;
#}
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	@symmetric_difference = $lcmashu->get_AorBonly;
#}
#$seen{$_}++ foreach (@symmetric_difference);
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$symmetric_difference_ref = $lcmashu->get_AorBonly_ref;
#}
#$seen{$_}++ foreach (@{$symmetric_difference_ref});
#ok(exists $seen{'abel'});
#ok(! exists $seen{'baker'});
#ok(! exists $seen{'camera'});
#ok(! exists $seen{'delta'});
#ok(! exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(! exists $seen{'hilton'});
#ok(! exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#@nonintersection = $lcmashu->get_nonintersection;
#$seen{$_}++ foreach (@nonintersection);
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$nonintersection_ref = $lcmashu->get_nonintersection_ref;
#$seen{$_}++ foreach (@{$nonintersection_ref});
#ok(exists $seen{'abel'});
#ok(exists $seen{'baker'});
#ok(exists $seen{'camera'});
#ok(exists $seen{'delta'});
#ok(exists $seen{'edward'});
#ok(! exists $seen{'fargo'});
#ok(! exists $seen{'golfer'});
#ok(exists $seen{'hilton'});
#ok(exists $seen{'icon'});
#ok(exists $seen{'jerky'});
#%seen = ();
#
#$LR = $lcmashu->is_LsubsetR(3,2);
#ok($LR);
#
#$LR = $lcmashu->is_AsubsetB(3,2);
#ok($LR);
#
#$LR = $lcmashu->is_LsubsetR(2,3);
#ok(! $LR);
#
#$LR = $lcmashu->is_AsubsetB(2,3);
#ok(! $LR);
#
#$LR = $lcmashu->is_LsubsetR;
#ok(! $LR);
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$RL = $lcmashu->is_RsubsetL;
#}
#ok(! $RL);
#
#{
#	local $SIG{__WARN__} = \&_capture;
#	$RL = $lcmashu->is_BsubsetA;
#}
#ok(! $RL);
#
#$eqv = $lcmashu->is_LequivalentR(3,4);
#ok($eqv);
#
#$eqv = $lcmashu->is_LeqvlntR(3,4);
#ok($eqv);
#
#$eqv = $lcmashu->is_LequivalentR(2,4);
#ok(! $eqv);
#
#$return = $lcmashu->print_subset_chart;
#ok($return);
#
#$return = $lcmashu->print_equivalence_chart;
#ok($return);
#
#@memb_arr = $lcmashu->is_member_which('abel');
#ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));
#
#@memb_arr = $lcmashu->is_member_which('baker');
#ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmashu->is_member_which('camera');
#ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmashu->is_member_which('delta');
#ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmashu->is_member_which('edward');
#ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));
#
#@memb_arr = $lcmashu->is_member_which('fargo');
#ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#
#@memb_arr = $lcmashu->is_member_which('golfer');
#ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#
#@memb_arr = $lcmashu->is_member_which('hilton');
#ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#
#@memb_arr = $lcmashu->is_member_which('icon');
#ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));
#
#@memb_arr = $lcmashu->is_member_which('jerky');
#ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));
#
#@memb_arr = $lcmashu->is_member_which('zebra');
#ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));
#
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('abel');
#ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('baker');
#ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('camera');
#ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('delta');
#ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('edward');
#ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('fargo');
#ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('golfer');
#ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('hilton');
#ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('icon');
#ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('jerky');
#ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));
#
#$memb_arr_ref = $lcmashu->is_member_which_ref('zebra');
#ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));
#
#
#$memb_hash_ref = $lcmashu->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));
#
#$memb_hash_ref = $lcmashu->are_members_which( [ qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra | ] );
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));
#
#
#ok($lcmashu->is_member_any('abel'));
#ok($lcmashu->is_member_any('baker'));
#ok($lcmashu->is_member_any('camera'));
#ok($lcmashu->is_member_any('delta'));
#ok($lcmashu->is_member_any('edward'));
#ok($lcmashu->is_member_any('fargo'));
#ok($lcmashu->is_member_any('golfer'));
#ok($lcmashu->is_member_any('hilton'));
#ok($lcmashu->is_member_any('icon' ));
#ok($lcmashu->is_member_any('jerky'));
#ok(! $lcmashu->is_member_any('zebra'));
#
#$memb_hash_ref = $lcmashu->are_members_any(qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra |);
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));
#
#$memb_hash_ref = $lcmashu->are_members_any( [ qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra | ] );
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));
#
#$vers = $lcmashu->get_version;
#ok($vers);
#
########### BELOW:  Tests for '--unsorted' option ##########
#
#my $lcmashun   = List::Compare::SeenHash->new('--unsorted', \%h0, \%h1, \%h2, \%h3, \%h4);
#ok($lcmashun);
#
########### BELOW:  Tests for bad values in seen-hash ##########
#
#my ($f5, $f6, $f7);
#
#eval { $f5 = List::Compare::SeenHash->new(\%h0, \%h5, \%h6) };
#ok(ok_capture_error($@));
#
#eval { $f6 = List::Compare::SeenHash->new(\%h0, \%h6, \%h7) };
#ok(ok_capture_error($@));
#
#eval { $f7 = List::Compare::SeenHash->new(\%h6, \%h7, \%h0) };
#ok(ok_capture_error($@));
#
#
