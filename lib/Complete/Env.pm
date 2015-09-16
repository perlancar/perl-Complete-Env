package Complete::Env;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Setting;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_env
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
        word  => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
        ci    => { schema=>['bool'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_env {
    require Complete::Util;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;
    if ($word =~ /^\$/) {
        Complete::Util::complete_array_elem(
            word=>$word, array=>[map {"\$$_"} keys %ENV], ci=>$ci);
    } else {
        Complete::Util::complete_array_elem(
            word=>$word, array=>[keys %ENV], ci=>$ci);
    }
}
1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
