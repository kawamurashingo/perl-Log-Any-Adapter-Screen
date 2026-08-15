#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Log::Any::Adapter::Screen;

sub adapter {
    return Log::Any::Adapter::Screen->new(@_);
}

{
    my $adapter = adapter(log_level => 'info');
    is($adapter->{min_level}, 'info', 'log_level sets min_level');
    ok($adapter->is_info, 'info is enabled');
    ok(!$adapter->is_debug, 'debug is disabled');
}

{
    my $adapter = adapter(min_level => 'error');
    is($adapter->{min_level}, 'error', 'min_level is honored');
    ok($adapter->is_error, 'error is enabled');
    ok(!$adapter->is_warning, 'warning is disabled');
}

{
    my $adapter = adapter(
        log_level => 'debug',
        min_level => 'critical',
    );
    is($adapter->{min_level}, 'critical', 'min_level takes precedence over log_level');
    ok($adapter->is_critical, 'critical is enabled');
    ok(!$adapter->is_error, 'error is disabled');
}

{
    my $adapter = adapter();
    is($adapter->{min_level}, 'warning', 'default level is warning');
    ok($adapter->is_warning, 'warning is enabled by default');
    ok(!$adapter->is_info, 'info is disabled by default');
}

done_testing;
