#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use autodie;

use Template;

my @pages = glob "pages/*.pod pages/*/*.pod";
my $t = Template->new({
	INCLUDE_PATH => 'tt',
	POST_CHOMP   => 1,
	EVAL_PERL    => 0,
	});
foreach my $p (@pages) {
	open my $fh, '<', $p;
	my %data = (body => '');
	while (my $line = <$fh>) {
		if ($line =~ /^=(\w+)\s+(.*?)\s*$/) {
			$data{$1} = $2;
			next;
		}
		$data{body} .= $line;
	}
	close $fh;

	my $outfile = 'html/' . substr($p, 6, -4);
	say "Creating $outfile";

	$t->process('page.tt', \%data, $outfile) or die;
}

