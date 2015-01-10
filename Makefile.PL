require 5.010;
use strict;
use warnings;

use File::Spec::Functions qw(catfile);

my $module    = 'Module::Release::Git';
( my $dist = $module ) =~ s/::/-/g;

my $github    = 'https://github.com/briandfoy/module-release-git';
my $main_file = catfile( 'lib', split /::/, "$module.pm" );

my %WriteMakefile = (
	'NAME'	        => $module,
	'ABSTRACT_FROM' => $main_file,
	'VERSION_FROM'  => $main_file,
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',
	
	'CONFIGURE_REQUIRES' => { 
		'ExtUtils::MakeMaker'   => '6.64',
		'File::Spec::Functions' => '0',
		},

	'BUILD_REQUIRES' => { 
		},

	'TEST_REQUIRES' => { 
		'Test::More'      => '0.98',
		},

	'PREREQ_PM' => {
		'Module::Release' => '2.06',	
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		keywords => ['workflow', 'module', 'distribution', 
			'pause', 'automation', 'testing', 'git' ],
		resources => {
			repository => {
				type => 'git',
				url  => "$github.git",
				web  => $github,
				},
			bugtraker => {
				web    => "$github/issues",
				},
			homepage => $github,
			},
		},

	clean => { FILES => "$dist-*" },
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
	eval "use $MM_version; 1" or die "Could not load $MM_version: $@";
	eval "use Test::Manifest 1.21" 
		if -e File::Spec->catfile( qw(t test_manifest) );
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
