#!/usr/bin/perl -I /var/lib/jenkins/workspace/ciom
use strict;
use English;
use Data::Dumper;
use Data::UUID;
my $ug = Data::UUID->new();	

my $b = "| grep '^?' | awk '{print \$2}' | xargs -I{} rm -rf '{}'";


sub main() {
	exit 3;
	return 2;
}

main();