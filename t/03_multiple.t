# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 225; $| = 1; print "1..$last_test_to_print\n"; } # 7/24/2002
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

my $lcm   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcm);                               # 2

@union = $lcm->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 3
ok(exists $seen{'baker'});              # 4
ok(exists $seen{'camera'});             # 5
ok(exists $seen{'delta'});              # 6
ok(exists $seen{'edward'});             # 7
ok(exists $seen{'fargo'});              # 8
ok(exists $seen{'golfer'});             # 9
ok(exists $seen{'hilton'});             # 10
ok(exists $seen{'icon'});               # 11
ok(exists $seen{'jerky'});              # 12
%seen = ();

@intersection = $lcm->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 13
ok(! exists $seen{'baker'});            # 14
ok(! exists $seen{'camera'});           # 15
ok(! exists $seen{'delta'});            # 16
ok(! exists $seen{'edward'});           # 17
ok(exists $seen{'fargo'});              # 18
ok(exists $seen{'golfer'});             # 19
ok(! exists $seen{'hilton'});           # 20
ok(! exists $seen{'icon'});             # 21
ok(! exists $seen{'jerky'});            # 22
%seen = ();

@nonintersection = $lcm->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 23
ok(exists $seen{'baker'});              # 24
ok(exists $seen{'camera'});             # 25
ok(exists $seen{'delta'});              # 26
ok(exists $seen{'edward'});             # 27
ok(! exists $seen{'fargo'});            # 28
ok(! exists $seen{'golfer'});           # 29
ok(exists $seen{'hilton'});             # 30
ok(exists $seen{'icon'});               # 31
ok(exists $seen{'jerky'});              # 32
%seen = ();

@unique = $lcm->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 33
ok(! exists $seen{'baker'});            # 34
ok(! exists $seen{'camera'});           # 35
ok(! exists $seen{'delta'});            # 36
ok(! exists $seen{'edward'});           # 37
ok(! exists $seen{'fargo'});            # 38
ok(! exists $seen{'golfer'});           # 39
ok(! exists $seen{'hilton'});           # 40
ok(! exists $seen{'icon'});             # 41
ok(exists $seen{'jerky'});              # 42
%seen = ();

@unique = $lcm->get_Lonly(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 43
ok(! exists $seen{'baker'});            # 44
ok(! exists $seen{'camera'});           # 45
ok(! exists $seen{'delta'});            # 46
ok(! exists $seen{'edward'});           # 47
ok(! exists $seen{'fargo'});            # 48
ok(! exists $seen{'golfer'});           # 49
ok(! exists $seen{'hilton'});           # 50
ok(! exists $seen{'icon'});             # 51
ok(exists $seen{'jerky'});              # 52
%seen = ();

@unique = $lcm->get_Aonly(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 53
ok(! exists $seen{'baker'});            # 54
ok(! exists $seen{'camera'});           # 55
ok(! exists $seen{'delta'});            # 56
ok(! exists $seen{'edward'});           # 57
ok(! exists $seen{'fargo'});            # 58
ok(! exists $seen{'golfer'});           # 59
ok(! exists $seen{'hilton'});           # 60
ok(! exists $seen{'icon'});             # 61
ok(exists $seen{'jerky'});              # 62
%seen = ();

@unique = $lcm->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 63
ok(! exists $seen{'baker'});            # 64
ok(! exists $seen{'camera'});           # 65
ok(! exists $seen{'delta'});            # 66
ok(! exists $seen{'edward'});           # 67
ok(! exists $seen{'fargo'});            # 68
ok(! exists $seen{'golfer'});           # 69
ok(! exists $seen{'hilton'});           # 70
ok(! exists $seen{'icon'});             # 71
ok(! exists $seen{'jerky'});            # 72
%seen = ();

@unique = $lcm->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 73
ok(! exists $seen{'baker'});            # 74
ok(! exists $seen{'camera'});           # 75
ok(! exists $seen{'delta'});            # 76
ok(! exists $seen{'edward'});           # 77
ok(! exists $seen{'fargo'});            # 78
ok(! exists $seen{'golfer'});           # 79
ok(! exists $seen{'hilton'});           # 80
ok(! exists $seen{'icon'});             # 81
ok(! exists $seen{'jerky'});            # 82
%seen = ();

@unique = $lcm->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 83
ok(! exists $seen{'baker'});            # 84
ok(! exists $seen{'camera'});           # 85
ok(! exists $seen{'delta'});            # 86
ok(! exists $seen{'edward'});           # 87
ok(! exists $seen{'fargo'});            # 88
ok(! exists $seen{'golfer'});           # 89
ok(! exists $seen{'hilton'});           # 90
ok(! exists $seen{'icon'});             # 91
ok(! exists $seen{'jerky'});            # 92
%seen = ();

@complement = $lcm->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 93
ok(! exists $seen{'baker'});            # 94
ok(! exists $seen{'camera'});           # 95
ok(! exists $seen{'delta'});            # 96
ok(! exists $seen{'edward'});           # 97
ok(! exists $seen{'fargo'});            # 98
ok(! exists $seen{'golfer'});           # 99
ok(! exists $seen{'hilton'});           # 100
ok(exists $seen{'icon'});               # 101
ok(exists $seen{'jerky'});              # 102
%seen = ();

@complement = $lcm->get_Ronly(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 103
ok(! exists $seen{'baker'});            # 104
ok(! exists $seen{'camera'});           # 105
ok(! exists $seen{'delta'});            # 106
ok(! exists $seen{'edward'});           # 107
ok(! exists $seen{'fargo'});            # 108
ok(! exists $seen{'golfer'});           # 109
ok(! exists $seen{'hilton'});           # 110
ok(exists $seen{'icon'});               # 111
ok(exists $seen{'jerky'});              # 112
%seen = ();

@complement = $lcm->get_Bonly(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 113
ok(! exists $seen{'baker'});            # 114
ok(! exists $seen{'camera'});           # 115
ok(! exists $seen{'delta'});            # 116
ok(! exists $seen{'edward'});           # 117
ok(! exists $seen{'fargo'});            # 118
ok(! exists $seen{'golfer'});           # 119
ok(! exists $seen{'hilton'});           # 120
ok(exists $seen{'icon'});               # 121
ok(exists $seen{'jerky'});              # 122
%seen = ();

@complement = $lcm->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 123
ok(! exists $seen{'baker'});            # 124
ok(! exists $seen{'camera'});           # 125
ok(! exists $seen{'delta'});            # 126
ok(! exists $seen{'edward'});           # 127
ok(! exists $seen{'fargo'});            # 128
ok(! exists $seen{'golfer'});           # 129
ok(exists $seen{'hilton'});             # 130
ok(exists $seen{'icon'});               # 131
ok(exists $seen{'jerky'});              # 132
%seen = ();

@complement = $lcm->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 133
ok(! exists $seen{'baker'});            # 134
ok(! exists $seen{'camera'});           # 135
ok(! exists $seen{'delta'});            # 136
ok(! exists $seen{'edward'});           # 137
ok(! exists $seen{'fargo'});            # 138
ok(! exists $seen{'golfer'});           # 139
ok(exists $seen{'hilton'});             # 140
ok(exists $seen{'icon'});               # 141
ok(exists $seen{'jerky'});              # 142
%seen = ();

@complement = $lcm->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 143
ok(! exists $seen{'baker'});            # 144
ok(! exists $seen{'camera'});           # 145
ok(! exists $seen{'delta'});            # 146
ok(! exists $seen{'edward'});           # 147
ok(! exists $seen{'fargo'});            # 148
ok(! exists $seen{'golfer'});           # 149
ok(exists $seen{'hilton'});             # 150
ok(exists $seen{'icon'});               # 151
ok(exists $seen{'jerky'});              # 152
%seen = ();

@symmetric_difference = $lcm->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 153
ok(! exists $seen{'baker'});            # 154
ok(! exists $seen{'camera'});           # 155
ok(! exists $seen{'delta'});            # 156
ok(! exists $seen{'edward'});           # 157
ok(! exists $seen{'fargo'});            # 158
ok(! exists $seen{'golfer'});           # 159
ok(! exists $seen{'hilton'});           # 160
ok(! exists $seen{'icon'});             # 161
ok(exists $seen{'jerky'});              # 162
%seen = ();

@symmetric_difference = $lcm->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 163
ok(! exists $seen{'baker'});            # 164
ok(! exists $seen{'camera'});           # 165
ok(! exists $seen{'delta'});            # 166
ok(! exists $seen{'edward'});           # 167
ok(! exists $seen{'fargo'});            # 168
ok(! exists $seen{'golfer'});           # 169
ok(! exists $seen{'hilton'});           # 170
ok(! exists $seen{'icon'});             # 171
ok(exists $seen{'jerky'});              # 172
%seen = ();

@symmetric_difference = $lcm->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 173
ok(! exists $seen{'baker'});            # 174
ok(! exists $seen{'camera'});           # 175
ok(! exists $seen{'delta'});            # 176
ok(! exists $seen{'edward'});           # 177
ok(! exists $seen{'fargo'});            # 178
ok(! exists $seen{'golfer'});           # 179
ok(! exists $seen{'hilton'});           # 180
ok(! exists $seen{'icon'});             # 181
ok(exists $seen{'jerky'});              # 182
%seen = ();

@symmetric_difference = $lcm->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 183
ok(! exists $seen{'baker'});            # 184
ok(! exists $seen{'camera'});           # 185
ok(! exists $seen{'delta'});            # 186
ok(! exists $seen{'edward'});           # 187
ok(! exists $seen{'fargo'});            # 188
ok(! exists $seen{'golfer'});           # 189
ok(! exists $seen{'hilton'});           # 190
ok(! exists $seen{'icon'});             # 191
ok(exists $seen{'jerky'});              # 192
%seen = ();

@shared = $lcm->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 193
ok(exists $seen{'baker'});              # 194
ok(exists $seen{'camera'});             # 195
ok(exists $seen{'delta'});              # 196
ok(exists $seen{'edward'});             # 197
ok(exists $seen{'fargo'});              # 198
ok(exists $seen{'golfer'});             # 199
ok(exists $seen{'hilton'});             # 200
ok(exists $seen{'icon'});               # 201
ok(! exists $seen{'jerky'});            # 202
%seen = ();

@bag = $lcm->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 203
ok($seen{'baker'} == 2);                # 204
ok($seen{'camera'} == 2);               # 205
ok($seen{'delta'} == 3);                # 206
ok($seen{'edward'} == 2);               # 207
ok($seen{'fargo'} == 6);                # 208
ok($seen{'golfer'} == 5);               # 209
ok($seen{'hilton'} == 4);               # 210
ok($seen{'icon'} == 5);                 # 211
ok($seen{'jerky'} == 1);                # 212
%seen = ();

$LR = $lcm->is_LsubsetR(3,2);
ok($LR);                                # 213

$LR = $lcm->is_AsubsetB(3,2);
ok($LR);                                # 214

$LR = $lcm->is_LsubsetR(2,3);
ok(! $LR);                              # 215

$LR = $lcm->is_AsubsetB(2,3);
ok(! $LR);                              # 216

$LR = $lcm->is_LsubsetR;
ok(! $LR);                              # 217

$RL = $lcm->is_RsubsetL;
ok(! $RL);                              # 218

$RL = $lcm->is_BsubsetA;
ok(! $RL);                              # 219

$eqv = $lcm->is_LequivalentR(3,4);
ok($eqv);                               # 220

$eqv = $lcm->is_LeqvlntR(3,4);
ok($eqv);                               # 221

$eqv = $lcm->is_LequivalentR(2,4);
ok(! $eqv);                             # 222

$return = $lcm->print_subset_chart;
ok($return);                            # 223

$return = $lcm->print_equivalence_chart;
ok($return);                            # 224

$vers = $lcm->get_version;
ok($vers);                              # 225

#################################### Done to here: Sun Jul 21 10:31:56 EDT 2002
### But I don't yet have a good test of the print_..._chart methods


sub ok {
	my $condition = shift;
	print $condition ? "ok $testnum\n" : "not ok $testnum\n";
	$testnum++;
}

