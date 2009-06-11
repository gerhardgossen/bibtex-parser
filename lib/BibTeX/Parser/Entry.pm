package BibTeX::Parser::Entry;

use warnings;
use strict;

use BibTeX::Parser::Author;

=head1 NAME

BibTeX::Entry - Contains a single entry of a BibTeX document.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.2';


=head1 SYNOPSIS

This class ist a wrapper for a single BibTeX entry. It is usually created
by a BibTeX::Parser.


    use BibTeX::Parser::Entry;

    my $entry = BibTeX::Parser::Entry->new($type, $key, $parse_ok, \%fields);
    
    if ($entry->parse_ok) {
	    my $type    = $entry->type;
	    my $key     = $enty->key;
	    print $entry->field("title");
	    my @authors = $entry->author;
	    my @editors = $entry->editor;

	    ...
    }

=head1 FUNCTIONS

=head2 new

Create new entry.

=cut

sub new {
	my ($class, $type, $key, $parse_ok, $fieldsref) = @_;

	my %fields = defined $fieldsref ? %$fieldsref : ();
	$fields{_type}     = uc($type);
	$fields{_key}      = $key;
	$fields{_parse_ok} = $parse_ok;
	return bless \%fields, $class;
}


=head2 parse_ok

If the entry was correctly parsed, this method returns a true value, false otherwise.

=cut

sub parse_ok {
	my $self = shift;
	if (@_) {
		$self->{_parse_ok} = shift;
	}
	$self->{_parse_ok};
}

=head2 error

Return the error message, if the entry could not be parsed or undef otherwise.

=cut

sub error {
	my $self = shift;
	if (@_) {
		$self->{_error} = shift;
		$self->parse_ok(0);
	}
	return $self->parse_ok ? undef : $self->{_error};
}

=head2 type

Get or set the type of the entry, eg. 'ARTICLE' or 'BOOK'. Return value is 
always uppercase.

=cut

sub type {
	if (scalar @_ == 1) {
		# get
		my $self = shift;
		return $self->{_type};
	} else {
		# set
		my ($self, $newval) = @_;
		$self->{_type} = uc($newval);
	}
}

=head2 key

Get or set the reference key of the entry.

=cut

sub key {
	if (scalar @_ == 1) {
		# get
		my $self = shift;
		return $self->{_key};
	} else {
		# set
		my ($self, $newval) = @_;
		$self->{_key} = $newval;
	}

}

=head2 field($name [, $value])

Get or set the contents of a field. The first parameter is the name of the
field, the second (optional) value is the new value.

=cut

sub field {
	if (scalar @_ == 2) {
		# get
		my ($self, $field) = @_;
		return $self->{ lc( $field ) };
	} else {
		my ($self, $key, $value) = @_;
		$self->{ lc( $key ) } = _sanitize_field($value);
	}

}

sub _handle_author_editor {
	my $type = shift;
	my $self = shift;
	if (@_) {
		if (@_ == 1) { #single string
			my @names = split /\s+and\s+/i, $_[0];
			$self->{"_$type"} = [map {new BibTeX::Parser::Author $_} @names];
			$self->field($type, join " and ", @{$self->{"_$type"}});
		} else {
			$self->{"_$type"} = [];
			foreach my $param (@_) {
				if (ref $param eq "BibTeX::Author") {
					push @{$self->{"_$type"}}, $param;
				} else {
					push @{$self->{"_$type"}}, new BibTeX::Parser::Author $param;
				}

				$self->field($type, join " and ", @{$self->{"_$type"}});
			}
		}
	} else {
		unless ( defined $self->{"_$type"} ) {
			my @names = split /\s+and\s+/i, $self->{$type} || "";
			$self->{"_$type"} = [map {new BibTeX::Parser::Author $_} @names];
		}
		return @{$self->{"_$type"}};
	}
}

=head2 author([@authors])

Get or set the authors. Returns an array of L<BibTeX::Author|BibTeX::Author> 
objects. The parameters can either be L<BibTeX::Author|BibTeX::Author> objects
or strings.

Note: You can also change the authors with $entry->field('author', $authors_string)

=cut

sub author {
	_handle_author_editor('author', @_);
}

=head2 editor([@editors])

Get or set the editors. Returns an array of L<BibTeX::Author|BibTeX::Author> 
objects. The parameters can either be L<BibTeX::Author|BibTeX::Author> objects
or strings.

Note: You can also change the authors with $entry->field('editor', $editors_string)

=cut

sub editor {
	_handle_author_editor('editor', @_);
}

=head2 fieldlist()

Returns a list of all the fields used in this entry.

=cut

sub fieldlist {
	my $self = shift;
	
	return grep {!/^_/} keys %$self;	
}

=head2 has($fieldname)

Returns a true value if this entry has a value for $fieldname.

=cut

sub has {
	my ($self, $field) = @_;

	return defined $self->{$field};
}

sub _sanitize_field {
	my $value = shift;	
	for ($value) {
		tr/\{\}//d;
		s/\\(?!=[ \\])//g;
		s/\\\\/\\/g;
	}
	return $value;
}

=head1 AUTHOR

Gerhard Gossen, C<< <gerhard.gossen at googlemail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-bibtex-entry at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=BibTeX-Parser>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BibTeX::Parser


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=BibTeX-Parser>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/BibTeX-Parser>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/BibTeX-Parser>

=item * Search CPAN

L<http://search.cpan.org/dist/BibTeX-Parser>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Gerhard Gossen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of BibTeX::Entry
