package Test::ListCompareSpecial;
# Contains test subroutines for distribution with List::Compare
# As of:  June 1, 2003
require Exporter;
our @ISA         = qw(Exporter);
our @EXPORT      = qw( ok  $testnum );
our @EXPORT_OK   = qw( ok_seen_a  ok_seen_h ); 
our %EXPORT_TAGS = (
    seen => [ qw( ok_seen_a  ok_seen_h ) ],
);

$testnum = 1;

sub ok {
	my $condition = shift;
	print $condition ? "ok $testnum\n" : "not ok $testnum\n";
	$testnum++;
}

sub ok_seen_h {
	die "Need 4 arguments: $!" unless (@_ == 4);
	my ($mhr, $arg, $quant_expect, $expected_ref) = @_;
	my (%seen, $score);
	$seen{$_}++ foreach (@{${$mhr}{$arg}});
	$score++ if (keys %seen == $quant_expect);
	foreach (@{$expected_ref}) {
		$score++ if exists $seen{$_};
	}
	$score == 1 + scalar(@{$expected_ref})
		? return 1
		: return 0;
}

sub ok_seen_a {
	die "Need 4 arguments: $!" unless (@_ == 4);
	my ($mar, $arg, $quant_expect, $expected_ref) = @_;
	my (%seen, $score);
	$seen{$_}++ foreach (@{$mar});
	$score++ if (keys %seen == $quant_expect);
	foreach (@{$expected_ref}) {
		$score++ if exists $seen{$_};
	}
	$score == 1 + scalar(@{$expected_ref})
		? return 1
		: return 0;
}

1;

