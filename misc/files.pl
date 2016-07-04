
sub load_file
{
    my($filename, $data) = @_;
    local($/, *IN);
    if (open(IN, $filename))
    {
        $data = <IN>;
        close IN;
    }
    $data;
}

sub save_file
{
  my ($fi, @data)= @_ ;
  local (*FH) ;
  open FH, '>', $fi or die "$fi: $!\n" ;

  my $data= join('', @data) ;
  my $rc= syswrite FH, $data ;
  die "write error $fi: $!" unless $rc = length($data) ;
}

sub save_fileln
{
  my ($fi, @data)= @_ ;
  local (*FH) ;
  open FH, '>', $fi or die "$fi: $!\n" ;

  my $data= join("\n", @data, undef) ;
  my $rc= syswrite FH, $data ;
  die "write error $fi: $!" unless $rc = length($data) ;
}

