# 09_multaccel.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
1004;
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

my $lcma   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcma);                              # 2

@union = $lcma->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 3
ok(exists $seen{'baker'});              # 4
ok(exists $seen{'camera'});             # 5
ok(exists $seen{'delta'});              # 6
ok(exists $seen{'edward'});             # 7
ok(exists $seen{'fargo'});              # 8
ok(exists $seen{'golfer'});             # 9
ok(exists $seen{'hilton'});             # 10
ok(exists $seen{'icon'});               # 11
ok(exists $seen{'jerky'});              # 12
%seen = ();

$union_ref = $lcma->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 13
ok(exists $seen{'baker'});              # 14
ok(exists $seen{'camera'});             # 15
ok(exists $seen{'delta'});              # 16
ok(exists $seen{'edward'});             # 17
ok(exists $seen{'fargo'});              # 18
ok(exists $seen{'golfer'});             # 19
ok(exists $seen{'hilton'});             # 20
ok(exists $seen{'icon'});               # 21
ok(exists $seen{'jerky'});              # 22
%seen = ();

@shared = $lcma->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 23
ok(exists $seen{'baker'});              # 24
ok(exists $seen{'camera'});             # 25
ok(exists $seen{'delta'});              # 26
ok(exists $seen{'edward'});             # 27
ok(exists $seen{'fargo'});              # 28
ok(exists $seen{'golfer'});             # 29
ok(exists $seen{'hilton'});             # 30
ok(exists $seen{'icon'});               # 31
ok(! exists $seen{'jerky'});            # 32
%seen = ();

$shared_ref = $lcma->get_shared_ref;
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 33
ok(exists $seen{'baker'});              # 34
ok(exists $seen{'camera'});             # 35
ok(exists $seen{'delta'});              # 36
ok(exists $seen{'edward'});             # 37
ok(exists $seen{'fargo'});              # 38
ok(exists $seen{'golfer'});             # 39
ok(exists $seen{'hilton'});             # 40
ok(exists $seen{'icon'});               # 41
ok(! exists $seen{'jerky'});            # 42
%seen = ();

@intersection = $lcma->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 43
ok(! exists $seen{'baker'});            # 44
ok(! exists $seen{'camera'});           # 45
ok(! exists $seen{'delta'});            # 46
ok(! exists $seen{'edward'});           # 47
ok(exists $seen{'fargo'});              # 48
ok(exists $seen{'golfer'});             # 49
ok(! exists $seen{'hilton'});           # 50
ok(! exists $seen{'icon'});             # 51
ok(! exists $seen{'jerky'});            # 52
%seen = ();

$intersection_ref = $lcma->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 53
ok(! exists $seen{'baker'});            # 54
ok(! exists $seen{'camera'});           # 55
ok(! exists $seen{'delta'});            # 56
ok(! exists $seen{'edward'});           # 57
ok(exists $seen{'fargo'});              # 58
ok(exists $seen{'golfer'});             # 59
ok(! exists $seen{'hilton'});           # 60
ok(! exists $seen{'icon'});             # 61
ok(! exists $seen{'jerky'});            # 62
%seen = ();

@unique = $lcma->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 63
ok(! exists $seen{'baker'});            # 64
ok(! exists $seen{'camera'});           # 65
ok(! exists $seen{'delta'});            # 66
ok(! exists $seen{'edward'});           # 67
ok(! exists $seen{'fargo'});            # 68
ok(! exists $seen{'golfer'});           # 69
ok(! exists $seen{'hilton'});           # 70
ok(! exists $seen{'icon'});             # 71
ok(exists $seen{'jerky'});              # 72
%seen = ();

$unique_ref = $lcma->get_unique_ref(2);
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 73
ok(! exists $seen{'baker'});            # 74
ok(! exists $seen{'camera'});           # 75
ok(! exists $seen{'delta'});            # 76
ok(! exists $seen{'edward'});           # 77
ok(! exists $seen{'fargo'});            # 78
ok(! exists $seen{'golfer'});           # 79
ok(! exists $seen{'hilton'});           # 80
ok(! exists $seen{'icon'});             # 81
ok(exists $seen{'jerky'});              # 82
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcma->get_Lonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 83
ok(! exists $seen{'baker'});            # 84
ok(! exists $seen{'camera'});           # 85
ok(! exists $seen{'delta'});            # 86
ok(! exists $seen{'edward'});           # 87
ok(! exists $seen{'fargo'});            # 88
ok(! exists $seen{'golfer'});           # 89
ok(! exists $seen{'hilton'});           # 90
ok(! exists $seen{'icon'});             # 91
ok(exists $seen{'jerky'});              # 92
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcma->get_Aonly(2);
}
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 93
ok(! exists $seen{'baker'});            # 94
ok(! exists $seen{'camera'});           # 95
ok(! exists $seen{'delta'});            # 96
ok(! exists $seen{'edward'});           # 97
ok(! exists $seen{'fargo'});            # 98
ok(! exists $seen{'golfer'});           # 99
ok(! exists $seen{'hilton'});           # 100
ok(! exists $seen{'icon'});             # 101
ok(exists $seen{'jerky'});              # 102
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcma->get_Aonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 103
ok(! exists $seen{'baker'});            # 104
ok(! exists $seen{'camera'});           # 105
ok(! exists $seen{'delta'});            # 106
ok(! exists $seen{'edward'});           # 107
ok(! exists $seen{'fargo'});            # 108
ok(! exists $seen{'golfer'});           # 109
ok(! exists $seen{'hilton'});           # 110
ok(! exists $seen{'icon'});             # 111
ok(exists $seen{'jerky'});              # 112
%seen = ();

@unique = $lcma->get_unique;
$seen{$_}++ foreach (@unique);
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

$unique_ref = $lcma->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcma->get_Lonly;
}
$seen{$_}++ foreach (@unique);
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

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcma->get_Lonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 143
ok(! exists $seen{'baker'});            # 144
ok(! exists $seen{'camera'});           # 145
ok(! exists $seen{'delta'});            # 146
ok(! exists $seen{'edward'});           # 147
ok(! exists $seen{'fargo'});            # 148
ok(! exists $seen{'golfer'});           # 149
ok(! exists $seen{'hilton'});           # 150
ok(! exists $seen{'icon'});             # 151
ok(! exists $seen{'jerky'});            # 152
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcma->get_Aonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 153
ok(! exists $seen{'baker'});            # 154
ok(! exists $seen{'camera'});           # 155
ok(! exists $seen{'delta'});            # 156
ok(! exists $seen{'edward'});           # 157
ok(! exists $seen{'fargo'});            # 158
ok(! exists $seen{'golfer'});           # 159
ok(! exists $seen{'hilton'});           # 160
ok(! exists $seen{'icon'});             # 161
ok(! exists $seen{'jerky'});            # 162
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcma->get_Aonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 163
ok(! exists $seen{'baker'});            # 164
ok(! exists $seen{'camera'});           # 165
ok(! exists $seen{'delta'});            # 166
ok(! exists $seen{'edward'});           # 167
ok(! exists $seen{'fargo'});            # 168
ok(! exists $seen{'golfer'});           # 169
ok(! exists $seen{'hilton'});           # 170
ok(! exists $seen{'icon'});             # 171
ok(! exists $seen{'jerky'});            # 172
%seen = ();

@complement = $lcma->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 173
ok(! exists $seen{'baker'});            # 174
ok(! exists $seen{'camera'});           # 175
ok(! exists $seen{'delta'});            # 176
ok(! exists $seen{'edward'});           # 177
ok(! exists $seen{'fargo'});            # 178
ok(! exists $seen{'golfer'});           # 179
ok(! exists $seen{'hilton'});           # 180
ok(exists $seen{'icon'});               # 181
ok(exists $seen{'jerky'});              # 182
%seen = ();

$complement_ref = $lcma->get_complement_ref(1);
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 183
ok(! exists $seen{'baker'});            # 184
ok(! exists $seen{'camera'});           # 185
ok(! exists $seen{'delta'});            # 186
ok(! exists $seen{'edward'});           # 187
ok(! exists $seen{'fargo'});            # 188
ok(! exists $seen{'golfer'});           # 189
ok(! exists $seen{'hilton'});           # 190
ok(exists $seen{'icon'});               # 191
ok(exists $seen{'jerky'});              # 192
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcma->get_Ronly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 193
ok(! exists $seen{'baker'});            # 194
ok(! exists $seen{'camera'});           # 195
ok(! exists $seen{'delta'});            # 196
ok(! exists $seen{'edward'});           # 197
ok(! exists $seen{'fargo'});            # 198
ok(! exists $seen{'golfer'});           # 199
ok(! exists $seen{'hilton'});           # 200
ok(exists $seen{'icon'});               # 201
ok(exists $seen{'jerky'});              # 202
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcma->get_Ronly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 203
ok(! exists $seen{'baker'});            # 204
ok(! exists $seen{'camera'});           # 205
ok(! exists $seen{'delta'});            # 206
ok(! exists $seen{'edward'});           # 207
ok(! exists $seen{'fargo'});            # 208
ok(! exists $seen{'golfer'});           # 209
ok(! exists $seen{'hilton'});           # 210
ok(exists $seen{'icon'});               # 211
ok(exists $seen{'jerky'});              # 212
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcma->get_Bonly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 213
ok(! exists $seen{'baker'});            # 214
ok(! exists $seen{'camera'});           # 215
ok(! exists $seen{'delta'});            # 216
ok(! exists $seen{'edward'});           # 217
ok(! exists $seen{'fargo'});            # 218
ok(! exists $seen{'golfer'});           # 219
ok(! exists $seen{'hilton'});           # 220
ok(exists $seen{'icon'});               # 221
ok(exists $seen{'jerky'});              # 222
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcma->get_Bonly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 223
ok(! exists $seen{'baker'});            # 224
ok(! exists $seen{'camera'});           # 225
ok(! exists $seen{'delta'});            # 226
ok(! exists $seen{'edward'});           # 227
ok(! exists $seen{'fargo'});            # 228
ok(! exists $seen{'golfer'});           # 229
ok(! exists $seen{'hilton'});           # 230
ok(exists $seen{'icon'});               # 231
ok(exists $seen{'jerky'});              # 232
%seen = ();

@complement = $lcma->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 233
ok(! exists $seen{'baker'});            # 234
ok(! exists $seen{'camera'});           # 235
ok(! exists $seen{'delta'});            # 236
ok(! exists $seen{'edward'});           # 237
ok(! exists $seen{'fargo'});            # 238
ok(! exists $seen{'golfer'});           # 239
ok(exists $seen{'hilton'});             # 240
ok(exists $seen{'icon'});               # 241
ok(exists $seen{'jerky'});              # 242
%seen = ();

$complement_ref = $lcma->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 243
ok(! exists $seen{'baker'});            # 244
ok(! exists $seen{'camera'});           # 245
ok(! exists $seen{'delta'});            # 246
ok(! exists $seen{'edward'});           # 247
ok(! exists $seen{'fargo'});            # 248
ok(! exists $seen{'golfer'});           # 249
ok(exists $seen{'hilton'});             # 250
ok(exists $seen{'icon'});               # 251
ok(exists $seen{'jerky'});              # 252
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcma->get_Ronly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 253
ok(! exists $seen{'baker'});            # 254
ok(! exists $seen{'camera'});           # 255
ok(! exists $seen{'delta'});            # 256
ok(! exists $seen{'edward'});           # 257
ok(! exists $seen{'fargo'});            # 258
ok(! exists $seen{'golfer'});           # 259
ok(exists $seen{'hilton'});             # 260
ok(exists $seen{'icon'});               # 261
ok(exists $seen{'jerky'});              # 262
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcma->get_Ronly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 263
ok(! exists $seen{'baker'});            # 264
ok(! exists $seen{'camera'});           # 265
ok(! exists $seen{'delta'});            # 266
ok(! exists $seen{'edward'});           # 267
ok(! exists $seen{'fargo'});            # 268
ok(! exists $seen{'golfer'});           # 269
ok(exists $seen{'hilton'});             # 270
ok(exists $seen{'icon'});               # 271
ok(exists $seen{'jerky'});              # 272
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcma->get_Bonly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 273
ok(! exists $seen{'baker'});            # 274
ok(! exists $seen{'camera'});           # 275
ok(! exists $seen{'delta'});            # 276
ok(! exists $seen{'edward'});           # 277
ok(! exists $seen{'fargo'});            # 278
ok(! exists $seen{'golfer'});           # 279
ok(exists $seen{'hilton'});             # 280
ok(exists $seen{'icon'});               # 281
ok(exists $seen{'jerky'});              # 282
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcma->get_Bonly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 283
ok(! exists $seen{'baker'});            # 284
ok(! exists $seen{'camera'});           # 285
ok(! exists $seen{'delta'});            # 286
ok(! exists $seen{'edward'});           # 287
ok(! exists $seen{'fargo'});            # 288
ok(! exists $seen{'golfer'});           # 289
ok(exists $seen{'hilton'});             # 290
ok(exists $seen{'icon'});               # 291
ok(exists $seen{'jerky'});              # 292
%seen = ();

@symmetric_difference = $lcma->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 293
ok(! exists $seen{'baker'});            # 294
ok(! exists $seen{'camera'});           # 295
ok(! exists $seen{'delta'});            # 296
ok(! exists $seen{'edward'});           # 297
ok(! exists $seen{'fargo'});            # 298
ok(! exists $seen{'golfer'});           # 299
ok(! exists $seen{'hilton'});           # 300
ok(! exists $seen{'icon'});             # 301
ok(exists $seen{'jerky'});              # 302
%seen = ();

$symmetric_difference_ref = $lcma->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 303
ok(! exists $seen{'baker'});            # 304
ok(! exists $seen{'camera'});           # 305
ok(! exists $seen{'delta'});            # 306
ok(! exists $seen{'edward'});           # 307
ok(! exists $seen{'fargo'});            # 308
ok(! exists $seen{'golfer'});           # 309
ok(! exists $seen{'hilton'});           # 310
ok(! exists $seen{'icon'});             # 311
ok(exists $seen{'jerky'});              # 312
%seen = ();

@symmetric_difference = $lcma->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 313
ok(! exists $seen{'baker'});            # 314
ok(! exists $seen{'camera'});           # 315
ok(! exists $seen{'delta'});            # 316
ok(! exists $seen{'edward'});           # 317
ok(! exists $seen{'fargo'});            # 318
ok(! exists $seen{'golfer'});           # 319
ok(! exists $seen{'hilton'});           # 320
ok(! exists $seen{'icon'});             # 321
ok(exists $seen{'jerky'});              # 322
%seen = ();

$symmetric_difference_ref = $lcma->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 323
ok(! exists $seen{'baker'});            # 324
ok(! exists $seen{'camera'});           # 325
ok(! exists $seen{'delta'});            # 326
ok(! exists $seen{'edward'});           # 327
ok(! exists $seen{'fargo'});            # 328
ok(! exists $seen{'golfer'});           # 329
ok(! exists $seen{'hilton'});           # 330
ok(! exists $seen{'icon'});             # 331
ok(exists $seen{'jerky'});              # 332
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@symmetric_difference = $lcma->get_LorRonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 333
ok(! exists $seen{'baker'});            # 334
ok(! exists $seen{'camera'});           # 335
ok(! exists $seen{'delta'});            # 336
ok(! exists $seen{'edward'});           # 337
ok(! exists $seen{'fargo'});            # 338
ok(! exists $seen{'golfer'});           # 339
ok(! exists $seen{'hilton'});           # 340
ok(! exists $seen{'icon'});             # 341
ok(exists $seen{'jerky'});              # 342
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$symmetric_difference_ref = $lcma->get_LorRonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 343
ok(! exists $seen{'baker'});            # 344
ok(! exists $seen{'camera'});           # 345
ok(! exists $seen{'delta'});            # 346
ok(! exists $seen{'edward'});           # 347
ok(! exists $seen{'fargo'});            # 348
ok(! exists $seen{'golfer'});           # 349
ok(! exists $seen{'hilton'});           # 350
ok(! exists $seen{'icon'});             # 351
ok(exists $seen{'jerky'});              # 352
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@symmetric_difference = $lcma->get_AorBonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 353
ok(! exists $seen{'baker'});            # 354
ok(! exists $seen{'camera'});           # 355
ok(! exists $seen{'delta'});            # 356
ok(! exists $seen{'edward'});           # 357
ok(! exists $seen{'fargo'});            # 358
ok(! exists $seen{'golfer'});           # 359
ok(! exists $seen{'hilton'});           # 360
ok(! exists $seen{'icon'});             # 361
ok(exists $seen{'jerky'});              # 362
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$symmetric_difference_ref = $lcma->get_AorBonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 363
ok(! exists $seen{'baker'});            # 364
ok(! exists $seen{'camera'});           # 365
ok(! exists $seen{'delta'});            # 366
ok(! exists $seen{'edward'});           # 367
ok(! exists $seen{'fargo'});            # 368
ok(! exists $seen{'golfer'});           # 369
ok(! exists $seen{'hilton'});           # 370
ok(! exists $seen{'icon'});             # 371
ok(exists $seen{'jerky'});              # 372
%seen = ();

@nonintersection = $lcma->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 373
ok(exists $seen{'baker'});              # 374
ok(exists $seen{'camera'});             # 375
ok(exists $seen{'delta'});              # 376
ok(exists $seen{'edward'});             # 377
ok(! exists $seen{'fargo'});            # 378
ok(! exists $seen{'golfer'});           # 379
ok(exists $seen{'hilton'});             # 380
ok(exists $seen{'icon'});               # 381
ok(exists $seen{'jerky'});              # 382
%seen = ();

$nonintersection_ref = $lcma->get_nonintersection_ref;
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 383
ok(exists $seen{'baker'});              # 384
ok(exists $seen{'camera'});             # 385
ok(exists $seen{'delta'});              # 386
ok(exists $seen{'edward'});             # 387
ok(! exists $seen{'fargo'});            # 388
ok(! exists $seen{'golfer'});           # 389
ok(exists $seen{'hilton'});             # 390
ok(exists $seen{'icon'});               # 391
ok(exists $seen{'jerky'});              # 392
%seen = ();

@bag = $lcma->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 393
ok($seen{'baker'} == 2);                # 394
ok($seen{'camera'} == 2);               # 395
ok($seen{'delta'} == 3);                # 396
ok($seen{'edward'} == 2);               # 397
ok($seen{'fargo'} == 6);                # 398
ok($seen{'golfer'} == 5);               # 399
ok($seen{'hilton'} == 4);               # 400
ok($seen{'icon'} == 5);                 # 401
ok($seen{'jerky'} == 1);                # 402
%seen = ();

$bag_ref = $lcma->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 403
ok($seen{'baker'} == 2);                # 404
ok($seen{'camera'} == 2);               # 405
ok($seen{'delta'} == 3);                # 406
ok($seen{'edward'} == 2);               # 407
ok($seen{'fargo'} == 6);                # 408
ok($seen{'golfer'} == 5);               # 409
ok($seen{'hilton'} == 4);               # 410
ok($seen{'icon'} == 5);                 # 411
ok($seen{'jerky'} == 1);                # 412
%seen = ();

$LR = $lcma->is_LsubsetR(3,2);
ok($LR);                                # 413

$LR = $lcma->is_AsubsetB(3,2);
ok($LR);                                # 414

$LR = $lcma->is_LsubsetR(2,3);
ok(! $LR);                              # 415

$LR = $lcma->is_AsubsetB(2,3);
ok(! $LR);                              # 416

$LR = $lcma->is_LsubsetR;
ok(! $LR);                              # 417

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcma->is_RsubsetL;
}
ok(! $RL);                              # 418

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcma->is_BsubsetA;
}
ok(! $RL);                              # 419

$eqv = $lcma->is_LequivalentR(3,4);
ok($eqv);                               # 420

$eqv = $lcma->is_LeqvlntR(3,4);
ok($eqv);                               # 421

$eqv = $lcma->is_LequivalentR(2,4);
ok(! $eqv);                             # 422

$return = $lcma->print_subset_chart;
ok($return);                            # 423

$return = $lcma->print_equivalence_chart;
ok($return);                            # 424

@memb_arr = $lcma->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 425

@memb_arr = $lcma->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 426

@memb_arr = $lcma->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 427

@memb_arr = $lcma->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 428

@memb_arr = $lcma->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 429

@memb_arr = $lcma->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 430

@memb_arr = $lcma->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 431

@memb_arr = $lcma->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 432

@memb_arr = $lcma->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 433

@memb_arr = $lcma->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 434

@memb_arr = $lcma->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 435


$memb_arr_ref = $lcma->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 436

$memb_arr_ref = $lcma->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 437

$memb_arr_ref = $lcma->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 438

$memb_arr_ref = $lcma->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 439

$memb_arr_ref = $lcma->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 440

$memb_arr_ref = $lcma->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 441

$memb_arr_ref = $lcma->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 442

$memb_arr_ref = $lcma->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 443

$memb_arr_ref = $lcma->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 444

$memb_arr_ref = $lcma->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 445

$memb_arr_ref = $lcma->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 446


$memb_hash_ref = $lcma->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 447
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 448
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 449
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 450
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 451
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 452
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 453
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 454
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 455
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 456
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 457

$memb_hash_ref = $lcma->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 458
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 459
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 460
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 461
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 462
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 463
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 464
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 465
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 466
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 467
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 468

ok($lcma->is_member_any('abel'));       # 469
ok($lcma->is_member_any('baker'));      # 470
ok($lcma->is_member_any('camera'));     # 471
ok($lcma->is_member_any('delta'));      # 472
ok($lcma->is_member_any('edward'));     # 473
ok($lcma->is_member_any('fargo'));      # 474
ok($lcma->is_member_any('golfer'));     # 475
ok($lcma->is_member_any('hilton'));     # 476
ok($lcma->is_member_any('icon' ));      # 477
ok($lcma->is_member_any('jerky'));      # 478
ok(! $lcma->is_member_any('zebra'));    # 479

$memb_hash_ref = $lcma->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 480
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 481
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 482
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 483
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 484
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 485
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 486
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 487
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 488
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 489
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 490

$memb_hash_ref = $lcma->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 491
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 492
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 493
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 494
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 495
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 496
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 497
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 498
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 499
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 500
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 501

$vers = $lcma->get_version;
ok($vers);                              # 502

########## BELOW:  Tests for '-u' option ##########

my $lcmau   = List::Compare->new('-u', \@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcmau);                             # 503

@union = $lcmau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 504
ok(exists $seen{'baker'});              # 505
ok(exists $seen{'camera'});             # 506
ok(exists $seen{'delta'});              # 507
ok(exists $seen{'edward'});             # 508
ok(exists $seen{'fargo'});              # 509
ok(exists $seen{'golfer'});             # 510
ok(exists $seen{'hilton'});             # 511
ok(exists $seen{'icon'});               # 512
ok(exists $seen{'jerky'});              # 513
%seen = ();

$union_ref = $lcmau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 514
ok(exists $seen{'baker'});              # 515
ok(exists $seen{'camera'});             # 516
ok(exists $seen{'delta'});              # 517
ok(exists $seen{'edward'});             # 518
ok(exists $seen{'fargo'});              # 519
ok(exists $seen{'golfer'});             # 520
ok(exists $seen{'hilton'});             # 521
ok(exists $seen{'icon'});               # 522
ok(exists $seen{'jerky'});              # 523
%seen = ();

@shared = $lcmau->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 524
ok(exists $seen{'baker'});              # 525
ok(exists $seen{'camera'});             # 526
ok(exists $seen{'delta'});              # 527
ok(exists $seen{'edward'});             # 528
ok(exists $seen{'fargo'});              # 529
ok(exists $seen{'golfer'});             # 530
ok(exists $seen{'hilton'});             # 531
ok(exists $seen{'icon'});               # 532
ok(! exists $seen{'jerky'});            # 533
%seen = ();

$shared_ref = $lcmau->get_shared_ref;
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 534
ok(exists $seen{'baker'});              # 535
ok(exists $seen{'camera'});             # 536
ok(exists $seen{'delta'});              # 537
ok(exists $seen{'edward'});             # 538
ok(exists $seen{'fargo'});              # 539
ok(exists $seen{'golfer'});             # 540
ok(exists $seen{'hilton'});             # 541
ok(exists $seen{'icon'});               # 542
ok(! exists $seen{'jerky'});            # 543
%seen = ();

@intersection = $lcmau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 544
ok(! exists $seen{'baker'});            # 545
ok(! exists $seen{'camera'});           # 546
ok(! exists $seen{'delta'});            # 547
ok(! exists $seen{'edward'});           # 548
ok(exists $seen{'fargo'});              # 549
ok(exists $seen{'golfer'});             # 550
ok(! exists $seen{'hilton'});           # 551
ok(! exists $seen{'icon'});             # 552
ok(! exists $seen{'jerky'});            # 553
%seen = ();

$intersection_ref = $lcmau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 554
ok(! exists $seen{'baker'});            # 555
ok(! exists $seen{'camera'});           # 556
ok(! exists $seen{'delta'});            # 557
ok(! exists $seen{'edward'});           # 558
ok(exists $seen{'fargo'});              # 559
ok(exists $seen{'golfer'});             # 560
ok(! exists $seen{'hilton'});           # 561
ok(! exists $seen{'icon'});             # 562
ok(! exists $seen{'jerky'});            # 563
%seen = ();

@unique = $lcmau->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 564
ok(! exists $seen{'baker'});            # 565
ok(! exists $seen{'camera'});           # 566
ok(! exists $seen{'delta'});            # 567
ok(! exists $seen{'edward'});           # 568
ok(! exists $seen{'fargo'});            # 569
ok(! exists $seen{'golfer'});           # 570
ok(! exists $seen{'hilton'});           # 571
ok(! exists $seen{'icon'});             # 572
ok(exists $seen{'jerky'});              # 573
%seen = ();

$unique_ref = $lcmau->get_unique_ref(2);
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 574
ok(! exists $seen{'baker'});            # 575
ok(! exists $seen{'camera'});           # 576
ok(! exists $seen{'delta'});            # 577
ok(! exists $seen{'edward'});           # 578
ok(! exists $seen{'fargo'});            # 579
ok(! exists $seen{'golfer'});           # 580
ok(! exists $seen{'hilton'});           # 581
ok(! exists $seen{'icon'});             # 582
ok(exists $seen{'jerky'});              # 583
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmau->get_Lonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 584
ok(! exists $seen{'baker'});            # 585
ok(! exists $seen{'camera'});           # 586
ok(! exists $seen{'delta'});            # 587
ok(! exists $seen{'edward'});           # 588
ok(! exists $seen{'fargo'});            # 589
ok(! exists $seen{'golfer'});           # 590
ok(! exists $seen{'hilton'});           # 591
ok(! exists $seen{'icon'});             # 592
ok(exists $seen{'jerky'});              # 593
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcmau->get_Aonly(2);
}
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 594
ok(! exists $seen{'baker'});            # 595
ok(! exists $seen{'camera'});           # 596
ok(! exists $seen{'delta'});            # 597
ok(! exists $seen{'edward'});           # 598
ok(! exists $seen{'fargo'});            # 599
ok(! exists $seen{'golfer'});           # 600
ok(! exists $seen{'hilton'});           # 601
ok(! exists $seen{'icon'});             # 602
ok(exists $seen{'jerky'});              # 603
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmau->get_Aonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 604
ok(! exists $seen{'baker'});            # 605
ok(! exists $seen{'camera'});           # 606
ok(! exists $seen{'delta'});            # 607
ok(! exists $seen{'edward'});           # 608
ok(! exists $seen{'fargo'});            # 609
ok(! exists $seen{'golfer'});           # 610
ok(! exists $seen{'hilton'});           # 611
ok(! exists $seen{'icon'});             # 612
ok(exists $seen{'jerky'});              # 613
%seen = ();

@unique = $lcmau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 614
ok(! exists $seen{'baker'});            # 615
ok(! exists $seen{'camera'});           # 616
ok(! exists $seen{'delta'});            # 617
ok(! exists $seen{'edward'});           # 618
ok(! exists $seen{'fargo'});            # 619
ok(! exists $seen{'golfer'});           # 620
ok(! exists $seen{'hilton'});           # 621
ok(! exists $seen{'icon'});             # 622
ok(! exists $seen{'jerky'});            # 623
%seen = ();

$unique_ref = $lcmau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 624
ok(! exists $seen{'baker'});            # 625
ok(! exists $seen{'camera'});           # 626
ok(! exists $seen{'delta'});            # 627
ok(! exists $seen{'edward'});           # 628
ok(! exists $seen{'fargo'});            # 629
ok(! exists $seen{'golfer'});           # 630
ok(! exists $seen{'hilton'});           # 631
ok(! exists $seen{'icon'});             # 632
ok(! exists $seen{'jerky'});            # 633
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcmau->get_Lonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 634
ok(! exists $seen{'baker'});            # 635
ok(! exists $seen{'camera'});           # 636
ok(! exists $seen{'delta'});            # 637
ok(! exists $seen{'edward'});           # 638
ok(! exists $seen{'fargo'});            # 639
ok(! exists $seen{'golfer'});           # 640
ok(! exists $seen{'hilton'});           # 641
ok(! exists $seen{'icon'});             # 642
ok(! exists $seen{'jerky'});            # 643
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmau->get_Lonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 644
ok(! exists $seen{'baker'});            # 645
ok(! exists $seen{'camera'});           # 646
ok(! exists $seen{'delta'});            # 647
ok(! exists $seen{'edward'});           # 648
ok(! exists $seen{'fargo'});            # 649
ok(! exists $seen{'golfer'});           # 650
ok(! exists $seen{'hilton'});           # 651
ok(! exists $seen{'icon'});             # 652
ok(! exists $seen{'jerky'});            # 653
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcmau->get_Aonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 654
ok(! exists $seen{'baker'});            # 655
ok(! exists $seen{'camera'});           # 656
ok(! exists $seen{'delta'});            # 657
ok(! exists $seen{'edward'});           # 658
ok(! exists $seen{'fargo'});            # 659
ok(! exists $seen{'golfer'});           # 660
ok(! exists $seen{'hilton'});           # 661
ok(! exists $seen{'icon'});             # 662
ok(! exists $seen{'jerky'});            # 663
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmau->get_Aonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 664
ok(! exists $seen{'baker'});            # 665
ok(! exists $seen{'camera'});           # 666
ok(! exists $seen{'delta'});            # 667
ok(! exists $seen{'edward'});           # 668
ok(! exists $seen{'fargo'});            # 669
ok(! exists $seen{'golfer'});           # 670
ok(! exists $seen{'hilton'});           # 671
ok(! exists $seen{'icon'});             # 672
ok(! exists $seen{'jerky'});            # 673
%seen = ();

@complement = $lcmau->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 674
ok(! exists $seen{'baker'});            # 675
ok(! exists $seen{'camera'});           # 676
ok(! exists $seen{'delta'});            # 677
ok(! exists $seen{'edward'});           # 678
ok(! exists $seen{'fargo'});            # 679
ok(! exists $seen{'golfer'});           # 680
ok(! exists $seen{'hilton'});           # 681
ok(exists $seen{'icon'});               # 682
ok(exists $seen{'jerky'});              # 683
%seen = ();

$complement_ref = $lcmau->get_complement_ref(1);
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 684
ok(! exists $seen{'baker'});            # 685
ok(! exists $seen{'camera'});           # 686
ok(! exists $seen{'delta'});            # 687
ok(! exists $seen{'edward'});           # 688
ok(! exists $seen{'fargo'});            # 689
ok(! exists $seen{'golfer'});           # 690
ok(! exists $seen{'hilton'});           # 691
ok(exists $seen{'icon'});               # 692
ok(exists $seen{'jerky'});              # 693
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmau->get_Ronly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 694
ok(! exists $seen{'baker'});            # 695
ok(! exists $seen{'camera'});           # 696
ok(! exists $seen{'delta'});            # 697
ok(! exists $seen{'edward'});           # 698
ok(! exists $seen{'fargo'});            # 699
ok(! exists $seen{'golfer'});           # 700
ok(! exists $seen{'hilton'});           # 701
ok(exists $seen{'icon'});               # 702
ok(exists $seen{'jerky'});              # 703
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmau->get_Ronly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 704
ok(! exists $seen{'baker'});            # 705
ok(! exists $seen{'camera'});           # 706
ok(! exists $seen{'delta'});            # 707
ok(! exists $seen{'edward'});           # 708
ok(! exists $seen{'fargo'});            # 709
ok(! exists $seen{'golfer'});           # 710
ok(! exists $seen{'hilton'});           # 711
ok(exists $seen{'icon'});               # 712
ok(exists $seen{'jerky'});              # 713
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmau->get_Bonly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 714
ok(! exists $seen{'baker'});            # 715
ok(! exists $seen{'camera'});           # 716
ok(! exists $seen{'delta'});            # 717
ok(! exists $seen{'edward'});           # 718
ok(! exists $seen{'fargo'});            # 719
ok(! exists $seen{'golfer'});           # 720
ok(! exists $seen{'hilton'});           # 721
ok(exists $seen{'icon'});               # 722
ok(exists $seen{'jerky'});              # 723
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmau->get_Bonly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 724
ok(! exists $seen{'baker'});            # 725
ok(! exists $seen{'camera'});           # 726
ok(! exists $seen{'delta'});            # 727
ok(! exists $seen{'edward'});           # 728
ok(! exists $seen{'fargo'});            # 729
ok(! exists $seen{'golfer'});           # 730
ok(! exists $seen{'hilton'});           # 731
ok(exists $seen{'icon'});               # 732
ok(exists $seen{'jerky'});              # 733
%seen = ();

@complement = $lcmau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 734
ok(! exists $seen{'baker'});            # 735
ok(! exists $seen{'camera'});           # 736
ok(! exists $seen{'delta'});            # 737
ok(! exists $seen{'edward'});           # 738
ok(! exists $seen{'fargo'});            # 739
ok(! exists $seen{'golfer'});           # 740
ok(exists $seen{'hilton'});             # 741
ok(exists $seen{'icon'});               # 742
ok(exists $seen{'jerky'});              # 743
%seen = ();

$complement_ref = $lcmau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 744
ok(! exists $seen{'baker'});            # 745
ok(! exists $seen{'camera'});           # 746
ok(! exists $seen{'delta'});            # 747
ok(! exists $seen{'edward'});           # 748
ok(! exists $seen{'fargo'});            # 749
ok(! exists $seen{'golfer'});           # 750
ok(exists $seen{'hilton'});             # 751
ok(exists $seen{'icon'});               # 752
ok(exists $seen{'jerky'});              # 753
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmau->get_Ronly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 754
ok(! exists $seen{'baker'});            # 755
ok(! exists $seen{'camera'});           # 756
ok(! exists $seen{'delta'});            # 757
ok(! exists $seen{'edward'});           # 758
ok(! exists $seen{'fargo'});            # 759
ok(! exists $seen{'golfer'});           # 760
ok(exists $seen{'hilton'});             # 761
ok(exists $seen{'icon'});               # 762
ok(exists $seen{'jerky'});              # 763
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmau->get_Ronly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 764
ok(! exists $seen{'baker'});            # 765
ok(! exists $seen{'camera'});           # 766
ok(! exists $seen{'delta'});            # 767
ok(! exists $seen{'edward'});           # 768
ok(! exists $seen{'fargo'});            # 769
ok(! exists $seen{'golfer'});           # 770
ok(exists $seen{'hilton'});             # 771
ok(exists $seen{'icon'});               # 772
ok(exists $seen{'jerky'});              # 773
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmau->get_Bonly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 774
ok(! exists $seen{'baker'});            # 775
ok(! exists $seen{'camera'});           # 776
ok(! exists $seen{'delta'});            # 777
ok(! exists $seen{'edward'});           # 778
ok(! exists $seen{'fargo'});            # 779
ok(! exists $seen{'golfer'});           # 780
ok(exists $seen{'hilton'});             # 781
ok(exists $seen{'icon'});               # 782
ok(exists $seen{'jerky'});              # 783
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmau->get_Bonly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 784
ok(! exists $seen{'baker'});            # 785
ok(! exists $seen{'camera'});           # 786
ok(! exists $seen{'delta'});            # 787
ok(! exists $seen{'edward'});           # 788
ok(! exists $seen{'fargo'});            # 789
ok(! exists $seen{'golfer'});           # 790
ok(exists $seen{'hilton'});             # 791
ok(exists $seen{'icon'});               # 792
ok(exists $seen{'jerky'});              # 793
%seen = ();

@symmetric_difference = $lcmau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 794
ok(! exists $seen{'baker'});            # 795
ok(! exists $seen{'camera'});           # 796
ok(! exists $seen{'delta'});            # 797
ok(! exists $seen{'edward'});           # 798
ok(! exists $seen{'fargo'});            # 799
ok(! exists $seen{'golfer'});           # 800
ok(! exists $seen{'hilton'});           # 801
ok(! exists $seen{'icon'});             # 802
ok(exists $seen{'jerky'});              # 803
%seen = ();

$symmetric_difference_ref = $lcmau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 804
ok(! exists $seen{'baker'});            # 805
ok(! exists $seen{'camera'});           # 806
ok(! exists $seen{'delta'});            # 807
ok(! exists $seen{'edward'});           # 808
ok(! exists $seen{'fargo'});            # 809
ok(! exists $seen{'golfer'});           # 810
ok(! exists $seen{'hilton'});           # 811
ok(! exists $seen{'icon'});             # 812
ok(exists $seen{'jerky'});              # 813
%seen = ();

@symmetric_difference = $lcmau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 814
ok(! exists $seen{'baker'});            # 815
ok(! exists $seen{'camera'});           # 816
ok(! exists $seen{'delta'});            # 817
ok(! exists $seen{'edward'});           # 818
ok(! exists $seen{'fargo'});            # 819
ok(! exists $seen{'golfer'});           # 820
ok(! exists $seen{'hilton'});           # 821
ok(! exists $seen{'icon'});             # 822
ok(exists $seen{'jerky'});              # 823
%seen = ();

$symmetric_difference_ref = $lcmau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 824
ok(! exists $seen{'baker'});            # 825
ok(! exists $seen{'camera'});           # 826
ok(! exists $seen{'delta'});            # 827
ok(! exists $seen{'edward'});           # 828
ok(! exists $seen{'fargo'});            # 829
ok(! exists $seen{'golfer'});           # 830
ok(! exists $seen{'hilton'});           # 831
ok(! exists $seen{'icon'});             # 832
ok(exists $seen{'jerky'});              # 833
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@symmetric_difference = $lcmau->get_LorRonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 834
ok(! exists $seen{'baker'});            # 835
ok(! exists $seen{'camera'});           # 836
ok(! exists $seen{'delta'});            # 837
ok(! exists $seen{'edward'});           # 838
ok(! exists $seen{'fargo'});            # 839
ok(! exists $seen{'golfer'});           # 840
ok(! exists $seen{'hilton'});           # 841
ok(! exists $seen{'icon'});             # 842
ok(exists $seen{'jerky'});              # 843
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$symmetric_difference_ref = $lcmau->get_LorRonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 844
ok(! exists $seen{'baker'});            # 845
ok(! exists $seen{'camera'});           # 846
ok(! exists $seen{'delta'});            # 847
ok(! exists $seen{'edward'});           # 848
ok(! exists $seen{'fargo'});            # 849
ok(! exists $seen{'golfer'});           # 850
ok(! exists $seen{'hilton'});           # 851
ok(! exists $seen{'icon'});             # 852
ok(exists $seen{'jerky'});              # 853
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@symmetric_difference = $lcmau->get_AorBonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 854
ok(! exists $seen{'baker'});            # 855
ok(! exists $seen{'camera'});           # 856
ok(! exists $seen{'delta'});            # 857
ok(! exists $seen{'edward'});           # 858
ok(! exists $seen{'fargo'});            # 859
ok(! exists $seen{'golfer'});           # 860
ok(! exists $seen{'hilton'});           # 861
ok(! exists $seen{'icon'});             # 862
ok(exists $seen{'jerky'});              # 863
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$symmetric_difference_ref = $lcmau->get_AorBonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 864
ok(! exists $seen{'baker'});            # 865
ok(! exists $seen{'camera'});           # 866
ok(! exists $seen{'delta'});            # 867
ok(! exists $seen{'edward'});           # 868
ok(! exists $seen{'fargo'});            # 869
ok(! exists $seen{'golfer'});           # 870
ok(! exists $seen{'hilton'});           # 871
ok(! exists $seen{'icon'});             # 872
ok(exists $seen{'jerky'});              # 873
%seen = ();

@nonintersection = $lcmau->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 874
ok(exists $seen{'baker'});              # 875
ok(exists $seen{'camera'});             # 876
ok(exists $seen{'delta'});              # 877
ok(exists $seen{'edward'});             # 878
ok(! exists $seen{'fargo'});            # 879
ok(! exists $seen{'golfer'});           # 880
ok(exists $seen{'hilton'});             # 881
ok(exists $seen{'icon'});               # 882
ok(exists $seen{'jerky'});              # 883
%seen = ();

$nonintersection_ref = $lcmau->get_nonintersection_ref;
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 884
ok(exists $seen{'baker'});              # 885
ok(exists $seen{'camera'});             # 886
ok(exists $seen{'delta'});              # 887
ok(exists $seen{'edward'});             # 888
ok(! exists $seen{'fargo'});            # 889
ok(! exists $seen{'golfer'});           # 890
ok(exists $seen{'hilton'});             # 891
ok(exists $seen{'icon'});               # 892
ok(exists $seen{'jerky'});              # 893
%seen = ();

@bag = $lcmau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 894
ok($seen{'baker'} == 2);                # 895
ok($seen{'camera'} == 2);               # 896
ok($seen{'delta'} == 3);                # 897
ok($seen{'edward'} == 2);               # 898
ok($seen{'fargo'} == 6);                # 899
ok($seen{'golfer'} == 5);               # 900
ok($seen{'hilton'} == 4);               # 901
ok($seen{'icon'} == 5);                 # 902
ok($seen{'jerky'} == 1);                # 903
%seen = ();

$bag_ref = $lcmau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 904
ok($seen{'baker'} == 2);                # 905
ok($seen{'camera'} == 2);               # 906
ok($seen{'delta'} == 3);                # 907
ok($seen{'edward'} == 2);               # 908
ok($seen{'fargo'} == 6);                # 909
ok($seen{'golfer'} == 5);               # 910
ok($seen{'hilton'} == 4);               # 911
ok($seen{'icon'} == 5);                 # 912
ok($seen{'jerky'} == 1);                # 913
%seen = ();

$LR = $lcmau->is_LsubsetR(3,2);
ok($LR);                                # 914

$LR = $lcmau->is_AsubsetB(3,2);
ok($LR);                                # 915

$LR = $lcmau->is_LsubsetR(2,3);
ok(! $LR);                              # 916

$LR = $lcmau->is_AsubsetB(2,3);
ok(! $LR);                              # 917

$LR = $lcmau->is_LsubsetR;
ok(! $LR);                              # 918

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmau->is_RsubsetL;
}
ok(! $RL);                              # 919

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmau->is_BsubsetA;
}
ok(! $RL);                              # 920

$eqv = $lcmau->is_LequivalentR(3,4);
ok($eqv);                               # 921

$eqv = $lcmau->is_LeqvlntR(3,4);
ok($eqv);                               # 922

$eqv = $lcmau->is_LequivalentR(2,4);
ok(! $eqv);                             # 923

$return = $lcmau->print_subset_chart;
ok($return);                            # 924

$return = $lcmau->print_equivalence_chart;
ok($return);                            # 925

@memb_arr = $lcmau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 926

@memb_arr = $lcmau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 927

@memb_arr = $lcmau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 928

@memb_arr = $lcmau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 929

@memb_arr = $lcmau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 930

@memb_arr = $lcmau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 931

@memb_arr = $lcmau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 932

@memb_arr = $lcmau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 933

@memb_arr = $lcmau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 934

@memb_arr = $lcmau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 935

@memb_arr = $lcmau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 936


$memb_arr_ref = $lcmau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 937

$memb_arr_ref = $lcmau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 938

$memb_arr_ref = $lcmau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 939

$memb_arr_ref = $lcmau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 940

$memb_arr_ref = $lcmau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 941

$memb_arr_ref = $lcmau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 942

$memb_arr_ref = $lcmau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 943

$memb_arr_ref = $lcmau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 944

$memb_arr_ref = $lcmau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 945

$memb_arr_ref = $lcmau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 946

$memb_arr_ref = $lcmau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 947


$memb_hash_ref = $lcmau->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 948
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 949
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 950
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 951
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 952
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 953
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 954
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 955
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 956
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 957
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 958

$memb_hash_ref = $lcmau->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 959
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 960
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 961
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 962
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 963
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 964
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 965
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 966
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 967
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 968
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 969


ok($lcmau->is_member_any('abel'));      # 970
ok($lcmau->is_member_any('baker'));     # 971
ok($lcmau->is_member_any('camera'));    # 972
ok($lcmau->is_member_any('delta'));     # 973
ok($lcmau->is_member_any('edward'));    # 974
ok($lcmau->is_member_any('fargo'));     # 975
ok($lcmau->is_member_any('golfer'));    # 976
ok($lcmau->is_member_any('hilton'));    # 977
ok($lcmau->is_member_any('icon' ));     # 978
ok($lcmau->is_member_any('jerky'));     # 979
ok(! $lcmau->is_member_any('zebra'));   # 980

$memb_hash_ref = $lcmau->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 981
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 982
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 983
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 984
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 985
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 986
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 987
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 988
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 989
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 990
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 991

$memb_hash_ref = $lcmau->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 992
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 993
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 994
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 995
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 996
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 997
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 998
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 999
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 1000
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 1001
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 1002

$vers = $lcmau->get_version;
ok($vers);                              # 1003

########## BELOW:  Tests for '--unsorted' option ##########

my $lcmaun   = List::Compare->new('--unsorted', \@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcmaun);                            # 1004

