# 11_functional_multiple.t 

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
752;
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

# FIRST UNION
@union = get_union( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$union_ref = get_union_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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
@shared = get_shared( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$shared_ref = get_shared_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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
@intersection = get_intersection( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$intersection_ref = get_intersection_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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
@unique = get_unique( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$unique_ref = get_unique_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@unique = get_unique( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
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

$unique_ref = get_unique_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
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
@complement = get_complement( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$complement_ref = get_complement_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@complement = get_complement( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
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

$complement_ref = get_complement_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
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
@symmetric_difference = get_symmetric_difference( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$symmetric_difference_ref = get_symmetric_difference_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@symmetric_difference = get_symdiff( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$symmetric_difference_ref = get_symdiff_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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
@nonintersection = get_nonintersection( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$nonintersection_ref = get_nonintersection_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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
@bag = get_bag( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$bag_ref = get_bag_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok(! $LR);                              # 222

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3,2] );
ok($LR);                                # 223

$LR = is_LsubsetR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [4,2] );
ok($LR);                                # 224

$RL = is_RsubsetL( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok(! $RL);                              # 225

$RL = is_RsubsetL( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2,3] );
ok($RL);                                # 226

$RL = is_RsubsetL( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2,4] );
ok($RL);                                # 227

$eqv = is_LequivalentR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok(! $eqv);                             # 228

$eqv = is_LeqvlntR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok(! $eqv);                             # 229

$eqv = is_LequivalentR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3,4] );
ok($eqv);                               # 230

$eqv = is_LeqvlntR( [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3,4] );
ok($eqv);                               # 231

$return = print_subset_chart( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok($return);                            # 232

$return = print_equivalence_chart( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
ok($return);                            # 233
# FIRST IS MEMBER WHICH
@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'abel' ] );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 234

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'baker' ] );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 235

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'camera' ] );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 236

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'delta' ] );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 237

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'edward' ] );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 238

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'fargo' ] );
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 239

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'golfer' ] );
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 240

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'hilton' ] );
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 241

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'icon' ] );
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 242

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'jerky' ] );
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2 > ] ));# 243

@memb_arr = is_member_which( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'zebra' ] );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 244


$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'abel' ] );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 245

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'baker' ] );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 246

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'camera' ] );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 247

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'delta' ] );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 248

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'edward' ] );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 249

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'fargo' ] );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 250

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'golfer' ] );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 251

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'hilton' ] );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 252

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'icon' ] );
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 253

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'jerky' ] );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2 > ] ));# 254

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'zebra' ] );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 255
# FIRST ARE MEMBERS WHICH
$memb_hash_ref = are_members_which(  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , 
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );
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
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'abel' ] ));# 267
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'baker' ] ));# 268
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'camera' ] ));# 269
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'delta' ] ));# 270
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'edward' ] ));# 271
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'fargo' ] ));# 272
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'golfer' ] ));# 273
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'hilton' ] ));# 274
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'icon' ] ));# 275
ok(is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'jerky' ] ));# 276
ok(! is_member_any( [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , [ 'zebra' ] ));# 277
# FIRST ARE MEMBERS ANY
$memb_hash_ref = are_members_any(  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] , 
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );
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

$disj = is_LdisjointR( [ \@a0, \@a1, \@a2, \@a3, \@a4, \@a8 ] );
ok(! $disj);                            # 290

$disj = is_LdisjointR( [ \@a0, \@a1, \@a2, \@a3, \@a4, \@a8 ], [2,3] );
ok(! $disj);                            # 291

$disj = is_LdisjointR( [ \@a0, \@a1, \@a2, \@a3, \@a4, \@a8 ], [4,5] );
ok($disj);                              # 292

########## BELOW:  Tests for '-u' option ##########

@union = get_union('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$union_ref = get_union_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@shared = get_shared('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$shared_ref = get_shared_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@intersection = get_intersection('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$intersection_ref = get_intersection_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@unique = get_unique('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$unique_ref = get_unique_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@unique = get_unique('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
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

$unique_ref = get_unique_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
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

@complement = get_complement('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$complement_ref = get_complement_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@complement = get_complement('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
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

$complement_ref = get_complement_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
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

@symmetric_difference = get_symmetric_difference('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$symmetric_difference_ref = get_symmetric_difference_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@symmetric_difference = get_symdiff('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$symmetric_difference_ref = get_symdiff_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@nonintersection = get_nonintersection('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$nonintersection_ref = get_nonintersection_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

@bag = get_bag('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

$bag_ref = get_bag_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
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

##### BELOW:  Tests for '--unsorted' option ##########

@union = get_union('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 513
ok(exists $seen{'baker'});              # 514
ok(exists $seen{'camera'});             # 515
ok(exists $seen{'delta'});              # 516
ok(exists $seen{'edward'});             # 517
ok(exists $seen{'fargo'});              # 518
ok(exists $seen{'golfer'});             # 519
ok(exists $seen{'hilton'});             # 520
ok(exists $seen{'icon'});               # 521
ok(exists $seen{'jerky'});              # 522
%seen = ();

$union_ref = get_union_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 523
ok(exists $seen{'baker'});              # 524
ok(exists $seen{'camera'});             # 525
ok(exists $seen{'delta'});              # 526
ok(exists $seen{'edward'});             # 527
ok(exists $seen{'fargo'});              # 528
ok(exists $seen{'golfer'});             # 529
ok(exists $seen{'hilton'});             # 530
ok(exists $seen{'icon'});               # 531
ok(exists $seen{'jerky'});              # 532
%seen = ();

@shared = get_shared('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 533
ok(exists $seen{'baker'});              # 534
ok(exists $seen{'camera'});             # 535
ok(exists $seen{'delta'});              # 536
ok(exists $seen{'edward'});             # 537
ok(exists $seen{'fargo'});              # 538
ok(exists $seen{'golfer'});             # 539
ok(exists $seen{'hilton'});             # 540
ok(exists $seen{'icon'});               # 541
ok(! exists $seen{'jerky'});            # 542
%seen = ();

$shared_ref = get_shared_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 543
ok(exists $seen{'baker'});              # 544
ok(exists $seen{'camera'});             # 545
ok(exists $seen{'delta'});              # 546
ok(exists $seen{'edward'});             # 547
ok(exists $seen{'fargo'});              # 548
ok(exists $seen{'golfer'});             # 549
ok(exists $seen{'hilton'});             # 550
ok(exists $seen{'icon'});               # 551
ok(! exists $seen{'jerky'});            # 552
%seen = ();

@intersection = get_intersection('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 553
ok(! exists $seen{'baker'});            # 554
ok(! exists $seen{'camera'});           # 555
ok(! exists $seen{'delta'});            # 556
ok(! exists $seen{'edward'});           # 557
ok(exists $seen{'fargo'});              # 558
ok(exists $seen{'golfer'});             # 559
ok(! exists $seen{'hilton'});           # 560
ok(! exists $seen{'icon'});             # 561
ok(! exists $seen{'jerky'});            # 562
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 563
ok(! exists $seen{'baker'});            # 564
ok(! exists $seen{'camera'});           # 565
ok(! exists $seen{'delta'});            # 566
ok(! exists $seen{'edward'});           # 567
ok(exists $seen{'fargo'});              # 568
ok(exists $seen{'golfer'});             # 569
ok(! exists $seen{'hilton'});           # 570
ok(! exists $seen{'icon'});             # 571
ok(! exists $seen{'jerky'});            # 572
%seen = ();

@unique = get_unique('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 573
ok(! exists $seen{'baker'});            # 574
ok(! exists $seen{'camera'});           # 575
ok(! exists $seen{'delta'});            # 576
ok(! exists $seen{'edward'});           # 577
ok(! exists $seen{'fargo'});            # 578
ok(! exists $seen{'golfer'});           # 579
ok(! exists $seen{'hilton'});           # 580
ok(! exists $seen{'icon'});             # 581
ok(! exists $seen{'jerky'});            # 582
%seen = ();

$unique_ref = get_unique_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 583
ok(! exists $seen{'baker'});            # 584
ok(! exists $seen{'camera'});           # 585
ok(! exists $seen{'delta'});            # 586
ok(! exists $seen{'edward'});           # 587
ok(! exists $seen{'fargo'});            # 588
ok(! exists $seen{'golfer'});           # 589
ok(! exists $seen{'hilton'});           # 590
ok(! exists $seen{'icon'});             # 591
ok(! exists $seen{'jerky'});            # 592
%seen = ();

@unique = get_unique('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 593
ok(! exists $seen{'baker'});            # 594
ok(! exists $seen{'camera'});           # 595
ok(! exists $seen{'delta'});            # 596
ok(! exists $seen{'edward'});           # 597
ok(! exists $seen{'fargo'});            # 598
ok(! exists $seen{'golfer'});           # 599
ok(! exists $seen{'hilton'});           # 600
ok(! exists $seen{'icon'});             # 601
ok(exists $seen{'jerky'});              # 602
%seen = ();

$unique_ref = get_unique_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 603
ok(! exists $seen{'baker'});            # 604
ok(! exists $seen{'camera'});           # 605
ok(! exists $seen{'delta'});            # 606
ok(! exists $seen{'edward'});           # 607
ok(! exists $seen{'fargo'});            # 608
ok(! exists $seen{'golfer'});           # 609
ok(! exists $seen{'hilton'});           # 610
ok(! exists $seen{'icon'});             # 611
ok(exists $seen{'jerky'});              # 612

@complement = get_complement('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 613
ok(! exists $seen{'baker'});            # 614
ok(! exists $seen{'camera'});           # 615
ok(! exists $seen{'delta'});            # 616
ok(! exists $seen{'edward'});           # 617
ok(! exists $seen{'fargo'});            # 618
ok(! exists $seen{'golfer'});           # 619
ok(exists $seen{'hilton'});             # 620
ok(exists $seen{'icon'});               # 621
ok(exists $seen{'jerky'});              # 622
%seen = ();

$complement_ref = get_complement_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 623
ok(! exists $seen{'baker'});            # 624
ok(! exists $seen{'camera'});           # 625
ok(! exists $seen{'delta'});            # 626
ok(! exists $seen{'edward'});           # 627
ok(! exists $seen{'fargo'});            # 628
ok(! exists $seen{'golfer'});           # 629
ok(exists $seen{'hilton'});             # 630
ok(exists $seen{'icon'});               # 631
ok(exists $seen{'jerky'});              # 632
%seen = ();

@complement = get_complement('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 633
ok(exists $seen{'baker'});              # 634
ok(exists $seen{'camera'});             # 635
ok(exists $seen{'delta'});              # 636
ok(exists $seen{'edward'});             # 637
ok(! exists $seen{'fargo'});            # 638
ok(! exists $seen{'golfer'});           # 639
ok(! exists $seen{'hilton'});           # 640
ok(! exists $seen{'icon'});             # 641
ok(exists $seen{'jerky'});              # 642
%seen = ();

$complement_ref = get_complement_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 643
ok(exists $seen{'baker'});              # 644
ok(exists $seen{'camera'});             # 645
ok(exists $seen{'delta'});              # 646
ok(exists $seen{'edward'});             # 647
ok(! exists $seen{'fargo'});            # 648
ok(! exists $seen{'golfer'});           # 649
ok(! exists $seen{'hilton'});           # 650
ok(! exists $seen{'icon'});             # 651
ok(exists $seen{'jerky'});              # 652
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 653
ok(! exists $seen{'baker'});            # 654
ok(! exists $seen{'camera'});           # 655
ok(! exists $seen{'delta'});            # 656
ok(! exists $seen{'edward'});           # 657
ok(! exists $seen{'fargo'});            # 658
ok(! exists $seen{'golfer'});           # 659
ok(! exists $seen{'hilton'});           # 660
ok(! exists $seen{'icon'});             # 661
ok(exists $seen{'jerky'});              # 662
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 663
ok(! exists $seen{'baker'});            # 664
ok(! exists $seen{'camera'});           # 665
ok(! exists $seen{'delta'});            # 666
ok(! exists $seen{'edward'});           # 667
ok(! exists $seen{'fargo'});            # 668
ok(! exists $seen{'golfer'});           # 669
ok(! exists $seen{'hilton'});           # 670
ok(! exists $seen{'icon'});             # 671
ok(exists $seen{'jerky'});              # 672
%seen = ();

@symmetric_difference = get_symdiff('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 673
ok(! exists $seen{'baker'});            # 674
ok(! exists $seen{'camera'});           # 675
ok(! exists $seen{'delta'});            # 676
ok(! exists $seen{'edward'});           # 677
ok(! exists $seen{'fargo'});            # 678
ok(! exists $seen{'golfer'});           # 679
ok(! exists $seen{'hilton'});           # 680
ok(! exists $seen{'icon'});             # 681
ok(exists $seen{'jerky'});              # 682
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 683
ok(! exists $seen{'baker'});            # 684
ok(! exists $seen{'camera'});           # 685
ok(! exists $seen{'delta'});            # 686
ok(! exists $seen{'edward'});           # 687
ok(! exists $seen{'fargo'});            # 688
ok(! exists $seen{'golfer'});           # 689
ok(! exists $seen{'hilton'});           # 690
ok(! exists $seen{'icon'});             # 691
ok(exists $seen{'jerky'});              # 692
%seen = ();

@nonintersection = get_nonintersection('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 693
ok(exists $seen{'baker'});              # 694
ok(exists $seen{'camera'});             # 695
ok(exists $seen{'delta'});              # 696
ok(exists $seen{'edward'});             # 697
ok(! exists $seen{'fargo'});            # 698
ok(! exists $seen{'golfer'});           # 699
ok(exists $seen{'hilton'});             # 700
ok(exists $seen{'icon'});               # 701
ok(exists $seen{'jerky'});              # 702
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 703
ok(exists $seen{'baker'});              # 704
ok(exists $seen{'camera'});             # 705
ok(exists $seen{'delta'});              # 706
ok(exists $seen{'edward'});             # 707
ok(! exists $seen{'fargo'});            # 708
ok(! exists $seen{'golfer'});           # 709
ok(exists $seen{'hilton'});             # 710
ok(exists $seen{'icon'});               # 711
ok(exists $seen{'jerky'});              # 712
%seen = ();

@bag = get_bag('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 713
ok($seen{'baker'} == 2);                # 714
ok($seen{'camera'} == 2);               # 715
ok($seen{'delta'} == 3);                # 716
ok($seen{'edward'} == 2);               # 717
ok($seen{'fargo'} == 6);                # 718
ok($seen{'golfer'} == 5);               # 719
ok($seen{'hilton'} == 4);               # 720
ok($seen{'icon'} == 5);                 # 721
ok($seen{'jerky'} == 1);                # 722
%seen = ();

$bag_ref = get_bag_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 723
ok($seen{'baker'} == 2);                # 724
ok($seen{'camera'} == 2);               # 725
ok($seen{'delta'} == 3);                # 726
ok($seen{'edward'} == 2);               # 727
ok($seen{'fargo'} == 6);                # 728
ok($seen{'golfer'} == 5);               # 729
ok($seen{'hilton'} == 4);               # 730
ok($seen{'icon'} == 5);                 # 731
ok($seen{'jerky'} == 1);                # 732
%seen = ();

########## Tests of passing refs to named arrays to functions ##########

my @allarrays = (\@a0, \@a1, \@a2, \@a3, \@a4); 
@intersection = get_intersection('--unsorted', \@allarrays );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 733
ok(! exists $seen{'baker'});            # 734
ok(! exists $seen{'camera'});           # 735
ok(! exists $seen{'delta'});            # 736
ok(! exists $seen{'edward'});           # 737
ok(exists $seen{'fargo'});              # 738
ok(exists $seen{'golfer'});             # 739
ok(! exists $seen{'hilton'});           # 740
ok(! exists $seen{'icon'});             # 741
ok(! exists $seen{'jerky'});            # 742
%seen = ();

@unique = get_unique('--unsorted', \@allarrays, [2] );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 743
ok(! exists $seen{'baker'});            # 744
ok(! exists $seen{'camera'});           # 745
ok(! exists $seen{'delta'});            # 746
ok(! exists $seen{'edward'});           # 747
ok(! exists $seen{'fargo'});            # 748
ok(! exists $seen{'golfer'});           # 749
ok(! exists $seen{'hilton'});           # 750
ok(! exists $seen{'icon'});             # 751
ok(exists $seen{'jerky'});              # 752
%seen = ();


