# 04_simple_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
761;
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


my $lcsh  = List::Compare::SeenHash->new(\%h0, \%h1);

ok($lcsh);                              # 2

@union = $lcsh->get_union;
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

$union_ref = $lcsh->get_union_ref;
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
	@shared = $lcsh->get_shared;
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
	$shared_ref = $lcsh->get_shared_ref;
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

@intersection = $lcsh->get_intersection;
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

$intersection_ref = $lcsh->get_intersection_ref;
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

@unique = $lcsh->get_unique;
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

$unique_ref = $lcsh->get_unique_ref;
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

@unique = $lcsh->get_Lonly;
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

$unique_ref = $lcsh->get_Lonly_ref;
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

@unique = $lcsh->get_Aonly;
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

$unique_ref = $lcsh->get_Aonly_ref;
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

@complement = $lcsh->get_complement;
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

$complement_ref = $lcsh->get_complement_ref;
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

@complement = $lcsh->get_Ronly;
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

$complement_ref = $lcsh->get_Ronly_ref;
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

@complement = $lcsh->get_Bonly;
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

$complement_ref = $lcsh->get_Bonly_ref;
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

@symmetric_difference = $lcsh->get_symmetric_difference;
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

$symmetric_difference_ref = $lcsh->get_symmetric_difference_ref;
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

@symmetric_difference = $lcsh->get_symdiff;
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

$symmetric_difference_ref = $lcsh->get_symdiff_ref;
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

@symmetric_difference = $lcsh->get_LorRonly;
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

$symmetric_difference_ref = $lcsh->get_LorRonly_ref;
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

@symmetric_difference = $lcsh->get_AorBonly;
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

$symmetric_difference_ref = $lcsh->get_AorBonly_ref;
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
	@nonintersection = $lcsh->get_nonintersection;
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
	$nonintersection_ref = $lcsh->get_nonintersection_ref;
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

$LR = $lcsh->is_LsubsetR;
ok(! $LR);                              # 283

$LR = $lcsh->is_AsubsetB;
ok(! $LR);                              # 284

$RL = $lcsh->is_RsubsetL;
ok(! $RL);                              # 285

$RL = $lcsh->is_BsubsetA;
ok(! $RL);                              # 286

$eqv = $lcsh->is_LequivalentR;
ok(! $eqv);                             # 287

$eqv = $lcsh->is_LeqvlntR;
ok(! $eqv);                             # 288

$return = $lcsh->print_subset_chart;
ok($return);                            # 289

$return = $lcsh->print_equivalence_chart;
ok($return);                            # 290

@memb_arr = $lcsh->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 291

@memb_arr = $lcsh->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 292

@memb_arr = $lcsh->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 293

@memb_arr = $lcsh->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 294

@memb_arr = $lcsh->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 295

@memb_arr = $lcsh->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 296

@memb_arr = $lcsh->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 297

@memb_arr = $lcsh->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 298

@memb_arr = $lcsh->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 299

@memb_arr = $lcsh->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 300

@memb_arr = $lcsh->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 301


$memb_arr_ref = $lcsh->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 302

$memb_arr_ref = $lcsh->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 303

$memb_arr_ref = $lcsh->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 304

$memb_arr_ref = $lcsh->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 305

$memb_arr_ref = $lcsh->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 306

$memb_arr_ref = $lcsh->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 307

$memb_arr_ref = $lcsh->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 308

$memb_arr_ref = $lcsh->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 309

$memb_arr_ref = $lcsh->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 310

$memb_arr_ref = $lcsh->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 311

$memb_arr_ref = $lcsh->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 312

$memb_hash_ref = $lcsh->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 313
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 314
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 315
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 316
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 317
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 318
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 319
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 320
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 321
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 322
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 323

$memb_hash_ref = $lcsh->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 324
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 325
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 326
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 327
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 328
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 329
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 330
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 331
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 332
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 333
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 334


ok($lcsh->is_member_any('abel'));       # 335
ok($lcsh->is_member_any('baker'));      # 336
ok($lcsh->is_member_any('camera'));     # 337
ok($lcsh->is_member_any('delta'));      # 338
ok($lcsh->is_member_any('edward'));     # 339
ok($lcsh->is_member_any('fargo'));      # 340
ok($lcsh->is_member_any('golfer'));     # 341
ok($lcsh->is_member_any('hilton'));     # 342
ok(! $lcsh->is_member_any('icon' ));    # 343
ok(! $lcsh->is_member_any('jerky'));    # 344
ok(! $lcsh->is_member_any('zebra'));    # 345

$memb_hash_ref = $lcsh->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 346
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 347
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 348
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 349
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 350
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 351
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 352
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 353
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 354
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 355
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 356

$memb_hash_ref = $lcsh->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 357
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 358
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 359
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 360
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 361
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 362
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 363
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 364
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 365
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 366
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 367

$vers = $lcsh->get_version;
ok($vers);                              # 368

my $lcsh_s  = List::Compare::SeenHash->new(\%h2, \%h3);
ok($lcsh_s);                            # 369

$LR = $lcsh_s->is_LsubsetR;
ok(! $LR);                              # 370

$LR = $lcsh_s->is_AsubsetB;
ok(! $LR);                              # 371

$RL = $lcsh_s->is_RsubsetL;
ok($RL);                                # 372

$RL = $lcsh_s->is_BsubsetA;
ok($RL);                                # 373

$eqv = $lcsh_s->is_LequivalentR;
ok(! $eqv);                             # 374

$eqv = $lcsh_s->is_LeqvlntR;
ok(! $eqv);                             # 375

my $lcsh_e  = List::Compare::SeenHash->new(\%h3, \%h4);

ok($lcsh_e);                            # 376

$eqv = $lcsh_e->is_LequivalentR;
ok($eqv);                               # 377

$eqv = $lcsh_e->is_LeqvlntR;
ok($eqv);                               # 378

########## BELOW:  Tests for '-u' option ##########

my $lcshu  = List::Compare::SeenHash->new('-u', \%h0, \%h1);

ok($lcshu);                             # 379

@union = $lcshu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 380
ok(exists $seen{'baker'});              # 381
ok(exists $seen{'camera'});             # 382
ok(exists $seen{'delta'});              # 383
ok(exists $seen{'edward'});             # 384
ok(exists $seen{'fargo'});              # 385
ok(exists $seen{'golfer'});             # 386
ok(exists $seen{'hilton'});             # 387
ok(! exists $seen{'icon'});             # 388
ok(! exists $seen{'jerky'});            # 389
%seen = ();

$union_ref = $lcshu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 390
ok(exists $seen{'baker'});              # 391
ok(exists $seen{'camera'});             # 392
ok(exists $seen{'delta'});              # 393
ok(exists $seen{'edward'});             # 394
ok(exists $seen{'fargo'});              # 395
ok(exists $seen{'golfer'});             # 396
ok(exists $seen{'hilton'});             # 397
ok(! exists $seen{'icon'});             # 398
ok(! exists $seen{'jerky'});            # 399
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcshu->get_shared;
}
$seen{$_}++ foreach (@shared);
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

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcshu->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
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

@intersection = $lcshu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 420
ok(exists $seen{'baker'});              # 421
ok(exists $seen{'camera'});             # 422
ok(exists $seen{'delta'});              # 423
ok(exists $seen{'edward'});             # 424
ok(exists $seen{'fargo'});              # 425
ok(exists $seen{'golfer'});             # 426
ok(! exists $seen{'hilton'});           # 427
ok(! exists $seen{'icon'});             # 428
ok(! exists $seen{'jerky'});            # 429
%seen = ();

$intersection_ref = $lcshu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 430
ok(exists $seen{'baker'});              # 431
ok(exists $seen{'camera'});             # 432
ok(exists $seen{'delta'});              # 433
ok(exists $seen{'edward'});             # 434
ok(exists $seen{'fargo'});              # 435
ok(exists $seen{'golfer'});             # 436
ok(! exists $seen{'hilton'});           # 437
ok(! exists $seen{'icon'});             # 438
ok(! exists $seen{'jerky'});            # 439
%seen = ();

@unique = $lcshu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 440
ok(! exists $seen{'baker'});            # 441
ok(! exists $seen{'camera'});           # 442
ok(! exists $seen{'delta'});            # 443
ok(! exists $seen{'edward'});           # 444
ok(! exists $seen{'fargo'});            # 445
ok(! exists $seen{'golfer'});           # 446
ok(! exists $seen{'hilton'});           # 447
ok(! exists $seen{'icon'});             # 448
ok(! exists $seen{'jerky'});            # 449
%seen = ();

$unique_ref = $lcshu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 450
ok(! exists $seen{'baker'});            # 451
ok(! exists $seen{'camera'});           # 452
ok(! exists $seen{'delta'});            # 453
ok(! exists $seen{'edward'});           # 454
ok(! exists $seen{'fargo'});            # 455
ok(! exists $seen{'golfer'});           # 456
ok(! exists $seen{'hilton'});           # 457
ok(! exists $seen{'icon'});             # 458
ok(! exists $seen{'jerky'});            # 459
%seen = ();

@unique = $lcshu->get_Lonly;
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

$unique_ref = $lcshu->get_Lonly_ref;
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

@unique = $lcshu->get_Aonly;
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

$unique_ref = $lcshu->get_Aonly_ref;
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

@complement = $lcshu->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 500
ok(! exists $seen{'baker'});            # 501
ok(! exists $seen{'camera'});           # 502
ok(! exists $seen{'delta'});            # 503
ok(! exists $seen{'edward'});           # 504
ok(! exists $seen{'fargo'});            # 505
ok(! exists $seen{'golfer'});           # 506
ok(exists $seen{'hilton'});             # 507
ok(! exists $seen{'icon'});             # 508
ok(! exists $seen{'jerky'});            # 509
%seen = ();

$complement_ref = $lcshu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 510
ok(! exists $seen{'baker'});            # 511
ok(! exists $seen{'camera'});           # 512
ok(! exists $seen{'delta'});            # 513
ok(! exists $seen{'edward'});           # 514
ok(! exists $seen{'fargo'});            # 515
ok(! exists $seen{'golfer'});           # 516
ok(exists $seen{'hilton'});             # 517
ok(! exists $seen{'icon'});             # 518
ok(! exists $seen{'jerky'});            # 519
%seen = ();

@complement = $lcshu->get_Ronly;
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

$complement_ref = $lcshu->get_Ronly_ref;
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

@complement = $lcshu->get_Bonly;
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

$complement_ref = $lcshu->get_Bonly_ref;
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

@symmetric_difference = $lcshu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 560
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

$symmetric_difference_ref = $lcshu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 570
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

@symmetric_difference = $lcshu->get_symdiff;
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

$symmetric_difference_ref = $lcshu->get_symdiff_ref;
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

@symmetric_difference = $lcshu->get_LorRonly;
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

$symmetric_difference_ref = $lcshu->get_LorRonly_ref;
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

@symmetric_difference = $lcshu->get_AorBonly;
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

$symmetric_difference_ref = $lcshu->get_AorBonly_ref;
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

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcshu->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
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

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcshu->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
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

$LR = $lcshu->is_LsubsetR;
ok(! $LR);                              # 660

$LR = $lcshu->is_AsubsetB;
ok(! $LR);                              # 661

$RL = $lcshu->is_RsubsetL;
ok(! $RL);                              # 662

$RL = $lcshu->is_BsubsetA;
ok(! $RL);                              # 663

$eqv = $lcshu->is_LequivalentR;
ok(! $eqv);                             # 664

$eqv = $lcshu->is_LeqvlntR;
ok(! $eqv);                             # 665

$return = $lcshu->print_subset_chart;
ok($return);                            # 666

$return = $lcshu->print_equivalence_chart;
ok($return);                            # 667

@memb_arr = $lcshu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 668

@memb_arr = $lcshu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 669

@memb_arr = $lcshu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 670

@memb_arr = $lcshu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 671

@memb_arr = $lcshu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 672

@memb_arr = $lcshu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 673

@memb_arr = $lcshu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 674

@memb_arr = $lcshu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 675

@memb_arr = $lcshu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 676

@memb_arr = $lcshu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 677

@memb_arr = $lcshu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 678


$memb_arr_ref = $lcshu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 679

$memb_arr_ref = $lcshu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 680

$memb_arr_ref = $lcshu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 681

$memb_arr_ref = $lcshu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 682

$memb_arr_ref = $lcshu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 683

$memb_arr_ref = $lcshu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 684

$memb_arr_ref = $lcshu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 685

$memb_arr_ref = $lcshu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 686

$memb_arr_ref = $lcshu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 687

$memb_arr_ref = $lcshu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 688

$memb_arr_ref = $lcshu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 689

$memb_hash_ref = $lcshu->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 690
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 691
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 692
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 693
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 694
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 695
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 696
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 697
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 698
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 699
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 700

$memb_hash_ref = $lcshu->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 701
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 702
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 703
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 704
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 705
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 706
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 707
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 708
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 709
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 710
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 711


ok($lcshu->is_member_any('abel'));      # 712
ok($lcshu->is_member_any('baker'));     # 713
ok($lcshu->is_member_any('camera'));    # 714
ok($lcshu->is_member_any('delta'));     # 715
ok($lcshu->is_member_any('edward'));    # 716
ok($lcshu->is_member_any('fargo'));     # 717
ok($lcshu->is_member_any('golfer'));    # 718
ok($lcshu->is_member_any('hilton'));    # 719
ok(! $lcshu->is_member_any('icon' ));   # 720
ok(! $lcshu->is_member_any('jerky'));   # 721
ok(! $lcshu->is_member_any('zebra'));   # 722

$memb_hash_ref = $lcshu->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 723
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 724
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 725
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 726
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 727
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 728
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 729
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 730
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 731
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 732
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 733

$memb_hash_ref = $lcshu->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 734
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 735
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 736
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 737
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 738
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 739
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 740
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 741
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 742
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 743
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 744

$vers = $lcshu->get_version;
ok($vers);                              # 745

my $lcshu_s  = List::Compare::SeenHash->new('-u', \%h2, \%h3);
ok($lcshu_s);                           # 746

$LR = $lcshu_s->is_LsubsetR;
ok(! $LR);                              # 747

$LR = $lcshu_s->is_AsubsetB;
ok(! $LR);                              # 748

$RL = $lcshu_s->is_RsubsetL;
ok($RL);                                # 749

$RL = $lcshu_s->is_BsubsetA;
ok($RL);                                # 750

$eqv = $lcshu_s->is_LequivalentR;
ok(! $eqv);                             # 751

$eqv = $lcshu_s->is_LeqvlntR;
ok(! $eqv);                             # 752

my $lcshu_e  = List::Compare::SeenHash->new('-u', \%h3, \%h4);

ok($lcshu_e);                           # 753

$eqv = $lcshu_e->is_LequivalentR;
ok($eqv);                               # 754

$eqv = $lcshu_e->is_LeqvlntR;
ok($eqv);                               # 755

########## BELOW:  Tests for '--unsorted' option ##########

my $lcshun  = List::Compare::SeenHash->new('--unsorted', \%h0, \%h1);
ok($lcshun);                            # 756

my $lcshun_s  = List::Compare::SeenHash->new('--unsorted', \%h2, \%h3);
ok($lcshun_s);                          # 757

my $lcshun_e  = List::Compare::SeenHash->new('--unsorted', \%h3, \%h4);
ok($lcshun_e);                          # 758

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare::SeenHash->new(\%h0, \%h5) };
ok(ok_capture_error($@));               # 759

eval { $f6 = List::Compare::SeenHash->new(\%h6, \%h0) };
ok(ok_capture_error($@));               # 760

eval { $f7 = List::Compare::SeenHash->new(\%h6, \%h7) };
ok(ok_capture_error($@));               # 761


