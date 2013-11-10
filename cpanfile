
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
    requires "AnyEvent::WebSocket::Client" => "0.20";
    requires "Scalar::Util";
    requires "Plack::Util";
};

on 'configure' => sub {
    requires 'Module::Build::Pluggable',           '0.09';
    requires 'Module::Build::Pluggable::CPANfile', '0.02';
};
