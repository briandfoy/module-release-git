#!/usr/bin/perl
use strict;
use vars qw($run_output);

use Test::More 'no_plan';

my $class  = 'Module::Release::Git';
my $method = 'cvs_tag';

use_ok( $class );
can_ok( $class, $method );

{
no warnings 'redefine';

*Module::Release::Git::_print = sub { 1 }
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=pod

To test these functions, I want to give them some sample git 
output and ensure they do what I want them to do. Instead of
running git, I override the run() method to return whatever 
is passed to it.

=cut

BEGIN {
package Module::Release::Git;
use vars qw( $run_output $fine_output );

$fine_output = <<"HERE";
# On branch master
nothing to commit (working directory clean)
HERE

no warnings 'redefine';
package Module::Release::Git; # load before redefine
sub run   { $main::run_output = $_[1] }
sub _warn { 1 }
}

my $release = bless {}, $class;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with an argument
{
my $tag = 'foo';
ok( $release->$method( $tag ), "Returns true (whoop-de-do!)" );
is( $run_output, "git tag $tag", 
	"Run output sees the right tag with an argument" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with no argument, nothing in remote_file
{
ok( $release->$method( ), "Returns true (whoop-de-do!)" );
is( $run_output, "git tag RELEASE__", 
	"Run output sees the right tag with no argument, no remote" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with no argument, nothing in remote_file
{
local $release->{remote_file} = 'Foo-Bar-45.98.tgz';

ok( $release->$method( ), "Returns true (whoop-de-do!)" );
is( $run_output, "git tag RELEASE_45_98", 
	"Run output sees the right tag with no argument, remote set" );
}