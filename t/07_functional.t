# 07_functional.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
995; $| = 1; print "1..$last_test_to_print\n"; } # 11/23/2003
END {print "not ok 1\n" unless $loaded;}
use lib ("./t");
use List::Compare;
use List::Compare::Functional qw(:originals :aliases);
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

@union = get_union(\@a0, \@a1);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 2
ok(exists $seen{'baker'});              # 3
ok(exists $seen{'camera'});             # 4
ok(exists $seen{'delta'});              # 5
ok(exists $seen{'edward'});             # 6
ok(exists $seen{'fargo'});              # 7
ok(exists $seen{'golfer'});             # 8
ok(exists $seen{'hilton'});             # 9
ok(! exists $seen{'icon'});             # 10
ok(! exists $seen{'jerky'});            # 11
%seen = ();

$union_ref = get_union_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 12
ok(exists $seen{'baker'});              # 13
ok(exists $seen{'camera'});             # 14
ok(exists $seen{'delta'});              # 15
ok(exists $seen{'edward'});             # 16
ok(exists $seen{'fargo'});              # 17
ok(exists $seen{'golfer'});             # 18
ok(exists $seen{'hilton'});             # 19
ok(! exists $seen{'icon'});             # 20
ok(! exists $seen{'jerky'});            # 21
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = get_shared(\@a0, \@a1);
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 22
ok(exists $seen{'baker'});              # 23
ok(exists $seen{'camera'});             # 24
ok(exists $seen{'delta'});              # 25
ok(exists $seen{'edward'});             # 26
ok(exists $seen{'fargo'});              # 27
ok(exists $seen{'golfer'});             # 28
ok(exists $seen{'hilton'});             # 29
ok(! exists $seen{'icon'});             # 30
ok(! exists $seen{'jerky'});            # 31
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = get_shared_ref(\@a0, \@a1);
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 32
ok(exists $seen{'baker'});              # 33
ok(exists $seen{'camera'});             # 34
ok(exists $seen{'delta'});              # 35
ok(exists $seen{'edward'});             # 36
ok(exists $seen{'fargo'});              # 37
ok(exists $seen{'golfer'});             # 38
ok(exists $seen{'hilton'});             # 39
ok(! exists $seen{'icon'});             # 40
ok(! exists $seen{'jerky'});            # 41
%seen = ();

@intersection = get_intersection(\@a0, \@a1);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 42
ok(exists $seen{'baker'});              # 43
ok(exists $seen{'camera'});             # 44
ok(exists $seen{'delta'});              # 45
ok(exists $seen{'edward'});             # 46
ok(exists $seen{'fargo'});              # 47
ok(exists $seen{'golfer'});             # 48
ok(! exists $seen{'hilton'});           # 49
ok(! exists $seen{'icon'});             # 50
ok(! exists $seen{'jerky'});            # 51
%seen = ();

$intersection_ref = get_intersection_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 52
ok(exists $seen{'baker'});              # 53
ok(exists $seen{'camera'});             # 54
ok(exists $seen{'delta'});              # 55
ok(exists $seen{'edward'});             # 56
ok(exists $seen{'fargo'});              # 57
ok(exists $seen{'golfer'});             # 58
ok(! exists $seen{'hilton'});           # 59
ok(! exists $seen{'icon'});             # 60
ok(! exists $seen{'jerky'});            # 61
%seen = ();

@unique = get_unique(\@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 62
ok(! exists $seen{'baker'});            # 63
ok(! exists $seen{'camera'});           # 64
ok(! exists $seen{'delta'});            # 65
ok(! exists $seen{'edward'});           # 66
ok(! exists $seen{'fargo'});            # 67
ok(! exists $seen{'golfer'});           # 68
ok(! exists $seen{'hilton'});           # 69
ok(! exists $seen{'icon'});             # 70
ok(! exists $seen{'jerky'});            # 71
%seen = ();

$unique_ref = get_unique_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 72
ok(! exists $seen{'baker'});            # 73
ok(! exists $seen{'camera'});           # 74
ok(! exists $seen{'delta'});            # 75
ok(! exists $seen{'edward'});           # 76
ok(! exists $seen{'fargo'});            # 77
ok(! exists $seen{'golfer'});           # 78
ok(! exists $seen{'hilton'});           # 79
ok(! exists $seen{'icon'});             # 80
ok(! exists $seen{'jerky'});            # 81
%seen = ();

@unique = get_Lonly(\@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 82
ok(! exists $seen{'baker'});            # 83
ok(! exists $seen{'camera'});           # 84
ok(! exists $seen{'delta'});            # 85
ok(! exists $seen{'edward'});           # 86
ok(! exists $seen{'fargo'});            # 87
ok(! exists $seen{'golfer'});           # 88
ok(! exists $seen{'hilton'});           # 89
ok(! exists $seen{'icon'});             # 90
ok(! exists $seen{'jerky'});            # 91
%seen = ();

$unique_ref = get_Lonly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 92
ok(! exists $seen{'baker'});            # 93
ok(! exists $seen{'camera'});           # 94
ok(! exists $seen{'delta'});            # 95
ok(! exists $seen{'edward'});           # 96
ok(! exists $seen{'fargo'});            # 97
ok(! exists $seen{'golfer'});           # 98
ok(! exists $seen{'hilton'});           # 99
ok(! exists $seen{'icon'});             # 100
ok(! exists $seen{'jerky'});            # 101
%seen = ();

@unique = get_Aonly(\@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 102
ok(! exists $seen{'baker'});            # 103
ok(! exists $seen{'camera'});           # 104
ok(! exists $seen{'delta'});            # 105
ok(! exists $seen{'edward'});           # 106
ok(! exists $seen{'fargo'});            # 107
ok(! exists $seen{'golfer'});           # 108
ok(! exists $seen{'hilton'});           # 109
ok(! exists $seen{'icon'});             # 110
ok(! exists $seen{'jerky'});            # 111
%seen = ();

$unique_ref = get_Aonly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 112
ok(! exists $seen{'baker'});            # 113
ok(! exists $seen{'camera'});           # 114
ok(! exists $seen{'delta'});            # 115
ok(! exists $seen{'edward'});           # 116
ok(! exists $seen{'fargo'});            # 117
ok(! exists $seen{'golfer'});           # 118
ok(! exists $seen{'hilton'});           # 119
ok(! exists $seen{'icon'});             # 120
ok(! exists $seen{'jerky'});            # 121
%seen = ();

@complement = get_complement(\@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 122
ok(! exists $seen{'baker'});            # 123
ok(! exists $seen{'camera'});           # 124
ok(! exists $seen{'delta'});            # 125
ok(! exists $seen{'edward'});           # 126
ok(! exists $seen{'fargo'});            # 127
ok(! exists $seen{'golfer'});           # 128
ok(exists $seen{'hilton'});             # 129
ok(! exists $seen{'icon'});             # 130
ok(! exists $seen{'jerky'});            # 131
%seen = ();

$complement_ref = get_complement_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 132
ok(! exists $seen{'baker'});            # 133
ok(! exists $seen{'camera'});           # 134
ok(! exists $seen{'delta'});            # 135
ok(! exists $seen{'edward'});           # 136
ok(! exists $seen{'fargo'});            # 137
ok(! exists $seen{'golfer'});           # 138
ok(exists $seen{'hilton'});             # 139
ok(! exists $seen{'icon'});             # 140
ok(! exists $seen{'jerky'});            # 141
%seen = ();

@complement = get_Ronly(\@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 142
ok(! exists $seen{'baker'});            # 143
ok(! exists $seen{'camera'});           # 144
ok(! exists $seen{'delta'});            # 145
ok(! exists $seen{'edward'});           # 146
ok(! exists $seen{'fargo'});            # 147
ok(! exists $seen{'golfer'});           # 148
ok(exists $seen{'hilton'});             # 149
ok(! exists $seen{'icon'});             # 150
ok(! exists $seen{'jerky'});            # 151
%seen = ();

$complement_ref = get_Ronly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 152
ok(! exists $seen{'baker'});            # 153
ok(! exists $seen{'camera'});           # 154
ok(! exists $seen{'delta'});            # 155
ok(! exists $seen{'edward'});           # 156
ok(! exists $seen{'fargo'});            # 157
ok(! exists $seen{'golfer'});           # 158
ok(exists $seen{'hilton'});             # 159
ok(! exists $seen{'icon'});             # 160
ok(! exists $seen{'jerky'});            # 161
%seen = ();

@complement = get_Bonly(\@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 162
ok(! exists $seen{'baker'});            # 163
ok(! exists $seen{'camera'});           # 164
ok(! exists $seen{'delta'});            # 165
ok(! exists $seen{'edward'});           # 166
ok(! exists $seen{'fargo'});            # 167
ok(! exists $seen{'golfer'});           # 168
ok(exists $seen{'hilton'});             # 169
ok(! exists $seen{'icon'});             # 170
ok(! exists $seen{'jerky'});            # 171
%seen = ();

$complement_ref = get_Bonly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 172
ok(! exists $seen{'baker'});            # 173
ok(! exists $seen{'camera'});           # 174
ok(! exists $seen{'delta'});            # 175
ok(! exists $seen{'edward'});           # 176
ok(! exists $seen{'fargo'});            # 177
ok(! exists $seen{'golfer'});           # 178
ok(exists $seen{'hilton'});             # 179
ok(! exists $seen{'icon'});             # 180
ok(! exists $seen{'jerky'});            # 181
%seen = ();

@symmetric_difference = get_symmetric_difference(\@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 182
ok(! exists $seen{'baker'});            # 183
ok(! exists $seen{'camera'});           # 184
ok(! exists $seen{'delta'});            # 185
ok(! exists $seen{'edward'});           # 186
ok(! exists $seen{'fargo'});            # 187
ok(! exists $seen{'golfer'});           # 188
ok(exists $seen{'hilton'});             # 189
ok(! exists $seen{'icon'});             # 190
ok(! exists $seen{'jerky'});            # 191
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 192
ok(! exists $seen{'baker'});            # 193
ok(! exists $seen{'camera'});           # 194
ok(! exists $seen{'delta'});            # 195
ok(! exists $seen{'edward'});           # 196
ok(! exists $seen{'fargo'});            # 197
ok(! exists $seen{'golfer'});           # 198
ok(exists $seen{'hilton'});             # 199
ok(! exists $seen{'icon'});             # 200
ok(! exists $seen{'jerky'});            # 201
%seen = ();

@symmetric_difference = get_symdiff(\@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 202
ok(! exists $seen{'baker'});            # 203
ok(! exists $seen{'camera'});           # 204
ok(! exists $seen{'delta'});            # 205
ok(! exists $seen{'edward'});           # 206
ok(! exists $seen{'fargo'});            # 207
ok(! exists $seen{'golfer'});           # 208
ok(exists $seen{'hilton'});             # 209
ok(! exists $seen{'icon'});             # 210
ok(! exists $seen{'jerky'});            # 211
%seen = ();

$symmetric_difference_ref = get_symdiff_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 212
ok(! exists $seen{'baker'});            # 213
ok(! exists $seen{'camera'});           # 214
ok(! exists $seen{'delta'});            # 215
ok(! exists $seen{'edward'});           # 216
ok(! exists $seen{'fargo'});            # 217
ok(! exists $seen{'golfer'});           # 218
ok(exists $seen{'hilton'});             # 219
ok(! exists $seen{'icon'});             # 220
ok(! exists $seen{'jerky'});            # 221
%seen = ();

@symmetric_difference = get_LorRonly(\@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 222
ok(! exists $seen{'baker'});            # 223
ok(! exists $seen{'camera'});           # 224
ok(! exists $seen{'delta'});            # 225
ok(! exists $seen{'edward'});           # 226
ok(! exists $seen{'fargo'});            # 227
ok(! exists $seen{'golfer'});           # 228
ok(exists $seen{'hilton'});             # 229
ok(! exists $seen{'icon'});             # 230
ok(! exists $seen{'jerky'});            # 231
%seen = ();

$symmetric_difference_ref = get_LorRonly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 232
ok(! exists $seen{'baker'});            # 233
ok(! exists $seen{'camera'});           # 234
ok(! exists $seen{'delta'});            # 235
ok(! exists $seen{'edward'});           # 236
ok(! exists $seen{'fargo'});            # 237
ok(! exists $seen{'golfer'});           # 238
ok(exists $seen{'hilton'});             # 239
ok(! exists $seen{'icon'});             # 240
ok(! exists $seen{'jerky'});            # 241
%seen = ();

@symmetric_difference = get_AorBonly(\@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 242
ok(! exists $seen{'baker'});            # 243
ok(! exists $seen{'camera'});           # 244
ok(! exists $seen{'delta'});            # 245
ok(! exists $seen{'edward'});           # 246
ok(! exists $seen{'fargo'});            # 247
ok(! exists $seen{'golfer'});           # 248
ok(exists $seen{'hilton'});             # 249
ok(! exists $seen{'icon'});             # 250
ok(! exists $seen{'jerky'});            # 251
%seen = ();

$symmetric_difference_ref = get_AorBonly_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 252
ok(! exists $seen{'baker'});            # 253
ok(! exists $seen{'camera'});           # 254
ok(! exists $seen{'delta'});            # 255
ok(! exists $seen{'edward'});           # 256
ok(! exists $seen{'fargo'});            # 257
ok(! exists $seen{'golfer'});           # 258
ok(exists $seen{'hilton'});             # 259
ok(! exists $seen{'icon'});             # 260
ok(! exists $seen{'jerky'});            # 261
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = get_nonintersection(\@a0, \@a1);
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 262
ok(! exists $seen{'baker'});            # 263
ok(! exists $seen{'camera'});           # 264
ok(! exists $seen{'delta'});            # 265
ok(! exists $seen{'edward'});           # 266
ok(! exists $seen{'fargo'});            # 267
ok(! exists $seen{'golfer'});           # 268
ok(exists $seen{'hilton'});             # 269
ok(! exists $seen{'icon'});             # 270
ok(! exists $seen{'jerky'});            # 271
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = get_nonintersection_ref(\@a0, \@a1);
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 272
ok(! exists $seen{'baker'});            # 273
ok(! exists $seen{'camera'});           # 274
ok(! exists $seen{'delta'});            # 275
ok(! exists $seen{'edward'});           # 276
ok(! exists $seen{'fargo'});            # 277
ok(! exists $seen{'golfer'});           # 278
ok(exists $seen{'hilton'});             # 279
ok(! exists $seen{'icon'});             # 280
ok(! exists $seen{'jerky'});            # 281
%seen = ();

@bag = get_bag(\@a0, \@a1);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 282
ok($seen{'baker'} == 2);                # 283
ok($seen{'camera'} == 2);               # 284
ok($seen{'delta'} == 3);                # 285
ok($seen{'edward'} == 2);               # 286
ok($seen{'fargo'} == 2);                # 287
ok($seen{'golfer'} == 2);               # 288
ok($seen{'hilton'} == 1);               # 289
ok(! exists $seen{'icon'});             # 290
ok(! exists $seen{'jerky'});            # 291
%seen = ();

$bag_ref = get_bag_ref(\@a0, \@a1);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 292
ok($seen{'baker'} == 2);                # 293
ok($seen{'camera'} == 2);               # 294
ok($seen{'delta'} == 3);                # 295
ok($seen{'edward'} == 2);               # 296
ok($seen{'fargo'} == 2);                # 297
ok($seen{'golfer'} == 2);               # 298
ok($seen{'hilton'} == 1);               # 299
ok(! exists $seen{'icon'});             # 300
ok(! exists $seen{'jerky'});            # 301
%seen = ();

$LR = is_LsubsetR(\@a0, \@a1);
ok(! $LR);                              # 302

$LR = is_AsubsetB(\@a0, \@a1);
ok(! $LR);                              # 303

$RL = is_RsubsetL(\@a0, \@a1);
ok(! $RL);                              # 304

$RL = is_BsubsetA(\@a0, \@a1);
ok(! $RL);                              # 305

$eqv = is_LequivalentR(\@a0, \@a1);
ok(! $eqv);                             # 306

$eqv = is_LeqvlntR(\@a0, \@a1);
ok(! $eqv);                             # 307

$return = print_subset_chart(\@a0, \@a1);
ok($return);                            # 308

$return = print_equivalence_chart(\@a0, \@a1);
ok($return);                            # 309

@memb_arr = is_member_which(\@a0, \@a1, 'abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 310

@memb_arr = is_member_which(\@a0, \@a1, 'baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 311

@memb_arr = is_member_which(\@a0, \@a1, 'camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 312

@memb_arr = is_member_which(\@a0, \@a1, 'delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 313

@memb_arr = is_member_which(\@a0, \@a1, 'edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 314

@memb_arr = is_member_which(\@a0, \@a1, 'fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 315

@memb_arr = is_member_which(\@a0, \@a1, 'golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 316

@memb_arr = is_member_which(\@a0, \@a1, 'hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 317

@memb_arr = is_member_which(\@a0, \@a1, 'icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 318

@memb_arr = is_member_which(\@a0, \@a1, 'jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 319

@memb_arr = is_member_which(\@a0, \@a1, 'zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 320


$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 321

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 322

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 323

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 328

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 329

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 330

$memb_arr_ref = is_member_which_ref(\@a0, \@a1, 'zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 331


$memb_hash_ref = are_members_which(\@a0, \@a1, 
	qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra |);
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 332
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 333
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 334
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 335
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 336
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 337
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 338
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 339
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 340
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 341
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 342

$memb_hash_ref = are_members_which( \@a0, \@a1, 
	[ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 343
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 344
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 345
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 346
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 347
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 348
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 349
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 350
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 351
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 352
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 353


ok(is_member_any(\@a0, \@a1, 'abel'));  # 354
ok(is_member_any(\@a0, \@a1, 'baker')); # 355
ok(is_member_any(\@a0, \@a1, 'camera'));# 356
ok(is_member_any(\@a0, \@a1, 'delta')); # 357
ok(is_member_any(\@a0, \@a1, 'edward'));# 358
ok(is_member_any(\@a0, \@a1, 'fargo')); # 359
ok(is_member_any(\@a0, \@a1, 'golfer'));# 360
ok(is_member_any(\@a0, \@a1, 'hilton'));# 361
ok(! is_member_any(\@a0, \@a1, 'icon' ));# 362
ok(! is_member_any(\@a0, \@a1, 'jerky'));# 363
ok(! is_member_any(\@a0, \@a1, 'zebra'));# 364

$memb_hash_ref = are_members_any(\@a0, \@a1, 
	qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra |);

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 365
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 366
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 367
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 368
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 369
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 370
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 371
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 372
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 373
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 374
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 375

$memb_hash_ref = are_members_any( \@a0, \@a1, 
	[ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 376
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 377
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 378
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 379
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 380
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 381
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 382
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 383
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 384
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 385
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 386

$vers = get_version;
ok($vers);                              # 387

$LR = is_LsubsetR(\@a2, \@a3);
ok(! $LR);                              # 388

$LR = is_AsubsetB(\@a2, \@a3);
ok(! $LR);                              # 389

$RL = is_RsubsetL(\@a2, \@a3);
ok($RL);                                # 390

$RL = is_BsubsetA(\@a2, \@a3);
ok($RL);                                # 391

$eqv = is_LequivalentR(\@a2, \@a3);
ok(! $eqv);                             # 392

$eqv = is_LeqvlntR(\@a2, \@a3);
ok(! $eqv);                             # 393

$eqv = is_LequivalentR(\@a3, \@a4);
ok($eqv);                               # 394

$eqv = is_LeqvlntR(\@a3, \@a4);
ok($eqv);                               # 395

########## BELOW:  Tests for '-u' option ##########

@union = get_union('-u', \@a0, \@a1);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 396
ok(exists $seen{'baker'});              # 397
ok(exists $seen{'camera'});             # 398
ok(exists $seen{'delta'});              # 399
ok(exists $seen{'edward'});             # 400
ok(exists $seen{'fargo'});              # 401
ok(exists $seen{'golfer'});             # 402
ok(exists $seen{'hilton'});             # 403
ok(! exists $seen{'icon'});             # 404
ok(! exists $seen{'jerky'});            # 405
%seen = ();

$union_ref = get_union_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 406
ok(exists $seen{'baker'});              # 407
ok(exists $seen{'camera'});             # 408
ok(exists $seen{'delta'});              # 409
ok(exists $seen{'edward'});             # 410
ok(exists $seen{'fargo'});              # 411
ok(exists $seen{'golfer'});             # 412
ok(exists $seen{'hilton'});             # 413
ok(! exists $seen{'icon'});             # 414
ok(! exists $seen{'jerky'});            # 415
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = get_shared('-u', \@a0, \@a1);
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 416
ok(exists $seen{'baker'});              # 417
ok(exists $seen{'camera'});             # 418
ok(exists $seen{'delta'});              # 419
ok(exists $seen{'edward'});             # 420
ok(exists $seen{'fargo'});              # 421
ok(exists $seen{'golfer'});             # 422
ok(exists $seen{'hilton'});             # 423
ok(! exists $seen{'icon'});             # 424
ok(! exists $seen{'jerky'});            # 425
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = get_shared_ref('-u', \@a0, \@a1);
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 426
ok(exists $seen{'baker'});              # 427
ok(exists $seen{'camera'});             # 428
ok(exists $seen{'delta'});              # 429
ok(exists $seen{'edward'});             # 430
ok(exists $seen{'fargo'});              # 431
ok(exists $seen{'golfer'});             # 432
ok(exists $seen{'hilton'});             # 433
ok(! exists $seen{'icon'});             # 434
ok(! exists $seen{'jerky'});            # 435
%seen = ();

@intersection = get_intersection('-u', \@a0, \@a1);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 436
ok(exists $seen{'baker'});              # 437
ok(exists $seen{'camera'});             # 438
ok(exists $seen{'delta'});              # 439
ok(exists $seen{'edward'});             # 440
ok(exists $seen{'fargo'});              # 441
ok(exists $seen{'golfer'});             # 442
ok(! exists $seen{'hilton'});           # 443
ok(! exists $seen{'icon'});             # 444
ok(! exists $seen{'jerky'});            # 445
%seen = ();

$intersection_ref = get_intersection_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 446
ok(exists $seen{'baker'});              # 447
ok(exists $seen{'camera'});             # 448
ok(exists $seen{'delta'});              # 449
ok(exists $seen{'edward'});             # 450
ok(exists $seen{'fargo'});              # 451
ok(exists $seen{'golfer'});             # 452
ok(! exists $seen{'hilton'});           # 453
ok(! exists $seen{'icon'});             # 454
ok(! exists $seen{'jerky'});            # 455
%seen = ();

@unique = get_unique('-u', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 456
ok(! exists $seen{'baker'});            # 457
ok(! exists $seen{'camera'});           # 458
ok(! exists $seen{'delta'});            # 459
ok(! exists $seen{'edward'});           # 460
ok(! exists $seen{'fargo'});            # 461
ok(! exists $seen{'golfer'});           # 462
ok(! exists $seen{'hilton'});           # 463
ok(! exists $seen{'icon'});             # 464
ok(! exists $seen{'jerky'});            # 465
%seen = ();

$unique_ref = get_unique_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 466
ok(! exists $seen{'baker'});            # 467
ok(! exists $seen{'camera'});           # 468
ok(! exists $seen{'delta'});            # 469
ok(! exists $seen{'edward'});           # 470
ok(! exists $seen{'fargo'});            # 471
ok(! exists $seen{'golfer'});           # 472
ok(! exists $seen{'hilton'});           # 473
ok(! exists $seen{'icon'});             # 474
ok(! exists $seen{'jerky'});            # 475
%seen = ();

@unique = get_Lonly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 476
ok(! exists $seen{'baker'});            # 477
ok(! exists $seen{'camera'});           # 478
ok(! exists $seen{'delta'});            # 479
ok(! exists $seen{'edward'});           # 480
ok(! exists $seen{'fargo'});            # 481
ok(! exists $seen{'golfer'});           # 482
ok(! exists $seen{'hilton'});           # 483
ok(! exists $seen{'icon'});             # 484
ok(! exists $seen{'jerky'});            # 485
%seen = ();

$unique_ref = get_Lonly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 486
ok(! exists $seen{'baker'});            # 487
ok(! exists $seen{'camera'});           # 488
ok(! exists $seen{'delta'});            # 489
ok(! exists $seen{'edward'});           # 490
ok(! exists $seen{'fargo'});            # 491
ok(! exists $seen{'golfer'});           # 492
ok(! exists $seen{'hilton'});           # 493
ok(! exists $seen{'icon'});             # 494
ok(! exists $seen{'jerky'});            # 495
%seen = ();

@unique = get_Aonly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 496
ok(! exists $seen{'baker'});            # 497
ok(! exists $seen{'camera'});           # 498
ok(! exists $seen{'delta'});            # 499
ok(! exists $seen{'edward'});           # 500
ok(! exists $seen{'fargo'});            # 501
ok(! exists $seen{'golfer'});           # 502
ok(! exists $seen{'hilton'});           # 503
ok(! exists $seen{'icon'});             # 504
ok(! exists $seen{'jerky'});            # 505
%seen = ();

$unique_ref = get_Aonly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 506
ok(! exists $seen{'baker'});            # 507
ok(! exists $seen{'camera'});           # 508
ok(! exists $seen{'delta'});            # 509
ok(! exists $seen{'edward'});           # 510
ok(! exists $seen{'fargo'});            # 511
ok(! exists $seen{'golfer'});           # 512
ok(! exists $seen{'hilton'});           # 513
ok(! exists $seen{'icon'});             # 514
ok(! exists $seen{'jerky'});            # 515
%seen = ();

@complement = get_complement('-u', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 516
ok(! exists $seen{'baker'});            # 517
ok(! exists $seen{'camera'});           # 518
ok(! exists $seen{'delta'});            # 519
ok(! exists $seen{'edward'});           # 520
ok(! exists $seen{'fargo'});            # 521
ok(! exists $seen{'golfer'});           # 522
ok(exists $seen{'hilton'});             # 523
ok(! exists $seen{'icon'});             # 524
ok(! exists $seen{'jerky'});            # 525
%seen = ();

$complement_ref = get_complement_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 526
ok(! exists $seen{'baker'});            # 527
ok(! exists $seen{'camera'});           # 528
ok(! exists $seen{'delta'});            # 529
ok(! exists $seen{'edward'});           # 530
ok(! exists $seen{'fargo'});            # 531
ok(! exists $seen{'golfer'});           # 532
ok(exists $seen{'hilton'});             # 533
ok(! exists $seen{'icon'});             # 534
ok(! exists $seen{'jerky'});            # 535
%seen = ();

@complement = get_Ronly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 536
ok(! exists $seen{'baker'});            # 537
ok(! exists $seen{'camera'});           # 538
ok(! exists $seen{'delta'});            # 539
ok(! exists $seen{'edward'});           # 540
ok(! exists $seen{'fargo'});            # 541
ok(! exists $seen{'golfer'});           # 542
ok(exists $seen{'hilton'});             # 543
ok(! exists $seen{'icon'});             # 544
ok(! exists $seen{'jerky'});            # 545
%seen = ();

$complement_ref = get_Ronly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 546
ok(! exists $seen{'baker'});            # 547
ok(! exists $seen{'camera'});           # 548
ok(! exists $seen{'delta'});            # 549
ok(! exists $seen{'edward'});           # 550
ok(! exists $seen{'fargo'});            # 551
ok(! exists $seen{'golfer'});           # 552
ok(exists $seen{'hilton'});             # 553
ok(! exists $seen{'icon'});             # 554
ok(! exists $seen{'jerky'});            # 555
%seen = ();

@complement = get_Bonly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 556
ok(! exists $seen{'baker'});            # 557
ok(! exists $seen{'camera'});           # 558
ok(! exists $seen{'delta'});            # 559
ok(! exists $seen{'edward'});           # 560
ok(! exists $seen{'fargo'});            # 561
ok(! exists $seen{'golfer'});           # 562
ok(exists $seen{'hilton'});             # 563
ok(! exists $seen{'icon'});             # 564
ok(! exists $seen{'jerky'});            # 565
%seen = ();

$complement_ref = get_Bonly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 566
ok(! exists $seen{'baker'});            # 567
ok(! exists $seen{'camera'});           # 568
ok(! exists $seen{'delta'});            # 569
ok(! exists $seen{'edward'});           # 570
ok(! exists $seen{'fargo'});            # 571
ok(! exists $seen{'golfer'});           # 572
ok(exists $seen{'hilton'});             # 573
ok(! exists $seen{'icon'});             # 574
ok(! exists $seen{'jerky'});            # 575
%seen = ();

@symmetric_difference = get_symmetric_difference('-u', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 576
ok(! exists $seen{'baker'});            # 577
ok(! exists $seen{'camera'});           # 578
ok(! exists $seen{'delta'});            # 579
ok(! exists $seen{'edward'});           # 580
ok(! exists $seen{'fargo'});            # 581
ok(! exists $seen{'golfer'});           # 582
ok(exists $seen{'hilton'});             # 583
ok(! exists $seen{'icon'});             # 584
ok(! exists $seen{'jerky'});            # 585
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 586
ok(! exists $seen{'baker'});            # 587
ok(! exists $seen{'camera'});           # 588
ok(! exists $seen{'delta'});            # 589
ok(! exists $seen{'edward'});           # 590
ok(! exists $seen{'fargo'});            # 591
ok(! exists $seen{'golfer'});           # 592
ok(exists $seen{'hilton'});             # 593
ok(! exists $seen{'icon'});             # 594
ok(! exists $seen{'jerky'});            # 595
%seen = ();

@symmetric_difference = get_symdiff('-u', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 596
ok(! exists $seen{'baker'});            # 597
ok(! exists $seen{'camera'});           # 598
ok(! exists $seen{'delta'});            # 599
ok(! exists $seen{'edward'});           # 600
ok(! exists $seen{'fargo'});            # 601
ok(! exists $seen{'golfer'});           # 602
ok(exists $seen{'hilton'});             # 603
ok(! exists $seen{'icon'});             # 604
ok(! exists $seen{'jerky'});            # 605
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 606
ok(! exists $seen{'baker'});            # 607
ok(! exists $seen{'camera'});           # 608
ok(! exists $seen{'delta'});            # 609
ok(! exists $seen{'edward'});           # 610
ok(! exists $seen{'fargo'});            # 611
ok(! exists $seen{'golfer'});           # 612
ok(exists $seen{'hilton'});             # 613
ok(! exists $seen{'icon'});             # 614
ok(! exists $seen{'jerky'});            # 615
%seen = ();

@symmetric_difference = get_LorRonly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 616
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

$symmetric_difference_ref = get_LorRonly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 626
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

@symmetric_difference = get_AorBonly('-u', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 636
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

$symmetric_difference_ref = get_AorBonly_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 646
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

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = get_nonintersection('-u', \@a0, \@a1);
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 656
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

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = get_nonintersection_ref('-u', \@a0, \@a1);
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 666
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

@bag = get_bag('-u', \@a0, \@a1);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 676
ok($seen{'baker'} == 2);                # 677
ok($seen{'camera'} == 2);               # 678
ok($seen{'delta'} == 3);                # 679
ok($seen{'edward'} == 2);               # 680
ok($seen{'fargo'} == 2);                # 681
ok($seen{'golfer'} == 2);               # 682
ok($seen{'hilton'} == 1);               # 683
ok(! exists $seen{'icon'});             # 684
ok(! exists $seen{'jerky'});            # 685
%seen = ();

$bag_ref = get_bag_ref('-u', \@a0, \@a1);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 686
ok($seen{'baker'} == 2);                # 687
ok($seen{'camera'} == 2);               # 688
ok($seen{'delta'} == 3);                # 689
ok($seen{'edward'} == 2);               # 690
ok($seen{'fargo'} == 2);                # 691
ok($seen{'golfer'} == 2);               # 692
ok($seen{'hilton'} == 1);               # 693
ok(! exists $seen{'icon'});             # 694
ok(! exists $seen{'jerky'});            # 695
%seen = ();

##### BELOW:  Tests for '--unsorted' option ##########

@union = get_union('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 696
ok(exists $seen{'baker'});              # 697
ok(exists $seen{'camera'});             # 698
ok(exists $seen{'delta'});              # 699
ok(exists $seen{'edward'});             # 700
ok(exists $seen{'fargo'});              # 701
ok(exists $seen{'golfer'});             # 702
ok(exists $seen{'hilton'});             # 703
ok(! exists $seen{'icon'});             # 704
ok(! exists $seen{'jerky'});            # 705
%seen = ();

$union_ref = get_union_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 706
ok(exists $seen{'baker'});              # 707
ok(exists $seen{'camera'});             # 708
ok(exists $seen{'delta'});              # 709
ok(exists $seen{'edward'});             # 710
ok(exists $seen{'fargo'});              # 711
ok(exists $seen{'golfer'});             # 712
ok(exists $seen{'hilton'});             # 713
ok(! exists $seen{'icon'});             # 714
ok(! exists $seen{'jerky'});            # 715
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@shared = get_shared('--unsorted', \@a0, \@a1);
}
$seen{$_}++ foreach (@shared);
ok(exists $seen{'abel'});               # 716
ok(exists $seen{'baker'});              # 717
ok(exists $seen{'camera'});             # 718
ok(exists $seen{'delta'});              # 719
ok(exists $seen{'edward'});             # 720
ok(exists $seen{'fargo'});              # 721
ok(exists $seen{'golfer'});             # 722
ok(exists $seen{'hilton'});             # 723
ok(! exists $seen{'icon'});             # 724
ok(! exists $seen{'jerky'});            # 725
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$shared_ref = get_shared_ref('--unsorted', \@a0, \@a1);
}
$seen{$_}++ foreach (@{$shared_ref});
ok(exists $seen{'abel'});               # 726
ok(exists $seen{'baker'});              # 727
ok(exists $seen{'camera'});             # 728
ok(exists $seen{'delta'});              # 729
ok(exists $seen{'edward'});             # 730
ok(exists $seen{'fargo'});              # 731
ok(exists $seen{'golfer'});             # 732
ok(exists $seen{'hilton'});             # 733
ok(! exists $seen{'icon'});             # 734
ok(! exists $seen{'jerky'});            # 735
%seen = ();

@intersection = get_intersection('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 736
ok(exists $seen{'baker'});              # 737
ok(exists $seen{'camera'});             # 738
ok(exists $seen{'delta'});              # 739
ok(exists $seen{'edward'});             # 740
ok(exists $seen{'fargo'});              # 741
ok(exists $seen{'golfer'});             # 742
ok(! exists $seen{'hilton'});           # 743
ok(! exists $seen{'icon'});             # 744
ok(! exists $seen{'jerky'});            # 745
%seen = ();

$intersection_ref = get_intersection_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 746
ok(exists $seen{'baker'});              # 747
ok(exists $seen{'camera'});             # 748
ok(exists $seen{'delta'});              # 749
ok(exists $seen{'edward'});             # 750
ok(exists $seen{'fargo'});              # 751
ok(exists $seen{'golfer'});             # 752
ok(! exists $seen{'hilton'});           # 753
ok(! exists $seen{'icon'});             # 754
ok(! exists $seen{'jerky'});            # 755
%seen = ();

@unique = get_unique('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 756
ok(! exists $seen{'baker'});            # 757
ok(! exists $seen{'camera'});           # 758
ok(! exists $seen{'delta'});            # 759
ok(! exists $seen{'edward'});           # 760
ok(! exists $seen{'fargo'});            # 761
ok(! exists $seen{'golfer'});           # 762
ok(! exists $seen{'hilton'});           # 763
ok(! exists $seen{'icon'});             # 764
ok(! exists $seen{'jerky'});            # 765
%seen = ();

$unique_ref = get_unique_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 766
ok(! exists $seen{'baker'});            # 767
ok(! exists $seen{'camera'});           # 768
ok(! exists $seen{'delta'});            # 769
ok(! exists $seen{'edward'});           # 770
ok(! exists $seen{'fargo'});            # 771
ok(! exists $seen{'golfer'});           # 772
ok(! exists $seen{'hilton'});           # 773
ok(! exists $seen{'icon'});             # 774
ok(! exists $seen{'jerky'});            # 775
%seen = ();

@unique = get_Lonly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 776
ok(! exists $seen{'baker'});            # 777
ok(! exists $seen{'camera'});           # 778
ok(! exists $seen{'delta'});            # 779
ok(! exists $seen{'edward'});           # 780
ok(! exists $seen{'fargo'});            # 781
ok(! exists $seen{'golfer'});           # 782
ok(! exists $seen{'hilton'});           # 783
ok(! exists $seen{'icon'});             # 784
ok(! exists $seen{'jerky'});            # 785
%seen = ();

$unique_ref = get_Lonly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 786
ok(! exists $seen{'baker'});            # 787
ok(! exists $seen{'camera'});           # 788
ok(! exists $seen{'delta'});            # 789
ok(! exists $seen{'edward'});           # 790
ok(! exists $seen{'fargo'});            # 791
ok(! exists $seen{'golfer'});           # 792
ok(! exists $seen{'hilton'});           # 793
ok(! exists $seen{'icon'});             # 794
ok(! exists $seen{'jerky'});            # 795
%seen = ();

@unique = get_Aonly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 796
ok(! exists $seen{'baker'});            # 797
ok(! exists $seen{'camera'});           # 798
ok(! exists $seen{'delta'});            # 799
ok(! exists $seen{'edward'});           # 800
ok(! exists $seen{'fargo'});            # 801
ok(! exists $seen{'golfer'});           # 802
ok(! exists $seen{'hilton'});           # 803
ok(! exists $seen{'icon'});             # 804
ok(! exists $seen{'jerky'});            # 805
%seen = ();

$unique_ref = get_Aonly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 806
ok(! exists $seen{'baker'});            # 807
ok(! exists $seen{'camera'});           # 808
ok(! exists $seen{'delta'});            # 809
ok(! exists $seen{'edward'});           # 810
ok(! exists $seen{'fargo'});            # 811
ok(! exists $seen{'golfer'});           # 812
ok(! exists $seen{'hilton'});           # 813
ok(! exists $seen{'icon'});             # 814
ok(! exists $seen{'jerky'});            # 815
%seen = ();

@complement = get_complement('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 816
ok(! exists $seen{'baker'});            # 817
ok(! exists $seen{'camera'});           # 818
ok(! exists $seen{'delta'});            # 819
ok(! exists $seen{'edward'});           # 820
ok(! exists $seen{'fargo'});            # 821
ok(! exists $seen{'golfer'});           # 822
ok(exists $seen{'hilton'});             # 823
ok(! exists $seen{'icon'});             # 824
ok(! exists $seen{'jerky'});            # 825
%seen = ();

$complement_ref = get_complement_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 826
ok(! exists $seen{'baker'});            # 827
ok(! exists $seen{'camera'});           # 828
ok(! exists $seen{'delta'});            # 829
ok(! exists $seen{'edward'});           # 830
ok(! exists $seen{'fargo'});            # 831
ok(! exists $seen{'golfer'});           # 832
ok(exists $seen{'hilton'});             # 833
ok(! exists $seen{'icon'});             # 834
ok(! exists $seen{'jerky'});            # 835
%seen = ();

@complement = get_Ronly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 836
ok(! exists $seen{'baker'});            # 837
ok(! exists $seen{'camera'});           # 838
ok(! exists $seen{'delta'});            # 839
ok(! exists $seen{'edward'});           # 840
ok(! exists $seen{'fargo'});            # 841
ok(! exists $seen{'golfer'});           # 842
ok(exists $seen{'hilton'});             # 843
ok(! exists $seen{'icon'});             # 844
ok(! exists $seen{'jerky'});            # 845
%seen = ();

$complement_ref = get_Ronly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 846
ok(! exists $seen{'baker'});            # 847
ok(! exists $seen{'camera'});           # 848
ok(! exists $seen{'delta'});            # 849
ok(! exists $seen{'edward'});           # 850
ok(! exists $seen{'fargo'});            # 851
ok(! exists $seen{'golfer'});           # 852
ok(exists $seen{'hilton'});             # 853
ok(! exists $seen{'icon'});             # 854
ok(! exists $seen{'jerky'});            # 855
%seen = ();

@complement = get_Bonly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 856
ok(! exists $seen{'baker'});            # 857
ok(! exists $seen{'camera'});           # 858
ok(! exists $seen{'delta'});            # 859
ok(! exists $seen{'edward'});           # 860
ok(! exists $seen{'fargo'});            # 861
ok(! exists $seen{'golfer'});           # 862
ok(exists $seen{'hilton'});             # 863
ok(! exists $seen{'icon'});             # 864
ok(! exists $seen{'jerky'});            # 865
%seen = ();

$complement_ref = get_Bonly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 866
ok(! exists $seen{'baker'});            # 867
ok(! exists $seen{'camera'});           # 868
ok(! exists $seen{'delta'});            # 869
ok(! exists $seen{'edward'});           # 870
ok(! exists $seen{'fargo'});            # 871
ok(! exists $seen{'golfer'});           # 872
ok(exists $seen{'hilton'});             # 873
ok(! exists $seen{'icon'});             # 874
ok(! exists $seen{'jerky'});            # 875
%seen = ();

@symmetric_difference = get_symmetric_difference('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 876
ok(! exists $seen{'baker'});            # 877
ok(! exists $seen{'camera'});           # 878
ok(! exists $seen{'delta'});            # 879
ok(! exists $seen{'edward'});           # 880
ok(! exists $seen{'fargo'});            # 881
ok(! exists $seen{'golfer'});           # 882
ok(exists $seen{'hilton'});             # 883
ok(! exists $seen{'icon'});             # 884
ok(! exists $seen{'jerky'});            # 885
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 886
ok(! exists $seen{'baker'});            # 887
ok(! exists $seen{'camera'});           # 888
ok(! exists $seen{'delta'});            # 889
ok(! exists $seen{'edward'});           # 890
ok(! exists $seen{'fargo'});            # 891
ok(! exists $seen{'golfer'});           # 892
ok(exists $seen{'hilton'});             # 893
ok(! exists $seen{'icon'});             # 894
ok(! exists $seen{'jerky'});            # 895
%seen = ();

@symmetric_difference = get_symdiff('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 896
ok(! exists $seen{'baker'});            # 897
ok(! exists $seen{'camera'});           # 898
ok(! exists $seen{'delta'});            # 899
ok(! exists $seen{'edward'});           # 900
ok(! exists $seen{'fargo'});            # 901
ok(! exists $seen{'golfer'});           # 902
ok(exists $seen{'hilton'});             # 903
ok(! exists $seen{'icon'});             # 904
ok(! exists $seen{'jerky'});            # 905
%seen = ();

$symmetric_difference_ref = get_symdiff_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 906
ok(! exists $seen{'baker'});            # 907
ok(! exists $seen{'camera'});           # 908
ok(! exists $seen{'delta'});            # 909
ok(! exists $seen{'edward'});           # 910
ok(! exists $seen{'fargo'});            # 911
ok(! exists $seen{'golfer'});           # 912
ok(exists $seen{'hilton'});             # 913
ok(! exists $seen{'icon'});             # 914
ok(! exists $seen{'jerky'});            # 915
%seen = ();

@symmetric_difference = get_LorRonly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 916
ok(! exists $seen{'baker'});            # 917
ok(! exists $seen{'camera'});           # 918
ok(! exists $seen{'delta'});            # 919
ok(! exists $seen{'edward'});           # 920
ok(! exists $seen{'fargo'});            # 921
ok(! exists $seen{'golfer'});           # 922
ok(exists $seen{'hilton'});             # 923
ok(! exists $seen{'icon'});             # 924
ok(! exists $seen{'jerky'});            # 925
%seen = ();

$symmetric_difference_ref = get_LorRonly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 926
ok(! exists $seen{'baker'});            # 927
ok(! exists $seen{'camera'});           # 928
ok(! exists $seen{'delta'});            # 929
ok(! exists $seen{'edward'});           # 930
ok(! exists $seen{'fargo'});            # 931
ok(! exists $seen{'golfer'});           # 932
ok(exists $seen{'hilton'});             # 933
ok(! exists $seen{'icon'});             # 934
ok(! exists $seen{'jerky'});            # 935
%seen = ();

@symmetric_difference = get_AorBonly('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 936
ok(! exists $seen{'baker'});            # 937
ok(! exists $seen{'camera'});           # 938
ok(! exists $seen{'delta'});            # 939
ok(! exists $seen{'edward'});           # 940
ok(! exists $seen{'fargo'});            # 941
ok(! exists $seen{'golfer'});           # 942
ok(exists $seen{'hilton'});             # 943
ok(! exists $seen{'icon'});             # 944
ok(! exists $seen{'jerky'});            # 945
%seen = ();

$symmetric_difference_ref = get_AorBonly_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 946
ok(! exists $seen{'baker'});            # 947
ok(! exists $seen{'camera'});           # 948
ok(! exists $seen{'delta'});            # 949
ok(! exists $seen{'edward'});           # 950
ok(! exists $seen{'fargo'});            # 951
ok(! exists $seen{'golfer'});           # 952
ok(exists $seen{'hilton'});             # 953
ok(! exists $seen{'icon'});             # 954
ok(! exists $seen{'jerky'});            # 955
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	@nonintersection = get_nonintersection('--unsorted', \@a0, \@a1);
}
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 956
ok(! exists $seen{'baker'});            # 957
ok(! exists $seen{'camera'});           # 958
ok(! exists $seen{'delta'});            # 959
ok(! exists $seen{'edward'});           # 960
ok(! exists $seen{'fargo'});            # 961
ok(! exists $seen{'golfer'});           # 962
ok(exists $seen{'hilton'});             # 963
ok(! exists $seen{'icon'});             # 964
ok(! exists $seen{'jerky'});            # 965
%seen = ();

{
	local $SIG{__WARN__} = \&_capture;
	$nonintersection_ref = get_nonintersection_ref('--unsorted', \@a0, \@a1);
}
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 966
ok(! exists $seen{'baker'});            # 967
ok(! exists $seen{'camera'});           # 968
ok(! exists $seen{'delta'});            # 969
ok(! exists $seen{'edward'});           # 970
ok(! exists $seen{'fargo'});            # 971
ok(! exists $seen{'golfer'});           # 972
ok(exists $seen{'hilton'});             # 973
ok(! exists $seen{'icon'});             # 974
ok(! exists $seen{'jerky'});            # 975
%seen = ();

@bag = get_bag('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 976
ok($seen{'baker'} == 2);                # 977
ok($seen{'camera'} == 2);               # 978
ok($seen{'delta'} == 3);                # 979
ok($seen{'edward'} == 2);               # 980
ok($seen{'fargo'} == 2);                # 981
ok($seen{'golfer'} == 2);               # 982
ok($seen{'hilton'} == 1);               # 983
ok(! exists $seen{'icon'});             # 984
ok(! exists $seen{'jerky'});            # 985
%seen = ();

$bag_ref = get_bag_ref('--unsorted', \@a0, \@a1);
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 986
ok($seen{'baker'} == 2);                # 987
ok($seen{'camera'} == 2);               # 988
ok($seen{'delta'} == 3);                # 989
ok($seen{'edward'} == 2);               # 990
ok($seen{'fargo'} == 2);                # 991
ok($seen{'golfer'} == 2);               # 992
ok($seen{'hilton'} == 1);               # 993
ok(! exists $seen{'icon'});             # 994
ok(! exists $seen{'jerky'});            # 995
%seen = ();

