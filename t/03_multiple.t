# 03_multiple.t # as of 04/25/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
970;
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

my $lcm   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcm);                               # 2

@union = $lcm->get_union;
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

$union_ref = $lcm->get_union_ref;
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

@shared = $lcm->get_shared;
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

$shared_ref = $lcm->get_shared_ref;
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

@intersection = $lcm->get_intersection;
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

$intersection_ref = $lcm->get_intersection_ref;
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

@unique = $lcm->get_unique(2);
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

$unique_ref = $lcm->get_unique_ref(2);
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
    $unique_ref = $lcm->get_Lonly_ref(2);
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
    @unique = $lcm->get_Aonly(2);
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
    $unique_ref = $lcm->get_Aonly_ref(2);
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

@unique = $lcm->get_unique;
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

$unique_ref = $lcm->get_unique_ref;
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
    @unique = $lcm->get_Lonly;
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
    $unique_ref = $lcm->get_Lonly_ref;
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
    @unique = $lcm->get_Aonly;
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
    $unique_ref = $lcm->get_Aonly_ref;
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

@complement = $lcm->get_complement(1);
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

$complement_ref = $lcm->get_complement_ref(1);
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
    @complement = $lcm->get_Ronly(1);
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
    $complement_ref = $lcm->get_Ronly_ref(1);
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
    @complement = $lcm->get_Bonly(1);
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
    $complement_ref = $lcm->get_Bonly_ref(1);
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

@complement = $lcm->get_complement;
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

$complement_ref = $lcm->get_complement_ref;
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
    @complement = $lcm->get_Ronly;
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
    $complement_ref = $lcm->get_Ronly_ref;
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
    @complement = $lcm->get_Bonly;
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
    $complement_ref = $lcm->get_Bonly_ref;
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

@symmetric_difference = $lcm->get_symmetric_difference;
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

$symmetric_difference_ref = $lcm->get_symmetric_difference_ref;
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

@symmetric_difference = $lcm->get_symdiff;
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

$symmetric_difference_ref = $lcm->get_symdiff_ref;
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
    @symmetric_difference = $lcm->get_LorRonly;
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
    $symmetric_difference_ref = $lcm->get_LorRonly_ref;
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
    @symmetric_difference = $lcm->get_AorBonly;
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
    $symmetric_difference_ref = $lcm->get_AorBonly_ref;
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

@nonintersection = $lcm->get_nonintersection;
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

$nonintersection_ref = $lcm->get_nonintersection_ref;
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

@bag = $lcm->get_bag;
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

$bag_ref = $lcm->get_bag_ref;
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

$LR = $lcm->is_LsubsetR(3,2);
ok($LR);                                # 413

$LR = $lcm->is_AsubsetB(3,2);
ok($LR);                                # 414

$LR = $lcm->is_LsubsetR(2,3);
ok(! $LR);                              # 415

$LR = $lcm->is_AsubsetB(2,3);
ok(! $LR);                              # 416

$LR = $lcm->is_LsubsetR;
ok(! $LR);                              # 417

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcm->is_RsubsetL;
}
ok(! $RL);                              # 418

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcm->is_BsubsetA;
}
ok(! $RL);                              # 419

$eqv = $lcm->is_LequivalentR(3,4);
ok($eqv);                               # 420

$eqv = $lcm->is_LeqvlntR(3,4);
ok($eqv);                               # 421

$eqv = $lcm->is_LequivalentR(2,4);
ok(! $eqv);                             # 422

$return = $lcm->print_subset_chart;
ok($return);                            # 423

$return = $lcm->print_equivalence_chart;
ok($return);                            # 424

@memb_arr = $lcm->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 425

@memb_arr = $lcm->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 426

@memb_arr = $lcm->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 427

@memb_arr = $lcm->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 428

@memb_arr = $lcm->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 429

@memb_arr = $lcm->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 430

@memb_arr = $lcm->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 431

@memb_arr = $lcm->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 432

@memb_arr = $lcm->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 433

@memb_arr = $lcm->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 434

@memb_arr = $lcm->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 435


$memb_arr_ref = $lcm->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 436

$memb_arr_ref = $lcm->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 437

$memb_arr_ref = $lcm->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 438

$memb_arr_ref = $lcm->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 439

$memb_arr_ref = $lcm->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 440

$memb_arr_ref = $lcm->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 441

$memb_arr_ref = $lcm->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 442

$memb_arr_ref = $lcm->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 443

$memb_arr_ref = $lcm->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 444

$memb_arr_ref = $lcm->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 445

$memb_arr_ref = $lcm->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 446

$memb_hash_ref = $lcm->are_members_which( 
  [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] 
);
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

ok($lcm->is_member_any('abel'));        # 458
ok($lcm->is_member_any('baker'));       # 459
ok($lcm->is_member_any('camera'));      # 460
ok($lcm->is_member_any('delta'));       # 461
ok($lcm->is_member_any('edward'));      # 462
ok($lcm->is_member_any('fargo'));       # 463
ok($lcm->is_member_any('golfer'));      # 464
ok($lcm->is_member_any('hilton'));      # 465
ok($lcm->is_member_any('icon' ));       # 466
ok($lcm->is_member_any('jerky'));       # 467
ok(! $lcm->is_member_any('zebra'));     # 468

$memb_hash_ref = $lcm->are_members_any( 
    [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 469
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 470
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 471
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 472
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 473
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 474
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 475
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 476
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 477
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 478
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 479

$vers = $lcm->get_version;
ok($vers);                              # 480

my $lcm_dj   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4, \@a8);

ok($lcm_dj);                            # 481

$disj = $lcm_dj->is_LdisjointR;
ok(! $disj);                            # 482

$disj = $lcm_dj->is_LdisjointR(2,3);
ok(! $disj);                            # 483

$disj = $lcm_dj->is_LdisjointR(4,5);
ok($disj);                              # 484

########## BELOW:  Tests for '-u' option ##########

my $lcmu   = List::Compare->new('-u', \@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcmu);                              # 485

@union = $lcmu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 486
ok(exists $seen{'baker'});              # 487
ok(exists $seen{'camera'});             # 488
ok(exists $seen{'delta'});              # 489
ok(exists $seen{'edward'});             # 490
ok(exists $seen{'fargo'});              # 491
ok(exists $seen{'golfer'});             # 492
ok(exists $seen{'hilton'});             # 493
ok(exists $seen{'icon'});               # 494
ok(exists $seen{'jerky'});              # 495
%seen = ();

$union_ref = $lcmu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 496
ok(exists $seen{'baker'});              # 497
ok(exists $seen{'camera'});             # 498
ok(exists $seen{'delta'});              # 499
ok(exists $seen{'edward'});             # 500
ok(exists $seen{'fargo'});              # 501
ok(exists $seen{'golfer'});             # 502
ok(exists $seen{'hilton'});             # 503
ok(exists $seen{'icon'});               # 504
ok(exists $seen{'jerky'});              # 505
%seen = ();

@shared = $lcmu->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 506
ok(exists $seen{'baker'});              # 507
ok(exists $seen{'camera'});             # 508
ok(exists $seen{'delta'});              # 509
ok(exists $seen{'edward'});             # 510
ok(exists $seen{'fargo'});              # 511
ok(exists $seen{'golfer'});             # 512
ok(exists $seen{'hilton'});             # 513
ok(exists $seen{'icon'});               # 514
ok(! exists $seen{'jerky'});            # 515
%seen = ();

$shared_ref = $lcmu->get_shared_ref;
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 516
ok(exists $seen{'baker'});              # 517
ok(exists $seen{'camera'});             # 518
ok(exists $seen{'delta'});              # 519
ok(exists $seen{'edward'});             # 520
ok(exists $seen{'fargo'});              # 521
ok(exists $seen{'golfer'});             # 522
ok(exists $seen{'hilton'});             # 523
ok(exists $seen{'icon'});               # 524
ok(! exists $seen{'jerky'});            # 525
%seen = ();

@intersection = $lcmu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 526
ok(! exists $seen{'baker'});            # 527
ok(! exists $seen{'camera'});           # 528
ok(! exists $seen{'delta'});            # 529
ok(! exists $seen{'edward'});           # 530
ok(exists $seen{'fargo'});              # 531
ok(exists $seen{'golfer'});             # 532
ok(! exists $seen{'hilton'});           # 533
ok(! exists $seen{'icon'});             # 534
ok(! exists $seen{'jerky'});            # 535
%seen = ();

$intersection_ref = $lcmu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 536
ok(! exists $seen{'baker'});            # 537
ok(! exists $seen{'camera'});           # 538
ok(! exists $seen{'delta'});            # 539
ok(! exists $seen{'edward'});           # 540
ok(exists $seen{'fargo'});              # 541
ok(exists $seen{'golfer'});             # 542
ok(! exists $seen{'hilton'});           # 543
ok(! exists $seen{'icon'});             # 544
ok(! exists $seen{'jerky'});            # 545
%seen = ();

@unique = $lcmu->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 546
ok(! exists $seen{'baker'});            # 547
ok(! exists $seen{'camera'});           # 548
ok(! exists $seen{'delta'});            # 549
ok(! exists $seen{'edward'});           # 550
ok(! exists $seen{'fargo'});            # 551
ok(! exists $seen{'golfer'});           # 552
ok(! exists $seen{'hilton'});           # 553
ok(! exists $seen{'icon'});             # 554
ok(exists $seen{'jerky'});              # 555
%seen = ();

$unique_ref = $lcmu->get_unique_ref(2);
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 556
ok(! exists $seen{'baker'});            # 557
ok(! exists $seen{'camera'});           # 558
ok(! exists $seen{'delta'});            # 559
ok(! exists $seen{'edward'});           # 560
ok(! exists $seen{'fargo'});            # 561
ok(! exists $seen{'golfer'});           # 562
ok(! exists $seen{'hilton'});           # 563
ok(! exists $seen{'icon'});             # 564
ok(exists $seen{'jerky'});              # 565
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmu->get_Lonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 566
ok(! exists $seen{'baker'});            # 567
ok(! exists $seen{'camera'});           # 568
ok(! exists $seen{'delta'});            # 569
ok(! exists $seen{'edward'});           # 570
ok(! exists $seen{'fargo'});            # 571
ok(! exists $seen{'golfer'});           # 572
ok(! exists $seen{'hilton'});           # 573
ok(! exists $seen{'icon'});             # 574
ok(exists $seen{'jerky'});              # 575
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmu->get_Aonly(2);
}
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 576
ok(! exists $seen{'baker'});            # 577
ok(! exists $seen{'camera'});           # 578
ok(! exists $seen{'delta'});            # 579
ok(! exists $seen{'edward'});           # 580
ok(! exists $seen{'fargo'});            # 581
ok(! exists $seen{'golfer'});           # 582
ok(! exists $seen{'hilton'});           # 583
ok(! exists $seen{'icon'});             # 584
ok(exists $seen{'jerky'});              # 585
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmu->get_Aonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 586
ok(! exists $seen{'baker'});            # 587
ok(! exists $seen{'camera'});           # 588
ok(! exists $seen{'delta'});            # 589
ok(! exists $seen{'edward'});           # 590
ok(! exists $seen{'fargo'});            # 591
ok(! exists $seen{'golfer'});           # 592
ok(! exists $seen{'hilton'});           # 593
ok(! exists $seen{'icon'});             # 594
ok(exists $seen{'jerky'});              # 595
%seen = ();

@unique = $lcmu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 596
ok(! exists $seen{'baker'});            # 597
ok(! exists $seen{'camera'});           # 598
ok(! exists $seen{'delta'});            # 599
ok(! exists $seen{'edward'});           # 600
ok(! exists $seen{'fargo'});            # 601
ok(! exists $seen{'golfer'});           # 602
ok(! exists $seen{'hilton'});           # 603
ok(! exists $seen{'icon'});             # 604
ok(! exists $seen{'jerky'});            # 605
%seen = ();

$unique_ref = $lcmu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 606
ok(! exists $seen{'baker'});            # 607
ok(! exists $seen{'camera'});           # 608
ok(! exists $seen{'delta'});            # 609
ok(! exists $seen{'edward'});           # 610
ok(! exists $seen{'fargo'});            # 611
ok(! exists $seen{'golfer'});           # 612
ok(! exists $seen{'hilton'});           # 613
ok(! exists $seen{'icon'});             # 614
ok(! exists $seen{'jerky'});            # 615
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmu->get_Lonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 616
ok(! exists $seen{'baker'});            # 617
ok(! exists $seen{'camera'});           # 618
ok(! exists $seen{'delta'});            # 619
ok(! exists $seen{'edward'});           # 620
ok(! exists $seen{'fargo'});            # 621
ok(! exists $seen{'golfer'});           # 622
ok(! exists $seen{'hilton'});           # 623
ok(! exists $seen{'icon'});             # 624
ok(! exists $seen{'jerky'});            # 625
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmu->get_Lonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 626
ok(! exists $seen{'baker'});            # 627
ok(! exists $seen{'camera'});           # 628
ok(! exists $seen{'delta'});            # 629
ok(! exists $seen{'edward'});           # 630
ok(! exists $seen{'fargo'});            # 631
ok(! exists $seen{'golfer'});           # 632
ok(! exists $seen{'hilton'});           # 633
ok(! exists $seen{'icon'});             # 634
ok(! exists $seen{'jerky'});            # 635
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmu->get_Aonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 636
ok(! exists $seen{'baker'});            # 637
ok(! exists $seen{'camera'});           # 638
ok(! exists $seen{'delta'});            # 639
ok(! exists $seen{'edward'});           # 640
ok(! exists $seen{'fargo'});            # 641
ok(! exists $seen{'golfer'});           # 642
ok(! exists $seen{'hilton'});           # 643
ok(! exists $seen{'icon'});             # 644
ok(! exists $seen{'jerky'});            # 645
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmu->get_Aonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 646
ok(! exists $seen{'baker'});            # 647
ok(! exists $seen{'camera'});           # 648
ok(! exists $seen{'delta'});            # 649
ok(! exists $seen{'edward'});           # 650
ok(! exists $seen{'fargo'});            # 651
ok(! exists $seen{'golfer'});           # 652
ok(! exists $seen{'hilton'});           # 653
ok(! exists $seen{'icon'});             # 654
ok(! exists $seen{'jerky'});            # 655
%seen = ();

@complement = $lcmu->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 656
ok(! exists $seen{'baker'});            # 657
ok(! exists $seen{'camera'});           # 658
ok(! exists $seen{'delta'});            # 659
ok(! exists $seen{'edward'});           # 660
ok(! exists $seen{'fargo'});            # 661
ok(! exists $seen{'golfer'});           # 662
ok(! exists $seen{'hilton'});           # 663
ok(exists $seen{'icon'});               # 664
ok(exists $seen{'jerky'});              # 665
%seen = ();

$complement_ref = $lcmu->get_complement_ref(1);
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 666
ok(! exists $seen{'baker'});            # 667
ok(! exists $seen{'camera'});           # 668
ok(! exists $seen{'delta'});            # 669
ok(! exists $seen{'edward'});           # 670
ok(! exists $seen{'fargo'});            # 671
ok(! exists $seen{'golfer'});           # 672
ok(! exists $seen{'hilton'});           # 673
ok(exists $seen{'icon'});               # 674
ok(exists $seen{'jerky'});              # 675
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmu->get_Ronly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 676
ok(! exists $seen{'baker'});            # 677
ok(! exists $seen{'camera'});           # 678
ok(! exists $seen{'delta'});            # 679
ok(! exists $seen{'edward'});           # 680
ok(! exists $seen{'fargo'});            # 681
ok(! exists $seen{'golfer'});           # 682
ok(! exists $seen{'hilton'});           # 683
ok(exists $seen{'icon'});               # 684
ok(exists $seen{'jerky'});              # 685
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmu->get_Ronly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 686
ok(! exists $seen{'baker'});            # 687
ok(! exists $seen{'camera'});           # 688
ok(! exists $seen{'delta'});            # 689
ok(! exists $seen{'edward'});           # 690
ok(! exists $seen{'fargo'});            # 691
ok(! exists $seen{'golfer'});           # 692
ok(! exists $seen{'hilton'});           # 693
ok(exists $seen{'icon'});               # 694
ok(exists $seen{'jerky'});              # 695
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmu->get_Bonly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 696
ok(! exists $seen{'baker'});            # 697
ok(! exists $seen{'camera'});           # 698
ok(! exists $seen{'delta'});            # 699
ok(! exists $seen{'edward'});           # 700
ok(! exists $seen{'fargo'});            # 701
ok(! exists $seen{'golfer'});           # 702
ok(! exists $seen{'hilton'});           # 703
ok(exists $seen{'icon'});               # 704
ok(exists $seen{'jerky'});              # 705
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmu->get_Bonly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 706
ok(! exists $seen{'baker'});            # 707
ok(! exists $seen{'camera'});           # 708
ok(! exists $seen{'delta'});            # 709
ok(! exists $seen{'edward'});           # 710
ok(! exists $seen{'fargo'});            # 711
ok(! exists $seen{'golfer'});           # 712
ok(! exists $seen{'hilton'});           # 713
ok(exists $seen{'icon'});               # 714
ok(exists $seen{'jerky'});              # 715
%seen = ();

@complement = $lcmu->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 716
ok(! exists $seen{'baker'});            # 717
ok(! exists $seen{'camera'});           # 718
ok(! exists $seen{'delta'});            # 719
ok(! exists $seen{'edward'});           # 720
ok(! exists $seen{'fargo'});            # 721
ok(! exists $seen{'golfer'});           # 722
ok(exists $seen{'hilton'});             # 723
ok(exists $seen{'icon'});               # 724
ok(exists $seen{'jerky'});              # 725
%seen = ();

$complement_ref = $lcmu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 726
ok(! exists $seen{'baker'});            # 727
ok(! exists $seen{'camera'});           # 728
ok(! exists $seen{'delta'});            # 729
ok(! exists $seen{'edward'});           # 730
ok(! exists $seen{'fargo'});            # 731
ok(! exists $seen{'golfer'});           # 732
ok(exists $seen{'hilton'});             # 733
ok(exists $seen{'icon'});               # 734
ok(exists $seen{'jerky'});              # 735
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmu->get_Ronly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 736
ok(! exists $seen{'baker'});            # 737
ok(! exists $seen{'camera'});           # 738
ok(! exists $seen{'delta'});            # 739
ok(! exists $seen{'edward'});           # 740
ok(! exists $seen{'fargo'});            # 741
ok(! exists $seen{'golfer'});           # 742
ok(exists $seen{'hilton'});             # 743
ok(exists $seen{'icon'});               # 744
ok(exists $seen{'jerky'});              # 745
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmu->get_Ronly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 746
ok(! exists $seen{'baker'});            # 747
ok(! exists $seen{'camera'});           # 748
ok(! exists $seen{'delta'});            # 749
ok(! exists $seen{'edward'});           # 750
ok(! exists $seen{'fargo'});            # 751
ok(! exists $seen{'golfer'});           # 752
ok(exists $seen{'hilton'});             # 753
ok(exists $seen{'icon'});               # 754
ok(exists $seen{'jerky'});              # 755
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmu->get_Bonly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 756
ok(! exists $seen{'baker'});            # 757
ok(! exists $seen{'camera'});           # 758
ok(! exists $seen{'delta'});            # 759
ok(! exists $seen{'edward'});           # 760
ok(! exists $seen{'fargo'});            # 761
ok(! exists $seen{'golfer'});           # 762
ok(exists $seen{'hilton'});             # 763
ok(exists $seen{'icon'});               # 764
ok(exists $seen{'jerky'});              # 765
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmu->get_Bonly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 766
ok(! exists $seen{'baker'});            # 767
ok(! exists $seen{'camera'});           # 768
ok(! exists $seen{'delta'});            # 769
ok(! exists $seen{'edward'});           # 770
ok(! exists $seen{'fargo'});            # 771
ok(! exists $seen{'golfer'});           # 772
ok(exists $seen{'hilton'});             # 773
ok(exists $seen{'icon'});               # 774
ok(exists $seen{'jerky'});              # 775
%seen = ();

@symmetric_difference = $lcmu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 776
ok(! exists $seen{'baker'});            # 777
ok(! exists $seen{'camera'});           # 778
ok(! exists $seen{'delta'});            # 779
ok(! exists $seen{'edward'});           # 780
ok(! exists $seen{'fargo'});            # 781
ok(! exists $seen{'golfer'});           # 782
ok(! exists $seen{'hilton'});           # 783
ok(! exists $seen{'icon'});             # 784
ok(exists $seen{'jerky'});              # 785
%seen = ();

$symmetric_difference_ref = $lcmu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 786
ok(! exists $seen{'baker'});            # 787
ok(! exists $seen{'camera'});           # 788
ok(! exists $seen{'delta'});            # 789
ok(! exists $seen{'edward'});           # 790
ok(! exists $seen{'fargo'});            # 791
ok(! exists $seen{'golfer'});           # 792
ok(! exists $seen{'hilton'});           # 793
ok(! exists $seen{'icon'});             # 794
ok(exists $seen{'jerky'});              # 795
%seen = ();

@symmetric_difference = $lcmu->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 796
ok(! exists $seen{'baker'});            # 797
ok(! exists $seen{'camera'});           # 798
ok(! exists $seen{'delta'});            # 799
ok(! exists $seen{'edward'});           # 800
ok(! exists $seen{'fargo'});            # 801
ok(! exists $seen{'golfer'});           # 802
ok(! exists $seen{'hilton'});           # 803
ok(! exists $seen{'icon'});             # 804
ok(exists $seen{'jerky'});              # 805
%seen = ();

$symmetric_difference_ref = $lcmu->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 806
ok(! exists $seen{'baker'});            # 807
ok(! exists $seen{'camera'});           # 808
ok(! exists $seen{'delta'});            # 809
ok(! exists $seen{'edward'});           # 810
ok(! exists $seen{'fargo'});            # 811
ok(! exists $seen{'golfer'});           # 812
ok(! exists $seen{'hilton'});           # 813
ok(! exists $seen{'icon'});             # 814
ok(exists $seen{'jerky'});              # 815
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @symmetric_difference = $lcmu->get_LorRonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 816
ok(! exists $seen{'baker'});            # 817
ok(! exists $seen{'camera'});           # 818
ok(! exists $seen{'delta'});            # 819
ok(! exists $seen{'edward'});           # 820
ok(! exists $seen{'fargo'});            # 821
ok(! exists $seen{'golfer'});           # 822
ok(! exists $seen{'hilton'});           # 823
ok(! exists $seen{'icon'});             # 824
ok(exists $seen{'jerky'});              # 825
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $symmetric_difference_ref = $lcmu->get_LorRonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 826
ok(! exists $seen{'baker'});            # 827
ok(! exists $seen{'camera'});           # 828
ok(! exists $seen{'delta'});            # 829
ok(! exists $seen{'edward'});           # 830
ok(! exists $seen{'fargo'});            # 831
ok(! exists $seen{'golfer'});           # 832
ok(! exists $seen{'hilton'});           # 833
ok(! exists $seen{'icon'});             # 834
ok(exists $seen{'jerky'});              # 835
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @symmetric_difference = $lcmu->get_AorBonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 836
ok(! exists $seen{'baker'});            # 837
ok(! exists $seen{'camera'});           # 838
ok(! exists $seen{'delta'});            # 839
ok(! exists $seen{'edward'});           # 840
ok(! exists $seen{'fargo'});            # 841
ok(! exists $seen{'golfer'});           # 842
ok(! exists $seen{'hilton'});           # 843
ok(! exists $seen{'icon'});             # 844
ok(exists $seen{'jerky'});              # 845
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $symmetric_difference_ref = $lcmu->get_AorBonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 846
ok(! exists $seen{'baker'});            # 847
ok(! exists $seen{'camera'});           # 848
ok(! exists $seen{'delta'});            # 849
ok(! exists $seen{'edward'});           # 850
ok(! exists $seen{'fargo'});            # 851
ok(! exists $seen{'golfer'});           # 852
ok(! exists $seen{'hilton'});           # 853
ok(! exists $seen{'icon'});             # 854
ok(exists $seen{'jerky'});              # 855
%seen = ();

@nonintersection = $lcmu->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 856
ok(exists $seen{'baker'});              # 857
ok(exists $seen{'camera'});             # 858
ok(exists $seen{'delta'});              # 859
ok(exists $seen{'edward'});             # 860
ok(! exists $seen{'fargo'});            # 861
ok(! exists $seen{'golfer'});           # 862
ok(exists $seen{'hilton'});             # 863
ok(exists $seen{'icon'});               # 864
ok(exists $seen{'jerky'});              # 865
%seen = ();

$nonintersection_ref = $lcmu->get_nonintersection_ref;
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 866
ok(exists $seen{'baker'});              # 867
ok(exists $seen{'camera'});             # 868
ok(exists $seen{'delta'});              # 869
ok(exists $seen{'edward'});             # 870
ok(! exists $seen{'fargo'});            # 871
ok(! exists $seen{'golfer'});           # 872
ok(exists $seen{'hilton'});             # 873
ok(exists $seen{'icon'});               # 874
ok(exists $seen{'jerky'});              # 875
%seen = ();

@bag = $lcmu->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 876
ok($seen{'baker'} == 2);                # 877
ok($seen{'camera'} == 2);               # 878
ok($seen{'delta'} == 3);                # 879
ok($seen{'edward'} == 2);               # 880
ok($seen{'fargo'} == 6);                # 881
ok($seen{'golfer'} == 5);               # 882
ok($seen{'hilton'} == 4);               # 883
ok($seen{'icon'} == 5);                 # 884
ok($seen{'jerky'} == 1);                # 885
%seen = ();

$bag_ref = $lcmu->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 886
ok($seen{'baker'} == 2);                # 887
ok($seen{'camera'} == 2);               # 888
ok($seen{'delta'} == 3);                # 889
ok($seen{'edward'} == 2);               # 890
ok($seen{'fargo'} == 6);                # 891
ok($seen{'golfer'} == 5);               # 892
ok($seen{'hilton'} == 4);               # 893
ok($seen{'icon'} == 5);                 # 894
ok($seen{'jerky'} == 1);                # 895
%seen = ();

$LR = $lcmu->is_LsubsetR(3,2);
ok($LR);                                # 896

$LR = $lcmu->is_AsubsetB(3,2);
ok($LR);                                # 897

$LR = $lcmu->is_LsubsetR(2,3);
ok(! $LR);                              # 898

$LR = $lcmu->is_AsubsetB(2,3);
ok(! $LR);                              # 899

$LR = $lcmu->is_LsubsetR;
ok(! $LR);                              # 900

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcmu->is_RsubsetL;
}
ok(! $RL);                              # 901

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcmu->is_BsubsetA;
}
ok(! $RL);                              # 902

$eqv = $lcmu->is_LequivalentR(3,4);
ok($eqv);                               # 903

$eqv = $lcmu->is_LeqvlntR(3,4);
ok($eqv);                               # 904

$eqv = $lcmu->is_LequivalentR(2,4);
ok(! $eqv);                             # 905

$return = $lcmu->print_subset_chart;
ok($return);                            # 906

$return = $lcmu->print_equivalence_chart;
ok($return);                            # 907

@memb_arr = $lcmu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 908

@memb_arr = $lcmu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 909

@memb_arr = $lcmu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 910

@memb_arr = $lcmu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 911

@memb_arr = $lcmu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 912

@memb_arr = $lcmu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 913

@memb_arr = $lcmu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 914

@memb_arr = $lcmu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 915

@memb_arr = $lcmu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 916

@memb_arr = $lcmu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 917

@memb_arr = $lcmu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 918

$memb_arr_ref = $lcmu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 919

$memb_arr_ref = $lcmu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 920

$memb_arr_ref = $lcmu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 921

$memb_arr_ref = $lcmu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 922

$memb_arr_ref = $lcmu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 923

$memb_arr_ref = $lcmu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 924

$memb_arr_ref = $lcmu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 925

$memb_arr_ref = $lcmu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 926

$memb_arr_ref = $lcmu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 927

$memb_arr_ref = $lcmu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 928

$memb_arr_ref = $lcmu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 929

$memb_hash_ref = $lcmu->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 930
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 931
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 932
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 933
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 934
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 935
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 936
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 937
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 938
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 939
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 940


ok($lcmu->is_member_any('abel'));       # 941
ok($lcmu->is_member_any('baker'));      # 942
ok($lcmu->is_member_any('camera'));     # 943
ok($lcmu->is_member_any('delta'));      # 944
ok($lcmu->is_member_any('edward'));     # 945
ok($lcmu->is_member_any('fargo'));      # 946
ok($lcmu->is_member_any('golfer'));     # 947
ok($lcmu->is_member_any('hilton'));     # 948
ok($lcmu->is_member_any('icon' ));      # 949
ok($lcmu->is_member_any('jerky'));      # 950
ok(! $lcmu->is_member_any('zebra'));    # 951

$memb_hash_ref = $lcmu->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 952
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 953
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 954
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 955
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 956
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 957
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 958
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 959
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 960
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 961
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 962

$vers = $lcmu->get_version;
ok($vers);                              # 963

my $lcmu_dj   = List::Compare->new(\@a0, \@a1, \@a2, \@a3, \@a4, \@a8);

ok($lcmu_dj);                           # 964

$disj = $lcmu_dj->is_LdisjointR;
ok(! $disj);                            # 965

$disj = $lcmu_dj->is_LdisjointR(2,3);
ok(! $disj);                            # 966

$disj = $lcmu_dj->is_LdisjointR(4,5);
ok($disj);                              # 967

########## BELOW:  Test for '--unsorted' option ##########

my $lcmun   = List::Compare->new('--unsorted', \@a0, \@a1, \@a2, \@a3, \@a4);

ok($lcmun);                             # 968

########## BELOW:  Testfor bad arguments to constructor ##########

my ($lcm_bad);
my %h5 = (
    golfer   => 1,
    lambda   => 0,
);

eval { $lcm_bad = List::Compare->new('-a', \@a0, \@a1, \@a2, \@a3, \%h5) };
ok(ok_capture_error($@));               # 969

eval { $lcm_bad = List::Compare->new('-a', \%h5, \@a0, \@a1, \@a2, \@a3) };
ok(ok_capture_error($@));               # 970


