# 05_accelerated_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
770; $| = 1; print "1..$last_test_to_print\n"; } # 11/22/2003
END {print "not ok 1\n" unless $loaded;}
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

my $lcsha   = List::Compare::SeenHash->new('-a', \%h0, \%h1);
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

$LR = $lcsha->is_LsubsetR;
ok(! $LR);                              # 283

$LR = $lcsha->is_AsubsetB;
ok(! $LR);                              # 284

$RL = $lcsha->is_RsubsetL;
ok(! $RL);                              # 285

$RL = $lcsha->is_BsubsetA;
ok(! $RL);                              # 286

$eqv = $lcsha->is_LequivalentR;
ok(! $eqv);                             # 287

$eqv = $lcsha->is_LeqvlntR;
ok(! $eqv);                             # 288

$return = $lcsha->print_subset_chart;
ok($return);                            # 289

$return = $lcsha->print_equivalence_chart;
ok($return);                            # 290

@memb_arr = $lcsha->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 291

@memb_arr = $lcsha->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 292

@memb_arr = $lcsha->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 293

@memb_arr = $lcsha->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 294

@memb_arr = $lcsha->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 295

@memb_arr = $lcsha->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 296

@memb_arr = $lcsha->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 297

@memb_arr = $lcsha->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 298

@memb_arr = $lcsha->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 299

@memb_arr = $lcsha->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 300

@memb_arr = $lcsha->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 301


$memb_arr_ref = $lcsha->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 302

$memb_arr_ref = $lcsha->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 303

$memb_arr_ref = $lcsha->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 304

$memb_arr_ref = $lcsha->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 305

$memb_arr_ref = $lcsha->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 306

$memb_arr_ref = $lcsha->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 307

$memb_arr_ref = $lcsha->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 308

$memb_arr_ref = $lcsha->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 309

$memb_arr_ref = $lcsha->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 310

$memb_arr_ref = $lcsha->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 311

$memb_arr_ref = $lcsha->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 312


$memb_hash_ref = $lcsha->are_members_which(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lcsha->are_members_which( [ qw| abel baker camera delta edward fargo 
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


ok($lcsha->is_member_any('abel'));      # 335
ok($lcsha->is_member_any('baker'));     # 336
ok($lcsha->is_member_any('camera'));    # 337
ok($lcsha->is_member_any('delta'));     # 338
ok($lcsha->is_member_any('edward'));    # 339
ok($lcsha->is_member_any('fargo'));     # 340
ok($lcsha->is_member_any('golfer'));    # 341
ok($lcsha->is_member_any('hilton'));    # 342
ok(! $lcsha->is_member_any('icon' ));   # 343
ok(! $lcsha->is_member_any('jerky'));   # 344
ok(! $lcsha->is_member_any('zebra'));   # 345

$memb_hash_ref = $lcsha->are_members_any(qw| abel baker camera delta edward fargo 
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

$memb_hash_ref = $lcsha->are_members_any( [ qw| abel baker camera delta edward fargo 
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

$vers = $lcsha->get_version;
ok($vers);                              # 368

my $lcsha_s  = List::Compare::SeenHash->new('-a', \%h2, \%h3);
ok($lcsha_s);                           # 369

$LR = $lcsha_s->is_LsubsetR;
ok(! $LR);                              # 370

$LR = $lcsha_s->is_AsubsetB;
ok(! $LR);                              # 371

$RL = $lcsha_s->is_RsubsetL;
ok($RL);                                # 372

$RL = $lcsha_s->is_BsubsetA;
ok($RL);                                # 373

$eqv = $lcsha_s->is_LequivalentR;
ok(! $eqv);                             # 374

$eqv = $lcsha_s->is_LeqvlntR;
ok(! $eqv);                             # 375

my $lcsha_e  = List::Compare::SeenHash->new('-a', \%h3, \%h4);
ok($lcsha_e);                           # 376

$eqv = $lcsha_e->is_LequivalentR;
ok($eqv);                               # 377

$eqv = $lcsha_e->is_LeqvlntR;
ok($eqv);                               # 378

########## BELOW:  Tests for '--accelerated' option ##########

my $lcshacc   = List::Compare::SeenHash->new('--accelerated', \%h0, \%h1);
ok($lcshacc);                           # 379

my $lcshacc_s  = List::Compare::SeenHash->new('--accelerated', \%h2, \%h3);
ok($lcshacc_s);                         # 380

my $lcshacc_e  = List::Compare::SeenHash->new('--accelerated', \%h3, \%h4);
ok($lcshacc_e);                         # 381

########## BELOW:  Tests for '-u' option ##########

my $lcshau   = List::Compare::SeenHash->new('-a', \%h0, \%h1);
ok($lcshau);                            # 382

@union = $lcshau->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 383
ok(exists $seen{'baker'});              # 384
ok(exists $seen{'camera'});             # 385
ok(exists $seen{'delta'});              # 386
ok(exists $seen{'edward'});             # 387
ok(exists $seen{'fargo'});              # 388
ok(exists $seen{'golfer'});             # 389
ok(exists $seen{'hilton'});             # 390
ok(! exists $seen{'icon'});             # 391
ok(! exists $seen{'jerky'});            # 392
%seen = ();

$union_ref = $lcshau->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 393
ok(exists $seen{'baker'});              # 394
ok(exists $seen{'camera'});             # 395
ok(exists $seen{'delta'});              # 396
ok(exists $seen{'edward'});             # 397
ok(exists $seen{'fargo'});              # 398
ok(exists $seen{'golfer'});             # 399
ok(exists $seen{'hilton'});             # 400
ok(! exists $seen{'icon'});             # 401
ok(! exists $seen{'jerky'});            # 402
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcshau->get_shared;
}
$seen{$_}++ foreach (@shared);
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

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcshau->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
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

@intersection = $lcshau->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 423
ok(exists $seen{'baker'});              # 424
ok(exists $seen{'camera'});             # 425
ok(exists $seen{'delta'});              # 426
ok(exists $seen{'edward'});             # 427
ok(exists $seen{'fargo'});              # 428
ok(exists $seen{'golfer'});             # 429
ok(! exists $seen{'hilton'});           # 430
ok(! exists $seen{'icon'});             # 431
ok(! exists $seen{'jerky'});            # 432
%seen = ();

$intersection_ref = $lcshau->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 433
ok(exists $seen{'baker'});              # 434
ok(exists $seen{'camera'});             # 435
ok(exists $seen{'delta'});              # 436
ok(exists $seen{'edward'});             # 437
ok(exists $seen{'fargo'});              # 438
ok(exists $seen{'golfer'});             # 439
ok(! exists $seen{'hilton'});           # 440
ok(! exists $seen{'icon'});             # 441
ok(! exists $seen{'jerky'});            # 442
%seen = ();

@unique = $lcshau->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 443
ok(! exists $seen{'baker'});            # 444
ok(! exists $seen{'camera'});           # 445
ok(! exists $seen{'delta'});            # 446
ok(! exists $seen{'edward'});           # 447
ok(! exists $seen{'fargo'});            # 448
ok(! exists $seen{'golfer'});           # 449
ok(! exists $seen{'hilton'});           # 450
ok(! exists $seen{'icon'});             # 451
ok(! exists $seen{'jerky'});            # 452
%seen = ();

$unique_ref = $lcshau->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 453
ok(! exists $seen{'baker'});            # 454
ok(! exists $seen{'camera'});           # 455
ok(! exists $seen{'delta'});            # 456
ok(! exists $seen{'edward'});           # 457
ok(! exists $seen{'fargo'});            # 458
ok(! exists $seen{'golfer'});           # 459
ok(! exists $seen{'hilton'});           # 460
ok(! exists $seen{'icon'});             # 461
ok(! exists $seen{'jerky'});            # 462
%seen = ();

@unique = $lcshau->get_Lonly;
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

$unique_ref = $lcshau->get_Lonly_ref;
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

@unique = $lcshau->get_Aonly;
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

$unique_ref = $lcshau->get_Aonly_ref;
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

@complement = $lcshau->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 503
ok(! exists $seen{'baker'});            # 504
ok(! exists $seen{'camera'});           # 505
ok(! exists $seen{'delta'});            # 506
ok(! exists $seen{'edward'});           # 507
ok(! exists $seen{'fargo'});            # 508
ok(! exists $seen{'golfer'});           # 509
ok(exists $seen{'hilton'});             # 510
ok(! exists $seen{'icon'});             # 511
ok(! exists $seen{'jerky'});            # 512
%seen = ();

$complement_ref = $lcshau->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 513
ok(! exists $seen{'baker'});            # 514
ok(! exists $seen{'camera'});           # 515
ok(! exists $seen{'delta'});            # 516
ok(! exists $seen{'edward'});           # 517
ok(! exists $seen{'fargo'});            # 518
ok(! exists $seen{'golfer'});           # 519
ok(exists $seen{'hilton'});             # 520
ok(! exists $seen{'icon'});             # 521
ok(! exists $seen{'jerky'});            # 522
%seen = ();

@complement = $lcshau->get_Ronly;
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

$complement_ref = $lcshau->get_Ronly_ref;
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

@complement = $lcshau->get_Bonly;
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

$complement_ref = $lcshau->get_Bonly_ref;
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

@symmetric_difference = $lcshau->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 563
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

$symmetric_difference_ref = $lcshau->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 573
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

@symmetric_difference = $lcshau->get_symdiff;
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

$symmetric_difference_ref = $lcshau->get_symdiff_ref;
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

@symmetric_difference = $lcshau->get_LorRonly;
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

$symmetric_difference_ref = $lcshau->get_LorRonly_ref;
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

@symmetric_difference = $lcshau->get_AorBonly;
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

$symmetric_difference_ref = $lcshau->get_AorBonly_ref;
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

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcshau->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
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

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcshau->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
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

$LR = $lcshau->is_LsubsetR;
ok(! $LR);                              # 663

$LR = $lcshau->is_AsubsetB;
ok(! $LR);                              # 664

$RL = $lcshau->is_RsubsetL;
ok(! $RL);                              # 665

$RL = $lcshau->is_BsubsetA;
ok(! $RL);                              # 666

$eqv = $lcshau->is_LequivalentR;
ok(! $eqv);                             # 667

$eqv = $lcshau->is_LeqvlntR;
ok(! $eqv);                             # 668

$return = $lcshau->print_subset_chart;
ok($return);                            # 669

$return = $lcshau->print_equivalence_chart;
ok($return);                            # 670

@memb_arr = $lcshau->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 671

@memb_arr = $lcshau->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 672

@memb_arr = $lcshau->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 673

@memb_arr = $lcshau->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 674

@memb_arr = $lcshau->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 675

@memb_arr = $lcshau->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 676

@memb_arr = $lcshau->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 677

@memb_arr = $lcshau->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 678

@memb_arr = $lcshau->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 679

@memb_arr = $lcshau->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 680

@memb_arr = $lcshau->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 681


$memb_arr_ref = $lcshau->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 682

$memb_arr_ref = $lcshau->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 683

$memb_arr_ref = $lcshau->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 684

$memb_arr_ref = $lcshau->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 685

$memb_arr_ref = $lcshau->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 686

$memb_arr_ref = $lcshau->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 687

$memb_arr_ref = $lcshau->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 688

$memb_arr_ref = $lcshau->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 689

$memb_arr_ref = $lcshau->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 690

$memb_arr_ref = $lcshau->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 691

$memb_arr_ref = $lcshau->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 692


$memb_hash_ref = $lcshau->are_members_which(qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 693
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 694
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 695
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 696
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 697
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 698
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 699
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 700
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 701
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 702
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 703

$memb_hash_ref = $lcshau->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 704
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 705
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 706
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 707
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 708
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 709
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 710
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 711
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 712
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 713
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 714


ok($lcshau->is_member_any('abel'));     # 715
ok($lcshau->is_member_any('baker'));    # 716
ok($lcshau->is_member_any('camera'));   # 717
ok($lcshau->is_member_any('delta'));    # 718
ok($lcshau->is_member_any('edward'));   # 719
ok($lcshau->is_member_any('fargo'));    # 720
ok($lcshau->is_member_any('golfer'));   # 721
ok($lcshau->is_member_any('hilton'));   # 722
ok(! $lcshau->is_member_any('icon' ));  # 723
ok(! $lcshau->is_member_any('jerky'));  # 724
ok(! $lcshau->is_member_any('zebra'));  # 725

$memb_hash_ref = $lcshau->are_members_any(qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 726
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 727
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 728
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 729
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 730
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 731
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 732
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 733
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 734
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 735
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 736

$memb_hash_ref = $lcshau->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 737
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 738
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 739
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 740
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 741
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 742
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 743
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 744
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 745
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 746
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 747

$vers = $lcshau->get_version;
ok($vers);                              # 748

my $lcshau_s  = List::Compare::SeenHash->new('-a', \%h2, \%h3);
ok($lcshau_s);                          # 749

$LR = $lcshau_s->is_LsubsetR;
ok(! $LR);                              # 750

$LR = $lcshau_s->is_AsubsetB;
ok(! $LR);                              # 751

$RL = $lcshau_s->is_RsubsetL;
ok($RL);                                # 752

$RL = $lcshau_s->is_BsubsetA;
ok($RL);                                # 753

$eqv = $lcshau_s->is_LequivalentR;
ok(! $eqv);                             # 754

$eqv = $lcshau_s->is_LeqvlntR;
ok(! $eqv);                             # 755

my $lcshau_e  = List::Compare::SeenHash->new('-a', \%h3, \%h4);
ok($lcshau_e);                          # 756

$eqv = $lcshau_e->is_LequivalentR;
ok($eqv);                               # 757

$eqv = $lcshau_e->is_LeqvlntR;
ok($eqv);                               # 758

########## BELOW:  Tests for '--unsorted' and '--accelerated' options ##########

my $lcshaun   = List::Compare::SeenHash->new('--unsorted', '-a', \%h0, \%h1);
ok($lcshaun);                           # 759

my $lcshaun_s  = List::Compare::SeenHash->new('--unsorted', '-a', \%h2, \%h3);
ok($lcshaun_s);                         # 760

my $lcshaun_e  = List::Compare::SeenHash->new('--unsorted', '-a', \%h3, \%h4);
ok($lcshaun_e);                         # 761

my $lcshaccun   = List::Compare::SeenHash->new('--unsorted', '--accelerated', \%h0, \%h1);
ok($lcshaccun);                         # 762

my $lcshaccun_s  = List::Compare::SeenHash->new('--unsorted', '--accelerated', \%h2, \%h3);
ok($lcshaccun_s);                       # 763

my $lcshaccun_e  = List::Compare::SeenHash->new('--unsorted', '--accelerated', \%h3, \%h4);
ok($lcshaccun_e);                       # 764

my $lcshaccu   = List::Compare::SeenHash->new('-u', '--accelerated', \%h0, \%h1);
ok($lcshaccu);                          # 765

my $lcshaccu_s  = List::Compare::SeenHash->new('-u', '--accelerated', \%h2, \%h3);
ok($lcshaccu_s);                        # 766

my $lcshaccu_e  = List::Compare::SeenHash->new('-u', '--accelerated', \%h3, \%h4);
ok($lcshaccu_e);                        # 767

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare::SeenHash->new('-a', \%h0, \%h5) };
ok_capture_error($@);                   # 768

eval { $f6 = List::Compare::SeenHash->new('-a', \%h6, \%h0) };
ok_capture_error($@);                   # 769

eval { $f7 = List::Compare::SeenHash->new('-a', \%h6, \%h7) };
ok_capture_error($@);                   # 770



