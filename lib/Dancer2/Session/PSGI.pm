package Dancer2::Session::PSGI;

# ABSTRACT: Dancer2 session storage via Plack::Middleware::Session

use Moo;
with 'Dancer2::Core::Role::SessionFactory';

our $VERSION = '0.008'; # VERSION

#-----------------------------------------#
# Alter SessionFactory attribute defaults
#-----------------------------------------#

has '+cookie_name' => ( default => 'plack_session' );

#-----------------------------------------#
# SessionFactory implementation methods
#-----------------------------------------#

# Get middleware session hash
sub _retrieve {
    shift->request->env->{'psgix.session'};
}

# Put data back/into middleware session hash
sub _flush {
    my ( $self, $id, $data ) = @_;
    $self->request->env->{'psgix.session'} = $data;
}

# Middleware handles cookie expiry
sub _destroy { return }

# Its the responsibility of Plack::Middleware::Session for
# tracking other sessions (we know nothing about them).
# So return an empty list.
sub _sessions { return [] }

#-----------------------------------------#
# Overridden methods from SessionFactory
#-----------------------------------------#

# Middleware sets the cookie.
sub set_cookie_header {
    my ( $self, %params ) = @_;

    my $session = $params{session};
    my $options = $self->request->env->{'psgix.session.options'};

    if ( my $expires = $session->expires ) {
        if ( $session->expires < time ) { # Cookie has expired.
            $options->{expire} = 1;
        }
        else { # Pass upstream the cookie expire time
            $options->{expires} = $expires;
        }
    }
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Dancer2::Session::PSGI - Dancer2 session storage via Plack::Middleware::Session

=head1 VERSION

version 0.008

=head1 SYNOPSIS

    use Dancer2;

    setting( session => 'PSGI' );

    get '/' => sub {
        my $count = session("counter");
        session "counter" => ++$count;
        return "This is my ${count}th dance";
    };

=head1 DESCRIPTION

This module implements implements a session factory for Dancer2 that uses
L<Plack::Middleware::Session> for session management.

=for Pod::Coverage method_names_here
set_cookie_header

=head1 CONFIGURATION

The setting B<session> should be set to C<PSGI> in order to use this session
engine in a Dancer2 application.

The default cookie name is C<plack_session>. Refer to
L<Dancer2::Config/Session_engine> if you need to modify this.

=head1 ACKNOWLEDGEMENTS

The methods required by L<Dancer2::Core::Role::SessionFactory> were
heavily based on L<Dancer2::Session::Cookie> by David Golden.

=head1 AUTHOR

Russell Jenkins <russellj@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Russell Jenkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
