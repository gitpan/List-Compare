# 02_accelerated.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
398; $| = 1; print "1..$last_test_to_print\n"; } # 06/01/2003 
END {print "not ok 1\n" unless $loaded;}
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


$memb_hash_ref = $lca->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
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

$memb_hash_ref = $lca->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 344
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 345
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 346
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 347
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 348
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 349
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 350
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 351
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 352
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 353
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 354


ok($lca->is_member_any('abel'));        # 355
ok($lca->is_member_any('baker'));       # 356
ok($lca->is_member_any('camera'));      # 357
ok($lca->is_member_any('delta'));       # 358
ok($lca->is_member_any('edward'));      # 359
ok($lca->is_member_any('fargo'));       # 360
ok($lca->is_member_any('golfer'));      # 361
ok($lca->is_member_any('hilton'));      # 362
ok(! $lca->is_member_any('icon' ));     # 363
ok(! $lca->is_member_any('jerky'));     # 364
ok(! $lca->is_member_any('zebra'));     # 365

$memb_hash_ref = $lca->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 366
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 367
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 368
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 369
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 370
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 371
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 372
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 373
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 374
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 375
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 376

$memb_hash_ref = $lca->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 377
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 378
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 379
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 380
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 381
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 382
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 383
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 384
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 385
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 386
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 387

$vers = $lca->get_version;
ok($vers);                              # 388

my $lca_s  = List::Compare->new(\@a2, \@a3);

ok($lca_s);                             # 389

$LR = $lca_s->is_LsubsetR;
ok(! $LR);                              # 390

$LR = $lca_s->is_AsubsetB;
ok(! $LR);                              # 391

$RL = $lca_s->is_RsubsetL;
ok($RL);                                # 392

$RL = $lca_s->is_BsubsetA;
ok($RL);                                # 393

$eqv = $lca_s->is_LequivalentR;
ok(! $eqv);                             # 394

$eqv = $lca_s->is_LeqvlntR;
ok(! $eqv);                             # 395

my $lca_e  = List::Compare->new(\@a3, \@a4);

ok($lca_e);                             # 396

$eqv = $lca_e->is_LequivalentR;
ok($eqv);                               # 397

$eqv = $lca_e->is_LeqvlntR;
ok($eqv);                               # 398




