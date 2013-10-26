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

=head1 CLASS METHODS

=head1 OBJECT METHODS

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


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Toshio Ito.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
