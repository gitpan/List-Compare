# 28_alt_functional_multiple_sh.t # as of 05/08/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
532;
use lib ("./t");
use List::Compare;
use List::Compare::Functional qw(:originals :aliases);
use Test::ListCompareSpecial;
use Test::ListCompareSpecial qw(:seen);

$loaded = 1;
ok($loaded);                            # 1

######################### End of black magic.

my %seen = ();
my (@unique, @complement, @intersection, @union, @symmetric_difference, @bag);
my ($unique_ref, $complement_ref, $intersection_ref, $union_ref, $symmetric_difference_ref, $bag_ref);
my ($LR, $RL, $eqv, $disj, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);
my @a8 = qw(kappa lambda mu);

my (%h0, %h1, %h2, %h3, %h4);
$h0{$_}++ for @a0;
$h1{$_}++ for @a1;
$h2{$_}++ for @a2;
$h3{$_}++ for @a3;
$h4{$_}++ for @a4;
$h8{$_}++ for @a8;

# FIRST UNION
@union = get_union( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 2
ok(exists $seen{'baker'});              # 3
ok(exists $seen{'camera'});             # 4
ok(exists $seen{'delta'});              # 5
ok(exists $seen{'edward'});             # 6
ok(exists $seen{'fargo'});              # 7
ok(exists $seen{'golfer'});             # 8
ok(exists $seen{'hilton'});             # 9
ok(exists $seen{'icon'});               # 10
ok(exists $seen{'jerky'});              # 11
%seen = ();

$union_ref = get_union_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 12
ok(exists $seen{'baker'});              # 13
ok(exists $seen{'camera'});             # 14
ok(exists $seen{'delta'});              # 15
ok(exists $seen{'edward'});             # 16
ok(exists $seen{'fargo'});              # 17
ok(exists $seen{'golfer'});             # 18
ok(exists $seen{'hilton'});             # 19
ok(exists $seen{'icon'});               # 20
ok(exists $seen{'jerky'});              # 21
%seen = ();
# FIRST SHARED
@shared = get_shared( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 22
ok(exists $seen{'baker'});              # 23
ok(exists $seen{'camera'});             # 24
ok(exists $seen{'delta'});              # 25
ok(exists $seen{'edward'});             # 26
ok(exists $seen{'fargo'});              # 27
ok(exists $seen{'golfer'});             # 28
ok(exists $seen{'hilton'});             # 29
ok(exists $seen{'icon'});               # 30
ok(! exists $seen{'jerky'});            # 31
%seen = ();

$shared_ref = get_shared_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 32
ok(exists $seen{'baker'});              # 33
ok(exists $seen{'camera'});             # 34
ok(exists $seen{'delta'});              # 35
ok(exists $seen{'edward'});             # 36
ok(exists $seen{'fargo'});              # 37
ok(exists $seen{'golfer'});             # 38
ok(exists $seen{'hilton'});             # 39
ok(exists $seen{'icon'});               # 40
ok(! exists $seen{'jerky'});            # 41
%seen = ();
# FIRST INTERSECTION
@intersection = get_intersection( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 42
ok(! exists $seen{'baker'});            # 43
ok(! exists $seen{'camera'});           # 44
ok(! exists $seen{'delta'});            # 45
ok(! exists $seen{'edward'});           # 46
ok(exists $seen{'fargo'});              # 47
ok(exists $seen{'golfer'});             # 48
ok(! exists $seen{'hilton'});           # 49
ok(! exists $seen{'icon'});             # 50
ok(! exists $seen{'jerky'});            # 51
%seen = ();

$intersection_ref = get_intersection_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 52
ok(! exists $seen{'baker'});            # 53
ok(! exists $seen{'camera'});           # 54
ok(! exists $seen{'delta'});            # 55
ok(! exists $seen{'edward'});           # 56
ok(exists $seen{'fargo'});              # 57
ok(exists $seen{'golfer'});             # 58
ok(! exists $seen{'hilton'});           # 59
ok(! exists $seen{'icon'});             # 60
ok(! exists $seen{'jerky'});            # 61
%seen = ();
# FIRST UNIQUE
@unique = get_unique( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 62
ok(! exists $seen{'baker'});            # 63
ok(! exists $seen{'camera'});           # 64
ok(! exists $seen{'delta'});            # 65
ok(! exists $seen{'edward'});           # 66
ok(! exists $seen{'fargo'});            # 67
ok(! exists $seen{'golfer'});           # 68
ok(! exists $seen{'hilton'});           # 69
ok(! exists $seen{'icon'});             # 70
ok(! exists $seen{'jerky'});            # 71
%seen = ();

$unique_ref = get_unique_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 72
ok(! exists $seen{'baker'});            # 73
ok(! exists $seen{'camera'});           # 74
ok(! exists $seen{'delta'});            # 75
ok(! exists $seen{'edward'});           # 76
ok(! exists $seen{'fargo'});            # 77
ok(! exists $seen{'golfer'});           # 78
ok(! exists $seen{'hilton'});           # 79
ok(! exists $seen{'icon'});             # 80
ok(! exists $seen{'jerky'});            # 81
%seen = ();

@unique = get_unique( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 2 } );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 82
ok(! exists $seen{'baker'});            # 83
ok(! exists $seen{'camera'});           # 84
ok(! exists $seen{'delta'});            # 85
ok(! exists $seen{'edward'});           # 86
ok(! exists $seen{'fargo'});            # 87
ok(! exists $seen{'golfer'});           # 88
ok(! exists $seen{'hilton'});           # 89
ok(! exists $seen{'icon'});             # 90
ok(exists $seen{'jerky'});              # 91
%seen = ();

$unique_ref = get_unique_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 2 } );
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 92
ok(! exists $seen{'baker'});            # 93
ok(! exists $seen{'camera'});           # 94
ok(! exists $seen{'delta'});            # 95
ok(! exists $seen{'edward'});           # 96
ok(! exists $seen{'fargo'});            # 97
ok(! exists $seen{'golfer'});           # 98
ok(! exists $seen{'hilton'});           # 99
ok(! exists $seen{'icon'});             # 100
ok(exists $seen{'jerky'});              # 101
%seen = ();
# FIRST COMPLEMENT
@complement = get_complement( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 102
ok(! exists $seen{'baker'});            # 103
ok(! exists $seen{'camera'});           # 104
ok(! exists $seen{'delta'});            # 105
ok(! exists $seen{'edward'});           # 106
ok(! exists $seen{'fargo'});            # 107
ok(! exists $seen{'golfer'});           # 108
ok(exists $seen{'hilton'});             # 109
ok(exists $seen{'icon'});               # 110
ok(exists $seen{'jerky'});              # 111
%seen = ();

$complement_ref = get_complement_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 112
ok(! exists $seen{'baker'});            # 113
ok(! exists $seen{'camera'});           # 114
ok(! exists $seen{'delta'});            # 115
ok(! exists $seen{'edward'});           # 116
ok(! exists $seen{'fargo'});            # 117
ok(! exists $seen{'golfer'});           # 118
ok(exists $seen{'hilton'});             # 119
ok(exists $seen{'icon'});               # 120
ok(exists $seen{'jerky'});              # 121
%seen = ();

@complement = get_complement( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 3 } );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 122
ok(exists $seen{'baker'});              # 123
ok(exists $seen{'camera'});             # 124
ok(exists $seen{'delta'});              # 125
ok(exists $seen{'edward'});             # 126
ok(! exists $seen{'fargo'});            # 127
ok(! exists $seen{'golfer'});           # 128
ok(! exists $seen{'hilton'});           # 129
ok(! exists $seen{'icon'});             # 130
ok(exists $seen{'jerky'});              # 131
%seen = ();

$complement_ref = get_complement_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 3 } );
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 132
ok(exists $seen{'baker'});              # 133
ok(exists $seen{'camera'});             # 134
ok(exists $seen{'delta'});              # 135
ok(exists $seen{'edward'});             # 136
ok(! exists $seen{'fargo'});            # 137
ok(! exists $seen{'golfer'});           # 138
ok(! exists $seen{'hilton'});           # 139
ok(! exists $seen{'icon'});             # 140
ok(exists $seen{'jerky'});              # 141
%seen = ();
# FIRST SYMMETRIC DIFFERENCE
@symmetric_difference = get_symmetric_difference( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 142
ok(! exists $seen{'baker'});            # 143
ok(! exists $seen{'camera'});           # 144
ok(! exists $seen{'delta'});            # 145
ok(! exists $seen{'edward'});           # 146
ok(! exists $seen{'fargo'});            # 147
ok(! exists $seen{'golfer'});           # 148
ok(! exists $seen{'hilton'});           # 149
ok(! exists $seen{'icon'});             # 150
ok(exists $seen{'jerky'});              # 151
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 152
ok(! exists $seen{'baker'});            # 153
ok(! exists $seen{'camera'});           # 154
ok(! exists $seen{'delta'});            # 155
ok(! exists $seen{'edward'});           # 156
ok(! exists $seen{'fargo'});            # 157
ok(! exists $seen{'golfer'});           # 158
ok(! exists $seen{'hilton'});           # 159
ok(! exists $seen{'icon'});             # 160
ok(exists $seen{'jerky'});              # 161
%seen = ();

@symmetric_difference = get_symdiff( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 162
ok(! exists $seen{'baker'});            # 163
ok(! exists $seen{'camera'});           # 164
ok(! exists $seen{'delta'});            # 165
ok(! exists $seen{'edward'});           # 166
ok(! exists $seen{'fargo'});            # 167
ok(! exists $seen{'golfer'});           # 168
ok(! exists $seen{'hilton'});           # 169
ok(! exists $seen{'icon'});             # 170
ok(exists $seen{'jerky'});              # 171
%seen = ();

$symmetric_difference_ref = get_symdiff_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 172
ok(! exists $seen{'baker'});            # 173
ok(! exists $seen{'camera'});           # 174
ok(! exists $seen{'delta'});            # 175
ok(! exists $seen{'edward'});           # 176
ok(! exists $seen{'fargo'});            # 177
ok(! exists $seen{'golfer'});           # 178
ok(! exists $seen{'hilton'});           # 179
ok(! exists $seen{'icon'});             # 180
ok(exists $seen{'jerky'});              # 181
%seen = ();
# FIRST NONINTERSECTION 
@nonintersection = get_nonintersection( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 182
ok(exists $seen{'baker'});              # 183
ok(exists $seen{'camera'});             # 184
ok(exists $seen{'delta'});              # 185
ok(exists $seen{'edward'});             # 186
ok(! exists $seen{'fargo'});            # 187
ok(! exists $seen{'golfer'});           # 188
ok(exists $seen{'hilton'});             # 189
ok(exists $seen{'icon'});               # 190
ok(exists $seen{'jerky'});              # 191
%seen = ();

$nonintersection_ref = get_nonintersection_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 192
ok(exists $seen{'baker'});              # 193
ok(exists $seen{'camera'});             # 194
ok(exists $seen{'delta'});              # 195
ok(exists $seen{'edward'});             # 196
ok(! exists $seen{'fargo'});            # 197
ok(! exists $seen{'golfer'});           # 198
ok(exists $seen{'hilton'});             # 199
ok(exists $seen{'icon'});               # 200
ok(exists $seen{'jerky'});              # 201
%seen = ();
# FIRST BAG
@bag = get_bag( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 202
ok($seen{'baker'} == 2);                # 203
ok($seen{'camera'} == 2);               # 204
ok($seen{'delta'} == 3);                # 205
ok($seen{'edward'} == 2);               # 206
ok($seen{'fargo'} == 6);                # 207
ok($seen{'golfer'} == 5);               # 208
ok($seen{'hilton'} == 4);               # 209
ok($seen{'icon'} == 5);                 # 210
ok($seen{'jerky'} == 1);                # 211
%seen = ();

$bag_ref = get_bag_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 212
ok($seen{'baker'} == 2);                # 213
ok($seen{'camera'} == 2);               # 214
ok($seen{'delta'} == 3);                # 215
ok($seen{'edward'} == 2);               # 216
ok($seen{'fargo'} == 6);                # 217
ok($seen{'golfer'} == 5);               # 218
ok($seen{'hilton'} == 4);               # 219
ok($seen{'icon'} == 5);                 # 220
ok($seen{'jerky'} == 1);                # 221
%seen = ();

$LR = is_LsubsetR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok(! $LR);                              # 222

$LR = is_LsubsetR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [3,2] } );
ok($LR);                                # 223

$LR = is_LsubsetR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [4,2] } );
ok($LR);                                # 224

$RL = is_RsubsetL( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok(! $RL);                              # 225

$RL = is_RsubsetL( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [2,3] } );
ok($RL);                                # 226

$RL = is_RsubsetL( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [2,4] } );
ok($RL);                                # 227

$eqv = is_LequivalentR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok(! $eqv);                             # 228

$eqv = is_LeqvlntR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok(! $eqv);                             # 229

$eqv = is_LequivalentR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [3,4] } );
ok($eqv);                               # 230

$eqv = is_LeqvlntR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], pair => [3,4] } );
ok($eqv);                               # 231

$return = print_subset_chart( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok($return);                            # 232

$return = print_equivalence_chart( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
ok($return);                            # 233
# FIRST IS MEMBER WHICH
@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'abel' } );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 234

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'baker' } );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 235

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'camera' } );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 236

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'delta' } );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 237

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'edward' } );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 238

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'fargo' } );
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 239

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'golfer' } );
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 240

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'hilton' } );
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 241

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'icon' } );
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 242

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'jerky' } );
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2 > ] ));# 243

@memb_arr = is_member_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'zebra' } );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 244


$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'abel' } );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 245

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'baker' } );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 246

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'camera' } );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 247

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'delta' } );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 248

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'edward' } );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 249

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'fargo' } );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 250

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'golfer' } );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 251

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'hilton' } );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 252

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'icon' } );
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 253

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'jerky' } );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2 > ] ));# 254

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'zebra' } );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 255
# FIRST ARE MEMBERS WHICH
$memb_hash_ref = are_members_which( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] , 
    items => [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] } );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 256
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 257
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 258
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 259
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 260
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 261
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 262
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 263
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 264
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2 > ] ));# 265
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 266
# FIRST IS MEMBER ANY
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'abel' } ));# 267
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'baker' } ));# 268
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'camera' } ));# 269
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'delta' } ));# 270
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'edward' } ));# 271
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'fargo' } ));# 272
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'golfer' } ));# 273
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'hilton' } ));# 274
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'icon' } ));# 275
ok(is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'jerky' } ));# 276
ok(! is_member_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 'zebra' } ));# 277
# FIRST ARE MEMBERS ANY
$memb_hash_ref = are_members_any( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] , 
    items => [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] } );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 278
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 279
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 280
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 281
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 282
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 283
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 284
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 285
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 286
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 287
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 288

$vers = get_version;
ok($vers);                              # 289

$disj = is_LdisjointR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4, \%h8 ] } );
ok(! $disj);                            # 290

$disj = is_LdisjointR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4, \%h8 ], pair => [2,3] } );
ok(! $disj);                            # 291

$disj = is_LdisjointR( { lists => [ \%h0, \%h1, \%h2, \%h3, \%h4, \%h8 ], pair => [4,5] } );
ok($disj);                              # 292

########## BELOW:  Tests for '-u' option ##########

@union = get_union( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 293
ok(exists $seen{'baker'});              # 294
ok(exists $seen{'camera'});             # 295
ok(exists $seen{'delta'});              # 296
ok(exists $seen{'edward'});             # 297
ok(exists $seen{'fargo'});              # 298
ok(exists $seen{'golfer'});             # 299
ok(exists $seen{'hilton'});             # 300
ok(exists $seen{'icon'});               # 301
ok(exists $seen{'jerky'});              # 302
%seen = ();

$union_ref = get_union_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 303
ok(exists $seen{'baker'});              # 304
ok(exists $seen{'camera'});             # 305
ok(exists $seen{'delta'});              # 306
ok(exists $seen{'edward'});             # 307
ok(exists $seen{'fargo'});              # 308
ok(exists $seen{'golfer'});             # 309
ok(exists $seen{'hilton'});             # 310
ok(exists $seen{'icon'});               # 311
ok(exists $seen{'jerky'});              # 312
%seen = ();

@shared = get_shared( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 313
ok(exists $seen{'baker'});              # 314
ok(exists $seen{'camera'});             # 315
ok(exists $seen{'delta'});              # 316
ok(exists $seen{'edward'});             # 317
ok(exists $seen{'fargo'});              # 318
ok(exists $seen{'golfer'});             # 319
ok(exists $seen{'hilton'});             # 320
ok(exists $seen{'icon'});               # 321
ok(! exists $seen{'jerky'});            # 322
%seen = ();

$shared_ref = get_shared_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 323
ok(exists $seen{'baker'});              # 324
ok(exists $seen{'camera'});             # 325
ok(exists $seen{'delta'});              # 326
ok(exists $seen{'edward'});             # 327
ok(exists $seen{'fargo'});              # 328
ok(exists $seen{'golfer'});             # 329
ok(exists $seen{'hilton'});             # 330
ok(exists $seen{'icon'});               # 331
ok(! exists $seen{'jerky'});            # 332
%seen = ();

@intersection = get_intersection( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 333
ok(! exists $seen{'baker'});            # 334
ok(! exists $seen{'camera'});           # 335
ok(! exists $seen{'delta'});            # 336
ok(! exists $seen{'edward'});           # 337
ok(exists $seen{'fargo'});              # 338
ok(exists $seen{'golfer'});             # 339
ok(! exists $seen{'hilton'});           # 340
ok(! exists $seen{'icon'});             # 341
ok(! exists $seen{'jerky'});            # 342
%seen = ();

$intersection_ref = get_intersection_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 343
ok(! exists $seen{'baker'});            # 344
ok(! exists $seen{'camera'});           # 345
ok(! exists $seen{'delta'});            # 346
ok(! exists $seen{'edward'});           # 347
ok(exists $seen{'fargo'});              # 348
ok(exists $seen{'golfer'});             # 349
ok(! exists $seen{'hilton'});           # 350
ok(! exists $seen{'icon'});             # 351
ok(! exists $seen{'jerky'});            # 352
%seen = ();

@unique = get_unique( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 353
ok(! exists $seen{'baker'});            # 354
ok(! exists $seen{'camera'});           # 355
ok(! exists $seen{'delta'});            # 356
ok(! exists $seen{'edward'});           # 357
ok(! exists $seen{'fargo'});            # 358
ok(! exists $seen{'golfer'});           # 359
ok(! exists $seen{'hilton'});           # 360
ok(! exists $seen{'icon'});             # 361
ok(! exists $seen{'jerky'});            # 362
%seen = ();

$unique_ref = get_unique_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 363
ok(! exists $seen{'baker'});            # 364
ok(! exists $seen{'camera'});           # 365
ok(! exists $seen{'delta'});            # 366
ok(! exists $seen{'edward'});           # 367
ok(! exists $seen{'fargo'});            # 368
ok(! exists $seen{'golfer'});           # 369
ok(! exists $seen{'hilton'});           # 370
ok(! exists $seen{'icon'});             # 371
ok(! exists $seen{'jerky'});            # 372
%seen = ();

@unique = get_unique( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 2 } );
$seen{$_}++ foreach (@unique);
ok(!exists $seen{'abel'});              # 373
ok(! exists $seen{'baker'});            # 374
ok(! exists $seen{'camera'});           # 375
ok(! exists $seen{'delta'});            # 376
ok(! exists $seen{'edward'});           # 377
ok(! exists $seen{'fargo'});            # 378
ok(! exists $seen{'golfer'});           # 379
ok(! exists $seen{'hilton'});           # 380
ok(! exists $seen{'icon'});             # 381
ok(exists $seen{'jerky'});              # 382
%seen = ();

$unique_ref = get_unique_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 2 } );
$seen{$_}++ foreach (@{$unique_ref});
ok(!exists $seen{'abel'});              # 383
ok(! exists $seen{'baker'});            # 384
ok(! exists $seen{'camera'});           # 385
ok(! exists $seen{'delta'});            # 386
ok(! exists $seen{'edward'});           # 387
ok(! exists $seen{'fargo'});            # 388
ok(! exists $seen{'golfer'});           # 389
ok(! exists $seen{'hilton'});           # 390
ok(! exists $seen{'icon'});             # 391
ok(exists $seen{'jerky'});              # 392
%seen = ();

@complement = get_complement( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 393
ok(! exists $seen{'baker'});            # 394
ok(! exists $seen{'camera'});           # 395
ok(! exists $seen{'delta'});            # 396
ok(! exists $seen{'edward'});           # 397
ok(! exists $seen{'fargo'});            # 398
ok(! exists $seen{'golfer'});           # 399
ok(exists $seen{'hilton'});             # 400
ok(exists $seen{'icon'});               # 401
ok(exists $seen{'jerky'});              # 402
%seen = ();

$complement_ref = get_complement_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 403
ok(! exists $seen{'baker'});            # 404
ok(! exists $seen{'camera'});           # 405
ok(! exists $seen{'delta'});            # 406
ok(! exists $seen{'edward'});           # 407
ok(! exists $seen{'fargo'});            # 408
ok(! exists $seen{'golfer'});           # 409
ok(exists $seen{'hilton'});             # 410
ok(exists $seen{'icon'});               # 411
ok(exists $seen{'jerky'});              # 412
%seen = ();

@complement = get_complement( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 3 } );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 413
ok(exists $seen{'baker'});              # 414
ok(exists $seen{'camera'});             # 415
ok(exists $seen{'delta'});              # 416
ok(exists $seen{'edward'});             # 417
ok(! exists $seen{'fargo'});            # 418
ok(! exists $seen{'golfer'});           # 419
ok(! exists $seen{'hilton'});           # 420
ok(! exists $seen{'icon'});             # 421
ok(exists $seen{'jerky'});              # 422
%seen = ();

$complement_ref = get_complement_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ], item => 3 } );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 423
ok(exists $seen{'baker'});              # 424
ok(exists $seen{'camera'});             # 425
ok(exists $seen{'delta'});              # 426
ok(exists $seen{'edward'});             # 427
ok(! exists $seen{'fargo'});            # 428
ok(! exists $seen{'golfer'});           # 429
ok(! exists $seen{'hilton'});           # 430
ok(! exists $seen{'icon'});             # 431
ok(exists $seen{'jerky'});              # 432
%seen = ();

@symmetric_difference = get_symmetric_difference( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 433
ok(! exists $seen{'baker'});            # 434
ok(! exists $seen{'camera'});           # 435
ok(! exists $seen{'delta'});            # 436
ok(! exists $seen{'edward'});           # 437
ok(! exists $seen{'fargo'});            # 438
ok(! exists $seen{'golfer'});           # 439
ok(! exists $seen{'hilton'});           # 440
ok(! exists $seen{'icon'});             # 441
ok(exists $seen{'jerky'});              # 442
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 443
ok(! exists $seen{'baker'});            # 444
ok(! exists $seen{'camera'});           # 445
ok(! exists $seen{'delta'});            # 446
ok(! exists $seen{'edward'});           # 447
ok(! exists $seen{'fargo'});            # 448
ok(! exists $seen{'golfer'});           # 449
ok(! exists $seen{'hilton'});           # 450
ok(! exists $seen{'icon'});             # 451
ok(exists $seen{'jerky'});              # 452
%seen = ();

@symmetric_difference = get_symdiff( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 453
ok(! exists $seen{'baker'});            # 454
ok(! exists $seen{'camera'});           # 455
ok(! exists $seen{'delta'});            # 456
ok(! exists $seen{'edward'});           # 457
ok(! exists $seen{'fargo'});            # 458
ok(! exists $seen{'golfer'});           # 459
ok(! exists $seen{'hilton'});           # 460
ok(! exists $seen{'icon'});             # 461
ok(exists $seen{'jerky'});              # 462
%seen = ();

$symmetric_difference_ref = get_symdiff_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 463
ok(! exists $seen{'baker'});            # 464
ok(! exists $seen{'camera'});           # 465
ok(! exists $seen{'delta'});            # 466
ok(! exists $seen{'edward'});           # 467
ok(! exists $seen{'fargo'});            # 468
ok(! exists $seen{'golfer'});           # 469
ok(! exists $seen{'hilton'});           # 470
ok(! exists $seen{'icon'});             # 471
ok(exists $seen{'jerky'});              # 472
%seen = ();

@nonintersection = get_nonintersection( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 473
ok(exists $seen{'baker'});              # 474
ok(exists $seen{'camera'});             # 475
ok(exists $seen{'delta'});              # 476
ok(exists $seen{'edward'});             # 477
ok(! exists $seen{'fargo'});            # 478
ok(! exists $seen{'golfer'});           # 479
ok(exists $seen{'hilton'});             # 480
ok(exists $seen{'icon'});               # 481
ok(exists $seen{'jerky'});              # 482
%seen = ();

$nonintersection_ref = get_nonintersection_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 483
ok(exists $seen{'baker'});              # 484
ok(exists $seen{'camera'});             # 485
ok(exists $seen{'delta'});              # 486
ok(exists $seen{'edward'});             # 487
ok(! exists $seen{'fargo'});            # 488
ok(! exists $seen{'golfer'});           # 489
ok(exists $seen{'hilton'});             # 490
ok(exists $seen{'icon'});               # 491
ok(exists $seen{'jerky'});              # 492
%seen = ();

@bag = get_bag( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 493
ok($seen{'baker'} == 2);                # 494
ok($seen{'camera'} == 2);               # 495
ok($seen{'delta'} == 3);                # 496
ok($seen{'edward'} == 2);               # 497
ok($seen{'fargo'} == 6);                # 498
ok($seen{'golfer'} == 5);               # 499
ok($seen{'hilton'} == 4);               # 500
ok($seen{'icon'} == 5);                 # 501
ok($seen{'jerky'} == 1);                # 502
%seen = ();

$bag_ref = get_bag_ref( { unsorted => 1, lists => [ \%h0, \%h1, \%h2, \%h3, \%h4 ] } );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 503
ok($seen{'baker'} == 2);                # 504
ok($seen{'camera'} == 2);               # 505
ok($seen{'delta'} == 3);                # 506
ok($seen{'edward'} == 2);               # 507
ok($seen{'fargo'} == 6);                # 508
ok($seen{'golfer'} == 5);               # 509
ok($seen{'hilton'} == 4);               # 510
ok($seen{'icon'} == 5);                 # 511
ok($seen{'jerky'} == 1);                # 512
%seen = ();

########## Tests of passing refs to named arrays to functions ##########

my @allhashes = (\%h0, \%h1, \%h2, \%h3, \%h4); 
@intersection = get_intersection( { unsorted => 1, lists => \@allhashes } );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 513
ok(! exists $seen{'baker'});            # 514
ok(! exists $seen{'camera'});           # 515
ok(! exists $seen{'delta'});            # 516
ok(! exists $seen{'edward'});           # 517
ok(exists $seen{'fargo'});              # 518
ok(exists $seen{'golfer'});             # 519
ok(! exists $seen{'hilton'});           # 520
ok(! exists $seen{'icon'});             # 521
ok(! exists $seen{'jerky'});            # 522
%seen = ();

@unique = get_unique( { unsorted => 1, lists => \@allhashes, item => 2 } );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 523
ok(! exists $seen{'baker'});            # 524
ok(! exists $seen{'camera'});           # 525
ok(! exists $seen{'delta'});            # 526
ok(! exists $seen{'edward'});           # 527
ok(! exists $seen{'fargo'});            # 528
ok(! exists $seen{'golfer'});           # 529
ok(! exists $seen{'hilton'});           # 530
ok(! exists $seen{'icon'});             # 531
ok(exists $seen{'jerky'});              # 532
%seen = ();


