# 22_alt_construct_accelerated_sh_rev.t # as of 8/4/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
888;
use lib ("./t");
use List::Compare;
use Test::ListCompareSpecial qw(:seen);

$loaded = 1;
ok($loaded);                            # 1
######################### End of black magic.

my %seen = ();
my (@unique, @complement, @intersection, @union, @symmetric_difference);
my ($unique_ref, $complement_ref, $intersection_ref, $union_ref, $symmetric_difference_ref);
my ($LR, $RL, $eqv, $disj, $return);
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

my %h8 = map {$_, 1} qw(kappa lambda mu);

my $lcsha   = List::Compare->new( { accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcsha);                             # 2

@union = $lcsha->get_union;
ok($union[0] eq 'abel');                # 3
ok($union[1] eq 'baker');               # 4
ok($union[2] eq 'camera');              # 5
ok($union[3] eq 'delta');               # 6
ok($union[4] eq 'edward');              # 7
ok($union[5] eq 'fargo');               # 8
ok($union[6] eq 'golfer');              # 9
ok($union[-1] eq 'hilton');             # 10

$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 11
ok(exists $seen{'baker'});              # 12
ok(exists $seen{'camera'});             # 13
ok(exists $seen{'delta'});              # 14
ok(exists $seen{'edward'});             # 15
ok(exists $seen{'fargo'});              # 16
ok(exists $seen{'golfer'});             # 17
ok(exists $seen{'hilton'});             # 18
ok(! exists $seen{'icon'});             # 19
ok(! exists $seen{'jerky'});            # 20
%seen = ();

$union_ref = $lcsha->get_union_ref;
ok(${$union_ref}[0] eq 'abel');         # 21
ok(${$union_ref}[1] eq 'baker');        # 22
ok(${$union_ref}[2] eq 'camera');       # 23
ok(${$union_ref}[3] eq 'delta');        # 24
ok(${$union_ref}[4] eq 'edward');       # 25
ok(${$union_ref}[5] eq 'fargo');        # 26
ok(${$union_ref}[6] eq 'golfer');       # 27
ok(${$union_ref}[-1] eq 'hilton');      # 28

$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 29
ok(exists $seen{'baker'});              # 30
ok(exists $seen{'camera'});             # 31
ok(exists $seen{'delta'});              # 32
ok(exists $seen{'edward'});             # 33
ok(exists $seen{'fargo'});              # 34
ok(exists $seen{'golfer'});             # 35
ok(exists $seen{'hilton'});             # 36
ok(! exists $seen{'icon'});             # 37
ok(! exists $seen{'jerky'});            # 38
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @shared = $lcsha->get_shared;
}
ok($shared[0] eq 'abel');               # 39
ok($shared[1] eq 'baker');              # 40
ok($shared[2] eq 'camera');             # 41
ok($shared[3] eq 'delta');              # 42
ok($shared[4] eq 'edward');             # 43
ok($shared[5] eq 'fargo');              # 44
ok($shared[6] eq 'golfer');             # 45
ok($shared[-1] eq 'hilton');            # 46

$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 47
ok(exists $seen{'baker'});              # 48
ok(exists $seen{'camera'});             # 49
ok(exists $seen{'delta'});              # 50
ok(exists $seen{'edward'});             # 51
ok(exists $seen{'fargo'});              # 52
ok(exists $seen{'golfer'});             # 53
ok(exists $seen{'hilton'});             # 54
ok(! exists $seen{'icon'});             # 55
ok(! exists $seen{'jerky'});            # 56
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $shared_ref = $lcsha->get_shared_ref;
}
ok(${$shared_ref}[0] eq 'abel');        # 57
ok(${$shared_ref}[1] eq 'baker');       # 58
ok(${$shared_ref}[2] eq 'camera');      # 59
ok(${$shared_ref}[3] eq 'delta');       # 60
ok(${$shared_ref}[4] eq 'edward');      # 61
ok(${$shared_ref}[5] eq 'fargo');       # 62
ok(${$shared_ref}[6] eq 'golfer');      # 63
ok(${$shared_ref}[-1] eq 'hilton');     # 64

$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 65
ok(exists $seen{'baker'});              # 66
ok(exists $seen{'camera'});             # 67
ok(exists $seen{'delta'});              # 68
ok(exists $seen{'edward'});             # 69
ok(exists $seen{'fargo'});              # 70
ok(exists $seen{'golfer'});             # 71
ok(exists $seen{'hilton'});             # 72
ok(! exists $seen{'icon'});             # 73
ok(! exists $seen{'jerky'});            # 74
%seen = ();

@intersection = $lcsha->get_intersection;
ok($intersection[0] eq 'baker');        # 75
ok($intersection[1] eq 'camera');       # 76
ok($intersection[2] eq 'delta');        # 77
ok($intersection[3] eq 'edward');       # 78
ok($intersection[4] eq 'fargo');        # 79
ok($intersection[-1] eq 'golfer');      # 80

$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 81
ok(exists $seen{'baker'});              # 82
ok(exists $seen{'camera'});             # 83
ok(exists $seen{'delta'});              # 84
ok(exists $seen{'edward'});             # 85
ok(exists $seen{'fargo'});              # 86
ok(exists $seen{'golfer'});             # 87
ok(! exists $seen{'hilton'});           # 88
ok(! exists $seen{'icon'});             # 89
ok(! exists $seen{'jerky'});            # 90
%seen = ();

$intersection_ref = $lcsha->get_intersection_ref;
ok(${$intersection_ref}[0] eq 'baker'); # 91
ok(${$intersection_ref}[1] eq 'camera');# 92
ok(${$intersection_ref}[2] eq 'delta'); # 93
ok(${$intersection_ref}[3] eq 'edward');# 94
ok(${$intersection_ref}[4] eq 'fargo'); # 95
ok(${$intersection_ref}[-1] eq 'golfer');# 96

$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 97
ok(exists $seen{'baker'});              # 98
ok(exists $seen{'camera'});             # 99
ok(exists $seen{'delta'});              # 100
ok(exists $seen{'edward'});             # 101
ok(exists $seen{'fargo'});              # 102
ok(exists $seen{'golfer'});             # 103
ok(! exists $seen{'hilton'});           # 104
ok(! exists $seen{'icon'});             # 105
ok(! exists $seen{'jerky'});            # 106
%seen = ();

@unique = $lcsha->get_unique;
ok($unique[-1] eq 'abel');              # 107

$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 108
ok(! exists $seen{'baker'});            # 109
ok(! exists $seen{'camera'});           # 110
ok(! exists $seen{'delta'});            # 111
ok(! exists $seen{'edward'});           # 112
ok(! exists $seen{'fargo'});            # 113
ok(! exists $seen{'golfer'});           # 114
ok(! exists $seen{'hilton'});           # 115
ok(! exists $seen{'icon'});             # 116
ok(! exists $seen{'jerky'});            # 117
%seen = ();

$unique_ref = $lcsha->get_unique_ref;
ok(${$unique_ref}[-1] eq 'abel');       # 118

$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 119
ok(! exists $seen{'baker'});            # 120
ok(! exists $seen{'camera'});           # 121
ok(! exists $seen{'delta'});            # 122
ok(! exists $seen{'edward'});           # 123
ok(! exists $seen{'fargo'});            # 124
ok(! exists $seen{'golfer'});           # 125
ok(! exists $seen{'hilton'});           # 126
ok(! exists $seen{'icon'});             # 127
ok(! exists $seen{'jerky'});            # 128
%seen = ();

@unique = $lcsha->get_Lonly;
ok($unique[-1] eq 'abel');              # 129

$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 130
ok(! exists $seen{'baker'});            # 131
ok(! exists $seen{'camera'});           # 132
ok(! exists $seen{'delta'});            # 133
ok(! exists $seen{'edward'});           # 134
ok(! exists $seen{'fargo'});            # 135
ok(! exists $seen{'golfer'});           # 136
ok(! exists $seen{'hilton'});           # 137
ok(! exists $seen{'icon'});             # 138
ok(! exists $seen{'jerky'});            # 139
%seen = ();

$unique_ref = $lcsha->get_Lonly_ref;
ok(${$unique_ref}[-1] eq 'abel');       # 140

$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 141
ok(! exists $seen{'baker'});            # 142
ok(! exists $seen{'camera'});           # 143
ok(! exists $seen{'delta'});            # 144
ok(! exists $seen{'edward'});           # 145
ok(! exists $seen{'fargo'});            # 146
ok(! exists $seen{'golfer'});           # 147
ok(! exists $seen{'hilton'});           # 148
ok(! exists $seen{'icon'});             # 149
ok(! exists $seen{'jerky'});            # 150
%seen = ();

@unique = $lcsha->get_Aonly;
ok($unique[-1] eq 'abel');              # 151

$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 152
ok(! exists $seen{'baker'});            # 153
ok(! exists $seen{'camera'});           # 154
ok(! exists $seen{'delta'});            # 155
ok(! exists $seen{'edward'});           # 156
ok(! exists $seen{'fargo'});            # 157
ok(! exists $seen{'golfer'});           # 158
ok(! exists $seen{'hilton'});           # 159
ok(! exists $seen{'icon'});             # 160
ok(! exists $seen{'jerky'});            # 161
%seen = ();

$unique_ref = $lcsha->get_Aonly_ref;
ok(${$unique_ref}[-1] eq 'abel');       # 162

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

@complement = $lcsha->get_complement;
ok($complement[-1] eq 'hilton');        # 173

$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 174
ok(! exists $seen{'baker'});            # 175
ok(! exists $seen{'camera'});           # 176
ok(! exists $seen{'delta'});            # 177
ok(! exists $seen{'edward'});           # 178
ok(! exists $seen{'fargo'});            # 179
ok(! exists $seen{'golfer'});           # 180
ok(exists $seen{'hilton'});             # 181
ok(! exists $seen{'icon'});             # 182
ok(! exists $seen{'jerky'});            # 183
%seen = ();

$complement_ref = $lcsha->get_complement_ref;
ok(${$complement_ref}[-1] eq 'hilton'); # 184

$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 185
ok(! exists $seen{'baker'});            # 186
ok(! exists $seen{'camera'});           # 187
ok(! exists $seen{'delta'});            # 188
ok(! exists $seen{'edward'});           # 189
ok(! exists $seen{'fargo'});            # 190
ok(! exists $seen{'golfer'});           # 191
ok(exists $seen{'hilton'});             # 192
ok(! exists $seen{'icon'});             # 193
ok(! exists $seen{'jerky'});            # 194
%seen = ();

@complement = $lcsha->get_Ronly;
ok($complement[-1] eq 'hilton');        # 195

$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 196
ok(! exists $seen{'baker'});            # 197
ok(! exists $seen{'camera'});           # 198
ok(! exists $seen{'delta'});            # 199
ok(! exists $seen{'edward'});           # 200
ok(! exists $seen{'fargo'});            # 201
ok(! exists $seen{'golfer'});           # 202
ok(exists $seen{'hilton'});             # 203
ok(! exists $seen{'icon'});             # 204
ok(! exists $seen{'jerky'});            # 205
%seen = ();

$complement_ref = $lcsha->get_Ronly_ref;
ok(${$complement_ref}[-1] eq 'hilton'); # 206

$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 207
ok(! exists $seen{'baker'});            # 208
ok(! exists $seen{'camera'});           # 209
ok(! exists $seen{'delta'});            # 210
ok(! exists $seen{'edward'});           # 211
ok(! exists $seen{'fargo'});            # 212
ok(! exists $seen{'golfer'});           # 213
ok(exists $seen{'hilton'});             # 214
ok(! exists $seen{'icon'});             # 215
ok(! exists $seen{'jerky'});            # 216
%seen = ();

@complement = $lcsha->get_Bonly;
ok($complement[-1] eq 'hilton');        # 217

$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 218
ok(! exists $seen{'baker'});            # 219
ok(! exists $seen{'camera'});           # 220
ok(! exists $seen{'delta'});            # 221
ok(! exists $seen{'edward'});           # 222
ok(! exists $seen{'fargo'});            # 223
ok(! exists $seen{'golfer'});           # 224
ok(exists $seen{'hilton'});             # 225
ok(! exists $seen{'icon'});             # 226
ok(! exists $seen{'jerky'});            # 227
%seen = ();

$complement_ref = $lcsha->get_Bonly_ref;
ok(${$complement_ref}[-1] eq 'hilton'); # 228

$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 229
ok(! exists $seen{'baker'});            # 230
ok(! exists $seen{'camera'});           # 231
ok(! exists $seen{'delta'});            # 232
ok(! exists $seen{'edward'});           # 233
ok(! exists $seen{'fargo'});            # 234
ok(! exists $seen{'golfer'});           # 235
ok(exists $seen{'hilton'});             # 236
ok(! exists $seen{'icon'});             # 237
ok(! exists $seen{'jerky'});            # 238
%seen = ();

@symmetric_difference = $lcsha->get_symmetric_difference;
ok($symmetric_difference[0] eq 'abel'); # 239
ok($symmetric_difference[-1] eq 'hilton');# 240

$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 241
ok(! exists $seen{'baker'});            # 242
ok(! exists $seen{'camera'});           # 243
ok(! exists $seen{'delta'});            # 244
ok(! exists $seen{'edward'});           # 245
ok(! exists $seen{'fargo'});            # 246
ok(! exists $seen{'golfer'});           # 247
ok(exists $seen{'hilton'});             # 248
ok(! exists $seen{'icon'});             # 249
ok(! exists $seen{'jerky'});            # 250
%seen = ();

$symmetric_difference_ref = $lcsha->get_symmetric_difference_ref;
ok(${$symmetric_difference_ref}[0] eq 'abel');# 251
ok(${$symmetric_difference_ref}[-1] eq 'hilton');# 252

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

@symmetric_difference = $lcsha->get_symdiff;
ok($symmetric_difference[0] eq 'abel'); # 263
ok($symmetric_difference[-1] eq 'hilton');# 264

$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 265
ok(! exists $seen{'baker'});            # 266
ok(! exists $seen{'camera'});           # 267
ok(! exists $seen{'delta'});            # 268
ok(! exists $seen{'edward'});           # 269
ok(! exists $seen{'fargo'});            # 270
ok(! exists $seen{'golfer'});           # 271
ok(exists $seen{'hilton'});             # 272
ok(! exists $seen{'icon'});             # 273
ok(! exists $seen{'jerky'});            # 274
%seen = ();

$symmetric_difference_ref = $lcsha->get_symdiff_ref;
ok(${$symmetric_difference_ref}[0] eq 'abel');# 275
ok(${$symmetric_difference_ref}[-1] eq 'hilton');# 276

$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 277
ok(! exists $seen{'baker'});            # 278
ok(! exists $seen{'camera'});           # 279
ok(! exists $seen{'delta'});            # 280
ok(! exists $seen{'edward'});           # 281
ok(! exists $seen{'fargo'});            # 282
ok(! exists $seen{'golfer'});           # 283
ok(exists $seen{'hilton'});             # 284
ok(! exists $seen{'icon'});             # 285
ok(! exists $seen{'jerky'});            # 286
%seen = ();

@symmetric_difference = $lcsha->get_LorRonly;
ok($symmetric_difference[0] eq 'abel'); # 287
ok($symmetric_difference[-1] eq 'hilton');# 288

$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 289
ok(! exists $seen{'baker'});            # 290
ok(! exists $seen{'camera'});           # 291
ok(! exists $seen{'delta'});            # 292
ok(! exists $seen{'edward'});           # 293
ok(! exists $seen{'fargo'});            # 294
ok(! exists $seen{'golfer'});           # 295
ok(exists $seen{'hilton'});             # 296
ok(! exists $seen{'icon'});             # 297
ok(! exists $seen{'jerky'});            # 298
%seen = ();

$symmetric_difference_ref = $lcsha->get_LorRonly_ref;
ok(${$symmetric_difference_ref}[0] eq 'abel');# 299
ok(${$symmetric_difference_ref}[-1] eq 'hilton');# 300

$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 301
ok(! exists $seen{'baker'});            # 302
ok(! exists $seen{'camera'});           # 303
ok(! exists $seen{'delta'});            # 304
ok(! exists $seen{'edward'});           # 305
ok(! exists $seen{'fargo'});            # 306
ok(! exists $seen{'golfer'});           # 307
ok(exists $seen{'hilton'});             # 308
ok(! exists $seen{'icon'});             # 309
ok(! exists $seen{'jerky'});            # 310
%seen = ();

@symmetric_difference = $lcsha->get_AorBonly;
ok($symmetric_difference[0] eq 'abel'); # 311
ok($symmetric_difference[-1] eq 'hilton');# 312

$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lcsha->get_AorBonly_ref;
ok(${$symmetric_difference_ref}[0] eq 'abel');# 323
ok(${$symmetric_difference_ref}[-1] eq 'hilton');# 324

$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 325
ok(! exists $seen{'baker'});            # 326
ok(! exists $seen{'camera'});           # 327
ok(! exists $seen{'delta'});            # 328
ok(! exists $seen{'edward'});           # 329
ok(! exists $seen{'fargo'});            # 330
ok(! exists $seen{'golfer'});           # 331
ok(exists $seen{'hilton'});             # 332
ok(! exists $seen{'icon'});             # 333
ok(! exists $seen{'jerky'});            # 334
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @nonintersection = $lcsha->get_nonintersection;
}
ok($nonintersection[0] eq 'abel');      # 335
ok($nonintersection[-1] eq 'hilton');   # 336

$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 337
ok(! exists $seen{'baker'});            # 338
ok(! exists $seen{'camera'});           # 339
ok(! exists $seen{'delta'});            # 340
ok(! exists $seen{'edward'});           # 341
ok(! exists $seen{'fargo'});            # 342
ok(! exists $seen{'golfer'});           # 343
ok(exists $seen{'hilton'});             # 344
ok(! exists $seen{'icon'});             # 345
ok(! exists $seen{'jerky'});            # 346
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $nonintersection_ref = $lcsha->get_nonintersection_ref;
}
ok(${$nonintersection_ref}[0] eq 'abel');# 347
ok(${$nonintersection_ref}[-1] eq 'hilton');# 348

$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 349
ok(! exists $seen{'baker'});            # 350
ok(! exists $seen{'camera'});           # 351
ok(! exists $seen{'delta'});            # 352
ok(! exists $seen{'edward'});           # 353
ok(! exists $seen{'fargo'});            # 354
ok(! exists $seen{'golfer'});           # 355
ok(exists $seen{'hilton'});             # 356
ok(! exists $seen{'icon'});             # 357
ok(! exists $seen{'jerky'});            # 358
%seen = ();

@bag = $lcsha->get_bag;
ok($bag[0] eq 'abel');                  # 359
ok($bag[1] eq 'abel');                  # 360
ok($bag[2] eq 'baker');                 # 361
ok($bag[3] eq 'baker');                 # 362
ok($bag[4] eq 'camera');                # 363
ok($bag[5] eq 'camera');                # 364
ok($bag[6] eq 'delta');                 # 365
ok($bag[7] eq 'delta');                 # 366
ok($bag[8] eq 'delta');                 # 367
ok($bag[9] eq 'edward');                # 368
ok($bag[10] eq 'edward');               # 369
ok($bag[11] eq 'fargo');                # 370
ok($bag[12] eq 'fargo');                # 371
ok($bag[13] eq 'golfer');               # 372
ok($bag[14] eq 'golfer');               # 373
ok($bag[-1] eq 'hilton');               # 374

$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 375
ok($seen{'baker'} == 2);                # 376
ok($seen{'camera'} == 2);               # 377
ok($seen{'delta'} == 3);                # 378
ok($seen{'edward'} == 2);               # 379
ok($seen{'fargo'} == 2);                # 380
ok($seen{'golfer'} == 2);               # 381
ok($seen{'hilton'} == 1);               # 382
ok(! exists $seen{'icon'});             # 383
ok(! exists $seen{'jerky'});            # 384
%seen = ();

$bag_ref = $lcsha->get_bag_ref;
ok(${$bag_ref}[0] eq 'abel');           # 385
ok(${$bag_ref}[1] eq 'abel');           # 386
ok(${$bag_ref}[2] eq 'baker');          # 387
ok(${$bag_ref}[3] eq 'baker');          # 388
ok(${$bag_ref}[4] eq 'camera');         # 389
ok(${$bag_ref}[5] eq 'camera');         # 390
ok(${$bag_ref}[6] eq 'delta');          # 391
ok(${$bag_ref}[7] eq 'delta');          # 392
ok(${$bag_ref}[8] eq 'delta');          # 393
ok(${$bag_ref}[9] eq 'edward');         # 394
ok(${$bag_ref}[10] eq 'edward');        # 395
ok(${$bag_ref}[11] eq 'fargo');         # 396
ok(${$bag_ref}[12] eq 'fargo');         # 397
ok(${$bag_ref}[13] eq 'golfer');        # 398
ok(${$bag_ref}[14] eq 'golfer');        # 399
ok(${$bag_ref}[-1] eq 'hilton');        # 400

$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 401
ok($seen{'baker'} == 2);                # 402
ok($seen{'camera'} == 2);               # 403
ok($seen{'delta'} == 3);                # 404
ok($seen{'edward'} == 2);               # 405
ok($seen{'fargo'} == 2);                # 406
ok($seen{'golfer'} == 2);               # 407
ok($seen{'hilton'} == 1);               # 408
ok(! exists $seen{'icon'});             # 409
ok(! exists $seen{'jerky'});            # 410
%seen = ();

$LR = $lcsha->is_LsubsetR;
ok(! $LR);                              # 411

$LR = $lcsha->is_AsubsetB;
ok(! $LR);                              # 412

$RL = $lcsha->is_RsubsetL;
ok(! $RL);                              # 413

$RL = $lcsha->is_BsubsetA;
ok(! $RL);                              # 414

$eqv = $lcsha->is_LequivalentR;
ok(! $eqv);                             # 415

$eqv = $lcsha->is_LeqvlntR;
ok(! $eqv);                             # 416

$disj = $lcsha->is_LdisjointR;
ok(! $disj);                            # 417

$return = $lcsha->print_subset_chart;
ok($return);                            # 418

$return = $lcsha->print_equivalence_chart;
ok($return);                            # 419

@memb_arr = $lcsha->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 420

@memb_arr = $lcsha->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 421

@memb_arr = $lcsha->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 422

@memb_arr = $lcsha->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 423

@memb_arr = $lcsha->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 424

@memb_arr = $lcsha->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 425

@memb_arr = $lcsha->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 426

@memb_arr = $lcsha->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 427

@memb_arr = $lcsha->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 428

@memb_arr = $lcsha->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 429

@memb_arr = $lcsha->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 430

$memb_arr_ref = $lcsha->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 431

$memb_arr_ref = $lcsha->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 432

$memb_arr_ref = $lcsha->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 433

$memb_arr_ref = $lcsha->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 434

$memb_arr_ref = $lcsha->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 435

$memb_arr_ref = $lcsha->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 436

$memb_arr_ref = $lcsha->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 437

$memb_arr_ref = $lcsha->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 438

$memb_arr_ref = $lcsha->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 439

$memb_arr_ref = $lcsha->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 440

$memb_arr_ref = $lcsha->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 441

$memb_hash_ref = $lcsha->are_members_which(
    [ qw| abel baker camera delta edward fargo 
      golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 442
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 443
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 444
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 445
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 446
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 447
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 448
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 449
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 450
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 451
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 452

ok($lcsha->is_member_any('abel'));      # 453
ok($lcsha->is_member_any('baker'));     # 454
ok($lcsha->is_member_any('camera'));    # 455
ok($lcsha->is_member_any('delta'));     # 456
ok($lcsha->is_member_any('edward'));    # 457
ok($lcsha->is_member_any('fargo'));     # 458
ok($lcsha->is_member_any('golfer'));    # 459
ok($lcsha->is_member_any('hilton'));    # 460
ok(! $lcsha->is_member_any('icon' ));   # 461
ok(! $lcsha->is_member_any('jerky'));   # 462
ok(! $lcsha->is_member_any('zebra'));   # 463

$memb_hash_ref = $lcsha->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 464
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 465
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 466
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 467
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 468
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 469
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 470
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 471
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 472
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 473
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 474

$vers = $lcsha->get_version;
ok($vers);                              # 475

my $lcsha_s  = List::Compare->new( { accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcsha_s);                           # 476

$LR = $lcsha_s->is_LsubsetR;
ok(! $LR);                              # 477

$LR = $lcsha_s->is_AsubsetB;
ok(! $LR);                              # 478

$RL = $lcsha_s->is_RsubsetL;
ok($RL);                                # 479

$RL = $lcsha_s->is_BsubsetA;
ok($RL);                                # 480

$eqv = $lcsha_s->is_LequivalentR;
ok(! $eqv);                             # 481

$eqv = $lcsha_s->is_LeqvlntR;
ok(! $eqv);                             # 482

$disj = $lcsha_s->is_LdisjointR;
ok(! $disj);                            # 483

my $lcsha_e  = List::Compare->new( { accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcsha_e);                           # 484

$eqv = $lcsha_e->is_LequivalentR;
ok($eqv);                               # 485

$eqv = $lcsha_e->is_LeqvlntR;
ok($eqv);                               # 486

$disj = $lcsha_e->is_LdisjointR;
ok(! $disj);                            # 487

my $lcsha_dj  = List::Compare->new( { accelerated => 1, lists => [\%h4, \%h8] } );

ok($lcsha_dj);                          # 488

ok(0 == $lcsha_dj->get_intersection);   # 489
ok(0 == scalar(@{$lcsha_dj->get_intersection_ref}));# 490
$disj = $lcsha_dj->is_LdisjointR;
ok($disj);                              # 491

########## BELOW:  Tests for '--accelerated' option ##########

my $lcshacc   = List::Compare->new( { accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcshacc);                           # 492

my $lcshacc_s  = List::Compare->new( { accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcshacc_s);                         # 493

my $lcshacc_e  = List::Compare->new( { accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcshacc_e);                         # 494

########## BELOW:  Tests for '-u' option ##########

my $lcshau   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcshau);                            # 495

@union = $lcshau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 496
ok(exists $seen{'baker'});              # 497
ok(exists $seen{'camera'});             # 498
ok(exists $seen{'delta'});              # 499
ok(exists $seen{'edward'});             # 500
ok(exists $seen{'fargo'});              # 501
ok(exists $seen{'golfer'});             # 502
ok(exists $seen{'hilton'});             # 503
ok(! exists $seen{'icon'});             # 504
ok(! exists $seen{'jerky'});            # 505
%seen = ();

$union_ref = $lcshau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 506
ok(exists $seen{'baker'});              # 507
ok(exists $seen{'camera'});             # 508
ok(exists $seen{'delta'});              # 509
ok(exists $seen{'edward'});             # 510
ok(exists $seen{'fargo'});              # 511
ok(exists $seen{'golfer'});             # 512
ok(exists $seen{'hilton'});             # 513
ok(! exists $seen{'icon'});             # 514
ok(! exists $seen{'jerky'});            # 515
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @shared = $lcshau->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 516
ok(exists $seen{'baker'});              # 517
ok(exists $seen{'camera'});             # 518
ok(exists $seen{'delta'});              # 519
ok(exists $seen{'edward'});             # 520
ok(exists $seen{'fargo'});              # 521
ok(exists $seen{'golfer'});             # 522
ok(exists $seen{'hilton'});             # 523
ok(! exists $seen{'icon'});             # 524
ok(! exists $seen{'jerky'});            # 525
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $shared_ref = $lcshau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 526
ok(exists $seen{'baker'});              # 527
ok(exists $seen{'camera'});             # 528
ok(exists $seen{'delta'});              # 529
ok(exists $seen{'edward'});             # 530
ok(exists $seen{'fargo'});              # 531
ok(exists $seen{'golfer'});             # 532
ok(exists $seen{'hilton'});             # 533
ok(! exists $seen{'icon'});             # 534
ok(! exists $seen{'jerky'});            # 535
%seen = ();

@intersection = $lcshau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 536
ok(exists $seen{'baker'});              # 537
ok(exists $seen{'camera'});             # 538
ok(exists $seen{'delta'});              # 539
ok(exists $seen{'edward'});             # 540
ok(exists $seen{'fargo'});              # 541
ok(exists $seen{'golfer'});             # 542
ok(! exists $seen{'hilton'});           # 543
ok(! exists $seen{'icon'});             # 544
ok(! exists $seen{'jerky'});            # 545
%seen = ();

$intersection_ref = $lcshau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 546
ok(exists $seen{'baker'});              # 547
ok(exists $seen{'camera'});             # 548
ok(exists $seen{'delta'});              # 549
ok(exists $seen{'edward'});             # 550
ok(exists $seen{'fargo'});              # 551
ok(exists $seen{'golfer'});             # 552
ok(! exists $seen{'hilton'});           # 553
ok(! exists $seen{'icon'});             # 554
ok(! exists $seen{'jerky'});            # 555
%seen = ();

@unique = $lcshau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 556
ok(! exists $seen{'baker'});            # 557
ok(! exists $seen{'camera'});           # 558
ok(! exists $seen{'delta'});            # 559
ok(! exists $seen{'edward'});           # 560
ok(! exists $seen{'fargo'});            # 561
ok(! exists $seen{'golfer'});           # 562
ok(! exists $seen{'hilton'});           # 563
ok(! exists $seen{'icon'});             # 564
ok(! exists $seen{'jerky'});            # 565
%seen = ();

$unique_ref = $lcshau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 566
ok(! exists $seen{'baker'});            # 567
ok(! exists $seen{'camera'});           # 568
ok(! exists $seen{'delta'});            # 569
ok(! exists $seen{'edward'});           # 570
ok(! exists $seen{'fargo'});            # 571
ok(! exists $seen{'golfer'});           # 572
ok(! exists $seen{'hilton'});           # 573
ok(! exists $seen{'icon'});             # 574
ok(! exists $seen{'jerky'});            # 575
%seen = ();

@unique = $lcshau->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 576
ok(! exists $seen{'baker'});            # 577
ok(! exists $seen{'camera'});           # 578
ok(! exists $seen{'delta'});            # 579
ok(! exists $seen{'edward'});           # 580
ok(! exists $seen{'fargo'});            # 581
ok(! exists $seen{'golfer'});           # 582
ok(! exists $seen{'hilton'});           # 583
ok(! exists $seen{'icon'});             # 584
ok(! exists $seen{'jerky'});            # 585
%seen = ();

$unique_ref = $lcshau->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 586
ok(! exists $seen{'baker'});            # 587
ok(! exists $seen{'camera'});           # 588
ok(! exists $seen{'delta'});            # 589
ok(! exists $seen{'edward'});           # 590
ok(! exists $seen{'fargo'});            # 591
ok(! exists $seen{'golfer'});           # 592
ok(! exists $seen{'hilton'});           # 593
ok(! exists $seen{'icon'});             # 594
ok(! exists $seen{'jerky'});            # 595
%seen = ();

@unique = $lcshau->get_Aonly;
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

$unique_ref = $lcshau->get_Aonly_ref;
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

@complement = $lcshau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 616
ok(! exists $seen{'baker'});            # 617
ok(! exists $seen{'camera'});           # 618
ok(! exists $seen{'delta'});            # 619
ok(! exists $seen{'edward'});           # 620
ok(! exists $seen{'fargo'});            # 621
ok(! exists $seen{'golfer'});           # 622
ok(exists $seen{'hilton'});             # 623
ok(! exists $seen{'icon'});             # 624
ok(! exists $seen{'jerky'});            # 625
%seen = ();

$complement_ref = $lcshau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 626
ok(! exists $seen{'baker'});            # 627
ok(! exists $seen{'camera'});           # 628
ok(! exists $seen{'delta'});            # 629
ok(! exists $seen{'edward'});           # 630
ok(! exists $seen{'fargo'});            # 631
ok(! exists $seen{'golfer'});           # 632
ok(exists $seen{'hilton'});             # 633
ok(! exists $seen{'icon'});             # 634
ok(! exists $seen{'jerky'});            # 635
%seen = ();

@complement = $lcshau->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 636
ok(! exists $seen{'baker'});            # 637
ok(! exists $seen{'camera'});           # 638
ok(! exists $seen{'delta'});            # 639
ok(! exists $seen{'edward'});           # 640
ok(! exists $seen{'fargo'});            # 641
ok(! exists $seen{'golfer'});           # 642
ok(exists $seen{'hilton'});             # 643
ok(! exists $seen{'icon'});             # 644
ok(! exists $seen{'jerky'});            # 645
%seen = ();

$complement_ref = $lcshau->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 646
ok(! exists $seen{'baker'});            # 647
ok(! exists $seen{'camera'});           # 648
ok(! exists $seen{'delta'});            # 649
ok(! exists $seen{'edward'});           # 650
ok(! exists $seen{'fargo'});            # 651
ok(! exists $seen{'golfer'});           # 652
ok(exists $seen{'hilton'});             # 653
ok(! exists $seen{'icon'});             # 654
ok(! exists $seen{'jerky'});            # 655
%seen = ();

@complement = $lcshau->get_Bonly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 656
ok(! exists $seen{'baker'});            # 657
ok(! exists $seen{'camera'});           # 658
ok(! exists $seen{'delta'});            # 659
ok(! exists $seen{'edward'});           # 660
ok(! exists $seen{'fargo'});            # 661
ok(! exists $seen{'golfer'});           # 662
ok(exists $seen{'hilton'});             # 663
ok(! exists $seen{'icon'});             # 664
ok(! exists $seen{'jerky'});            # 665
%seen = ();

$complement_ref = $lcshau->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 666
ok(! exists $seen{'baker'});            # 667
ok(! exists $seen{'camera'});           # 668
ok(! exists $seen{'delta'});            # 669
ok(! exists $seen{'edward'});           # 670
ok(! exists $seen{'fargo'});            # 671
ok(! exists $seen{'golfer'});           # 672
ok(exists $seen{'hilton'});             # 673
ok(! exists $seen{'icon'});             # 674
ok(! exists $seen{'jerky'});            # 675
%seen = ();

@symmetric_difference = $lcshau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 676
ok(! exists $seen{'baker'});            # 677
ok(! exists $seen{'camera'});           # 678
ok(! exists $seen{'delta'});            # 679
ok(! exists $seen{'edward'});           # 680
ok(! exists $seen{'fargo'});            # 681
ok(! exists $seen{'golfer'});           # 682
ok(exists $seen{'hilton'});             # 683
ok(! exists $seen{'icon'});             # 684
ok(! exists $seen{'jerky'});            # 685
%seen = ();

$symmetric_difference_ref = $lcshau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 686
ok(! exists $seen{'baker'});            # 687
ok(! exists $seen{'camera'});           # 688
ok(! exists $seen{'delta'});            # 689
ok(! exists $seen{'edward'});           # 690
ok(! exists $seen{'fargo'});            # 691
ok(! exists $seen{'golfer'});           # 692
ok(exists $seen{'hilton'});             # 693
ok(! exists $seen{'icon'});             # 694
ok(! exists $seen{'jerky'});            # 695
%seen = ();

@symmetric_difference = $lcshau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 696
ok(! exists $seen{'baker'});            # 697
ok(! exists $seen{'camera'});           # 698
ok(! exists $seen{'delta'});            # 699
ok(! exists $seen{'edward'});           # 700
ok(! exists $seen{'fargo'});            # 701
ok(! exists $seen{'golfer'});           # 702
ok(exists $seen{'hilton'});             # 703
ok(! exists $seen{'icon'});             # 704
ok(! exists $seen{'jerky'});            # 705
%seen = ();

$symmetric_difference_ref = $lcshau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 706
ok(! exists $seen{'baker'});            # 707
ok(! exists $seen{'camera'});           # 708
ok(! exists $seen{'delta'});            # 709
ok(! exists $seen{'edward'});           # 710
ok(! exists $seen{'fargo'});            # 711
ok(! exists $seen{'golfer'});           # 712
ok(exists $seen{'hilton'});             # 713
ok(! exists $seen{'icon'});             # 714
ok(! exists $seen{'jerky'});            # 715
%seen = ();

@symmetric_difference = $lcshau->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 716
ok(! exists $seen{'baker'});            # 717
ok(! exists $seen{'camera'});           # 718
ok(! exists $seen{'delta'});            # 719
ok(! exists $seen{'edward'});           # 720
ok(! exists $seen{'fargo'});            # 721
ok(! exists $seen{'golfer'});           # 722
ok(exists $seen{'hilton'});             # 723
ok(! exists $seen{'icon'});             # 724
ok(! exists $seen{'jerky'});            # 725
%seen = ();

$symmetric_difference_ref = $lcshau->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 726
ok(! exists $seen{'baker'});            # 727
ok(! exists $seen{'camera'});           # 728
ok(! exists $seen{'delta'});            # 729
ok(! exists $seen{'edward'});           # 730
ok(! exists $seen{'fargo'});            # 731
ok(! exists $seen{'golfer'});           # 732
ok(exists $seen{'hilton'});             # 733
ok(! exists $seen{'icon'});             # 734
ok(! exists $seen{'jerky'});            # 735
%seen = ();

@symmetric_difference = $lcshau->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 736
ok(! exists $seen{'baker'});            # 737
ok(! exists $seen{'camera'});           # 738
ok(! exists $seen{'delta'});            # 739
ok(! exists $seen{'edward'});           # 740
ok(! exists $seen{'fargo'});            # 741
ok(! exists $seen{'golfer'});           # 742
ok(exists $seen{'hilton'});             # 743
ok(! exists $seen{'icon'});             # 744
ok(! exists $seen{'jerky'});            # 745
%seen = ();

$symmetric_difference_ref = $lcshau->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 746
ok(! exists $seen{'baker'});            # 747
ok(! exists $seen{'camera'});           # 748
ok(! exists $seen{'delta'});            # 749
ok(! exists $seen{'edward'});           # 750
ok(! exists $seen{'fargo'});            # 751
ok(! exists $seen{'golfer'});           # 752
ok(exists $seen{'hilton'});             # 753
ok(! exists $seen{'icon'});             # 754
ok(! exists $seen{'jerky'});            # 755
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @nonintersection = $lcshau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 756
ok(! exists $seen{'baker'});            # 757
ok(! exists $seen{'camera'});           # 758
ok(! exists $seen{'delta'});            # 759
ok(! exists $seen{'edward'});           # 760
ok(! exists $seen{'fargo'});            # 761
ok(! exists $seen{'golfer'});           # 762
ok(exists $seen{'hilton'});             # 763
ok(! exists $seen{'icon'});             # 764
ok(! exists $seen{'jerky'});            # 765
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $nonintersection_ref = $lcshau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 766
ok(! exists $seen{'baker'});            # 767
ok(! exists $seen{'camera'});           # 768
ok(! exists $seen{'delta'});            # 769
ok(! exists $seen{'edward'});           # 770
ok(! exists $seen{'fargo'});            # 771
ok(! exists $seen{'golfer'});           # 772
ok(exists $seen{'hilton'});             # 773
ok(! exists $seen{'icon'});             # 774
ok(! exists $seen{'jerky'});            # 775
%seen = ();

@bag = $lcshau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 776
ok($seen{'baker'} == 2);                # 777
ok($seen{'camera'} == 2);               # 778
ok($seen{'delta'} == 3);                # 779
ok($seen{'edward'} == 2);               # 780
ok($seen{'fargo'} == 2);                # 781
ok($seen{'golfer'} == 2);               # 782
ok($seen{'hilton'} == 1);               # 783
ok(! exists $seen{'icon'});             # 784
ok(! exists $seen{'jerky'});            # 785
%seen = ();

$bag_ref = $lcshau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 786
ok($seen{'baker'} == 2);                # 787
ok($seen{'camera'} == 2);               # 788
ok($seen{'delta'} == 3);                # 789
ok($seen{'edward'} == 2);               # 790
ok($seen{'fargo'} == 2);                # 791
ok($seen{'golfer'} == 2);               # 792
ok($seen{'hilton'} == 1);               # 793
ok(! exists $seen{'icon'});             # 794
ok(! exists $seen{'jerky'});            # 795
%seen = ();

$LR = $lcshau->is_LsubsetR;
ok(! $LR);                              # 796

$LR = $lcshau->is_AsubsetB;
ok(! $LR);                              # 797

$RL = $lcshau->is_RsubsetL;
ok(! $RL);                              # 798

$RL = $lcshau->is_BsubsetA;
ok(! $RL);                              # 799

$eqv = $lcshau->is_LequivalentR;
ok(! $eqv);                             # 800

$eqv = $lcshau->is_LeqvlntR;
ok(! $eqv);                             # 801

$disj = $lcshau->is_LdisjointR;
ok(! $disj);                            # 802

$return = $lcshau->print_subset_chart;
ok($return);                            # 803

$return = $lcshau->print_equivalence_chart;
ok($return);                            # 804

@memb_arr = $lcshau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 805

@memb_arr = $lcshau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 806

@memb_arr = $lcshau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 807

@memb_arr = $lcshau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 808

@memb_arr = $lcshau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 809

@memb_arr = $lcshau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 810

@memb_arr = $lcshau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 811

@memb_arr = $lcshau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 812

@memb_arr = $lcshau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 813

@memb_arr = $lcshau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 814

@memb_arr = $lcshau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 815

$memb_arr_ref = $lcshau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 816

$memb_arr_ref = $lcshau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 817

$memb_arr_ref = $lcshau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 818

$memb_arr_ref = $lcshau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 819

$memb_arr_ref = $lcshau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 820

$memb_arr_ref = $lcshau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 821

$memb_arr_ref = $lcshau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 822

$memb_arr_ref = $lcshau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 823

$memb_arr_ref = $lcshau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 824

$memb_arr_ref = $lcshau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 825

$memb_arr_ref = $lcshau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 826

$memb_hash_ref = $lcshau->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 827
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 828
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 829
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 830
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 831
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 832
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 833
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 834
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 835
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 836
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 837

ok($lcshau->is_member_any('abel'));     # 838
ok($lcshau->is_member_any('baker'));    # 839
ok($lcshau->is_member_any('camera'));   # 840
ok($lcshau->is_member_any('delta'));    # 841
ok($lcshau->is_member_any('edward'));   # 842
ok($lcshau->is_member_any('fargo'));    # 843
ok($lcshau->is_member_any('golfer'));   # 844
ok($lcshau->is_member_any('hilton'));   # 845
ok(! $lcshau->is_member_any('icon' ));  # 846
ok(! $lcshau->is_member_any('jerky'));  # 847
ok(! $lcshau->is_member_any('zebra'));  # 848

$memb_hash_ref = $lcshau->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 849
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 850
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 851
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 852
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 853
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 854
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 855
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 856
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 857
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 858
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 859

$vers = $lcshau->get_version;
ok($vers);                              # 860

my $lcshau_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcshau_s);                          # 861

$LR = $lcshau_s->is_LsubsetR;
ok(! $LR);                              # 862

$LR = $lcshau_s->is_AsubsetB;
ok(! $LR);                              # 863

$RL = $lcshau_s->is_RsubsetL;
ok($RL);                                # 864

$RL = $lcshau_s->is_BsubsetA;
ok($RL);                                # 865

$eqv = $lcshau_s->is_LequivalentR;
ok(! $eqv);                             # 866

$eqv = $lcshau_s->is_LeqvlntR;
ok(! $eqv);                             # 867

$disj = $lcshau_s->is_LdisjointR;
ok(! $disj);                            # 868

my $lcshau_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcshau_e);                          # 869

$eqv = $lcshau_e->is_LequivalentR;
ok($eqv);                               # 870

$eqv = $lcshau_e->is_LeqvlntR;
ok($eqv);                               # 871

$disj = $lcshau_e->is_LdisjointR;
ok(! $disj);                            # 872

my $lcusha_dj  = List::Compare->new( { unsorted => 1, lists => [\%h4, \%h8] } );

ok($lcusha_dj);                         # 873

ok(0 == $lcusha_dj->get_intersection);  # 874
ok(0 == scalar(@{$lcusha_dj->get_intersection_ref}));# 875
$disj = $lcusha_dj->is_LdisjointR;
ok($disj);                              # 876

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcshaun   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcshaun);                           # 877

my $lcshaun_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcshaun_s);                         # 878

my $lcshaun_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcshaun_e);                         # 879

my $lcshaccun   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcshaccun);                         # 880

my $lcshaccun_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcshaccun_s);                       # 881

my $lcshaccun_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcshaccun_e);                       # 882

my $lcshaccu   = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h0, \%h1] } );
ok($lcshaccu);                          # 883

my $lcshaccu_s  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h2, \%h3] } );
ok($lcshaccu_s);                        # 884

my $lcshaccu_e  = List::Compare->new( { unsorted => 1, accelerated => 1, lists => [\%h3, \%h4] } );
ok($lcshaccu_e);                        # 885

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare->new( { accelerated => 1, lists => [\%h0, \%h5] } ) };
ok(ok_capture_error($@));               # 886

eval { $f6 = List::Compare->new( { accelerated => 1, lists => [\%h6, \%h0] } ) };
ok(ok_capture_error($@));               # 887

eval { $f7 = List::Compare->new( { accelerated => 1, lists => [\%h6, \%h7] } ) };
ok(ok_capture_error($@));               # 888






