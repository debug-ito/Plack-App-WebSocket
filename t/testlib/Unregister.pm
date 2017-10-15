package testlib::Unregister;
use strict;
use warnings;
use Test::More;
use testlib::Util qw(set_timeout run_server);
use AnyEvent::WebSocket::Client;
use AnyEvent;

sub run_tests {
    my ($server_runner) = @_;
    set_timeout;
    {
        note("-- on method returns unregister coderef. it is ok to call unregister more than once.");
        my $app = Plack::App::WebSocket->new(
            on_establish => sub {
                my ($conn) = @_;
                my $unregister = $conn->on(message => sub {
                    my ($conn, $msg) = @_;
                    $conn->send("1: still registered: $msg");
                });
                $conn->on(message => sub {
                    my ($conn, $msg) = @_;
                    if($msg eq "unregister") {
                        $unregister->();
                        $conn->send("2: do unregister");
                    }else {
                        $conn->send("2: do nothing: $msg");
                    }
                });
                $conn->on(finish => sub {
                    undef $conn;
                });
            }
        );
        my ($port, $guard) = run_server($server_runner, $app);
        my $client = AnyEvent::WebSocket::Client->new;
        my @got;
        my $conn = $client->connect("ws://127.0.0.1:$port/")->recv;
        my $finish_cv = AnyEvent->condvar;
        $conn->on(each_message => sub {
            my ($c, $msg) = @_;
            push @got, $msg->body;
        });
        $conn->on(finish => sub { $finish_cv->send });
        $conn->send("hoge");
        $conn->send("unregister");
        $conn->send("hoge");
        $conn->send("unregister");
        $conn->close;
        $finish_cv->recv;
        is_deeply \@got, [
            "1: still registered: hoge", "2: do nothing: hoge",
            "1: still registered: unregister", "2: do unregister",
            "2: do nothing: hoge",
            "2: do unregister"
        ];
    }
    {
        note("-- message event gets unregister coderef");
        ok 0, "TODO";
    }
    {
        note("-- on method returns list of unregister coderefs, in the same order as the args");
        note("-- The unregister coderefs can be called in any order.");
        ok 0, "TODO";
    }
}

1;
