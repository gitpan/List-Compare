# 02_accelerated.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
807; $| = 1; print "1..$last_test_to_print\n"; } # 11/22/2003 
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

my $lca_s  = List::Compare->new('-a', \@a2, \@a3);
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

my $lca_e  = List::Compare->new('-a', \@a3, \@a4);
ok($lca_e);                             # 396

$eqv = $lca_e->is_LequivalentR;
ok($eqv);                               # 397

$eqv = $lca_e->is_LeqvlntR;
ok($eqv);                               # 398

########## BELOW:  Tests for '--accelerated' option ##########

my $lcacc   = List::Compare->new('--accelerated', \@a0, \@a1);
ok($lcacc);                             # 399

my $lcacc_s  = List::Compare->new('--accelerated', \@a2, \@a3);
ok($lcacc_s);                           # 400

my $lcacc_e  = List::Compare->new('--accelerated', \@a3, \@a4);
ok($lcacc_e);                           # 401

########## BELOW:  Tests for '-u' option ##########

my $lcau   = List::Compare->new('-u', '-a', \@a0, \@a1);
ok($lcau);                              # 402

@union = $lcau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 403
ok(exists $seen{'baker'});              # 404
ok(exists $seen{'camera'});             # 405
ok(exists $seen{'delta'});              # 406
ok(exists $seen{'edward'});             # 407
ok(exists $seen{'fargo'});              # 408
ok(exists $seen{'golfer'});             # 409
ok(exists $seen{'hilton'});             # 410
ok(! exists $seen{'icon'});             # 411
ok(! exists $seen{'jerky'});            # 412
%seen = ();

$union_ref = $lcau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 413
ok(exists $seen{'baker'});              # 414
ok(exists $seen{'camera'});             # 415
ok(exists $seen{'delta'});              # 416
ok(exists $seen{'edward'});             # 417
ok(exists $seen{'fargo'});              # 418
ok(exists $seen{'golfer'});             # 419
ok(exists $seen{'hilton'});             # 420
ok(! exists $seen{'icon'});             # 421
ok(! exists $seen{'jerky'});            # 422
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcau->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 423
ok(exists $seen{'baker'});              # 424
ok(exists $seen{'camera'});             # 425
ok(exists $seen{'delta'});              # 426
ok(exists $seen{'edward'});             # 427
ok(exists $seen{'fargo'});              # 428
ok(exists $seen{'golfer'});             # 429
ok(exists $seen{'hilton'});             # 430
ok(! exists $seen{'icon'});             # 431
ok(! exists $seen{'jerky'});            # 432
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
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

@intersection = $lcau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 443
ok(exists $seen{'baker'});              # 444
ok(exists $seen{'camera'});             # 445
ok(exists $seen{'delta'});              # 446
ok(exists $seen{'edward'});             # 447
ok(exists $seen{'fargo'});              # 448
ok(exists $seen{'golfer'});             # 449
ok(! exists $seen{'hilton'});           # 450
ok(! exists $seen{'icon'});             # 451
ok(! exists $seen{'jerky'});            # 452
%seen = ();

$intersection_ref = $lcau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
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

@unique = $lcau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 463
ok(! exists $seen{'baker'});            # 464
ok(! exists $seen{'camera'});           # 465
ok(! exists $seen{'delta'});            # 466
ok(! exists $seen{'edward'});           # 467
ok(! exists $seen{'fargo'});            # 468
ok(! exists $seen{'golfer'});           # 469
ok(! exists $seen{'hilton'});           # 470
ok(! exists $seen{'icon'});             # 471
ok(! exists $seen{'jerky'});            # 472
%seen = ();

$unique_ref = $lcau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 473
ok(! exists $seen{'baker'});            # 474
ok(! exists $seen{'camera'});           # 475
ok(! exists $seen{'delta'});            # 476
ok(! exists $seen{'edward'});           # 477
ok(! exists $seen{'fargo'});            # 478
ok(! exists $seen{'golfer'});           # 479
ok(! exists $seen{'hilton'});           # 480
ok(! exists $seen{'icon'});             # 481
ok(! exists $seen{'jerky'});            # 482
%seen = ();

@unique = $lcau->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 483
ok(! exists $seen{'baker'});            # 484
ok(! exists $seen{'camera'});           # 485
ok(! exists $seen{'delta'});            # 486
ok(! exists $seen{'edward'});           # 487
ok(! exists $seen{'fargo'});            # 488
ok(! exists $seen{'golfer'});           # 489
ok(! exists $seen{'hilton'});           # 490
ok(! exists $seen{'icon'});             # 491
ok(! exists $seen{'jerky'});            # 492
%seen = ();

$unique_ref = $lcau->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

@unique = $lcau->get_Aonly;
$seen{$_}++ foreach (@unique);
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

$unique_ref = $lcau->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 513
ok(! exists $seen{'baker'});            # 514
ok(! exists $seen{'camera'});           # 515
ok(! exists $seen{'delta'});            # 516
ok(! exists $seen{'edward'});           # 517
ok(! exists $seen{'fargo'});            # 518
ok(! exists $seen{'golfer'});           # 519
ok(! exists $seen{'hilton'});           # 520
ok(! exists $seen{'icon'});             # 521
ok(! exists $seen{'jerky'});            # 522
%seen = ();

@complement = $lcau->get_complement;
$seen{$_}++ foreach (@complement);
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

$complement_ref = $lcau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 533
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

@complement = $lcau->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 543
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

$complement_ref = $lcau->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 553
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

@complement = $lcau->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 563
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

$complement_ref = $lcau->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 573
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

@symmetric_difference = $lcau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lcau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 593
ok(! exists $seen{'baker'});            # 594
ok(! exists $seen{'camera'});           # 595
ok(! exists $seen{'delta'});            # 596
ok(! exists $seen{'edward'});           # 597
ok(! exists $seen{'fargo'});            # 598
ok(! exists $seen{'golfer'});           # 599
ok(exists $seen{'hilton'});             # 600
ok(! exists $seen{'icon'});             # 601
ok(! exists $seen{'jerky'});            # 602
%seen = ();

@symmetric_difference = $lcau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 603
ok(! exists $seen{'baker'});            # 604
ok(! exists $seen{'camera'});           # 605
ok(! exists $seen{'delta'});            # 606
ok(! exists $seen{'edward'});           # 607
ok(! exists $seen{'fargo'});            # 608
ok(! exists $seen{'golfer'});           # 609
ok(exists $seen{'hilton'});             # 610
ok(! exists $seen{'icon'});             # 611
ok(! exists $seen{'jerky'});            # 612
%seen = ();

$symmetric_difference_ref = $lcau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 613
ok(! exists $seen{'baker'});            # 614
ok(! exists $seen{'camera'});           # 615
ok(! exists $seen{'delta'});            # 616
ok(! exists $seen{'edward'});           # 617
ok(! exists $seen{'fargo'});            # 618
ok(! exists $seen{'golfer'});           # 619
ok(exists $seen{'hilton'});             # 620
ok(! exists $seen{'icon'});             # 621
ok(! exists $seen{'jerky'});            # 622
%seen = ();

@symmetric_difference = $lcau->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 623
ok(! exists $seen{'baker'});            # 624
ok(! exists $seen{'camera'});           # 625
ok(! exists $seen{'delta'});            # 626
ok(! exists $seen{'edward'});           # 627
ok(! exists $seen{'fargo'});            # 628
ok(! exists $seen{'golfer'});           # 629
ok(exists $seen{'hilton'});             # 630
ok(! exists $seen{'icon'});             # 631
ok(! exists $seen{'jerky'});            # 632
%seen = ();

$symmetric_difference_ref = $lcau->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 633
ok(! exists $seen{'baker'});            # 634
ok(! exists $seen{'camera'});           # 635
ok(! exists $seen{'delta'});            # 636
ok(! exists $seen{'edward'});           # 637
ok(! exists $seen{'fargo'});            # 638
ok(! exists $seen{'golfer'});           # 639
ok(exists $seen{'hilton'});             # 640
ok(! exists $seen{'icon'});             # 641
ok(! exists $seen{'jerky'});            # 642
%seen = ();

@symmetric_difference = $lcau->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 643
ok(! exists $seen{'baker'});            # 644
ok(! exists $seen{'camera'});           # 645
ok(! exists $seen{'delta'});            # 646
ok(! exists $seen{'edward'});           # 647
ok(! exists $seen{'fargo'});            # 648
ok(! exists $seen{'golfer'});           # 649
ok(exists $seen{'hilton'});             # 650
ok(! exists $seen{'icon'});             # 651
ok(! exists $seen{'jerky'});            # 652
%seen = ();

$symmetric_difference_ref = $lcau->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 653
ok(! exists $seen{'baker'});            # 654
ok(! exists $seen{'camera'});           # 655
ok(! exists $seen{'delta'});            # 656
ok(! exists $seen{'edward'});           # 657
ok(! exists $seen{'fargo'});            # 658
ok(! exists $seen{'golfer'});           # 659
ok(exists $seen{'hilton'});             # 660
ok(! exists $seen{'icon'});             # 661
ok(! exists $seen{'jerky'});            # 662
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 663
ok(! exists $seen{'baker'});            # 664
ok(! exists $seen{'camera'});           # 665
ok(! exists $seen{'delta'});            # 666
ok(! exists $seen{'edward'});           # 667
ok(! exists $seen{'fargo'});            # 668
ok(! exists $seen{'golfer'});           # 669
ok(exists $seen{'hilton'});             # 670
ok(! exists $seen{'icon'});             # 671
ok(! exists $seen{'jerky'});            # 672
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 673
ok(! exists $seen{'baker'});            # 674
ok(! exists $seen{'camera'});           # 675
ok(! exists $seen{'delta'});            # 676
ok(! exists $seen{'edward'});           # 677
ok(! exists $seen{'fargo'});            # 678
ok(! exists $seen{'golfer'});           # 679
ok(exists $seen{'hilton'});             # 680
ok(! exists $seen{'icon'});             # 681
ok(! exists $seen{'jerky'});            # 682
%seen = ();

@bag = $lcau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 683
ok($seen{'baker'} == 2);                # 684
ok($seen{'camera'} == 2);               # 685
ok($seen{'delta'} == 3);                # 686
ok($seen{'edward'} == 2);               # 687
ok($seen{'fargo'} == 2);                # 688
ok($seen{'golfer'} == 2);               # 689
ok($seen{'hilton'} == 1);               # 690
ok(! exists $seen{'icon'});             # 691
ok(! exists $seen{'jerky'});            # 692
%seen = ();

$bag_ref = $lcau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 693
ok($seen{'baker'} == 2);                # 694
ok($seen{'camera'} == 2);               # 695
ok($seen{'delta'} == 3);                # 696
ok($seen{'edward'} == 2);               # 697
ok($seen{'fargo'} == 2);                # 698
ok($seen{'golfer'} == 2);               # 699
ok($seen{'hilton'} == 1);               # 700
ok(! exists $seen{'icon'});             # 701
ok(! exists $seen{'jerky'});            # 702
%seen = ();

$LR = $lcau->is_LsubsetR;
ok(! $LR);                              # 703

$LR = $lcau->is_AsubsetB;
ok(! $LR);                              # 704

$RL = $lcau->is_RsubsetL;
ok(! $RL);                              # 705

$RL = $lcau->is_BsubsetA;
ok(! $RL);                              # 706

$eqv = $lcau->is_LequivalentR;
ok(! $eqv);                             # 707

$eqv = $lcau->is_LeqvlntR;
ok(! $eqv);                             # 708

$return = $lcau->print_subset_chart;
ok($return);                            # 709

$return = $lcau->print_equivalence_chart;
ok($return);                            # 710

@memb_arr = $lcau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 711

@memb_arr = $lcau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 712

@memb_arr = $lcau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 713

@memb_arr = $lcau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 714

@memb_arr = $lcau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 715

@memb_arr = $lcau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 716

@memb_arr = $lcau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 717

@memb_arr = $lcau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 718

@memb_arr = $lcau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 719

@memb_arr = $lcau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 720

@memb_arr = $lcau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 721



$memb_arr_ref = $lcau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 722

$memb_arr_ref = $lcau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 723

$memb_arr_ref = $lcau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 724

$memb_arr_ref = $lcau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 725

$memb_arr_ref = $lcau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 726

$memb_arr_ref = $lcau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 727

$memb_arr_ref = $lcau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 728

$memb_arr_ref = $lcau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 729

$memb_arr_ref = $lcau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 730

$memb_arr_ref = $lcau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 731

$memb_arr_ref = $lcau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 732


$memb_hash_ref = $lcau->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 733
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 734
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 735
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 736
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 737
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 738
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 739
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 740
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 741
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 742
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 743

$memb_hash_ref = $lcau->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 744
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 745
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 746
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 747
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 748
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 749
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 750
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 751
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 752
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 753
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 754


ok($lcau->is_member_any('abel'));       # 755
ok($lcau->is_member_any('baker'));      # 756
ok($lcau->is_member_any('camera'));     # 757
ok($lcau->is_member_any('delta'));      # 758
ok($lcau->is_member_any('edward'));     # 759
ok($lcau->is_member_any('fargo'));      # 760
ok($lcau->is_member_any('golfer'));     # 761
ok($lcau->is_member_any('hilton'));     # 762
ok(! $lcau->is_member_any('icon' ));    # 763
ok(! $lcau->is_member_any('jerky'));    # 764
ok(! $lcau->is_member_any('zebra'));    # 765

$memb_hash_ref = $lcau->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 766
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 767
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 768
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 769
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 770
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 771
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 772
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 773
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 774
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 775
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 776

$memb_hash_ref = $lcau->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 777
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 778
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 779
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 780
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 781
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 782
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 783
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 784
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 785
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 786
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 787

$vers = $lcau->get_version;
ok($vers);                              # 788

my $lcau_s  = List::Compare->new('-u', '-a', \@a2, \@a3);
ok($lcau_s);                            # 789

$LR = $lcau_s->is_LsubsetR;
ok(! $LR);                              # 790

$LR = $lcau_s->is_AsubsetB;
ok(! $LR);                              # 791

$RL = $lcau_s->is_RsubsetL;
ok($RL);                                # 792

$RL = $lcau_s->is_BsubsetA;
ok($RL);                                # 793

$eqv = $lcau_s->is_LequivalentR;
ok(! $eqv);                             # 794

$eqv = $lcau_s->is_LeqvlntR;
ok(! $eqv);                             # 795

my $lcau_e  = List::Compare->new('-u', '-a', \@a3, \@a4);
ok($lcau_e);                            # 796

$eqv = $lcau_e->is_LequivalentR;
ok($eqv);                               # 797

$eqv = $lcau_e->is_LeqvlntR;
ok($eqv);                               # 798

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcaun   = List::Compare->new('--unsorted', '-a', \@a0, \@a1);
ok($lcaun);                             # 799

my $lcaun_s  = List::Compare->new('--unsorted', '-a', \@a2, \@a3);
ok($lcaun_s);                           # 800

my $lcaun_e  = List::Compare->new('--unsorted', '-a', \@a3, \@a4);
ok($lcaun_e);                           # 801

my $lcaccun   = List::Compare->new('--unsorted', '--accelerated', \@a0, \@a1);
ok($lcaccun);                           # 802

my $lcaccun_s  = List::Compare->new('--unsorted', '--accelerated', \@a2, \@a3);
ok($lcaccun_s);                         # 803

my $lcaccun_e  = List::Compare->new('--unsorted', '--accelerated', \@a3, \@a4);
ok($lcaccun_e);                         # 804

my $lcaccu   = List::Compare->new('-u', '--accelerated', \@a0, \@a1);
ok($lcaccu);                            # 805

my $lcaccu_s  = List::Compare->new('-u', '--accelerated', \@a2, \@a3);
ok($lcaccu_s);                          # 806

my $lcaccu_e  = List::Compare->new('-u', '--accelerated', \@a3, \@a4);
ok($lcaccu_e);                          # 807

