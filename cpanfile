on "test" => sub {
    requires "Test::More";
    requires "Test::Requires";
    requires "AnyEvent";
    requires "Net::EmptyPort";
    requires "AnyEvent::WebSocket::Client" => "0.18";
};
