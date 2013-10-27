package Plack::App::WebSocket::Connection;
use strict;
use warnings;

our $VERSION = "0.01";

1;

__END__

=pod

=head1 NAME

Plack::App::WebSocket::Connection - WebSocket connection for Plack::App::WebSocket

=head1 SYNOPSIS

    my $app = Plack::App::WebSocket->new(on_establish => sub {
        my $connection = shift;
        $connection->on(message => sub {
            my ($connection, $message) = @_;
            warn "Received: $message\n";
            if($message eq "quit") {
                $connection->close();
            }
        });
        $connection->on(finish => sub {
            warn "Closed\n";
            undef $connection;
        });
        $connection->send("Message to the client");
    });

=head1 DESCRIPTION

L<Plack::App::WebSocket::Connection> is an object representing a
WebSocket connection to a client. It is created by
L<Plack::App::WebSocket> internally and given to you in
C<on_establish> callback function.

=head1 OBJECT METHODS

=head2 $connection->on($event => $handler)

Register a callback function to a particular event.
You can register multiple callbacks to the same event.

C<$event> is a string and C<$handler> is a subroutine reference.

Possible value for C<$event> is:

=over

=item C<"message">

    $handler->($connection, $message)

C<$handler> is called for each message received via the C<$connection>.
Argument C<$connection> is the L<Plack::App::WebSocket::Connection> object,
and C<$message> is a non-decoded byte string of the received message.

=item C<"finish">

    $handler->($connection)

C<$handler> is called when the C<$connection> is closed.
Argument C<$connection> is the L<Plack::App::WebSocket::Connection> object.

=back

=head2 $connection->send($message)

Send a message via C<$connection>.

C<$message> should be a UTF-8 encoded string.

=head2 $connection->close()

Close the WebSocket C<$connection>.

=head1 AUTHOR

Toshio Ito, C<< <toshioito at cpan.org> >>


=cut
