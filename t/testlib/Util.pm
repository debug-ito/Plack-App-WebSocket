package testlib::Util;
use strict;
use warnings;
use AnyEvent;
use Exporter qw(import);
use Test::More;

our @EXPORT_OK = qw(set_timeout);

my $TIMEOUT_DEFAULT_SEC = 30;

sub set_timeout {
    my $w; $w = AnyEvent->timer(after => $TIMEOUT_DEFAULT_SEC, cb => sub {
        undef $w;
        fail("Timeout");
        exit 2;
    });
}

1;



