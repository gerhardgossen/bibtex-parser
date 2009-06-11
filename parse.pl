#!/usr/bin/perl 

use strict;
use warnings;

use BibTeX::Parser;
use IO::File;

my $file = shift or die "Usage: $0 filename\n";

my $fh = new IO::File $file;

my $parser = new BibTeX::Parser $fh;

while (my $entry = $parser->next) {
	print "Title: " . $entry->field("title") . "\n";
}

