package Complete::Env;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_env
                       complete_env_elem
                       complete_path_env_elem
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to environment variables',
};

$SPEC{complete_env} = {
    v => 1.1,
    summary => 'Complete from environment variables',
    description => <<'_',

On Windows, environment variable names are all converted to uppercase. You can
use case-insensitive option (`ci`) to match against original casing.

_
    args => {
        word     => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_env {
    require Complete::Util;

    my %args  = @_;
    my $word     = $args{word} // "";
    if ($word =~ /^\$/) {
        Complete::Util::complete_array_elem(
            word=>$word, array=>[map {"\$$_"} keys %ENV],
        );
    } else {
        Complete::Util::complete_array_elem(
            word=>$word, array=>[keys %ENV],
        );
    }
}

$SPEC{complete_env_elem} = {
    v => 1.1,
    summary => 'Complete from elements of an environment variable',
    description => <<'_',

An environment variable like PATH contains colon- (or, on Windows, semicolon-)
separated elements. This routine complete from the elements of such variable.

_
    args => {
        word     => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
        env      => {
            summary => 'Name of environment variable to use',
            schema  => 'str*',
            req => 1,
            pos => 1,
        },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_env_elem {
    require Complete::Util;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $env   = $args{env};
    my @elems;
    if ($^O eq 'MSWin32') {
        @elems = split /;/, ($ENV{$env} // '');
    } else {
        @elems = split /:/, ($ENV{$env} // '');
    }
    Complete::Util::complete_array_elem(
        word=>$word, array=>\@elems,
    );
}

$SPEC{complete_path_env_elem} = {
    v => 1.1,
    summary => 'Complete from elements of PATH environment variable',
    description => <<'_',

PATH environment variable contains colon- (or, on Windows, semicolon-) separated
elements. This routine complete from those elements.

_
    args => {
        word     => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_path_env_elem {
    my %args  = @_;
    complete_env_elem(word => $args{word}, env => 'PATH');
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
