#!perl -w
use strict;

# $Id: shellquote.t,v 1.1 1997-03-14 12:10:04-05 roderick Exp $
#
# Copyright (c) 1997 Roderick Schertler.  All rights reserved.  This
# program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

BEGIN {
    $| = 1;
    print "1..14\n";
}

use String::ShellQuote;

sub ok {
    my ($n, $result, @info) = @_;
    if ($result) {
    	print "ok $n\n";
    }
    else {
    	print "not ok $n\n";
	print "# ", @info, "\n" if @info;
    }
}

my $testsub;
sub test {
    my ($n, $want, @args) = @_;
    my $got = &$testsub(@args);
    ok $n, $got eq $want, qq[wanted "$want", got "$got"];
}

$testsub = \&shell_quote;
test 1, '';
test 2, 'foo',			'foo';
test 3, 'foo bar',		qw(foo bar);
test 4, "'foo*'",		'foo*';
test 5, "'foo bar'",		'foo bar';
test 6, "'foo'\\''bar'",	"foo'bar";
test 7, "''\\''foo'",		"'foo";
test 8, "foo 'bar*'",		qw(foo bar*);
test 9, "'foo'\\''foo' bar 'baz'\\'''", qw(foo'foo bar baz');

$testsub = \&shell_comment_quote;
test 10, '';
test 11, 'foo',			'foo';
test 12, "foo\n#bar",		"foo\nbar";
test 13, "foo\n#bar\n#baz",	"foo\nbar\nbaz";

eval { shell_comment_quote 'foo', 'bar' };
ok 14, $@ =~ /^\QToo many arguments to shell_comment_quote (got 2 expected 1)/,
    	$@;
