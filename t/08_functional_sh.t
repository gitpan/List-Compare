# 08_functional_sh.t

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 
395; $| = 1; print "1..$last_test_to_print\n"; } # 10/27/2003
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

my (%h0, %h1, %h2, %h3, %h4);
$h0{$_}++ for @a0;
$h1{$_}++ for @a1;
$h2{$_}++ for @a2;
$h3{$_}++ for @a3;
$h4{$_}++ for @a4;

@union = get_union(\%h0, \%h1);
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

$union_ref = get_union_ref(\%h0, \%h1);
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
	@shared = get_shared(\%h0, \%h1);
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
	$shared_ref = get_shared_ref(\%h0, \%h1);
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

@intersection = get_intersection(\%h0, \%h1);
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

$intersection_ref = get_intersection_ref(\%h0, \%h1);
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

@unique = get_unique(\%h0, \%h1);
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

$unique_ref = get_unique_ref(\%h0, \%h1);
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

@unique = get_Lonly(\%h0, \%h1);
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

$unique_ref = get_Lonly_ref(\%h0, \%h1);
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

@unique = get_Aonly(\%h0, \%h1);
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

$unique_ref = get_Aonly_ref(\%h0, \%h1);
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

@complement = get_complement(\%h0, \%h1);
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

$complement_ref = get_complement_ref(\%h0, \%h1);
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

@complement = get_Ronly(\%h0, \%h1);
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

$complement_ref = get_Ronly_ref(\%h0, \%h1);
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

@complement = get_Bonly(\%h0, \%h1);
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

$complement_ref = get_Bonly_ref(\%h0, \%h1);
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

@symmetric_difference = get_symmetric_difference(\%h0, \%h1);
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

$symmetric_difference_ref = get_symmetric_difference_ref(\%h0, \%h1);
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

@symmetric_difference = get_symdiff(\%h0, \%h1);
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

$symmetric_difference_ref = get_symdiff_ref(\%h0, \%h1);
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

@symmetric_difference = get_LorRonly(\%h0, \%h1);
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

$symmetric_difference_ref = get_LorRonly_ref(\%h0, \%h1);
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

@symmetric_difference = get_AorBonly(\%h0, \%h1);
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

$symmetric_difference_ref = get_AorBonly_ref(\%h0, \%h1);
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
	@nonintersection = get_nonintersection(\%h0, \%h1);
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
	$nonintersection_ref = get_nonintersection_ref(\%h0, \%h1);
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

@bag = get_bag(\%h0, \%h1);
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

$bag_ref = get_bag_ref(\%h0, \%h1);
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

$LR = is_LsubsetR(\%h0, \%h1);
ok(! $LR);                              # 302

$LR = is_AsubsetB(\%h0, \%h1);
ok(! $LR);                              # 303

$RL = is_RsubsetL(\%h0, \%h1);
ok(! $RL);                              # 304

$RL = is_BsubsetA(\%h0, \%h1);
ok(! $RL);                              # 305

$eqv = is_LequivalentR(\%h0, \%h1);
ok(! $eqv);                             # 306

$eqv = is_LeqvlntR(\%h0, \%h1);
ok(! $eqv);                             # 307

$return = print_subset_chart(\%h0, \%h1);
ok($return);                            # 308

$return = print_equivalence_chart(\%h0, \%h1);
ok($return);                            # 309

@memb_arr = is_member_which(\%h0, \%h1, 'abel');
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 310

@memb_arr = is_member_which(\%h0, \%h1, 'baker');
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 311

@memb_arr = is_member_which(\%h0, \%h1, 'camera');
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 312

@memb_arr = is_member_which(\%h0, \%h1, 'delta');
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 313

@memb_arr = is_member_which(\%h0, \%h1, 'edward');
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 314

@memb_arr = is_member_which(\%h0, \%h1, 'fargo');
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 315

@memb_arr = is_member_which(\%h0, \%h1, 'golfer');
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 316

@memb_arr = is_member_which(\%h0, \%h1, 'hilton');
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 317

@memb_arr = is_member_which(\%h0, \%h1, 'icon');
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 318

@memb_arr = is_member_which(\%h0, \%h1, 'jerky');
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 319

@memb_arr = is_member_which(\%h0, \%h1, 'zebra');
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 320


$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'abel');
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 321

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'baker');
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 322

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'camera');
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 323

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'delta');
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 324

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'edward');
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 325

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'fargo');
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 326

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'golfer');
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 327

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'hilton');
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 328

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'icon');
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 329

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'jerky');
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 330

$memb_arr_ref = is_member_which_ref(\%h0, \%h1, 'zebra');
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 331


$memb_hash_ref = are_members_which(\%h0, \%h1, 
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

$memb_hash_ref = are_members_which( \%h0, \%h1, 
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


ok(is_member_any(\%h0, \%h1, 'abel'));  # 354
ok(is_member_any(\%h0, \%h1, 'baker')); # 355
ok(is_member_any(\%h0, \%h1, 'camera'));# 356
ok(is_member_any(\%h0, \%h1, 'delta')); # 357
ok(is_member_any(\%h0, \%h1, 'edward'));# 358
ok(is_member_any(\%h0, \%h1, 'fargo')); # 359
ok(is_member_any(\%h0, \%h1, 'golfer'));# 360
ok(is_member_any(\%h0, \%h1, 'hilton'));# 361
ok(! is_member_any(\%h0, \%h1, 'icon' ));# 362
ok(! is_member_any(\%h0, \%h1, 'jerky'));# 363
ok(! is_member_any(\%h0, \%h1, 'zebra'));# 364

$memb_hash_ref = are_members_any(\%h0, \%h1, 
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

$memb_hash_ref = are_members_any( \%h0, \%h1, 
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

$LR = is_LsubsetR(\%h2, \%h3);
ok(! $LR);                              # 388

$LR = is_AsubsetB(\%h2, \%h3);
ok(! $LR);                              # 389

$RL = is_RsubsetL(\%h2, \%h3);
ok($RL);                                # 390

$RL = is_BsubsetA(\%h2, \%h3);
ok($RL);                                # 391

$eqv = is_LequivalentR(\%h2, \%h3);
ok(! $eqv);                             # 392

$eqv = is_LeqvlntR(\%h2, \%h3);
ok(! $eqv);                             # 393

$eqv = is_LequivalentR(\%h3, \%h4);
ok($eqv);                               # 394

$eqv = is_LeqvlntR(\%h3, \%h4);
ok($eqv);                               # 395




