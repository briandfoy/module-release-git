#!/usr/bin/perl
use strict;
use vars qw($run_output);

use Test::More 'no_plan';

my $module_release = "Module::Release";

my $class  = 'Module::Release::Git';
my $method = 'cvs_tag';

use_ok( $module_release );

local $^W = 0;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=pod

To test these functions, I want to give them some sample git 
output and ensure they do what I want them to do. Instead of
running git, I override the run() method to return whatever 
is passed to it.

=cut

my $release = $module_release->new;
$module_release->load_mixin( $class );
can_ok( $module_release, $method );

{
no warnings qw(redefine once);
*Module::Release::run    = sub { $main::run_output = $_[1] };
*Module::Release::_warn  = sub { 1 };
*Module::Release::_print = sub { 1 };
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with an argument
{
my $tag = 'foo';
ok( $release->$method( $tag ), "$method returns true (whoop-de-do!)" );
is( $main::run_output, "git tag $tag", 
	"Run output sees the right tag with an argument" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with no argument, nothing in remote_file
{
ok( $release->$method( ), "Returns true (whoop-de-do!)" );
is( $main::run_output, "git tag RELEASE__", 
	"Run output sees the right tag with no argument, no remote" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with no argument, version in remote_file
{
$release->{remote_file} = 'Foo-Bar-45.98.tgz';

ok( $release->$method(), "$method returns true (whoop-de-do!)" );
is( $main::run_output, "git tag RELEASE_45_98", 
	"Run output sees the right tag with no argument, remote set" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Try it with no argument, dev version in remote_file
{
$release->{remote_file} = 'Foo-Bar-45.98_01.tgz';

ok( $release->$method(), "$method returns true (whoop-de-do!)" );
is( $main::run_output, "git tag RELEASE_45_98_01", 
	"Run output sees the right tag with no argument, remote set" );
}