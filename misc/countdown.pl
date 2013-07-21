#!/usr/bin/perl -s

	my $rotator= "|/-\\|" ;
	my $subrotator= ".,;:" ;

	use 5.012 ;

sub parsetime
{
	my $s= shift ;
	my $t ;

	for ( split /:/, $s ) { $t *= 60 ;  $t += $_ }
	$t
}

sub countdown
{
	my ($t, $td) ;
	my ( $slabel, $sbars) ;
	$slabel= "$_ -" ;
	$|= 1 ;

	$t= $td= parsetime( $_) ;
	print "$slabel " ;

	while ( $t > 0 )
	{
		for ( $t)
		{
			when ( $_ > 600 )
			{
				print " " ;
				for ( 0..4 ) { sleep(60) ;  print "\b" . substr($rotator, $_, 1) }
				$t -= 300 ;
				$sbars .= "|" ;
			}
			when ( $_ > 60 )
			{
				print " " ;
				for ( 0..3 ) { sleep(15) ;  print "\b" . substr($subrotator, $_, 1) }
				$t -= 60 ;
				$sbars .= ':' ;
			}
			default
			{
				$td= 6 ;  if ( $td > $t ) { $td= $t ; }
				sleep($td) ;  $t -= $td ;
				print "." ;
			}
		}

		print "\b\b  \r$slabel ($t) $sbars" if ( $t > 60) ;
	}

	print "\n" ;
}

{
	for ( @ARGV )
	{
		countdown( $_ ) ;

	}
}

