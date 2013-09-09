#!/usr/bin/perl -s

use common::date ;

my ($start, $count)= @ARGV ;
my $jday= db_to_j($start) ;

die "usage: tmplrange <date> <count>" unless $start && $jday && $count ;

while ( $count -- )
{
	my ($y,$m,$d)= j_to_date( $jday) ;
	$jday += 7 ;

	$y %= 100 ;

	my $str= sprintf("%02d%02d%02d", $m, $d, $y) ;
	print STDERR "$str\n" ;

	print "wget http://pages.nxtbook.com/nxtbooks/cmp/eetimes$str/offline/cmp_eetimes$str\_pdf.zip\n"
}

