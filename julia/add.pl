#!/usr/bin/env perl

use 5.012 ;

my %modules ;

sub cat
{
    my ($fi)= @_ ;  local $/ ;
    open FH, '<', $fi or return ;
    <FH>
}

for ( <*.jl> ) { @modules { map { /using ([A-Z]\w+)/gm } cat($_) }= undef ; }
 say "add $_" for ( sort keys %modules ) ;
 say "" ;
 say "using $_" for ( sort keys %modules )

