# 04_simple_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
378; $| = 1; print "1..$last_test_to_print\n"; } # 06/01/2003
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


