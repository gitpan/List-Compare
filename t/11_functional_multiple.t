# 11_functional_multiple.t 

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
749;
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
my ($LR, $RL, $eqv, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);

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

########## BELOW:  Tests for '-u' option ##########

@union = get_union('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 290
ok(exists $seen{'baker'});              # 291
ok(exists $seen{'camera'});             # 292
ok(exists $seen{'delta'});              # 293
ok(exists $seen{'edward'});             # 294
ok(exists $seen{'fargo'});              # 295
ok(exists $seen{'golfer'});             # 296
ok(exists $seen{'hilton'});             # 297
ok(exists $seen{'icon'});               # 298
ok(exists $seen{'jerky'});              # 299
%seen = ();

$union_ref = get_union_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 300
ok(exists $seen{'baker'});              # 301
ok(exists $seen{'camera'});             # 302
ok(exists $seen{'delta'});              # 303
ok(exists $seen{'edward'});             # 304
ok(exists $seen{'fargo'});              # 305
ok(exists $seen{'golfer'});             # 306
ok(exists $seen{'hilton'});             # 307
ok(exists $seen{'icon'});               # 308
ok(exists $seen{'jerky'});              # 309
%seen = ();

@shared = get_shared('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 310
ok(exists $seen{'baker'});              # 311
ok(exists $seen{'camera'});             # 312
ok(exists $seen{'delta'});              # 313
ok(exists $seen{'edward'});             # 314
ok(exists $seen{'fargo'});              # 315
ok(exists $seen{'golfer'});             # 316
ok(exists $seen{'hilton'});             # 317
ok(exists $seen{'icon'});               # 318
ok(! exists $seen{'jerky'});            # 319
%seen = ();

$shared_ref = get_shared_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 320
ok(exists $seen{'baker'});              # 321
ok(exists $seen{'camera'});             # 322
ok(exists $seen{'delta'});              # 323
ok(exists $seen{'edward'});             # 324
ok(exists $seen{'fargo'});              # 325
ok(exists $seen{'golfer'});             # 326
ok(exists $seen{'hilton'});             # 327
ok(exists $seen{'icon'});               # 328
ok(! exists $seen{'jerky'});            # 329
%seen = ();

@intersection = get_intersection('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 330
ok(! exists $seen{'baker'});            # 331
ok(! exists $seen{'camera'});           # 332
ok(! exists $seen{'delta'});            # 333
ok(! exists $seen{'edward'});           # 334
ok(exists $seen{'fargo'});              # 335
ok(exists $seen{'golfer'});             # 336
ok(! exists $seen{'hilton'});           # 337
ok(! exists $seen{'icon'});             # 338
ok(! exists $seen{'jerky'});            # 339
%seen = ();

$intersection_ref = get_intersection_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 340
ok(! exists $seen{'baker'});            # 341
ok(! exists $seen{'camera'});           # 342
ok(! exists $seen{'delta'});            # 343
ok(! exists $seen{'edward'});           # 344
ok(exists $seen{'fargo'});              # 345
ok(exists $seen{'golfer'});             # 346
ok(! exists $seen{'hilton'});           # 347
ok(! exists $seen{'icon'});             # 348
ok(! exists $seen{'jerky'});            # 349
%seen = ();

@unique = get_unique('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 350
ok(! exists $seen{'baker'});            # 351
ok(! exists $seen{'camera'});           # 352
ok(! exists $seen{'delta'});            # 353
ok(! exists $seen{'edward'});           # 354
ok(! exists $seen{'fargo'});            # 355
ok(! exists $seen{'golfer'});           # 356
ok(! exists $seen{'hilton'});           # 357
ok(! exists $seen{'icon'});             # 358
ok(! exists $seen{'jerky'});            # 359
%seen = ();

$unique_ref = get_unique_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 360
ok(! exists $seen{'baker'});            # 361
ok(! exists $seen{'camera'});           # 362
ok(! exists $seen{'delta'});            # 363
ok(! exists $seen{'edward'});           # 364
ok(! exists $seen{'fargo'});            # 365
ok(! exists $seen{'golfer'});           # 366
ok(! exists $seen{'hilton'});           # 367
ok(! exists $seen{'icon'});             # 368
ok(! exists $seen{'jerky'});            # 369
%seen = ();

@unique = get_unique('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@unique);
ok(!exists $seen{'abel'});              # 370
ok(! exists $seen{'baker'});            # 371
ok(! exists $seen{'camera'});           # 372
ok(! exists $seen{'delta'});            # 373
ok(! exists $seen{'edward'});           # 374
ok(! exists $seen{'fargo'});            # 375
ok(! exists $seen{'golfer'});           # 376
ok(! exists $seen{'hilton'});           # 377
ok(! exists $seen{'icon'});             # 378
ok(exists $seen{'jerky'});              # 379
%seen = ();

$unique_ref = get_unique_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@{$unique_ref});
ok(!exists $seen{'abel'});              # 380
ok(! exists $seen{'baker'});            # 381
ok(! exists $seen{'camera'});           # 382
ok(! exists $seen{'delta'});            # 383
ok(! exists $seen{'edward'});           # 384
ok(! exists $seen{'fargo'});            # 385
ok(! exists $seen{'golfer'});           # 386
ok(! exists $seen{'hilton'});           # 387
ok(! exists $seen{'icon'});             # 388
ok(exists $seen{'jerky'});              # 389
%seen = ();

@complement = get_complement('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 390
ok(! exists $seen{'baker'});            # 391
ok(! exists $seen{'camera'});           # 392
ok(! exists $seen{'delta'});            # 393
ok(! exists $seen{'edward'});           # 394
ok(! exists $seen{'fargo'});            # 395
ok(! exists $seen{'golfer'});           # 396
ok(exists $seen{'hilton'});             # 397
ok(exists $seen{'icon'});               # 398
ok(exists $seen{'jerky'});              # 399
%seen = ();

$complement_ref = get_complement_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 400
ok(! exists $seen{'baker'});            # 401
ok(! exists $seen{'camera'});           # 402
ok(! exists $seen{'delta'});            # 403
ok(! exists $seen{'edward'});           # 404
ok(! exists $seen{'fargo'});            # 405
ok(! exists $seen{'golfer'});           # 406
ok(exists $seen{'hilton'});             # 407
ok(exists $seen{'icon'});               # 408
ok(exists $seen{'jerky'});              # 409
%seen = ();

@complement = get_complement('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 410
ok(exists $seen{'baker'});              # 411
ok(exists $seen{'camera'});             # 412
ok(exists $seen{'delta'});              # 413
ok(exists $seen{'edward'});             # 414
ok(! exists $seen{'fargo'});            # 415
ok(! exists $seen{'golfer'});           # 416
ok(! exists $seen{'hilton'});           # 417
ok(! exists $seen{'icon'});             # 418
ok(exists $seen{'jerky'});              # 419
%seen = ();

$complement_ref = get_complement_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 420
ok(exists $seen{'baker'});              # 421
ok(exists $seen{'camera'});             # 422
ok(exists $seen{'delta'});              # 423
ok(exists $seen{'edward'});             # 424
ok(! exists $seen{'fargo'});            # 425
ok(! exists $seen{'golfer'});           # 426
ok(! exists $seen{'hilton'});           # 427
ok(! exists $seen{'icon'});             # 428
ok(exists $seen{'jerky'});              # 429
%seen = ();

@symmetric_difference = get_symmetric_difference('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 430
ok(! exists $seen{'baker'});            # 431
ok(! exists $seen{'camera'});           # 432
ok(! exists $seen{'delta'});            # 433
ok(! exists $seen{'edward'});           # 434
ok(! exists $seen{'fargo'});            # 435
ok(! exists $seen{'golfer'});           # 436
ok(! exists $seen{'hilton'});           # 437
ok(! exists $seen{'icon'});             # 438
ok(exists $seen{'jerky'});              # 439
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 440
ok(! exists $seen{'baker'});            # 441
ok(! exists $seen{'camera'});           # 442
ok(! exists $seen{'delta'});            # 443
ok(! exists $seen{'edward'});           # 444
ok(! exists $seen{'fargo'});            # 445
ok(! exists $seen{'golfer'});           # 446
ok(! exists $seen{'hilton'});           # 447
ok(! exists $seen{'icon'});             # 448
ok(exists $seen{'jerky'});              # 449
%seen = ();

@symmetric_difference = get_symdiff('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 450
ok(! exists $seen{'baker'});            # 451
ok(! exists $seen{'camera'});           # 452
ok(! exists $seen{'delta'});            # 453
ok(! exists $seen{'edward'});           # 454
ok(! exists $seen{'fargo'});            # 455
ok(! exists $seen{'golfer'});           # 456
ok(! exists $seen{'hilton'});           # 457
ok(! exists $seen{'icon'});             # 458
ok(exists $seen{'jerky'});              # 459
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 460
ok(! exists $seen{'baker'});            # 461
ok(! exists $seen{'camera'});           # 462
ok(! exists $seen{'delta'});            # 463
ok(! exists $seen{'edward'});           # 464
ok(! exists $seen{'fargo'});            # 465
ok(! exists $seen{'golfer'});           # 466
ok(! exists $seen{'hilton'});           # 467
ok(! exists $seen{'icon'});             # 468
ok(exists $seen{'jerky'});              # 469
%seen = ();

@nonintersection = get_nonintersection('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 470
ok(exists $seen{'baker'});              # 471
ok(exists $seen{'camera'});             # 472
ok(exists $seen{'delta'});              # 473
ok(exists $seen{'edward'});             # 474
ok(! exists $seen{'fargo'});            # 475
ok(! exists $seen{'golfer'});           # 476
ok(exists $seen{'hilton'});             # 477
ok(exists $seen{'icon'});               # 478
ok(exists $seen{'jerky'});              # 479
%seen = ();

$nonintersection_ref = get_nonintersection_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 480
ok(exists $seen{'baker'});              # 481
ok(exists $seen{'camera'});             # 482
ok(exists $seen{'delta'});              # 483
ok(exists $seen{'edward'});             # 484
ok(! exists $seen{'fargo'});            # 485
ok(! exists $seen{'golfer'});           # 486
ok(exists $seen{'hilton'});             # 487
ok(exists $seen{'icon'});               # 488
ok(exists $seen{'jerky'});              # 489
%seen = ();

@bag = get_bag('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 490
ok($seen{'baker'} == 2);                # 491
ok($seen{'camera'} == 2);               # 492
ok($seen{'delta'} == 3);                # 493
ok($seen{'edward'} == 2);               # 494
ok($seen{'fargo'} == 6);                # 495
ok($seen{'golfer'} == 5);               # 496
ok($seen{'hilton'} == 4);               # 497
ok($seen{'icon'} == 5);                 # 498
ok($seen{'jerky'} == 1);                # 499
%seen = ();

$bag_ref = get_bag_ref('-u',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 500
ok($seen{'baker'} == 2);                # 501
ok($seen{'camera'} == 2);               # 502
ok($seen{'delta'} == 3);                # 503
ok($seen{'edward'} == 2);               # 504
ok($seen{'fargo'} == 6);                # 505
ok($seen{'golfer'} == 5);               # 506
ok($seen{'hilton'} == 4);               # 507
ok($seen{'icon'} == 5);                 # 508
ok($seen{'jerky'} == 1);                # 509
%seen = ();

##### BELOW:  Tests for '--unsorted' option ##########

@union = get_union('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 510
ok(exists $seen{'baker'});              # 511
ok(exists $seen{'camera'});             # 512
ok(exists $seen{'delta'});              # 513
ok(exists $seen{'edward'});             # 514
ok(exists $seen{'fargo'});              # 515
ok(exists $seen{'golfer'});             # 516
ok(exists $seen{'hilton'});             # 517
ok(exists $seen{'icon'});               # 518
ok(exists $seen{'jerky'});              # 519
%seen = ();

$union_ref = get_union_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 520
ok(exists $seen{'baker'});              # 521
ok(exists $seen{'camera'});             # 522
ok(exists $seen{'delta'});              # 523
ok(exists $seen{'edward'});             # 524
ok(exists $seen{'fargo'});              # 525
ok(exists $seen{'golfer'});             # 526
ok(exists $seen{'hilton'});             # 527
ok(exists $seen{'icon'});               # 528
ok(exists $seen{'jerky'});              # 529
%seen = ();

@shared = get_shared('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 530
ok(exists $seen{'baker'});              # 531
ok(exists $seen{'camera'});             # 532
ok(exists $seen{'delta'});              # 533
ok(exists $seen{'edward'});             # 534
ok(exists $seen{'fargo'});              # 535
ok(exists $seen{'golfer'});             # 536
ok(exists $seen{'hilton'});             # 537
ok(exists $seen{'icon'});               # 538
ok(! exists $seen{'jerky'});            # 539
%seen = ();

$shared_ref = get_shared_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 540
ok(exists $seen{'baker'});              # 541
ok(exists $seen{'camera'});             # 542
ok(exists $seen{'delta'});              # 543
ok(exists $seen{'edward'});             # 544
ok(exists $seen{'fargo'});              # 545
ok(exists $seen{'golfer'});             # 546
ok(exists $seen{'hilton'});             # 547
ok(exists $seen{'icon'});               # 548
ok(! exists $seen{'jerky'});            # 549
%seen = ();

@intersection = get_intersection('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 550
ok(! exists $seen{'baker'});            # 551
ok(! exists $seen{'camera'});           # 552
ok(! exists $seen{'delta'});            # 553
ok(! exists $seen{'edward'});           # 554
ok(exists $seen{'fargo'});              # 555
ok(exists $seen{'golfer'});             # 556
ok(! exists $seen{'hilton'});           # 557
ok(! exists $seen{'icon'});             # 558
ok(! exists $seen{'jerky'});            # 559
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 560
ok(! exists $seen{'baker'});            # 561
ok(! exists $seen{'camera'});           # 562
ok(! exists $seen{'delta'});            # 563
ok(! exists $seen{'edward'});           # 564
ok(exists $seen{'fargo'});              # 565
ok(exists $seen{'golfer'});             # 566
ok(! exists $seen{'hilton'});           # 567
ok(! exists $seen{'icon'});             # 568
ok(! exists $seen{'jerky'});            # 569
%seen = ();

@unique = get_unique('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 570
ok(! exists $seen{'baker'});            # 571
ok(! exists $seen{'camera'});           # 572
ok(! exists $seen{'delta'});            # 573
ok(! exists $seen{'edward'});           # 574
ok(! exists $seen{'fargo'});            # 575
ok(! exists $seen{'golfer'});           # 576
ok(! exists $seen{'hilton'});           # 577
ok(! exists $seen{'icon'});             # 578
ok(! exists $seen{'jerky'});            # 579
%seen = ();

$unique_ref = get_unique_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 580
ok(! exists $seen{'baker'});            # 581
ok(! exists $seen{'camera'});           # 582
ok(! exists $seen{'delta'});            # 583
ok(! exists $seen{'edward'});           # 584
ok(! exists $seen{'fargo'});            # 585
ok(! exists $seen{'golfer'});           # 586
ok(! exists $seen{'hilton'});           # 587
ok(! exists $seen{'icon'});             # 588
ok(! exists $seen{'jerky'});            # 589
%seen = ();

@unique = get_unique('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 590
ok(! exists $seen{'baker'});            # 591
ok(! exists $seen{'camera'});           # 592
ok(! exists $seen{'delta'});            # 593
ok(! exists $seen{'edward'});           # 594
ok(! exists $seen{'fargo'});            # 595
ok(! exists $seen{'golfer'});           # 596
ok(! exists $seen{'hilton'});           # 597
ok(! exists $seen{'icon'});             # 598
ok(exists $seen{'jerky'});              # 599
%seen = ();

$unique_ref = get_unique_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [2] );
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 600
ok(! exists $seen{'baker'});            # 601
ok(! exists $seen{'camera'});           # 602
ok(! exists $seen{'delta'});            # 603
ok(! exists $seen{'edward'});           # 604
ok(! exists $seen{'fargo'});            # 605
ok(! exists $seen{'golfer'});           # 606
ok(! exists $seen{'hilton'});           # 607
ok(! exists $seen{'icon'});             # 608
ok(exists $seen{'jerky'});              # 609

@complement = get_complement('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 610
ok(! exists $seen{'baker'});            # 611
ok(! exists $seen{'camera'});           # 612
ok(! exists $seen{'delta'});            # 613
ok(! exists $seen{'edward'});           # 614
ok(! exists $seen{'fargo'});            # 615
ok(! exists $seen{'golfer'});           # 616
ok(exists $seen{'hilton'});             # 617
ok(exists $seen{'icon'});               # 618
ok(exists $seen{'jerky'});              # 619
%seen = ();

$complement_ref = get_complement_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 620
ok(! exists $seen{'baker'});            # 621
ok(! exists $seen{'camera'});           # 622
ok(! exists $seen{'delta'});            # 623
ok(! exists $seen{'edward'});           # 624
ok(! exists $seen{'fargo'});            # 625
ok(! exists $seen{'golfer'});           # 626
ok(exists $seen{'hilton'});             # 627
ok(exists $seen{'icon'});               # 628
ok(exists $seen{'jerky'});              # 629
%seen = ();

@complement = get_complement('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 630
ok(exists $seen{'baker'});              # 631
ok(exists $seen{'camera'});             # 632
ok(exists $seen{'delta'});              # 633
ok(exists $seen{'edward'});             # 634
ok(! exists $seen{'fargo'});            # 635
ok(! exists $seen{'golfer'});           # 636
ok(! exists $seen{'hilton'});           # 637
ok(! exists $seen{'icon'});             # 638
ok(exists $seen{'jerky'});              # 639
%seen = ();

$complement_ref = get_complement_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ], [3] );
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 640
ok(exists $seen{'baker'});              # 641
ok(exists $seen{'camera'});             # 642
ok(exists $seen{'delta'});              # 643
ok(exists $seen{'edward'});             # 644
ok(! exists $seen{'fargo'});            # 645
ok(! exists $seen{'golfer'});           # 646
ok(! exists $seen{'hilton'});           # 647
ok(! exists $seen{'icon'});             # 648
ok(exists $seen{'jerky'});              # 649
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 650
ok(! exists $seen{'baker'});            # 651
ok(! exists $seen{'camera'});           # 652
ok(! exists $seen{'delta'});            # 653
ok(! exists $seen{'edward'});           # 654
ok(! exists $seen{'fargo'});            # 655
ok(! exists $seen{'golfer'});           # 656
ok(! exists $seen{'hilton'});           # 657
ok(! exists $seen{'icon'});             # 658
ok(exists $seen{'jerky'});              # 659
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 660
ok(! exists $seen{'baker'});            # 661
ok(! exists $seen{'camera'});           # 662
ok(! exists $seen{'delta'});            # 663
ok(! exists $seen{'edward'});           # 664
ok(! exists $seen{'fargo'});            # 665
ok(! exists $seen{'golfer'});           # 666
ok(! exists $seen{'hilton'});           # 667
ok(! exists $seen{'icon'});             # 668
ok(exists $seen{'jerky'});              # 669
%seen = ();

@symmetric_difference = get_symdiff('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 670
ok(! exists $seen{'baker'});            # 671
ok(! exists $seen{'camera'});           # 672
ok(! exists $seen{'delta'});            # 673
ok(! exists $seen{'edward'});           # 674
ok(! exists $seen{'fargo'});            # 675
ok(! exists $seen{'golfer'});           # 676
ok(! exists $seen{'hilton'});           # 677
ok(! exists $seen{'icon'});             # 678
ok(exists $seen{'jerky'});              # 679
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 680
ok(! exists $seen{'baker'});            # 681
ok(! exists $seen{'camera'});           # 682
ok(! exists $seen{'delta'});            # 683
ok(! exists $seen{'edward'});           # 684
ok(! exists $seen{'fargo'});            # 685
ok(! exists $seen{'golfer'});           # 686
ok(! exists $seen{'hilton'});           # 687
ok(! exists $seen{'icon'});             # 688
ok(exists $seen{'jerky'});              # 689
%seen = ();

@nonintersection = get_nonintersection('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 690
ok(exists $seen{'baker'});              # 691
ok(exists $seen{'camera'});             # 692
ok(exists $seen{'delta'});              # 693
ok(exists $seen{'edward'});             # 694
ok(! exists $seen{'fargo'});            # 695
ok(! exists $seen{'golfer'});           # 696
ok(exists $seen{'hilton'});             # 697
ok(exists $seen{'icon'});               # 698
ok(exists $seen{'jerky'});              # 699
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 700
ok(exists $seen{'baker'});              # 701
ok(exists $seen{'camera'});             # 702
ok(exists $seen{'delta'});              # 703
ok(exists $seen{'edward'});             # 704
ok(! exists $seen{'fargo'});            # 705
ok(! exists $seen{'golfer'});           # 706
ok(exists $seen{'hilton'});             # 707
ok(exists $seen{'icon'});               # 708
ok(exists $seen{'jerky'});              # 709
%seen = ();

@bag = get_bag('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 710
ok($seen{'baker'} == 2);                # 711
ok($seen{'camera'} == 2);               # 712
ok($seen{'delta'} == 3);                # 713
ok($seen{'edward'} == 2);               # 714
ok($seen{'fargo'} == 6);                # 715
ok($seen{'golfer'} == 5);               # 716
ok($seen{'hilton'} == 4);               # 717
ok($seen{'icon'} == 5);                 # 718
ok($seen{'jerky'} == 1);                # 719
%seen = ();

$bag_ref = get_bag_ref('--unsorted',  [ \@a0, \@a1, \@a2, \@a3, \@a4 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 720
ok($seen{'baker'} == 2);                # 721
ok($seen{'camera'} == 2);               # 722
ok($seen{'delta'} == 3);                # 723
ok($seen{'edward'} == 2);               # 724
ok($seen{'fargo'} == 6);                # 725
ok($seen{'golfer'} == 5);               # 726
ok($seen{'hilton'} == 4);               # 727
ok($seen{'icon'} == 5);                 # 728
ok($seen{'jerky'} == 1);                # 729
%seen = ();

########## Tests of passing refs to named arrays to functions ##########

my @allarrays = (\@a0, \@a1, \@a2, \@a3, \@a4); 
@intersection = get_intersection('--unsorted', \@allarrays );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 730
ok(! exists $seen{'baker'});            # 731
ok(! exists $seen{'camera'});           # 732
ok(! exists $seen{'delta'});            # 733
ok(! exists $seen{'edward'});           # 734
ok(exists $seen{'fargo'});              # 735
ok(exists $seen{'golfer'});             # 736
ok(! exists $seen{'hilton'});           # 737
ok(! exists $seen{'icon'});             # 738
ok(! exists $seen{'jerky'});            # 739
%seen = ();

@unique = get_unique('--unsorted', \@allarrays, [2] );
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 740
ok(! exists $seen{'baker'});            # 741
ok(! exists $seen{'camera'});           # 742
ok(! exists $seen{'delta'});            # 743
ok(! exists $seen{'edward'});           # 744
ok(! exists $seen{'fargo'});            # 745
ok(! exists $seen{'golfer'});           # 746
ok(! exists $seen{'hilton'});           # 747
ok(! exists $seen{'icon'});             # 748
ok(exists $seen{'jerky'});              # 749
%seen = ();


