# 14_accelerated_sh_rev.t # as of 04/25/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} 
use Test::Simple tests =>
780;
use lib ("./t");
use List::Compare;
use Test::ListCompareSpecial;
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

my $lcsha   = List::Compare->new('-a', \%h0, \%h1);
ok($lcsha);                             # 2

@union = $lcsha->get_union;
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

$union_ref = $lcsha->get_union_ref;
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
    @shared = $lcsha->get_shared;
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
    $shared_ref = $lcsha->get_shared_ref;
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

@intersection = $lcsha->get_intersection;
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

$intersection_ref = $lcsha->get_intersection_ref;
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

@unique = $lcsha->get_unique;
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

$unique_ref = $lcsha->get_unique_ref;
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

@unique = $lcsha->get_Lonly;
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

$unique_ref = $lcsha->get_Lonly_ref;
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

@unique = $lcsha->get_Aonly;
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

$unique_ref = $lcsha->get_Aonly_ref;
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

@complement = $lcsha->get_complement;
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

$complement_ref = $lcsha->get_complement_ref;
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

@complement = $lcsha->get_Ronly;
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

$complement_ref = $lcsha->get_Ronly_ref;
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

@complement = $lcsha->get_Bonly;
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

$complement_ref = $lcsha->get_Bonly_ref;
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

@symmetric_difference = $lcsha->get_symmetric_difference;
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

$symmetric_difference_ref = $lcsha->get_symmetric_difference_ref;
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

@symmetric_difference = $lcsha->get_symdiff;
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

$symmetric_difference_ref = $lcsha->get_symdiff_ref;
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

@symmetric_difference = $lcsha->get_LorRonly;
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

$symmetric_difference_ref = $lcsha->get_LorRonly_ref;
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

@symmetric_difference = $lcsha->get_AorBonly;
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

$symmetric_difference_ref = $lcsha->get_AorBonly_ref;
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
    @nonintersection = $lcsha->get_nonintersection;
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
    $nonintersection_ref = $lcsha->get_nonintersection_ref;
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

@bag = $lcsha->get_bag;
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

$bag_ref = $lcsha->get_bag_ref;
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

$LR = $lcsha->is_LsubsetR;
ok(! $LR);                              # 303

$LR = $lcsha->is_AsubsetB;
ok(! $LR);                              # 304

$RL = $lcsha->is_RsubsetL;
ok(! $RL);                              # 305

$RL = $lcsha->is_BsubsetA;
ok(! $RL);                              # 306

$eqv = $lcsha->is_LequivalentR;
ok(! $eqv);                             # 307

$eqv = $lcsha->is_LeqvlntR;
ok(! $eqv);                             # 308

$disj = $lcsha->is_LdisjointR;
ok(! $disj);                            # 309

$return = $lcsha->print_subset_chart;
ok($return);                            # 310

$return = $lcsha->print_equivalence_chart;
ok($return);                            # 311

@memb_arr = $lcsha->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 312

@memb_arr = $lcsha->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 313

@memb_arr = $lcsha->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 314

@memb_arr = $lcsha->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 315

@memb_arr = $lcsha->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 316

@memb_arr = $lcsha->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 317

@memb_arr = $lcsha->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 318

@memb_arr = $lcsha->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 319

@memb_arr = $lcsha->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 320

@memb_arr = $lcsha->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 321

@memb_arr = $lcsha->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 322

$memb_arr_ref = $lcsha->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 323

$memb_arr_ref = $lcsha->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = $lcsha->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = $lcsha->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = $lcsha->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = $lcsha->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 328

$memb_arr_ref = $lcsha->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 329

$memb_arr_ref = $lcsha->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 330

$memb_arr_ref = $lcsha->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 331

$memb_arr_ref = $lcsha->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 332

$memb_arr_ref = $lcsha->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 333

$memb_hash_ref = $lcsha->are_members_which(
    [ qw| abel baker camera delta edward fargo 
      golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 334
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 335
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 336
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 337
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 338
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 339
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 340
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 341
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 342
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 343
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 344

ok($lcsha->is_member_any('abel'));      # 345
ok($lcsha->is_member_any('baker'));     # 346
ok($lcsha->is_member_any('camera'));    # 347
ok($lcsha->is_member_any('delta'));     # 348
ok($lcsha->is_member_any('edward'));    # 349
ok($lcsha->is_member_any('fargo'));     # 350
ok($lcsha->is_member_any('golfer'));    # 351
ok($lcsha->is_member_any('hilton'));    # 352
ok(! $lcsha->is_member_any('icon' ));   # 353
ok(! $lcsha->is_member_any('jerky'));   # 354
ok(! $lcsha->is_member_any('zebra'));   # 355

$memb_hash_ref = $lcsha->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 356
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 357
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 358
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 359
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 360
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 361
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 362
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 363
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 364
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 365
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 366

$vers = $lcsha->get_version;
ok($vers);                              # 367

my $lcsha_s  = List::Compare->new('-a', \%h2, \%h3);
ok($lcsha_s);                           # 368

$LR = $lcsha_s->is_LsubsetR;
ok(! $LR);                              # 369

$LR = $lcsha_s->is_AsubsetB;
ok(! $LR);                              # 370

$RL = $lcsha_s->is_RsubsetL;
ok($RL);                                # 371

$RL = $lcsha_s->is_BsubsetA;
ok($RL);                                # 372

$eqv = $lcsha_s->is_LequivalentR;
ok(! $eqv);                             # 373

$eqv = $lcsha_s->is_LeqvlntR;
ok(! $eqv);                             # 374

$disj = $lcsha_s->is_LdisjointR;
ok(! $disj);                            # 375

my $lcsha_e  = List::Compare->new('-a', \%h3, \%h4);
ok($lcsha_e);                           # 376

$eqv = $lcsha_e->is_LequivalentR;
ok($eqv);                               # 377

$eqv = $lcsha_e->is_LeqvlntR;
ok($eqv);                               # 378

$disj = $lcsha_e->is_LdisjointR;
ok(! $disj);                            # 379

my $lcsha_dj  = List::Compare->new(\%h4, \%h8);

ok($lcsha_dj);                          # 380

ok(0 == $lcsha_dj->get_intersection);   # 381
ok(0 == scalar(@{$lcsha_dj->get_intersection_ref}));# 382
$disj = $lcsha_dj->is_LdisjointR;
ok($disj);                              # 383

########## BELOW:  Tests for '--accelerated' option ##########

my $lcshacc   = List::Compare->new('--accelerated', \%h0, \%h1);
ok($lcshacc);                           # 384

my $lcshacc_s  = List::Compare->new('--accelerated', \%h2, \%h3);
ok($lcshacc_s);                         # 385

my $lcshacc_e  = List::Compare->new('--accelerated', \%h3, \%h4);
ok($lcshacc_e);                         # 386

########## BELOW:  Tests for '-u' option ##########

my $lcshau   = List::Compare->new('-a', \%h0, \%h1);
ok($lcshau);                            # 387

@union = $lcshau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 388
ok(exists $seen{'baker'});              # 389
ok(exists $seen{'camera'});             # 390
ok(exists $seen{'delta'});              # 391
ok(exists $seen{'edward'});             # 392
ok(exists $seen{'fargo'});              # 393
ok(exists $seen{'golfer'});             # 394
ok(exists $seen{'hilton'});             # 395
ok(! exists $seen{'icon'});             # 396
ok(! exists $seen{'jerky'});            # 397
%seen = ();

$union_ref = $lcshau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 398
ok(exists $seen{'baker'});              # 399
ok(exists $seen{'camera'});             # 400
ok(exists $seen{'delta'});              # 401
ok(exists $seen{'edward'});             # 402
ok(exists $seen{'fargo'});              # 403
ok(exists $seen{'golfer'});             # 404
ok(exists $seen{'hilton'});             # 405
ok(! exists $seen{'icon'});             # 406
ok(! exists $seen{'jerky'});            # 407
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    @shared = $lcshau->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 408
ok(exists $seen{'baker'});              # 409
ok(exists $seen{'camera'});             # 410
ok(exists $seen{'delta'});              # 411
ok(exists $seen{'edward'});             # 412
ok(exists $seen{'fargo'});              # 413
ok(exists $seen{'golfer'});             # 414
ok(exists $seen{'hilton'});             # 415
ok(! exists $seen{'icon'});             # 416
ok(! exists $seen{'jerky'});            # 417
%seen = ();

{
    local $SIG{__WARN__} = \&_capture;
    $shared_ref = $lcshau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 418
ok(exists $seen{'baker'});              # 419
ok(exists $seen{'camera'});             # 420
ok(exists $seen{'delta'});              # 421
ok(exists $seen{'edward'});             # 422
ok(exists $seen{'fargo'});              # 423
ok(exists $seen{'golfer'});             # 424
ok(exists $seen{'hilton'});             # 425
ok(! exists $seen{'icon'});             # 426
ok(! exists $seen{'jerky'});            # 427
%seen = ();

@intersection = $lcshau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 428
ok(exists $seen{'baker'});              # 429
ok(exists $seen{'camera'});             # 430
ok(exists $seen{'delta'});              # 431
ok(exists $seen{'edward'});             # 432
ok(exists $seen{'fargo'});              # 433
ok(exists $seen{'golfer'});             # 434
ok(! exists $seen{'hilton'});           # 435
ok(! exists $seen{'icon'});             # 436
ok(! exists $seen{'jerky'});            # 437
%seen = ();

$intersection_ref = $lcshau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 438
ok(exists $seen{'baker'});              # 439
ok(exists $seen{'camera'});             # 440
ok(exists $seen{'delta'});              # 441
ok(exists $seen{'edward'});             # 442
ok(exists $seen{'fargo'});              # 443
ok(exists $seen{'golfer'});             # 444
ok(! exists $seen{'hilton'});           # 445
ok(! exists $seen{'icon'});             # 446
ok(! exists $seen{'jerky'});            # 447
%seen = ();

@unique = $lcshau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 448
ok(! exists $seen{'baker'});            # 449
ok(! exists $seen{'camera'});           # 450
ok(! exists $seen{'delta'});            # 451
ok(! exists $seen{'edward'});           # 452
ok(! exists $seen{'fargo'});            # 453
ok(! exists $seen{'golfer'});           # 454
ok(! exists $seen{'hilton'});           # 455
ok(! exists $seen{'icon'});             # 456
ok(! exists $seen{'jerky'});            # 457
%seen = ();

$unique_ref = $lcshau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 458
ok(! exists $seen{'baker'});            # 459
ok(! exists $seen{'camera'});           # 460
ok(! exists $seen{'delta'});            # 461
ok(! exists $seen{'edward'});           # 462
ok(! exists $seen{'fargo'});            # 463
ok(! exists $seen{'golfer'});           # 464
ok(! exists $seen{'hilton'});           # 465
ok(! exists $seen{'icon'});             # 466
ok(! exists $seen{'jerky'});            # 467
%seen = ();

@unique = $lcshau->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 468
ok(! exists $seen{'baker'});            # 469
ok(! exists $seen{'camera'});           # 470
ok(! exists $seen{'delta'});            # 471
ok(! exists $seen{'edward'});           # 472
ok(! exists $seen{'fargo'});            # 473
ok(! exists $seen{'golfer'});           # 474
ok(! exists $seen{'hilton'});           # 475
ok(! exists $seen{'icon'});             # 476
ok(! exists $seen{'jerky'});            # 477
%seen = ();

$unique_ref = $lcshau->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 478
ok(! exists $seen{'baker'});            # 479
ok(! exists $seen{'camera'});           # 480
ok(! exists $seen{'delta'});            # 481
ok(! exists $seen{'edward'});           # 482
ok(! exists $seen{'fargo'});            # 483
ok(! exists $seen{'golfer'});           # 484
ok(! exists $seen{'hilton'});           # 485
ok(! exists $seen{'icon'});             # 486
ok(! exists $seen{'jerky'});            # 487
%seen = ();

@unique = $lcshau->get_Aonly;
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

$unique_ref = $lcshau->get_Aonly_ref;
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

@complement = $lcshau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 508
ok(! exists $seen{'baker'});            # 509
ok(! exists $seen{'camera'});           # 510
ok(! exists $seen{'delta'});            # 511
ok(! exists $seen{'edward'});           # 512
ok(! exists $seen{'fargo'});            # 513
ok(! exists $seen{'golfer'});           # 514
ok(exists $seen{'hilton'});             # 515
ok(! exists $seen{'icon'});             # 516
ok(! exists $seen{'jerky'});            # 517
%seen = ();

$complement_ref = $lcshau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 518
ok(! exists $seen{'baker'});            # 519
ok(! exists $seen{'camera'});           # 520
ok(! exists $seen{'delta'});            # 521
ok(! exists $seen{'edward'});           # 522
ok(! exists $seen{'fargo'});            # 523
ok(! exists $seen{'golfer'});           # 524
ok(exists $seen{'hilton'});             # 525
ok(! exists $seen{'icon'});             # 526
ok(! exists $seen{'jerky'});            # 527
%seen = ();

@complement = $lcshau->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 528
ok(! exists $seen{'baker'});            # 529
ok(! exists $seen{'camera'});           # 530
ok(! exists $seen{'delta'});            # 531
ok(! exists $seen{'edward'});           # 532
ok(! exists $seen{'fargo'});            # 533
ok(! exists $seen{'golfer'});           # 534
ok(exists $seen{'hilton'});             # 535
ok(! exists $seen{'icon'});             # 536
ok(! exists $seen{'jerky'});            # 537
%seen = ();

$complement_ref = $lcshau->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 538
ok(! exists $seen{'baker'});            # 539
ok(! exists $seen{'camera'});           # 540
ok(! exists $seen{'delta'});            # 541
ok(! exists $seen{'edward'});           # 542
ok(! exists $seen{'fargo'});            # 543
ok(! exists $seen{'golfer'});           # 544
ok(exists $seen{'hilton'});             # 545
ok(! exists $seen{'icon'});             # 546
ok(! exists $seen{'jerky'});            # 547
%seen = ();

@complement = $lcshau->get_Bonly;
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

$complement_ref = $lcshau->get_Bonly_ref;
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

@symmetric_difference = $lcshau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 568
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

$symmetric_difference_ref = $lcshau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 578
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

@symmetric_difference = $lcshau->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 588
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

$symmetric_difference_ref = $lcshau->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 598
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

@symmetric_difference = $lcshau->get_LorRonly;
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

$symmetric_difference_ref = $lcshau->get_LorRonly_ref;
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

@symmetric_difference = $lcshau->get_AorBonly;
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

$symmetric_difference_ref = $lcshau->get_AorBonly_ref;
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

{
    local $SIG{__WARN__} = \&_capture;
    @nonintersection = $lcshau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
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

{
    local $SIG{__WARN__} = \&_capture;
    $nonintersection_ref = $lcshau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
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

@bag = $lcshau->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 668
ok($seen{'baker'} == 2);                # 669
ok($seen{'camera'} == 2);               # 670
ok($seen{'delta'} == 3);                # 671
ok($seen{'edward'} == 2);               # 672
ok($seen{'fargo'} == 2);                # 673
ok($seen{'golfer'} == 2);               # 674
ok($seen{'hilton'} == 1);               # 675
ok(! exists $seen{'icon'});             # 676
ok(! exists $seen{'jerky'});            # 677
%seen = ();

$bag_ref = $lcshau->get_bag_ref;
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 678
ok($seen{'baker'} == 2);                # 679
ok($seen{'camera'} == 2);               # 680
ok($seen{'delta'} == 3);                # 681
ok($seen{'edward'} == 2);               # 682
ok($seen{'fargo'} == 2);                # 683
ok($seen{'golfer'} == 2);               # 684
ok($seen{'hilton'} == 1);               # 685
ok(! exists $seen{'icon'});             # 686
ok(! exists $seen{'jerky'});            # 687
%seen = ();

$LR = $lcshau->is_LsubsetR;
ok(! $LR);                              # 688

$LR = $lcshau->is_AsubsetB;
ok(! $LR);                              # 689

$RL = $lcshau->is_RsubsetL;
ok(! $RL);                              # 690

$RL = $lcshau->is_BsubsetA;
ok(! $RL);                              # 691

$eqv = $lcshau->is_LequivalentR;
ok(! $eqv);                             # 692

$eqv = $lcshau->is_LeqvlntR;
ok(! $eqv);                             # 693

$disj = $lcshau->is_LdisjointR;
ok(! $disj);                            # 694

$return = $lcshau->print_subset_chart;
ok($return);                            # 695

$return = $lcshau->print_equivalence_chart;
ok($return);                            # 696

@memb_arr = $lcshau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 697

@memb_arr = $lcshau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 698

@memb_arr = $lcshau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 699

@memb_arr = $lcshau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 700

@memb_arr = $lcshau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 701

@memb_arr = $lcshau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 702

@memb_arr = $lcshau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 703

@memb_arr = $lcshau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 704

@memb_arr = $lcshau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 705

@memb_arr = $lcshau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 706

@memb_arr = $lcshau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 707

$memb_arr_ref = $lcshau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 708

$memb_arr_ref = $lcshau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 709

$memb_arr_ref = $lcshau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 710

$memb_arr_ref = $lcshau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 711

$memb_arr_ref = $lcshau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 712

$memb_arr_ref = $lcshau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 713

$memb_arr_ref = $lcshau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 714

$memb_arr_ref = $lcshau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 715

$memb_arr_ref = $lcshau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 716

$memb_arr_ref = $lcshau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 717

$memb_arr_ref = $lcshau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 718

$memb_hash_ref = $lcshau->are_members_which(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 719
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 720
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 721
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 722
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 723
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 724
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 725
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 726
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 727
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 728
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 729

ok($lcshau->is_member_any('abel'));     # 730
ok($lcshau->is_member_any('baker'));    # 731
ok($lcshau->is_member_any('camera'));   # 732
ok($lcshau->is_member_any('delta'));    # 733
ok($lcshau->is_member_any('edward'));   # 734
ok($lcshau->is_member_any('fargo'));    # 735
ok($lcshau->is_member_any('golfer'));   # 736
ok($lcshau->is_member_any('hilton'));   # 737
ok(! $lcshau->is_member_any('icon' ));  # 738
ok(! $lcshau->is_member_any('jerky'));  # 739
ok(! $lcshau->is_member_any('zebra'));  # 740

$memb_hash_ref = $lcshau->are_members_any(
    [ qw| abel baker camera delta edward fargo 
          golfer hilton icon jerky zebra | ] );
ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 741
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 742
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 743
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 744
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 745
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 746
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 747
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 748
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 749
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 750
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 751

$vers = $lcshau->get_version;
ok($vers);                              # 752

my $lcshau_s  = List::Compare->new('-a', \%h2, \%h3);
ok($lcshau_s);                          # 753

$LR = $lcshau_s->is_LsubsetR;
ok(! $LR);                              # 754

$LR = $lcshau_s->is_AsubsetB;
ok(! $LR);                              # 755

$RL = $lcshau_s->is_RsubsetL;
ok($RL);                                # 756

$RL = $lcshau_s->is_BsubsetA;
ok($RL);                                # 757

$eqv = $lcshau_s->is_LequivalentR;
ok(! $eqv);                             # 758

$eqv = $lcshau_s->is_LeqvlntR;
ok(! $eqv);                             # 759

$disj = $lcshau_s->is_LdisjointR;
ok(! $disj);                            # 760

my $lcshau_e  = List::Compare->new('-a', \%h3, \%h4);
ok($lcshau_e);                          # 761

$eqv = $lcshau_e->is_LequivalentR;
ok($eqv);                               # 762

$eqv = $lcshau_e->is_LeqvlntR;
ok($eqv);                               # 763

$disj = $lcshau_e->is_LdisjointR;
ok(! $disj);                            # 764

my $lcusha_dj  = List::Compare->new('-u', \%h4, \%h8);

ok($lcusha_dj);                         # 765

ok(0 == $lcusha_dj->get_intersection);  # 766
ok(0 == scalar(@{$lcusha_dj->get_intersection_ref}));# 767
$disj = $lcusha_dj->is_LdisjointR;
ok($disj);                              # 768

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcshaun   = List::Compare->new('--unsorted', '-a', \%h0, \%h1);
ok($lcshaun);                           # 769

my $lcshaun_s  = List::Compare->new('--unsorted', '-a', \%h2, \%h3);
ok($lcshaun_s);                         # 770

my $lcshaun_e  = List::Compare->new('--unsorted', '-a', \%h3, \%h4);
ok($lcshaun_e);                         # 771

my $lcshaccun   = List::Compare->new('--unsorted', '--accelerated', \%h0, \%h1);
ok($lcshaccun);                         # 772

my $lcshaccun_s  = List::Compare->new('--unsorted', '--accelerated', \%h2, \%h3);
ok($lcshaccun_s);                       # 773

my $lcshaccun_e  = List::Compare->new('--unsorted', '--accelerated', \%h3, \%h4);
ok($lcshaccun_e);                       # 774

my $lcshaccu   = List::Compare->new('-u', '--accelerated', \%h0, \%h1);
ok($lcshaccu);                          # 775

my $lcshaccu_s  = List::Compare->new('-u', '--accelerated', \%h2, \%h3);
ok($lcshaccu_s);                        # 776

my $lcshaccu_e  = List::Compare->new('-u', '--accelerated', \%h3, \%h4);
ok($lcshaccu_e);                        # 777

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare->new('-a', \%h0, \%h5) };
ok(ok_capture_error($@));               # 778

eval { $f6 = List::Compare->new('-a', \%h6, \%h0) };
ok(ok_capture_error($@));               # 779

eval { $f7 = List::Compare->new('-a', \%h6, \%h7) };
ok(ok_capture_error($@));               # 780



