# 01_simple.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
798; $| = 1; print "1..$last_test_to_print\n"; } # 11/21/2003 
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

$return = $lc->print_subset_chart;
ok($return);                            # 309

$return = $lc->print_equivalence_chart;
ok($return);                            # 310

@memb_arr = $lc->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 311

@memb_arr = $lc->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 312

@memb_arr = $lc->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 313

@memb_arr = $lc->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 314

@memb_arr = $lc->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 315

@memb_arr = $lc->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 316

@memb_arr = $lc->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 317

@memb_arr = $lc->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 318

@memb_arr = $lc->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 319

@memb_arr = $lc->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 320

@memb_arr = $lc->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 321



$memb_arr_ref = $lc->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 322

$memb_arr_ref = $lc->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 323

$memb_arr_ref = $lc->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = $lc->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = $lc->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = $lc->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = $lc->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 328

$memb_arr_ref = $lc->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 329

$memb_arr_ref = $lc->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 330

$memb_arr_ref = $lc->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 331

$memb_arr_ref = $lc->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 332


$memb_hash_ref = $lc->are_members_which(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lc->are_members_which( [ qw| abel baker camera delta edward fargo 
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

ok($lc->is_member_any('abel'));         # 355
ok($lc->is_member_any('baker'));        # 356
ok($lc->is_member_any('camera'));       # 357
ok($lc->is_member_any('delta'));        # 358
ok($lc->is_member_any('edward'));       # 359
ok($lc->is_member_any('fargo'));        # 360
ok($lc->is_member_any('golfer'));       # 361
ok($lc->is_member_any('hilton'));       # 362
ok(! $lc->is_member_any('icon' ));      # 363
ok(! $lc->is_member_any('jerky'));      # 364
ok(! $lc->is_member_any('zebra'));      # 365

$memb_hash_ref = $lc->are_members_any(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lc->are_members_any( [ qw| abel baker camera delta edward fargo 
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

$vers = $lc->get_version;
ok($vers);                              # 388

my $lc_s  = List::Compare->new(\@a2, \@a3);

ok($lc_s);                              # 389

$LR = $lc_s->is_LsubsetR;
ok(! $LR);                              # 390

$LR = $lc_s->is_AsubsetB;
ok(! $LR);                              # 391

$RL = $lc_s->is_RsubsetL;
ok($RL);                                # 392

$RL = $lc_s->is_BsubsetA;
ok($RL);                                # 393

$eqv = $lc_s->is_LequivalentR;
ok(! $eqv);                             # 394

$eqv = $lc_s->is_LeqvlntR;
ok(! $eqv);                             # 395

my $lc_e  = List::Compare->new(\@a3, \@a4);

ok($lc_e);                              # 396

$eqv = $lc_e->is_LequivalentR;
ok($eqv);                               # 397

$eqv = $lc_e->is_LeqvlntR;
ok($eqv);                               # 398

########## BELOW:  Tests for '-u' option ##########

my $lcu    = List::Compare->new('-u', \@a0, \@a1);

ok($lcu);                               # 399

@union = $lcu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 400
ok(exists $seen{'baker'});              # 401
ok(exists $seen{'camera'});             # 402
ok(exists $seen{'delta'});              # 403
ok(exists $seen{'edward'});             # 404
ok(exists $seen{'fargo'});              # 405
ok(exists $seen{'golfer'});             # 406
ok(exists $seen{'hilton'});             # 407
ok(! exists $seen{'icon'});             # 408
ok(! exists $seen{'jerky'});            # 409
%seen = ();

$union_ref = $lcu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 410
ok(exists $seen{'baker'});              # 411
ok(exists $seen{'camera'});             # 412
ok(exists $seen{'delta'});              # 413
ok(exists $seen{'edward'});             # 414
ok(exists $seen{'fargo'});              # 415
ok(exists $seen{'golfer'});             # 416
ok(exists $seen{'hilton'});             # 417
ok(! exists $seen{'icon'});             # 418
ok(! exists $seen{'jerky'});            # 419
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcu->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 420
ok(exists $seen{'baker'});              # 421
ok(exists $seen{'camera'});             # 422
ok(exists $seen{'delta'});              # 423
ok(exists $seen{'edward'});             # 424
ok(exists $seen{'fargo'});              # 425
ok(exists $seen{'golfer'});             # 426
ok(exists $seen{'hilton'});             # 427
ok(! exists $seen{'icon'});             # 428
ok(! exists $seen{'jerky'});            # 429
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcu->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
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

@intersection = $lcu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 440
ok(exists $seen{'baker'});              # 441
ok(exists $seen{'camera'});             # 442
ok(exists $seen{'delta'});              # 443
ok(exists $seen{'edward'});             # 444
ok(exists $seen{'fargo'});              # 445
ok(exists $seen{'golfer'});             # 446
ok(! exists $seen{'hilton'});           # 447
ok(! exists $seen{'icon'});             # 448
ok(! exists $seen{'jerky'});            # 449
%seen = ();

$intersection_ref = $lcu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
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

@unique = $lcu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 460
ok(! exists $seen{'baker'});            # 461
ok(! exists $seen{'camera'});           # 462
ok(! exists $seen{'delta'});            # 463
ok(! exists $seen{'edward'});           # 464
ok(! exists $seen{'fargo'});            # 465
ok(! exists $seen{'golfer'});           # 466
ok(! exists $seen{'hilton'});           # 467
ok(! exists $seen{'icon'});             # 468
ok(! exists $seen{'jerky'});            # 469
%seen = ();

$unique_ref = $lcu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 470
ok(! exists $seen{'baker'});            # 471
ok(! exists $seen{'camera'});           # 472
ok(! exists $seen{'delta'});            # 473
ok(! exists $seen{'edward'});           # 474
ok(! exists $seen{'fargo'});            # 475
ok(! exists $seen{'golfer'});           # 476
ok(! exists $seen{'hilton'});           # 477
ok(! exists $seen{'icon'});             # 478
ok(! exists $seen{'jerky'});            # 479
%seen = ();

@unique = $lcu->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 480
ok(! exists $seen{'baker'});            # 481
ok(! exists $seen{'camera'});           # 482
ok(! exists $seen{'delta'});            # 483
ok(! exists $seen{'edward'});           # 484
ok(! exists $seen{'fargo'});            # 485
ok(! exists $seen{'golfer'});           # 486
ok(! exists $seen{'hilton'});           # 487
ok(! exists $seen{'icon'});             # 488
ok(! exists $seen{'jerky'});            # 489
%seen = ();

$unique_ref = $lcu->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

@unique = $lcu->get_Aonly;
$seen{$_}++ foreach (@unique);
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

$unique_ref = $lcu->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 510
ok(! exists $seen{'baker'});            # 511
ok(! exists $seen{'camera'});           # 512
ok(! exists $seen{'delta'});            # 513
ok(! exists $seen{'edward'});           # 514
ok(! exists $seen{'fargo'});            # 515
ok(! exists $seen{'golfer'});           # 516
ok(! exists $seen{'hilton'});           # 517
ok(! exists $seen{'icon'});             # 518
ok(! exists $seen{'jerky'});            # 519
%seen = ();

@complement = $lcu->get_complement;
$seen{$_}++ foreach (@complement);
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

$complement_ref = $lcu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 530
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

@complement = $lcu->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 540
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

$complement_ref = $lcu->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 550
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

@complement = $lcu->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 560
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

$complement_ref = $lcu->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 570
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

@symmetric_difference = $lcu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lcu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 590
ok(! exists $seen{'baker'});            # 591
ok(! exists $seen{'camera'});           # 592
ok(! exists $seen{'delta'});            # 593
ok(! exists $seen{'edward'});           # 594
ok(! exists $seen{'fargo'});            # 595
ok(! exists $seen{'golfer'});           # 596
ok(exists $seen{'hilton'});             # 597
ok(! exists $seen{'icon'});             # 598
ok(! exists $seen{'jerky'});            # 599
%seen = ();

@symmetric_difference = $lcu->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 600
ok(! exists $seen{'baker'});            # 601
ok(! exists $seen{'camera'});           # 602
ok(! exists $seen{'delta'});            # 603
ok(! exists $seen{'edward'});           # 604
ok(! exists $seen{'fargo'});            # 605
ok(! exists $seen{'golfer'});           # 606
ok(exists $seen{'hilton'});             # 607
ok(! exists $seen{'icon'});             # 608
ok(! exists $seen{'jerky'});            # 609
%seen = ();

$symmetric_difference_ref = $lcu->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 610
ok(! exists $seen{'baker'});            # 611
ok(! exists $seen{'camera'});           # 612
ok(! exists $seen{'delta'});            # 613
ok(! exists $seen{'edward'});           # 614
ok(! exists $seen{'fargo'});            # 615
ok(! exists $seen{'golfer'});           # 616
ok(exists $seen{'hilton'});             # 617
ok(! exists $seen{'icon'});             # 618
ok(! exists $seen{'jerky'});            # 619
%seen = ();

@symmetric_difference = $lcu->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 620
ok(! exists $seen{'baker'});            # 621
ok(! exists $seen{'camera'});           # 622
ok(! exists $seen{'delta'});            # 623
ok(! exists $seen{'edward'});           # 624
ok(! exists $seen{'fargo'});            # 625
ok(! exists $seen{'golfer'});           # 626
ok(exists $seen{'hilton'});             # 627
ok(! exists $seen{'icon'});             # 628
ok(! exists $seen{'jerky'});            # 629
%seen = ();

$symmetric_difference_ref = $lcu->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 630
ok(! exists $seen{'baker'});            # 631
ok(! exists $seen{'camera'});           # 632
ok(! exists $seen{'delta'});            # 633
ok(! exists $seen{'edward'});           # 634
ok(! exists $seen{'fargo'});            # 635
ok(! exists $seen{'golfer'});           # 636
ok(exists $seen{'hilton'});             # 637
ok(! exists $seen{'icon'});             # 638
ok(! exists $seen{'jerky'});            # 639
%seen = ();

@symmetric_difference = $lcu->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 640
ok(! exists $seen{'baker'});            # 641
ok(! exists $seen{'camera'});           # 642
ok(! exists $seen{'delta'});            # 643
ok(! exists $seen{'edward'});           # 644
ok(! exists $seen{'fargo'});            # 645
ok(! exists $seen{'golfer'});           # 646
ok(exists $seen{'hilton'});             # 647
ok(! exists $seen{'icon'});             # 648
ok(! exists $seen{'jerky'});            # 649
%seen = ();

$symmetric_difference_ref = $lcu->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 650
ok(! exists $seen{'baker'});            # 651
ok(! exists $seen{'camera'});           # 652
ok(! exists $seen{'delta'});            # 653
ok(! exists $seen{'edward'});           # 654
ok(! exists $seen{'fargo'});            # 655
ok(! exists $seen{'golfer'});           # 656
ok(exists $seen{'hilton'});             # 657
ok(! exists $seen{'icon'});             # 658
ok(! exists $seen{'jerky'});            # 659
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcu->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 660
ok(! exists $seen{'baker'});            # 661
ok(! exists $seen{'camera'});           # 662
ok(! exists $seen{'delta'});            # 663
ok(! exists $seen{'edward'});           # 664
ok(! exists $seen{'fargo'});            # 665
ok(! exists $seen{'golfer'});           # 666
ok(exists $seen{'hilton'});             # 667
ok(! exists $seen{'icon'});             # 668
ok(! exists $seen{'jerky'});            # 669
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcu->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 670
ok(! exists $seen{'baker'});            # 671
ok(! exists $seen{'camera'});           # 672
ok(! exists $seen{'delta'});            # 673
ok(! exists $seen{'edward'});           # 674
ok(! exists $seen{'fargo'});            # 675
ok(! exists $seen{'golfer'});           # 676
ok(exists $seen{'hilton'});             # 677
ok(! exists $seen{'icon'});             # 678
ok(! exists $seen{'jerky'});            # 679
%seen = ();

@bag = $lcu->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 680
ok($seen{'baker'} == 2);                # 681
ok($seen{'camera'} == 2);               # 682
ok($seen{'delta'} == 3);                # 683
ok($seen{'edward'} == 2);               # 684
ok($seen{'fargo'} == 2);                # 685
ok($seen{'golfer'} == 2);               # 686
ok($seen{'hilton'} == 1);               # 687
ok(! exists $seen{'icon'});             # 688
ok(! exists $seen{'jerky'});            # 689
%seen = ();

$bag_ref = $lcu->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 690
ok($seen{'baker'} == 2);                # 691
ok($seen{'camera'} == 2);               # 692
ok($seen{'delta'} == 3);                # 693
ok($seen{'edward'} == 2);               # 694
ok($seen{'fargo'} == 2);                # 695
ok($seen{'golfer'} == 2);               # 696
ok($seen{'hilton'} == 1);               # 697
ok(! exists $seen{'icon'});             # 698
ok(! exists $seen{'jerky'});            # 699
%seen = ();

$LR = $lcu->is_LsubsetR;
ok(! $LR);                              # 700

$LR = $lcu->is_AsubsetB;
ok(! $LR);                              # 701

$RL = $lcu->is_RsubsetL;
ok(! $RL);                              # 702

$RL = $lcu->is_BsubsetA;
ok(! $RL);                              # 703

$eqv = $lcu->is_LequivalentR;
ok(! $eqv);                             # 704

$eqv = $lcu->is_LeqvlntR;
ok(! $eqv);                             # 705

$return = $lcu->print_subset_chart;
ok($return);                            # 706

$return = $lcu->print_equivalence_chart;
ok($return);                            # 707

@memb_arr = $lcu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 708

@memb_arr = $lcu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 709

@memb_arr = $lcu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 710

@memb_arr = $lcu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 711

@memb_arr = $lcu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 712

@memb_arr = $lcu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 713

@memb_arr = $lcu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 714

@memb_arr = $lcu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 715

@memb_arr = $lcu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 716

@memb_arr = $lcu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 717

@memb_arr = $lcu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 718



$memb_arr_ref = $lcu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 719

$memb_arr_ref = $lcu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 720

$memb_arr_ref = $lcu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 721

$memb_arr_ref = $lcu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 722

$memb_arr_ref = $lcu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 723

$memb_arr_ref = $lcu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 724

$memb_arr_ref = $lcu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 725

$memb_arr_ref = $lcu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 726

$memb_arr_ref = $lcu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 727

$memb_arr_ref = $lcu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 728

$memb_arr_ref = $lcu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 729


$memb_hash_ref = $lcu->are_members_which(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 730
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 731
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 732
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 733
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 734
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 735
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 736
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 737
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 738
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 739
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 740

$memb_hash_ref = $lcu->are_members_which( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 741
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 742
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 743
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 744
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 745
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 746
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 747
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 748
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 749
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 750
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 751

ok($lcu->is_member_any('abel'));        # 752
ok($lcu->is_member_any('baker'));       # 753
ok($lcu->is_member_any('camera'));      # 754
ok($lcu->is_member_any('delta'));       # 755
ok($lcu->is_member_any('edward'));      # 756
ok($lcu->is_member_any('fargo'));       # 757
ok($lcu->is_member_any('golfer'));      # 758
ok($lcu->is_member_any('hilton'));      # 759
ok(! $lcu->is_member_any('icon' ));     # 760
ok(! $lcu->is_member_any('jerky'));     # 761
ok(! $lcu->is_member_any('zebra'));     # 762

$memb_hash_ref = $lcu->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 763
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 764
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 765
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 766
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 767
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 768
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 769
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 770
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 771
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 772
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 773

$memb_hash_ref = $lcu->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 774
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 775
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 776
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 777
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 778
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 779
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 780
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 781
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 782
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 783
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 784

$vers = $lcu->get_version;
ok($vers);                              # 785

my $lcu_s  = List::Compare->new('-u', \@a2, \@a3);

ok($lcu_s);                             # 786

$LR = $lcu_s->is_LsubsetR;
ok(! $LR);                              # 787

$LR = $lcu_s->is_AsubsetB;
ok(! $LR);                              # 788

$RL = $lcu_s->is_RsubsetL;
ok($RL);                                # 789

$RL = $lcu_s->is_BsubsetA;
ok($RL);                                # 790

$eqv = $lcu_s->is_LequivalentR;
ok(! $eqv);                             # 791

$eqv = $lcu_s->is_LeqvlntR;
ok(! $eqv);                             # 792

my $lcu_e  = List::Compare->new('-u', \@a3, \@a4);

ok($lcu_e);                             # 793

$eqv = $lcu_e->is_LequivalentR;
ok($eqv);                               # 794

$eqv = $lcu_e->is_LeqvlntR;
ok($eqv);                               # 795

########## BELOW:  Tests for '--unsorted' option ##########

my $lcun    = List::Compare->new('--unsorted', \@a0, \@a1);
ok($lcun);                              # 796

my $lcun_s  = List::Compare->new('--unsorted', \@a2, \@a3);
ok($lcun_s);                            # 797

my $lcun_e  = List::Compare->new('--unsorted', \@a3, \@a4);
ok($lcun_e);                            # 798
