

var _ = require('underscore')._ ;
var ex = require('express') ;

var	app= ex() ;
var web ;

var	wait= function() { console.log("closed.") }

_.each(['ab', 'cd', 'ef'], function(x) { console.log("output _ " + x) ; }) ;

app.get('/:path', function(req, res) {
				res.send("Hello "+ req.path + ".<p>At " + (+ new Date())) ;
		} ) ;

app.get('/done/:x', function(req, res) {
				res.send("Shutting down.") ;
				res.end() ;
				web.close( wait) ;
				console.log("Done") ;
		} ) ;

web= app.listen(8070) ;

