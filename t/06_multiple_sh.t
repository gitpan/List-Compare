# 06_multiple_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
967;
use lib ("./t");
use List::Compare::SeenHash;
use Test::ListCompareSpecial;
use Test::ListCompareSpecial qw(:seen);

$loaded = 1;
ok($loaded);                            # 1
######################### End of black magic.

my %seen = ();
my (@unique, @complement, @intersection, @union, @symmetric_difference);
my ($unique_ref, $complement_ref, $intersection_ref, $union_ref, $symmetric_difference_ref);
my ($LR, $RL, $eqv, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my %h0 = (
	abel     => 2,
	baker    => 1,
	camera   => 1,
	delta    => 1,
	edward   => 1,
	fargo    => 1,
	golfer   => 1,
);

my %h1 = (
	baker    => 1,
	camera   => 1,
	delta    => 2,
	edward   => 1,
	fargo    => 1,
	golfer   => 1,
	hilton   => 1,
);

my %h2 = (
	fargo    => 1,
	golfer   => 1,
	hilton   => 1,
	icon     => 2,
	jerky    => 1,	
);

my %h3 = (
	fargo    => 1,
	golfer   => 1,
	hilton   => 1,
	icon     => 2,
);

my %h4 = (
	fargo    => 2,
	golfer   => 1,
	hilton   => 1,
	icon     => 1,
);

my %h5 = (
	golfer   => 1,
	lambda   => 0,
);

my %h6 = (
	golfer   => 1,
	mu       => 00,
);

my %h7 = (
	golfer   => 1,
	nu       => 'nothing',
);


my $lcmsh   = List::Compare::SeenHash->new(\%h0, \%h1, \%h2, \%h3, \%h4);
ok($lcmsh);                             # 2

@union = $lcmsh->get_union;
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

$union_ref = $lcmsh->get_union_ref;
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

@shared = $lcmsh->get_shared;
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

$shared_ref = $lcmsh->get_shared_ref;
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

@intersection = $lcmsh->get_intersection;
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

$intersection_ref = $lcmsh->get_intersection_ref;
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

@unique = $lcmsh->get_unique(2);
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

$unique_ref = $lcmsh->get_unique_ref(2);
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
	$unique_ref = $lcmsh->get_Lonly_ref(2);
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
	@unique = $lcmsh->get_Aonly(2);
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
	$unique_ref = $lcmsh->get_Aonly_ref(2);
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

@unique = $lcmsh->get_unique;
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

$unique_ref = $lcmsh->get_unique_ref;
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
	@unique = $lcmsh->get_Lonly;
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
	$unique_ref = $lcmsh->get_Lonly_ref;
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
	@unique = $lcmsh->get_Aonly;
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
	$unique_ref = $lcmsh->get_Aonly_ref;
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

@complement = $lcmsh->get_complement(1);
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

$complement_ref = $lcmsh->get_complement_ref(1);
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
	@complement = $lcmsh->get_Ronly(1);
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
	$complement_ref = $lcmsh->get_Ronly_ref(1);
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
	@complement = $lcmsh->get_Bonly(1);
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
	$complement_ref = $lcmsh->get_Bonly_ref(1);
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

@complement = $lcmsh->get_complement;
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

$complement_ref = $lcmsh->get_complement_ref;
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
	@complement = $lcmsh->get_Ronly;
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
	$complement_ref = $lcmsh->get_Ronly_ref;
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
	@complement = $lcmsh->get_Bonly;
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
	$complement_ref = $lcmsh->get_Bonly_ref;
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

@symmetric_difference = $lcmsh->get_symmetric_difference;
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

$symmetric_difference_ref = $lcmsh->get_symmetric_difference_ref;
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

@symmetric_difference = $lcmsh->get_symdiff;
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

$symmetric_difference_ref = $lcmsh->get_symdiff_ref;
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
	@symmetric_difference = $lcmsh->get_LorRonly;
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
	$symmetric_difference_ref = $lcmsh->get_LorRonly_ref;
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
	@symmetric_difference = $lcmsh->get_AorBonly;
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
	$symmetric_difference_ref = $lcmsh->get_AorBonly_ref;
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

@nonintersection = $lcmsh->get_nonintersection;
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

$nonintersection_ref = $lcmsh->get_nonintersection_ref;
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

$LR = $lcmsh->is_LsubsetR(3,2);
ok($LR);                                # 393

$LR = $lcmsh->is_AsubsetB(3,2);
ok($LR);                                # 394

$LR = $lcmsh->is_LsubsetR(2,3);
ok(! $LR);                              # 395

$LR = $lcmsh->is_AsubsetB(2,3);
ok(! $LR);                              # 396

$LR = $lcmsh->is_LsubsetR;
ok(! $LR);                              # 397

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmsh->is_RsubsetL;
}
ok(! $RL);                              # 398

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmsh->is_BsubsetA;
}
ok(! $RL);                              # 399

$eqv = $lcmsh->is_LequivalentR(3,4);
ok($eqv);                               # 400

$eqv = $lcmsh->is_LeqvlntR(3,4);
ok($eqv);                               # 401

$eqv = $lcmsh->is_LequivalentR(2,4);
ok(! $eqv);                             # 402

$return = $lcmsh->print_subset_chart;
ok($return);                            # 403

$return = $lcmsh->print_equivalence_chart;
ok($return);                            # 404

@memb_arr = $lcmsh->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 405

@memb_arr = $lcmsh->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 406

@memb_arr = $lcmsh->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 407

@memb_arr = $lcmsh->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 408

@memb_arr = $lcmsh->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 409

@memb_arr = $lcmsh->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 410

@memb_arr = $lcmsh->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 411

@memb_arr = $lcmsh->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 412

@memb_arr = $lcmsh->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 413

@memb_arr = $lcmsh->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 414

@memb_arr = $lcmsh->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 415


$memb_arr_ref = $lcmsh->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 416

$memb_arr_ref = $lcmsh->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 417

$memb_arr_ref = $lcmsh->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 418

$memb_arr_ref = $lcmsh->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 419

$memb_arr_ref = $lcmsh->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 420

$memb_arr_ref = $lcmsh->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 421

$memb_arr_ref = $lcmsh->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 422

$memb_arr_ref = $lcmsh->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 423

$memb_arr_ref = $lcmsh->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 424

$memb_arr_ref = $lcmsh->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 425

$memb_arr_ref = $lcmsh->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 426


$memb_hash_ref = $lcmsh->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 427
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 428
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 429
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 430
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 431
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 432
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 433
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 434
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 435
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 436
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 437

$memb_hash_ref = $lcmsh->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 438
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 439
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 440
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 441
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 442
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 443
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 444
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 445
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 446
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 447
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 448


ok($lcmsh->is_member_any('abel'));      # 449
ok($lcmsh->is_member_any('baker'));     # 450
ok($lcmsh->is_member_any('camera'));    # 451
ok($lcmsh->is_member_any('delta'));     # 452
ok($lcmsh->is_member_any('edward'));    # 453
ok($lcmsh->is_member_any('fargo'));     # 454
ok($lcmsh->is_member_any('golfer'));    # 455
ok($lcmsh->is_member_any('hilton'));    # 456
ok($lcmsh->is_member_any('icon' ));     # 457
ok($lcmsh->is_member_any('jerky'));     # 458
ok(! $lcmsh->is_member_any('zebra'));   # 459

$memb_hash_ref = $lcmsh->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 460
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 461
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 462
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 463
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 464
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 465
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 466
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 467
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 468
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 469
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 470

$memb_hash_ref = $lcmsh->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 471
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 472
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 473
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 474
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 475
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 476
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 477
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 478
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 479
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 480
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 481

$vers = $lcmsh->get_version;
ok($vers);                              # 482

########## BELOW:  Tests for '-u' option ##########

my $lcmshu   = List::Compare::SeenHash->new('-u', \%h0, \%h1, \%h2, \%h3, \%h4);
ok($lcmshu);                            # 483

@union = $lcmshu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 484
ok(exists $seen{'baker'});              # 485
ok(exists $seen{'camera'});             # 486
ok(exists $seen{'delta'});              # 487
ok(exists $seen{'edward'});             # 488
ok(exists $seen{'fargo'});              # 489
ok(exists $seen{'golfer'});             # 490
ok(exists $seen{'hilton'});             # 491
ok(exists $seen{'icon'});               # 492
ok(exists $seen{'jerky'});              # 493
%seen = ();

$union_ref = $lcmshu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 494
ok(exists $seen{'baker'});              # 495
ok(exists $seen{'camera'});             # 496
ok(exists $seen{'delta'});              # 497
ok(exists $seen{'edward'});             # 498
ok(exists $seen{'fargo'});              # 499
ok(exists $seen{'golfer'});             # 500
ok(exists $seen{'hilton'});             # 501
ok(exists $seen{'icon'});               # 502
ok(exists $seen{'jerky'});              # 503
%seen = ();

@shared = $lcmshu->get_shared;
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 504
ok(exists $seen{'baker'});              # 505
ok(exists $seen{'camera'});             # 506
ok(exists $seen{'delta'});              # 507
ok(exists $seen{'edward'});             # 508
ok(exists $seen{'fargo'});              # 509
ok(exists $seen{'golfer'});             # 510
ok(exists $seen{'hilton'});             # 511
ok(exists $seen{'icon'});               # 512
ok(! exists $seen{'jerky'});            # 513
%seen = ();

$shared_ref = $lcmshu->get_shared_ref;
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 514
ok(exists $seen{'baker'});              # 515
ok(exists $seen{'camera'});             # 516
ok(exists $seen{'delta'});              # 517
ok(exists $seen{'edward'});             # 518
ok(exists $seen{'fargo'});              # 519
ok(exists $seen{'golfer'});             # 520
ok(exists $seen{'hilton'});             # 521
ok(exists $seen{'icon'});               # 522
ok(! exists $seen{'jerky'});            # 523
%seen = ();

@intersection = $lcmshu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 524
ok(! exists $seen{'baker'});            # 525
ok(! exists $seen{'camera'});           # 526
ok(! exists $seen{'delta'});            # 527
ok(! exists $seen{'edward'});           # 528
ok(exists $seen{'fargo'});              # 529
ok(exists $seen{'golfer'});             # 530
ok(! exists $seen{'hilton'});           # 531
ok(! exists $seen{'icon'});             # 532
ok(! exists $seen{'jerky'});            # 533
%seen = ();

$intersection_ref = $lcmshu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 534
ok(! exists $seen{'baker'});            # 535
ok(! exists $seen{'camera'});           # 536
ok(! exists $seen{'delta'});            # 537
ok(! exists $seen{'edward'});           # 538
ok(exists $seen{'fargo'});              # 539
ok(exists $seen{'golfer'});             # 540
ok(! exists $seen{'hilton'});           # 541
ok(! exists $seen{'icon'});             # 542
ok(! exists $seen{'jerky'});            # 543
%seen = ();

@unique = $lcmshu->get_unique(2);
$seen{$_}++ foreach (@unique);
ok(! exists $seen{'abel'});             # 544
ok(! exists $seen{'baker'});            # 545
ok(! exists $seen{'camera'});           # 546
ok(! exists $seen{'delta'});            # 547
ok(! exists $seen{'edward'});           # 548
ok(! exists $seen{'fargo'});            # 549
ok(! exists $seen{'golfer'});           # 550
ok(! exists $seen{'hilton'});           # 551
ok(! exists $seen{'icon'});             # 552
ok(exists $seen{'jerky'});              # 553
%seen = ();

$unique_ref = $lcmshu->get_unique_ref(2);
$seen{$_}++ foreach (@{$unique_ref});
ok(! exists $seen{'abel'});             # 554
ok(! exists $seen{'baker'});            # 555
ok(! exists $seen{'camera'});           # 556
ok(! exists $seen{'delta'});            # 557
ok(! exists $seen{'edward'});           # 558
ok(! exists $seen{'fargo'});            # 559
ok(! exists $seen{'golfer'});           # 560
ok(! exists $seen{'hilton'});           # 561
ok(! exists $seen{'icon'});             # 562
ok(exists $seen{'jerky'});              # 563
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmshu->get_Lonly_ref(2);
}
$seen{$_}++ foreach (@{$unique_ref});
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

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcmshu->get_Aonly(2);
}
$seen{$_}++ foreach (@unique);
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
	$unique_ref = $lcmshu->get_Aonly_ref(2);
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

@unique = $lcmshu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 594
ok(! exists $seen{'baker'});            # 595
ok(! exists $seen{'camera'});           # 596
ok(! exists $seen{'delta'});            # 597
ok(! exists $seen{'edward'});           # 598
ok(! exists $seen{'fargo'});            # 599
ok(! exists $seen{'golfer'});           # 600
ok(! exists $seen{'hilton'});           # 601
ok(! exists $seen{'icon'});             # 602
ok(! exists $seen{'jerky'});            # 603
%seen = ();

$unique_ref = $lcmshu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 604
ok(! exists $seen{'baker'});            # 605
ok(! exists $seen{'camera'});           # 606
ok(! exists $seen{'delta'});            # 607
ok(! exists $seen{'edward'});           # 608
ok(! exists $seen{'fargo'});            # 609
ok(! exists $seen{'golfer'});           # 610
ok(! exists $seen{'hilton'});           # 611
ok(! exists $seen{'icon'});             # 612
ok(! exists $seen{'jerky'});            # 613
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@unique = $lcmshu->get_Lonly;
}
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

{
	local $SIG{__WARN__} = \&_capture;
	$unique_ref = $lcmshu->get_Lonly_ref;
}
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
	@unique = $lcmshu->get_Aonly;
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
	$unique_ref = $lcmshu->get_Aonly_ref;
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

@complement = $lcmshu->get_complement(1);
$seen{$_}++ foreach (@complement);
ok(exists $seen{'abel'});               # 654
ok(! exists $seen{'baker'});            # 655
ok(! exists $seen{'camera'});           # 656
ok(! exists $seen{'delta'});            # 657
ok(! exists $seen{'edward'});           # 658
ok(! exists $seen{'fargo'});            # 659
ok(! exists $seen{'golfer'});           # 660
ok(! exists $seen{'hilton'});           # 661
ok(exists $seen{'icon'});               # 662
ok(exists $seen{'jerky'});              # 663
%seen = ();

$complement_ref = $lcmshu->get_complement_ref(1);
$seen{$_}++ foreach (@{$complement_ref});
ok(exists $seen{'abel'});               # 664
ok(! exists $seen{'baker'});            # 665
ok(! exists $seen{'camera'});           # 666
ok(! exists $seen{'delta'});            # 667
ok(! exists $seen{'edward'});           # 668
ok(! exists $seen{'fargo'});            # 669
ok(! exists $seen{'golfer'});           # 670
ok(! exists $seen{'hilton'});           # 671
ok(exists $seen{'icon'});               # 672
ok(exists $seen{'jerky'});              # 673
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmshu->get_Ronly(1);
}
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

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmshu->get_Ronly_ref(1);
}
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
	@complement = $lcmshu->get_Bonly(1);
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
	$complement_ref = $lcmshu->get_Bonly_ref(1);
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

@complement = $lcmshu->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 714
ok(! exists $seen{'baker'});            # 715
ok(! exists $seen{'camera'});           # 716
ok(! exists $seen{'delta'});            # 717
ok(! exists $seen{'edward'});           # 718
ok(! exists $seen{'fargo'});            # 719
ok(! exists $seen{'golfer'});           # 720
ok(exists $seen{'hilton'});             # 721
ok(exists $seen{'icon'});               # 722
ok(exists $seen{'jerky'});              # 723
%seen = ();

$complement_ref = $lcmshu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 724
ok(! exists $seen{'baker'});            # 725
ok(! exists $seen{'camera'});           # 726
ok(! exists $seen{'delta'});            # 727
ok(! exists $seen{'edward'});           # 728
ok(! exists $seen{'fargo'});            # 729
ok(! exists $seen{'golfer'});           # 730
ok(exists $seen{'hilton'});             # 731
ok(exists $seen{'icon'});               # 732
ok(exists $seen{'jerky'});              # 733
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@complement = $lcmshu->get_Ronly;
}
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

{
	local $SIG{__WARN__} = \&_capture;
	$complement_ref = $lcmshu->get_Ronly_ref;
}
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
	@complement = $lcmshu->get_Bonly;
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
	$complement_ref = $lcmshu->get_Bonly_ref;
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

@symmetric_difference = $lcmshu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 774
ok(! exists $seen{'baker'});            # 775
ok(! exists $seen{'camera'});           # 776
ok(! exists $seen{'delta'});            # 777
ok(! exists $seen{'edward'});           # 778
ok(! exists $seen{'fargo'});            # 779
ok(! exists $seen{'golfer'});           # 780
ok(! exists $seen{'hilton'});           # 781
ok(! exists $seen{'icon'});             # 782
ok(exists $seen{'jerky'});              # 783
%seen = ();

$symmetric_difference_ref = $lcmshu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 784
ok(! exists $seen{'baker'});            # 785
ok(! exists $seen{'camera'});           # 786
ok(! exists $seen{'delta'});            # 787
ok(! exists $seen{'edward'});           # 788
ok(! exists $seen{'fargo'});            # 789
ok(! exists $seen{'golfer'});           # 790
ok(! exists $seen{'hilton'});           # 791
ok(! exists $seen{'icon'});             # 792
ok(exists $seen{'jerky'});              # 793
%seen = ();

@symmetric_difference = $lcmshu->get_symdiff;
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

$symmetric_difference_ref = $lcmshu->get_symdiff_ref;
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

{
	local $SIG{__WARN__} = \&_capture;
	@symmetric_difference = $lcmshu->get_LorRonly;
}
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

{
	local $SIG{__WARN__} = \&_capture;
	$symmetric_difference_ref = $lcmshu->get_LorRonly_ref;
}
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
	@symmetric_difference = $lcmshu->get_AorBonly;
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
	$symmetric_difference_ref = $lcmshu->get_AorBonly_ref;
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

@nonintersection = $lcmshu->get_nonintersection;
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 854
ok(exists $seen{'baker'});              # 855
ok(exists $seen{'camera'});             # 856
ok(exists $seen{'delta'});              # 857
ok(exists $seen{'edward'});             # 858
ok(! exists $seen{'fargo'});            # 859
ok(! exists $seen{'golfer'});           # 860
ok(exists $seen{'hilton'});             # 861
ok(exists $seen{'icon'});               # 862
ok(exists $seen{'jerky'});              # 863
%seen = ();

$nonintersection_ref = $lcmshu->get_nonintersection_ref;
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 864
ok(exists $seen{'baker'});              # 865
ok(exists $seen{'camera'});             # 866
ok(exists $seen{'delta'});              # 867
ok(exists $seen{'edward'});             # 868
ok(! exists $seen{'fargo'});            # 869
ok(! exists $seen{'golfer'});           # 870
ok(exists $seen{'hilton'});             # 871
ok(exists $seen{'icon'});               # 872
ok(exists $seen{'jerky'});              # 873
%seen = ();

$LR = $lcmshu->is_LsubsetR(3,2);
ok($LR);                                # 874

$LR = $lcmshu->is_AsubsetB(3,2);
ok($LR);                                # 875

$LR = $lcmshu->is_LsubsetR(2,3);
ok(! $LR);                              # 876

$LR = $lcmshu->is_AsubsetB(2,3);
ok(! $LR);                              # 877

$LR = $lcmshu->is_LsubsetR;
ok(! $LR);                              # 878

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmshu->is_RsubsetL;
}
ok(! $RL);                              # 879

{
	local $SIG{__WARN__} = \&_capture;
	$RL = $lcmshu->is_BsubsetA;
}
ok(! $RL);                              # 880

$eqv = $lcmshu->is_LequivalentR(3,4);
ok($eqv);                               # 881

$eqv = $lcmshu->is_LeqvlntR(3,4);
ok($eqv);                               # 882

$eqv = $lcmshu->is_LequivalentR(2,4);
ok(! $eqv);                             # 883

$return = $lcmshu->print_subset_chart;
ok($return);                            # 884

$return = $lcmshu->print_equivalence_chart;
ok($return);                            # 885

@memb_arr = $lcmshu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0        > ] ));# 886

@memb_arr = $lcmshu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1      > ] ));# 887

@memb_arr = $lcmshu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1      > ] ));# 888

@memb_arr = $lcmshu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1      > ] ));# 889

@memb_arr = $lcmshu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1      > ] ));# 890

@memb_arr = $lcmshu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 891

@memb_arr = $lcmshu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 892

@memb_arr = $lcmshu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 893

@memb_arr = $lcmshu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   3, [ qw<     2 3 4 > ] ));# 894

@memb_arr = $lcmshu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  1, [ qw<     2     > ] ));# 895

@memb_arr = $lcmshu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<           > ] ));# 896


$memb_arr_ref = $lcmshu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0        > ] ));# 897

$memb_arr_ref = $lcmshu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1      > ] ));# 898

$memb_arr_ref = $lcmshu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1      > ] ));# 899

$memb_arr_ref = $lcmshu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1      > ] ));# 900

$memb_arr_ref = $lcmshu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1      > ] ));# 901

$memb_arr_ref = $lcmshu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 902

$memb_arr_ref = $lcmshu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 903

$memb_arr_ref = $lcmshu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 904

$memb_arr_ref = $lcmshu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 905

$memb_arr_ref = $lcmshu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  1, [ qw<     2     > ] ));# 906

$memb_arr_ref = $lcmshu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<           > ] ));# 907


$memb_hash_ref = $lcmshu->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 908
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 909
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 910
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 911
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 912
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 913
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 914
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 915
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 916
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 917
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 918

$memb_hash_ref = $lcmshu->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0         > ] ));# 919
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1       > ] ));# 920
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1       > ] ));# 921
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1       > ] ));# 922
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1       > ] ));# 923
ok(ok_seen_h( $memb_hash_ref, 'fargo',  5, [ qw< 0 1 2 3 4 > ] ));# 924
ok(ok_seen_h( $memb_hash_ref, 'golfer', 5, [ qw< 0 1 2 3 4 > ] ));# 925
ok(ok_seen_h( $memb_hash_ref, 'hilton', 4, [ qw<   1 2 3 4 > ] ));# 926
ok(ok_seen_h( $memb_hash_ref, 'icon',   3, [ qw<     2 3 4 > ] ));# 927
ok(ok_seen_h( $memb_hash_ref, 'jerky',  1, [ qw<     2     > ] ));# 928
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<           > ] ));# 929


ok($lcmshu->is_member_any('abel'));     # 930
ok($lcmshu->is_member_any('baker'));    # 931
ok($lcmshu->is_member_any('camera'));   # 932
ok($lcmshu->is_member_any('delta'));    # 933
ok($lcmshu->is_member_any('edward'));   # 934
ok($lcmshu->is_member_any('fargo'));    # 935
ok($lcmshu->is_member_any('golfer'));   # 936
ok($lcmshu->is_member_any('hilton'));   # 937
ok($lcmshu->is_member_any('icon' ));    # 938
ok($lcmshu->is_member_any('jerky'));    # 939
ok(! $lcmshu->is_member_any('zebra'));  # 940

$memb_hash_ref = $lcmshu->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 941
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 942
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 943
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 944
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 945
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 946
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 947
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 948
ok(ok_any_h( $memb_hash_ref, 'icon',   1 ));# 949
ok(ok_any_h( $memb_hash_ref, 'jerky',  1 ));# 950
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 951

$memb_hash_ref = $lcmshu->are_members_any( [ qw| abel baker camera delta edward fargo 
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

$vers = $lcmshu->get_version;
ok($vers);                              # 963

########## BELOW:  Tests for '--unsorted' option ##########

my $lcmshun   = List::Compare::SeenHash->new('--unsorted', \%h0, \%h1, \%h2, \%h3, \%h4);
ok($lcmshun);                           # 964

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare::SeenHash->new(\%h0, \%h5, \%h6) };
ok(ok_capture_error($@));               # 965

eval { $f6 = List::Compare::SeenHash->new(\%h0, \%h6, \%h7) };
ok(ok_capture_error($@));               # 966

eval { $f7 = List::Compare::SeenHash->new(\%h6, \%h7, \%h0) };
ok(ok_capture_error($@));               # 967


