#!/usr/bin/env -S perl -s

use 5.012 ;

use vars qw($go) ;

my %modules ;

sub cat
{
    my ($fi)= @_ ;  local $/ ;
    open FH, '<', $fi or return ;
    <FH>
}

for ( <*.jl> ) { @modules { map { /using ([A-Z]\w+)/gm } cat($_) }= undef ; }
 unless ( $go ) { say "add $_" for ( sort keys %modules ) }
 say "" unless $go ;
 say "using $_" for ( sort keys %modules ) ;

say "using Dates\nusing Pluto\nDates.now()" if $go ;
say "Pluto.run()" if $go ; 

