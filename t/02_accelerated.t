# 02_accelerated.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
763;
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
my ($LR, $RL, $eqv, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);

my $lca   = List::Compare->new('-a', \@a0, \@a1);
ok($lca);                               # 2

@union = $lca->get_union;
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

$union_ref = $lca->get_union_ref;
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
	@shared = $lca->get_shared;
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
	$shared_ref = $lca->get_shared_ref;
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

@intersection = $lca->get_intersection;
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

$intersection_ref = $lca->get_intersection_ref;
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

@unique = $lca->get_unique;
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

$unique_ref = $lca->get_unique_ref;
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

@unique = $lca->get_Lonly;
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

$unique_ref = $lca->get_Lonly_ref;
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

@unique = $lca->get_Aonly;
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

$unique_ref = $lca->get_Aonly_ref;
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

@complement = $lca->get_complement;
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

$complement_ref = $lca->get_complement_ref;
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

@complement = $lca->get_Ronly;
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

$complement_ref = $lca->get_Ronly_ref;
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

@complement = $lca->get_Bonly;
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

$complement_ref = $lca->get_Bonly_ref;
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

@symmetric_difference = $lca->get_symmetric_difference;
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

$symmetric_difference_ref = $lca->get_symmetric_difference_ref;
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

@symmetric_difference = $lca->get_symdiff;
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

$symmetric_difference_ref = $lca->get_symdiff_ref;
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

@symmetric_difference = $lca->get_LorRonly;
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

$symmetric_difference_ref = $lca->get_LorRonly_ref;
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

@symmetric_difference = $lca->get_AorBonly;
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

$symmetric_difference_ref = $lca->get_AorBonly_ref;
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
	@nonintersection = $lca->get_nonintersection;
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
	$nonintersection_ref = $lca->get_nonintersection_ref;
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

@bag = $lca->get_bag;
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

$bag_ref = $lca->get_bag_ref;
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

$LR = $lca->is_LsubsetR;
ok(! $LR);                              # 303

$LR = $lca->is_AsubsetB;
ok(! $LR);                              # 304

$RL = $lca->is_RsubsetL;
ok(! $RL);                              # 305

$RL = $lca->is_BsubsetA;
ok(! $RL);                              # 306

$eqv = $lca->is_LequivalentR;
ok(! $eqv);                             # 307

$eqv = $lca->is_LeqvlntR;
ok(! $eqv);                             # 308

$return = $lca->print_subset_chart;
ok($return);                            # 309

$return = $lca->print_equivalence_chart;
ok($return);                            # 310

@memb_arr = $lca->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 311

@memb_arr = $lca->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 312

@memb_arr = $lca->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 313

@memb_arr = $lca->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 314

@memb_arr = $lca->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 315

@memb_arr = $lca->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 316

@memb_arr = $lca->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 317

@memb_arr = $lca->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 318

@memb_arr = $lca->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 319

@memb_arr = $lca->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 320

@memb_arr = $lca->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 321



$memb_arr_ref = $lca->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 322

$memb_arr_ref = $lca->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 323

$memb_arr_ref = $lca->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = $lca->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = $lca->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = $lca->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = $lca->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 328

$memb_arr_ref = $lca->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 329

$memb_arr_ref = $lca->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 330

$memb_arr_ref = $lca->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 331

$memb_arr_ref = $lca->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 332


#$memb_hash_ref = $lca->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
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

$memb_hash_ref = $lca->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 333
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 334
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 335
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 336
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 337
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 338
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 339
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 340
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 341
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 342
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 343


ok($lca->is_member_any('abel'));        # 344
ok($lca->is_member_any('baker'));       # 345
ok($lca->is_member_any('camera'));      # 346
ok($lca->is_member_any('delta'));       # 347
ok($lca->is_member_any('edward'));      # 348
ok($lca->is_member_any('fargo'));       # 349
ok($lca->is_member_any('golfer'));      # 350
ok($lca->is_member_any('hilton'));      # 351
ok(! $lca->is_member_any('icon' ));     # 352
ok(! $lca->is_member_any('jerky'));     # 353
ok(! $lca->is_member_any('zebra'));     # 354

#$memb_hash_ref = $lca->are_members_any(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lca->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 355
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 356
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 357
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 358
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 359
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 360
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 361
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 362
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 363
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 364
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 365

$vers = $lca->get_version;
ok($vers);                              # 366

my $lca_s  = List::Compare->new('-a', \@a2, \@a3);
ok($lca_s);                             # 367

$LR = $lca_s->is_LsubsetR;
ok(! $LR);                              # 368

$LR = $lca_s->is_AsubsetB;
ok(! $LR);                              # 369

$RL = $lca_s->is_RsubsetL;
ok($RL);                                # 370

$RL = $lca_s->is_BsubsetA;
ok($RL);                                # 371

$eqv = $lca_s->is_LequivalentR;
ok(! $eqv);                             # 372

$eqv = $lca_s->is_LeqvlntR;
ok(! $eqv);                             # 373

my $lca_e  = List::Compare->new('-a', \@a3, \@a4);
ok($lca_e);                             # 374

$eqv = $lca_e->is_LequivalentR;
ok($eqv);                               # 375

$eqv = $lca_e->is_LeqvlntR;
ok($eqv);                               # 376

########## BELOW:  Tests for '--accelerated' option ##########

my $lcacc   = List::Compare->new('--accelerated', \@a0, \@a1);
ok($lcacc);                             # 377

my $lcacc_s  = List::Compare->new('--accelerated', \@a2, \@a3);
ok($lcacc_s);                           # 378

my $lcacc_e  = List::Compare->new('--accelerated', \@a3, \@a4);
ok($lcacc_e);                           # 379

########## BELOW:  Tests for '-u' option ##########

my $lcau   = List::Compare->new('-u', '-a', \@a0, \@a1);
ok($lcau);                              # 380

@union = $lcau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 381
ok(exists $seen{'baker'});              # 382
ok(exists $seen{'camera'});             # 383
ok(exists $seen{'delta'});              # 384
ok(exists $seen{'edward'});             # 385
ok(exists $seen{'fargo'});              # 386
ok(exists $seen{'golfer'});             # 387
ok(exists $seen{'hilton'});             # 388
ok(! exists $seen{'icon'});             # 389
ok(! exists $seen{'jerky'});            # 390
%seen = ();

$union_ref = $lcau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 391
ok(exists $seen{'baker'});              # 392
ok(exists $seen{'camera'});             # 393
ok(exists $seen{'delta'});              # 394
ok(exists $seen{'edward'});             # 395
ok(exists $seen{'fargo'});              # 396
ok(exists $seen{'golfer'});             # 397
ok(exists $seen{'hilton'});             # 398
ok(! exists $seen{'icon'});             # 399
ok(! exists $seen{'jerky'});            # 400
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcau->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 401
ok(exists $seen{'baker'});              # 402
ok(exists $seen{'camera'});             # 403
ok(exists $seen{'delta'});              # 404
ok(exists $seen{'edward'});             # 405
ok(exists $seen{'fargo'});              # 406
ok(exists $seen{'golfer'});             # 407
ok(exists $seen{'hilton'});             # 408
ok(! exists $seen{'icon'});             # 409
ok(! exists $seen{'jerky'});            # 410
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 411
ok(exists $seen{'baker'});              # 412
ok(exists $seen{'camera'});             # 413
ok(exists $seen{'delta'});              # 414
ok(exists $seen{'edward'});             # 415
ok(exists $seen{'fargo'});              # 416
ok(exists $seen{'golfer'});             # 417
ok(exists $seen{'hilton'});             # 418
ok(! exists $seen{'icon'});             # 419
ok(! exists $seen{'jerky'});            # 420
%seen = ();

@intersection = $lcau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 421
ok(exists $seen{'baker'});              # 422
ok(exists $seen{'camera'});             # 423
ok(exists $seen{'delta'});              # 424
ok(exists $seen{'edward'});             # 425
ok(exists $seen{'fargo'});              # 426
ok(exists $seen{'golfer'});             # 427
ok(! exists $seen{'hilton'});           # 428
ok(! exists $seen{'icon'});             # 429
ok(! exists $seen{'jerky'});            # 430
%seen = ();

$intersection_ref = $lcau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 431
ok(exists $seen{'baker'});              # 432
ok(exists $seen{'camera'});             # 433
ok(exists $seen{'delta'});              # 434
ok(exists $seen{'edward'});             # 435
ok(exists $seen{'fargo'});              # 436
ok(exists $seen{'golfer'});             # 437
ok(! exists $seen{'hilton'});           # 438
ok(! exists $seen{'icon'});             # 439
ok(! exists $seen{'jerky'});            # 440
%seen = ();

@unique = $lcau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 441
ok(! exists $seen{'baker'});            # 442
ok(! exists $seen{'camera'});           # 443
ok(! exists $seen{'delta'});            # 444
ok(! exists $seen{'edward'});           # 445
ok(! exists $seen{'fargo'});            # 446
ok(! exists $seen{'golfer'});           # 447
ok(! exists $seen{'hilton'});           # 448
ok(! exists $seen{'icon'});             # 449
ok(! exists $seen{'jerky'});            # 450
%seen = ();

$unique_ref = $lcau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 451
ok(! exists $seen{'baker'});            # 452
ok(! exists $seen{'camera'});           # 453
ok(! exists $seen{'delta'});            # 454
ok(! exists $seen{'edward'});           # 455
ok(! exists $seen{'fargo'});            # 456
ok(! exists $seen{'golfer'});           # 457
ok(! exists $seen{'hilton'});           # 458
ok(! exists $seen{'icon'});             # 459
ok(! exists $seen{'jerky'});            # 460
%seen = ();

@unique = $lcau->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 461
ok(! exists $seen{'baker'});            # 462
ok(! exists $seen{'camera'});           # 463
ok(! exists $seen{'delta'});            # 464
ok(! exists $seen{'edward'});           # 465
ok(! exists $seen{'fargo'});            # 466
ok(! exists $seen{'golfer'});           # 467
ok(! exists $seen{'hilton'});           # 468
ok(! exists $seen{'icon'});             # 469
ok(! exists $seen{'jerky'});            # 470
%seen = ();

$unique_ref = $lcau->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 471
ok(! exists $seen{'baker'});            # 472
ok(! exists $seen{'camera'});           # 473
ok(! exists $seen{'delta'});            # 474
ok(! exists $seen{'edward'});           # 475
ok(! exists $seen{'fargo'});            # 476
ok(! exists $seen{'golfer'});           # 477
ok(! exists $seen{'hilton'});           # 478
ok(! exists $seen{'icon'});             # 479
ok(! exists $seen{'jerky'});            # 480
%seen = ();

@unique = $lcau->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 481
ok(! exists $seen{'baker'});            # 482
ok(! exists $seen{'camera'});           # 483
ok(! exists $seen{'delta'});            # 484
ok(! exists $seen{'edward'});           # 485
ok(! exists $seen{'fargo'});            # 486
ok(! exists $seen{'golfer'});           # 487
ok(! exists $seen{'hilton'});           # 488
ok(! exists $seen{'icon'});             # 489
ok(! exists $seen{'jerky'});            # 490
%seen = ();

$unique_ref = $lcau->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 491
ok(! exists $seen{'baker'});            # 492
ok(! exists $seen{'camera'});           # 493
ok(! exists $seen{'delta'});            # 494
ok(! exists $seen{'edward'});           # 495
ok(! exists $seen{'fargo'});            # 496
ok(! exists $seen{'golfer'});           # 497
ok(! exists $seen{'hilton'});           # 498
ok(! exists $seen{'icon'});             # 499
ok(! exists $seen{'jerky'});            # 500
%seen = ();

@complement = $lcau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 501
ok(! exists $seen{'baker'});            # 502
ok(! exists $seen{'camera'});           # 503
ok(! exists $seen{'delta'});            # 504
ok(! exists $seen{'edward'});           # 505
ok(! exists $seen{'fargo'});            # 506
ok(! exists $seen{'golfer'});           # 507
ok(exists $seen{'hilton'});             # 508
ok(! exists $seen{'icon'});             # 509
ok(! exists $seen{'jerky'});            # 510
%seen = ();

$complement_ref = $lcau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 511
ok(! exists $seen{'baker'});            # 512
ok(! exists $seen{'camera'});           # 513
ok(! exists $seen{'delta'});            # 514
ok(! exists $seen{'edward'});           # 515
ok(! exists $seen{'fargo'});            # 516
ok(! exists $seen{'golfer'});           # 517
ok(exists $seen{'hilton'});             # 518
ok(! exists $seen{'icon'});             # 519
ok(! exists $seen{'jerky'});            # 520
%seen = ();

@complement = $lcau->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 521
ok(! exists $seen{'baker'});            # 522
ok(! exists $seen{'camera'});           # 523
ok(! exists $seen{'delta'});            # 524
ok(! exists $seen{'edward'});           # 525
ok(! exists $seen{'fargo'});            # 526
ok(! exists $seen{'golfer'});           # 527
ok(exists $seen{'hilton'});             # 528
ok(! exists $seen{'icon'});             # 529
ok(! exists $seen{'jerky'});            # 530
%seen = ();

$complement_ref = $lcau->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 531
ok(! exists $seen{'baker'});            # 532
ok(! exists $seen{'camera'});           # 533
ok(! exists $seen{'delta'});            # 534
ok(! exists $seen{'edward'});           # 535
ok(! exists $seen{'fargo'});            # 536
ok(! exists $seen{'golfer'});           # 537
ok(exists $seen{'hilton'});             # 538
ok(! exists $seen{'icon'});             # 539
ok(! exists $seen{'jerky'});            # 540
%seen = ();

@complement = $lcau->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 541
ok(! exists $seen{'baker'});            # 542
ok(! exists $seen{'camera'});           # 543
ok(! exists $seen{'delta'});            # 544
ok(! exists $seen{'edward'});           # 545
ok(! exists $seen{'fargo'});            # 546
ok(! exists $seen{'golfer'});           # 547
ok(exists $seen{'hilton'});             # 548
ok(! exists $seen{'icon'});             # 549
ok(! exists $seen{'jerky'});            # 550
%seen = ();

$complement_ref = $lcau->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 551
ok(! exists $seen{'baker'});            # 552
ok(! exists $seen{'camera'});           # 553
ok(! exists $seen{'delta'});            # 554
ok(! exists $seen{'edward'});           # 555
ok(! exists $seen{'fargo'});            # 556
ok(! exists $seen{'golfer'});           # 557
ok(exists $seen{'hilton'});             # 558
ok(! exists $seen{'icon'});             # 559
ok(! exists $seen{'jerky'});            # 560
%seen = ();

@symmetric_difference = $lcau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 561
ok(! exists $seen{'baker'});            # 562
ok(! exists $seen{'camera'});           # 563
ok(! exists $seen{'delta'});            # 564
ok(! exists $seen{'edward'});           # 565
ok(! exists $seen{'fargo'});            # 566
ok(! exists $seen{'golfer'});           # 567
ok(exists $seen{'hilton'});             # 568
ok(! exists $seen{'icon'});             # 569
ok(! exists $seen{'jerky'});            # 570
%seen = ();

$symmetric_difference_ref = $lcau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 571
ok(! exists $seen{'baker'});            # 572
ok(! exists $seen{'camera'});           # 573
ok(! exists $seen{'delta'});            # 574
ok(! exists $seen{'edward'});           # 575
ok(! exists $seen{'fargo'});            # 576
ok(! exists $seen{'golfer'});           # 577
ok(exists $seen{'hilton'});             # 578
ok(! exists $seen{'icon'});             # 579
ok(! exists $seen{'jerky'});            # 580
%seen = ();

@symmetric_difference = $lcau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 581
ok(! exists $seen{'baker'});            # 582
ok(! exists $seen{'camera'});           # 583
ok(! exists $seen{'delta'});            # 584
ok(! exists $seen{'edward'});           # 585
ok(! exists $seen{'fargo'});            # 586
ok(! exists $seen{'golfer'});           # 587
ok(exists $seen{'hilton'});             # 588
ok(! exists $seen{'icon'});             # 589
ok(! exists $seen{'jerky'});            # 590
%seen = ();

$symmetric_difference_ref = $lcau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 591
ok(! exists $seen{'baker'});            # 592
ok(! exists $seen{'camera'});           # 593
ok(! exists $seen{'delta'});            # 594
ok(! exists $seen{'edward'});           # 595
ok(! exists $seen{'fargo'});            # 596
ok(! exists $seen{'golfer'});           # 597
ok(exists $seen{'hilton'});             # 598
ok(! exists $seen{'icon'});             # 599
ok(! exists $seen{'jerky'});            # 600
%seen = ();

@symmetric_difference = $lcau->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 601
ok(! exists $seen{'baker'});            # 602
ok(! exists $seen{'camera'});           # 603
ok(! exists $seen{'delta'});            # 604
ok(! exists $seen{'edward'});           # 605
ok(! exists $seen{'fargo'});            # 606
ok(! exists $seen{'golfer'});           # 607
ok(exists $seen{'hilton'});             # 608
ok(! exists $seen{'icon'});             # 609
ok(! exists $seen{'jerky'});            # 610
%seen = ();

$symmetric_difference_ref = $lcau->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 611
ok(! exists $seen{'baker'});            # 612
ok(! exists $seen{'camera'});           # 613
ok(! exists $seen{'delta'});            # 614
ok(! exists $seen{'edward'});           # 615
ok(! exists $seen{'fargo'});            # 616
ok(! exists $seen{'golfer'});           # 617
ok(exists $seen{'hilton'});             # 618
ok(! exists $seen{'icon'});             # 619
ok(! exists $seen{'jerky'});            # 620
%seen = ();

@symmetric_difference = $lcau->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 621
ok(! exists $seen{'baker'});            # 622
ok(! exists $seen{'camera'});           # 623
ok(! exists $seen{'delta'});            # 624
ok(! exists $seen{'edward'});           # 625
ok(! exists $seen{'fargo'});            # 626
ok(! exists $seen{'golfer'});           # 627
ok(exists $seen{'hilton'});             # 628
ok(! exists $seen{'icon'});             # 629
ok(! exists $seen{'jerky'});            # 630
%seen = ();

$symmetric_difference_ref = $lcau->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 631
ok(! exists $seen{'baker'});            # 632
ok(! exists $seen{'camera'});           # 633
ok(! exists $seen{'delta'});            # 634
ok(! exists $seen{'edward'});           # 635
ok(! exists $seen{'fargo'});            # 636
ok(! exists $seen{'golfer'});           # 637
ok(exists $seen{'hilton'});             # 638
ok(! exists $seen{'icon'});             # 639
ok(! exists $seen{'jerky'});            # 640
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 641
ok(! exists $seen{'baker'});            # 642
ok(! exists $seen{'camera'});           # 643
ok(! exists $seen{'delta'});            # 644
ok(! exists $seen{'edward'});           # 645
ok(! exists $seen{'fargo'});            # 646
ok(! exists $seen{'golfer'});           # 647
ok(exists $seen{'hilton'});             # 648
ok(! exists $seen{'icon'});             # 649
ok(! exists $seen{'jerky'});            # 650
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 651
ok(! exists $seen{'baker'});            # 652
ok(! exists $seen{'camera'});           # 653
ok(! exists $seen{'delta'});            # 654
ok(! exists $seen{'edward'});           # 655
ok(! exists $seen{'fargo'});            # 656
ok(! exists $seen{'golfer'});           # 657
ok(exists $seen{'hilton'});             # 658
ok(! exists $seen{'icon'});             # 659
ok(! exists $seen{'jerky'});            # 660
%seen = ();

@bag = $lcau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 661
ok($seen{'baker'} == 2);                # 662
ok($seen{'camera'} == 2);               # 663
ok($seen{'delta'} == 3);                # 664
ok($seen{'edward'} == 2);               # 665
ok($seen{'fargo'} == 2);                # 666
ok($seen{'golfer'} == 2);               # 667
ok($seen{'hilton'} == 1);               # 668
ok(! exists $seen{'icon'});             # 669
ok(! exists $seen{'jerky'});            # 670
%seen = ();

$bag_ref = $lcau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 671
ok($seen{'baker'} == 2);                # 672
ok($seen{'camera'} == 2);               # 673
ok($seen{'delta'} == 3);                # 674
ok($seen{'edward'} == 2);               # 675
ok($seen{'fargo'} == 2);                # 676
ok($seen{'golfer'} == 2);               # 677
ok($seen{'hilton'} == 1);               # 678
ok(! exists $seen{'icon'});             # 679
ok(! exists $seen{'jerky'});            # 680
%seen = ();

$LR = $lcau->is_LsubsetR;
ok(! $LR);                              # 681

$LR = $lcau->is_AsubsetB;
ok(! $LR);                              # 682

$RL = $lcau->is_RsubsetL;
ok(! $RL);                              # 683

$RL = $lcau->is_BsubsetA;
ok(! $RL);                              # 684

$eqv = $lcau->is_LequivalentR;
ok(! $eqv);                             # 685

$eqv = $lcau->is_LeqvlntR;
ok(! $eqv);                             # 686

$return = $lcau->print_subset_chart;
ok($return);                            # 687

$return = $lcau->print_equivalence_chart;
ok($return);                            # 688

@memb_arr = $lcau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 689

@memb_arr = $lcau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 690

@memb_arr = $lcau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 691

@memb_arr = $lcau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 692

@memb_arr = $lcau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 693

@memb_arr = $lcau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 694

@memb_arr = $lcau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 695

@memb_arr = $lcau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 696

@memb_arr = $lcau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 697

@memb_arr = $lcau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 698

@memb_arr = $lcau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 699



$memb_arr_ref = $lcau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 700

$memb_arr_ref = $lcau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 701

$memb_arr_ref = $lcau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 702

$memb_arr_ref = $lcau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 703

$memb_arr_ref = $lcau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 704

$memb_arr_ref = $lcau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 705

$memb_arr_ref = $lcau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 706

$memb_arr_ref = $lcau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 707

$memb_arr_ref = $lcau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 708

$memb_arr_ref = $lcau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 709

$memb_arr_ref = $lcau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 710


#$memb_hash_ref = $lcau->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
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

$memb_hash_ref = $lcau->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 711
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 712
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 713
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 714
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 715
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 716
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 717
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 718
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 719
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 720
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 721


ok($lcau->is_member_any('abel'));       # 722
ok($lcau->is_member_any('baker'));      # 723
ok($lcau->is_member_any('camera'));     # 724
ok($lcau->is_member_any('delta'));      # 725
ok($lcau->is_member_any('edward'));     # 726
ok($lcau->is_member_any('fargo'));      # 727
ok($lcau->is_member_any('golfer'));     # 728
ok($lcau->is_member_any('hilton'));     # 729
ok(! $lcau->is_member_any('icon' ));    # 730
ok(! $lcau->is_member_any('jerky'));    # 731
ok(! $lcau->is_member_any('zebra'));    # 732

#$memb_hash_ref = $lcau->are_members_any(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lcau->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 733
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 734
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 735
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 736
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 737
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 738
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 739
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 740
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 741
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 742
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 743

$vers = $lcau->get_version;
ok($vers);                              # 744

my $lcau_s  = List::Compare->new('-u', '-a', \@a2, \@a3);
ok($lcau_s);                            # 745

$LR = $lcau_s->is_LsubsetR;
ok(! $LR);                              # 746

$LR = $lcau_s->is_AsubsetB;
ok(! $LR);                              # 747

$RL = $lcau_s->is_RsubsetL;
ok($RL);                                # 748

$RL = $lcau_s->is_BsubsetA;
ok($RL);                                # 749

$eqv = $lcau_s->is_LequivalentR;
ok(! $eqv);                             # 750

$eqv = $lcau_s->is_LeqvlntR;
ok(! $eqv);                             # 751

my $lcau_e  = List::Compare->new('-u', '-a', \@a3, \@a4);
ok($lcau_e);                            # 752

$eqv = $lcau_e->is_LequivalentR;
ok($eqv);                               # 753

$eqv = $lcau_e->is_LeqvlntR;
ok($eqv);                               # 754

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcaun   = List::Compare->new('--unsorted', '-a', \@a0, \@a1);
ok($lcaun);                             # 755

my $lcaun_s  = List::Compare->new('--unsorted', '-a', \@a2, \@a3);
ok($lcaun_s);                           # 756

my $lcaun_e  = List::Compare->new('--unsorted', '-a', \@a3, \@a4);
ok($lcaun_e);                           # 757

my $lcaccun   = List::Compare->new('--unsorted', '--accelerated', \@a0, \@a1);
ok($lcaccun);                           # 758

my $lcaccun_s  = List::Compare->new('--unsorted', '--accelerated', \@a2, \@a3);
ok($lcaccun_s);                         # 759

my $lcaccun_e  = List::Compare->new('--unsorted', '--accelerated', \@a3, \@a4);
ok($lcaccun_e);                         # 760

my $lcaccu   = List::Compare->new('-u', '--accelerated', \@a0, \@a1);
ok($lcaccu);                            # 761

my $lcaccu_s  = List::Compare->new('-u', '--accelerated', \@a2, \@a3);
ok($lcaccu_s);                          # 762

my $lcaccu_e  = List::Compare->new('-u', '--accelerated', \@a3, \@a4);
ok($lcaccu_e);                          # 763

