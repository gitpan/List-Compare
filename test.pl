# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $last_test_to_print = 74; $| = 1; print "1..$last_test_to_print\n"; }
END {print "not ok 1\n" unless $loaded;}
use List::Compare;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my @Alist = qw(alpha beta beta gamma delta epsilon);
my @Blist = qw(gamma delta delta epsilon zeta eta);
my %seen = ();
my @Aonly = my @Bonly = my @intersection = my @union = my @AorBonly = my @bag = ();
my ($AB, $BA);

my $cl = List::Compare->new(\@Alist, \@Blist);
my $testnum = 1;

ok($cl);

@Aonly = $cl->get_Aonly;
$seen{$_}++ foreach (@Aonly);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(! exists $seen{'zeta'});
ok(! exists $seen{'eta'});
%seen = ();

@Aonly = $cl->get_unique;
$seen{$_}++ foreach (@Aonly);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(! exists $seen{'zeta'});
ok(! exists $seen{'eta'});
%seen = ();

@Bonly = $cl->get_Bonly;
$seen{$_}++ foreach (@Bonly);
ok(! exists $seen{'alpha'});
ok(! exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

@Bonly = $cl->get_complement;
$seen{$_}++ foreach (@Bonly);
ok(! exists $seen{'alpha'});
ok(! exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

@union = $cl->get_union;
$seen{$_}++ foreach (@union);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(exists $seen{'gamma'});
ok(exists $seen{'delta'});
ok(exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

@intersection = $cl->get_intersection;
$seen{$_}++ foreach (@intersection);
ok(! exists $seen{'alpha'});
ok(! exists $seen{'beta'});
ok(exists $seen{'gamma'});
ok(exists $seen{'delta'});
ok(exists $seen{'epsilon'});
ok(! exists $seen{'zeta'});
ok(! exists $seen{'eta'});
%seen = ();

@AorBonly = $cl->get_AorBonly;
$seen{$_}++ foreach (@AorBonly);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

@AorBonly = $cl->get_symdiff;
$seen{$_}++ foreach (@AorBonly);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

@AorBonly = $cl->get_symmetric_difference;
$seen{$_}++ foreach (@AorBonly);
ok(exists $seen{'alpha'});
ok(exists $seen{'beta'});
ok(! exists $seen{'gamma'});
ok(! exists $seen{'delta'});
ok(! exists $seen{'epsilon'});
ok(exists $seen{'zeta'});
ok(exists $seen{'eta'});
%seen = ();

$AB = $cl->is_AsubsetB;
ok(! $AB);

$BA = $cl->is_BsubsetA;
ok(! $BA);

@bag = $cl->get_bag;
$seen{$_}++ foreach (@bag);
ok($seen{'alpha'} == 1);
ok($seen{'beta'} == 2);
ok($seen{'gamma'} == 2);
ok($seen{'delta'} == 3);
ok($seen{'epsilon'} == 2);
ok($seen{'zeta'} == 1);
ok($seen{'eta'} == 1);
%seen = ();

$vers = $cl->get_version;
ok($vers);

sub ok {
	my $condition = shift;
	print $condition ? "ok $testnum\n" : "not ok $testnum\n";
	$testnum++;
}

