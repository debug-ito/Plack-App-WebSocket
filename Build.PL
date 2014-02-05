use strict;
use warnings;
use Module::Build::Pluggable (
    'CPANfile'
);

my $builder = Module::Build::Pluggable->new(
    module_name         => 'Plack::App::WebSocket',
    license             => 'perl',
    dist_author         => q{Toshio Ito <toshioito@cpan.org>},
    dist_version_from   => 'lib/Plack/App/WebSocket.pm',
    add_to_cleanup      => [ 'Plack-App-WebSocket-*' ],
    recursive_test_files => 1,
    no_index => {
        directory => ["t", "xt", "eg", "inc"],
        file => ['README.pod'],
    },
    meta_add => {
        resources => {
            bugtracker => 'https://github.com/debug-ito/Plack-App-WebSocket/issues',
            repository => 'git://github.com/debug-ito/Plack-App-WebSocket.git'
        }
    }

);

$builder->create_build_script();
