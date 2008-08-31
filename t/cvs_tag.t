#!/usr/bin/perl
use strict;
use vars qw($run_output);

use Test::More 'no_plan';

my $class  = 'Module::Release::Git';
my $method = 'cvs_tag';

use_ok( $class );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=pod

To test these functions, I want to give them some sample git 
output and ensure they do what I want them to do. Instead of
running git, I override the run() method to return whatever 
is passed to it.

=cut

{
package Null;

sub new { bless {}, __PACKAGE__ }
sub AUTOLOAD { "" }

package main;
no warnings qw(redefine once);
*Module::Release::Git::run         = sub { $main::run_output = $_[1] };
*Module::Release::Git::remote_file = sub { $_[0]->{remote_file} };
*Module::Release::Git::_warn       = sub { 1 };
*Module::Release::Git::_print      = sub { 1 };
}

my $release = bless {}, $class;
can_ok( $release, $method );


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