# 27_alt_functional_sh.t # as of 05/08/2004

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

END {print "not ok 1\n" unless $loaded;} # 
use Test::Simple tests =>
432;
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
my ($LR, $RL, $eqv, $disj, $return);
my (@nonintersection, @shared);
my ($nonintersection_ref, @shared_ref);
my ($memb_hash_ref, $memb_arr_ref, @memb_arr);

my @a0 = qw(abel abel baker camera delta edward fargo golfer);
my @a1 = qw(baker camera delta delta edward fargo golfer hilton);
my @a2 = qw(fargo golfer hilton icon icon jerky);
my @a3 = qw(fargo golfer hilton icon icon);
my @a4 = qw(fargo fargo golfer hilton icon);
my @a8 = qw(kappa lambda mu);

my (%h0, %h1, %h2, %h3, %h4, %h8);
$h0{$_}++ for @a0;
$h1{$_}++ for @a1;
$h2{$_}++ for @a2;
$h3{$_}++ for @a3;
$h4{$_}++ for @a4;
$h8{$_}++ for @a8;

@union = get_union( { lists => [ \%h0, \%h1 ] } );
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

$union_ref = get_union_ref( { lists => [ \%h0, \%h1 ] } );
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

@shared = get_shared( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 22
ok(exists $seen{'baker'});              # 23
ok(exists $seen{'camera'});             # 24
ok(exists $seen{'delta'});              # 25
ok(exists $seen{'edward'});             # 26
ok(exists $seen{'fargo'});              # 27
ok(exists $seen{'golfer'});             # 28
ok(! exists $seen{'hilton'});           # 29
ok(! exists $seen{'icon'});             # 30
ok(! exists $seen{'jerky'});            # 31
%seen = ();

$shared_ref = get_shared_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 32
ok(exists $seen{'baker'});              # 33
ok(exists $seen{'camera'});             # 34
ok(exists $seen{'delta'});              # 35
ok(exists $seen{'edward'});             # 36
ok(exists $seen{'fargo'});              # 37
ok(exists $seen{'golfer'});             # 38
ok(! exists $seen{'hilton'});           # 39
ok(! exists $seen{'icon'});             # 40
ok(! exists $seen{'jerky'});            # 41
%seen = ();

@intersection = get_intersection( { lists => [ \%h0, \%h1 ] } );
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

$intersection_ref = get_intersection_ref( { lists => [ \%h0, \%h1 ] } );
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

@unique = get_unique( { lists => [ \%h0, \%h1 ] } );
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

$unique_ref = get_unique_ref( { lists => [ \%h0, \%h1 ] } );
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

@complement = get_complement( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 82
ok(! exists $seen{'baker'});            # 83
ok(! exists $seen{'camera'});           # 84
ok(! exists $seen{'delta'});            # 85
ok(! exists $seen{'edward'});           # 86
ok(! exists $seen{'fargo'});            # 87
ok(! exists $seen{'golfer'});           # 88
ok(exists $seen{'hilton'});             # 89
ok(! exists $seen{'icon'});             # 90
ok(! exists $seen{'jerky'});            # 91
%seen = ();

$complement_ref = get_complement_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 92
ok(! exists $seen{'baker'});            # 93
ok(! exists $seen{'camera'});           # 94
ok(! exists $seen{'delta'});            # 95
ok(! exists $seen{'edward'});           # 96
ok(! exists $seen{'fargo'});            # 97
ok(! exists $seen{'golfer'});           # 98
ok(exists $seen{'hilton'});             # 99
ok(! exists $seen{'icon'});             # 100
ok(! exists $seen{'jerky'});            # 101
%seen = ();

@symmetric_difference = get_symmetric_difference( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 102
ok(! exists $seen{'baker'});            # 103
ok(! exists $seen{'camera'});           # 104
ok(! exists $seen{'delta'});            # 105
ok(! exists $seen{'edward'});           # 106
ok(! exists $seen{'fargo'});            # 107
ok(! exists $seen{'golfer'});           # 108
ok(exists $seen{'hilton'});             # 109
ok(! exists $seen{'icon'});             # 110
ok(! exists $seen{'jerky'});            # 111
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 112
ok(! exists $seen{'baker'});            # 113
ok(! exists $seen{'camera'});           # 114
ok(! exists $seen{'delta'});            # 115
ok(! exists $seen{'edward'});           # 116
ok(! exists $seen{'fargo'});            # 117
ok(! exists $seen{'golfer'});           # 118
ok(exists $seen{'hilton'});             # 119
ok(! exists $seen{'icon'});             # 120
ok(! exists $seen{'jerky'});            # 121
%seen = ();

@symmetric_difference = get_symdiff( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 122
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

$symmetric_difference_ref = get_symdiff_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 132
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

@nonintersection = get_nonintersection( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 142
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

$nonintersection_ref = get_nonintersection_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 152
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

@bag = get_bag( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 162
ok($seen{'baker'} == 2);                # 163
ok($seen{'camera'} == 2);               # 164
ok($seen{'delta'} == 3);                # 165
ok($seen{'edward'} == 2);               # 166
ok($seen{'fargo'} == 2);                # 167
ok($seen{'golfer'} == 2);               # 168
ok($seen{'hilton'} == 1);               # 169
ok(! exists $seen{'icon'});             # 170
ok(! exists $seen{'jerky'});            # 171
%seen = ();

$bag_ref = get_bag_ref( { lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 172
ok($seen{'baker'} == 2);                # 173
ok($seen{'camera'} == 2);               # 174
ok($seen{'delta'} == 3);                # 175
ok($seen{'edward'} == 2);               # 176
ok($seen{'fargo'} == 2);                # 177
ok($seen{'golfer'} == 2);               # 178
ok($seen{'hilton'} == 1);               # 179
ok(! exists $seen{'icon'});             # 180
ok(! exists $seen{'jerky'});            # 181
%seen = ();

$LR = is_LsubsetR( { lists => [ \%h0, \%h1 ] } );
ok(! $LR);                              # 182

$RL = is_RsubsetL( { lists => [ \%h0, \%h1 ] } );
ok(! $RL);                              # 183

$eqv = is_LequivalentR( { lists => [ \%h0, \%h1 ] } );
ok(! $eqv);                             # 184

$eqv = is_LeqvlntR( { lists => [ \%h0, \%h1 ] } );
ok(! $eqv);                             # 185

$disj = is_LdisjointR( { lists => [ \%h0, \%h1 ] } );
ok(! $disj);                            # 186

$return = print_subset_chart( { lists => [ \%h0, \%h1 ] } );
ok($return);                            # 187

$return = print_equivalence_chart( { lists => [ \%h0, \%h1 ] } );
ok($return);                            # 188

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'abel' } );
ok(ok_seen_a( \@memb_arr, 'abel',   1, [ qw< 0   > ] ));# 189

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'baker' } );
ok(ok_seen_a( \@memb_arr, 'baker',  2, [ qw< 0 1 > ] ));# 190

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'camera' } );
ok(ok_seen_a( \@memb_arr, 'camera', 2, [ qw< 0 1 > ] ));# 191

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'delta' } );
ok(ok_seen_a( \@memb_arr, 'delta',  2, [ qw< 0 1 > ] ));# 192

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'edward' } );
ok(ok_seen_a( \@memb_arr, 'edward', 2, [ qw< 0 1 > ] ));# 193

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'fargo' } );
ok(ok_seen_a( \@memb_arr, 'fargo',  2, [ qw< 0 1 > ] ));# 194

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'golfer' } );
ok(ok_seen_a( \@memb_arr, 'golfer', 2, [ qw< 0 1 > ] ));# 195

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'hilton' } );
ok(ok_seen_a( \@memb_arr, 'hilton', 1, [ qw<   1 > ] ));# 196

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'icon' } );
ok(ok_seen_a( \@memb_arr, 'icon',   0, [ qw<     > ] ));# 197

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'jerky' } );
ok(ok_seen_a( \@memb_arr, 'jerky',  0, [ qw<     > ] ));# 198

@memb_arr = is_member_which( { lists => [ \%h0, \%h1 ], item => 'zebra' } );
ok(ok_seen_a( \@memb_arr, 'zebra',  0, [ qw<     > ] ));# 199

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'abel' } );
ok(ok_seen_a( $memb_arr_ref, 'abel',   1, [ qw< 0   > ] ));# 200

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'baker' } );
ok(ok_seen_a( $memb_arr_ref, 'baker',  2, [ qw< 0 1 > ] ));# 201

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'camera' } );
ok(ok_seen_a( $memb_arr_ref, 'camera', 2, [ qw< 0 1 > ] ));# 202

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'delta' } );
ok(ok_seen_a( $memb_arr_ref, 'delta',  2, [ qw< 0 1 > ] ));# 203

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'edward' } );
ok(ok_seen_a( $memb_arr_ref, 'edward', 2, [ qw< 0 1 > ] ));# 204

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'fargo' } );
ok(ok_seen_a( $memb_arr_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 205

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'golfer' } );
ok(ok_seen_a( $memb_arr_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 206

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'hilton' } );
ok(ok_seen_a( $memb_arr_ref, 'hilton', 1, [ qw<   1 > ] ));# 207

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'icon' } );
ok(ok_seen_a( $memb_arr_ref, 'icon',   0, [ qw<     > ] ));# 208

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'jerky' } );
ok(ok_seen_a( $memb_arr_ref, 'jerky',  0, [ qw<     > ] ));# 209

$memb_arr_ref = is_member_which_ref( { lists => [ \%h0, \%h1 ], item => 'zebra' } );
ok(ok_seen_a( $memb_arr_ref, 'zebra',  0, [ qw<     > ] ));# 210


$memb_hash_ref = are_members_which( { lists => [ \%h0, \%h1 ] , 
    items => [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] } );
ok(ok_seen_h( $memb_hash_ref, 'abel',   1, [ qw< 0   > ] ));# 211
ok(ok_seen_h( $memb_hash_ref, 'baker',  2, [ qw< 0 1 > ] ));# 212
ok(ok_seen_h( $memb_hash_ref, 'camera', 2, [ qw< 0 1 > ] ));# 213
ok(ok_seen_h( $memb_hash_ref, 'delta',  2, [ qw< 0 1 > ] ));# 214
ok(ok_seen_h( $memb_hash_ref, 'edward', 2, [ qw< 0 1 > ] ));# 215
ok(ok_seen_h( $memb_hash_ref, 'fargo',  2, [ qw< 0 1 > ] ));# 216
ok(ok_seen_h( $memb_hash_ref, 'golfer', 2, [ qw< 0 1 > ] ));# 217
ok(ok_seen_h( $memb_hash_ref, 'hilton', 1, [ qw<   1 > ] ));# 218
ok(ok_seen_h( $memb_hash_ref, 'icon',   0, [ qw<     > ] ));# 219
ok(ok_seen_h( $memb_hash_ref, 'jerky',  0, [ qw<     > ] ));# 220
ok(ok_seen_h( $memb_hash_ref, 'zebra',  0, [ qw<     > ] ));# 221

ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'abel' } ));# 222
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'baker' } ));# 223
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'camera' } ));# 224
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'delta' } ));# 225
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'edward' } ));# 226
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'fargo' } ));# 227
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'golfer' } ));# 228
ok(is_member_any( { lists => [ \%h0, \%h1 ], item => 'hilton' } ));# 229
ok(! is_member_any( { lists => [ \%h0, \%h1 ], item => 'icon' } ));# 230
ok(! is_member_any( { lists => [ \%h0, \%h1 ], item => 'jerky' } ));# 231
ok(! is_member_any( { lists => [ \%h0, \%h1 ], item => 'zebra' } ));# 232

$memb_hash_ref = are_members_any( { lists => [ \%h0, \%h1 ],
    items => [ qw| abel baker camera delta edward fargo golfer hilton icon jerky zebra | ] } );

ok(ok_any_h( $memb_hash_ref, 'abel',   1 ));# 233
ok(ok_any_h( $memb_hash_ref, 'baker',  1 ));# 234
ok(ok_any_h( $memb_hash_ref, 'camera', 1 ));# 235
ok(ok_any_h( $memb_hash_ref, 'delta',  1 ));# 236
ok(ok_any_h( $memb_hash_ref, 'edward', 1 ));# 237
ok(ok_any_h( $memb_hash_ref, 'fargo',  1 ));# 238
ok(ok_any_h( $memb_hash_ref, 'golfer', 1 ));# 239
ok(ok_any_h( $memb_hash_ref, 'hilton', 1 ));# 240
ok(ok_any_h( $memb_hash_ref, 'icon',   0 ));# 241
ok(ok_any_h( $memb_hash_ref, 'jerky',  0 ));# 242
ok(ok_any_h( $memb_hash_ref, 'zebra',  0 ));# 243

$vers = get_version;
ok($vers);                              # 244

$LR = is_LsubsetR( { lists => [ \%h2, \%h3 ] } );
ok(! $LR);                              # 245

$RL = is_RsubsetL( { lists => [ \%h2, \%h3 ] } );
ok($RL);                                # 246

$eqv = is_LequivalentR( { lists => [ \%h2, \%h3 ] } );
ok(! $eqv);                             # 247

$eqv = is_LeqvlntR( { lists => [ \%h2, \%h3 ] } );
ok(! $eqv);                             # 248

$eqv = is_LequivalentR( { lists => [ \%h3, \%h4 ] } );
ok($eqv);                               # 249

$eqv = is_LeqvlntR( { lists => [ \%h3, \%h4 ] } );
ok($eqv);                               # 250

$disj = is_LdisjointR( { lists => [ \%h3, \%h4 ] } );
ok(! $disj);                            # 251

$disj = is_LdisjointR( { lists => [ \%h4, \%h8 ] } );
ok($disj);                              # 252

########## BELOW:  Tests for '-u' option ##########

@union = get_union( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@union);
ok(exists $seen{'abel'});               # 253
ok(exists $seen{'baker'});              # 254
ok(exists $seen{'camera'});             # 255
ok(exists $seen{'delta'});              # 256
ok(exists $seen{'edward'});             # 257
ok(exists $seen{'fargo'});              # 258
ok(exists $seen{'golfer'});             # 259
ok(exists $seen{'hilton'});             # 260
ok(! exists $seen{'icon'});             # 261
ok(! exists $seen{'jerky'});            # 262
%seen = ();

$union_ref = get_union_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$union_ref});
ok(exists $seen{'abel'});               # 263
ok(exists $seen{'baker'});              # 264
ok(exists $seen{'camera'});             # 265
ok(exists $seen{'delta'});              # 266
ok(exists $seen{'edward'});             # 267
ok(exists $seen{'fargo'});              # 268
ok(exists $seen{'golfer'});             # 269
ok(exists $seen{'hilton'});             # 270
ok(! exists $seen{'icon'});             # 271
ok(! exists $seen{'jerky'});            # 272
%seen = ();

@shared = get_shared( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@shared);
ok(! exists $seen{'abel'});             # 273
ok(exists $seen{'baker'});              # 274
ok(exists $seen{'camera'});             # 275
ok(exists $seen{'delta'});              # 276
ok(exists $seen{'edward'});             # 277
ok(exists $seen{'fargo'});              # 278
ok(exists $seen{'golfer'});             # 279
ok(! exists $seen{'hilton'});           # 280
ok(! exists $seen{'icon'});             # 281
ok(! exists $seen{'jerky'});            # 282
%seen = ();

$shared_ref = get_shared_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$shared_ref});
ok(! exists $seen{'abel'});             # 283
ok(exists $seen{'baker'});              # 284
ok(exists $seen{'camera'});             # 285
ok(exists $seen{'delta'});              # 286
ok(exists $seen{'edward'});             # 287
ok(exists $seen{'fargo'});              # 288
ok(exists $seen{'golfer'});             # 289
ok(! exists $seen{'hilton'});           # 290
ok(! exists $seen{'icon'});             # 291
ok(! exists $seen{'jerky'});            # 292
%seen = ();

@intersection = get_intersection( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'abel'});             # 293
ok(exists $seen{'baker'});              # 294
ok(exists $seen{'camera'});             # 295
ok(exists $seen{'delta'});              # 296
ok(exists $seen{'edward'});             # 297
ok(exists $seen{'fargo'});              # 298
ok(exists $seen{'golfer'});             # 299
ok(! exists $seen{'hilton'});           # 300
ok(! exists $seen{'icon'});             # 301
ok(! exists $seen{'jerky'});            # 302
%seen = ();

$intersection_ref = get_intersection_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$intersection_ref});
ok(! exists $seen{'abel'});             # 303
ok(exists $seen{'baker'});              # 304
ok(exists $seen{'camera'});             # 305
ok(exists $seen{'delta'});              # 306
ok(exists $seen{'edward'});             # 307
ok(exists $seen{'fargo'});              # 308
ok(exists $seen{'golfer'});             # 309
ok(! exists $seen{'hilton'});           # 310
ok(! exists $seen{'icon'});             # 311
ok(! exists $seen{'jerky'});            # 312
%seen = ();

@unique = get_unique( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@unique);
ok(exists $seen{'abel'});               # 313
ok(! exists $seen{'baker'});            # 314
ok(! exists $seen{'camera'});           # 315
ok(! exists $seen{'delta'});            # 316
ok(! exists $seen{'edward'});           # 317
ok(! exists $seen{'fargo'});            # 318
ok(! exists $seen{'golfer'});           # 319
ok(! exists $seen{'hilton'});           # 320
ok(! exists $seen{'icon'});             # 321
ok(! exists $seen{'jerky'});            # 322
%seen = ();

$unique_ref = get_unique_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$unique_ref});
ok(exists $seen{'abel'});               # 323
ok(! exists $seen{'baker'});            # 324
ok(! exists $seen{'camera'});           # 325
ok(! exists $seen{'delta'});            # 326
ok(! exists $seen{'edward'});           # 327
ok(! exists $seen{'fargo'});            # 328
ok(! exists $seen{'golfer'});           # 329
ok(! exists $seen{'hilton'});           # 330
ok(! exists $seen{'icon'});             # 331
ok(! exists $seen{'jerky'});            # 332
%seen = ();

@complement = get_complement( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@complement);
ok(! exists $seen{'abel'});             # 333
ok(! exists $seen{'baker'});            # 334
ok(! exists $seen{'camera'});           # 335
ok(! exists $seen{'delta'});            # 336
ok(! exists $seen{'edward'});           # 337
ok(! exists $seen{'fargo'});            # 338
ok(! exists $seen{'golfer'});           # 339
ok(exists $seen{'hilton'});             # 340
ok(! exists $seen{'icon'});             # 341
ok(! exists $seen{'jerky'});            # 342
%seen = ();

$complement_ref = get_complement_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$complement_ref});
ok(! exists $seen{'abel'});             # 343
ok(! exists $seen{'baker'});            # 344
ok(! exists $seen{'camera'});           # 345
ok(! exists $seen{'delta'});            # 346
ok(! exists $seen{'edward'});           # 347
ok(! exists $seen{'fargo'});            # 348
ok(! exists $seen{'golfer'});           # 349
ok(exists $seen{'hilton'});             # 350
ok(! exists $seen{'icon'});             # 351
ok(! exists $seen{'jerky'});            # 352
%seen = ();

@symmetric_difference = get_symmetric_difference( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 353
ok(! exists $seen{'baker'});            # 354
ok(! exists $seen{'camera'});           # 355
ok(! exists $seen{'delta'});            # 356
ok(! exists $seen{'edward'});           # 357
ok(! exists $seen{'fargo'});            # 358
ok(! exists $seen{'golfer'});           # 359
ok(exists $seen{'hilton'});             # 360
ok(! exists $seen{'icon'});             # 361
ok(! exists $seen{'jerky'});            # 362
%seen = ();

$symmetric_difference_ref = get_symmetric_difference_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 363
ok(! exists $seen{'baker'});            # 364
ok(! exists $seen{'camera'});           # 365
ok(! exists $seen{'delta'});            # 366
ok(! exists $seen{'edward'});           # 367
ok(! exists $seen{'fargo'});            # 368
ok(! exists $seen{'golfer'});           # 369
ok(exists $seen{'hilton'});             # 370
ok(! exists $seen{'icon'});             # 371
ok(! exists $seen{'jerky'});            # 372
%seen = ();

@symmetric_difference = get_symdiff( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@symmetric_difference);
ok(exists $seen{'abel'});               # 373
ok(! exists $seen{'baker'});            # 374
ok(! exists $seen{'camera'});           # 375
ok(! exists $seen{'delta'});            # 376
ok(! exists $seen{'edward'});           # 377
ok(! exists $seen{'fargo'});            # 378
ok(! exists $seen{'golfer'});           # 379
ok(exists $seen{'hilton'});             # 380
ok(! exists $seen{'icon'});             # 381
ok(! exists $seen{'jerky'});            # 382
%seen = ();

$symmetric_difference_ref = get_symdiff_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$symmetric_difference_ref});
ok(exists $seen{'abel'});               # 383
ok(! exists $seen{'baker'});            # 384
ok(! exists $seen{'camera'});           # 385
ok(! exists $seen{'delta'});            # 386
ok(! exists $seen{'edward'});           # 387
ok(! exists $seen{'fargo'});            # 388
ok(! exists $seen{'golfer'});           # 389
ok(exists $seen{'hilton'});             # 390
ok(! exists $seen{'icon'});             # 391
ok(! exists $seen{'jerky'});            # 392
%seen = ();

@nonintersection = get_nonintersection( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@nonintersection);
ok(exists $seen{'abel'});               # 393
ok(! exists $seen{'baker'});            # 394
ok(! exists $seen{'camera'});           # 395
ok(! exists $seen{'delta'});            # 396
ok(! exists $seen{'edward'});           # 397
ok(! exists $seen{'fargo'});            # 398
ok(! exists $seen{'golfer'});           # 399
ok(exists $seen{'hilton'});             # 400
ok(! exists $seen{'icon'});             # 401
ok(! exists $seen{'jerky'});            # 402
%seen = ();

$nonintersection_ref = get_nonintersection_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$nonintersection_ref});
ok(exists $seen{'abel'});               # 403
ok(! exists $seen{'baker'});            # 404
ok(! exists $seen{'camera'});           # 405
ok(! exists $seen{'delta'});            # 406
ok(! exists $seen{'edward'});           # 407
ok(! exists $seen{'fargo'});            # 408
ok(! exists $seen{'golfer'});           # 409
ok(exists $seen{'hilton'});             # 410
ok(! exists $seen{'icon'});             # 411
ok(! exists $seen{'jerky'});            # 412
%seen = ();

@bag = get_bag( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@bag);
ok($seen{'abel'} == 2);                 # 413
ok($seen{'baker'} == 2);                # 414
ok($seen{'camera'} == 2);               # 415
ok($seen{'delta'} == 3);                # 416
ok($seen{'edward'} == 2);               # 417
ok($seen{'fargo'} == 2);                # 418
ok($seen{'golfer'} == 2);               # 419
ok($seen{'hilton'} == 1);               # 420
ok(! exists $seen{'icon'});             # 421
ok(! exists $seen{'jerky'});            # 422
%seen = ();

$bag_ref = get_bag_ref( { unsorted => 1, lists => [ \%h0, \%h1 ] } );
$seen{$_}++ foreach (@{$bag_ref});
ok($seen{'abel'} == 2);                 # 423
ok($seen{'baker'} == 2);                # 424
ok($seen{'camera'} == 2);               # 425
ok($seen{'delta'} == 3);                # 426
ok($seen{'edward'} == 2);               # 427
ok($seen{'fargo'} == 2);                # 428
ok($seen{'golfer'} == 2);               # 429
ok($seen{'hilton'} == 1);               # 430
ok(! exists $seen{'icon'});             # 431
ok(! exists $seen{'jerky'});            # 432
%seen = ();

