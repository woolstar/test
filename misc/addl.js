// server side js - node

var readline = require('readline'),
	rl = readline.createInterface( process.stdin, process.stdout ) ;

var isum= 0 ;

rl.on('line', function(str) {
	str.trim() ;
	if ( str.match(/([\d\.\-\+]+)/) ) { isum += + str ; }
		else { console.log("\t" + isum.toFixed(2)) ; }
	}).on('close', function() { console.log("  ====\t" + isum.toFixed(2)) ;  process.exit( 0) ; } ) ;

