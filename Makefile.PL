# $Id: Makefile.PL,v 1.4 2004/07/04 17:04:17 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile(
	'NAME'	       => 'Module::Release::Git',
	'VERSION_FROM' => 'lib/Git.pm',
	'LICENSE'      => 'perl',
	
	'PREREQ_PM'    => { 
		'Test::More' => '0',
		},

	'PM'           => {
		'lib/Git.pm'         => '$(INST_LIBDIR)/Git.pm',
		},

	'MAN3PODS'     => {
		'lib/Git.pm' => '$(INST_MAN3DIR)/Module::Release::Git.3',
		},

	clean  => { FILES    => q|Module-Release-Git-*| },

	);
