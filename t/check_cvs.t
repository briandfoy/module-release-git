#!/usr/bin/perl
use strict;
use vars qw(
	$output 
	$newfile_output $changedfile_output
	$untrackedfile_output $combined_output
	);

use Test::More 'no_plan';

my $class = 'Module::Release::Git';

use_ok( $class );
can_ok( $class, 'check_cvs' );

# are we where we think we're starting?
can_ok( $class, 'run' );
is( $class->run, $output );

# we're testing, so turn off output (kludge)
{
no warnings 'redefine';
*Module::Release::Git::_print = sub { 1 }
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
{
# Test when there is nothing left to commit (using the starting $output)
my $rc = eval { $class->check_cvs };
my $at = $@;

ok( ! $at, "(Nothing left to commit) \$@ undef (good)" );
ok( $rc, "(Nothing left to commit) returns true (good)" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Test when there is a new file
foreach my $try ( $newfile_output, $changedfile_output,
	$untrackedfile_output, $combined_output )
	{
	our $output = $try;

	my $rc = eval { $class->check_cvs };
	my $at = $@;
	
	ok( defined $at, "(Dirty working dir) \$@ defined (good)" );
	ok( ! $rc, "(Dirty working dir) returns true (good)" );
	}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=pod

To test these functions, I want to give them some sample git 
output and ensure they do what I want them to do. Instead of
running git, I override the run() method to return whatever 
is in the global variable $output. I can change that during
the test run to try different things.

=cut

BEGIN {
our $output = <<"HERE";
# On branch master
nothing to commit (working directory clean)
HERE

no warnings 'redefine';
use Module::Release; # load before redefine
*Module::Release::run = sub { $output; };

$newfile_output = <<"HERE";
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   README
HERE

$changedfile_output = <<"HERE";
# On branch master
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#
#       modified:   .gitignore
HERE

$untrackedfile_output = <<"HERE";
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       Changes
#       LICENSE
#       MANIFEST.SKIP
HERE

$combined_output = <<"HERE";
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   README
#
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#
#       modified:   .gitignore
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       Changes
#       LICENSE
#       MANIFEST.SKIP
#       Makefile.PL
#       examples/
#       lib/
#       t/
HERE

}
