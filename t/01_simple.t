# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 151; $| = 1; print "1..$last_test_to_print\n"; } # 7/24/2002
END {print "not ok 1\n" unless $loaded;}
use List::Compare;
$loaded = 1;
my $testnum = 1;
ok($loaded);	                           # 1

######################### End of black magic.

my %seen = ();
my @unique = my @complement = my @intersection = my @union = my @symmetric_difference = my @bag = ();
my ($LR, $RL, $eqv, $return);
my @nonintersection = my @shared = ();

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);

my $lc    = List::Compare->new(\@a0, \@a1);

ok($lc);                                # 2

@union = $lc->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 3
ok(exists $seen{'baker'});              # 4
ok(exists $seen{'camera'});             # 5
ok(exists $seen{'delta'});              # 6
ok(exists $seen{'edward'});             # 7
ok(exists $seen{'fargo'});              # 8
ok(exists $seen{'golfer'});             # 9
ok(exists $seen{'hilton'});             # 10
ok(! exists $seen{'icon'});             # 11
ok(! exists $seen{'jerky'});            # 12
%seen = ();

@intersection = $lc->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 13
ok(exists $seen{'baker'});              # 14
ok(exists $seen{'camera'});             # 15
ok(exists $seen{'delta'});              # 16
ok(exists $seen{'edward'});             # 17
ok(exists $seen{'fargo'});              # 18
ok(exists $seen{'golfer'});             # 19
ok(! exists $seen{'hilton'});           # 20
ok(! exists $seen{'icon'});             # 21
ok(! exists $seen{'jerky'});            # 22
%seen = ();

@unique = $lc->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 23
ok(! exists $seen{'baker'});            # 24
ok(! exists $seen{'camera'});           # 25
ok(! exists $seen{'delta'});            # 26
ok(! exists $seen{'edward'});           # 27
ok(! exists $seen{'fargo'});            # 28
ok(! exists $seen{'golfer'});           # 29
ok(! exists $seen{'hilton'});           # 30
ok(! exists $seen{'icon'});             # 31
ok(! exists $seen{'jerky'});            # 32
%seen = ();

@unique = $lc->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 33
ok(! exists $seen{'baker'});            # 34
ok(! exists $seen{'camera'});           # 35
ok(! exists $seen{'delta'});            # 36
ok(! exists $seen{'edward'});           # 37
ok(! exists $seen{'fargo'});            # 38
ok(! exists $seen{'golfer'});           # 39
ok(! exists $seen{'hilton'});           # 40
ok(! exists $seen{'icon'});             # 41
ok(! exists $seen{'jerky'});            # 42
%seen = ();

@unique = $lc->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 43
ok(! exists $seen{'baker'});            # 44
ok(! exists $seen{'camera'});           # 45
ok(! exists $seen{'delta'});            # 46
ok(! exists $seen{'edward'});           # 47
ok(! exists $seen{'fargo'});            # 48
ok(! exists $seen{'golfer'});           # 49
ok(! exists $seen{'hilton'});           # 50
ok(! exists $seen{'icon'});             # 51
ok(! exists $seen{'jerky'});            # 52
%seen = ();

@complement = $lc->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 53
ok(! exists $seen{'baker'});            # 54
ok(! exists $seen{'camera'});           # 55
ok(! exists $seen{'delta'});            # 56
ok(! exists $seen{'edward'});           # 57
ok(! exists $seen{'fargo'});            # 58
ok(! exists $seen{'golfer'});           # 59
ok(exists $seen{'hilton'});             # 60
ok(! exists $seen{'icon'});             # 61
ok(! exists $seen{'jerky'});            # 62
%seen = ();

@complement = $lc->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 63
ok(! exists $seen{'baker'});            # 64
ok(! exists $seen{'camera'});           # 65
ok(! exists $seen{'delta'});            # 66
ok(! exists $seen{'edward'});           # 67
ok(! exists $seen{'fargo'});            # 68
ok(! exists $seen{'golfer'});           # 69
ok(exists $seen{'hilton'});             # 70
ok(! exists $seen{'icon'});             # 71
ok(! exists $seen{'jerky'});            # 72
%seen = ();

@complement = $lc->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 73
ok(! exists $seen{'baker'});            # 74
ok(! exists $seen{'camera'});           # 75
ok(! exists $seen{'delta'});            # 76
ok(! exists $seen{'edward'});           # 77
ok(! exists $seen{'fargo'});            # 78
ok(! exists $seen{'golfer'});           # 79
ok(exists $seen{'hilton'});             # 80
ok(! exists $seen{'icon'});             # 81
ok(! exists $seen{'jerky'});            # 82
%seen = ();

@symmetric_difference = $lc->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 83
ok(! exists $seen{'baker'});            # 84
ok(! exists $seen{'camera'});           # 85
ok(! exists $seen{'delta'});            # 86
ok(! exists $seen{'edward'});           # 87
ok(! exists $seen{'fargo'});            # 88
ok(! exists $seen{'golfer'});           # 89
ok(exists $seen{'hilton'});             # 90
ok(! exists $seen{'icon'});             # 91
ok(! exists $seen{'jerky'});            # 92
%seen = ();

@symmetric_difference = $lc->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 93
ok(! exists $seen{'baker'});            # 94
ok(! exists $seen{'camera'});           # 95
ok(! exists $seen{'delta'});            # 96
ok(! exists $seen{'edward'});           # 97
ok(! exists $seen{'fargo'});            # 98
ok(! exists $seen{'golfer'});           # 99
ok(exists $seen{'hilton'});             # 100
ok(! exists $seen{'icon'});             # 101
ok(! exists $seen{'jerky'});            # 102
%seen = ();

@symmetric_difference = $lc->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 103
ok(! exists $seen{'baker'});            # 104
ok(! exists $seen{'camera'});           # 105
ok(! exists $seen{'delta'});            # 106
ok(! exists $seen{'edward'});           # 107
ok(! exists $seen{'fargo'});            # 108
ok(! exists $seen{'golfer'});           # 109
ok(exists $seen{'hilton'});             # 110
ok(! exists $seen{'icon'});             # 111
ok(! exists $seen{'jerky'});            # 112
%seen = ();

@symmetric_difference = $lc->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 113
ok(! exists $seen{'baker'});            # 114
ok(! exists $seen{'camera'});           # 115
ok(! exists $seen{'delta'});            # 116
ok(! exists $seen{'edward'});           # 117
ok(! exists $seen{'fargo'});            # 118
ok(! exists $seen{'golfer'});           # 119
ok(exists $seen{'hilton'});             # 120
ok(! exists $seen{'icon'});             # 121
ok(! exists $seen{'jerky'});            # 122
%seen = ();

@bag = $lc->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 123
ok($seen{'baker'} == 2);                # 124
ok($seen{'camera'} == 2);               # 125
ok($seen{'delta'} == 3);                # 126
ok($seen{'edward'} == 2);               # 127
ok($seen{'fargo'} == 2);                # 128
ok($seen{'golfer'} == 2);               # 129
ok($seen{'hilton'} == 1);               # 130
ok(! exists $seen{'icon'});             # 131
ok(! exists $seen{'jerky'});            # 132
%seen = ();

$LR = $lc->is_LsubsetR;
ok(! $LR);                              # 133

$LR = $lc->is_AsubsetB;
ok(! $LR);                              # 134

$RL = $lc->is_RsubsetL;
ok(! $RL);                              # 135

$RL = $lc->is_BsubsetA;
ok(! $RL);                              # 136

$eqv = $lc->is_LequivalentR;
ok(! $eqv);                             # 137

$eqv = $lc->is_LeqvlntR;
ok(! $eqv);                             # 138

$return = $lc->print_subset_chart;
ok($return);                            # 139

$return = $lc->print_equivalence_chart;
ok($return);                            # 140

$vers = $lc->get_version;
ok($vers);                              # 141

my $lc_s  = List::Compare->new(\@a2, \@a3);

ok($lc_s);                              # 142

$LR = $lc_s->is_LsubsetR;
ok(! $LR);                              # 143

$LR = $lc_s->is_AsubsetB;
ok(! $LR);                              # 144

$RL = $lc_s->is_RsubsetL;
ok($RL);                                # 145

$RL = $lc_s->is_BsubsetA;
ok($RL);                                # 146

$eqv = $lc_s->is_LequivalentR;
ok(! $eqv);                             # 147

$eqv = $lc_s->is_LeqvlntR;
ok(! $eqv);                             # 148

my $lc_e  = List::Compare->new(\@a3, \@a4);

ok($lc_e);                              # 149

$eqv = $lc_e->is_LequivalentR;
ok($eqv);                               # 150

$eqv = $lc_e->is_LeqvlntR;
ok($eqv);                               # 151


sub ok {
	my $condition = shift;
	print $condition ? "ok $testnum\n" : "not ok $testnum\n";
	$testnum++;
}
