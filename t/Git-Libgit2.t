#!/usr/bin/perl -w

use Test::More no_plan;
use strict;

BEGIN { use_ok('Git::Libgit2') };
use FindBin qw($Bin);

my $git = Git::Libgit2->new(directory => "$Bin/..");

isa_ok($git->__C, "Git::Libgit2::repo", "C binding Hello, World");

