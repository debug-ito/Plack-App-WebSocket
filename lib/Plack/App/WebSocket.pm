package Plack::App::WebSocket;
use strict;
use warnings;

our $VERSION = '0.01';

1;

__END__

=pod

=head1 NAME

Plack::App::WebSocket - WebSocket server as a PSGI application

=head1 SYNOPSIS

    use Plack::App::WebSocket;
    use Plack::Builder;
    
    builder {
        mount "/websocket" => Plack::App::WebSocket->new(
            on_fallback => sub {
                my $env = shift;
                return [500, ["Content-Type" => "text/plain"], ["Error: " . $env->{"plack.app.websocket.error"}]];
            },
            on_establish => sub {
                my ($conn) = @_; ## Plack::App::WebSocket::Connection object
                $conn->on(
                    message => sub {
                        my ($conn, $data) = @_;
                        $conn->send($data);
                    },
                    finish => sub {
                        undef $conn;
                        warn "Bye!!\n";
                    },
                );
            }
        )->to_app;
        
        mount "/" => $your_app;
    };

=head1 DESCRIPTION

This module is a L<PSGI> application that creates an endpoint for WebSocket connections.

=head2 Prerequisites

To use L<Plack::App::WebSocket>, your L<PSGI> server must meet the following requirements.
(L<Twiggy> meets all of them, for example)

=over

=item *

C<psgi.streaming> environment is true.

=item *

C<psgi.nonblocking> environment is true, and the server supports L<AnyEvent>.

=item *

C<psgix.io> environment holds a valid raw IO socket object. See L<PSGI::Extensions>.

=back

=head1 CLASS METHODS

=head2 $app = Plack::App::WebSocket->new(%args)

The constructor.

Fields in C<%args> are:

=over

=item C<on_establish> => CODE (mandatory)

A subroutine reference that is called each time it establishes a new
WebSocket connection to a client.

The code is called like

    $code->($connection)

where C<$connection> is a L<Plack::App::WebSocket::Connection> object.
You can use the C<$connection> to communicate with the client.

Make sure you keep C<$connection> object as long as you need it.
If you lose reference to C<$connection> object and it's destroyed,
the WebSocket connection (and its underlying transport connection) is closed.

=item C<on_fallback> => PSGI_APP (optional)

A subroutine reference that is called when some error
happens while processing a request.

The code is a L<PSGI> app, so it's called like

    $psgi_response = $code->($psgi_env)

C<$psgi_response> is returned to the client instead of a valid
WebSocket handshake response.

When C<$code> is called, C<< $psgi_env->{"plack.app.websocket.error"} >> contains a string
that briefly describes the error (See below).

By default, it returns a simple non-200 HTTP response according to C<< $psgi_env->{"plack.app.websocket.error"} >>.
See below for detail.

=back

=head1 C<plack.app.websocket.error> ENVIRONMENT STRINGS

Below is the list of possible values of C<plack.app.websocket.error> L<PSGI> environment parameter.
It is set in the C<on_fallback> L<PSGI> applincation.

=over

=item C<"not supported by the PSGI server">

The L<PSGI> server does not support L<Plack::App::WebSocket>. See L</Prerequisites>.

By default, 500 "Internal Server Error" response is returned for this error.

=item C<"invalid request">

The client sent an invalid request.

By default, 400 "Bad Request" response is returned for this error.

=back

=head1 OBJECT METHODS

=head2 $psgi_response = $app->call($psgi_env)

Process the L<PSGI> environment (C<$psgi_env>) and returns a L<PSGI> response (C<$psgi_response>).

=head2 $app_code = $app->to_app

Return a L<PSGI> application subroutine reference.

=head1 SEE ALSO

=over

=item L<Amon2::Plugin::Web::WebSocket>

WebSocket implementation for L<Amon2> Web application framework.

=item L<Mojo::Transaction::WebSocket>

WebSocket implementation for L<Mojolicious> Web application framework.

=item L<PocketIO>

Socket.io implementation as a L<PSGI> application.

=back

=head1 AUTHOR

Toshio Ito, C<< <toshioito at cpan.org> >>

=head1 REPOSITORY

L<https://github.com/debug-ito/Plack-App-WebSocket>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Toshio Ito.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
