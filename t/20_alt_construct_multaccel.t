# 20_alt_construct_multaccel.t.raw # 05/08/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
960;
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

my $lcma   = List::Compare->new( { accelerated => 1, lists => [\@a0, \@a1, \@a2, \@a3, \@a4] } );

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

$memb_hash_ref = $lcma->are_members_which(
                     [ qw| abel baker camera delta edward fargo 
                           golfer hilton icon jerky zebra | ] );
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

ok($lcma->is_member_any('abel'));       # 458
ok($lcma->is_member_any('baker'));      # 459
ok($lcma->is_member_any('camera'));     # 460
ok($lcma->is_member_any('delta'));      # 461
ok($lcma->is_member_any('edward'));     # 462
ok($lcma->is_member_any('fargo'));      # 463
ok($lcma->is_member_any('golfer'));     # 464
ok($lcma->is_member_any('hilton'));     # 465
ok($lcma->is_member_any('icon' ));      # 466
ok($lcma->is_member_any('jerky'));      # 467
ok(! $lcma->is_member_any('zebra'));    # 468

$memb_hash_ref = $lcma->are_members_any(
                     [ qw| abel baker camera delta edward fargo 
                           golfer hilton icon jerky zebra | ] );
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

$vers = $lcma->get_version;
ok($vers);                              # 480

########## BELOW:  Tests for '-u' option ##########

my $lcmau   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1, \@a2, \@a3, \@a4] } );

ok($lcmau);                             # 481

@union = $lcmau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 482
ok(exists $seen{'baker'});              # 483
ok(exists $seen{'camera'});             # 484
ok(exists $seen{'delta'});              # 485
ok(exists $seen{'edward'});             # 486
ok(exists $seen{'fargo'});              # 487
ok(exists $seen{'golfer'});             # 488
ok(exists $seen{'hilton'});             # 489
ok(exists $seen{'icon'});               # 490
ok(exists $seen{'jerky'});              # 491
%seen = ();

$union_ref = $lcmau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 492
ok(exists $seen{'baker'});              # 493
ok(exists $seen{'camera'});             # 494
ok(exists $seen{'delta'});              # 495
ok(exists $seen{'edward'});             # 496
ok(exists $seen{'fargo'});              # 497
ok(exists $seen{'golfer'});             # 498
ok(exists $seen{'hilton'});             # 499
ok(exists $seen{'icon'});               # 500
ok(exists $seen{'jerky'});              # 501
%seen = ();

@shared = $lcmau->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 502
ok(exists $seen{'baker'});              # 503
ok(exists $seen{'camera'});             # 504
ok(exists $seen{'delta'});              # 505
ok(exists $seen{'edward'});             # 506
ok(exists $seen{'fargo'});              # 507
ok(exists $seen{'golfer'});             # 508
ok(exists $seen{'hilton'});             # 509
ok(exists $seen{'icon'});               # 510
ok(! exists $seen{'jerky'});            # 511
%seen = ();

$shared_ref = $lcmau->get_shared_ref;
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 512
ok(exists $seen{'baker'});              # 513
ok(exists $seen{'camera'});             # 514
ok(exists $seen{'delta'});              # 515
ok(exists $seen{'edward'});             # 516
ok(exists $seen{'fargo'});              # 517
ok(exists $seen{'golfer'});             # 518
ok(exists $seen{'hilton'});             # 519
ok(exists $seen{'icon'});               # 520
ok(! exists $seen{'jerky'});            # 521
%seen = ();

@intersection = $lcmau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 522
ok(! exists $seen{'baker'});            # 523
ok(! exists $seen{'camera'});           # 524
ok(! exists $seen{'delta'});            # 525
ok(! exists $seen{'edward'});           # 526
ok(exists $seen{'fargo'});              # 527
ok(exists $seen{'golfer'});             # 528
ok(! exists $seen{'hilton'});           # 529
ok(! exists $seen{'icon'});             # 530
ok(! exists $seen{'jerky'});            # 531
%seen = ();

$intersection_ref = $lcmau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 532
ok(! exists $seen{'baker'});            # 533
ok(! exists $seen{'camera'});           # 534
ok(! exists $seen{'delta'});            # 535
ok(! exists $seen{'edward'});           # 536
ok(exists $seen{'fargo'});              # 537
ok(exists $seen{'golfer'});             # 538
ok(! exists $seen{'hilton'});           # 539
ok(! exists $seen{'icon'});             # 540
ok(! exists $seen{'jerky'});            # 541
%seen = ();

@unique = $lcmau->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 542
ok(! exists $seen{'baker'});            # 543
ok(! exists $seen{'camera'});           # 544
ok(! exists $seen{'delta'});            # 545
ok(! exists $seen{'edward'});           # 546
ok(! exists $seen{'fargo'});            # 547
ok(! exists $seen{'golfer'});           # 548
ok(! exists $seen{'hilton'});           # 549
ok(! exists $seen{'icon'});             # 550
ok(exists $seen{'jerky'});              # 551
%seen = ();

$unique_ref = $lcmau->get_unique_ref(2);
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 552
ok(! exists $seen{'baker'});            # 553
ok(! exists $seen{'camera'});           # 554
ok(! exists $seen{'delta'});            # 555
ok(! exists $seen{'edward'});           # 556
ok(! exists $seen{'fargo'});            # 557
ok(! exists $seen{'golfer'});           # 558
ok(! exists $seen{'hilton'});           # 559
ok(! exists $seen{'icon'});             # 560
ok(exists $seen{'jerky'});              # 561
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmau->get_Lonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 562
ok(! exists $seen{'baker'});            # 563
ok(! exists $seen{'camera'});           # 564
ok(! exists $seen{'delta'});            # 565
ok(! exists $seen{'edward'});           # 566
ok(! exists $seen{'fargo'});            # 567
ok(! exists $seen{'golfer'});           # 568
ok(! exists $seen{'hilton'});           # 569
ok(! exists $seen{'icon'});             # 570
ok(exists $seen{'jerky'});              # 571
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmau->get_Aonly(2);
}
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 572
ok(! exists $seen{'baker'});            # 573
ok(! exists $seen{'camera'});           # 574
ok(! exists $seen{'delta'});            # 575
ok(! exists $seen{'edward'});           # 576
ok(! exists $seen{'fargo'});            # 577
ok(! exists $seen{'golfer'});           # 578
ok(! exists $seen{'hilton'});           # 579
ok(! exists $seen{'icon'});             # 580
ok(exists $seen{'jerky'});              # 581
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmau->get_Aonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 582
ok(! exists $seen{'baker'});            # 583
ok(! exists $seen{'camera'});           # 584
ok(! exists $seen{'delta'});            # 585
ok(! exists $seen{'edward'});           # 586
ok(! exists $seen{'fargo'});            # 587
ok(! exists $seen{'golfer'});           # 588
ok(! exists $seen{'hilton'});           # 589
ok(! exists $seen{'icon'});             # 590
ok(exists $seen{'jerky'});              # 591
%seen = ();

@unique = $lcmau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 592
ok(! exists $seen{'baker'});            # 593
ok(! exists $seen{'camera'});           # 594
ok(! exists $seen{'delta'});            # 595
ok(! exists $seen{'edward'});           # 596
ok(! exists $seen{'fargo'});            # 597
ok(! exists $seen{'golfer'});           # 598
ok(! exists $seen{'hilton'});           # 599
ok(! exists $seen{'icon'});             # 600
ok(! exists $seen{'jerky'});            # 601
%seen = ();

$unique_ref = $lcmau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 602
ok(! exists $seen{'baker'});            # 603
ok(! exists $seen{'camera'});           # 604
ok(! exists $seen{'delta'});            # 605
ok(! exists $seen{'edward'});           # 606
ok(! exists $seen{'fargo'});            # 607
ok(! exists $seen{'golfer'});           # 608
ok(! exists $seen{'hilton'});           # 609
ok(! exists $seen{'icon'});             # 610
ok(! exists $seen{'jerky'});            # 611
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmau->get_Lonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 612
ok(! exists $seen{'baker'});            # 613
ok(! exists $seen{'camera'});           # 614
ok(! exists $seen{'delta'});            # 615
ok(! exists $seen{'edward'});           # 616
ok(! exists $seen{'fargo'});            # 617
ok(! exists $seen{'golfer'});           # 618
ok(! exists $seen{'hilton'});           # 619
ok(! exists $seen{'icon'});             # 620
ok(! exists $seen{'jerky'});            # 621
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmau->get_Lonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 622
ok(! exists $seen{'baker'});            # 623
ok(! exists $seen{'camera'});           # 624
ok(! exists $seen{'delta'});            # 625
ok(! exists $seen{'edward'});           # 626
ok(! exists $seen{'fargo'});            # 627
ok(! exists $seen{'golfer'});           # 628
ok(! exists $seen{'hilton'});           # 629
ok(! exists $seen{'icon'});             # 630
ok(! exists $seen{'jerky'});            # 631
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @unique = $lcmau->get_Aonly;
}
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 632
ok(! exists $seen{'baker'});            # 633
ok(! exists $seen{'camera'});           # 634
ok(! exists $seen{'delta'});            # 635
ok(! exists $seen{'edward'});           # 636
ok(! exists $seen{'fargo'});            # 637
ok(! exists $seen{'golfer'});           # 638
ok(! exists $seen{'hilton'});           # 639
ok(! exists $seen{'icon'});             # 640
ok(! exists $seen{'jerky'});            # 641
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $unique_ref = $lcmau->get_Aonly_ref;
}
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 642
ok(! exists $seen{'baker'});            # 643
ok(! exists $seen{'camera'});           # 644
ok(! exists $seen{'delta'});            # 645
ok(! exists $seen{'edward'});           # 646
ok(! exists $seen{'fargo'});            # 647
ok(! exists $seen{'golfer'});           # 648
ok(! exists $seen{'hilton'});           # 649
ok(! exists $seen{'icon'});             # 650
ok(! exists $seen{'jerky'});            # 651
%seen = ();

@complement = $lcmau->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 652
ok(! exists $seen{'baker'});            # 653
ok(! exists $seen{'camera'});           # 654
ok(! exists $seen{'delta'});            # 655
ok(! exists $seen{'edward'});           # 656
ok(! exists $seen{'fargo'});            # 657
ok(! exists $seen{'golfer'});           # 658
ok(! exists $seen{'hilton'});           # 659
ok(exists $seen{'icon'});               # 660
ok(exists $seen{'jerky'});              # 661
%seen = ();

$complement_ref = $lcmau->get_complement_ref(1);
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 662
ok(! exists $seen{'baker'});            # 663
ok(! exists $seen{'camera'});           # 664
ok(! exists $seen{'delta'});            # 665
ok(! exists $seen{'edward'});           # 666
ok(! exists $seen{'fargo'});            # 667
ok(! exists $seen{'golfer'});           # 668
ok(! exists $seen{'hilton'});           # 669
ok(exists $seen{'icon'});               # 670
ok(exists $seen{'jerky'});              # 671
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmau->get_Ronly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 672
ok(! exists $seen{'baker'});            # 673
ok(! exists $seen{'camera'});           # 674
ok(! exists $seen{'delta'});            # 675
ok(! exists $seen{'edward'});           # 676
ok(! exists $seen{'fargo'});            # 677
ok(! exists $seen{'golfer'});           # 678
ok(! exists $seen{'hilton'});           # 679
ok(exists $seen{'icon'});               # 680
ok(exists $seen{'jerky'});              # 681
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmau->get_Ronly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 682
ok(! exists $seen{'baker'});            # 683
ok(! exists $seen{'camera'});           # 684
ok(! exists $seen{'delta'});            # 685
ok(! exists $seen{'edward'});           # 686
ok(! exists $seen{'fargo'});            # 687
ok(! exists $seen{'golfer'});           # 688
ok(! exists $seen{'hilton'});           # 689
ok(exists $seen{'icon'});               # 690
ok(exists $seen{'jerky'});              # 691
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmau->get_Bonly(1);
}
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 692
ok(! exists $seen{'baker'});            # 693
ok(! exists $seen{'camera'});           # 694
ok(! exists $seen{'delta'});            # 695
ok(! exists $seen{'edward'});           # 696
ok(! exists $seen{'fargo'});            # 697
ok(! exists $seen{'golfer'});           # 698
ok(! exists $seen{'hilton'});           # 699
ok(exists $seen{'icon'});               # 700
ok(exists $seen{'jerky'});              # 701
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmau->get_Bonly_ref(1);
}
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 702
ok(! exists $seen{'baker'});            # 703
ok(! exists $seen{'camera'});           # 704
ok(! exists $seen{'delta'});            # 705
ok(! exists $seen{'edward'});           # 706
ok(! exists $seen{'fargo'});            # 707
ok(! exists $seen{'golfer'});           # 708
ok(! exists $seen{'hilton'});           # 709
ok(exists $seen{'icon'});               # 710
ok(exists $seen{'jerky'});              # 711
%seen = ();

@complement = $lcmau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 712
ok(! exists $seen{'baker'});            # 713
ok(! exists $seen{'camera'});           # 714
ok(! exists $seen{'delta'});            # 715
ok(! exists $seen{'edward'});           # 716
ok(! exists $seen{'fargo'});            # 717
ok(! exists $seen{'golfer'});           # 718
ok(exists $seen{'hilton'});             # 719
ok(exists $seen{'icon'});               # 720
ok(exists $seen{'jerky'});              # 721
%seen = ();

$complement_ref = $lcmau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 722
ok(! exists $seen{'baker'});            # 723
ok(! exists $seen{'camera'});           # 724
ok(! exists $seen{'delta'});            # 725
ok(! exists $seen{'edward'});           # 726
ok(! exists $seen{'fargo'});            # 727
ok(! exists $seen{'golfer'});           # 728
ok(exists $seen{'hilton'});             # 729
ok(exists $seen{'icon'});               # 730
ok(exists $seen{'jerky'});              # 731
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmau->get_Ronly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 732
ok(! exists $seen{'baker'});            # 733
ok(! exists $seen{'camera'});           # 734
ok(! exists $seen{'delta'});            # 735
ok(! exists $seen{'edward'});           # 736
ok(! exists $seen{'fargo'});            # 737
ok(! exists $seen{'golfer'});           # 738
ok(exists $seen{'hilton'});             # 739
ok(exists $seen{'icon'});               # 740
ok(exists $seen{'jerky'});              # 741
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmau->get_Ronly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 742
ok(! exists $seen{'baker'});            # 743
ok(! exists $seen{'camera'});           # 744
ok(! exists $seen{'delta'});            # 745
ok(! exists $seen{'edward'});           # 746
ok(! exists $seen{'fargo'});            # 747
ok(! exists $seen{'golfer'});           # 748
ok(exists $seen{'hilton'});             # 749
ok(exists $seen{'icon'});               # 750
ok(exists $seen{'jerky'});              # 751
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @complement = $lcmau->get_Bonly;
}
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 752
ok(! exists $seen{'baker'});            # 753
ok(! exists $seen{'camera'});           # 754
ok(! exists $seen{'delta'});            # 755
ok(! exists $seen{'edward'});           # 756
ok(! exists $seen{'fargo'});            # 757
ok(! exists $seen{'golfer'});           # 758
ok(exists $seen{'hilton'});             # 759
ok(exists $seen{'icon'});               # 760
ok(exists $seen{'jerky'});              # 761
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $complement_ref = $lcmau->get_Bonly_ref;
}
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 762
ok(! exists $seen{'baker'});            # 763
ok(! exists $seen{'camera'});           # 764
ok(! exists $seen{'delta'});            # 765
ok(! exists $seen{'edward'});           # 766
ok(! exists $seen{'fargo'});            # 767
ok(! exists $seen{'golfer'});           # 768
ok(exists $seen{'hilton'});             # 769
ok(exists $seen{'icon'});               # 770
ok(exists $seen{'jerky'});              # 771
%seen = ();

@symmetric_difference = $lcmau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 772
ok(! exists $seen{'baker'});            # 773
ok(! exists $seen{'camera'});           # 774
ok(! exists $seen{'delta'});            # 775
ok(! exists $seen{'edward'});           # 776
ok(! exists $seen{'fargo'});            # 777
ok(! exists $seen{'golfer'});           # 778
ok(! exists $seen{'hilton'});           # 779
ok(! exists $seen{'icon'});             # 780
ok(exists $seen{'jerky'});              # 781
%seen = ();

$symmetric_difference_ref = $lcmau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 782
ok(! exists $seen{'baker'});            # 783
ok(! exists $seen{'camera'});           # 784
ok(! exists $seen{'delta'});            # 785
ok(! exists $seen{'edward'});           # 786
ok(! exists $seen{'fargo'});            # 787
ok(! exists $seen{'golfer'});           # 788
ok(! exists $seen{'hilton'});           # 789
ok(! exists $seen{'icon'});             # 790
ok(exists $seen{'jerky'});              # 791
%seen = ();

@symmetric_difference = $lcmau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 792
ok(! exists $seen{'baker'});            # 793
ok(! exists $seen{'camera'});           # 794
ok(! exists $seen{'delta'});            # 795
ok(! exists $seen{'edward'});           # 796
ok(! exists $seen{'fargo'});            # 797
ok(! exists $seen{'golfer'});           # 798
ok(! exists $seen{'hilton'});           # 799
ok(! exists $seen{'icon'});             # 800
ok(exists $seen{'jerky'});              # 801
%seen = ();

$symmetric_difference_ref = $lcmau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 802
ok(! exists $seen{'baker'});            # 803
ok(! exists $seen{'camera'});           # 804
ok(! exists $seen{'delta'});            # 805
ok(! exists $seen{'edward'});           # 806
ok(! exists $seen{'fargo'});            # 807
ok(! exists $seen{'golfer'});           # 808
ok(! exists $seen{'hilton'});           # 809
ok(! exists $seen{'icon'});             # 810
ok(exists $seen{'jerky'});              # 811
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @symmetric_difference = $lcmau->get_LorRonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 812
ok(! exists $seen{'baker'});            # 813
ok(! exists $seen{'camera'});           # 814
ok(! exists $seen{'delta'});            # 815
ok(! exists $seen{'edward'});           # 816
ok(! exists $seen{'fargo'});            # 817
ok(! exists $seen{'golfer'});           # 818
ok(! exists $seen{'hilton'});           # 819
ok(! exists $seen{'icon'});             # 820
ok(exists $seen{'jerky'});              # 821
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $symmetric_difference_ref = $lcmau->get_LorRonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 822
ok(! exists $seen{'baker'});            # 823
ok(! exists $seen{'camera'});           # 824
ok(! exists $seen{'delta'});            # 825
ok(! exists $seen{'edward'});           # 826
ok(! exists $seen{'fargo'});            # 827
ok(! exists $seen{'golfer'});           # 828
ok(! exists $seen{'hilton'});           # 829
ok(! exists $seen{'icon'});             # 830
ok(exists $seen{'jerky'});              # 831
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @symmetric_difference = $lcmau->get_AorBonly;
}
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 832
ok(! exists $seen{'baker'});            # 833
ok(! exists $seen{'camera'});           # 834
ok(! exists $seen{'delta'});            # 835
ok(! exists $seen{'edward'});           # 836
ok(! exists $seen{'fargo'});            # 837
ok(! exists $seen{'golfer'});           # 838
ok(! exists $seen{'hilton'});           # 839
ok(! exists $seen{'icon'});             # 840
ok(exists $seen{'jerky'});              # 841
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $symmetric_difference_ref = $lcmau->get_AorBonly_ref;
}
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 842
ok(! exists $seen{'baker'});            # 843
ok(! exists $seen{'camera'});           # 844
ok(! exists $seen{'delta'});            # 845
ok(! exists $seen{'edward'});           # 846
ok(! exists $seen{'fargo'});            # 847
ok(! exists $seen{'golfer'});           # 848
ok(! exists $seen{'hilton'});           # 849
ok(! exists $seen{'icon'});             # 850
ok(exists $seen{'jerky'});              # 851
%seen = ();

@nonintersection = $lcmau->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 852
ok(exists $seen{'baker'});              # 853
ok(exists $seen{'camera'});             # 854
ok(exists $seen{'delta'});              # 855
ok(exists $seen{'edward'});             # 856
ok(! exists $seen{'fargo'});            # 857
ok(! exists $seen{'golfer'});           # 858
ok(exists $seen{'hilton'});             # 859
ok(exists $seen{'icon'});               # 860
ok(exists $seen{'jerky'});              # 861
%seen = ();

$nonintersection_ref = $lcmau->get_nonintersection_ref;
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 862
ok(exists $seen{'baker'});              # 863
ok(exists $seen{'camera'});             # 864
ok(exists $seen{'delta'});              # 865
ok(exists $seen{'edward'});             # 866
ok(! exists $seen{'fargo'});            # 867
ok(! exists $seen{'golfer'});           # 868
ok(exists $seen{'hilton'});             # 869
ok(exists $seen{'icon'});               # 870
ok(exists $seen{'jerky'});              # 871
%seen = ();

@bag = $lcmau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 872
ok($seen{'baker'} == 2);                # 873
ok($seen{'camera'} == 2);               # 874
ok($seen{'delta'} == 3);                # 875
ok($seen{'edward'} == 2);               # 876
ok($seen{'fargo'} == 6);                # 877
ok($seen{'golfer'} == 5);               # 878
ok($seen{'hilton'} == 4);               # 879
ok($seen{'icon'} == 5);                 # 880
ok($seen{'jerky'} == 1);                # 881
%seen = ();

$bag_ref = $lcmau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 882
ok($seen{'baker'} == 2);                # 883
ok($seen{'camera'} == 2);               # 884
ok($seen{'delta'} == 3);                # 885
ok($seen{'edward'} == 2);               # 886
ok($seen{'fargo'} == 6);                # 887
ok($seen{'golfer'} == 5);               # 888
ok($seen{'hilton'} == 4);               # 889
ok($seen{'icon'} == 5);                 # 890
ok($seen{'jerky'} == 1);                # 891
%seen = ();

$LR = $lcmau->is_LsubsetR(3,2);
ok($LR);                                # 892

$LR = $lcmau->is_AsubsetB(3,2);
ok($LR);                                # 893

$LR = $lcmau->is_LsubsetR(2,3);
ok(! $LR);                              # 894

$LR = $lcmau->is_AsubsetB(2,3);
ok(! $LR);                              # 895

$LR = $lcmau->is_LsubsetR;
ok(! $LR);                              # 896

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcmau->is_RsubsetL;
}
ok(! $RL);                              # 897

{
    local $SIG{__WARN__} = \&_capture;
    $RL = $lcmau->is_BsubsetA;
}
ok(! $RL);                              # 898

$eqv = $lcmau->is_LequivalentR(3,4);
ok($eqv);                               # 899

$eqv = $lcmau->is_LeqvlntR(3,4);
ok($eqv);                               # 900

$eqv = $lcmau->is_LequivalentR(2,4);
ok(! $eqv);                             # 901

$return = $lcmau->print_subset_chart;
ok($return);                            # 902

$return = $lcmau->print_equivalence_chart;
ok($return);                            # 903

@memb_arr = $lcmau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 904

@memb_arr = $lcmau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 905

@memb_arr = $lcmau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 906

@memb_arr = $lcmau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 907

@memb_arr = $lcmau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 908

@memb_arr = $lcmau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 909

@memb_arr = $lcmau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 910

@memb_arr = $lcmau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 911

@memb_arr = $lcmau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 912

@memb_arr = $lcmau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 913

@memb_arr = $lcmau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 914

$memb_arr_ref = $lcmau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 915

$memb_arr_ref = $lcmau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 916

$memb_arr_ref = $lcmau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 917

$memb_arr_ref = $lcmau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 918

$memb_arr_ref = $lcmau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 919

$memb_arr_ref = $lcmau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 920

$memb_arr_ref = $lcmau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 921

$memb_arr_ref = $lcmau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 922

$memb_arr_ref = $lcmau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 923

$memb_arr_ref = $lcmau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 924

$memb_arr_ref = $lcmau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 925

$memb_hash_ref = $lcmau->are_members_which(
                     [ qw| abel baker camera delta edward fargo 
                           golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 926
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 927
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 928
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 929
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 930
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 931
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 932
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 933
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 934
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 935
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 936

ok($lcmau->is_member_any('abel'));      # 937
ok($lcmau->is_member_any('baker'));     # 938
ok($lcmau->is_member_any('camera'));    # 939
ok($lcmau->is_member_any('delta'));     # 940
ok($lcmau->is_member_any('edward'));    # 941
ok($lcmau->is_member_any('fargo'));     # 942
ok($lcmau->is_member_any('golfer'));    # 943
ok($lcmau->is_member_any('hilton'));    # 944
ok($lcmau->is_member_any('icon' ));     # 945
ok($lcmau->is_member_any('jerky'));     # 946
ok(! $lcmau->is_member_any('zebra'));   # 947

$memb_hash_ref = $lcmau->are_members_any(
                     [ qw| abel baker camera delta edward fargo 
                           golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 948
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 949
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 950
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 951
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 952
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 953
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 954
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 955
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 956
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 957
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 958

$vers = $lcmau->get_version;
ok($vers);                              # 959

########## BELOW:  Tests for '--unsorted' option ##########

my $lcmaun   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\@a0, \@a1, \@a2, \@a3, \@a4] } );

ok($lcmaun);                            # 960
