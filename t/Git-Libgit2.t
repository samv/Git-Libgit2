#!/usr/bin/perl -w

use Test::More no_plan;
use strict;

BEGIN { use_ok('Git::Libgit2') };
use FindBin qw($Bin);
use Data::Dumper;

my $TERMINAL = ( -t STDOUT );
{
	my $git = Git::Libgit2->new(directory => "$Bin/..");

	isa_ok($git->__C, "Git::Libgit2::repo", "C binding Hello, World");
	isa_ok($git->__odb, "Git::Libgit2::odb", "Got an object DB");

	print Dumper $git if $TERMINAL;
}

pass("Destructor didn't blow up!");

