#!/usr/bin/perl -s

my @lst= ( '0' .. '9', 'A' .. 'Z', 'a' .. 'z' ) ;
my $xtra= '!#$%&()*+-;<=>?@^_`{|}~' ;

push @lst, $xtra =~ /(.)/g ;
my $str= join('', @lst) ;

print " ascii85= '$str' ;\n" ;

my @xcode= ( ( 0) x128) ;

	foreach ( map { ord($_) } @lst ) { $xcode[$_]= $i ++ }

print " dasci85[]= { ". join(', ', @xcode ). " } ; \n" ;


