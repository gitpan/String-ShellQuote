#!perl -w
use strict;

# $Id: test.t,v 1.3 2005/02/10 01:48:17 roderick Exp $
#
# Copyright (c) 1997 Roderick Schertler.  All rights reserved.  This
# program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

BEGIN {
    $| = 1;
    print "1..27\n";
}

use String::ShellQuote;

my $test_num = 0;
sub ok {
    my ($result, @info) = @_;
    $test_num++;
    if ($result) {
    	print "ok $test_num\n";
    }
    else {
    	print "not ok $test_num\n";
	print "# ", @info, "\n" if @info;
    }
}

my $testsub;
sub test {
    my ($want, @args) = @_;
    my $got = eval { &$testsub(@args) };
    if ($@) {
	chomp $@;
	$@ =~ s/ at \S+ line \d+\.?\z//;
	$got = "die: $@";
    }
    my $from_line = (caller)[2];
    ok $got eq $want,
	qq{line $from_line\n# wanted [$want]\n# got    [$got]};
}

$testsub = \&shell_quote;
test '';
test q{''},			'';
test q{''},			undef;
test q{foo},			qw(foo);
test q{foo bar},		qw(foo bar);
test q{'foo*'},			qw(foo*);
test q{'foo bar'},		 q{foo bar};
test q{'foo'\''bar'},		qw(foo'bar);
test q{\''foo'},		qw('foo);
test q{foo 'bar*'},		qw(foo bar*);
test q{'foo'\''foo' bar 'baz'\'}, qw(foo'foo bar baz');
test q{'\'},			qw(\\);
test q{\'},			qw(');
test q{'\'\'},			qw(\');
test q{'a'"''"'b'},		qw(a''b);
test q{azAZ09_!%+,-./:@^},	 q{azAZ09_!%+,-./:@^};
test
    "die: shell_quote(): No way to quote string containing null (\\000) bytes",
    "t\x00";

$testsub = \&shell_quote_best_effort;
test '';
test q{''},			'';
test q{''},			undef;
test q{'foo*'},			'foo*';
test q{'foo*' asdf},		'foo*', "as\x00df";

$testsub = \&shell_comment_quote;
test '';
test qq{foo},			qq{foo};
test qq{foo\n#bar},		qq{foo\nbar};
test qq{foo\n#bar\n#baz},	qq{foo\nbar\nbaz};
test "die: Too many arguments to shell_comment_quote (got 2 expected 1)",
	    'foo', 'bar';
