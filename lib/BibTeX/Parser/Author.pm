package BibTeX::Parser::Author;

use warnings;
use strict;

use overload
	'""' => \&to_string;

=head1 NAME

BibTeX::Author - Contains a single author for a BibTeX document.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.21';


=head1 SYNOPSIS

This class ist a wrapper for a single BibTeX author. It is usually created
by a BibTeX::Parser.


    use BibTeX::Parser::Author;

    my $entry = BibTeX::Parser::Author->new($full_name);
    
    my $firstname = $author->first;
    my $von	  = $author->von;
    my $last      = $author->last;
    my $jr	  = $author->jr;

    # or ...
    
    my ($first, $von, $last, $jr) = BibTeX::Author->split($fullname);


=head1 FUNCTIONS

=head2 new

Create new author object. Expects full name as parameter.

=cut

sub new {
	my $class = shift;

	if (@_) {
		my $self = [ $class->split(@_) ];
		return bless $self, $class;
	} else {
		return bless [], $class;
	}
}

sub _get_or_set_field {
	my ($self, $field, $value) = @_;
	if (defined $value) {
		$self->[$field] = $value;
	} else {
		return $self->[$field];
	}
}

=head2 first

Set or get first name(s).

=cut

sub first {
	shift->_get_or_set_field(0, @_);
}

=head2 von

Set or get 'von' part of name.

=cut

sub von {
	shift->_get_or_set_field(1, @_);
}

=head2 last

Set or get last name(s).

=cut

sub last {
	shift->_get_or_set_field(2, @_);
}

=head2 jr

Set or get 'jr' part of name.

=cut

sub jr {
	shift->_get_or_set_field(3, @_);
}

=head2 split

Split name into (firstname, von part, last name, jr part). Returns array
with four strings, some of them possibliy empty.

=cut

sub split {
	my ($self_or_class, $name) = @_;

	# remove whitespace at start and end of string
	$name =~ s/^\s*(.*)\s*$/$1/s;

	my @parts = split /\s*,\s*/, $name;

	if (@parts == 0) {
		return (undef, undef, undef, undef);
	} elsif (@parts == 1) {	# name without comma
		if ( $name =~ /\b[[:lower:]]/) { # name has von part or has only lowercase names
			my @name_parts = split /\s+/, $parts[0];

			my $first;
			while (@name_parts && ucfirst($name_parts[0]) eq $name_parts[0] ) {
				$first .= $first ? ' ' . shift @name_parts : shift @name_parts;
			}

			my $von;
			# von part are lowercase words
			while ( @name_parts && lc($name_parts[0]) eq $name_parts[0] ) {
				$von .= $von ? ' ' . shift @name_parts : shift @name_parts;
			}

			if (@name_parts) {
				return ($first, $von, join(" ", @name_parts), undef);
			} else {
				return (undef, undef, $name, undef);
			}
		} else {
			if ($name =~ /^((.*)\s+)?\b([\w\-']+)$/) {;
				return ($2, undef, $3, undef);
			}
		}

	} elsif (@parts == 2) {
		my @von_last_parts = split /\s+/, $parts[0];
		my $von;
		# von part are lowercase words
		while ( lc($von_last_parts[0]) eq $von_last_parts[0] ) {
			$von .= $von ? ' ' . shift @von_last_parts : shift @von_last_parts;
		}
		return ($parts[1], $von, join(" ", @von_last_parts), undef);
	} else {
		my @von_last_parts = split /\s+/, $parts[0];
		my $von;
		# von part are lowercase words
		while ( lc($von_last_parts[0]) eq $von_last_parts[0] ) {
			$von .= $von ? ' ' . shift @von_last_parts : shift @von_last_parts;
		}
		return ($parts[2], $von, join(" ", @von_last_parts), $parts[1]);
	}

}

=head2 to_string

Return string representation of the name.

=cut

sub to_string {
	my $self = shift;

	if ($self->jr) {
		return $self->von . " " . $self->last . ", " . $self->jr . ", " . $self->first;
	} else {
		return ($self->von ? $self->von . " " : '') . $self->last . ($self->first ? ", " . $self->first : '');
	}
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
