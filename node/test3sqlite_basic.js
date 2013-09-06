
var _ = require('underscore')._ ;
var sq3 = require('sqlite3') ;

var db= new sq3.Database('data/test.sqlite3') ;
var setup= 0 ;

function	create_done()
{
	++ setup ;
	console.log("step " + setup) ;

	if ( 2 == setup ) {
		db.run("INSERT INTO log (time, msg) VALUES (datetime('now'), ?)", [ 'test startup' ]) ;
	}
}

	db.run("CREATE TABLE IF NOT EXISTS list ( id PRIMARY KEY, val )", create_done) ;
	db.run("CREATE TABLE IF NOT EXISTS log ( id INTEGER PRIMARY KEY AUTOINCREMENT, time, msg )", create_done) ;

// _.each(['ab', 'cd', 'ef'], function(x) { console.log("output _ " + x) ; }) ;

