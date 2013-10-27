package testlib::Echo;
use strict;
use warnings;
use Test::More;
use testlib::Util qw(set_timeout);

use Net::EmptyPort qw(empty_port);  ## should they be in Test::Requires?
use AnyEvent::WebSocket::Client;
use AnyEvent;

use Plack::App::WebSocket;

sub run_tests {
    my ($server_runner) = @_;
    set_timeout;
    my $app = Plack::App::WebSocket->new(on_establish => sub {
        my $conn = shift;
        note("server established.");
        $conn->on(message => sub {
            my ($conn, $msg) = @_;
            note("server received message.");
            $conn->send($msg);
        });
        $conn->on(finish => sub {
            note("server finished.");
            undef $conn;
        });
        $conn->send("echo started");
    });
    my $port = empty_port();
    my $server_guard = $server_runner->($port, $app->to_app);

    my @test_data = (
        {label => "8 bytes", data => "AAAABBBB"},
        {label => "0 bytes", data => ""},
        {label => "zero", data => 0},
        {label => "256 bytes", data => "A" x 256},
        {label => "64 ki bytes", data => "A" x (64 * 1024)},
    );

    my $client = AnyEvent::WebSocket::Client->new;
    note("--- create new connection for each test");
    foreach my $test (@test_data) {
        my $conn = $client->connect("ws://127.0.0.1:$port/")->recv;
        note("client established.");
        my $cv_fin = AnyEvent->condvar;
        my @messages = ();
        $conn->on(each_message => sub {
            note("client received message.");
            push(@messages, $_[1]->body);
        });
        $conn->on(finish => sub {
            note("client finished.");
            $cv_fin->send;
        });
        $conn->send($test->{data});
        $conn->close;
        $cv_fin->recv;
        is_deeply(\@messages, ["echo started", $test->{data}], "new conn: $test->{label} OK");
    }

    {
        note("--- all tests by single connection");
        my $conn = $client->connect("ws://127.0.0.1:$port/")->recv;
        my @exp_message = ({label => "sent by sever", exp => "echo started"});
        my $cv_fin = AnyEvent->condvar;
        $conn->on(each_message => sub {
            my ($conn, $msg) = @_;
            my $exp = shift @exp_message;
            is($msg->body, $exp->{exp}, "$exp->{label}: server message OK");
        });
        $conn->on(finish => sub { $cv_fin->send });
        foreach my $test (@test_data) {
            push(@exp_message, {label => $test->{label}, exp => $test->{data}});
            $conn->send($test->{data});
        }
        $conn->close;
        $cv_fin->recv;
        is(scalar(@exp_message), 0, "expected messages are all received.");
    }
    
    
    done_testing;
}

1;
