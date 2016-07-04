    # Select one row (one or more items)
 
my ($val1, $val2)= $dbh->selectrow_array("SELECT val1, val2 FROM vals") ;
 
    # Select a list
 
my $vals_= $dbh->selectcol_arrayref("SELECT val1 FROM vals") ;
my @vals= @{ $dbh-> selectcol_arrayref("SELECT val1 FROM vals") ;
 
    # Select key value pairs
 
my %keyvals= @{ $dbh-> selectcol_arrayref("SELECT val1, val2 FROM vals", { Columns => [1, 2] }) } ;
 
    # Select a list of hashes
 
my $vals_= $dbh-> selectall_arrayref("SELECT val1 as keyval, val2 as dataval FROM vals", { Slice=> {} } } ;
 
    # Long form with cursor
my $sth= $dbh-> prepare("SELECT x,y,z FROM vals WHERE x=?") ;
$sth-> exec("1") ;
  die "@{[$dbh->errstr]}\n" if $dbh->errstr ;

while ( my ($x,$y,$z)= $sth-> fetchrow_array ) {
	...
}
