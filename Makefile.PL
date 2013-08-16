use ExtUtils::MakeMaker;

require 5.010;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'	       => 'Module::Release::Git',
	'ABSTRACT'     => 'Use Git instead of CVS with Module::Release',
	'VERSION_FROM' => 'lib/Module/Release/Git.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
	'BUILD_REQUIRES' => { 
		'Test::More'      => '0.98',
		'Module::Release' => '2.06',		
		},
		
	META_MERGE => {
		resources => {
			repository => 'https://github.com/briandfoy/module-release-git'
			}
		},

	META_MERGE => {
		resources => {
			Repository => 'https://github.com/briandfoy/module-release-git'
			}
		},

	clean  => { FILES    => q|Module-Release-Git-*| },
	);
