# 18_alt_construct_accelerated.t # as of 05/08/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
819;
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

my $lca   = List::Compare->new( { accelerated => 1, lists => [\@a0, \@a1] } );
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

@intersection = $lca->get_intersection_alt;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 63
ok(exists $seen{'baker'});              # 64
ok(exists $seen{'camera'});             # 65
ok(exists $seen{'delta'});              # 66
ok(exists $seen{'edward'});             # 67
ok(exists $seen{'fargo'});              # 68
ok(exists $seen{'golfer'});             # 69
ok(! exists $seen{'hilton'});           # 70
ok(! exists $seen{'icon'});             # 71
ok(! exists $seen{'jerky'});            # 72
%seen = ();

$intersection_ref = $lca->get_intersection_alt_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 73
ok(exists $seen{'baker'});              # 74
ok(exists $seen{'camera'});             # 75
ok(exists $seen{'delta'});              # 76
ok(exists $seen{'edward'});             # 77
ok(exists $seen{'fargo'});              # 78
ok(exists $seen{'golfer'});             # 79
ok(! exists $seen{'hilton'});           # 80
ok(! exists $seen{'icon'});             # 81
ok(! exists $seen{'jerky'});            # 82
%seen = ();

@unique = $lca->get_unique;
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

$unique_ref = $lca->get_unique_ref;
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

@unique = $lca->get_Lonly;
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

$unique_ref = $lca->get_Lonly_ref;
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

@unique = $lca->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 123
ok(! exists $seen{'baker'});            # 124
ok(! exists $seen{'camera'});           # 125
ok(! exists $seen{'delta'});            # 126
ok(! exists $seen{'edward'});           # 127
ok(! exists $seen{'fargo'});            # 128
ok(! exists $seen{'golfer'});           # 129
ok(! exists $seen{'hilton'});           # 130
ok(! exists $seen{'icon'});             # 131
ok(! exists $seen{'jerky'});            # 132
%seen = ();

$unique_ref = $lca->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 133
ok(! exists $seen{'baker'});            # 134
ok(! exists $seen{'camera'});           # 135
ok(! exists $seen{'delta'});            # 136
ok(! exists $seen{'edward'});           # 137
ok(! exists $seen{'fargo'});            # 138
ok(! exists $seen{'golfer'});           # 139
ok(! exists $seen{'hilton'});           # 140
ok(! exists $seen{'icon'});             # 141
ok(! exists $seen{'jerky'});            # 142
%seen = ();

@complement = $lca->get_complement;
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

$complement_ref = $lca->get_complement_ref;
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

@complement = $lca->get_Ronly;
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

$complement_ref = $lca->get_Ronly_ref;
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

@complement = $lca->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 183
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

$complement_ref = $lca->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 193
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

@symmetric_difference = $lca->get_symmetric_difference;
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

$symmetric_difference_ref = $lca->get_symmetric_difference_ref;
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

@symmetric_difference = $lca->get_symmetric_difference_alt;
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

$symmetric_difference_ref = $lca->get_symmetric_difference_alt_ref;
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

@symmetric_difference = $lca->get_symdiff;
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

$symmetric_difference_ref = $lca->get_symdiff_ref;
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

@symmetric_difference = $lca->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lca->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
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

@symmetric_difference = $lca->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 283
ok(! exists $seen{'baker'});            # 284
ok(! exists $seen{'camera'});           # 285
ok(! exists $seen{'delta'});            # 286
ok(! exists $seen{'edward'});           # 287
ok(! exists $seen{'fargo'});            # 288
ok(! exists $seen{'golfer'});           # 289
ok(exists $seen{'hilton'});             # 290
ok(! exists $seen{'icon'});             # 291
ok(! exists $seen{'jerky'});            # 292
%seen = ();

$symmetric_difference_ref = $lca->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 293
ok(! exists $seen{'baker'});            # 294
ok(! exists $seen{'camera'});           # 295
ok(! exists $seen{'delta'});            # 296
ok(! exists $seen{'edward'});           # 297
ok(! exists $seen{'fargo'});            # 298
ok(! exists $seen{'golfer'});           # 299
ok(exists $seen{'hilton'});             # 300
ok(! exists $seen{'icon'});             # 301
ok(! exists $seen{'jerky'});            # 302
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @nonintersection = $lca->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 303
ok(! exists $seen{'baker'});            # 304
ok(! exists $seen{'camera'});           # 305
ok(! exists $seen{'delta'});            # 306
ok(! exists $seen{'edward'});           # 307
ok(! exists $seen{'fargo'});            # 308
ok(! exists $seen{'golfer'});           # 309
ok(exists $seen{'hilton'});             # 310
ok(! exists $seen{'icon'});             # 311
ok(! exists $seen{'jerky'});            # 312
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $nonintersection_ref = $lca->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 313
ok(! exists $seen{'baker'});            # 314
ok(! exists $seen{'camera'});           # 315
ok(! exists $seen{'delta'});            # 316
ok(! exists $seen{'edward'});           # 317
ok(! exists $seen{'fargo'});            # 318
ok(! exists $seen{'golfer'});           # 319
ok(exists $seen{'hilton'});             # 320
ok(! exists $seen{'icon'});             # 321
ok(! exists $seen{'jerky'});            # 322
%seen = ();

@bag = $lca->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 323
ok($seen{'baker'} == 2);                # 324
ok($seen{'camera'} == 2);               # 325
ok($seen{'delta'} == 3);                # 326
ok($seen{'edward'} == 2);               # 327
ok($seen{'fargo'} == 2);                # 328
ok($seen{'golfer'} == 2);               # 329
ok($seen{'hilton'} == 1);               # 330
ok(! exists $seen{'icon'});             # 331
ok(! exists $seen{'jerky'});            # 332
%seen = ();

$bag_ref = $lca->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 333
ok($seen{'baker'} == 2);                # 334
ok($seen{'camera'} == 2);               # 335
ok($seen{'delta'} == 3);                # 336
ok($seen{'edward'} == 2);               # 337
ok($seen{'fargo'} == 2);                # 338
ok($seen{'golfer'} == 2);               # 339
ok($seen{'hilton'} == 1);               # 340
ok(! exists $seen{'icon'});             # 341
ok(! exists $seen{'jerky'});            # 342
%seen = ();

$LR = $lca->is_LsubsetR;
ok(! $LR);                              # 343

$LR = $lca->is_AsubsetB;
ok(! $LR);                              # 344

$RL = $lca->is_RsubsetL;
ok(! $RL);                              # 345

$RL = $lca->is_BsubsetA;
ok(! $RL);                              # 346

$eqv = $lca->is_LequivalentR;
ok(! $eqv);                             # 347

$eqv = $lca->is_LeqvlntR;
ok(! $eqv);                             # 348

$disj = $lca->is_LdisjointR;
ok(! $disj);                            # 349

$return = $lca->print_subset_chart;
ok($return);                            # 350

$return = $lca->print_equivalence_chart;
ok($return);                            # 351

@memb_arr = $lca->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 352

@memb_arr = $lca->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 353

@memb_arr = $lca->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 354

@memb_arr = $lca->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 355

@memb_arr = $lca->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 356

@memb_arr = $lca->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 357

@memb_arr = $lca->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 358

@memb_arr = $lca->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 359

@memb_arr = $lca->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 360

@memb_arr = $lca->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 361

@memb_arr = $lca->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 362

$memb_arr_ref = $lca->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 363

$memb_arr_ref = $lca->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 364

$memb_arr_ref = $lca->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 365

$memb_arr_ref = $lca->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 366

$memb_arr_ref = $lca->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 367

$memb_arr_ref = $lca->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 368

$memb_arr_ref = $lca->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 369

$memb_arr_ref = $lca->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 370

$memb_arr_ref = $lca->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 371

$memb_arr_ref = $lca->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 372

$memb_arr_ref = $lca->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 373

$memb_hash_ref = $lca->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 374
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 375
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 376
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 377
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 378
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 379
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 380
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 381
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 382
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 383
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 384

ok($lca->is_member_any('abel'));        # 385
ok($lca->is_member_any('baker'));       # 386
ok($lca->is_member_any('camera'));      # 387
ok($lca->is_member_any('delta'));       # 388
ok($lca->is_member_any('edward'));      # 389
ok($lca->is_member_any('fargo'));       # 390
ok($lca->is_member_any('golfer'));      # 391
ok($lca->is_member_any('hilton'));      # 392
ok(! $lca->is_member_any('icon' ));     # 393
ok(! $lca->is_member_any('jerky'));     # 394
ok(! $lca->is_member_any('zebra'));     # 395

$memb_hash_ref = $lca->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 396
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 397
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 398
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 399
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 400
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 401
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 402
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 403
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 404
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 405
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 406

$vers = $lca->get_version;
ok($vers);                              # 407

my $lca_s  = List::Compare->new( { accelerated => 1, lists => [\@a2, \@a3] } );
ok($lca_s);                             # 408

$LR = $lca_s->is_LsubsetR;
ok(! $LR);                              # 409

$LR = $lca_s->is_AsubsetB;
ok(! $LR);                              # 410

$RL = $lca_s->is_RsubsetL;
ok($RL);                                # 411

$RL = $lca_s->is_BsubsetA;
ok($RL);                                # 412

$eqv = $lca_s->is_LequivalentR;
ok(! $eqv);                             # 413

$eqv = $lca_s->is_LeqvlntR;
ok(! $eqv);                             # 414

$disj = $lca_s->is_LdisjointR;
ok(! $disj);                            # 415

my $lca_e  = List::Compare->new( { accelerated => 1, lists => [\@a3, \@a4] } );
ok($lca_e);                             # 416

$eqv = $lca_e->is_LequivalentR;
ok($eqv);                               # 417

$eqv = $lca_e->is_LeqvlntR;
ok($eqv);                               # 418

$disj = $lca_e->is_LdisjointR;
ok(! $disj);                            # 419

my $lca_dj  = List::Compare->new( { accelerated => 1, lists => [\@a4, \@a8] } );

ok($lca_dj);                            # 420

ok(0 == $lca_dj->get_intersection);     # 421
ok(0 == scalar(@{$lca_dj->get_intersection_ref}));# 422
$disj = $lca_dj->is_LdisjointR;
ok($disj);                              # 423

########## BELOW:  Tests for '--accelerated' option ##########

my $lcacc   = List::Compare->new( { accelerated => 1, lists => [\@a0, \@a1] } );
ok($lcacc);                             # 424

my $lcacc_s  = List::Compare->new( { accelerated => 1, lists => [\@a2, \@a3] } );
ok($lcacc_s);                           # 425

my $lcacc_e  = List::Compare->new( { accelerated => 1, lists => [\@a3, \@a4] } );
ok($lcacc_e);                           # 426

########## BELOW:  Tests for '-u' option ##########

my $lcau   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1] } );
ok($lcau);                              # 427

@union = $lcau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 428
ok(exists $seen{'baker'});              # 429
ok(exists $seen{'camera'});             # 430
ok(exists $seen{'delta'});              # 431
ok(exists $seen{'edward'});             # 432
ok(exists $seen{'fargo'});              # 433
ok(exists $seen{'golfer'});             # 434
ok(exists $seen{'hilton'});             # 435
ok(! exists $seen{'icon'});             # 436
ok(! exists $seen{'jerky'});            # 437
%seen = ();

$union_ref = $lcau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 438
ok(exists $seen{'baker'});              # 439
ok(exists $seen{'camera'});             # 440
ok(exists $seen{'delta'});              # 441
ok(exists $seen{'edward'});             # 442
ok(exists $seen{'fargo'});              # 443
ok(exists $seen{'golfer'});             # 444
ok(exists $seen{'hilton'});             # 445
ok(! exists $seen{'icon'});             # 446
ok(! exists $seen{'jerky'});            # 447
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @shared = $lcau->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 448
ok(exists $seen{'baker'});              # 449
ok(exists $seen{'camera'});             # 450
ok(exists $seen{'delta'});              # 451
ok(exists $seen{'edward'});             # 452
ok(exists $seen{'fargo'});              # 453
ok(exists $seen{'golfer'});             # 454
ok(exists $seen{'hilton'});             # 455
ok(! exists $seen{'icon'});             # 456
ok(! exists $seen{'jerky'});            # 457
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $shared_ref = $lcau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 458
ok(exists $seen{'baker'});              # 459
ok(exists $seen{'camera'});             # 460
ok(exists $seen{'delta'});              # 461
ok(exists $seen{'edward'});             # 462
ok(exists $seen{'fargo'});              # 463
ok(exists $seen{'golfer'});             # 464
ok(exists $seen{'hilton'});             # 465
ok(! exists $seen{'icon'});             # 466
ok(! exists $seen{'jerky'});            # 467
%seen = ();

@intersection = $lcau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 468
ok(exists $seen{'baker'});              # 469
ok(exists $seen{'camera'});             # 470
ok(exists $seen{'delta'});              # 471
ok(exists $seen{'edward'});             # 472
ok(exists $seen{'fargo'});              # 473
ok(exists $seen{'golfer'});             # 474
ok(! exists $seen{'hilton'});           # 475
ok(! exists $seen{'icon'});             # 476
ok(! exists $seen{'jerky'});            # 477
%seen = ();

$intersection_ref = $lcau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 478
ok(exists $seen{'baker'});              # 479
ok(exists $seen{'camera'});             # 480
ok(exists $seen{'delta'});              # 481
ok(exists $seen{'edward'});             # 482
ok(exists $seen{'fargo'});              # 483
ok(exists $seen{'golfer'});             # 484
ok(! exists $seen{'hilton'});           # 485
ok(! exists $seen{'icon'});             # 486
ok(! exists $seen{'jerky'});            # 487
%seen = ();

@unique = $lcau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 488
ok(! exists $seen{'baker'});            # 489
ok(! exists $seen{'camera'});           # 490
ok(! exists $seen{'delta'});            # 491
ok(! exists $seen{'edward'});           # 492
ok(! exists $seen{'fargo'});            # 493
ok(! exists $seen{'golfer'});           # 494
ok(! exists $seen{'hilton'});           # 495
ok(! exists $seen{'icon'});             # 496
ok(! exists $seen{'jerky'});            # 497
%seen = ();

$unique_ref = $lcau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 498
ok(! exists $seen{'baker'});            # 499
ok(! exists $seen{'camera'});           # 500
ok(! exists $seen{'delta'});            # 501
ok(! exists $seen{'edward'});           # 502
ok(! exists $seen{'fargo'});            # 503
ok(! exists $seen{'golfer'});           # 504
ok(! exists $seen{'hilton'});           # 505
ok(! exists $seen{'icon'});             # 506
ok(! exists $seen{'jerky'});            # 507
%seen = ();

@unique = $lcau->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 508
ok(! exists $seen{'baker'});            # 509
ok(! exists $seen{'camera'});           # 510
ok(! exists $seen{'delta'});            # 511
ok(! exists $seen{'edward'});           # 512
ok(! exists $seen{'fargo'});            # 513
ok(! exists $seen{'golfer'});           # 514
ok(! exists $seen{'hilton'});           # 515
ok(! exists $seen{'icon'});             # 516
ok(! exists $seen{'jerky'});            # 517
%seen = ();

$unique_ref = $lcau->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 518
ok(! exists $seen{'baker'});            # 519
ok(! exists $seen{'camera'});           # 520
ok(! exists $seen{'delta'});            # 521
ok(! exists $seen{'edward'});           # 522
ok(! exists $seen{'fargo'});            # 523
ok(! exists $seen{'golfer'});           # 524
ok(! exists $seen{'hilton'});           # 525
ok(! exists $seen{'icon'});             # 526
ok(! exists $seen{'jerky'});            # 527
%seen = ();

@unique = $lcau->get_Aonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 528
ok(! exists $seen{'baker'});            # 529
ok(! exists $seen{'camera'});           # 530
ok(! exists $seen{'delta'});            # 531
ok(! exists $seen{'edward'});           # 532
ok(! exists $seen{'fargo'});            # 533
ok(! exists $seen{'golfer'});           # 534
ok(! exists $seen{'hilton'});           # 535
ok(! exists $seen{'icon'});             # 536
ok(! exists $seen{'jerky'});            # 537
%seen = ();

$unique_ref = $lcau->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 538
ok(! exists $seen{'baker'});            # 539
ok(! exists $seen{'camera'});           # 540
ok(! exists $seen{'delta'});            # 541
ok(! exists $seen{'edward'});           # 542
ok(! exists $seen{'fargo'});            # 543
ok(! exists $seen{'golfer'});           # 544
ok(! exists $seen{'hilton'});           # 545
ok(! exists $seen{'icon'});             # 546
ok(! exists $seen{'jerky'});            # 547
%seen = ();

@complement = $lcau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 548
ok(! exists $seen{'baker'});            # 549
ok(! exists $seen{'camera'});           # 550
ok(! exists $seen{'delta'});            # 551
ok(! exists $seen{'edward'});           # 552
ok(! exists $seen{'fargo'});            # 553
ok(! exists $seen{'golfer'});           # 554
ok(exists $seen{'hilton'});             # 555
ok(! exists $seen{'icon'});             # 556
ok(! exists $seen{'jerky'});            # 557
%seen = ();

$complement_ref = $lcau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 558
ok(! exists $seen{'baker'});            # 559
ok(! exists $seen{'camera'});           # 560
ok(! exists $seen{'delta'});            # 561
ok(! exists $seen{'edward'});           # 562
ok(! exists $seen{'fargo'});            # 563
ok(! exists $seen{'golfer'});           # 564
ok(exists $seen{'hilton'});             # 565
ok(! exists $seen{'icon'});             # 566
ok(! exists $seen{'jerky'});            # 567
%seen = ();

@complement = $lcau->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 568
ok(! exists $seen{'baker'});            # 569
ok(! exists $seen{'camera'});           # 570
ok(! exists $seen{'delta'});            # 571
ok(! exists $seen{'edward'});           # 572
ok(! exists $seen{'fargo'});            # 573
ok(! exists $seen{'golfer'});           # 574
ok(exists $seen{'hilton'});             # 575
ok(! exists $seen{'icon'});             # 576
ok(! exists $seen{'jerky'});            # 577
%seen = ();

$complement_ref = $lcau->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 578
ok(! exists $seen{'baker'});            # 579
ok(! exists $seen{'camera'});           # 580
ok(! exists $seen{'delta'});            # 581
ok(! exists $seen{'edward'});           # 582
ok(! exists $seen{'fargo'});            # 583
ok(! exists $seen{'golfer'});           # 584
ok(exists $seen{'hilton'});             # 585
ok(! exists $seen{'icon'});             # 586
ok(! exists $seen{'jerky'});            # 587
%seen = ();

@complement = $lcau->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 588
ok(! exists $seen{'baker'});            # 589
ok(! exists $seen{'camera'});           # 590
ok(! exists $seen{'delta'});            # 591
ok(! exists $seen{'edward'});           # 592
ok(! exists $seen{'fargo'});            # 593
ok(! exists $seen{'golfer'});           # 594
ok(exists $seen{'hilton'});             # 595
ok(! exists $seen{'icon'});             # 596
ok(! exists $seen{'jerky'});            # 597
%seen = ();

$complement_ref = $lcau->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 598
ok(! exists $seen{'baker'});            # 599
ok(! exists $seen{'camera'});           # 600
ok(! exists $seen{'delta'});            # 601
ok(! exists $seen{'edward'});           # 602
ok(! exists $seen{'fargo'});            # 603
ok(! exists $seen{'golfer'});           # 604
ok(exists $seen{'hilton'});             # 605
ok(! exists $seen{'icon'});             # 606
ok(! exists $seen{'jerky'});            # 607
%seen = ();

@symmetric_difference = $lcau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 608
ok(! exists $seen{'baker'});            # 609
ok(! exists $seen{'camera'});           # 610
ok(! exists $seen{'delta'});            # 611
ok(! exists $seen{'edward'});           # 612
ok(! exists $seen{'fargo'});            # 613
ok(! exists $seen{'golfer'});           # 614
ok(exists $seen{'hilton'});             # 615
ok(! exists $seen{'icon'});             # 616
ok(! exists $seen{'jerky'});            # 617
%seen = ();

$symmetric_difference_ref = $lcau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 618
ok(! exists $seen{'baker'});            # 619
ok(! exists $seen{'camera'});           # 620
ok(! exists $seen{'delta'});            # 621
ok(! exists $seen{'edward'});           # 622
ok(! exists $seen{'fargo'});            # 623
ok(! exists $seen{'golfer'});           # 624
ok(exists $seen{'hilton'});             # 625
ok(! exists $seen{'icon'});             # 626
ok(! exists $seen{'jerky'});            # 627
%seen = ();

@symmetric_difference = $lcau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 628
ok(! exists $seen{'baker'});            # 629
ok(! exists $seen{'camera'});           # 630
ok(! exists $seen{'delta'});            # 631
ok(! exists $seen{'edward'});           # 632
ok(! exists $seen{'fargo'});            # 633
ok(! exists $seen{'golfer'});           # 634
ok(exists $seen{'hilton'});             # 635
ok(! exists $seen{'icon'});             # 636
ok(! exists $seen{'jerky'});            # 637
%seen = ();

$symmetric_difference_ref = $lcau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 638
ok(! exists $seen{'baker'});            # 639
ok(! exists $seen{'camera'});           # 640
ok(! exists $seen{'delta'});            # 641
ok(! exists $seen{'edward'});           # 642
ok(! exists $seen{'fargo'});            # 643
ok(! exists $seen{'golfer'});           # 644
ok(exists $seen{'hilton'});             # 645
ok(! exists $seen{'icon'});             # 646
ok(! exists $seen{'jerky'});            # 647
%seen = ();

@symmetric_difference = $lcau->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 648
ok(! exists $seen{'baker'});            # 649
ok(! exists $seen{'camera'});           # 650
ok(! exists $seen{'delta'});            # 651
ok(! exists $seen{'edward'});           # 652
ok(! exists $seen{'fargo'});            # 653
ok(! exists $seen{'golfer'});           # 654
ok(exists $seen{'hilton'});             # 655
ok(! exists $seen{'icon'});             # 656
ok(! exists $seen{'jerky'});            # 657
%seen = ();

$symmetric_difference_ref = $lcau->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 658
ok(! exists $seen{'baker'});            # 659
ok(! exists $seen{'camera'});           # 660
ok(! exists $seen{'delta'});            # 661
ok(! exists $seen{'edward'});           # 662
ok(! exists $seen{'fargo'});            # 663
ok(! exists $seen{'golfer'});           # 664
ok(exists $seen{'hilton'});             # 665
ok(! exists $seen{'icon'});             # 666
ok(! exists $seen{'jerky'});            # 667
%seen = ();

@symmetric_difference = $lcau->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 668
ok(! exists $seen{'baker'});            # 669
ok(! exists $seen{'camera'});           # 670
ok(! exists $seen{'delta'});            # 671
ok(! exists $seen{'edward'});           # 672
ok(! exists $seen{'fargo'});            # 673
ok(! exists $seen{'golfer'});           # 674
ok(exists $seen{'hilton'});             # 675
ok(! exists $seen{'icon'});             # 676
ok(! exists $seen{'jerky'});            # 677
%seen = ();

$symmetric_difference_ref = $lcau->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 678
ok(! exists $seen{'baker'});            # 679
ok(! exists $seen{'camera'});           # 680
ok(! exists $seen{'delta'});            # 681
ok(! exists $seen{'edward'});           # 682
ok(! exists $seen{'fargo'});            # 683
ok(! exists $seen{'golfer'});           # 684
ok(exists $seen{'hilton'});             # 685
ok(! exists $seen{'icon'});             # 686
ok(! exists $seen{'jerky'});            # 687
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @nonintersection = $lcau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 688
ok(! exists $seen{'baker'});            # 689
ok(! exists $seen{'camera'});           # 690
ok(! exists $seen{'delta'});            # 691
ok(! exists $seen{'edward'});           # 692
ok(! exists $seen{'fargo'});            # 693
ok(! exists $seen{'golfer'});           # 694
ok(exists $seen{'hilton'});             # 695
ok(! exists $seen{'icon'});             # 696
ok(! exists $seen{'jerky'});            # 697
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $nonintersection_ref = $lcau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 698
ok(! exists $seen{'baker'});            # 699
ok(! exists $seen{'camera'});           # 700
ok(! exists $seen{'delta'});            # 701
ok(! exists $seen{'edward'});           # 702
ok(! exists $seen{'fargo'});            # 703
ok(! exists $seen{'golfer'});           # 704
ok(exists $seen{'hilton'});             # 705
ok(! exists $seen{'icon'});             # 706
ok(! exists $seen{'jerky'});            # 707
%seen = ();

@bag = $lcau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 708
ok($seen{'baker'} == 2);                # 709
ok($seen{'camera'} == 2);               # 710
ok($seen{'delta'} == 3);                # 711
ok($seen{'edward'} == 2);               # 712
ok($seen{'fargo'} == 2);                # 713
ok($seen{'golfer'} == 2);               # 714
ok($seen{'hilton'} == 1);               # 715
ok(! exists $seen{'icon'});             # 716
ok(! exists $seen{'jerky'});            # 717
%seen = ();

$bag_ref = $lcau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 718
ok($seen{'baker'} == 2);                # 719
ok($seen{'camera'} == 2);               # 720
ok($seen{'delta'} == 3);                # 721
ok($seen{'edward'} == 2);               # 722
ok($seen{'fargo'} == 2);                # 723
ok($seen{'golfer'} == 2);               # 724
ok($seen{'hilton'} == 1);               # 725
ok(! exists $seen{'icon'});             # 726
ok(! exists $seen{'jerky'});            # 727
%seen = ();

$LR = $lcau->is_LsubsetR;
ok(! $LR);                              # 728

$LR = $lcau->is_AsubsetB;
ok(! $LR);                              # 729

$RL = $lcau->is_RsubsetL;
ok(! $RL);                              # 730

$RL = $lcau->is_BsubsetA;
ok(! $RL);                              # 731

$eqv = $lcau->is_LequivalentR;
ok(! $eqv);                             # 732

$eqv = $lcau->is_LeqvlntR;
ok(! $eqv);                             # 733

$disj = $lcau->is_LdisjointR;
ok(! $disj);                            # 734

$return = $lcau->print_subset_chart;
ok($return);                            # 735

$return = $lcau->print_equivalence_chart;
ok($return);                            # 736

@memb_arr = $lcau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 737

@memb_arr = $lcau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 738

@memb_arr = $lcau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 739

@memb_arr = $lcau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 740

@memb_arr = $lcau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 741

@memb_arr = $lcau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 742

@memb_arr = $lcau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 743

@memb_arr = $lcau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 744

@memb_arr = $lcau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 745

@memb_arr = $lcau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 746

@memb_arr = $lcau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 747

$memb_arr_ref = $lcau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 748

$memb_arr_ref = $lcau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 749

$memb_arr_ref = $lcau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 750

$memb_arr_ref = $lcau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 751

$memb_arr_ref = $lcau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 752

$memb_arr_ref = $lcau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 753

$memb_arr_ref = $lcau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 754

$memb_arr_ref = $lcau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 755

$memb_arr_ref = $lcau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 756

$memb_arr_ref = $lcau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 757

$memb_arr_ref = $lcau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 758

$memb_hash_ref = $lcau->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 759
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 760
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 761
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 762
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 763
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 764
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 765
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 766
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 767
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 768
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 769

ok($lcau->is_member_any('abel'));       # 770
ok($lcau->is_member_any('baker'));      # 771
ok($lcau->is_member_any('camera'));     # 772
ok($lcau->is_member_any('delta'));      # 773
ok($lcau->is_member_any('edward'));     # 774
ok($lcau->is_member_any('fargo'));      # 775
ok($lcau->is_member_any('golfer'));     # 776
ok($lcau->is_member_any('hilton'));     # 777
ok(! $lcau->is_member_any('icon' ));    # 778
ok(! $lcau->is_member_any('jerky'));    # 779
ok(! $lcau->is_member_any('zebra'));    # 780

$memb_hash_ref = $lcau->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 781
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 782
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 783
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 784
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 785
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 786
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 787
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 788
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 789
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 790
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 791

$vers = $lcau->get_version;
ok($vers);                              # 792

my $lcau_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a2, \@a3] } );
ok($lcau_s);                            # 793

$LR = $lcau_s->is_LsubsetR;
ok(! $LR);                              # 794

$LR = $lcau_s->is_AsubsetB;
ok(! $LR);                              # 795

$RL = $lcau_s->is_RsubsetL;
ok($RL);                                # 796

$RL = $lcau_s->is_BsubsetA;
ok($RL);                                # 797

$eqv = $lcau_s->is_LequivalentR;
ok(! $eqv);                             # 798

$eqv = $lcau_s->is_LeqvlntR;
ok(! $eqv);                             # 799

$disj = $lcau_s->is_LdisjointR;
ok(! $disj);                            # 800

my $lcau_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a3, \@a4] } );
ok($lcau_e);                            # 801

$eqv = $lcau_e->is_LequivalentR;
ok($eqv);                               # 802

$eqv = $lcau_e->is_LeqvlntR;
ok($eqv);                               # 803

$disj = $lcau_e->is_LdisjointR;
ok(! $disj);                            # 804

my $lcau_dj  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a4, \@a8] } );

ok($lcau_dj);                           # 805

ok(0 == $lcau_dj->get_intersection);    # 806
ok(0 == scalar(@{$lcau_dj->get_intersection_ref}));# 807
$disj = $lcau_dj->is_LdisjointR;
ok($disj);                              # 808

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcaun   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1] } );
ok($lcaun);                             # 809

my $lcaun_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a2, \@a3] } );
ok($lcaun_s);                           # 810

my $lcaun_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a3, \@a4] } );
ok($lcaun_e);                           # 811

my $lcaccun   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1] } );
ok($lcaccun);                           # 812

my $lcaccun_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a2, \@a3] } );
ok($lcaccun_s);                         # 813

my $lcaccun_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a3, \@a4] } );
ok($lcaccun_e);                         # 814

my $lcaccu   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1] } );
ok($lcaccu);                            # 815

my $lcaccu_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a2, \@a3] } );
ok($lcaccu_s);                          # 816

my $lcaccu_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a3, \@a4] } );
ok($lcaccu_e);                          # 817

########## BELOW:  Test for bad arguments to constructor ##########

my ($lca_bad);
my %h5 = (
    golfer   => 1,
    lambda   => 0,
);

eval { $lca_bad = List::Compare->new( { accelerated => 1, lists => [\@a0, \%h5] } ) };
ok(ok_capture_error($@));               # 818

eval { $lca_bad = List::Compare->new( { accelerated => 1, lists => [\%h5, \@a0] } ) };
ok(ok_capture_error($@));               # 819


