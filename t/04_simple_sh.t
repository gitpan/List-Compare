# 04_simple_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 3/28/2004
use Test::Simple tests =>
717;
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

#$memb_hash_ref = $lcsh->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));

$memb_hash_ref = $lcsh->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
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


ok($lcsh->is_member_any('abel'));       # 324
ok($lcsh->is_member_any('baker'));      # 325
ok($lcsh->is_member_any('camera'));     # 326
ok($lcsh->is_member_any('delta'));      # 327
ok($lcsh->is_member_any('edward'));     # 328
ok($lcsh->is_member_any('fargo'));      # 329
ok($lcsh->is_member_any('golfer'));     # 330
ok($lcsh->is_member_any('hilton'));     # 331
ok(! $lcsh->is_member_any('icon' ));    # 332
ok(! $lcsh->is_member_any('jerky'));    # 333
ok(! $lcsh->is_member_any('zebra'));    # 334

#$memb_hash_ref = $lcsh->are_members_any(qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra |);
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));

$memb_hash_ref = $lcsh->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 335
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 336
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 337
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 338
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 339
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 340
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 341
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 342
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 343
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 344
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 345

$vers = $lcsh->get_version;
ok($vers);                              # 346

my $lcsh_s  = List::Compare::SeenHash->new(\%h2, \%h3);
ok($lcsh_s);                            # 347

$LR = $lcsh_s->is_LsubsetR;
ok(! $LR);                              # 348

$LR = $lcsh_s->is_AsubsetB;
ok(! $LR);                              # 349

$RL = $lcsh_s->is_RsubsetL;
ok($RL);                                # 350

$RL = $lcsh_s->is_BsubsetA;
ok($RL);                                # 351

$eqv = $lcsh_s->is_LequivalentR;
ok(! $eqv);                             # 352

$eqv = $lcsh_s->is_LeqvlntR;
ok(! $eqv);                             # 353

my $lcsh_e  = List::Compare::SeenHash->new(\%h3, \%h4);

ok($lcsh_e);                            # 354

$eqv = $lcsh_e->is_LequivalentR;
ok($eqv);                               # 355

$eqv = $lcsh_e->is_LeqvlntR;
ok($eqv);                               # 356

########## BELOW:  Tests for '-u' option ##########

my $lcshu  = List::Compare::SeenHash->new('-u', \%h0, \%h1);

ok($lcshu);                             # 357

@union = $lcshu->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 358
ok(exists $seen{'baker'});              # 359
ok(exists $seen{'camera'});             # 360
ok(exists $seen{'delta'});              # 361
ok(exists $seen{'edward'});             # 362
ok(exists $seen{'fargo'});              # 363
ok(exists $seen{'golfer'});             # 364
ok(exists $seen{'hilton'});             # 365
ok(! exists $seen{'icon'});             # 366
ok(! exists $seen{'jerky'});            # 367
%seen = ();

$union_ref = $lcshu->get_union_ref;
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 368
ok(exists $seen{'baker'});              # 369
ok(exists $seen{'camera'});             # 370
ok(exists $seen{'delta'});              # 371
ok(exists $seen{'edward'});             # 372
ok(exists $seen{'fargo'});              # 373
ok(exists $seen{'golfer'});             # 374
ok(exists $seen{'hilton'});             # 375
ok(! exists $seen{'icon'});             # 376
ok(! exists $seen{'jerky'});            # 377
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = $lcshu->get_shared;
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 378
ok(exists $seen{'baker'});              # 379
ok(exists $seen{'camera'});             # 380
ok(exists $seen{'delta'});              # 381
ok(exists $seen{'edward'});             # 382
ok(exists $seen{'fargo'});              # 383
ok(exists $seen{'golfer'});             # 384
ok(exists $seen{'hilton'});             # 385
ok(! exists $seen{'icon'});             # 386
ok(! exists $seen{'jerky'});            # 387
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = $lcshu->get_shared_ref;
}
$seen{$_}++ foreach (@{$shared_ref});
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

@intersection = $lcshu->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 398
ok(exists $seen{'baker'});              # 399
ok(exists $seen{'camera'});             # 400
ok(exists $seen{'delta'});              # 401
ok(exists $seen{'edward'});             # 402
ok(exists $seen{'fargo'});              # 403
ok(exists $seen{'golfer'});             # 404
ok(! exists $seen{'hilton'});           # 405
ok(! exists $seen{'icon'});             # 406
ok(! exists $seen{'jerky'});            # 407
%seen = ();

$intersection_ref = $lcshu->get_intersection_ref;
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 408
ok(exists $seen{'baker'});              # 409
ok(exists $seen{'camera'});             # 410
ok(exists $seen{'delta'});              # 411
ok(exists $seen{'edward'});             # 412
ok(exists $seen{'fargo'});              # 413
ok(exists $seen{'golfer'});             # 414
ok(! exists $seen{'hilton'});           # 415
ok(! exists $seen{'icon'});             # 416
ok(! exists $seen{'jerky'});            # 417
%seen = ();

@unique = $lcshu->get_unique;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 418
ok(! exists $seen{'baker'});            # 419
ok(! exists $seen{'camera'});           # 420
ok(! exists $seen{'delta'});            # 421
ok(! exists $seen{'edward'});           # 422
ok(! exists $seen{'fargo'});            # 423
ok(! exists $seen{'golfer'});           # 424
ok(! exists $seen{'hilton'});           # 425
ok(! exists $seen{'icon'});             # 426
ok(! exists $seen{'jerky'});            # 427
%seen = ();

$unique_ref = $lcshu->get_unique_ref;
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 428
ok(! exists $seen{'baker'});            # 429
ok(! exists $seen{'camera'});           # 430
ok(! exists $seen{'delta'});            # 431
ok(! exists $seen{'edward'});           # 432
ok(! exists $seen{'fargo'});            # 433
ok(! exists $seen{'golfer'});           # 434
ok(! exists $seen{'hilton'});           # 435
ok(! exists $seen{'icon'});             # 436
ok(! exists $seen{'jerky'});            # 437
%seen = ();

@unique = $lcshu->get_Lonly;
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 438
ok(! exists $seen{'baker'});            # 439
ok(! exists $seen{'camera'});           # 440
ok(! exists $seen{'delta'});            # 441
ok(! exists $seen{'edward'});           # 442
ok(! exists $seen{'fargo'});            # 443
ok(! exists $seen{'golfer'});           # 444
ok(! exists $seen{'hilton'});           # 445
ok(! exists $seen{'icon'});             # 446
ok(! exists $seen{'jerky'});            # 447
%seen = ();

$unique_ref = $lcshu->get_Lonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

@unique = $lcshu->get_Aonly;
$seen{$_}++ foreach (@unique);
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

$unique_ref = $lcshu->get_Aonly_ref;
$seen{$_}++ foreach (@{$unique_ref});
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

@complement = $lcshu->get_complement;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 478
ok(! exists $seen{'baker'});            # 479
ok(! exists $seen{'camera'});           # 480
ok(! exists $seen{'delta'});            # 481
ok(! exists $seen{'edward'});           # 482
ok(! exists $seen{'fargo'});            # 483
ok(! exists $seen{'golfer'});           # 484
ok(exists $seen{'hilton'});             # 485
ok(! exists $seen{'icon'});             # 486
ok(! exists $seen{'jerky'});            # 487
%seen = ();

$complement_ref = $lcshu->get_complement_ref;
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 488
ok(! exists $seen{'baker'});            # 489
ok(! exists $seen{'camera'});           # 490
ok(! exists $seen{'delta'});            # 491
ok(! exists $seen{'edward'});           # 492
ok(! exists $seen{'fargo'});            # 493
ok(! exists $seen{'golfer'});           # 494
ok(exists $seen{'hilton'});             # 495
ok(! exists $seen{'icon'});             # 496
ok(! exists $seen{'jerky'});            # 497
%seen = ();

@complement = $lcshu->get_Ronly;
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 498
ok(! exists $seen{'baker'});            # 499
ok(! exists $seen{'camera'});           # 500
ok(! exists $seen{'delta'});            # 501
ok(! exists $seen{'edward'});           # 502
ok(! exists $seen{'fargo'});            # 503
ok(! exists $seen{'golfer'});           # 504
ok(exists $seen{'hilton'});             # 505
ok(! exists $seen{'icon'});             # 506
ok(! exists $seen{'jerky'});            # 507
%seen = ();

$complement_ref = $lcshu->get_Ronly_ref;
$seen{$_}++ foreach (@{$complement_ref});
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

@complement = $lcshu->get_Bonly;
$seen{$_}++ foreach (@complement);
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

$complement_ref = $lcshu->get_Bonly_ref;
$seen{$_}++ foreach (@{$complement_ref});
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

@symmetric_difference = $lcshu->get_symmetric_difference;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 538
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

$symmetric_difference_ref = $lcshu->get_symmetric_difference_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 548
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

@symmetric_difference = $lcshu->get_symdiff;
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 558
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

$symmetric_difference_ref = $lcshu->get_symdiff_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
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

@symmetric_difference = $lcshu->get_LorRonly;
$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lcshu->get_LorRonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
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

@symmetric_difference = $lcshu->get_AorBonly;
$seen{$_}++ foreach (@symmetric_difference);
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

$symmetric_difference_ref = $lcshu->get_AorBonly_ref;
$seen{$_}++ foreach (@{$symmetric_difference_ref});
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

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = $lcshu->get_nonintersection;
}
$seen{$_}++ foreach (@nonintersection);
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

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = $lcshu->get_nonintersection_ref;
}
$seen{$_}++ foreach (@{$nonintersection_ref});
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

$LR = $lcshu->is_LsubsetR;
ok(! $LR);                              # 638

$LR = $lcshu->is_AsubsetB;
ok(! $LR);                              # 639

$RL = $lcshu->is_RsubsetL;
ok(! $RL);                              # 640

$RL = $lcshu->is_BsubsetA;
ok(! $RL);                              # 641

$eqv = $lcshu->is_LequivalentR;
ok(! $eqv);                             # 642

$eqv = $lcshu->is_LeqvlntR;
ok(! $eqv);                             # 643

$return = $lcshu->print_subset_chart;
ok($return);                            # 644

$return = $lcshu->print_equivalence_chart;
ok($return);                            # 645

@memb_arr = $lcshu->is_member_which('abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 646

@memb_arr = $lcshu->is_member_which('baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 647

@memb_arr = $lcshu->is_member_which('camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 648

@memb_arr = $lcshu->is_member_which('delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 649

@memb_arr = $lcshu->is_member_which('edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 650

@memb_arr = $lcshu->is_member_which('fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 651

@memb_arr = $lcshu->is_member_which('golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 652

@memb_arr = $lcshu->is_member_which('hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 653

@memb_arr = $lcshu->is_member_which('icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 654

@memb_arr = $lcshu->is_member_which('jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 655

@memb_arr = $lcshu->is_member_which('zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 656


$memb_arr_ref = $lcshu->is_member_which_ref('abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 657

$memb_arr_ref = $lcshu->is_member_which_ref('baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 658

$memb_arr_ref = $lcshu->is_member_which_ref('camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 659

$memb_arr_ref = $lcshu->is_member_which_ref('delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 660

$memb_arr_ref = $lcshu->is_member_which_ref('edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 661

$memb_arr_ref = $lcshu->is_member_which_ref('fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 662

$memb_arr_ref = $lcshu->is_member_which_ref('golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 663

$memb_arr_ref = $lcshu->is_member_which_ref('hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 664

$memb_arr_ref = $lcshu->is_member_which_ref('icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 665

$memb_arr_ref = $lcshu->is_member_which_ref('jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 666

$memb_arr_ref = $lcshu->is_member_which_ref('zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 667

#$memb_hash_ref = $lcshu->are_members_which(qw| abel baker camera delta edward fargo 
#	golfer hilton icon jerky zebra |);
#ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));
#ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));

$memb_hash_ref = $lcshu->are_members_which( [ qw| abel baker camera delta edward fargo 
	golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 668
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 669
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 670
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 671
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 672
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 673
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 674
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 675
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 676
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 677
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 678


ok($lcshu->is_member_any('abel'));      # 679
ok($lcshu->is_member_any('baker'));     # 680
ok($lcshu->is_member_any('camera'));    # 681
ok($lcshu->is_member_any('delta'));     # 682
ok($lcshu->is_member_any('edward'));    # 683
ok($lcshu->is_member_any('fargo'));     # 684
ok($lcshu->is_member_any('golfer'));    # 685
ok($lcshu->is_member_any('hilton'));    # 686
ok(! $lcshu->is_member_any('icon' ));   # 687
ok(! $lcshu->is_member_any('jerky'));   # 688
ok(! $lcshu->is_member_any('zebra'));   # 689

#$memb_hash_ref = $lcshu->are_members_any(qw| abel baker camera delta edward fargo 
#    golfer hilton icon jerky zebra |);
#
#ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));
#ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));
#ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));
#ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));
#ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));
#ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));

$memb_hash_ref = $lcshu->are_members_any( [ qw| abel baker camera delta edward fargo 
    golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 690
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 691
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 692
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 693
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 694
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 695
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 696
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 697
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 698
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 699
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 700

$vers = $lcshu->get_version;
ok($vers);                              # 701

my $lcshu_s  = List::Compare::SeenHash->new('-u', \%h2, \%h3);
ok($lcshu_s);                           # 702

$LR = $lcshu_s->is_LsubsetR;
ok(! $LR);                              # 703

$LR = $lcshu_s->is_AsubsetB;
ok(! $LR);                              # 704

$RL = $lcshu_s->is_RsubsetL;
ok($RL);                                # 705

$RL = $lcshu_s->is_BsubsetA;
ok($RL);                                # 706

$eqv = $lcshu_s->is_LequivalentR;
ok(! $eqv);                             # 707

$eqv = $lcshu_s->is_LeqvlntR;
ok(! $eqv);                             # 708

my $lcshu_e  = List::Compare::SeenHash->new('-u', \%h3, \%h4);

ok($lcshu_e);                           # 709

$eqv = $lcshu_e->is_LequivalentR;
ok($eqv);                               # 710

$eqv = $lcshu_e->is_LeqvlntR;
ok($eqv);                               # 711

########## BELOW:  Tests for '--unsorted' option ##########

my $lcshun  = List::Compare::SeenHash->new('--unsorted', \%h0, \%h1);
ok($lcshun);                            # 712

my $lcshun_s  = List::Compare::SeenHash->new('--unsorted', \%h2, \%h3);
ok($lcshun_s);                          # 713

my $lcshun_e  = List::Compare::SeenHash->new('--unsorted', \%h3, \%h4);
ok($lcshun_e);                          # 714

########## BELOW:  Tests for bad values in seen-hash ##########

my ($f5, $f6, $f7);

eval { $f5 = List::Compare::SeenHash->new(\%h0, \%h5) };
ok(ok_capture_error($@));               # 715

eval { $f6 = List::Compare::SeenHash->new(\%h6, \%h0) };
ok(ok_capture_error($@));               # 716

eval { $f7 = List::Compare::SeenHash->new(\%h6, \%h7) };
ok(ok_capture_error($@));               # 717


