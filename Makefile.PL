# $Id: Makefile.PL,v 1.4 2004/07/04 17:04:17 comdog Exp $
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'	       => 'Module::Release::Git',
	'ABSTRACT'     => 'Use Git instead of CVS with Module::Release',
	'VERSION_FROM' => 'lib/Git.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@gmail.com>',
	
	'PREREQ_PM'    => { 
		'Test::More'      => '0',
		'Module::Release' => '0',
		
		},

	'PM'           => {
		'lib/Git.pm'         => '$(INST_LIBDIR)/Git.pm',
		},

	'MAN3PODS'     => {
		'lib/Git.pm' => '$(INST_MAN3DIR)/Module::Release::Git.3',
		},

	clean  => { FILES    => q|Module-Release-Git-*| },

	);
