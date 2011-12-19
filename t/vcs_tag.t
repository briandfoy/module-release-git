#!/usr/bin/perl
use strict;
use vars qw($run_output);

use Test::More tests => 11;

my $class  = 'Module::Release::Git';
my $method = 'vcs_tag';

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

# Define our test cases.  'tag' is passed to ->vcs_tag, and 'expect'
# is the tag we expect to get supplied to Git.  If remote_file is
# specified, then this key and it's valye is inserted into the
# $release object, emulating the release of a distro with that file
# name.
my @cases = (
    {
        desc => 'an arbitrary tag argument', 
        tag => 'foo',
        expect => 'foo',
    },
    {
        desc => 'no tag info',
        tag => undef,
        expect => 'RELEASE__',
    },
    {
        desc => 'two-number version',
        tag => undef, remote_file => 'Foo-Bar-45.98.tgz',
        expect => 'RELEASE_45_98',
    },
    {
        desc => 'two-number dev version',
        tag => undef, remote_file => 'Foo-Bar-45.98_01.tgz',
        expect => 'RELEASE_45_98_01',
    },
);




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# quotes values, but maps undefs to '<undef>'
sub defang_undef {
    return map { defined $_? "'$_'" : '<undef>' } @_;
} 


foreach my $case (@cases) {
    # Set remote_file if one is supplied
    $release->{remote_file} = $case->{remote_file}
        if defined $case->{remote_file};

    ok( $release->$method( $case->{tag} ),
        sprintf(
            "$case->{desc}: ->%s(%s) returns true with %s",
            $method,
            defang_undef @$case{qw(tag remote_file)},
        ),
    );
    my $expected_cmd = "git tag $case->{expect}";
    is( $main::run_output,
        $expected_cmd,
	sprintf(
            " and run output sees '%s'",
            $expected_cmd,
        ),
    );
}
