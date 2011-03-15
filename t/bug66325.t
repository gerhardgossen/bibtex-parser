#!/usr/bin/perl -w

use Test::More;

use BibTeX::Parser;
use IO::File;

{
    my $fh = new IO::File "t/bibs/endnote.txt", "r" ;

    if (defined $fh) {
	    my $parser = new BibTeX::Parser $fh;

	    while (my $entry = $parser->next) {
		    $count++;
		    diag $entry->error;
		    isa_ok($entry, "BibTeX::Parser::Entry");
		    ok($entry->parse_ok, "parse_ok");
		    is($entry->key, undef, "key");
		    is($entry->type, "ARTICLE", "type");
		    is($entry->field("year"), 1999, "field");
		    is($entry->field("volume"), 59, "first field");
	    }
    }
}

done_testing;
