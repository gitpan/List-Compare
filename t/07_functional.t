# 07_functional.t # revised 3/30/04 to accommodate new interface to List::Compare::Functional # as of 04/25/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
612;
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

@union = get_union( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 2
ok(exists $seen{'baker'});              # 3
ok(exists $seen{'camera'});             # 4
ok(exists $seen{'delta'});              # 5
ok(exists $seen{'edward'});             # 6
ok(exists $seen{'fargo'});              # 7
ok(exists $seen{'golfer'});             # 8
ok(exists $seen{'hilton'});             # 9
ok(! exists $seen{'icon'});             # 10
ok(! exists $seen{'jerky'});            # 11
%seen = ();

$union_ref = get_union_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 12
ok(exists $seen{'baker'});              # 13
ok(exists $seen{'camera'});             # 14
ok(exists $seen{'delta'});              # 15
ok(exists $seen{'edward'});             # 16
ok(exists $seen{'fargo'});              # 17
ok(exists $seen{'golfer'});             # 18
ok(exists $seen{'hilton'});             # 19
ok(! exists $seen{'icon'});             # 20
ok(! exists $seen{'jerky'});            # 21
%seen = ();

@shared = get_shared( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 22
ok(exists $seen{'baker'});              # 23
ok(exists $seen{'camera'});             # 24
ok(exists $seen{'delta'});              # 25
ok(exists $seen{'edward'});             # 26
ok(exists $seen{'fargo'});              # 27
ok(exists $seen{'golfer'});             # 28
ok(! exists $seen{'hilton'});           # 29
ok(! exists $seen{'icon'});             # 30
ok(! exists $seen{'jerky'});            # 31
%seen = ();

$shared_ref = get_shared_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 32
ok(exists $seen{'baker'});              # 33
ok(exists $seen{'camera'});             # 34
ok(exists $seen{'delta'});              # 35
ok(exists $seen{'edward'});             # 36
ok(exists $seen{'fargo'});              # 37
ok(exists $seen{'golfer'});             # 38
ok(! exists $seen{'hilton'});           # 39
ok(! exists $seen{'icon'});             # 40
ok(! exists $seen{'jerky'});            # 41
%seen = ();

@intersection = get_intersection( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 42
ok(exists $seen{'baker'});              # 43
ok(exists $seen{'camera'});             # 44
ok(exists $seen{'delta'});              # 45
ok(exists $seen{'edward'});             # 46
ok(exists $seen{'fargo'});              # 47
ok(exists $seen{'golfer'});             # 48
ok(! exists $seen{'hilton'});           # 49
ok(! exists $seen{'icon'});             # 50
ok(! exists $seen{'jerky'});            # 51
%seen = ();

$intersection_ref = get_intersection_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 52
ok(exists $seen{'baker'});              # 53
ok(exists $seen{'camera'});             # 54
ok(exists $seen{'delta'});              # 55
ok(exists $seen{'edward'});             # 56
ok(exists $seen{'fargo'});              # 57
ok(exists $seen{'golfer'});             # 58
ok(! exists $seen{'hilton'});           # 59
ok(! exists $seen{'icon'});             # 60
ok(! exists $seen{'jerky'});            # 61
%seen = ();

@unique = get_unique( [ \@a0, \@a1 ] );
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

$unique_ref = get_unique_ref( [ \@a0, \@a1 ] );
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

@complement = get_complement( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 82
ok(! exists $seen{'baker'});            # 83
ok(! exists $seen{'camera'});           # 84
ok(! exists $seen{'delta'});            # 85
ok(! exists $seen{'edward'});           # 86
ok(! exists $seen{'fargo'});            # 87
ok(! exists $seen{'golfer'});           # 88
ok(exists $seen{'hilton'});             # 89
ok(! exists $seen{'icon'});             # 90
ok(! exists $seen{'jerky'});            # 91
%seen = ();

$complement_ref = get_complement_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 92
ok(! exists $seen{'baker'});            # 93
ok(! exists $seen{'camera'});           # 94
ok(! exists $seen{'delta'});            # 95
ok(! exists $seen{'edward'});           # 96
ok(! exists $seen{'fargo'});            # 97
ok(! exists $seen{'golfer'});           # 98
ok(exists $seen{'hilton'});             # 99
ok(! exists $seen{'icon'});             # 100
ok(! exists $seen{'jerky'});            # 101
%seen = ();

@symmetric_difference = get_symmetric_difference( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 102
ok(! exists $seen{'baker'});            # 103
ok(! exists $seen{'camera'});           # 104
ok(! exists $seen{'delta'});            # 105
ok(! exists $seen{'edward'});           # 106
ok(! exists $seen{'fargo'});            # 107
ok(! exists $seen{'golfer'});           # 108
ok(exists $seen{'hilton'});             # 109
ok(! exists $seen{'icon'});             # 110
ok(! exists $seen{'jerky'});            # 111
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 112
ok(! exists $seen{'baker'});            # 113
ok(! exists $seen{'camera'});           # 114
ok(! exists $seen{'delta'});            # 115
ok(! exists $seen{'edward'});           # 116
ok(! exists $seen{'fargo'});            # 117
ok(! exists $seen{'golfer'});           # 118
ok(exists $seen{'hilton'});             # 119
ok(! exists $seen{'icon'});             # 120
ok(! exists $seen{'jerky'});            # 121
%seen = ();

@symmetric_difference = get_symdiff( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 122
ok(! exists $seen{'baker'});            # 123
ok(! exists $seen{'camera'});           # 124
ok(! exists $seen{'delta'});            # 125
ok(! exists $seen{'edward'});           # 126
ok(! exists $seen{'fargo'});            # 127
ok(! exists $seen{'golfer'});           # 128
ok(exists $seen{'hilton'});             # 129
ok(! exists $seen{'icon'});             # 130
ok(! exists $seen{'jerky'});            # 131
%seen = ();

$symmetric_difference_ref = get_symdiff_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 132
ok(! exists $seen{'baker'});            # 133
ok(! exists $seen{'camera'});           # 134
ok(! exists $seen{'delta'});            # 135
ok(! exists $seen{'edward'});           # 136
ok(! exists $seen{'fargo'});            # 137
ok(! exists $seen{'golfer'});           # 138
ok(exists $seen{'hilton'});             # 139
ok(! exists $seen{'icon'});             # 140
ok(! exists $seen{'jerky'});            # 141
%seen = ();

@nonintersection = get_nonintersection( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 142
ok(! exists $seen{'baker'});            # 143
ok(! exists $seen{'camera'});           # 144
ok(! exists $seen{'delta'});            # 145
ok(! exists $seen{'edward'});           # 146
ok(! exists $seen{'fargo'});            # 147
ok(! exists $seen{'golfer'});           # 148
ok(exists $seen{'hilton'});             # 149
ok(! exists $seen{'icon'});             # 150
ok(! exists $seen{'jerky'});            # 151
%seen = ();

$nonintersection_ref = get_nonintersection_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 152
ok(! exists $seen{'baker'});            # 153
ok(! exists $seen{'camera'});           # 154
ok(! exists $seen{'delta'});            # 155
ok(! exists $seen{'edward'});           # 156
ok(! exists $seen{'fargo'});            # 157
ok(! exists $seen{'golfer'});           # 158
ok(exists $seen{'hilton'});             # 159
ok(! exists $seen{'icon'});             # 160
ok(! exists $seen{'jerky'});            # 161
%seen = ();

@bag = get_bag( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 162
ok($seen{'baker'} == 2);                # 163
ok($seen{'camera'} == 2);               # 164
ok($seen{'delta'} == 3);                # 165
ok($seen{'edward'} == 2);               # 166
ok($seen{'fargo'} == 2);                # 167
ok($seen{'golfer'} == 2);               # 168
ok($seen{'hilton'} == 1);               # 169
ok(! exists $seen{'icon'});             # 170
ok(! exists $seen{'jerky'});            # 171
%seen = ();

$bag_ref = get_bag_ref( [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 172
ok($seen{'baker'} == 2);                # 173
ok($seen{'camera'} == 2);               # 174
ok($seen{'delta'} == 3);                # 175
ok($seen{'edward'} == 2);               # 176
ok($seen{'fargo'} == 2);                # 177
ok($seen{'golfer'} == 2);               # 178
ok($seen{'hilton'} == 1);               # 179
ok(! exists $seen{'icon'});             # 180
ok(! exists $seen{'jerky'});            # 181
%seen = ();

$LR = is_LsubsetR( [ \@a0, \@a1 ] );
ok(! $LR);                              # 182

$RL = is_RsubsetL( [ \@a0, \@a1 ] );
ok(! $RL);                              # 183

$eqv = is_LequivalentR( [ \@a0, \@a1 ] );
ok(! $eqv);                             # 184

$eqv = is_LeqvlntR( [ \@a0, \@a1 ] );
ok(! $eqv);                             # 185

$disj = is_LdisjointR( [ \@a0, \@a1 ] );
ok(! $disj);                            # 186

$return = print_subset_chart( [ \@a0, \@a1 ] );
ok($return);                            # 187

$return = print_equivalence_chart( [ \@a0, \@a1 ] );
ok($return);                            # 188

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'abel' ] );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 189

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'baker' ] );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 190

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'camera' ] );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 191

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'delta' ] );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 192

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'edward' ] );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 193

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'fargo' ] );
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 194

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'golfer' ] );
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 195

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'hilton' ] );
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 196

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'icon' ] );
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 197

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'jerky' ] );
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 198

@memb_arr = is_member_which( [ \@a0, \@a1 ] , [ 'zebra' ] );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 199

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'abel' ] );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 200

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'baker' ] );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 201

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'camera' ] );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 202

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'delta' ] );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 203

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'edward' ] );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 204

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'fargo' ] );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 205

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'golfer' ] );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 206

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'hilton' ] );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 207

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'icon' ] );
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 208

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'jerky' ] );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 209

$memb_arr_ref = is_member_which_ref( [ \@a0, \@a1 ] , [ 'zebra' ] );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 210

$memb_hash_ref = are_members_which(
     [ \@a0, \@a1 ] , 
[ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 211
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 212
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 213
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 214
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 215
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 216
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 217
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 218
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 219
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 220
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 221

ok(is_member_any( [ \@a0, \@a1 ] , [ 'abel' ] ));# 222
ok(is_member_any( [ \@a0, \@a1 ] , [ 'baker' ] ));# 223
ok(is_member_any( [ \@a0, \@a1 ] , [ 'camera' ] ));# 224
ok(is_member_any( [ \@a0, \@a1 ] , [ 'delta' ] ));# 225
ok(is_member_any( [ \@a0, \@a1 ] , [ 'edward' ] ));# 226
ok(is_member_any( [ \@a0, \@a1 ] , [ 'fargo' ] ));# 227
ok(is_member_any( [ \@a0, \@a1 ] , [ 'golfer' ] ));# 228
ok(is_member_any( [ \@a0, \@a1 ] , [ 'hilton' ] ));# 229
ok(! is_member_any( [ \@a0, \@a1 ] , [ 'icon' ] ));# 230
ok(! is_member_any( [ \@a0, \@a1 ] , [ 'jerky' ] ));# 231
ok(! is_member_any( [ \@a0, \@a1 ] , [ 'zebra' ] ));# 232

$memb_hash_ref = are_members_any(  [ \@a0, \@a1 ] , 
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 233
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 234
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 235
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 236
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 237
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 238
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 239
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 240
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 241
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 242
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 243

$vers = get_version;
ok($vers);                              # 244

$LR = is_LsubsetR( [ \@a2, \@a3 ] );
ok(! $LR);                              # 245

$RL = is_RsubsetL( [ \@a2, \@a3 ] );
ok($RL);                                # 246

$eqv = is_LequivalentR( [ \@a2, \@a3 ] );
ok(! $eqv);                             # 247

$eqv = is_LeqvlntR( [ \@a2, \@a3 ] );
ok(! $eqv);                             # 248

$eqv = is_LequivalentR( [ \@a3, \@a4 ] );
ok($eqv);                               # 249

$eqv = is_LeqvlntR( [ \@a3, \@a4 ] );
ok($eqv);                               # 250

$disj = is_LdisjointR( [ \@a3, \@a4 ] );
ok(! $disj);                            # 251

$disj = is_LdisjointR( [ \@a4, \@a8 ] );
ok($disj);                              # 252

########## BELOW:  Tests for '-u' option ##########

@union = get_union('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 253
ok(exists $seen{'baker'});              # 254
ok(exists $seen{'camera'});             # 255
ok(exists $seen{'delta'});              # 256
ok(exists $seen{'edward'});             # 257
ok(exists $seen{'fargo'});              # 258
ok(exists $seen{'golfer'});             # 259
ok(exists $seen{'hilton'});             # 260
ok(! exists $seen{'icon'});             # 261
ok(! exists $seen{'jerky'});            # 262
%seen = ();

$union_ref = get_union_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 263
ok(exists $seen{'baker'});              # 264
ok(exists $seen{'camera'});             # 265
ok(exists $seen{'delta'});              # 266
ok(exists $seen{'edward'});             # 267
ok(exists $seen{'fargo'});              # 268
ok(exists $seen{'golfer'});             # 269
ok(exists $seen{'hilton'});             # 270
ok(! exists $seen{'icon'});             # 271
ok(! exists $seen{'jerky'});            # 272
%seen = ();

@shared = get_shared('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 273
ok(exists $seen{'baker'});              # 274
ok(exists $seen{'camera'});             # 275
ok(exists $seen{'delta'});              # 276
ok(exists $seen{'edward'});             # 277
ok(exists $seen{'fargo'});              # 278
ok(exists $seen{'golfer'});             # 279
ok(! exists $seen{'hilton'});           # 280
ok(! exists $seen{'icon'});             # 281
ok(! exists $seen{'jerky'});            # 282
%seen = ();

$shared_ref = get_shared_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 283
ok(exists $seen{'baker'});              # 284
ok(exists $seen{'camera'});             # 285
ok(exists $seen{'delta'});              # 286
ok(exists $seen{'edward'});             # 287
ok(exists $seen{'fargo'});              # 288
ok(exists $seen{'golfer'});             # 289
ok(! exists $seen{'hilton'});           # 290
ok(! exists $seen{'icon'});             # 291
ok(! exists $seen{'jerky'});            # 292
%seen = ();

@intersection = get_intersection('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 293
ok(exists $seen{'baker'});              # 294
ok(exists $seen{'camera'});             # 295
ok(exists $seen{'delta'});              # 296
ok(exists $seen{'edward'});             # 297
ok(exists $seen{'fargo'});              # 298
ok(exists $seen{'golfer'});             # 299
ok(! exists $seen{'hilton'});           # 300
ok(! exists $seen{'icon'});             # 301
ok(! exists $seen{'jerky'});            # 302
%seen = ();

$intersection_ref = get_intersection_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 303
ok(exists $seen{'baker'});              # 304
ok(exists $seen{'camera'});             # 305
ok(exists $seen{'delta'});              # 306
ok(exists $seen{'edward'});             # 307
ok(exists $seen{'fargo'});              # 308
ok(exists $seen{'golfer'});             # 309
ok(! exists $seen{'hilton'});           # 310
ok(! exists $seen{'icon'});             # 311
ok(! exists $seen{'jerky'});            # 312
%seen = ();

@unique = get_unique('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 313
ok(! exists $seen{'baker'});            # 314
ok(! exists $seen{'camera'});           # 315
ok(! exists $seen{'delta'});            # 316
ok(! exists $seen{'edward'});           # 317
ok(! exists $seen{'fargo'});            # 318
ok(! exists $seen{'golfer'});           # 319
ok(! exists $seen{'hilton'});           # 320
ok(! exists $seen{'icon'});             # 321
ok(! exists $seen{'jerky'});            # 322
%seen = ();

$unique_ref = get_unique_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 323
ok(! exists $seen{'baker'});            # 324
ok(! exists $seen{'camera'});           # 325
ok(! exists $seen{'delta'});            # 326
ok(! exists $seen{'edward'});           # 327
ok(! exists $seen{'fargo'});            # 328
ok(! exists $seen{'golfer'});           # 329
ok(! exists $seen{'hilton'});           # 330
ok(! exists $seen{'icon'});             # 331
ok(! exists $seen{'jerky'});            # 332
%seen = ();

@complement = get_complement('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 333
ok(! exists $seen{'baker'});            # 334
ok(! exists $seen{'camera'});           # 335
ok(! exists $seen{'delta'});            # 336
ok(! exists $seen{'edward'});           # 337
ok(! exists $seen{'fargo'});            # 338
ok(! exists $seen{'golfer'});           # 339
ok(exists $seen{'hilton'});             # 340
ok(! exists $seen{'icon'});             # 341
ok(! exists $seen{'jerky'});            # 342
%seen = ();

$complement_ref = get_complement_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 343
ok(! exists $seen{'baker'});            # 344
ok(! exists $seen{'camera'});           # 345
ok(! exists $seen{'delta'});            # 346
ok(! exists $seen{'edward'});           # 347
ok(! exists $seen{'fargo'});            # 348
ok(! exists $seen{'golfer'});           # 349
ok(exists $seen{'hilton'});             # 350
ok(! exists $seen{'icon'});             # 351
ok(! exists $seen{'jerky'});            # 352
%seen = ();

@symmetric_difference = get_symmetric_difference('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 353
ok(! exists $seen{'baker'});            # 354
ok(! exists $seen{'camera'});           # 355
ok(! exists $seen{'delta'});            # 356
ok(! exists $seen{'edward'});           # 357
ok(! exists $seen{'fargo'});            # 358
ok(! exists $seen{'golfer'});           # 359
ok(exists $seen{'hilton'});             # 360
ok(! exists $seen{'icon'});             # 361
ok(! exists $seen{'jerky'});            # 362
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 363
ok(! exists $seen{'baker'});            # 364
ok(! exists $seen{'camera'});           # 365
ok(! exists $seen{'delta'});            # 366
ok(! exists $seen{'edward'});           # 367
ok(! exists $seen{'fargo'});            # 368
ok(! exists $seen{'golfer'});           # 369
ok(exists $seen{'hilton'});             # 370
ok(! exists $seen{'icon'});             # 371
ok(! exists $seen{'jerky'});            # 372
%seen = ();

@symmetric_difference = get_symdiff('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 373
ok(! exists $seen{'baker'});            # 374
ok(! exists $seen{'camera'});           # 375
ok(! exists $seen{'delta'});            # 376
ok(! exists $seen{'edward'});           # 377
ok(! exists $seen{'fargo'});            # 378
ok(! exists $seen{'golfer'});           # 379
ok(exists $seen{'hilton'});             # 380
ok(! exists $seen{'icon'});             # 381
ok(! exists $seen{'jerky'});            # 382
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 383
ok(! exists $seen{'baker'});            # 384
ok(! exists $seen{'camera'});           # 385
ok(! exists $seen{'delta'});            # 386
ok(! exists $seen{'edward'});           # 387
ok(! exists $seen{'fargo'});            # 388
ok(! exists $seen{'golfer'});           # 389
ok(exists $seen{'hilton'});             # 390
ok(! exists $seen{'icon'});             # 391
ok(! exists $seen{'jerky'});            # 392
%seen = ();

@nonintersection = get_nonintersection('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 393
ok(! exists $seen{'baker'});            # 394
ok(! exists $seen{'camera'});           # 395
ok(! exists $seen{'delta'});            # 396
ok(! exists $seen{'edward'});           # 397
ok(! exists $seen{'fargo'});            # 398
ok(! exists $seen{'golfer'});           # 399
ok(exists $seen{'hilton'});             # 400
ok(! exists $seen{'icon'});             # 401
ok(! exists $seen{'jerky'});            # 402
%seen = ();

$nonintersection_ref = get_nonintersection_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 403
ok(! exists $seen{'baker'});            # 404
ok(! exists $seen{'camera'});           # 405
ok(! exists $seen{'delta'});            # 406
ok(! exists $seen{'edward'});           # 407
ok(! exists $seen{'fargo'});            # 408
ok(! exists $seen{'golfer'});           # 409
ok(exists $seen{'hilton'});             # 410
ok(! exists $seen{'icon'});             # 411
ok(! exists $seen{'jerky'});            # 412
%seen = ();

@bag = get_bag('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 413
ok($seen{'baker'} == 2);                # 414
ok($seen{'camera'} == 2);               # 415
ok($seen{'delta'} == 3);                # 416
ok($seen{'edward'} == 2);               # 417
ok($seen{'fargo'} == 2);                # 418
ok($seen{'golfer'} == 2);               # 419
ok($seen{'hilton'} == 1);               # 420
ok(! exists $seen{'icon'});             # 421
ok(! exists $seen{'jerky'});            # 422
%seen = ();

$bag_ref = get_bag_ref('-u',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 423
ok($seen{'baker'} == 2);                # 424
ok($seen{'camera'} == 2);               # 425
ok($seen{'delta'} == 3);                # 426
ok($seen{'edward'} == 2);               # 427
ok($seen{'fargo'} == 2);                # 428
ok($seen{'golfer'} == 2);               # 429
ok($seen{'hilton'} == 1);               # 430
ok(! exists $seen{'icon'});             # 431
ok(! exists $seen{'jerky'});            # 432
%seen = ();

##### BELOW:  Tests for '--unsorted' option ##########

@union = get_union('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 433
ok(exists $seen{'baker'});              # 434
ok(exists $seen{'camera'});             # 435
ok(exists $seen{'delta'});              # 436
ok(exists $seen{'edward'});             # 437
ok(exists $seen{'fargo'});              # 438
ok(exists $seen{'golfer'});             # 439
ok(exists $seen{'hilton'});             # 440
ok(! exists $seen{'icon'});             # 441
ok(! exists $seen{'jerky'});            # 442
%seen = ();

$union_ref = get_union_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 443
ok(exists $seen{'baker'});              # 444
ok(exists $seen{'camera'});             # 445
ok(exists $seen{'delta'});              # 446
ok(exists $seen{'edward'});             # 447
ok(exists $seen{'fargo'});              # 448
ok(exists $seen{'golfer'});             # 449
ok(exists $seen{'hilton'});             # 450
ok(! exists $seen{'icon'});             # 451
ok(! exists $seen{'jerky'});            # 452
%seen = ();

@shared = get_shared('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 453
ok(exists $seen{'baker'});              # 454
ok(exists $seen{'camera'});             # 455
ok(exists $seen{'delta'});              # 456
ok(exists $seen{'edward'});             # 457
ok(exists $seen{'fargo'});              # 458
ok(exists $seen{'golfer'});             # 459
ok(! exists $seen{'hilton'});           # 460
ok(! exists $seen{'icon'});             # 461
ok(! exists $seen{'jerky'});            # 462
%seen = ();

$shared_ref = get_shared_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 463
ok(exists $seen{'baker'});              # 464
ok(exists $seen{'camera'});             # 465
ok(exists $seen{'delta'});              # 466
ok(exists $seen{'edward'});             # 467
ok(exists $seen{'fargo'});              # 468
ok(exists $seen{'golfer'});             # 469
ok(! exists $seen{'hilton'});           # 470
ok(! exists $seen{'icon'});             # 471
ok(! exists $seen{'jerky'});            # 472
%seen = ();

@intersection = get_intersection('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 473
ok(exists $seen{'baker'});              # 474
ok(exists $seen{'camera'});             # 475
ok(exists $seen{'delta'});              # 476
ok(exists $seen{'edward'});             # 477
ok(exists $seen{'fargo'});              # 478
ok(exists $seen{'golfer'});             # 479
ok(! exists $seen{'hilton'});           # 480
ok(! exists $seen{'icon'});             # 481
ok(! exists $seen{'jerky'});            # 482
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 483
ok(exists $seen{'baker'});              # 484
ok(exists $seen{'camera'});             # 485
ok(exists $seen{'delta'});              # 486
ok(exists $seen{'edward'});             # 487
ok(exists $seen{'fargo'});              # 488
ok(exists $seen{'golfer'});             # 489
ok(! exists $seen{'hilton'});           # 490
ok(! exists $seen{'icon'});             # 491
ok(! exists $seen{'jerky'});            # 492
%seen = ();

@unique = get_unique('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 493
ok(! exists $seen{'baker'});            # 494
ok(! exists $seen{'camera'});           # 495
ok(! exists $seen{'delta'});            # 496
ok(! exists $seen{'edward'});           # 497
ok(! exists $seen{'fargo'});            # 498
ok(! exists $seen{'golfer'});           # 499
ok(! exists $seen{'hilton'});           # 500
ok(! exists $seen{'icon'});             # 501
ok(! exists $seen{'jerky'});            # 502
%seen = ();

$unique_ref = get_unique_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 503
ok(! exists $seen{'baker'});            # 504
ok(! exists $seen{'camera'});           # 505
ok(! exists $seen{'delta'});            # 506
ok(! exists $seen{'edward'});           # 507
ok(! exists $seen{'fargo'});            # 508
ok(! exists $seen{'golfer'});           # 509
ok(! exists $seen{'hilton'});           # 510
ok(! exists $seen{'icon'});             # 511
ok(! exists $seen{'jerky'});            # 512
%seen = ();

@complement = get_complement('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 513
ok(! exists $seen{'baker'});            # 514
ok(! exists $seen{'camera'});           # 515
ok(! exists $seen{'delta'});            # 516
ok(! exists $seen{'edward'});           # 517
ok(! exists $seen{'fargo'});            # 518
ok(! exists $seen{'golfer'});           # 519
ok(exists $seen{'hilton'});             # 520
ok(! exists $seen{'icon'});             # 521
ok(! exists $seen{'jerky'});            # 522
%seen = ();

$complement_ref = get_complement_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 523
ok(! exists $seen{'baker'});            # 524
ok(! exists $seen{'camera'});           # 525
ok(! exists $seen{'delta'});            # 526
ok(! exists $seen{'edward'});           # 527
ok(! exists $seen{'fargo'});            # 528
ok(! exists $seen{'golfer'});           # 529
ok(exists $seen{'hilton'});             # 530
ok(! exists $seen{'icon'});             # 531
ok(! exists $seen{'jerky'});            # 532
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 533
ok(! exists $seen{'baker'});            # 534
ok(! exists $seen{'camera'});           # 535
ok(! exists $seen{'delta'});            # 536
ok(! exists $seen{'edward'});           # 537
ok(! exists $seen{'fargo'});            # 538
ok(! exists $seen{'golfer'});           # 539
ok(exists $seen{'hilton'});             # 540
ok(! exists $seen{'icon'});             # 541
ok(! exists $seen{'jerky'});            # 542
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 543
ok(! exists $seen{'baker'});            # 544
ok(! exists $seen{'camera'});           # 545
ok(! exists $seen{'delta'});            # 546
ok(! exists $seen{'edward'});           # 547
ok(! exists $seen{'fargo'});            # 548
ok(! exists $seen{'golfer'});           # 549
ok(exists $seen{'hilton'});             # 550
ok(! exists $seen{'icon'});             # 551
ok(! exists $seen{'jerky'});            # 552
%seen = ();

@symmetric_difference = get_symdiff('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 553
ok(! exists $seen{'baker'});            # 554
ok(! exists $seen{'camera'});           # 555
ok(! exists $seen{'delta'});            # 556
ok(! exists $seen{'edward'});           # 557
ok(! exists $seen{'fargo'});            # 558
ok(! exists $seen{'golfer'});           # 559
ok(exists $seen{'hilton'});             # 560
ok(! exists $seen{'icon'});             # 561
ok(! exists $seen{'jerky'});            # 562
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 563
ok(! exists $seen{'baker'});            # 564
ok(! exists $seen{'camera'});           # 565
ok(! exists $seen{'delta'});            # 566
ok(! exists $seen{'edward'});           # 567
ok(! exists $seen{'fargo'});            # 568
ok(! exists $seen{'golfer'});           # 569
ok(exists $seen{'hilton'});             # 570
ok(! exists $seen{'icon'});             # 571
ok(! exists $seen{'jerky'});            # 572
%seen = ();

@nonintersection = get_nonintersection('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 573
ok(! exists $seen{'baker'});            # 574
ok(! exists $seen{'camera'});           # 575
ok(! exists $seen{'delta'});            # 576
ok(! exists $seen{'edward'});           # 577
ok(! exists $seen{'fargo'});            # 578
ok(! exists $seen{'golfer'});           # 579
ok(exists $seen{'hilton'});             # 580
ok(! exists $seen{'icon'});             # 581
ok(! exists $seen{'jerky'});            # 582
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 583
ok(! exists $seen{'baker'});            # 584
ok(! exists $seen{'camera'});           # 585
ok(! exists $seen{'delta'});            # 586
ok(! exists $seen{'edward'});           # 587
ok(! exists $seen{'fargo'});            # 588
ok(! exists $seen{'golfer'});           # 589
ok(exists $seen{'hilton'});             # 590
ok(! exists $seen{'icon'});             # 591
ok(! exists $seen{'jerky'});            # 592
%seen = ();

@bag = get_bag('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 593
ok($seen{'baker'} == 2);                # 594
ok($seen{'camera'} == 2);               # 595
ok($seen{'delta'} == 3);                # 596
ok($seen{'edward'} == 2);               # 597
ok($seen{'fargo'} == 2);                # 598
ok($seen{'golfer'} == 2);               # 599
ok($seen{'hilton'} == 1);               # 600
ok(! exists $seen{'icon'});             # 601
ok(! exists $seen{'jerky'});            # 602
%seen = ();

$bag_ref = get_bag_ref('--unsorted',  [ \@a0, \@a1 ] );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 603
ok($seen{'baker'} == 2);                # 604
ok($seen{'camera'} == 2);               # 605
ok($seen{'delta'} == 3);                # 606
ok($seen{'edward'} == 2);               # 607
ok($seen{'fargo'} == 2);                # 608
ok($seen{'golfer'} == 2);               # 609
ok($seen{'hilton'} == 1);               # 610
ok(! exists $seen{'icon'});             # 611
ok(! exists $seen{'jerky'});            # 612
%seen = ();

