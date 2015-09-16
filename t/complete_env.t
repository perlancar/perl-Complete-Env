#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;

use Complete::Env qw(complete_env);

{
    local %ENV = (APPLE=>1, AWAY=>2, DOCTOR=>3, AN=>4);
    test_complete(
        word      => 'A',
        result    => [qw(AN APPLE AWAY)],
        result_ci => [qw(AN APPLE AWAY)],
    );
}

subtest ci => sub {
    plan skip_all => 'Windows converts all env names to uppercase'
        if $^O =~ /Win32/;
    local %ENV = (APPLE=>1, AWAY=>2, DOCTOR=>3, an=>4);
    test_complete(
        word      => 'a',
        result    => [qw(an)],
        result_ci => [qw(an APPLE AWAY)],
    );
};

DONE_TESTING:
done_testing();

sub test_complete {
    my (%args) = @_;

    my $name = $args{name} // $args{word};
    my $res = complete_env(word=>$args{word}, ci=>0);
    is_deeply($res, $args{result}, "$name (result)")
        or diag explain($res);
    if ($args{result_ci}) {
        my $res_ci = complete_env(word=>$args{word}, ci=>1);
        is_deeply($res_ci, $args{result_ci}, "$name (result_ci)")
            or diag explain($res_ci);
    }
}
