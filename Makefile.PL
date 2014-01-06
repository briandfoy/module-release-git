use ExtUtils::MakeMaker 6.64;

require 5.010;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'	       => 'Module::Release::Git',
	'ABSTRACT'     => 'Use Git instead of CVS with Module::Release',
	'VERSION_FROM' => 'lib/Module/Release/Git.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
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
