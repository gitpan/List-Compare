# 17_alt_construct_simple.t # as of 05/08/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
767;
use lib ("./t");
use List::Compare;
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

my $lc    = List::Compare->new( { lists => [ \@a0, \@a1 ] } );

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

$union_ref = $lc->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 13
ok(exists $seen{'baker'});              # 14
ok(exists $seen{'camera'});             # 15
ok(exists $seen{'delta'});              # 16
ok(exists $seen{'edward'});             # 17
ok(exists $seen{'fargo'});              # 18
ok(exists $seen{'golfer'});             # 19
ok(exists $seen{'hilton'});             # 20
ok(! exists $seen{'icon'});             # 21
ok(! exists $seen{'jerky'});            # 22
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lc->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 23
ok(exists $seen{'baker'});              # 24
ok(exists $seen{'camera'});             # 25
ok(exists $seen{'delta'});              # 26
ok(exists $seen{'edward'});             # 27
ok(exists $seen{'fargo'});              # 28
ok(exists $seen{'golfer'});             # 29
ok(exists $seen{'hilton'});             # 30
ok(! exists $seen{'icon'});             # 31
ok(! exists $seen{'jerky'});            # 32
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lc->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 33
ok(exists $seen{'baker'});              # 34
ok(exists $seen{'camera'});             # 35
ok(exists $seen{'delta'});              # 36
ok(exists $seen{'edward'});             # 37
ok(exists $seen{'fargo'});              # 38
ok(exists $seen{'golfer'});             # 39
ok(exists $seen{'hilton'});             # 40
ok(! exists $seen{'icon'});             # 41
ok(! exists $seen{'jerky'});            # 42
%seen = ();

@intersection = $lc->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 43
ok(exists $seen{'baker'});              # 44
ok(exists $seen{'camera'});             # 45
ok(exists $seen{'delta'});              # 46
ok(exists $seen{'edward'});             # 47
ok(exists $seen{'fargo'});              # 48
ok(exists $seen{'golfer'});             # 49
ok(! exists $seen{'hilton'});           # 50
ok(! exists $seen{'icon'});             # 51
ok(! exists $seen{'jerky'});            # 52
%seen = ();

$intersection_ref = $lc->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 53
ok(exists $seen{'baker'});              # 54
ok(exists $seen{'camera'});             # 55
ok(exists $seen{'delta'});              # 56
ok(exists $seen{'edward'});             # 57
ok(exists $seen{'fargo'});              # 58
ok(exists $seen{'golfer'});             # 59
ok(! exists $seen{'hilton'});           # 60
ok(! exists $seen{'icon'});             # 61
ok(! exists $seen{'jerky'});            # 62
%seen = ();

@unique = $lc->get_unique;
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

$unique_ref = $lc->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

@unique = $lc->get_Lonly;
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

$unique_ref = $lc->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 93
ok(! exists $seen{'baker'});            # 94
ok(! exists $seen{'camera'});           # 95
ok(! exists $seen{'delta'});            # 96
ok(! exists $seen{'edward'});           # 97
ok(! exists $seen{'fargo'});            # 98
ok(! exists $seen{'golfer'});           # 99
ok(! exists $seen{'hilton'});           # 100
ok(! exists $seen{'icon'});             # 101
ok(! exists $seen{'jerky'});            # 102
%seen = ();

@unique = $lc->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 103
ok(! exists $seen{'baker'});            # 104
ok(! exists $seen{'camera'});           # 105
ok(! exists $seen{'delta'});            # 106
ok(! exists $seen{'edward'});           # 107
ok(! exists $seen{'fargo'});            # 108
ok(! exists $seen{'golfer'});           # 109
ok(! exists $seen{'hilton'});           # 110
ok(! exists $seen{'icon'});             # 111
ok(! exists $seen{'jerky'});            # 112
%seen = ();

$unique_ref = $lc->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 113
ok(! exists $seen{'baker'});            # 114
ok(! exists $seen{'camera'});           # 115
ok(! exists $seen{'delta'});            # 116
ok(! exists $seen{'edward'});           # 117
ok(! exists $seen{'fargo'});            # 118
ok(! exists $seen{'golfer'});           # 119
ok(! exists $seen{'hilton'});           # 120
ok(! exists $seen{'icon'});             # 121
ok(! exists $seen{'jerky'});            # 122
%seen = ();

@complement = $lc->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 123
ok(! exists $seen{'baker'});            # 124
ok(! exists $seen{'camera'});           # 125
ok(! exists $seen{'delta'});            # 126
ok(! exists $seen{'edward'});           # 127
ok(! exists $seen{'fargo'});            # 128
ok(! exists $seen{'golfer'});           # 129
ok(exists $seen{'hilton'});             # 130
ok(! exists $seen{'icon'});             # 131
ok(! exists $seen{'jerky'});            # 132
%seen = ();

$complement_ref = $lc->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 133
ok(! exists $seen{'baker'});            # 134
ok(! exists $seen{'camera'});           # 135
ok(! exists $seen{'delta'});            # 136
ok(! exists $seen{'edward'});           # 137
ok(! exists $seen{'fargo'});            # 138
ok(! exists $seen{'golfer'});           # 139
ok(exists $seen{'hilton'});             # 140
ok(! exists $seen{'icon'});             # 141
ok(! exists $seen{'jerky'});            # 142
%seen = ();

@complement = $lc->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 143
ok(! exists $seen{'baker'});            # 144
ok(! exists $seen{'camera'});           # 145
ok(! exists $seen{'delta'});            # 146
ok(! exists $seen{'edward'});           # 147
ok(! exists $seen{'fargo'});            # 148
ok(! exists $seen{'golfer'});           # 149
ok(exists $seen{'hilton'});             # 150
ok(! exists $seen{'icon'});             # 151
ok(! exists $seen{'jerky'});            # 152
%seen = ();

$complement_ref = $lc->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 153
ok(! exists $seen{'baker'});            # 154
ok(! exists $seen{'camera'});           # 155
ok(! exists $seen{'delta'});            # 156
ok(! exists $seen{'edward'});           # 157
ok(! exists $seen{'fargo'});            # 158
ok(! exists $seen{'golfer'});           # 159
ok(exists $seen{'hilton'});             # 160
ok(! exists $seen{'icon'});             # 161
ok(! exists $seen{'jerky'});            # 162
%seen = ();

@complement = $lc->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 163
ok(! exists $seen{'baker'});            # 164
ok(! exists $seen{'camera'});           # 165
ok(! exists $seen{'delta'});            # 166
ok(! exists $seen{'edward'});           # 167
ok(! exists $seen{'fargo'});            # 168
ok(! exists $seen{'golfer'});           # 169
ok(exists $seen{'hilton'});             # 170
ok(! exists $seen{'icon'});             # 171
ok(! exists $seen{'jerky'});            # 172
%seen = ();

$complement_ref = $lc->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 173
ok(! exists $seen{'baker'});            # 174
ok(! exists $seen{'camera'});           # 175
ok(! exists $seen{'delta'});            # 176
ok(! exists $seen{'edward'});           # 177
ok(! exists $seen{'fargo'});            # 178
ok(! exists $seen{'golfer'});           # 179
ok(exists $seen{'hilton'});             # 180
ok(! exists $seen{'icon'});             # 181
ok(! exists $seen{'jerky'});            # 182
%seen = ();

@symmetric_difference = $lc->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 183
ok(! exists $seen{'baker'});            # 184
ok(! exists $seen{'camera'});           # 185
ok(! exists $seen{'delta'});            # 186
ok(! exists $seen{'edward'});           # 187
ok(! exists $seen{'fargo'});            # 188
ok(! exists $seen{'golfer'});           # 189
ok(exists $seen{'hilton'});             # 190
ok(! exists $seen{'icon'});             # 191
ok(! exists $seen{'jerky'});            # 192
%seen = ();

$symmetric_difference_ref = $lc->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 193
ok(! exists $seen{'baker'});            # 194
ok(! exists $seen{'camera'});           # 195
ok(! exists $seen{'delta'});            # 196
ok(! exists $seen{'edward'});           # 197
ok(! exists $seen{'fargo'});            # 198
ok(! exists $seen{'golfer'});           # 199
ok(exists $seen{'hilton'});             # 200
ok(! exists $seen{'icon'});             # 201
ok(! exists $seen{'jerky'});            # 202
%seen = ();

@symmetric_difference = $lc->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 203
ok(! exists $seen{'baker'});            # 204
ok(! exists $seen{'camera'});           # 205
ok(! exists $seen{'delta'});            # 206
ok(! exists $seen{'edward'});           # 207
ok(! exists $seen{'fargo'});            # 208
ok(! exists $seen{'golfer'});           # 209
ok(exists $seen{'hilton'});             # 210
ok(! exists $seen{'icon'});             # 211
ok(! exists $seen{'jerky'});            # 212
%seen = ();

$symmetric_difference_ref = $lc->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 213
ok(! exists $seen{'baker'});            # 214
ok(! exists $seen{'camera'});           # 215
ok(! exists $seen{'delta'});            # 216
ok(! exists $seen{'edward'});           # 217
ok(! exists $seen{'fargo'});            # 218
ok(! exists $seen{'golfer'});           # 219
ok(exists $seen{'hilton'});             # 220
ok(! exists $seen{'icon'});             # 221
ok(! exists $seen{'jerky'});            # 222
%seen = ();

@symmetric_difference = $lc->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 223
ok(! exists $seen{'baker'});            # 224
ok(! exists $seen{'camera'});           # 225
ok(! exists $seen{'delta'});            # 226
ok(! exists $seen{'edward'});           # 227
ok(! exists $seen{'fargo'});            # 228
ok(! exists $seen{'golfer'});           # 229
ok(exists $seen{'hilton'});             # 230
ok(! exists $seen{'icon'});             # 231
ok(! exists $seen{'jerky'});            # 232
%seen = ();

$symmetric_difference_ref = $lc->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 233
ok(! exists $seen{'baker'});            # 234
ok(! exists $seen{'camera'});           # 235
ok(! exists $seen{'delta'});            # 236
ok(! exists $seen{'edward'});           # 237
ok(! exists $seen{'fargo'});            # 238
ok(! exists $seen{'golfer'});           # 239
ok(exists $seen{'hilton'});             # 240
ok(! exists $seen{'icon'});             # 241
ok(! exists $seen{'jerky'});            # 242
%seen = ();

@symmetric_difference = $lc->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 243
ok(! exists $seen{'baker'});            # 244
ok(! exists $seen{'camera'});           # 245
ok(! exists $seen{'delta'});            # 246
ok(! exists $seen{'edward'});           # 247
ok(! exists $seen{'fargo'});            # 248
ok(! exists $seen{'golfer'});           # 249
ok(exists $seen{'hilton'});             # 250
ok(! exists $seen{'icon'});             # 251
ok(! exists $seen{'jerky'});            # 252
%seen = ();

$symmetric_difference_ref = $lc->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 253
ok(! exists $seen{'baker'});            # 254
ok(! exists $seen{'camera'});           # 255
ok(! exists $seen{'delta'});            # 256
ok(! exists $seen{'edward'});           # 257
ok(! exists $seen{'fargo'});            # 258
ok(! exists $seen{'golfer'});           # 259
ok(exists $seen{'hilton'});             # 260
ok(! exists $seen{'icon'});             # 261
ok(! exists $seen{'jerky'});            # 262
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lc->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 263
ok(! exists $seen{'baker'});            # 264
ok(! exists $seen{'camera'});           # 265
ok(! exists $seen{'delta'});            # 266
ok(! exists $seen{'edward'});           # 267
ok(! exists $seen{'fargo'});            # 268
ok(! exists $seen{'golfer'});           # 269
ok(exists $seen{'hilton'});             # 270
ok(! exists $seen{'icon'});             # 271
ok(! exists $seen{'jerky'});            # 272
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lc->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 273
ok(! exists $seen{'baker'});            # 274
ok(! exists $seen{'camera'});           # 275
ok(! exists $seen{'delta'});            # 276
ok(! exists $seen{'edward'});           # 277
ok(! exists $seen{'fargo'});            # 278
ok(! exists $seen{'golfer'});           # 279
ok(exists $seen{'hilton'});             # 280
ok(! exists $seen{'icon'});             # 281
ok(! exists $seen{'jerky'});            # 282
%seen = ();

@bag = $lc->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 283
ok($seen{'baker'} == 2);                # 284
ok($seen{'camera'} == 2);               # 285
ok($seen{'delta'} == 3);                # 286
ok($seen{'edward'} == 2);               # 287
ok($seen{'fargo'} == 2);                # 288
ok($seen{'golfer'} == 2);               # 289
ok($seen{'hilton'} == 1);               # 290
ok(! exists $seen{'icon'});             # 291
ok(! exists $seen{'jerky'});            # 292
%seen = ();

$bag_ref = $lc->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 293
ok($seen{'baker'} == 2);                # 294
ok($seen{'camera'} == 2);               # 295
ok($seen{'delta'} == 3);                # 296
ok($seen{'edward'} == 2);               # 297
ok($seen{'fargo'} == 2);                # 298
ok($seen{'golfer'} == 2);               # 299
ok($seen{'hilton'} == 1);               # 300
ok(! exists $seen{'icon'});             # 301
ok(! exists $seen{'jerky'});            # 302
%seen = ();

$LR = $lc->is_LsubsetR;
ok(! $LR);                              # 303

$LR = $lc->is_AsubsetB;
ok(! $LR);                              # 304

$RL = $lc->is_RsubsetL;
ok(! $RL);                              # 305

$RL = $lc->is_BsubsetA;
ok(! $RL);                              # 306

$eqv = $lc->is_LequivalentR;
ok(! $eqv);                             # 307

$eqv = $lc->is_LeqvlntR;
ok(! $eqv);                             # 308

$disj = $lc->is_LdisjointR;
ok(! $disj);                            # 309

$return = $lc->print_subset_chart;
ok($return);                            # 310

$return = $lc->print_equivalence_chart;
ok($return);                            # 311

@memb_arr = $lc->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 312

@memb_arr = $lc->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 313

@memb_arr = $lc->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 314

@memb_arr = $lc->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 315

@memb_arr = $lc->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 316

@memb_arr = $lc->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 317

@memb_arr = $lc->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 318

@memb_arr = $lc->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 319

@memb_arr = $lc->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 320

@memb_arr = $lc->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 321

@memb_arr = $lc->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 322



$memb_arr_ref = $lc->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 323

$memb_arr_ref = $lc->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = $lc->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = $lc->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = $lc->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = $lc->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 328

$memb_arr_ref = $lc->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 329

$memb_arr_ref = $lc->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 330

$memb_arr_ref = $lc->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 331

$memb_arr_ref = $lc->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 332

$memb_arr_ref = $lc->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 333


#$memb_hash_ref = $lc->are_members_which(qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra |);
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));

$memb_hash_ref = $lc->are_members_which( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 334
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 335
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 336
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 337
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 338
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 339
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 340
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 341
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 342
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 343
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 344

ok($lc->is_member_any('abel'));         # 345
ok($lc->is_member_any('baker'));        # 346
ok($lc->is_member_any('camera'));       # 347
ok($lc->is_member_any('delta'));        # 348
ok($lc->is_member_any('edward'));       # 349
ok($lc->is_member_any('fargo'));        # 350
ok($lc->is_member_any('golfer'));       # 351
ok($lc->is_member_any('hilton'));       # 352
ok(! $lc->is_member_any('icon' ));      # 353
ok(! $lc->is_member_any('jerky'));      # 354
ok(! $lc->is_member_any('zebra'));      # 355

#$memb_hash_ref = $lc->are_members_any(qw| abel baker camera delta edward fargo 
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
#ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));

$memb_hash_ref = $lc->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 356
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 357
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 358
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 359
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 360
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 361
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 362
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 363
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 364
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 365
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 366

$vers = $lc->get_version;
ok($vers);                              # 367

my $lc_s  = List::Compare->new( { lists => [ \@a2, \@a3 ] } );

ok($lc_s);                              # 368

$LR = $lc_s->is_LsubsetR;
ok(! $LR);                              # 369

$LR = $lc_s->is_AsubsetB;
ok(! $LR);                              # 370

$RL = $lc_s->is_RsubsetL;
ok($RL);                                # 371

$RL = $lc_s->is_BsubsetA;
ok($RL);                                # 372

$eqv = $lc_s->is_LequivalentR;
ok(! $eqv);                             # 373

$eqv = $lc_s->is_LeqvlntR;
ok(! $eqv);                             # 374

$disj = $lc_s->is_LdisjointR;
ok(! $disj);                            # 375

my $lc_e  = List::Compare->new( { lists => [ \@a3, \@a4 ] } );

ok($lc_e);                              # 376

$eqv = $lc_e->is_LequivalentR;
ok($eqv);                               # 377

$eqv = $lc_e->is_LeqvlntR;
ok($eqv);                               # 378

$disj = $lc_e->is_LdisjointR;
ok(! $disj);                            # 379

my $lc_dj  = List::Compare->new( { lists => [ \@a4, \@a8 ] } );

ok($lc_dj);                             # 380

ok(0 == $lc_dj->get_intersection);      # 381
ok(0 == scalar(@{$lc_dj->get_intersection_ref}));# 382
$disj = $lc_dj->is_LdisjointR;
ok($disj);                              # 383

########## BELOW:  Tests for '-u' option ##########

my $lcu    = List::Compare->new( { unsorted => 1, lists => [ \@a0, \@a1 ] } );

ok($lcu);                               # 384

@union = $lcu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 385
ok(exists $seen{'baker'});              # 386
ok(exists $seen{'camera'});             # 387
ok(exists $seen{'delta'});              # 388
ok(exists $seen{'edward'});             # 389
ok(exists $seen{'fargo'});              # 390
ok(exists $seen{'golfer'});             # 391
ok(exists $seen{'hilton'});             # 392
ok(! exists $seen{'icon'});             # 393
ok(! exists $seen{'jerky'});            # 394
%seen = ();

$union_ref = $lcu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 395
ok(exists $seen{'baker'});              # 396
ok(exists $seen{'camera'});             # 397
ok(exists $seen{'delta'});              # 398
ok(exists $seen{'edward'});             # 399
ok(exists $seen{'fargo'});              # 400
ok(exists $seen{'golfer'});             # 401
ok(exists $seen{'hilton'});             # 402
ok(! exists $seen{'icon'});             # 403
ok(! exists $seen{'jerky'});            # 404
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcu->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 405
ok(exists $seen{'baker'});              # 406
ok(exists $seen{'camera'});             # 407
ok(exists $seen{'delta'});              # 408
ok(exists $seen{'edward'});             # 409
ok(exists $seen{'fargo'});              # 410
ok(exists $seen{'golfer'});             # 411
ok(exists $seen{'hilton'});             # 412
ok(! exists $seen{'icon'});             # 413
ok(! exists $seen{'jerky'});            # 414
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcu->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 415
ok(exists $seen{'baker'});              # 416
ok(exists $seen{'camera'});             # 417
ok(exists $seen{'delta'});              # 418
ok(exists $seen{'edward'});             # 419
ok(exists $seen{'fargo'});              # 420
ok(exists $seen{'golfer'});             # 421
ok(exists $seen{'hilton'});             # 422
ok(! exists $seen{'icon'});             # 423
ok(! exists $seen{'jerky'});            # 424
%seen = ();

@intersection = $lcu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 425
ok(exists $seen{'baker'});              # 426
ok(exists $seen{'camera'});             # 427
ok(exists $seen{'delta'});              # 428
ok(exists $seen{'edward'});             # 429
ok(exists $seen{'fargo'});              # 430
ok(exists $seen{'golfer'});             # 431
ok(! exists $seen{'hilton'});           # 432
ok(! exists $seen{'icon'});             # 433
ok(! exists $seen{'jerky'});            # 434
%seen = ();

$intersection_ref = $lcu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 435
ok(exists $seen{'baker'});              # 436
ok(exists $seen{'camera'});             # 437
ok(exists $seen{'delta'});              # 438
ok(exists $seen{'edward'});             # 439
ok(exists $seen{'fargo'});              # 440
ok(exists $seen{'golfer'});             # 441
ok(! exists $seen{'hilton'});           # 442
ok(! exists $seen{'icon'});             # 443
ok(! exists $seen{'jerky'});            # 444
%seen = ();

@unique = $lcu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 445
ok(! exists $seen{'baker'});            # 446
ok(! exists $seen{'camera'});           # 447
ok(! exists $seen{'delta'});            # 448
ok(! exists $seen{'edward'});           # 449
ok(! exists $seen{'fargo'});            # 450
ok(! exists $seen{'golfer'});           # 451
ok(! exists $seen{'hilton'});           # 452
ok(! exists $seen{'icon'});             # 453
ok(! exists $seen{'jerky'});            # 454
%seen = ();

$unique_ref = $lcu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 455
ok(! exists $seen{'baker'});            # 456
ok(! exists $seen{'camera'});           # 457
ok(! exists $seen{'delta'});            # 458
ok(! exists $seen{'edward'});           # 459
ok(! exists $seen{'fargo'});            # 460
ok(! exists $seen{'golfer'});           # 461
ok(! exists $seen{'hilton'});           # 462
ok(! exists $seen{'icon'});             # 463
ok(! exists $seen{'jerky'});            # 464
%seen = ();

@unique = $lcu->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 465
ok(! exists $seen{'baker'});            # 466
ok(! exists $seen{'camera'});           # 467
ok(! exists $seen{'delta'});            # 468
ok(! exists $seen{'edward'});           # 469
ok(! exists $seen{'fargo'});            # 470
ok(! exists $seen{'golfer'});           # 471
ok(! exists $seen{'hilton'});           # 472
ok(! exists $seen{'icon'});             # 473
ok(! exists $seen{'jerky'});            # 474
%seen = ();

$unique_ref = $lcu->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 475
ok(! exists $seen{'baker'});            # 476
ok(! exists $seen{'camera'});           # 477
ok(! exists $seen{'delta'});            # 478
ok(! exists $seen{'edward'});           # 479
ok(! exists $seen{'fargo'});            # 480
ok(! exists $seen{'golfer'});           # 481
ok(! exists $seen{'hilton'});           # 482
ok(! exists $seen{'icon'});             # 483
ok(! exists $seen{'jerky'});            # 484
%seen = ();

@unique = $lcu->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 485
ok(! exists $seen{'baker'});            # 486
ok(! exists $seen{'camera'});           # 487
ok(! exists $seen{'delta'});            # 488
ok(! exists $seen{'edward'});           # 489
ok(! exists $seen{'fargo'});            # 490
ok(! exists $seen{'golfer'});           # 491
ok(! exists $seen{'hilton'});           # 492
ok(! exists $seen{'icon'});             # 493
ok(! exists $seen{'jerky'});            # 494
%seen = ();

$unique_ref = $lcu->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 495
ok(! exists $seen{'baker'});            # 496
ok(! exists $seen{'camera'});           # 497
ok(! exists $seen{'delta'});            # 498
ok(! exists $seen{'edward'});           # 499
ok(! exists $seen{'fargo'});            # 500
ok(! exists $seen{'golfer'});           # 501
ok(! exists $seen{'hilton'});           # 502
ok(! exists $seen{'icon'});             # 503
ok(! exists $seen{'jerky'});            # 504
%seen = ();

@complement = $lcu->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 505
ok(! exists $seen{'baker'});            # 506
ok(! exists $seen{'camera'});           # 507
ok(! exists $seen{'delta'});            # 508
ok(! exists $seen{'edward'});           # 509
ok(! exists $seen{'fargo'});            # 510
ok(! exists $seen{'golfer'});           # 511
ok(exists $seen{'hilton'});             # 512
ok(! exists $seen{'icon'});             # 513
ok(! exists $seen{'jerky'});            # 514
%seen = ();

$complement_ref = $lcu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 515
ok(! exists $seen{'baker'});            # 516
ok(! exists $seen{'camera'});           # 517
ok(! exists $seen{'delta'});            # 518
ok(! exists $seen{'edward'});           # 519
ok(! exists $seen{'fargo'});            # 520
ok(! exists $seen{'golfer'});           # 521
ok(exists $seen{'hilton'});             # 522
ok(! exists $seen{'icon'});             # 523
ok(! exists $seen{'jerky'});            # 524
%seen = ();

@complement = $lcu->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 525
ok(! exists $seen{'baker'});            # 526
ok(! exists $seen{'camera'});           # 527
ok(! exists $seen{'delta'});            # 528
ok(! exists $seen{'edward'});           # 529
ok(! exists $seen{'fargo'});            # 530
ok(! exists $seen{'golfer'});           # 531
ok(exists $seen{'hilton'});             # 532
ok(! exists $seen{'icon'});             # 533
ok(! exists $seen{'jerky'});            # 534
%seen = ();

$complement_ref = $lcu->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 535
ok(! exists $seen{'baker'});            # 536
ok(! exists $seen{'camera'});           # 537
ok(! exists $seen{'delta'});            # 538
ok(! exists $seen{'edward'});           # 539
ok(! exists $seen{'fargo'});            # 540
ok(! exists $seen{'golfer'});           # 541
ok(exists $seen{'hilton'});             # 542
ok(! exists $seen{'icon'});             # 543
ok(! exists $seen{'jerky'});            # 544
%seen = ();

@complement = $lcu->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 545
ok(! exists $seen{'baker'});            # 546
ok(! exists $seen{'camera'});           # 547
ok(! exists $seen{'delta'});            # 548
ok(! exists $seen{'edward'});           # 549
ok(! exists $seen{'fargo'});            # 550
ok(! exists $seen{'golfer'});           # 551
ok(exists $seen{'hilton'});             # 552
ok(! exists $seen{'icon'});             # 553
ok(! exists $seen{'jerky'});            # 554
%seen = ();

$complement_ref = $lcu->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 555
ok(! exists $seen{'baker'});            # 556
ok(! exists $seen{'camera'});           # 557
ok(! exists $seen{'delta'});            # 558
ok(! exists $seen{'edward'});           # 559
ok(! exists $seen{'fargo'});            # 560
ok(! exists $seen{'golfer'});           # 561
ok(exists $seen{'hilton'});             # 562
ok(! exists $seen{'icon'});             # 563
ok(! exists $seen{'jerky'});            # 564
%seen = ();

@symmetric_difference = $lcu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 565
ok(! exists $seen{'baker'});            # 566
ok(! exists $seen{'camera'});           # 567
ok(! exists $seen{'delta'});            # 568
ok(! exists $seen{'edward'});           # 569
ok(! exists $seen{'fargo'});            # 570
ok(! exists $seen{'golfer'});           # 571
ok(exists $seen{'hilton'});             # 572
ok(! exists $seen{'icon'});             # 573
ok(! exists $seen{'jerky'});            # 574
%seen = ();

$symmetric_difference_ref = $lcu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 575
ok(! exists $seen{'baker'});            # 576
ok(! exists $seen{'camera'});           # 577
ok(! exists $seen{'delta'});            # 578
ok(! exists $seen{'edward'});           # 579
ok(! exists $seen{'fargo'});            # 580
ok(! exists $seen{'golfer'});           # 581
ok(exists $seen{'hilton'});             # 582
ok(! exists $seen{'icon'});             # 583
ok(! exists $seen{'jerky'});            # 584
%seen = ();

@symmetric_difference = $lcu->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 585
ok(! exists $seen{'baker'});            # 586
ok(! exists $seen{'camera'});           # 587
ok(! exists $seen{'delta'});            # 588
ok(! exists $seen{'edward'});           # 589
ok(! exists $seen{'fargo'});            # 590
ok(! exists $seen{'golfer'});           # 591
ok(exists $seen{'hilton'});             # 592
ok(! exists $seen{'icon'});             # 593
ok(! exists $seen{'jerky'});            # 594
%seen = ();

$symmetric_difference_ref = $lcu->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 595
ok(! exists $seen{'baker'});            # 596
ok(! exists $seen{'camera'});           # 597
ok(! exists $seen{'delta'});            # 598
ok(! exists $seen{'edward'});           # 599
ok(! exists $seen{'fargo'});            # 600
ok(! exists $seen{'golfer'});           # 601
ok(exists $seen{'hilton'});             # 602
ok(! exists $seen{'icon'});             # 603
ok(! exists $seen{'jerky'});            # 604
%seen = ();

@symmetric_difference = $lcu->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 605
ok(! exists $seen{'baker'});            # 606
ok(! exists $seen{'camera'});           # 607
ok(! exists $seen{'delta'});            # 608
ok(! exists $seen{'edward'});           # 609
ok(! exists $seen{'fargo'});            # 610
ok(! exists $seen{'golfer'});           # 611
ok(exists $seen{'hilton'});             # 612
ok(! exists $seen{'icon'});             # 613
ok(! exists $seen{'jerky'});            # 614
%seen = ();

$symmetric_difference_ref = $lcu->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 615
ok(! exists $seen{'baker'});            # 616
ok(! exists $seen{'camera'});           # 617
ok(! exists $seen{'delta'});            # 618
ok(! exists $seen{'edward'});           # 619
ok(! exists $seen{'fargo'});            # 620
ok(! exists $seen{'golfer'});           # 621
ok(exists $seen{'hilton'});             # 622
ok(! exists $seen{'icon'});             # 623
ok(! exists $seen{'jerky'});            # 624
%seen = ();

@symmetric_difference = $lcu->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 625
ok(! exists $seen{'baker'});            # 626
ok(! exists $seen{'camera'});           # 627
ok(! exists $seen{'delta'});            # 628
ok(! exists $seen{'edward'});           # 629
ok(! exists $seen{'fargo'});            # 630
ok(! exists $seen{'golfer'});           # 631
ok(exists $seen{'hilton'});             # 632
ok(! exists $seen{'icon'});             # 633
ok(! exists $seen{'jerky'});            # 634
%seen = ();

$symmetric_difference_ref = $lcu->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 635
ok(! exists $seen{'baker'});            # 636
ok(! exists $seen{'camera'});           # 637
ok(! exists $seen{'delta'});            # 638
ok(! exists $seen{'edward'});           # 639
ok(! exists $seen{'fargo'});            # 640
ok(! exists $seen{'golfer'});           # 641
ok(exists $seen{'hilton'});             # 642
ok(! exists $seen{'icon'});             # 643
ok(! exists $seen{'jerky'});            # 644
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcu->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 645
ok(! exists $seen{'baker'});            # 646
ok(! exists $seen{'camera'});           # 647
ok(! exists $seen{'delta'});            # 648
ok(! exists $seen{'edward'});           # 649
ok(! exists $seen{'fargo'});            # 650
ok(! exists $seen{'golfer'});           # 651
ok(exists $seen{'hilton'});             # 652
ok(! exists $seen{'icon'});             # 653
ok(! exists $seen{'jerky'});            # 654
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcu->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 655
ok(! exists $seen{'baker'});            # 656
ok(! exists $seen{'camera'});           # 657
ok(! exists $seen{'delta'});            # 658
ok(! exists $seen{'edward'});           # 659
ok(! exists $seen{'fargo'});            # 660
ok(! exists $seen{'golfer'});           # 661
ok(exists $seen{'hilton'});             # 662
ok(! exists $seen{'icon'});             # 663
ok(! exists $seen{'jerky'});            # 664
%seen = ();

@bag = $lcu->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 665
ok($seen{'baker'} == 2);                # 666
ok($seen{'camera'} == 2);               # 667
ok($seen{'delta'} == 3);                # 668
ok($seen{'edward'} == 2);               # 669
ok($seen{'fargo'} == 2);                # 670
ok($seen{'golfer'} == 2);               # 671
ok($seen{'hilton'} == 1);               # 672
ok(! exists $seen{'icon'});             # 673
ok(! exists $seen{'jerky'});            # 674
%seen = ();

$bag_ref = $lcu->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 675
ok($seen{'baker'} == 2);                # 676
ok($seen{'camera'} == 2);               # 677
ok($seen{'delta'} == 3);                # 678
ok($seen{'edward'} == 2);               # 679
ok($seen{'fargo'} == 2);                # 680
ok($seen{'golfer'} == 2);               # 681
ok($seen{'hilton'} == 1);               # 682
ok(! exists $seen{'icon'});             # 683
ok(! exists $seen{'jerky'});            # 684
%seen = ();

$LR = $lcu->is_LsubsetR;
ok(! $LR);                              # 685

$LR = $lcu->is_AsubsetB;
ok(! $LR);                              # 686

$RL = $lcu->is_RsubsetL;
ok(! $RL);                              # 687

$RL = $lcu->is_BsubsetA;
ok(! $RL);                              # 688

$eqv = $lcu->is_LequivalentR;
ok(! $eqv);                             # 689

$eqv = $lcu->is_LeqvlntR;
ok(! $eqv);                             # 690

$disj = $lcu->is_LdisjointR;
ok(! $disj);                            # 691

$return = $lcu->print_subset_chart;
ok($return);                            # 692

$return = $lcu->print_equivalence_chart;
ok($return);                            # 693

@memb_arr = $lcu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 694

@memb_arr = $lcu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 695

@memb_arr = $lcu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 696

@memb_arr = $lcu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 697

@memb_arr = $lcu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 698

@memb_arr = $lcu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 699

@memb_arr = $lcu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 700

@memb_arr = $lcu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 701

@memb_arr = $lcu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 702

@memb_arr = $lcu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 703

@memb_arr = $lcu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 704

$memb_arr_ref = $lcu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 705

$memb_arr_ref = $lcu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 706

$memb_arr_ref = $lcu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 707

$memb_arr_ref = $lcu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 708

$memb_arr_ref = $lcu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 709

$memb_arr_ref = $lcu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 710

$memb_arr_ref = $lcu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 711

$memb_arr_ref = $lcu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 712

$memb_arr_ref = $lcu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 713

$memb_arr_ref = $lcu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 714

$memb_arr_ref = $lcu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 715

$memb_hash_ref = $lcu->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 716
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 717
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 718
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 719
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 720
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 721
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 722
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 723
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 724
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 725
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 726

ok($lcu->is_member_any('abel'));        # 727
ok($lcu->is_member_any('baker'));       # 728
ok($lcu->is_member_any('camera'));      # 729
ok($lcu->is_member_any('delta'));       # 730
ok($lcu->is_member_any('edward'));      # 731
ok($lcu->is_member_any('fargo'));       # 732
ok($lcu->is_member_any('golfer'));      # 733
ok($lcu->is_member_any('hilton'));      # 734
ok(! $lcu->is_member_any('icon' ));     # 735
ok(! $lcu->is_member_any('jerky'));     # 736
ok(! $lcu->is_member_any('zebra'));     # 737

$memb_hash_ref = $lcu->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 738
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 739
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 740
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 741
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 742
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 743
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 744
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 745
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 746
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 747
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 748

$vers = $lcu->get_version;
ok($vers);                              # 749

my $lcu_s  = List::Compare->new( { unsorted => 1, lists => [ \@a2, \@a3 ] } );

ok($lcu_s);                             # 750

$LR = $lcu_s->is_LsubsetR;
ok(! $LR);                              # 751

$LR = $lcu_s->is_AsubsetB;
ok(! $LR);                              # 752

$RL = $lcu_s->is_RsubsetL;
ok($RL);                                # 753

$RL = $lcu_s->is_BsubsetA;
ok($RL);                                # 754

$eqv = $lcu_s->is_LequivalentR;
ok(! $eqv);                             # 755

$eqv = $lcu_s->is_LeqvlntR;
ok(! $eqv);                             # 756

$disj = $lcu_s->is_LdisjointR;
ok(! $disj);                            # 757

my $lcu_e  = List::Compare->new( { unsorted => 1, lists => [ \@a3, \@a4 ] } );

ok($lcu_e);                             # 758

$eqv = $lcu_e->is_LequivalentR;
ok($eqv);                               # 759

$eqv = $lcu_e->is_LeqvlntR;
ok($eqv);                               # 760

$disj = $lcu_e->is_LdisjointR;
ok(! $disj);                            # 761

my $lcu_dj  = List::Compare->new( { unsorted => 1, lists => [ \@a4, \@a8 ] } );

ok($lcu_dj);                            # 762

ok(0 == $lcu_dj->get_intersection);     # 763
ok(0 == scalar(@{$lcu_dj->get_intersection_ref}));# 764
$disj = $lcu_dj->is_LdisjointR;
ok($disj);                              # 765

########## BELOW:  Test for bad arguments to constructor ##########

my ($lc_bad);
my %h5 = (
	golfer   => 1,
	lambda   => 0,
);

eval { $lc_bad = List::Compare->new( { lists => [ \@a0, \%h5 ] } ) };
ok(ok_capture_error($@));               # 766

eval { $lc_bad = List::Compare->new( { lists => [ \%h5, \@a0 ] } ) };
ok(ok_capture_error($@));               # 767


