#!/usr/bin/perl -I /var/lib/jenkins/workspace/ciom
use strict;
use English;
use Data::Dumper;
use Data::UUID;
my $ug = Data::UUID->new();	

sub getUuid() {
	return $ug->create_str();
}
my $a = 6 % 7 || 1;

my $aa = {
	a => 0,
	b => 1,
	c => 2
};

my $fnRefreshUuid = sub($) {
	my $pms = shift;
	$pms->{pid} = getUuid();
	return $pms
};
my $pms = {
	orgId => '$orgId',
	targetId => '$knowledgeId',
	creator => '$userId'
};

print Dumper($fnRefreshUuid->($pms));
print Dumper($fnRefreshUuid->($pms));
print Dumper($fnRefreshUuid->($pms));
