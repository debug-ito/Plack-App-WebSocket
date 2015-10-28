package testlib::CustomServer;
use strict;
use warnings;
use Test::More;
use testlib::Util qw(set_timeout run_server);

use Plack::App::WebSocket;

sub run_tests {
    my ($server_runner) = @_;
    fail("customize handshake response");
    fail("user-defined exception from handshake process");
}
