#!/usr/bin/env -S perl -s

use 5.012 ;

use vars qw($go) ;

## dependencies baked into this script
my %modules = ( Dates => undef, Pluto => undef ) ;

sub cat
{
    my ($fi)= @_ ;  local $/ ;
    open FH, '<', $fi or return ;
    <FH>
}

for ( <*.jl> ) { @modules { grep !/Base/, map { /using ([A-Z]\w+)/gm } cat($_) }= undef ; }
 unless ( $go ) { say "]" ;  say "add $_" for ( sort keys %modules ) ; say "" ;  exit 0 }

say "using $_" for ( sort keys %modules ) ;
say "println( Dates.now() )" ;
say "Pluto.run()" ;

