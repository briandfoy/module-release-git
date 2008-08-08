#!/usr/bin/perl
use strict;
use vars qw($output);

use Test::More 'no_plan';

my $class = 'Module::Release::Git';

use_ok( $class );

can_ok( $class, 'cvs_tag' );

{
no warnings 'redefine';

*Module::Release::Git::_print = sub { 1 }
}

ok( $class->cvs_tag( 'foo' ), "Returns true (whoop-de-do!)" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=pod

To test these functions, I want to give them some sample git 
output and ensure they do what I want them to do. Instead of
running git, I override the run() method to return whatever 
is in the global variable $output. I can change that during
the test run to try different things.

=cut

BEGIN {
package Module::Release::Git;
use vars qw( $run_output $fine_output
	);

$fine_output = <<"HERE";
# On branch master
nothing to commit (working directory clean)
HERE

no warnings 'redefine';
package Module::Release::Git; # load before redefine
sub run { $run_output }
}

