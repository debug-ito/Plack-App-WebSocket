
requires "parent";
requires "Carp";
requires "Plack::Component";
requires "Plack::Response";
requires "AnyEvent";
requires "AnyEvent::WebSocket::Server";
requires "Try::Tiny";
requires "Scalar::Util";
requires "Devel::GlobalDestruction";

on "test" => sub {
    requires "Test::More";
    requires "Test::Requires";
    requires "AnyEvent";
    requires "Net::EmptyPort";
    requires "AnyEvent::WebSocket::Client" => "0.18";
};
