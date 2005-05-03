# $Id: Makefile.PL,v 1.4 2005/05/03 10:44:03 roderick Exp $
#
# Copyright (c) 1997 Roderick Schertler.  All rights reserved.  This
# program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'String::ShellQuote',
    VERSION_FROM	=> 'ShellQuote.pm',
    EXE_FILES		=> ['shell-quote'],
    dist		=> {
    	PREOP		=> '$(MAKE) ci',
	CI		=> 'cvs commit',
	RCS_LABEL	=> 'cvs tag v$(VERSION_SYM)',
    },
    test		=> { TESTS => 'test.t' },
);
