
	/****/

var _ = require('underscore')._ ;
var sq3 = require('sqlite3') ;

var db= new sq3.Database('data/test.sqlite3') ;

function lookup(aval, afinal)
{
	var op = { final : afinal } ;

	function query()
		{ db.all("SELECT id FROM entry WHERE val = ?", [ aval ], results) ; }
	function results(aerr, arows)
	{
		if ( aerr)
			{ if ( afinal.err ) { afinal.err(aerr) ; } else { afinal() ; } }

		if ( arows.length ) { afinal( arows) ; }
			else { db.run("INSERT INTO entry (val) VALUES (?)", [aval], create) ; }
	}
	function create(aerr, arows)
	{
		if ( aerr )
			{ if ( afinal.err ) { afinal.err(aerr) ; } else { afinal() ; } }

		console.log("create: " + this.lastID) ;
		afinal( [this.lastID ] ) ;
	}

	query( aval) ;
}

function show( results)
{
	var i, n ;
	n= results.length ;
	for ( i= n; ( i -- ) ; ) { console.log("V " + JSON.stringify( results[i])) }
}

db.serialize( function()
	{
		db.run("CREATE TABLE IF NOT EXISTS entry ( id INTEGER PRIMARY KEY AUTOINCREMENT, val )") ;
		db.run("CREATE INDEX IF NOT EXISTS kentry ON entry ( val )") ;

		db.parallelize( function()
			{
				lookup( 20, show) ;
				lookup( 21, show) ;
				lookup( 24, show) ;
			} ) ;

		setTimeout( function() {
			db.parallelize( function()
				{
					lookup( 22, show) ;
					lookup( 20, show) ;
					lookup( 25, show) ;
				} )
			}, 100) ;

		setTimeout( function() {
			db.parallelize( function()
				{
					lookup( 21, show) ;
					lookup( 22, show) ;
					lookup( 28, show) ;
				} )
			}, 300) ;
	} ) ;

