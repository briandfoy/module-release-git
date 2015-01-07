require 5.010;
use strict;
use warnings;

my $github    = 'https://github.com/briandfoy/';
my $main_file = 'lib/Module/Release/Git.pm';

my %WriteMakefile = (
	'NAME'	        => 'Module::Release::Git',
	'ABSTRACT_FROM' => $main_file,
	'VERSION_FROM'  => $main_file,
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',
	
	'CONFIGURE_REQUIRES' => { 
		'ExtUtils::MakeMaker' => '6.64',
		},

	'TEST_REQUIRES' => { 
		'Test::More'      => '0.98',
		},

	'PREREQ_PM' => {
		'Module::Release' => '2.06',	
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => 'git@github.com:briandfoy/module-release-git.git',
				web  => 'https://github.com/briandfoy/module-release-git',
				},
			},
		keywords => ['workflow', 'module', 'distribution', 
			'pause', 'automation', 'testing', 'git' ],
		},

	clean  => { FILES    => q|Module-Release-Git-*| },
	);

sub arguments { \%WriteMakefile }

do_it() unless caller;
sub do_it {
	require File::Spec;
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			//
		"$MM 6.64";
	eval "use $MM_version";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
