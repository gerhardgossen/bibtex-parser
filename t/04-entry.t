#!/usr/bin/perl -w

use Test::More tests => 14;

use BibTeX::Parser::Entry;


my $entry = new BibTeX::Parser::Entry("type", "key", 1, {title => "title"});

isa_ok($entry, "BibTeX::Parser::Entry");

is($entry->type, "TYPE", "Entry::type get");

$entry->type("newtype");

is($entry->type, "NEWTYPE", "Entry::type set");

is($entry->key, "key", "Entry::key get");

$entry->key("newkey");

is($entry->key, "newkey", "Entry::key set");

is($entry->field("title"), "title", "Entry::field with new");

$entry->field("title" => "newtitle");

is($entry->field("title"), "newtitle", "Entry::field overwrite");

$entry->field("year" => 2008);

is($entry->field("year"), 2008, "Entry::field set");

is($entry->field("pages"), undef, "Entry::field undef on unknown value");

is($entry->fieldlist, 2, "size of fieldlist");

ok($entry->has("title"), "Entry::has true on known value");

ok($entry->has("year"), "Entry::has true on known value");

ok( ! $entry->has("pages"), "Entry::has false on unknown value");

# check the author splitting code.
my @authors = BibTeX::Parser::Entry::_split_author_field("{Securities and Exchange Commission (SEC)} and {Barnes' and Noble} and Th{\\'{e}}venaz, Jacques");
is_deeply(\@authors, [
  "{Securities and Exchange Commission (SEC)}",
  "{Barnes' and Noble}",
  "Th{\\'{e}}venaz, Jacques"
], "Entry::_split_author_field returns correct number of authors");
