use strict;
use warnings;
use Test::More;
use FindBin;
use lib ($FindBin::RealBin);
use testlib::Echo;
use Test::Requires {
    "Twiggy::Server" => "0"
};
use Twiggy::Server;

testlib::Echo::run_tests sub {
    my ($port, $app) = @_;
    my $server = Twiggy::Server->new(
        host => "127.0.0.1", port => $port
    );
    $server->register_service($app);
    return $server;
};

