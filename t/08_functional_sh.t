# 08_functional_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 
use Test::Simple tests =>
609;
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

my (%h0, %h1, %h2, %h3, %h4);
$h0{$_}++ for @a0;
$h1{$_}++ for @a1;
$h2{$_}++ for @a2;
$h3{$_}++ for @a3;
$h4{$_}++ for @a4;

@union = get_union( [ \%h0, \%h1 ] );
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

$union_ref = get_union_ref( [ \%h0, \%h1 ] );
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

@shared = get_shared( [ \%h0, \%h1 ] );
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

$shared_ref = get_shared_ref( [ \%h0, \%h1 ] );
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

@intersection = get_intersection( [ \%h0, \%h1 ] );
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

$intersection_ref = get_intersection_ref( [ \%h0, \%h1 ] );
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

@unique = get_unique( [ \%h0, \%h1 ] );
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

$unique_ref = get_unique_ref( [ \%h0, \%h1 ] );
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

@complement = get_complement( [ \%h0, \%h1 ] );
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

$complement_ref = get_complement_ref( [ \%h0, \%h1 ] );
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

@symmetric_difference = get_symmetric_difference( [ \%h0, \%h1 ] );
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

$symmetric_difference_ref = get_symmetric_difference_ref( [ \%h0, \%h1 ] );
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

@symmetric_difference = get_symdiff( [ \%h0, \%h1 ] );
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

$symmetric_difference_ref = get_symdiff_ref( [ \%h0, \%h1 ] );
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

@nonintersection = get_nonintersection( [ \%h0, \%h1 ] );
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

$nonintersection_ref = get_nonintersection_ref( [ \%h0, \%h1 ] );
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

@bag = get_bag( [ \%h0, \%h1 ] );
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

$bag_ref = get_bag_ref( [ \%h0, \%h1 ] );
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

$LR = is_LsubsetR( [ \%h0, \%h1 ] );
ok(! $LR);                              # 182

$RL = is_RsubsetL( [ \%h0, \%h1 ] );
ok(! $RL);                              # 183

$eqv = is_LequivalentR( [ \%h0, \%h1 ] );
ok(! $eqv);                             # 184

$eqv = is_LeqvlntR( [ \%h0, \%h1 ] );
ok(! $eqv);                             # 185

$return = print_subset_chart( [ \%h0, \%h1 ] );
ok($return);                            # 186

$return = print_equivalence_chart( [ \%h0, \%h1 ] );
ok($return);                            # 187

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'abel' ] );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 188

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'baker' ] );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 189

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'camera' ] );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 190

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'delta' ] );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 191

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'edward' ] );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 192

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'fargo' ] );
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 193

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'golfer' ] );
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 194

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'hilton' ] );
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 195

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'icon' ] );
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 196

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'jerky' ] );
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 197

@memb_arr = is_member_which( [ \%h0, \%h1 ], [ 'zebra' ] );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 198


$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'abel' ] );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 199

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'baker' ] );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 200

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'camera' ] );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 201

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'delta' ] );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 202

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'edward' ] );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 203

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'fargo' ] );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 204

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'golfer' ] );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 205

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'hilton' ] );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 206

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'icon' ] );
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 207

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'jerky' ] );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 208

$memb_arr_ref = is_member_which_ref( [ \%h0, \%h1 ], [ 'zebra' ] );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 209


$memb_hash_ref = are_members_which( [ \%h0, \%h1 ] , 
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ]);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 210
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 211
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 212
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 213
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 214
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 215
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 216
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 217
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 218
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 219
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 220

ok(is_member_any( [ \%h0, \%h1 ], [ 'abel' ] ));# 221
ok(is_member_any( [ \%h0, \%h1 ], [ 'baker' ] ));# 222
ok(is_member_any( [ \%h0, \%h1 ], [ 'camera' ] ));# 223
ok(is_member_any( [ \%h0, \%h1 ], [ 'delta' ] ));# 224
ok(is_member_any( [ \%h0, \%h1 ], [ 'edward' ] ));# 225
ok(is_member_any( [ \%h0, \%h1 ], [ 'fargo' ] ));# 226
ok(is_member_any( [ \%h0, \%h1 ], [ 'golfer' ] ));# 227
ok(is_member_any( [ \%h0, \%h1 ], [ 'hilton' ] ));# 228
ok(! is_member_any( [ \%h0, \%h1 ], [ 'icon' ] ));# 229
ok(! is_member_any( [ \%h0, \%h1 ], [ 'jerky' ] ));# 230
ok(! is_member_any( [ \%h0, \%h1 ], [ 'zebra' ] ));# 231

$memb_hash_ref = are_members_any( [ \%h0, \%h1 ],
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ]);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 232
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 233
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 234
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 235
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 236
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 237
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 238
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 239
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 240
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 241
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 242

$vers = get_version;
ok($vers);                              # 243

$LR = is_LsubsetR([ \%h2, \%h3 ]);
ok(! $LR);                              # 244

$RL = is_RsubsetL([ \%h2, \%h3 ]);
ok($RL);                                # 245

$eqv = is_LequivalentR([ \%h2, \%h3 ]);
ok(! $eqv);                             # 246

$eqv = is_LeqvlntR([ \%h2, \%h3 ]);
ok(! $eqv);                             # 247

$eqv = is_LequivalentR([ \%h3, \%h4 ]);
ok($eqv);                               # 248

$eqv = is_LeqvlntR([ \%h3, \%h4 ]);
ok($eqv);                               # 249

########## BELOW:  Tests for '-u' option ##########

@union = get_union('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 250
ok(exists $seen{'baker'});              # 251
ok(exists $seen{'camera'});             # 252
ok(exists $seen{'delta'});              # 253
ok(exists $seen{'edward'});             # 254
ok(exists $seen{'fargo'});              # 255
ok(exists $seen{'golfer'});             # 256
ok(exists $seen{'hilton'});             # 257
ok(! exists $seen{'icon'});             # 258
ok(! exists $seen{'jerky'});            # 259
%seen = ();

$union_ref = get_union_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 260
ok(exists $seen{'baker'});              # 261
ok(exists $seen{'camera'});             # 262
ok(exists $seen{'delta'});              # 263
ok(exists $seen{'edward'});             # 264
ok(exists $seen{'fargo'});              # 265
ok(exists $seen{'golfer'});             # 266
ok(exists $seen{'hilton'});             # 267
ok(! exists $seen{'icon'});             # 268
ok(! exists $seen{'jerky'});            # 269
%seen = ();

@shared = get_shared('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 270
ok(exists $seen{'baker'});              # 271
ok(exists $seen{'camera'});             # 272
ok(exists $seen{'delta'});              # 273
ok(exists $seen{'edward'});             # 274
ok(exists $seen{'fargo'});              # 275
ok(exists $seen{'golfer'});             # 276
ok(! exists $seen{'hilton'});           # 277
ok(! exists $seen{'icon'});             # 278
ok(! exists $seen{'jerky'});            # 279
%seen = ();

$shared_ref = get_shared_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 280
ok(exists $seen{'baker'});              # 281
ok(exists $seen{'camera'});             # 282
ok(exists $seen{'delta'});              # 283
ok(exists $seen{'edward'});             # 284
ok(exists $seen{'fargo'});              # 285
ok(exists $seen{'golfer'});             # 286
ok(! exists $seen{'hilton'});           # 287
ok(! exists $seen{'icon'});             # 288
ok(! exists $seen{'jerky'});            # 289
%seen = ();

@intersection = get_intersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 290
ok(exists $seen{'baker'});              # 291
ok(exists $seen{'camera'});             # 292
ok(exists $seen{'delta'});              # 293
ok(exists $seen{'edward'});             # 294
ok(exists $seen{'fargo'});              # 295
ok(exists $seen{'golfer'});             # 296
ok(! exists $seen{'hilton'});           # 297
ok(! exists $seen{'icon'});             # 298
ok(! exists $seen{'jerky'});            # 299
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 300
ok(exists $seen{'baker'});              # 301
ok(exists $seen{'camera'});             # 302
ok(exists $seen{'delta'});              # 303
ok(exists $seen{'edward'});             # 304
ok(exists $seen{'fargo'});              # 305
ok(exists $seen{'golfer'});             # 306
ok(! exists $seen{'hilton'});           # 307
ok(! exists $seen{'icon'});             # 308
ok(! exists $seen{'jerky'});            # 309
%seen = ();

@unique = get_unique('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 310
ok(! exists $seen{'baker'});            # 311
ok(! exists $seen{'camera'});           # 312
ok(! exists $seen{'delta'});            # 313
ok(! exists $seen{'edward'});           # 314
ok(! exists $seen{'fargo'});            # 315
ok(! exists $seen{'golfer'});           # 316
ok(! exists $seen{'hilton'});           # 317
ok(! exists $seen{'icon'});             # 318
ok(! exists $seen{'jerky'});            # 319
%seen = ();

$unique_ref = get_unique_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 320
ok(! exists $seen{'baker'});            # 321
ok(! exists $seen{'camera'});           # 322
ok(! exists $seen{'delta'});            # 323
ok(! exists $seen{'edward'});           # 324
ok(! exists $seen{'fargo'});            # 325
ok(! exists $seen{'golfer'});           # 326
ok(! exists $seen{'hilton'});           # 327
ok(! exists $seen{'icon'});             # 328
ok(! exists $seen{'jerky'});            # 329
%seen = ();

@complement = get_complement('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 330
ok(! exists $seen{'baker'});            # 331
ok(! exists $seen{'camera'});           # 332
ok(! exists $seen{'delta'});            # 333
ok(! exists $seen{'edward'});           # 334
ok(! exists $seen{'fargo'});            # 335
ok(! exists $seen{'golfer'});           # 336
ok(exists $seen{'hilton'});             # 337
ok(! exists $seen{'icon'});             # 338
ok(! exists $seen{'jerky'});            # 339
%seen = ();

$complement_ref = get_complement_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 340
ok(! exists $seen{'baker'});            # 341
ok(! exists $seen{'camera'});           # 342
ok(! exists $seen{'delta'});            # 343
ok(! exists $seen{'edward'});           # 344
ok(! exists $seen{'fargo'});            # 345
ok(! exists $seen{'golfer'});           # 346
ok(exists $seen{'hilton'});             # 347
ok(! exists $seen{'icon'});             # 348
ok(! exists $seen{'jerky'});            # 349
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 350
ok(! exists $seen{'baker'});            # 351
ok(! exists $seen{'camera'});           # 352
ok(! exists $seen{'delta'});            # 353
ok(! exists $seen{'edward'});           # 354
ok(! exists $seen{'fargo'});            # 355
ok(! exists $seen{'golfer'});           # 356
ok(exists $seen{'hilton'});             # 357
ok(! exists $seen{'icon'});             # 358
ok(! exists $seen{'jerky'});            # 359
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 360
ok(! exists $seen{'baker'});            # 361
ok(! exists $seen{'camera'});           # 362
ok(! exists $seen{'delta'});            # 363
ok(! exists $seen{'edward'});           # 364
ok(! exists $seen{'fargo'});            # 365
ok(! exists $seen{'golfer'});           # 366
ok(exists $seen{'hilton'});             # 367
ok(! exists $seen{'icon'});             # 368
ok(! exists $seen{'jerky'});            # 369
%seen = ();

@symmetric_difference = get_symdiff('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 370
ok(! exists $seen{'baker'});            # 371
ok(! exists $seen{'camera'});           # 372
ok(! exists $seen{'delta'});            # 373
ok(! exists $seen{'edward'});           # 374
ok(! exists $seen{'fargo'});            # 375
ok(! exists $seen{'golfer'});           # 376
ok(exists $seen{'hilton'});             # 377
ok(! exists $seen{'icon'});             # 378
ok(! exists $seen{'jerky'});            # 379
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 380
ok(! exists $seen{'baker'});            # 381
ok(! exists $seen{'camera'});           # 382
ok(! exists $seen{'delta'});            # 383
ok(! exists $seen{'edward'});           # 384
ok(! exists $seen{'fargo'});            # 385
ok(! exists $seen{'golfer'});           # 386
ok(exists $seen{'hilton'});             # 387
ok(! exists $seen{'icon'});             # 388
ok(! exists $seen{'jerky'});            # 389
%seen = ();

@nonintersection = get_nonintersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 390
ok(! exists $seen{'baker'});            # 391
ok(! exists $seen{'camera'});           # 392
ok(! exists $seen{'delta'});            # 393
ok(! exists $seen{'edward'});           # 394
ok(! exists $seen{'fargo'});            # 395
ok(! exists $seen{'golfer'});           # 396
ok(exists $seen{'hilton'});             # 397
ok(! exists $seen{'icon'});             # 398
ok(! exists $seen{'jerky'});            # 399
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 400
ok(! exists $seen{'baker'});            # 401
ok(! exists $seen{'camera'});           # 402
ok(! exists $seen{'delta'});            # 403
ok(! exists $seen{'edward'});           # 404
ok(! exists $seen{'fargo'});            # 405
ok(! exists $seen{'golfer'});           # 406
ok(exists $seen{'hilton'});             # 407
ok(! exists $seen{'icon'});             # 408
ok(! exists $seen{'jerky'});            # 409
%seen = ();

@bag = get_bag('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 410
ok($seen{'baker'} == 2);                # 411
ok($seen{'camera'} == 2);               # 412
ok($seen{'delta'} == 3);                # 413
ok($seen{'edward'} == 2);               # 414
ok($seen{'fargo'} == 2);                # 415
ok($seen{'golfer'} == 2);               # 416
ok($seen{'hilton'} == 1);               # 417
ok(! exists $seen{'icon'});             # 418
ok(! exists $seen{'jerky'});            # 419
%seen = ();

$bag_ref = get_bag_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 420
ok($seen{'baker'} == 2);                # 421
ok($seen{'camera'} == 2);               # 422
ok($seen{'delta'} == 3);                # 423
ok($seen{'edward'} == 2);               # 424
ok($seen{'fargo'} == 2);                # 425
ok($seen{'golfer'} == 2);               # 426
ok($seen{'hilton'} == 1);               # 427
ok(! exists $seen{'icon'});             # 428
ok(! exists $seen{'jerky'});            # 429
%seen = ();

########## BELOW:  Tests for '---unsortednsorted' option ##########

@union = get_union('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 430
ok(exists $seen{'baker'});              # 431
ok(exists $seen{'camera'});             # 432
ok(exists $seen{'delta'});              # 433
ok(exists $seen{'edward'});             # 434
ok(exists $seen{'fargo'});              # 435
ok(exists $seen{'golfer'});             # 436
ok(exists $seen{'hilton'});             # 437
ok(! exists $seen{'icon'});             # 438
ok(! exists $seen{'jerky'});            # 439
%seen = ();

$union_ref = get_union_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 440
ok(exists $seen{'baker'});              # 441
ok(exists $seen{'camera'});             # 442
ok(exists $seen{'delta'});              # 443
ok(exists $seen{'edward'});             # 444
ok(exists $seen{'fargo'});              # 445
ok(exists $seen{'golfer'});             # 446
ok(exists $seen{'hilton'});             # 447
ok(! exists $seen{'icon'});             # 448
ok(! exists $seen{'jerky'});            # 449
%seen = ();

@shared = get_shared('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 450
ok(exists $seen{'baker'});              # 451
ok(exists $seen{'camera'});             # 452
ok(exists $seen{'delta'});              # 453
ok(exists $seen{'edward'});             # 454
ok(exists $seen{'fargo'});              # 455
ok(exists $seen{'golfer'});             # 456
ok(! exists $seen{'hilton'});           # 457
ok(! exists $seen{'icon'});             # 458
ok(! exists $seen{'jerky'});            # 459
%seen = ();

$shared_ref = get_shared_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 460
ok(exists $seen{'baker'});              # 461
ok(exists $seen{'camera'});             # 462
ok(exists $seen{'delta'});              # 463
ok(exists $seen{'edward'});             # 464
ok(exists $seen{'fargo'});              # 465
ok(exists $seen{'golfer'});             # 466
ok(! exists $seen{'hilton'});           # 467
ok(! exists $seen{'icon'});             # 468
ok(! exists $seen{'jerky'});            # 469
%seen = ();

@intersection = get_intersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 470
ok(exists $seen{'baker'});              # 471
ok(exists $seen{'camera'});             # 472
ok(exists $seen{'delta'});              # 473
ok(exists $seen{'edward'});             # 474
ok(exists $seen{'fargo'});              # 475
ok(exists $seen{'golfer'});             # 476
ok(! exists $seen{'hilton'});           # 477
ok(! exists $seen{'icon'});             # 478
ok(! exists $seen{'jerky'});            # 479
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 480
ok(exists $seen{'baker'});              # 481
ok(exists $seen{'camera'});             # 482
ok(exists $seen{'delta'});              # 483
ok(exists $seen{'edward'});             # 484
ok(exists $seen{'fargo'});              # 485
ok(exists $seen{'golfer'});             # 486
ok(! exists $seen{'hilton'});           # 487
ok(! exists $seen{'icon'});             # 488
ok(! exists $seen{'jerky'});            # 489
%seen = ();

@unique = get_unique('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 490
ok(! exists $seen{'baker'});            # 491
ok(! exists $seen{'camera'});           # 492
ok(! exists $seen{'delta'});            # 493
ok(! exists $seen{'edward'});           # 494
ok(! exists $seen{'fargo'});            # 495
ok(! exists $seen{'golfer'});           # 496
ok(! exists $seen{'hilton'});           # 497
ok(! exists $seen{'icon'});             # 498
ok(! exists $seen{'jerky'});            # 499
%seen = ();

$unique_ref = get_unique_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 500
ok(! exists $seen{'baker'});            # 501
ok(! exists $seen{'camera'});           # 502
ok(! exists $seen{'delta'});            # 503
ok(! exists $seen{'edward'});           # 504
ok(! exists $seen{'fargo'});            # 505
ok(! exists $seen{'golfer'});           # 506
ok(! exists $seen{'hilton'});           # 507
ok(! exists $seen{'icon'});             # 508
ok(! exists $seen{'jerky'});            # 509
%seen = ();

@complement = get_complement('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 510
ok(! exists $seen{'baker'});            # 511
ok(! exists $seen{'camera'});           # 512
ok(! exists $seen{'delta'});            # 513
ok(! exists $seen{'edward'});           # 514
ok(! exists $seen{'fargo'});            # 515
ok(! exists $seen{'golfer'});           # 516
ok(exists $seen{'hilton'});             # 517
ok(! exists $seen{'icon'});             # 518
ok(! exists $seen{'jerky'});            # 519
%seen = ();

$complement_ref = get_complement_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 520
ok(! exists $seen{'baker'});            # 521
ok(! exists $seen{'camera'});           # 522
ok(! exists $seen{'delta'});            # 523
ok(! exists $seen{'edward'});           # 524
ok(! exists $seen{'fargo'});            # 525
ok(! exists $seen{'golfer'});           # 526
ok(exists $seen{'hilton'});             # 527
ok(! exists $seen{'icon'});             # 528
ok(! exists $seen{'jerky'});            # 529
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 530
ok(! exists $seen{'baker'});            # 531
ok(! exists $seen{'camera'});           # 532
ok(! exists $seen{'delta'});            # 533
ok(! exists $seen{'edward'});           # 534
ok(! exists $seen{'fargo'});            # 535
ok(! exists $seen{'golfer'});           # 536
ok(exists $seen{'hilton'});             # 537
ok(! exists $seen{'icon'});             # 538
ok(! exists $seen{'jerky'});            # 539
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 540
ok(! exists $seen{'baker'});            # 541
ok(! exists $seen{'camera'});           # 542
ok(! exists $seen{'delta'});            # 543
ok(! exists $seen{'edward'});           # 544
ok(! exists $seen{'fargo'});            # 545
ok(! exists $seen{'golfer'});           # 546
ok(exists $seen{'hilton'});             # 547
ok(! exists $seen{'icon'});             # 548
ok(! exists $seen{'jerky'});            # 549
%seen = ();

@symmetric_difference = get_symdiff('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 550
ok(! exists $seen{'baker'});            # 551
ok(! exists $seen{'camera'});           # 552
ok(! exists $seen{'delta'});            # 553
ok(! exists $seen{'edward'});           # 554
ok(! exists $seen{'fargo'});            # 555
ok(! exists $seen{'golfer'});           # 556
ok(exists $seen{'hilton'});             # 557
ok(! exists $seen{'icon'});             # 558
ok(! exists $seen{'jerky'});            # 559
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 560
ok(! exists $seen{'baker'});            # 561
ok(! exists $seen{'camera'});           # 562
ok(! exists $seen{'delta'});            # 563
ok(! exists $seen{'edward'});           # 564
ok(! exists $seen{'fargo'});            # 565
ok(! exists $seen{'golfer'});           # 566
ok(exists $seen{'hilton'});             # 567
ok(! exists $seen{'icon'});             # 568
ok(! exists $seen{'jerky'});            # 569
%seen = ();

@nonintersection = get_nonintersection('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 570
ok(! exists $seen{'baker'});            # 571
ok(! exists $seen{'camera'});           # 572
ok(! exists $seen{'delta'});            # 573
ok(! exists $seen{'edward'});           # 574
ok(! exists $seen{'fargo'});            # 575
ok(! exists $seen{'golfer'});           # 576
ok(exists $seen{'hilton'});             # 577
ok(! exists $seen{'icon'});             # 578
ok(! exists $seen{'jerky'});            # 579
%seen = ();

$nonintersection_ref = get_nonintersection_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 580
ok(! exists $seen{'baker'});            # 581
ok(! exists $seen{'camera'});           # 582
ok(! exists $seen{'delta'});            # 583
ok(! exists $seen{'edward'});           # 584
ok(! exists $seen{'fargo'});            # 585
ok(! exists $seen{'golfer'});           # 586
ok(exists $seen{'hilton'});             # 587
ok(! exists $seen{'icon'});             # 588
ok(! exists $seen{'jerky'});            # 589
%seen = ();

@bag = get_bag('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 590
ok($seen{'baker'} == 2);                # 591
ok($seen{'camera'} == 2);               # 592
ok($seen{'delta'} == 3);                # 593
ok($seen{'edward'} == 2);               # 594
ok($seen{'fargo'} == 2);                # 595
ok($seen{'golfer'} == 2);               # 596
ok($seen{'hilton'} == 1);               # 597
ok(! exists $seen{'icon'});             # 598
ok(! exists $seen{'jerky'});            # 599
%seen = ();

$bag_ref = get_bag_ref('--unsorted', [ \%h0, \%h1 ]);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 600
ok($seen{'baker'} == 2);                # 601
ok($seen{'camera'} == 2);               # 602
ok($seen{'delta'} == 3);                # 603
ok($seen{'edward'} == 2);               # 604
ok($seen{'fargo'} == 2);                # 605
ok($seen{'golfer'} == 2);               # 606
ok($seen{'hilton'} == 1);               # 607
ok(! exists $seen{'icon'});             # 608
ok(! exists $seen{'jerky'});            # 609
%seen = ();


