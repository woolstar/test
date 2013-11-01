
my $k= log( 10) ;

	sub build_clean { system("rm testsort") ; }

	sub build_gcc
	{
		my ($lvl, $slow, $f)= @_ ;
		system("g++-4.8 -std=c++11 -O$lvl -DSLOW_TESTS=$slow testsort3.cpp -lm -o testsort" ) ;
		$f ||= 'f-' unless $slow ;
		return "${f}gcc$lvl"
	}

	sub build_clang
	{
		my ($lvl, $slow, $f)= @_ ;
		system("clang++ -std=c++11 -O$lvl -DSLOW_TESTS=$slow testsort3.cpp -lstdc++ -lm -o testsort" ) ;
		$f ||= 'f-' unless $slow ;
		return "${f}clang$lvl" ;
	}


sub	run_test
{
	my ($max, $buildr, $min)= @_ ;

	&build_clean ;
	my $grp= $buildr->() ;

	$min ||= 80 if $max > 90 ;
	$min ||= 60 ;

	print "GRP $grp\n" ;
	for ($min .. $max )
	{
		my $rng= int( exp( ( $_ / 20 ) * $k )) ;

		my $str= `./testsort $rng` ;
		my @n= $str =~ /(\d+\.?\d*)/g ;
		print join("\t", $rng, @n ). "\n" ;
	}
}

{
		## test the fast sorts up to 100MM
	run_test( 180, sub { build_gcc( 3, 0) } ) ;
	run_test( 180, sub { build_clang( 3, 0) } ) ;

		## test all sorts at different optimization levels and compilers

	run_test( 80, sub { build_gcc( 0, 1) } ) ;
	run_test( 95, sub { build_gcc( 2, 1) } ) ;
	run_test( 95, sub { build_gcc( 3, 1) } ) ;

	run_test( 80, sub { build_clang( 0, 1) } ) ;
	run_test( 95, sub { build_clang( 2, 1) } ) ;
	run_test( 95, sub { build_clang( 3, 1) } ) ;
}

